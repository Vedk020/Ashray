import 'dart:async';
import 'package:ashray/database_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SyncStatus { synced, syncing, offline, error }

class SyncService {
  SyncService._privateConstructor();
  static final SyncService instance = SyncService._privateConstructor();

  final dbHelper = DatabaseHelper.instance;
  final _firestore = FirebaseFirestore.instance;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final ValueNotifier<SyncStatus> syncStatus = ValueNotifier(SyncStatus.synced);

  final _tablesToSync = [
    'families',
    'members',
    'medical_history',
    'maternal_care',
    'child_care',
    'womens_health',
    'visits',
    'vaccinations',
    'tasks'
  ];

  Future<void> initialize() async {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    final results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi)) {
      if (syncStatus.value == SyncStatus.offline ||
          syncStatus.value == SyncStatus.error) {
        startSync();
      }
    } else {
      syncStatus.value = SyncStatus.offline;
    }
  }

  Future<void> startSync() async {
    if (syncStatus.value == SyncStatus.syncing) {
      debugPrint("SYNC SKIPPED: A sync is already in progress.");
      return;
    }

    syncStatus.value = SyncStatus.syncing;
    debugPrint("SYNC STARTED: Starting two-way background sync...");

    try {
      await _pushChanges();
      await _pullChanges();

      // As per the workflow, trigger the report generation after a sync.
      await _triggerPdfReport();

      debugPrint("SYNC SUCCESS: Background sync completed successfully.");
      syncStatus.value = SyncStatus.synced;
    } catch (e) {
      debugPrint(
          "SYNC FAILED: An error occurred during synchronization. Error: $e");
      syncStatus.value = SyncStatus.error;
    }
  }

  Future<void> _pushChanges() async {
    debugPrint("--- STEP 1: PUSHING local changes to server ---");
    for (final table in _tablesToSync) {
      final unsyncedRows = await dbHelper.getUnsyncedData(table);
      if (unsyncedRows.isEmpty) continue;

      debugPrint(
          "'$table': Found ${unsyncedRows.length} local changes to push.");
      for (final row in unsyncedRows) {
        final localId = row['id'];
        final dataToPush = Map<String, dynamic>.from(row)
          ..remove('id')
          ..remove('synced')
          ..['timestamp'] = FieldValue.serverTimestamp();

        // Resolve foreign keys
        if (dataToPush.containsKey('familyId') &&
            dataToPush['familyId'] != null) {
          final family = await dbHelper.getFamily(dataToPush['familyId']);
          dataToPush['familyServerId'] = family?['serverId'];
          dataToPush.remove('familyId');
        }
        if (dataToPush.containsKey('memberId') &&
            dataToPush['memberId'] != null) {
          final member = await dbHelper.getMember(dataToPush['memberId']);
          dataToPush['memberServerId'] = member?['serverId'];
          dataToPush.remove('memberId');
        }

        try {
          // Check if there's already a document with this serverId to update it
          if (row['serverId'] != null) {
            final docQuery = await _firestore
                .collection(table)
                .where('serverId', isEqualTo: row['serverId'])
                .limit(1)
                .get();
            if (docQuery.docs.isNotEmpty) {
              await docQuery.docs.first.reference.update(dataToPush);
              await dbHelper.markAsSynced(table, localId, row['serverId']);
              debugPrint(
                  "'$table': Successfully UPDATED row $localId. Server ID: ${row['serverId']}");
            }
          } else {
            final docRef = await _firestore.collection(table).add(dataToPush);
            await dbHelper.markAsSynced(table, localId, docRef.id);
            debugPrint(
                "'$table': Successfully CREATED row $localId. Server ID: ${docRef.id}");
          }
        } catch (e) {
          debugPrint("'$table': FAILED to push row $localId. Error: $e");
        }
      }
    }
    debugPrint("--- PUSH step finished. ---");
  }

  Future<void> _pullChanges() async {
    debugPrint("--- STEP 2: PULLING remote changes from server ---");
    final prefs = await SharedPreferences.getInstance();

    final serverTimestampDoc = _firestore.collection('meta').doc('timestamp');
    await serverTimestampDoc.set({'value': FieldValue.serverTimestamp()});
    final snapshot = await serverTimestampDoc.get();

    if (!snapshot.exists ||
        snapshot.data() == null ||
        snapshot.data()!['value'] == null) {
      debugPrint("Could not retrieve current server timestamp. Aborting pull.");
      return;
    }
    final nowTimestamp = snapshot.get('value') as Timestamp;
    final lastSyncTimestamp = prefs.getInt('lastSyncTimestamp') ?? 0;

    for (final table in _tablesToSync) {
      try {
        final querySnapshot = await _firestore
            .collection(table)
            .where('timestamp',
                isGreaterThan:
                    Timestamp.fromMillisecondsSinceEpoch(lastSyncTimestamp))
            .get();

        if (querySnapshot.docs.isEmpty) continue;

        debugPrint(
            "'$table': Pulled ${querySnapshot.docs.length} new/updated records.");
        for (final doc in querySnapshot.docs) {
          final data = doc.data();
          data['serverId'] = doc.id;
          await dbHelper.upsert(table, data);
        }
      } catch (e) {
        debugPrint("'$table': FAILED to pull changes. Error: $e");
        debugPrint(
            ">>>>>> IMPORTANT: If the error mentions a 'failed-precondition', you MUST create the Firestore index by visiting the URL in the error log.");
        rethrow;
      }
    }

    await prefs.setInt(
        'lastSyncTimestamp', nowTimestamp.millisecondsSinceEpoch);
    debugPrint(
        "--- PULL step finished. New sync timestamp set to: ${nowTimestamp.millisecondsSinceEpoch} ---");
  }

  /// Triggers a Firebase Cloud Function to generate and send a PDF report.
  Future<void> _triggerPdfReport() async {
    debugPrint("--- Preparing to trigger PDF report generation ---");

    // In a real app, you would not call this unconditionally.
    // You'd call it after a new 'medical_history' record is successfully pushed.
    // For now, it's here as per the workflow requirement to run after a sync.

    // 1. Identify which members have new medical records that were just synced.
    //    (This logic would need to be added. For now, we'll assume a placeholder.)
    const memberServerIdForReport = "MEMBER_SERVER_ID_HERE"; // Placeholder

    // 2. The name of your Firebase Cloud Function.
    const functionName = "generateAndSendPdfReport";
    final functionUrl =
        "YOUR_CLOUD_FUNCTION_URL/$functionName"; // Replace with your function's trigger URL.

    try {
      // 3. Make an HTTP POST request to the Cloud Function.
      // final response = await http.post(
      //   Uri.parse(functionUrl),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({'memberId': memberServerIdForReport}),
      // );

      // if (response.statusCode == 200) {
      //   debugPrint("Successfully triggered PDF report for member: $memberServerIdForReport");
      // } else {
      //   debugPrint("Failed to trigger PDF report. Status: ${response.statusCode}, Body: ${response.body}");
      // }
      debugPrint(
          "PLACEHOLDER: Would call a cloud function to generate a report for recently updated members.");
    } catch (e) {
      debugPrint("Error calling the PDF report cloud function: $e");
    }
  }

  void dispose() {
    _connectivitySubscription.cancel();
    syncStatus.dispose();
  }
}

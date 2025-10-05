import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  const Contact({
    required this.id,
    required this.name,
    required this.phone,
  });

  final String id;
  final String name;
  final String phone;
}

abstract class ContactsRepository {
  Stream<List<Contact>> watchContacts();

  Future<void> addContact({required String name, required String phone});

  Future<void> deleteContact(String id);
}

class FirestoreContactsRepository implements ContactsRepository {
  FirestoreContactsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('contacts');

  @override
  Stream<List<Contact>> watchContacts() {
    return _collection
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Contact(
          id: doc.id,
          name: _valueOrFallback(data['name'] as String?, '(no name)'),
          phone: _valueOrFallback(data['phone'] as String?, '(no phone)'),
        );
      }).toList();
    });
  }

  @override
  Future<void> addContact({required String name, required String phone}) {
    return _collection.add({
      'name': name,
      'phone': phone,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteContact(String id) {
    return _collection.doc(id).delete();
  }

  static String _valueOrFallback(String? value, String fallback) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? fallback : trimmed;
  }
}

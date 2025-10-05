import 'dart:async';

import 'package:contact_list/data/contacts_repository.dart';
import 'package:contact_list/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows empty state when there are no contacts', (tester) async {
    final repository = FakeContactsRepository();
    addTearDown(repository.dispose);

    await tester.pumpWidget(MyApp(repository: repository));
    await tester.pump();

    expect(find.text('No Contacts to Show'), findsOneWidget);
  });

  testWidgets('renders provided contacts from the repository', (tester) async {
    final repository = FakeContactsRepository(
      const [
        Contact(id: '1', name: 'Alice', phone: '123'),
        Contact(id: '2', name: 'Bob', phone: '456'),
      ],
    );
    addTearDown(repository.dispose);

    await tester.pumpWidget(MyApp(repository: repository));
    await tester.pump();

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('123'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('456'), findsOneWidget);
  });

  testWidgets('deleting a contact removes it from the list', (tester) async {
    final repository = FakeContactsRepository(
      const [Contact(id: '1', name: 'Alice', phone: '123')],
    );
    addTearDown(repository.dispose);

    await tester.pumpWidget(MyApp(repository: repository));
    await tester.pump();

    expect(find.text('Alice'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('Alice'), findsNothing);
    expect(find.text('No Contacts to Show'), findsOneWidget);
  });
}

class FakeContactsRepository implements ContactsRepository {
  FakeContactsRepository([Iterable<Contact> initialContacts = const []])
      : _contacts = List<Contact>.from(initialContacts) {
    late StreamController<List<Contact>> controller;
    controller = StreamController<List<Contact>>.broadcast(
      onListen: () {
        controller.add(List<Contact>.unmodifiable(_contacts));
      },
    );
    _controller = controller;
    _idSeed = _computeInitialSeed(_contacts);
  }

  final List<Contact> _contacts;
  late final StreamController<List<Contact>> _controller;
  late int _idSeed;

  static int _computeInitialSeed(List<Contact> contacts) {
    var seed = 0;
    for (final contact in contacts) {
      final parsed = int.tryParse(contact.id);
      if (parsed != null && parsed >= seed) {
        seed = parsed + 1;
      }
    }
    return seed;
  }

  @override
  Stream<List<Contact>> watchContacts() => _controller.stream;

  @override
  Future<void> addContact({required String name, required String phone}) async {
    final contact = Contact(
      id: (_idSeed++).toString(),
      name: name,
      phone: phone,
    );
    _contacts.insert(0, contact);
    _emit();
  }

  @override
  Future<void> deleteContact(String id) async {
    _contacts.removeWhere((contact) => contact.id == id);
    _emit();
  }

  @override
  Future<void> updateContact({required String id, required String name, required String phone}) async {
    final index = _contacts.indexWhere((c) => c.id == id);
    if (index == -1) return;
    _contacts[index] = Contact(id: id, name: name, phone: phone);
    _emit();
  }

  void _emit() {
    if (!_controller.isClosed) {
      _controller.add(List<Contact>.unmodifiable(_contacts));
    }
  }

  void dispose() {
    _controller.close();
  }
}

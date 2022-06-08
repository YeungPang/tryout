import 'package:flutter/material.dart';
import 'package:webxene_core/auth_manager.dart';
import 'package:webxene_core/group_manager.dart';
import 'package:webxene_core/motes/filter.dart';
import 'package:webxene_core/motes/mote.dart';
import 'package:webxene_core/motes/mote_relation.dart';
import 'package:webxene_core/motes/sort_method.dart';

class SampleGroup extends StatelessWidget {
  const SampleGroup({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getSampleGroup(),
      builder: (BuildContext context, AsyncSnapshot<List<Mote>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return Scaffold(
            appBar: AppBar(title: const Text("Loading...")),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Adressverwaltung: Kontakte")),
          body: ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                // The subtitle for each item in our list should contain address, telefone, and categories.
                String subtitle =
                    snapshot.data?[index].payload['cf_adresse'] ?? "";
                subtitle +=
                    "\n" + (snapshot.data?[index].payload['cf_telefon'] ?? "");
                // Get all relations as motes, then convert them into string separated by commas.
                var categoryRelations =
                    snapshot.data?[index].payload['cf_kategorie'] as List;
                var categoryNames = MoteRelation.asMoteList(
                        categoryRelations, snapshot.data?[index].id ?? 0)
                    .map((m) => m.payload['title'] ?? '(Unknown)');
                subtitle += "\n" + categoryNames.join(', ');

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const Icon(Icons.contact_phone, size: 36),
                    title: Text(snapshot.data?[index].payload['title'] ?? ""),
                    subtitle: Text(subtitle),
                  ),
                );
              }),
          /*
					floatingActionButton: FloatingActionButton(
						backgroundColor: Colors.blueGrey,
						child: const Icon(Icons.saved_search),
						onPressed: () {
						},
					),
					*/
        );
      },
    );
  }
}

Future<List<Mote>> _getSampleGroup() async {
  int targetGroupId = 1;
  int targetPageId = 6;
  int targetColumnId = 1;

  // This is equivalent to: https://crm.sevconcept.ch/#!/group/1/page/7/view/129
  int specialPageId = 7;
  int specialPageSubmote = 129;

  try {
    // Normal example
    final myGroups = await AuthManager().loggedInUser.getSelfGroupsList();
    final myGroupsSelection = myGroups.firstWhere((g) => g.id == targetGroupId);
    final targetGroup = await GroupManager().fetchGroup(myGroupsSelection.id);
    final targetPage =
        targetGroup.orderedMenu.firstWhere((p) => p.id == targetPageId);
    final fullPage = await GroupManager()
        .fetchPageAndMotes(targetPage.id, forceRefresh: true);
    final targetColumn = fullPage.columns[targetColumnId]!;
    targetColumn.filters.clear();
    targetColumn
        .calculateMoteView(); // Call once every time filters/sort changes or when initializing column.
    final motes =
        targetColumn.getMoteViewPage(pageNum: 0); // Gets 20 motes from page 0.
    await Mote.retrieveReferences(
        motes, targetGroupId); // Get all references from those 20 motes.

    final motesCSV = Mote.interpretMotesCSV(motes);
    final motesHeader = motesCSV.item1;
    debugPrint(motesHeader);
    final motesData = motesCSV.item2;
    debugPrint(motesData.toString());

    // Sorting example
    targetColumn.sortMethods.add(SortMethod.normalSort("title", true));
    targetColumn.calculateMoteView();
    final sortedMotes = targetColumn.getMoteViewPage(pageNum: 0);
    debugPrint(sortedMotes.map((m) => m.payload['title']).toList().toString());
    targetColumn.sortMethods.clear();

    // Filtering example
    targetColumn.filters.add(Filter.andFilter("title", "Kaufmann"));
    targetColumn.calculateMoteView();
    final filteredMotes =
        Mote.interpretMotesCSV(targetColumn.getMoteViewPage(pageNum: 0));
    debugPrint(filteredMotes.item1); // Header
    debugPrint(filteredMotes.item2.toString()); // Data

    // Special page example (e.g. fetching all contacts inside company mote #129)
    // This is equivalent to: https://crm.sevconcept.ch/#!/group/1/page/7/view/129
    final specialPage = await GroupManager().fetchPageAndMotes(specialPageId,
        forceRefresh: true, subviewMote: specialPageSubmote);
    final specialColumnContacts = specialPage.columns[1]; // 'Kontakte' column
    final specialColumnNotes = specialPage.columns[2]; // 'Notizen' column
    specialColumnContacts?.calculateMoteView();
    specialColumnNotes?.calculateMoteView();
    final List<Mote> contactsView =
        specialColumnContacts?.getMoteViewPage(unpaginated: true) ?? [];
    final List<Mote> notesView =
        specialColumnNotes?.getMoteViewPage(unpaginated: true) ?? [];
    // Fetch all references from both at once - or we wait a lot longer for 2 HTTP round trips!
    await Mote.retrieveReferences(contactsView + notesView, targetGroupId);

    debugPrint(
        "Found ${contactsView.length} contacts and ${notesView.length} notes!");
    for (var contact in contactsView) {
      dynamic kontakt = contact.payload['cf_*kontakt'];
      if (kontakt != null) {
        kontakt = MoteRelation.asMoteList(kontakt, contact.id);
        debugPrint(contact.payload['title'] +
            " kontakt: " +
            kontakt.map((c) => c.payload['title']).toList().join(", "));
      }
      dynamic ref1 = contact.payload['cf_*ref1'];
      if (ref1 != null) {
        ref1 = MoteRelation.asMoteList(ref1, contact.id);
        debugPrint(contact.payload['title'] +
            " ref1: " +
            ref1.map((c) => c.payload['title']).toList().join(", "));
      }
    }
    // Print each note title followed by company it is from (called ref2 internally)
    for (var note in notesView) {
      dynamic kontakt = note.payload['cf_*kontakt'];
      if (kontakt != null) {
        kontakt = MoteRelation.asMoteList(kontakt, note.id);
        debugPrint(note.payload['title'] +
            " kontakt: " +
            kontakt.map((c) => c.payload['title']).toList().join(", "));
      }
      dynamic companyRefs = note.payload['cf_*ref2'];
      if (companyRefs != null) {
        companyRefs = MoteRelation.asMoteList(companyRefs, note.id);
        debugPrint(note.payload['title'] +
            " ref2: " +
            companyRefs.map((c) => c.payload['title']).toList().join(", "));
      }
    }

    return motes;
  } catch (ex) {
    debugPrint("EXCEPTION:");
    debugPrint(ex.toString());
    return [];
  }
}

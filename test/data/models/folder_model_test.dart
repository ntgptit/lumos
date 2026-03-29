import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/data/models/folder_model.dart';

void main() {
  group('FolderModel', () {
    test('maps deckCount from json into the domain entity', () {
      final FolderModel model = FolderModel.fromJson(<String, dynamic>{
        'id': 7,
        'name': 'Root',
        'description': 'Desc',
        'parentId': 3,
        'depth': 2,
        'childFolderCount': 1,
        'deckCount': 4,
      });

      final entity = model.toEntity();

      expect(model.deckCount, 4);
      expect(entity.id, 7);
      expect(entity.parentId, 3);
      expect(entity.childFolderCount, 1);
      expect(entity.deckCount, 4);
    });

    test('defaults deckCount to zero when backend omits it', () {
      final FolderModel model = FolderModel.fromJson(<String, dynamic>{
        'id': 8,
        'name': 'Leaf',
        'description': '',
        'parentId': null,
        'depth': 1,
        'childFolderCount': 0,
      });

      expect(model.deckCount, 0);
      expect(model.toEntity().deckCount, 0);
    });
  });
}

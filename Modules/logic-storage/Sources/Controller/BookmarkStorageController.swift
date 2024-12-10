/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */
import RealmSwift

public protocol BookmarkStorageController: StorageController where Value == Bookmark {}

final class BookmarkStorageControllerImpl: BookmarkStorageController {

  private let realmService: RealmService

  init(realmService: RealmService) {
    self.realmService = realmService
  }

  func store(_ value: Bookmark) throws {
    let realm = try realmService.get()
    let realmValue = value.toRealmBookmark()
    try realm.write {
      realm.add(realmValue, update: .all)
    }
  }

  func store(_ values: [Bookmark]) throws {
    let realm = try realmService.get()
    let realmValues = values.toRealmBookmarks()
    try realm.write {
      realm.add(realmValues, update: .all)
    }
  }

  func update(_ value: Bookmark) throws {
    let realm = try realmService.get()
    let realmValue = value.toRealmBookmark()
    try realm.write {
      realm.add(realmValue, update: .modified)
    }
  }

  func retrieve(_ identifier: String) throws -> Bookmark {
    let realm = try realmService.get()
    guard
      let bookmark = realm.object(
        ofType: RealmBookmark.self,
        forPrimaryKey: identifier
      )?.toBookmark()
    else {
      throw StorageError.itemNotFound
    }
    return bookmark
  }

  func retrieveAll() throws -> [Bookmark] {
    let realm = try realmService.get()
    let bookmarks = realm.objects(RealmBookmark.self)
    guard !bookmarks.isEmpty else {
      throw StorageError.itemsNotFound
    }
    return bookmarks.toList().toBookmarks()
  }

  func delete(_ identifier: String) throws {
    let realm = try realmService.get()

    guard
      let value = realm.object(
        ofType: RealmBookmark.self,
        forPrimaryKey: identifier
      )
    else {
      return
    }

    try realm.write {
      realm.delete(value)
    }
  }

  func deleteAll() throws {
    let realm = try realmService.get()
    let values = realm.objects(RealmBookmark.self)
    guard !values.isEmpty else {
      return
    }
    try realm.write {
      realm.delete(values)
    }
  }
}

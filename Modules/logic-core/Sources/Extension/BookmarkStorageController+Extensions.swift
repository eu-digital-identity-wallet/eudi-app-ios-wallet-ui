/*
 * Copyright (c) 2026 European Commission
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

import logic_storage

extension BookmarkStorageController {
  /// Bookmarks every renewed document when the original was bookmarked, as the Android wallet does. A
  /// bookmark that cannot be stored does not fail the renewal, and the others are still stored.
  func carryBookmark(wasBookmarked: Bool, to renewedIds: [String]) async {
    guard wasBookmarked else { return }
    for id in renewedIds {
      try? await store(.init(identifier: id))
    }
  }
}

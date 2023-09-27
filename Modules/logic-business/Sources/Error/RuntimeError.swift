/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation

public enum RuntimeError: LocalizedError {

  case deepLinkError(String)
  case customError(String)
  case genericError
  case notSupported

  public var errorDescription: String? {
    switch self {
    case .deepLinkError(let message):
      return message
    case .genericError:
      return "Oups! Something went wrong"
    case .customError(let message):
      return message
    case .notSupported:
      return "Not supported yet"
    }
  }
}

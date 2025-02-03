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
import Combine

public final class SendableCurrentValueSubject<T: Sendable>: @unchecked Sendable {

  private let subject: CurrentValueSubject<T, Never>

  public init(_ defaultValue: T) {
    subject = .init(defaultValue)
  }

  public func getSubject() -> CurrentValueSubject<T, Never> {
    subject
  }

  public func getPublisher() -> AnyPublisher<T, Never> {
    subject.eraseToAnyPublisher()
  }

  public func getAsyncStream() -> AsyncStream<T> {
    subject.toAsyncStream()
  }

  public func send(_ value: T) {
    subject.send(value)
  }

  public func setValue(_ value: T) {
    subject.value = value
  }

  public func getValue() -> T {
    subject.value
  }

  public func complete() {
    subject.send(completion: .finished)
  }
}

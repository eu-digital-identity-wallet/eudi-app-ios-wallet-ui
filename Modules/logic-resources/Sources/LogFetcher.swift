import SwiftUI
import OSLog

class LogFetcher: ObservableObject {
  @MainActor static let shared = LogFetcher()
  @Published var logMessages = [LogEntry(date: Date.init(timeIntervalSince1970: 0), message: "That's all, folks!")]

  @Published var isLoading: Bool = false

  private let store = try? OSLogStore(scope: .currentProcessIdentifier)
  private var lastFetchDate: Date?

  struct LogEntry: Hashable {
    let date: Date
    let message: String
  }

  func fetchLogs() {
    guard !isLoading else { return }
    isLoading = true

    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self, let store else { return }
      do {

        let fromDate = self.lastFetchDate ?? Date().addingTimeInterval(-5 * 60)
        let position = store.position(date: fromDate)

        let predicate = NSPredicate(format: "subsystem == %@", Bundle.main.bundleIdentifier!)
        let entries = try store.getEntries(at: position, matching: predicate)

        var newEntries: [LogEntry] = []

        for case let entry as OSLogEntryLog in entries {
          if let last = self.lastFetchDate, entry.date <= last {
            continue
          }
          let log = LogEntry(date: entry.date, message: entry.composedMessage)
          newEntries.append(log)
        }

        DispatchQueue.main.async {
          self.logMessages.insert(contentsOf: newEntries.reversed(), at: 0)
          self.lastFetchDate = Date()
          self.isLoading = false
        }

      } catch {
        DispatchQueue.main.async {
          let errorLog = LogEntry(date: Date(), message: "Failed to load logs: \(error.localizedDescription)")
          self.logMessages.insert(errorLog, at: 0)
          self.isLoading = false
        }
      }
    }
  }
}

public struct DebugLogView: View {
  @StateObject var fetcher = LogFetcher.shared
  public init() {}

  public var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack(alignment: .leading, spacing: 0) {
          if fetcher.isLoading {
            Text("Loading new logs...")
              .font(.footnote)
              .foregroundColor(.gray)
              .padding()
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(Color(.systemGray6))
          }

          ForEach(Array(fetcher.logMessages.enumerated()), id: \.element) { index, log in
            VStack(alignment: .leading, spacing: 4) {
              Text(log.date.formatted(date: .omitted, time: .standard))
                .font(.caption)
                .foregroundColor(.secondary)
              Text(log.message)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(index.isMultiple(of: 2) ? Color(.systemGray6) : Color(.systemBackground))
          }
        }
      }
      .navigationTitle("Debug Logs")
      .onAppear {
        fetcher.fetchLogs()
      }
    }
  }
}

import SwiftUI

struct ExpandableCardView: View {
  let title: String
  let subtitle: String
  let details: [DetailItem]

  @State private var isExpanded: Bool = false

  var body: some View {
    VStack(spacing: 0) {
      // Card Header
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .font(.headline)
            .foregroundColor(.primary)
          Text(subtitle)
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        Spacer()
        Button(action: {
          withAnimation {
            isExpanded.toggle()
          }
        }) {
          Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            .foregroundColor(.gray)
        }
      }
      .padding()
      .background(Color(UIColor.systemGray6))
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(Color(UIColor.systemGray4), lineWidth: 1)
      )

      // Expanded Details
      if isExpanded {
        VStack(alignment: .leading, spacing: 8) {
          ForEach(details) { detail in
            HStack {
              Text(detail.title)
                .font(.subheadline)
                .foregroundColor(.secondary)
              Spacer()
              Text(detail.value)
                .font(.body)
                .foregroundColor(.primary)
            }
            Divider()
          }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color(UIColor.systemGray4), lineWidth: 1)
        )
        .padding(.top, -8)
      }
    }
    .padding(.horizontal)
  }
}

struct DetailItem: Identifiable {
  let id = UUID()
  let title: String
  let value: String
}

// Preview
struct ExpandableCardView_Previews: PreviewProvider {
  static var previews: some View {
    ExpandableCardView(
      title: "Digital ID",
      subtitle: "View details",
      details: [
        DetailItem(title: "Family name", value: "Doe"),
        DetailItem(title: "Given names", value: "John"),
        DetailItem(title: "Date of birth", value: "21 Oct 1994"),
        DetailItem(title: "Age over 18", value: "Yes"),
        DetailItem(title: "Date of issue", value: "21 Oct 2023"),
        DetailItem(title: "Date of expiry", value: "21 Oct 2040"),
        DetailItem(title: "Issuing authority", value: "GR"),
        DetailItem(title: "Issuing country", value: "GR")
      ]
    )
  }
}

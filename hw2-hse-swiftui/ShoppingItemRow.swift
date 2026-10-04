import SwiftUI

struct ShoppingItemRow: View {
    let item: ShoppingItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(item.isPurchased ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .strikethrough(item.isPurchased)

                HStack(spacing: 4) {
                    Image(systemName: ShoppingCategory.symbol(for: item.category))
                        .foregroundStyle(ShoppingCategory.color(for: item.category))
                    Text("\(item.category) · \(item.quantity) шт.")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview("Активная покупка") {
    ShoppingItemRow(item: ShoppingItem.samples[0]) { }
        .padding()
}

#Preview("Купленная покупка") {
    ShoppingItemRow(item: ShoppingItem.samples[2]) { }
        .padding()
}

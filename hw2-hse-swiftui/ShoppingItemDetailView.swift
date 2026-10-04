import SwiftUI

struct ShoppingItemDetailView: View {
    @Binding var item: ShoppingItem

    var body: some View {
        Form {
            TextField("Название", text: $item.name)
            HStack {
                Image(systemName: ShoppingCategory.symbol(for: item.category))
                    .foregroundStyle(ShoppingCategory.color(for: item.category))
                Picker("Категория", selection: $item.category) {
                    ForEach(ShoppingCategory.names, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
            }
            Stepper("Количество: \(item.quantity)", value: $item.quantity, in: 1...99)
            Toggle("Куплено", isOn: $item.isPurchased)
        }
        .formStyle(.grouped)
        .navigationTitle("Покупка")
        .onDisappear {
            item.name = ShoppingItem.cleanName(item.name)
        }
    }
}

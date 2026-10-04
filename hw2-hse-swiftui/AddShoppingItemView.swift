import SwiftUI

struct AddShoppingItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var category = "Продукты"
    @State private var quantity = 1

    let onSave: (ShoppingItem) -> Void

    private var cleanName: String {
        ShoppingItem.cleanName(name)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Название", text: $name)
                HStack {
                    Image(systemName: ShoppingCategory.symbol(for: category))
                        .foregroundStyle(ShoppingCategory.color(for: category))
                    Picker("Категория", selection: $category) {
                        ForEach(ShoppingCategory.names, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }
                Stepper("Количество: \(quantity)", value: $quantity, in: 1...99)
            }
            .formStyle(.grouped)
            .navigationTitle("Новая покупка")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let item = ShoppingItem(
                            name: cleanName,
                            category: category,
                            quantity: quantity
                        )
                        onSave(item)
                        dismiss()
                    }
                    .disabled(cleanName.isEmpty || quantity < 1 || quantity > 99)
                }
            }
        }
        #if os(macOS)
        .frame(width: 420, height: 300)
        #endif
    }
}

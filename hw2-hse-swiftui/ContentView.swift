import SwiftUI

struct ContentView: View {
    @State private var items = ShoppingItem.load()
    @State private var searchText = ""
    @State private var showingAddItem = false
    @State private var selectedStatus = "Все"
    @State private var sortOrder = "Название"

    private var visibleItems: [ShoppingItem] {
        var result = items

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
                    || $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }

        if selectedStatus == "Нужно купить" {
            result = result.filter { !$0.isPurchased }
        } else if selectedStatus == "Куплено" {
            result = result.filter { $0.isPurchased }
        }

        if sortOrder == "Название" {
            result.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        } else if sortOrder == "Категория" {
            result.sort { $0.category.localizedStandardCompare($1.category) == .orderedAscending }
        } else {
            result.sort { $0.quantity < $1.quantity }
        }

        return result
    }

    private var remainingCount: Int {
        items.filter { !$0.isPurchased }.count
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    Text("Осталось купить: \(remainingCount)")
                    Spacer()
                    Menu("Сортировка") {
                        Picker("Сортировка", selection: $sortOrder) {
                            Text("По названию").tag("Название")
                            Text("По категории").tag("Категория")
                            Text("По количеству").tag("Количество")
                        }
                        .pickerStyle(.inline)
                    }
                }
                .padding(.horizontal)

                Picker("Статус", selection: $selectedStatus) {
                    Text("Все").tag("Все")
                    Text("Нужно купить").tag("Нужно купить")
                    Text("Куплено").tag("Куплено")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    if visibleItems.isEmpty {
                        ContentUnavailableView(
                            "Ничего не найдено",
                            systemImage: "magnifyingglass",
                            description: Text("Измените поиск или фильтр, либо добавьте покупку.")
                        )
                    } else {
                        ForEach(visibleItems) { item in
                            NavigationLink(value: item.id) {
                                ShoppingItemRow(item: item) {
                                    toggle(item)
                                }
                            }
                            .contextMenu {
                                Button("Удалить", role: .destructive) {
                                    items.removeAll { $0.id == item.id }
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .padding(.top, 8)
            .navigationTitle("Покупки")
            .searchable(text: $searchText, prompt: "Название или категория")
            .toolbar {
                Button("Добавить", systemImage: "plus") {
                    showingAddItem = true
                }
                .help("Добавить покупку")
            }
            .sheet(isPresented: $showingAddItem) {
                AddShoppingItemView { item in
                    items.append(item)
                }
            }
            .navigationDestination(for: UUID.self) { id in
                if let index = items.firstIndex(where: { $0.id == id }) {
                    ShoppingItemDetailView(item: $items[index])
                }
            }
            .onChange(of: items) { _, newItems in
                ShoppingItem.save(newItems)
            }
        }
    }

    private func toggle(_ item: ShoppingItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isPurchased.toggle()
        }
    }

    private func delete(at offsets: IndexSet) {
        let ids = offsets.map { visibleItems[$0].id }
        items.removeAll { ids.contains($0.id) }
    }
}

#Preview {
    ContentView()
}

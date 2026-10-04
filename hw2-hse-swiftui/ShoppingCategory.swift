import SwiftUI

struct ShoppingCategory {
    static let names = ["Продукты", "Учёба", "Дом", "Одежда", "Другое"]

    static func symbol(for category: String) -> String {
        switch category {
        case "Продукты":
            return "cart.fill"
        case "Учёба":
            return "book.fill"
        case "Дом":
            return "house.fill"
        case "Одежда":
            return "tshirt.fill"
        default:
            return "bag.fill"
        }
    }

    static func color(for category: String) -> Color {
        switch category {
        case "Продукты":
            return .orange
        case "Учёба":
            return .blue
        case "Дом":
            return .purple
        case "Одежда":
            return .pink
        default:
            return .gray
        }
    }
}

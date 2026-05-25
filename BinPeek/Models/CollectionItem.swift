import Foundation

enum CollectionType {
    case greenBin
    case recycling
    case garbage
}

struct CollectionItem: Identifiable {
    let id = UUID()
    let type: CollectionType
    let title: String
}

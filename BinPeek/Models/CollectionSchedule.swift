import Foundation

struct CollectionSchedule: Codable {
    let date: Date
    let greenBin: Bool
    let recycling: Bool
    let garbage: Bool
}

import Foundation

extension Camera.Pub {
    static let queues = Set([
        DispatchQueue(label: "", qos: .utility),
        .init(label: "", qos: .utility),
        .init(label: "", qos: .utility)])
}

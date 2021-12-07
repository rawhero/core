import Foundation

extension Camera.Pub {
    public static let queues = Set([
        DispatchQueue(label: "", qos: .utility),
        .init(label: "", qos: .utility),
        .init(label: "", qos: .utility)])
}

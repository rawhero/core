import Foundation

public struct Exporter {
    public private(set) var scale = Double(1)
    private let size: Picture.Size
    
    public var width: Int {
        .init(.init(size.width) * scale)
    }
    
    public var height: Int {
        .init(.init(size.height) * scale)
    }
    
    public init(size: Picture.Size) {
        self.size = size
    }
    
    mutating func scale(with: Double) {
        guard
            with >= 0.01,
            .init(size.width) * with >= 2,
            .init(size.height) * with >= 2
        else {
            scale = max(2 / Double(size.width), 2 / Double(size.height))
            return
        }
        scale = with
    }
    
    mutating public func width(with: String) {
        Int(with)
            .map {
                scale(with: .init($0) / .init(size.width))
            }
    }
    
    mutating public func height(with: String) {
        Int(with)
            .map {
                scale(with: .init($0) / .init(size.height))
            }
    }
}

import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var bookmarks: [Bookmark]
    var current: Bookmark?
    
    public var data: Data {
        .init()
        .adding(size: UInt8.self, collection: bookmarks)
        .adding(optional: current)
    }
    
    public init() {
        timestamp = 0
        bookmarks = []
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        bookmarks = data.collection(size: UInt8.self)
        
        if !data.isEmpty {
            current = data.prototype()
        }
    }
}

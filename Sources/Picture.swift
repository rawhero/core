import Foundation
import UniformTypeIdentifiers
import ImageIO

public struct Picture: Hashable, Identifiable {
    public let id: URL
    public let speed: Speed
    public let size: Size
    public let bytes: Int
    public let date: Date
    
    init?(item: Any) {
        guard
            let id = item as? URL,
            let resources = try? id.resourceValues(forKeys: [.contentTypeKey,
                                                             .creationDateKey,
                                                             .fileSizeKey]),
            let type = resources.contentType,
            type.conforms(to: .image),
            let source = CGImageSourceCreateWithURL(id as CFURL, [kCGImageSourceShouldCache : false] as CFDictionary),
            let dictionary = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String : AnyObject],
            let width = dictionary["PixelWidth"] as? Int,
            let height = dictionary["PixelHeight"] as? Int
        else { return nil }
        
        let exif = dictionary["{Exif}"] as? [String : AnyObject]
        
        date = (exif?["DateTimeOriginal"] as? String)
            .flatMap {
                let a = ISO8601DateFormatter().date(from: $0)
                print("date : \(a)")
                return a
            }
        ?? resources.creationDate
        ?? .now
        
        speed = (exif?["ISOSpeedRatings"] as? [Int])
            .flatMap(Speed.iso)
        ?? .unknown
        
        bytes = resources.fileSize ?? 0
        size = .init(width: width, height: height)
        self.id = id
    }
    
    public func hash(into: inout Hasher) {
        into.combine(id.absoluteString)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id.absoluteString == rhs.id.absoluteString
    }
}

import Foundation
import UniformTypeIdentifiers
import ImageIO

public struct Picture: Hashable, Identifiable {
    public let id: URL
    public let speed: Speed
    public let size: Size
    public let bytes: Int
    public let date: Date
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
        return formatter
    } ()
    
    init?(item: Any) {
        guard
            let id = item as? URL,
            let resources = try? id.resourceValues(forKeys: [.contentTypeKey,
                                                             .creationDateKey,
                                                             .fileSizeKey]),
            let type = resources.contentType,
            type.conforms(to: .image),
            let source = CGImageSourceCreateWithURL(id as CFURL, [kCGImageSourceShouldCache : false] as CFDictionary),
            let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String : AnyObject]
        else { return nil }
        
        let exif = properties["{Exif}"] as? [String : AnyObject]
        let tiff = properties["{TIFF}"] as? [String : AnyObject]
        let rotated = ((properties["Orientation"] as? Int)
        ?? tiff?["Orientation"] as? Int
        ?? 1) > 4
        
        date = (exif?["DateTimeOriginal"] as? String)
            .flatMap(Self.formatter.date(from:))
        ?? resources.creationDate
        ?? .now
        
        speed = (exif?["ISOSpeedRatings"] as? [Int])
            .flatMap(Speed.iso)
        ?? .unknown
        
        size = .init(rotated: rotated,
                     width: (properties["PixelWidth"] as? Int)
                     ?? tiff?["Width"] as? Int
                     ?? 0,
                     height: (properties["PixelHeight"] as? Int)
                     ?? tiff?["Height"] as? Int
                     ?? 0)
        
        bytes = resources.fileSize ?? 0
        
        self.id = id
    }
    
    public func hash(into: inout Hasher) {
        into.combine(id.absoluteString)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id.absoluteString == rhs.id.absoluteString
    }
}

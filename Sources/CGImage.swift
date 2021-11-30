import Foundation
import ImageIO

extension CGImage {
    static func render(url: URL, size: CGFloat) -> CGImage? {
        CGImageSourceCreateThumbnailAtIndex(
            CGImageSourceCreateWithURL(url as CFURL,
                                       [kCGImageSourceShouldCache : false] as CFDictionary)!, 0,
            [kCGImageSourceCreateThumbnailFromImageAlways : true,
                      kCGImageSourceThumbnailMaxPixelSize : size,
               kCGImageSourceCreateThumbnailWithTransform : true] as CFDictionary)
    }
}

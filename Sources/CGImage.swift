import Foundation
import ImageIO

extension CGImage {
    public static func generate(url: URL, exporter: Exporter) -> Data? {
        let data = NSMutableData()
        guard
            let image = render(
                url: url,
                size: .init(max(exporter.width, exporter.height)),
                quality: exporter.quality,
                alpha: exporter.mode == .png),
            let destination = CGImageDestinationCreateWithData(data as CFMutableData, exporter.mode.type, 1, nil)
        else { return nil }
        CGImageDestinationAddImage(destination, image, nil)
        CGImageDestinationFinalize(destination)
        return data as Data
    }
    
    static func render(url: URL, size: CGFloat, quality: Double, alpha: Bool) -> CGImage? {
        CGImageSourceCreateThumbnailAtIndex(
            CGImageSourceCreateWithURL(url as CFURL,
                                       [kCGImageSourceShouldCache : false] as CFDictionary)!, 0,
            [kCGImageSourceCreateThumbnailFromImageAlways : true,
                      kCGImageSourceThumbnailMaxPixelSize : size,
               kCGImageSourceCreateThumbnailWithTransform : true,
                                 kCGImagePropertyHasAlpha : alpha,
               kCGImageDestinationLossyCompressionQuality : quality] as CFDictionary)
    }
}

import Foundation
import UniformTypeIdentifiers

extension Exporter {
    public enum Mode: Int {
        case
        jpg,
        png
        
        var type: CFString {
            switch self {
            case .jpg:
                return UTType.jpeg.identifier as CFString
            case .png:
                return UTType.png.identifier as CFString
            }
        }
    }
}

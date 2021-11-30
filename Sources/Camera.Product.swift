import Foundation

extension Camera {
    public enum Product {
        case
        error(CoreError),
        image(CGImage)
    }
}

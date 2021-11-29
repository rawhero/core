import Foundation

extension Camera {
    public enum Strategy {
        case
        thumbnail,
        hd
        
        func size(for image: Picture.Size) -> CGFloat {
            switch self {
            case .hd:
                return .init(min(1024, min(image.width, image.height)))
            case .thumbnail:
                return 100
            }
        }
    }
}

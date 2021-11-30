import Foundation

extension Picture {
    public struct Size: Hashable {
        public let width: Int
        public let height: Int
        
        init(rotated: Bool, width: Int, height: Int) {
            self.width = rotated ? height : width
            self.height = rotated ? width : height
        }
    }
}

import Foundation

extension Picture {
    public struct Size: Hashable, Comparable {
        public let width: Int
        public let height: Int
        
        init(rotated: Bool, width: Int, height: Int) {
            self.width = rotated ? height : width
            self.height = rotated ? width : height
        }
        
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.width * lhs.height < rhs.width * rhs.height
        }
    }
}

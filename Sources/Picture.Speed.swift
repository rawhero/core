import Foundation

extension Picture {
    public enum Speed: Hashable {
        case
        unknown,
        iso([Int])
    }
}

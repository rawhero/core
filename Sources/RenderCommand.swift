import Foundation

protocol RenderCommand {
    func output(for url: URL, with: Render.Pub)
}

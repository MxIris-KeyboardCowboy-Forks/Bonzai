import Combine
import SwiftUI

public struct IconView: View {
  private let icon: Icon
  private let size: CGSize
  @State private var nsImage: NSImage?

  public init(icon: Icon, size: CGSize) {
    self.icon = icon
    self.size = size
  }

  public var body: some View {
    Group {
      if let nsImage {
        Image(nsImage: nsImage)
          .aspectRatio(contentMode: .fill)
      } else {
        Color.clear
          .task(id: icon.path) {
            nsImage = try? await nsImage(for: icon.path, ofSize: size)
          }
      }
    }
    .frame(width: size.width, height: size.height)
    .fixedSize()
    .drawingGroup()
  }

  private func nsImage(for path: String, ofSize size: CGSize) async throws -> NSImage {
    let image = NSWorkspace.shared.icon(forFile: path)
    try Task.checkCancellation()
    if let imageRep = image.bestRepresentation(for: .init(origin: .zero, size: size), context: nil, hints: nil) {
      let repImage = NSImage(size: size)
      repImage.addRepresentation(imageRep)
      try Task.checkCancellation()
      return repImage
    } else {
      return image
    }
  }
}

struct IconView_Previews: PreviewProvider {
  static var previews: some View {
    IconView(icon: .init(bundleIdentifier: "com.apple.finder.",
                         path: "/System/Library/CoreServices/Finder.app"),
             size: .init(width: 32, height: 32))
  }
}

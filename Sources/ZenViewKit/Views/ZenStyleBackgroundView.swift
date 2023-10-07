import SwiftUI

struct ZenStyleBackgroundView: View {
  @Environment(\.colorScheme) var colorScheme
  let cornerRadius: CGFloat
  @Binding var isHovered: Bool
  let nsColor: NSColor

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .fill(LinearGradient(
          stops: Gradient.Stop.zen(colorScheme,
                                   nsColor: nsColor),
          startPoint: .top, endPoint: .bottom))
        .background(
          RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(strokeColor(), lineWidth: 1)
            .offset(y: 0.25)
        )
        .opacity(opacity())
    }
  }

  private func opacity() -> CGFloat {
    isHovered
    ? 1.0
    : colorScheme == .light ? 0.7 : 0.3
  }

  private func strokeColor() -> Color {
    if colorScheme == .dark {
      Color(nsColor: .shadowColor).opacity(0.2)
    } else {
      Color(nsColor: nsColor).opacity(0.2)
    }
  }
}

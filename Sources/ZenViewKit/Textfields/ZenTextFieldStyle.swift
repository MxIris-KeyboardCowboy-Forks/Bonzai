import SwiftUI

struct ZenTextFieldStyle: TextFieldStyle {
  @FocusState var isFocused: Bool
  @State var isHovered: Bool = false
  private let config: ZenStyleConfiguration

  init(_ config: ZenStyleConfiguration = .init()) {
    self.config = config
  }

  func _body(configuration: TextField<_Label>) -> some View {
    HStack {
      configuration
        .textFieldStyle(.plain)
        .modifier(ZenTextViewModifier(config.font))
        .background(
          RoundedRectangle(cornerRadius: 4 + 1.5)
            .strokeBorder(Color(config.color.nsColor), lineWidth: 1.5)
            .padding(-1.5)
            .opacity(isFocused ? 1 : isHovered ? 0.5 : config.unfocusedOpacity)
            .background(
              config.backgroundColor
            )
            .clipShape(
              RoundedRectangle(cornerRadius: 4)
            )
            .background(
              RoundedRectangle(cornerRadius: 4 + 2.5)
                .strokeBorder(Color(config.color.nsColor).opacity(0.5), lineWidth: 1.5)
                .padding(-2.5)
                .opacity(isFocused ? 1 : isHovered ? 0.5 : config.unfocusedOpacity)
            )
            .overlay(
              RoundedRectangle(cornerRadius: 4)
                .stroke(Color(isFocused ? config.color.nsColor : .windowFrameTextColor), lineWidth: 2)
                .compositingGroup()
                .shadow(color: Color(isFocused ? config.color.nsColor : .clear), radius: 2)
                .padding(-1)
                .opacity(
                  config.glow ? (isFocused ? 0.75
                                 : isHovered
                                 ? 0.25 : 0) : 0)
            )
            .compositingGroup()
            .grayscale(isFocused ? 0 : 0.5)
            .animation(.easeInOut(duration: 0.25), value: isHovered)
            .animation(.easeInOut(duration: 0.25), value: isFocused)
        )
        .padding(2.5)
        .compositingGroup()
        .onHover(perform: { newValue in
          isHovered = newValue
        })
        .focused($isFocused)
    }
  }
}

struct ZenTextFieldStyle_Preview: PreviewProvider {
  static var previews: some View {
    HStack {
      VStack {
        TextField("Regular TextField", text: .constant(""))

        TextField("Large TextField", text: .constant(""))
          .textFieldStyle(.large(color: .accentColor, backgroundColor: Color.clear, glow: true))

        TextField("Zen TextField", text: .constant(""))
          .textFieldStyle(.regular(nil))

        TextField("Zen TextField colored", text: .constant(""))
          .textFieldStyle(.zen(.init(color: .systemPurple)))
      }
      .environment(\.colorScheme, .light)

      VStack {
        TextField("Regular TextField", text: .constant(""))

        TextField("Large TextField", text: .constant(""))
          .textFieldStyle(.large(color: .accentColor, backgroundColor: .clear, glow: true))

        TextField("Zen TextField", text: .constant(""))
          .textFieldStyle(.regular(nil))

        TextField("Zen TextField colored", text: .constant(""))
          .textFieldStyle(.zen(.init(color: .systemPurple)))
      }
      .environment(\.colorScheme, .dark)
    }
    .padding()
  }
}

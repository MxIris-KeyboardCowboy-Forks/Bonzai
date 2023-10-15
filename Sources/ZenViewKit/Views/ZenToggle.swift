import SwiftUI

public struct ZenToggle: View {
  public enum Style {
    case regular
    case small

    var size: CGSize {
      switch self {
      case .regular: CGSize(width: 38, height: 20)
      case .small:   CGSize(width: 22, height: 12)
      }
    }

    var circle: CGSize {
      switch self {
      case .regular: CGSize(width: 19, height: 19)
      case .small: CGSize(width: 11, height: 11)
      }
    }
  }

  @Environment(\.controlActiveState) var controlActiveState
  @Binding private var isOn: Bool
  @State private var isHovered: Bool
  private let style: Style
  private let titleKey: String
  private let config: ZenStyleConfiguration
  private let onChange: (Bool) -> Void

  public init(_ titleKey: String = "",
       config: ZenStyleConfiguration = .init(color: .systemGreen),
       style: Style = .regular,
       isOn: Binding<Bool>,
       onChange: @escaping (Bool) -> Void = { _ in }) {
    _isOn = isOn
    _isHovered = .init(initialValue: config.hoverEffect.wrappedValue ? false : true)
    self.config = config
    self.style = style
    self.titleKey = titleKey
    self.onChange = onChange
  }

  public var body: some View {
    HStack {
      if !titleKey.isEmpty { Text(titleKey) }
      Button(action: {
        isOn.toggle()
        onChange(isOn)
      }, label: {
        Capsule()
          .fill(isOnFillColor)
          .overlay(alignment: isOn ? .trailing : .leading, content: {
            Circle()
              .frame(width: style.circle.width - 1, height: style.circle.height - 1)
              .overlay(
                Circle()
                  .stroke(isOnColor, lineWidth: 0.5)
              )
              .padding(.horizontal, 1)
              .shadow(radius: 1)
          })
          .overlay {
            Capsule()
              .stroke(Color(nsColor: config.color.nsColor.blended(withFraction: 0.5, of: .black)!), lineWidth: 0.5)
              .opacity(isOn ? 1 : 0)
          }
          .animation(.default, value: isOn)
          .background(
            Capsule()
              .strokeBorder(isOnColor, lineWidth: 1)
          )
          .frame(width: style.size.width, height: style.size.height)
      })
      .grayscale(grayscale())
      .buttonStyle(.plain)
    }
  }

  private func grayscale() -> CGFloat {
    config.grayscaleEffect.wrappedValue ? isHovered ? 0
    : isHovered ? 0.5 : 1
    : controlActiveState == .key ? 0 : 0.4
  }


  var isOnFillColor: Color {
    isOn
    ? Color(nsColor: config.color.nsColor.blended(withFraction: 0.2, of: .black)!)
    : Color(nsColor: .controlColor)
  }

  var isOnColor: Color {
    isOn
    ? Color(nsColor: config.color.nsColor.blended(withFraction: 0.25, of: .black)!)
    : Color(nsColor: .windowBackgroundColor)
  }
}



struct ZenToggle_Previews: PreviewProvider {
  static var systemToggles: some View {
    VStack {
      Toggle(isOn: .constant(true), label: {
        Text("Default on")
      })
      .tint(Color(.systemGreen))
      Toggle(isOn: .constant(false), label: {
        Text("Default off")
      })
    }
  }

  static var previews: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top, spacing: 32) {
        VStack(alignment: .leading) {
          Text("System")
            .font(.headline)
          systemToggles
            .toggleStyle(.switch)
        }

        VStack(alignment: .leading) {
          Text("Regular")
            .font(.headline)

          ZenToggle("",
                    style: .regular,
                    isOn: .constant(true)) { _ in }

          ZenToggle("Default on",
                    style: .regular,
                    isOn: .constant(true)) { _ in }
          ZenToggle("Default off",
                    style: .regular,
                    isOn: .constant(false)) { _ in }
        }

        VStack(alignment: .leading) {
          Text("Small")
            .font(.headline)
          ZenToggle("Default on", style: .small, isOn: .constant(true)) { _ in }
          ZenToggle("Default off", style: .small, isOn: .constant(false)) { _ in }
        }
      }
    }
    .padding()
  }
}


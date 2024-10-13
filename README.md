# ElegantTabView

ElegantTabView is a customizable and elegant tab view component for SwiftUI, designed to enhance the user interface of iOS applications. It provides a sleek and modern tab bar that can be positioned at the bottom, left, or right side of the screen.

## Features

- Customizable tab bar position (bottom, left, or right)
- Smooth animations for tab switching
- Customizable colors for background, foreground, and indicator
- Support for system SF Symbols as tab icons
- Easy integration with SwiftUI projects
- Minimum iOS version: 15.0

## Installation

### Swift Package Manager

You can add ElegantTabView to your project using Swift Package Manager. In Xcode, go to File > Swift Packages > Add Package Dependency and enter the following URL:

```
https://github.com/brunabaudel/elegantTabView.git
```

## Usage

1. Import the package in your SwiftUI view:

```swift
import ElegantTabView
```

2. Create an ElegantTabView with your desired tabs:

```swift
struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        ElegantTabView(position: .bottom, selectedTab: $selectedTab) {
            Text("Home")
                .tabItem("house")
            Text("Search")
                .tabItem("magnifyingglass")
            Text("Profile")
                .tabItem("person")
        }
    }
}
```

3. Customize the appearance (optional):

```swift
ElegantTabView(position: .bottom, selectedTab: $selectedTab) {
    // Tab content here
}
.background(.ultraThinMaterial)
.foreground(.blue)
.foregroundDisabled(.gray)
.indicator(.red)
.padding(.horizontal, 20)
```

## Customization

ElegantTabView offers several customization options:

- `background(_:)`: Set the background color or material of the tab bar
- `foreground(_:)`: Set the color of the selected tab icon
- `foregroundDisabled(_:)`: Set the color of unselected tab icons
- `indicator(_:)`: Set the color of the selection indicator
- `padding(_:)`: Add padding to the tab bar

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you have any questions or need support, please open an issue in the GitHub repository.

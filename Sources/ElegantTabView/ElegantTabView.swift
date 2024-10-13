// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct ElegantTabView<Content: View>: View {
    fileprivate let position: TabbarPosition
    @Binding fileprivate var selectedTab: Int
    
    @State fileprivate var tabPositions: [CGFloat] = []
    fileprivate var tabs: [String] = []
    fileprivate let content: Content
    
    private var tabItems: [any ElegantTabItem] = []
    fileprivate var tabBarBackgroundColor: Color?
    fileprivate var tabBarBackgroundMaterial: Material = .thickMaterial
    fileprivate var tabBarButtonsColor: Color = Color.blue
    fileprivate var tabBarButtonsDisabledColor: Color = Color.gray
    fileprivate var tabBarIndicatorColor: Color = Color.blue
    fileprivate var tabBarPaddingEdge: Edge.Set?
    fileprivate var tabBarPaddingLenght: CGFloat?
    
    fileprivate let tabBarPaddingHorizontal: CGFloat = 15
    fileprivate let tabBarPaddingVertical: CGFloat = 15
           
    public init(
        position: TabbarPosition,
        selectedTab: Binding<Int>,
        @ViewBuilder content: () -> Content
    ) {
        self.position = position
        self._selectedTab = selectedTab
        self.content = content()
        
        let mirror = Mirror(reflecting: content())
        self.tabItems = findTabItems(in: mirror)
        self.tabs = tabItems.map { $0.iconName }
        self._tabPositions = State(initialValue: Array(repeating: 0, count: self.tabs.count))
    }
    
    public var body: some View {
        if tabItems.count > 0 {
            GeometryReader { geometry in
                ZStack {
                    if selectedTab >= 0 && selectedTab < tabItems.count {
                        tabItems[selectedTab].content
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        EmptyView()
                    }
                    
                    tabbarView(geometry: geometry)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}


extension ElegantTabView {
    func background(_ color: Color) -> Self {
        var view = self
        view.tabBarBackgroundColor = color
        return view
    }
    
    func background(_ material: Material) -> Self {
        var view = self
        view.tabBarBackgroundMaterial = material
        return view
    }
    
    func foreground(_ color: Color) -> Self {
        var view = self
        view.tabBarButtonsColor = color
        return view
    }
    
    func foregroundDisabled(_ color: Color) -> Self {
        var view = self
        view.tabBarButtonsDisabledColor = color
        return view
    }
    
    func indicator(_ color: Color) -> Self {
        var view = self
        view.tabBarIndicatorColor = color
        return view
    }
    
    func padding(_ lenght: CGFloat) -> Self {
        var view = self
        view.tabBarPaddingLenght = lenght
        return view
    }
    
    func padding(_ edge: Edge.Set, _ lenght: CGFloat) -> Self {
        var view = self
        view.tabBarPaddingEdge = edge
        view.tabBarPaddingLenght = lenght
        return view
    }
    
    func findTabItems(in mirror: Mirror) -> [any ElegantTabItem] {
        var tabItems: [any ElegantTabItem] = []
        
        for child in mirror.children {
            if let tabItem = child.value as? any ElegantTabItem {
                tabItems.append(tabItem)
            } else {
                let childMirror = Mirror(reflecting: child.value)
                tabItems.append(contentsOf: findTabItems(in: childMirror))
            }
        }
        
        return tabItems
    }
    
    @ViewBuilder
    func tabbarView(geometry: GeometryProxy) -> some View {
        switch position {
        case .left:
            HStack {
                tabbarContent(geometry: geometry)
                    .frame(width: 70)
                    .padding(tabBarPaddingEdge ?? .all, tabBarPaddingLenght ?? 4)
                    
                Spacer()
            }
        case .bottom:
            VStack {
                Spacer()
                tabbarContent(geometry: geometry)
                    .frame(height: 70)
                    .padding(tabBarPaddingEdge ?? .all, tabBarPaddingLenght ?? 24)
                    
            }
        case .right:
            HStack {
                Spacer()
                tabbarContent(geometry: geometry)
                    .frame(width: 70)
                    .padding(tabBarPaddingEdge ?? .all, tabBarPaddingLenght ?? 4)
            }
        }
    }
    
    func tabbarContent(geometry: GeometryProxy) -> some View {
        ZStack {
            Group {
                if position == .bottom {
                    HStack(spacing: 0) {
                        tabButtons
                    }
                } else {
                    VStack(spacing: 0) {
                        tabButtons
                    }
                }
            }
            .padding(.vertical, position == .bottom ? 5 : tabBarPaddingVertical)
            .padding(.horizontal, position == .bottom ? tabBarPaddingHorizontal : 5)
            .background(tabBarBackgroundColor)
            .background(
                tabBarBackgroundMaterial
            )
            .clipShape(Capsule())
            
            indicatorCircle(geometry: geometry)
        }
    }
    
    var tabButtons: some View {
        ForEach(0..<tabs.count, id: \.self) { index in
            ElegantTabViewButtonView(
                title: tabs[index],
                isSelected: selectedTab == index,
                position: position,
                tabBarButtonsColor: tabBarButtonsColor,
                tabBarButtonsDisabledColor: tabBarButtonsDisabledColor,
                action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                },
                tabPosition: $tabPositions[index]
            )
        }
    }
    
    func indicatorCircle(geometry: GeometryProxy) -> some View {
        Circle()
            .trim(from: 0, to: 0.5)
            .fill(tabBarIndicatorColor)
            .frame(width: 30, height: 30)
            .rotationEffect(indicatorRotation)
            .offset(indicatorOffset(geometry: geometry))
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
    }
    
    var indicatorRotation: Angle {
        switch position {
        case .left:
            return .degrees(90)
        case .bottom:
            return .degrees(0)
        case .right:
            return .degrees(-90)
        }
    }
    
    func indicatorOffset(geometry: GeometryProxy) -> CGSize {
        switch position {
        case .left:
            return CGSize(
                width: tabBarPaddingHorizontal * 2 + 5,
                height: tabPositions[selectedTab] - geometry.size.height / 2 - tabBarPaddingVertical + 3
            )
        case .bottom:
            return CGSize(
                width: tabPositions[selectedTab] - geometry.size.width / 2 + (tabBarPaddingHorizontal * 2 + 2),
                height: -(tabBarPaddingVertical * 2 + 5)
            )
        case .right:
            return CGSize(
                width: -(tabBarPaddingHorizontal * 2 + 5),
                height: tabPositions[selectedTab] - geometry.size.height / 2 - tabBarPaddingVertical + 3
            )
        }
    }
}


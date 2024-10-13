//
//  ElegantTabItemView.swift
//  FluidSideBar
//
//  Created by Bruna on 12/10/2024.
//

import SwiftUI

protocol ElegantTabItem: View {
    var iconName: String { get }
    var content: AnyView { get }
}

public struct ElegantTabItemView<Content: View>: View, ElegantTabItem {
    let iconName: String
    let content: AnyView
    
    init(iconName: String, @ViewBuilder content: () -> Content) {
        self.iconName = iconName
        self.content = AnyView(content())
    }
    
    public var body: some View {
        content
    }
}

extension View {
    public func tabItem(_ iconName: String) -> some View {
        ElegantTabItemView(iconName: iconName) { self }
    }
}

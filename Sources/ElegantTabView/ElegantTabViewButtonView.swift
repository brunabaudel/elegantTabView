//
//  ElegantTabViewButtonView.swift
//  FluidSideBar
//
//  Created by Bruna on 12/10/2024.
//

import SwiftUI

struct ElegantTabViewButtonView: View {
    let title: String
    let isSelected: Bool
    let position: TabbarPosition
    let tabBarButtonsColor: Color
    let tabBarButtonsDisabledColor: Color
    let action: () -> Void
    @Binding var tabPosition: CGFloat
    
    var body: some View {
        Button(action: action) {
            Image(systemName: title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(isSelected ? tabBarButtonsColor : tabBarButtonsDisabledColor)
                .frame(width: 60, height: 60)
        }
        .background(
            GeometryReader { geo in
                Color.clear.preference(key: TabPositionKey.self, value: position == .bottom ? geo.frame(in: .global).minX : geo.frame(in: .global).minY)
            }
        )
        .onPreferenceChange(TabPositionKey.self) { tabPosition = $0 }
    }
}

struct TabPositionKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

//
//  ContentView.swift
//  CircleStyles
//
//  Created by Chris Eidhof on 14.01.20.
//  Copyright © 2020 Chris Eidhof. All rights reserved.
//

import SwiftUI

extension View {
    func circle(foreground: Color = .white, background: Color = .blue) -> some View {
        Circle()
            .fill(background)
            .overlay(Circle().strokeBorder(foreground).padding(3))
            .overlay(self.foregroundColor(foreground))
            .frame(width: 75, height: 75)
    }
}

struct CircleWrapper<Content: View>: View {
    var foreground, background: Color
    var content: Content
    init(foreground: Color = .white, background: Color = .blue, @ViewBuilder  content: () -> Content) {
        self.foreground = foreground
        self.background = background
        self.content = content()
    }
    
    var body: some View {
        Circle()
            .fill(background)
            .overlay(Circle().strokeBorder(foreground).padding(3))
            .overlay(content.foregroundColor(foreground))
            .frame(width: 75, height: 75)
    }
}

struct CircleModifier: ViewModifier {
    var foreground = Color.white
    var background = Color.blue
    func body(content: Content) -> some View {
        Circle()
            .fill(background)
            .overlay(Circle().strokeBorder(foreground).padding(3))
            .overlay(content.foregroundColor(foreground))
            .frame(width: 75, height: 75)
    }
}

struct CircleStyle: ButtonStyle {
    var foreground = Color.white
    var background = Color.blue
    
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        Circle()
            .fill(background.opacity(configuration.isPressed ? 0.8 : 1))
            .overlay(Circle().strokeBorder(foreground).padding(3))
            .overlay(configuration.label.foregroundColor(foreground))
            .frame(width: 75, height: 75)
    }
}

struct ContentView: View {
    var body: some View {
        HStack {
           Button(action: {}, label: { Text("One")})
           Button(action: {}, label: { Text("Two")})
           Button(action: {}, label: { Text("Three")})
        }.buttonStyle(CircleStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

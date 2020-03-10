//
//  ContentView.swift
//  Bounce Animation
//
//  Created by Florian Kugler on 06-02-2020.
//  Copyright © 2020 objc.io. All rights reserved.
//

import SwiftUI

struct Bounce: AnimatableModifier {
    var times: CGFloat = 0
    var amplitude: CGFloat = 30
    var animatableData: CGFloat {
        get { times }
        set { times = newValue }
    }

    func body(content: Content) -> some View {
        return content.offset(y: -abs(sin(times * .pi)) * amplitude)
    }
}

extension View {
    func bounce(times: Int) -> some View {
        return modifier(Bounce(times: CGFloat(times)))
    }
}

struct ContentView: View {
    @State private var taps: Int = 0
    var body: some View {
        Button("Tap Me") {
            withAnimation(.linear(duration: 0.9)) {
                self.taps += 1
            }
        }.bounce(times: taps * 3)
    }
}

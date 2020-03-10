//
//  ContentView.swift
//  ShakeAnimation
//
//  Created by Florian Kugler on 10-03-2020.
//  Copyright © 2020 Florian Kugler. All rights reserved.
//

import SwiftUI

struct Shake: AnimatableModifier {
    var times: CGFloat = 0
    let amplitude: CGFloat = 10
    var animatableData: CGFloat {
        get { times }
        set { times = newValue }
    }
    func body(content: Content) -> some View {
        return content.offset(x: sin(times * .pi * 2) * amplitude)
    }
}

struct ShakeEffect: GeometryEffect {
    var times: CGFloat = 0
    let amplitude: CGFloat = 10
    var animatableData: CGFloat {
        get { times }
        set { times = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(
            translationX: sin(times * .pi * 2) * amplitude,
            y: 0
        ))
    }
}

extension View {
    func shake(times: Int) -> some View {
        return modifier(Shake(times: CGFloat(times)))
    }
}

struct ContentView: View {
    @State private var taps: Int = 0

    var body: some View {
        Button("Hello") {
            withAnimation(.linear(duration: 0.5)) {
                self.taps += 1
            }
        }
        .shake(times: taps * 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

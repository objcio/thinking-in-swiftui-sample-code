//
//  ContentView.swift
//  Transition
//
//  Created by Chris Eidhof on 04.02.20.
//  Copyright © 2020 Chris Eidhof. All rights reserved.
//

import SwiftUI

struct Blur: ViewModifier {
    var active: Bool
    func body(content: Content) -> some View {
        return content
            .blur(radius: active ? 50 : 0)
            .opacity(active ? 0 : 1)
    }
}

extension AnyTransition {
    static var blur: AnyTransition {
        .modifier(active: Blur(active: true), identity: Blur(active: false))
    }
}

struct ContentView: View {
    @State var visible = false
    var body: some View {
        VStack {
            Button("Toggle") {
                withAnimation(.linear(duration: 1)) {
                    self.visible.toggle()
                }
            }
            if visible {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 100, height: 100)
                    .transition(.blur)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

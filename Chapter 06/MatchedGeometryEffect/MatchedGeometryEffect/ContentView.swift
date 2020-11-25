//
//  ContentView.swift
//  MatchedGeometryEffect
//
//  Created by Florian Kugler on 25-11-2020.
//

import SwiftUI

struct ContentView: View {
    @Namespace var ns
    @State var state = false
    
    var body: some View {
        VStack {
            if !state {
                Rectangle()
                    .fill(Color.red)
                    .matchedGeometryEffect(id: "1", in: ns)
                    .frame(width: 200, height: 200)
                    .offset(x: -100, y: 0)
            } else {
                Circle()
                    .fill(Color.green)
                    .matchedGeometryEffect(id: "1", in: ns)
                    .frame(width: 100, height: 100)
                    .offset(x: 100, y: 0)
            }
            Spacer()
            Toggle("", isOn: $state)
        }
        .animation(.default)
        .frame(width: 0, height: 300)
    }
}

extension AnyTransition {
    static let noOp: AnyTransition = .modifier(active: NoOpTransition(1), identity: NoOpTransition(0))
}

struct NoOpTransition: AnimatableModifier {
    var animatableData: CGFloat = 0
    
    init(_ x: CGFloat) {
        animatableData = x
    }
    
    func body(content: Content) -> some View {
        return content
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

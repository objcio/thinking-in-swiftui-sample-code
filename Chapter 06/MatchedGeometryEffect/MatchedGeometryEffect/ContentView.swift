//
//  ContentView.swift
//  MatchedGeometryEffect
//
//  Created by Florian Kugler on 25-11-2020.
//

import SwiftUI

let blue = Color(red: 0, green: 146/255.0, blue: 219/255.0)

struct ContentView: View {
    @Namespace var ns
    @State var state = false
    
    var body: some View {
        VStack {
            HStack {
                if !state {
                    Rectangle().fill(blue)
                        .matchedGeometryEffect(id: "1", in: ns)
                        .frame(width: 200, height: 200)
                }
                Spacer()
                if state {
                    Circle().fill(blue)
                        .matchedGeometryEffect(id: "1", in: ns)
                        .frame(width: 100, height: 100)
                }
            }
            .border(Color.black)
            .frame(width: 300, height: 200)
            Toggle("", isOn: $state)
        }
        .animation(.default)
        .frame(width: 0)
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

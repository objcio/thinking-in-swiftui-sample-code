//
//  ContentView.swift
//  01 Tap Me
//
//  Created by Florian Kugler on 31-01-2020.
//  Copyright © 2020 objc.io. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var counter = 0
    var body: some View {
        VStack {
            Button(action: { self.counter += 1 }, label: {
                Text("Tap me!")
                    .padding()
                    .background(Color(.tertiarySystemFill))
                    .cornerRadius(5)
            })
            
            if counter > 0 {
                Text("You've tapped \(counter) times")
            } else {
                Text("You've not yet tapped")
            }
        }
    }
}

func debug<A: View>(_ a: A) -> some View {
    print(Mirror(reflecting: a).subjectType)
    return a
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

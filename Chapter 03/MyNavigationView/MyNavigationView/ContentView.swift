//
//  ContentView.swift
//  03-MyNavigationView
//
//  Created by Chris Eidhof on 13.12.19.
//  Copyright © 2019 objc.io. All rights reserved.
//

import SwiftUI

struct MyNavigationTitleKey: PreferenceKey {
    static var defaultValue: String? = nil
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = value ?? nextValue()
    }
}

extension View {
    func myNavigationTitle(_ title: String) -> some View {
        self.preference(key: MyNavigationTitleKey.self, value: title)
    }
}

struct MyNavigationView<Content>: View where Content: View {
    let content: Content
    
    @State private var title: String?
    var body: some View {
        VStack {
            Text(title ?? "")
                .font(Font.largeTitle)
            content.onPreferenceChange(MyNavigationTitleKey.self) { title in
                self.title = title
            }
        }
    }
}

struct ContentView: View {
    @State var number: Int = 10
    
    var body: some View {
        MyNavigationView(content:
            Text("Hello")
                .myNavigationTitle("Root View")
                .background(Color.gray)
        )
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

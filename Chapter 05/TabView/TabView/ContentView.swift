//
//  ContentView.swift
//  AnchorExamples
//
//  Created by Chris Eidhof on 12.11.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import SwiftUI

struct BoundsKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
}

struct ContentView: View {
    let tabs: [Text] = [
        Text("World Clock"),
        Text("Alarm"),
        Text("Bedtime")
    ]
    
    @State var selectedTabIndex = 0
    
    var body: some View {
        HStack {
            ForEach(tabs.indices) { tabIndex in
                Button(action: {
                    withAnimation(.default) {
                        self.selectedTabIndex = tabIndex
                    }
                }, label: { self.tabs[tabIndex] })
                    .anchorPreference(key: BoundsKey.self, value: .bounds, transform: { anchor in
                        self.selectedTabIndex == tabIndex ? anchor : nil
                })
            }            
        }.padding(10).overlayPreferenceValue(BoundsKey.self, { anchor in
            GeometryReader { proxy in
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: proxy[anchor!].width, height: 2)
                    .offset(x: proxy[anchor!].minX)
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomLeading)
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  deleteme2
//
//  Created by Florian Kugler on 16-11-2020.
//

import SwiftUI

extension View {
    var measured: some View {
        overlay(GeometryReader { p in
            Text("\(p.size.width, specifier: "%.2f")")
                .font(.caption)
                .background(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        })
    }
}

struct ContentView: View {
    func items(_ count: Int) -> [Color] {
        (0..<count).map { Color(hue: Double($0)/Double(count), saturation: 0.8, brightness: 1) }
    }

    var body: some View {
        VStack(spacing: 30) {
            let items1 = items(20)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]) {
                ForEach(items1.indices) { idx in
                    items1[idx].frame(height: 50)
                }
            }
            .frame(width: 400)

            let items2 = items(4)
            LazyVGrid(columns: [
                GridItem(.flexible(minimum: 100)),
                GridItem(.flexible(minimum: 180)),
            ]) {
                ForEach(items2.indices) { idx in
                    items2[idx].measured.frame(height: 50)
                }
            }
            .frame(width: 300)
            .border(Color.black)

            let items3 = items(10)
            LazyVGrid(columns: [
                GridItem(.flexible(minimum: 100)),
                GridItem(.adaptive(minimum: 40)),
                GridItem(.flexible(minimum: 180)),
            ]) {
                ForEach(items3.indices) { idx in
                    items3[idx].measured.frame(height: 50)
                }
            }
            .frame(width: 300)
            .border(Color.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  Grids
//
//  Created by Florian Kugler on 16-11-2020.
//

import SwiftUI

let blue = Color(red: 0, green: 146/255.0, blue: 219/255.0)

struct ContentView: View {
    func items(_ count: Int) -> [Color] {
        Array(repeating: blue, count: count)
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
            .border(Color.black)
            .measuredBelow

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
            .measuredBelow

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
            .measuredBelow
        }
    }
}

extension View {
    func measured(_ color: Color) -> some View {
        overlay(GeometryReader { p in
            HStack(spacing: 2) {
                Arrow()
                Text("\(p.size.width, specifier: "%.0f")")
                    .font(.system(size: 14)).bold()
                    .foregroundColor(color)
                    .fixedSize()
                    .frame(maxHeight: .infinity)
                Arrow()
                    .scaleEffect(-1, anchor: .center)
            }
        })
    }
    
    var measured: some View {
        measured(.white)
    }
    
    var measuredBelow: some View {
        self
            .padding(.bottom, 25)
            .overlay(Color.clear.frame(height: 25).measured(.black), alignment: .bottom)
    }
}

struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            let x = rect.minX + 2
            let size: CGFloat = 5
            p.move(to: CGPoint(x: x, y: rect.midY))
            p.addLine(to: CGPoint(x: x + size, y: rect.midY - size))
            p.move(to: CGPoint(x: x, y: rect.midY))
            p.addLine(to: CGPoint(x: x + size, y: rect.midY + size))
            p.move(to: CGPoint(x: x, y: rect.midY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        }
    }
}

struct Arrow: View {
    var body: some View {
        ArrowShape()
            .stroke(lineWidth: 1)
            .foregroundColor(Color(red: 9/255.0, green: 73/255.0, blue: 109/255.0))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

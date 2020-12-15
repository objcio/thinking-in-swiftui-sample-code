//
//  ContentView.swift
//  Tables
//
//  Created by Chris Eidhof on 28.01.20.
//  Copyright © 2020 objc.io. All rights reserved.
//

import SwiftUI

struct WidthPreference: PreferenceKey {
    static let defaultValue: [Int:CGFloat] = [:]
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue(), uniquingKeysWith: max)
    }
}

struct HeightPreference: PreferenceKey {
    static let defaultValue: [Int:CGFloat] = [:]
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue(), uniquingKeysWith: max)
    }
}

extension View {
    func sizePreference(row: Int, column: Int) -> some View {
        background(GeometryReader { proxy in
            Color.clear
                .preference(key: WidthPreference.self, value: [column: proxy.size.width])
		.preference(key: HeightPreference.self, value: [row: proxy.size.height])
        })
    }
}

struct SelectionPreference: PreferenceKey {
    static let defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value ?? nextValue()
    }
}

struct Table<Cell: View>: View {
    var cells: [[Cell]]
    let padding: CGFloat = 5
    @State private var columnWidths: [Int: CGFloat] = [:]
    @State private var columnHeights: [Int: CGFloat] = [:]
    @State private var selection: (row: Int, column: Int)? = nil
    
    func cellFor(row: Int, column: Int) -> some View {
        cells[row][column]
            .sizePreference(row: row, column: column)
            .frame(width: columnWidths[column], height: columnHeights[row], alignment: .topLeading)
            .padding(padding)
    }
    
    func isSelected(row: Int, column: Int) -> Bool {
        guard let s = selection else { return false }
        return s.row == row && s.column == column
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(cells.indices) { row in
                HStack(alignment: .top) {
                    ForEach(self.cells[row].indices) { column in
                        self.cellFor(row: row, column: column)
                            .anchorPreference(key: SelectionPreference.self, value: .bounds) {
                                self.isSelected(row: row, column: column) ? $0 : nil
                            }
                            .background(Color.white.opacity(0.01)) // hack to make the entire cell tappable
                            .onTapGesture {
                                withAnimation(.default) {
                                	self.selection = (row: row, column: column)
                                }
                        	}
                    }
                }
                .background(row.isMultiple(of: 2) ? Color(.secondarySystemBackground) : Color(.systemBackground))

            }
        }
        .onPreferenceChange(WidthPreference.self) { self.columnWidths = $0 }
        .onPreferenceChange(HeightPreference.self) { self.columnHeights = $0 }
        .overlayPreferenceValue(SelectionPreference.self) { SelectionRectangle(anchor: $0) }
    }
}

struct SelectionRectangle: View {
    let anchor: Anchor<CGRect>?
    var body: some View {
        GeometryReader { proxy in
            if let rect = self.anchor.map({ proxy[$0] }) {
                Rectangle()
                    .fill(Color.clear)
                    .border(Color.blue, width: 2)
                    .offset(x: rect.minX, y: rect.minY)
                    .frame(width: rect.width, height: rect.height)
            }
        }
    }
}

struct ContentView: View {
    var cells = [
        [Text(""), Text("Monday").bold(), Text("Tuesday").bold(), Text("Wednesday").bold()],
        [Text("Berlin").bold(), Text("Cloudy"), Text("Mostly\nSunny"), Text("Sunny")],
        [Text("London").bold(), Text("Heavy Rain"), Text("Cloudy"), Text("Sunny")],
    ]
    
    var body: some View {
        Table(cells: cells)
            .font(Font.system(.body, design: .serif))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import SwiftUI

struct CollectSizePreference: PreferenceKey {
    static let defaultValue: [Int:CGSize] = [:]
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct CollectSize: ViewModifier {
    var index: Int
    func body(content: Content) -> some View {
        content.background(GeometryReader { proxy in
            Color.clear.preference(key: CollectSizePreference.self, value: [self.index:proxy.size])
        })
    }
}

struct Stack<Element, Content: View> {
    var data: [Element]
    var spacing: CGFloat = 8
    var axis: Axis = .horizontal
    var alignment: Alignment = .center
    var content: (Element) -> Content
    @State private var offsets: [CGPoint] = []
}

extension Stack {
    private func offset(index: Int) -> CGPoint {
        guard index < offsets.endIndex else { return .zero }
        return offsets[index]
    }
}

extension Stack {
    private func computeOffsets(sizes: [Int:CGSize]) {
        guard !sizes.isEmpty else { return }
        
        var offsets: [CGPoint] = [.zero]
        for i in 0..<self.data.count {
            guard let size = sizes[i] else { fatalError() }
            var newPoint = offsets.last!
            newPoint.x += size.width + self.spacing
            newPoint.y += size.height + self.spacing
            offsets.append(newPoint)
        }
        self.offsets = offsets
    }
}

extension Stack: View {
    var body: some View {
        ZStack(alignment: alignment) {
            ForEach(data.indices, content: { ix in
                self.content(self.data[ix])
                    .modifier(CollectSize(index: ix))
                    .alignmentGuide(self.alignment.horizontal, computeValue: {
                        self.axis == .horizontal ? -self.offset(index: ix).x : $0[self.alignment.horizontal]
                    })
                    .alignmentGuide(self.alignment.vertical, computeValue: {
                        self.axis == .vertical ? -self.offset(index: ix).y : $0[self.alignment.vertical]
                    })
            })
        }
        .onPreferenceChange(CollectSizePreference.self, perform: self.computeOffsets)
    }
}

struct ContentView: View {
    let colors: [(Color, CGFloat)] = [(.red, 50), (.green, 30), (.blue, 75)]
    @State var horizontal: Bool = true
    var body: some View {
        VStack {
            Button(action: {
                withAnimation(.default) {
                    self.horizontal.toggle()
                }
            }) { Text("Toggle axis") }
            Spacer()
            Stack(data: colors,
                  axis: horizontal ? .horizontal : .vertical) { item in
                Rectangle()
                    .fill(item.0)
                    .frame(width: item.1, height: item.1)
            }
            .border(Color.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

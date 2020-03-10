import SwiftUI

let sampleData: [CGFloat] = [0.1, 0.7, 0.3, 0.6, 0.45, 1.1]

struct LineGraph: Shape {
    var dataPoints: [CGFloat]
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            guard dataPoints.count > 1 else { return }
            let start = dataPoints[0]
            p.move(to: CGPoint(x: 0, y: (1-start) * rect.height))
            for (offset, point) in dataPoints.enumerated() {
                let x = rect.width * CGFloat(offset) / CGFloat(dataPoints.count - 1)
                let y = (1-point) * rect.height
                p.addLine(to: CGPoint(x: x, y: y))
            }
        }
    }
}

fileprivate struct PositionOnShapeEffect: GeometryEffect {
    var path: Path
    var at: CGFloat
    
    var animatableData: CGFloat {
        get { at }
        set { at = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let trimmed = path.trimmedPath(from: 0, to: at == 0 ? 0.00001 : at)
        let point = trimmed.currentPoint ?? .zero
        return ProjectionTransform(.init(translationX: point.x - size.width/2, y: point.y - size.height/2))
    }
}

extension View {
    func position<S: Shape>(on shape: S, at amount: CGFloat) -> some View {
        GeometryReader { proxy in
            self
                .modifier(PositionOnShapeEffect(path: shape.path(in: CGRect(origin: .zero, size: proxy.size)), at: amount))
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
        }
    }
}

struct ContentView: View {
    @State var visible = false
    
    let graph = LineGraph(dataPoints: sampleData)
    
    var body: some View {
        VStack {
            ZStack {
                graph
                    .trim(from: 0, to: visible ? 1 : 0)
                    .stroke(Color.red, lineWidth: 2)
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                    .position(on: graph, at: visible ? 1 : 0)
            }
            .aspectRatio(16/9, contentMode: .fit)
            .border(Color.gray, width: 1)
            .padding()
            Button(action: {
                withAnimation(Animation.easeInOut(duration: 2)) {
                    self.visible.toggle()
                }
            }) { Text("Animate") }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

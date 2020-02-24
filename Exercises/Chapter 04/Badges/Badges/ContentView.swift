import SwiftUI

extension View {
    func badge(count: Int) -> some View {
        overlay(
            ZStack {
                if count != 0 {
                    Circle()
                        .fill(Color.red)
                    Text("\(count)")
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
            .offset(x: 12, y: -12)
            .frame(width: 24, height: 24)
        , alignment: .topTrailing)
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello")
            .padding(10)
            .background(Color.gray)
            .badge(count: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

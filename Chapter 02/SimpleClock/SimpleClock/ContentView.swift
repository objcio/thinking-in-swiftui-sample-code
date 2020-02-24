//
//  ContentView.swift
//  SimpleClock
//
//  Created by Chris Eidhof on 05.11.19.
//  Copyright © 2019 Chris Eidhof. All rights reserved.
//

import SwiftUI
import Combine

final class CurrentTime: ObservableObject {
    @Published var now: Date = Date()
    
    let interval: TimeInterval = 1
    private var timer: Timer? = nil
    init() {
    }
    
    func start() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self] _ in
            self?.now = Date()
        })
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stop()
    }
}

struct TimerView: View {
    @ObservedObject var date = CurrentTime()
    
    var body: some View {
        Text("\(date.now)")
            .onAppear { self.date.start() }
            .onDisappear { self.date.stop() }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: TimerView(), label: {
                Text("Go to timer")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

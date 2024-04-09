//
//  ContentView.swift
//  Flashzilla
//
//  Created by enesozmus on 9.04.2024.
//

import SwiftUI

// → The only complex part of our next code is how we position the cards inside the card stack so they have slight overlapping.
// → In this case we’re going to create a new stacked() modifier that takes a position in an array along with the total size of the array, and offsets a view by some amount based on those values.
// → This will allow us to create an attractive card stack where each card is a little further down the screen than the ones before it.
extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

struct ContentView: View {
    // → Now that we’ve designed one card and its associated card view, the next step is to build a stack of those cards to represent the things our user is trying to learn.
    // → This stack will change as the app is used because the user will be able to remove cards, so we need to mark it with @State.
    @State private var cards = Array<Card>(repeating: .example, count: 10)
    
    var body: some View {
        // → Around that VStack will be another ZStack, so we can place our cards and timer on top of a background.
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            // → Around that ZStack will be a VStack. Right now that VStack won’t do much, but later on it will allow us to place a timer above our cards.
            VStack {
                // → Our stack of cards will be placed inside a ZStack so we can make them partially overlap with a neat 3D effect.
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                    }
                }
            }
        }
    }
    
    // ...
    func removeCard(at index: Int) {
        cards.remove(at: index)
    }
}

#Preview {
    ContentView()
}

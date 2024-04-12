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
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    var body: some View {
        // → Around that VStack will be another ZStack, so we can place our cards and timer on top of a background.
        ZStack {
            // → Our UI is a bit of a mess when used with VoiceOver.
            // → Make small swipes to the right and VoiceOver will move through all the accessibility elements – it reads out the text from all our cards, even the ones that aren’t visible.
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            // → Around that ZStack will be a VStack. Right now that VStack won’t do much, but later on it will allow us to place a timer above our cards.
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                // → Our stack of cards will be placed inside a ZStack so we can make them partially overlap with a neat 3D effect.
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        // → So that only the last card – the one on top – can be dragged around.
                        .allowsHitTesting(index == cards.count - 1)
                        // → In this case, every card that’s at an index less than the top card should be hidden from the accessibility system because there’s really nothing useful it can do with the card.
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                // → SwiftUI lets us disable interactivity for a view by setting allowsHitTesting() to false, so in our project we can use it to disable swiping on any card when the time runs out by checking the value of timeRemaining.
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
            }
            
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {    
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
    }
    
    // ...
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        cards = Array<Card>(repeating: .example, count: 10)
        timeRemaining = 100
        isActive = true
    }
    
}

#Preview {
    ContentView()
}

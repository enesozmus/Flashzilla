//
//  Card.swift
//  Flashzilla
//
//  Created by enesozmus on 9.04.2024.
//

import Foundation

// → In this project we want users to see a card with some prompt text for whatever they want to learn, such as “What is the capital city of Scotland?”
// → , and when they tap it we’ll reveal the answer, which in this case is of course Edinburgh.

// → A sensible place to start for most projects is to define the data model we want to work with: what does one card of information look like?
// → If you wanted to take this app further you could store some interesting statistics such as number of times shown and number of times correct, but here we’re only going to store a string for the prompt and a string for the answer.
struct Card: Codable, Identifiable, Equatable {
    var id = UUID()
    var prompt: String
    var answer: String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}

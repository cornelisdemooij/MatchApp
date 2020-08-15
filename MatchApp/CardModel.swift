//
//  CardModel.swift
//  MatchApp
//
//  Created by Cornelis de Mooij on 14/08/2020.
//  Copyright © 2020 Cornelis de Mooij. All rights reserved.
//

import Foundation

class CardModel {
    func getCards() -> [Card] {
        // Declare empty random number array
        var randomNumbers = [Int]()
        
        // Declare empty cards array
        var generatedCards = [Card]()
        
        // Randomly generate 8 pairs of cards
        while generatedCards.count < 2*8 {
            // Generate a random number
            let randomNumber = Int.random(in: 1...13)
                        
            // Check that the random number doesn't exist yet
            if (!randomNumbers.contains(randomNumber)) {
                // Add the new random number to the array
                randomNumbers.append(randomNumber)
                
                // Create two new card objects
                let cardOne = Card()
                let cardTwo = Card()
                
                // Set their image names
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                
                // Add them to the array
                generatedCards += [cardOne, cardTwo]
            }
        }
        
        // Randomize the cards within the array
        generatedCards.shuffle()
        
        // Return the array
        return generatedCards
    }
}

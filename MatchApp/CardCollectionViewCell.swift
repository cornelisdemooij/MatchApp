//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Cornelis de Mooij on 14/08/2020.
//  Copyright © 2020 Cornelis de Mooij. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card:Card) {
        
        // Keep trakc of the card that this cell represents
        self.card = card
        
        // Set the front image view to the image that represents the card
        frontImageView.image = UIImage(named: card.imageName)
        
        // Reset the state of the cell by checking the flipped status of the card and then showing the front or the back imageview accordingly
        if card.isFlipped == true {
            // Show the front image view
            flipUp(timeInterval: TimeInterval(0))
        } else {
            // Show the back image view
            flipDown(timeInterval: TimeInterval(0))
        }
    }
    
    func flipUp(timeInterval:TimeInterval = 0.3) {
        UIView.transition(from: backImageView, to: frontImageView, duration: timeInterval, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        card?.isFlipped = true
    }
    
    func flipDown(timeInterval:TimeInterval = 0.3) {
        UIView.transition(from: frontImageView, to: backImageView, duration: timeInterval, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        card?.isFlipped = false
    }
    
    func flipToggle(timeInterval:TimeInterval = 0.3) {
        if let actualCard = card {
            if actualCard.isFlipped {
                flipDown(timeInterval: timeInterval)
            } else {
                flipUp(timeInterval: timeInterval)
            }
        }
    }
    
}

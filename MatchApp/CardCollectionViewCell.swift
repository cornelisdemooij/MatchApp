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
        if card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        } else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        if card.isFlipped == true {
            // Show the front image view
            flipUp(timeInterval: TimeInterval(0))
        } else {
            // Show the back image view
            flipDown(timeInterval: TimeInterval(0), delay: TimeInterval(0))
        }
    }
    
    func flipUp(timeInterval:TimeInterval = 0.3) {
        UIView.transition(from: backImageView, to: frontImageView, duration: timeInterval, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        card?.isFlipped = true
    }
    
    func flipDown(timeInterval:TimeInterval = 0.3, delay:TimeInterval = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: timeInterval, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        
        card?.isFlipped = false
    }
    
    func remove() {
        // Make the image views invisible
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}

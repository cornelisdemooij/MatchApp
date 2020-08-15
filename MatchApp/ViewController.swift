//
//  ViewController.swift
//  MatchApp
//
//  Created by Cornelis de Mooij on 14/08/2020.
//  Copyright © 2020 Cornelis de Mooij. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer:Timer?
    var milliseconds:Int = 100 * 1000
    
    var firstFlippedCardIndex:IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        // Set the view controller as the datasource and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    // MARK: - Timer Methods
    @objc func timerFired() {
        // Decrement the counter
        milliseconds -= 1
        
        // Update the label
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        // Stop the timer if it reaches zero
        if milliseconds <= 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            checkForGameEnd()
        }
        
        // TODO: Check if the user has cleared all the pairs
    }
    
    // MARK: - Collection View Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell

        // Return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Configure the state of the cell based on the properties of the Card that it represents
        
        let cardCell = cell as? CardCollectionViewCell
        
        // get the card from the card array
        let card = cardsArray[indexPath.row]
        
        // Configure it
        cardCell?.configureCell(card: card)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            cell?.flipUp()
            
            // Check if this is the first card that was flipped or the second card
            if firstFlippedCardIndex == nil {
                // This is the first card flipped over
                firstFlippedCardIndex = indexPath
            } else {
                // Second card that is flipped
                
                // Run the comparison logic
                checkForMatch(indexPath)
            }
        }
    }
    
    // MARK: - Game Logic Methods
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        // Get the two card objects for the two indices and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row]
        let cardTwo = cardsArray[secondFlippedCardIndex.row]
        
        // Get the two collection view cells that represent card one and two
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            // It's a match
            
            // Set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            firstFlippedCardIndex = nil
            
            // Was that the last pair?
            checkForGameEnd()
        } else {
            // It's not a match
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip them back over
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            
            firstFlippedCardIndex = nil
        }
    }
    
    func checkForGameEnd() {
        // Check if there's any card that is not matched
        var hasWon = true
        for card in cardsArray {
            if card.isMatched == false {
                // We've found a card that is unmatched
                hasWon = false
                break
            }
        }
        
        if hasWon {
            // User has won
            
            // Stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.systemGreen
            
            // Show an alert
            showAlert(title: "Congratulations!", message: "You've won the game!")
        } else {
            // User hasn't won yet, check if there's any time left
            if milliseconds <= 0 {
                showAlert(title: "Time's up", message: "Sorry, better luck next time!")
            }
        }
    }

    func showAlert(title:String, message:String) {
        // Create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add a button for the user to dismiss it
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Show the alert
        present(alert, animated: true, completion: nil)
    }
}


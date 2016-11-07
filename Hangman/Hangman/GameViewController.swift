//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//
import UIKit


class GameViewController: UIViewController {
    
        
    let images = [#imageLiteral(resourceName: "hangman1.gif"), #imageLiteral(resourceName: "hangman2.gif"), #imageLiteral(resourceName: "hangman3.gif"), #imageLiteral(resourceName: "hangman4.gif"), #imageLiteral(resourceName: "hangman5.gif"), #imageLiteral(resourceName: "hangman6.gif"), #imageLiteral(resourceName: "hangman7.gif")]

    
    var phrase = ""
    
    @IBOutlet weak var puzzleString: UILabel!
    @IBOutlet weak var guess: UITextField!
    @IBOutlet weak var hangmanImage: UIImageView!
    
    @IBOutlet weak var incorrectGuesses: UILabel!
    @IBOutlet weak var numIncorrectGuesses: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
        
        incorrectGuesses.text = ""
        numIncorrectGuesses.text = String(0)
        var puzzleStringText = ""
        for char:Character in phrase.characters {
            if char == " " {
                puzzleStringText += " "
            } else {
                puzzleStringText += "-"
            }
        }
        puzzleString.text = puzzleStringText
        drawHangman()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressGuess(_ sender: UIButton) {
        print(phrase)
        updateGuess()
        drawHangman()
    }
    
    
    func updateGuess() {
        let g = guess.text?.characters.last
        let guessedLetter = "\(g!)".uppercased()
        if phrase.contains(guessedLetter) {
            var displayStr = ""
            
            for (index, char) in (puzzleString.text?.characters.enumerated())! {
                if phrase[index] == guessedLetter {
                    displayStr += phrase[index]
                } else if "\(char)" == "-" {
                    displayStr += "-"
                } else {
                    displayStr += phrase[index]
                }
            }
            puzzleString.text = displayStr
        } else {
            let badGuesses:String = incorrectGuesses.text! + guessedLetter
            incorrectGuesses.text = badGuesses
            let newNumIncorrect = Int(numIncorrectGuesses.text!)! + 1
            numIncorrectGuesses.text = "\(newNumIncorrect)"
        }
        isOver()
    }
    
    func isOver() {
        let victory = !(puzzleString.text?.contains("-"))!
        if victory {
            let alertController = UIAlertController(title: "Correct!", message:
                "Nice Work", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.default,handler: resetGame))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func resetGame(alert: UIAlertAction!) {
        viewDidLoad()
        viewWillAppear(true)
    }
    
    func drawHangman() {
        let numIncorrect = Int(numIncorrectGuesses.text!)
        if numIncorrect! > 6 {
            let alertController = UIAlertController(title: "You Lose!", message:
                "The answer was \n" + phrase, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.default,handler: resetGame))
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            hangmanImage.image = images[numIncorrect!]
        }
    }
    
}

//extension allows access of substring in string as characters, 
extension String {
    subscript(i: Int) -> String {
        guard i >= 0 && i < characters.count else { return "" }
        return String(self[index(startIndex, offsetBy: i)])
    }
    subscript(range: Range<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return substring(with: lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex))
    }
    subscript(range: ClosedRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return substring(with: lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex))
    }
}

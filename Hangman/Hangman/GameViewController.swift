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
    var phraseArray:[Character] = []

    
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
            phraseArray.append(char)
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
        let guessedLetter = String(g!).uppercased()
        if phrase.contains(guessedLetter) {
            var displayStr = ""
            
            for (index, char) in (puzzleString.text?.characters.enumerated())! {
                if String(phraseArray[index]) == guessedLetter {
                    displayStr += String(phraseArray[index])
                } else if String(char) == "-" {
                    displayStr += "-"
                } else {
                    displayStr += String(phraseArray[index])
                }
            }
            puzzleString.text = displayStr
        } else {
            let badGuesses:String = incorrectGuesses.text! + guessedLetter
            incorrectGuesses.text = badGuesses
            let newNumIncorrect = Int(numIncorrectGuesses.text!)! + 1
            numIncorrectGuesses.text = String(newNumIncorrect)
        }
        let hasWon = !(puzzleString.text?.contains("-"))!
        if hasWon {
            let alert = UIAlertController(title: "Correct!", message:
                "Nice Work", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.default,handler: resetGame))
            self.present(alert, animated: true, completion: nil)
        }
        guess.text = ""
    }
    
    func resetGame(alert: UIAlertAction!) {
        phraseArray.removeAll()
        viewDidLoad()
        viewWillAppear(true)
    }
    
    func drawHangman() {
        let numIncorrect = Int(numIncorrectGuesses.text!)
        if numIncorrect! > 6 {
            let alert = UIAlertController(title: "You Lose!", message:
                "The answer was \n" + phrase, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.default,handler: resetGame))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            hangmanImage.image = images[numIncorrect!]
        }
    }
    
}


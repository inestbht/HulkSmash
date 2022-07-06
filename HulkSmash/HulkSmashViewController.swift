//
//  HulkSmashViewController.swift
//  HulkSmash
//
//  Created by Samuel Pena on 7/5/22.
//

import UIKit
import GameplayKit

class HulkSmashViewController: UIViewController {
    
    var selection: String!
    let randomSelection = GKRandomDistribution(lowestValue: 0, highestValue: 2)
    
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var tieScore: UILabel!
    @IBOutlet weak var hulkScore: UILabel!
    @IBOutlet weak var hulkSelection: UILabel!
    @IBOutlet weak var statusMessage: UILabel!
    @IBOutlet weak var userSelection: UILabel!
    @IBOutlet weak var rockButton: UIButton!
    @IBOutlet weak var paperButton: UIButton!
    @IBOutlet weak var scissorsButton: UIButton!
    @IBOutlet weak var resetScoreButton: UIButton!
    
    let defaults: UserDefaults = UserDefaults.standard
    var userScoreInt: Int!
    var tieScoreInt: Int!
    var hulkScoreInt: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        userScoreInt = Int(defaults.integer(forKey: InitialScores.initialUserScore))
        tieScoreInt = Int(defaults.integer(forKey: InitialScores.initialTieScore))
        hulkScoreInt = Int(defaults.integer(forKey: InitialScores.initialHulkScore))
        resetScoreButton.isHidden = true
        updateScores()
        resetScores()
    }

    @IBAction func rockButtonPressed(_ sender: UIButton) {
        selection = "👊"
        getResult()
    }
    
    @IBAction func paperButtonPressed(_ sender: UIButton) {
        selection = "✋"
        getResult()
    }
    
    @IBAction func scissorsButtonPressed(_ sender: UIButton) {
        selection = "✌️"
        getResult()
    }
    
    @IBAction func resetScoreButtonPressed(_ sender: UIButton) {
        resetScores()
    }
    
    func getResult() {
        rockButton.isHidden = true
        paperButton.isHidden = true
        scissorsButton.isHidden = true
        hulkSelection.text = randomAction().rawValue
        userSelection.isHidden = false
        userSelection.text = selection
        resetScoreButton.isHidden = true
        statusMessage.text = runLogic(user: selection, computer: hulkSelection.text!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.resetItems()
        })
    }
    
    
    func randomAction() -> Action {
        let action = randomSelection.nextInt()
        if action == 0 {
            return .rock
        } else if action == 1 {
            return .paper
        } else {
            return .scissors
        }
    }
    
    func runLogic(user: String, computer: String) -> String {
        if user == computer {
            tieScoreInt = tieScoreInt + 1
            defaults.set(tieScoreInt, forKey: InitialScores.initialTieScore)
            updateScores()
            self.view.backgroundColor = UIColor.systemYellow
            return "Tie!"
        } else if (user == "👊" && computer == "✋") || (user == "✋" && computer == "✌️") || (user == "✌️" && computer == "👊") {
            UIView.animate(withDuration: 0.6, animations: { () -> Void in
                self.view.backgroundColor = UIColor.red
            })
            setWhiteLabels()
            hulkScoreInt = hulkScoreInt + 1
            defaults.set(hulkScoreInt, forKey: InitialScores.initialHulkScore)
            updateScores()
            return "Hulk Smash!"
        } else {
            UIView.animate(withDuration: 0.6, animations: { () -> Void in
                self.view.backgroundColor = #colorLiteral(red: 0.5452152491, green: 0.6792706847, blue: 0.347515136, alpha: 1)
            })
            setWhiteLabels()
            userScoreInt = userScoreInt + 1
            defaults.set(userScoreInt, forKey: InitialScores.initialUserScore)
            updateScores()
            return "You Win!"
        }
    }

    func setWhiteLabels() {
        UIView.animate(withDuration: 0.6, animations: { () -> Void in
            self.userScore.textColor = UIColor.white
            self.hulkScore.textColor = UIColor.white
            self.tieScore.textColor = UIColor.white
            self.statusMessage.textColor = UIColor.white
        })
    }
    
    func resetItems() {
        UIView.animate(withDuration: 0.6, animations: { () -> Void in
            self.view.backgroundColor = #colorLiteral(red: 0.3089209795, green: 0.3978866935, blue: 0.3136435747, alpha: 1)
            self.userScore.textColor = UIColor.black
            self.hulkScore.textColor = UIColor.black
            self.tieScore.textColor = UIColor.black
            self.statusMessage.textColor = #colorLiteral(red: 0.1706000417, green: 0.1706000417, blue: 0.1706000417, alpha: 1)
        })
        rockButton.isHidden = false
        paperButton.isHidden = false
        scissorsButton.isHidden = false
        userSelection.isHidden = true
        hulkSelection.text = "🤖"
        statusMessage.text = "Hulk Smash?"
        resetScoreButton.isHidden = false
    }
    
    func updateScores() {
        userScore.text = "You: \(Int(userScoreInt))"
        tieScore.text = "Draw: \(Int(tieScoreInt))"
        hulkScore.text = "Hulk: \(Int(hulkScoreInt))"
        
    }
    
    func resetScores() {
        userScoreInt = 0
        tieScoreInt = 0
        hulkScoreInt = 0
        updateScores()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}


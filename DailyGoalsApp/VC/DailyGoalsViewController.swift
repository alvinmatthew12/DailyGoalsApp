//
//  DailyGoalsViewController.swift
//  DailyGoalsApp
//
//  Created by Alvin Matthew Pratama on 10/04/20.
//  Copyright © 2020 Alvin Matthew Pratama. All rights reserved.
//

import UIKit

class DailyGoalsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var contentCard: UIView!
    @IBOutlet weak var goalsTextView: UITextView!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var quotesTextView: UITextView!
    
    let defaults = UserDefaults.standard
    
    struct Keys {
        static let goals = "goals"
    }

    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
    
    var quotes = [
        "Setting goals is the first step in turning the invisible into the visible\n\n- Tony Robbins -",
        "With the new day comes new strength and new thoughts.\n\n- Eleanor Roosevelt -",
        "Some people dream of success while others wake up and work.\n\n- Unknown -",
        "Opportunities don't happen. You create them.\n\n- Chris Grosser -",
    ]
    
    var hasGoal:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentCard.layer.cornerRadius = 70
        contentCard.layer.maskedCorners = [.layerMaxXMinYCorner]
        
        goalsTextView.delegate = self
        goalsTextView.text = "E.g. I want to write at least 2000 words today"
        goalsTextView.textColor = UIColor.lightGray
        goalsTextView.layer.cornerRadius = 4
        goalsTextView.backgroundColor = UIColor.white
        goalsTextView.returnKeyType = UIReturnKeyType.done
        
        setButton.layer.cornerRadius = 25
        setButton.layer.borderWidth = 3.0
        setButton.layer.borderColor = UIColor.white.cgColor
        
        quotes.shuffle()
        quotesTextView.text = quotes[0]
        
        if(hasGoal == 1) {
            checkForSaveGoals()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "E.g. I want to write at least 2000 words today"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func setButtonTapped(_ sender: Any) {
        if (goalsTextView.text == "E.g. I want to write at least 2000 words today") {
            showEmptyGoalAlert()
        } else {
            saveGoals()
            nextStep()
        }
    }
    
    func saveGoals() {
        defaults.set(goalsTextView.text!, forKey: Keys.goals)
    }
    
    func nextStep() {
        let vc = storyBoard.instantiateViewController(withIdentifier: "ToDoView") as! ToDoViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func checkForSaveGoals() {
        let goals = defaults.value(forKey: Keys.goals) as? String ?? ""
        goalsTextView.text = goals
        goalsTextView.textColor = UIColor.black
//        goalsTextView.isEditable = false
    }
    
    func showEmptyGoalAlert() {
        let alert = UIAlertController(title: "Empty Goal", message: "Let's set your daily goals first.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

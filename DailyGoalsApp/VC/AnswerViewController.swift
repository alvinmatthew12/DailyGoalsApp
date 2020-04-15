//
//  AnswerViewController.swift
//  DailyGoalsApp
//
//  Created by Alvin Matthew Pratama on 12/04/20.
//  Copyright © 2020 Alvin Matthew Pratama. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var encouragementLabel: UILabel!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var cheerButton: UIButton!
    @IBOutlet weak var celebrateLabel: UILabel!
    
    var toDoList = [Todo]()
    
    var isAchieved: Int = 0
    
    let defaults = UserDefaults.standard
    
    struct Keys {
        static let goals = "goals"
        static let todo = "todo"
    }
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
    
    var successQuotes = [
        "I survived because the fire inside me burned brighter than the fire around me\n\n- Joshua Graham -",
        "There are two ways to get enough. One is to continue to accumulate more and more. The other is to desire less.\n\n- G.K Chesterton -",
        "You know you are on the road to success if you would do your job, and not be paid for it.\n\n - Oprah Winfrey -",
        "There is a powerful driving force inside every human being that, once unleashed, can make any vision, dream, or desire reality.\n- Anthony Robbins -"
        
    ]
    
    var failureQuotes = [
        "I've missed more than 9000 shots in my career. I've lost almost 300 games. 26 times, I've been trusted to take the game winning shot and missed. I've failed over and over and over again in my life. And that is why I succeed.\n\n- Michael Jordan -",
        "Many of life's failures are people who did not realize how close they were to success when they gave up.\n\n- Thomas Edison -",
        "I never did anything worth doing by accident, nor did any of my inventions come indirectly through accident, except the phonograph. No, when I have fully decided that a result is worth getting, I go about it, and make trial after trial, until it comes.\n\n - Thomas Edison -",
        "Keep on going, and the chances are that you will stumble on something, perhaps when you are least expecting it. I never heard of anyone ever stumbling on something sitting down.\n\n- Charles F. Kettering -",
        "All progress takes place outside the comfort zone.\n\n- Michael John Bobak -",
    ]
    
    var todoCount:Int = 0;
    var todoIndex:Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let backgroundImage = UIImage.init(named: "bgimage-full")
        let backgroundImageView = UIImageView.init(frame: self.view.frame)

        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 1

        self.view.insertSubview(backgroundImageView, at: 0)
        
        cheerButton.layer.cornerRadius = 25
        cheerButton.layer.borderWidth = 3.0
        cheerButton.layer.borderColor = UIColor.white.cgColor

        successQuotes.shuffle()
        failureQuotes.shuffle()
        
        if(isAchieved == 1) {
            encouragementLabel.text = "Good Job!"
            quoteTextView.text = successQuotes[0]
        }
        else if (isAchieved == 2) {
            encouragementLabel.text = "Never Give Up"
            quoteTextView.text = failureQuotes[0]
        }
        
        if(todoCount == todoIndex + 1) {
            celebrateLabel.text = "let's celebrate today"
        } else {
            celebrateLabel.text = "let's celebrate for a while"
        }
        
        
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        do {
            let toDo = try PersistenceService.context.fetch(fetchRequest)
            self.toDoList = toDo
        } catch {}
        todoCount = toDoList.count
    }

    @IBAction func onCheerTapped(_ sender: Any) {
        if(todoCount == todoIndex + 1) {
            resetGoal()
            resetTodo()
            backToInitiate()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            if let vc = storyboard?.instantiateViewController(withIdentifier: "homeView") as? HomeViewController {
                vc.notifications.removeAll()
            }
        } else {
            backToHome()
        }
    }
    
    
    func resetGoal() {
        defaults.removeObject(forKey: "goals")
        defaults.removeObject(forKey: "todo")
        defaults.synchronize()
    }
    
    func resetTodo() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try PersistenceService.context.execute(batchDeleteRequest)
        } catch {
            print("Failed to reset Todo")
        }
    }
    
    func backToInitiate() {
        let vc = storyBoard.instantiateViewController(withIdentifier: "DailyGoalsView") as! DailyGoalsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func backToHome() {
        let vc = storyBoard.instantiateViewController(withIdentifier: "homeView") as! HomeViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

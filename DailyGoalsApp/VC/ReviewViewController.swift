//
//  ReviewViewController.swift
//  DailyGoalsApp
//
//  Created by Alvin Matthew Pratama on 12/04/20.
//  Copyright © 2020 Alvin Matthew Pratama. All rights reserved.
//

import UIKit
import CoreData

class ReviewViewController: UIViewController {

    @IBOutlet weak var goalsTitleCard: UIView!
    @IBOutlet weak var myGoalsTextView: UITextView!
    @IBOutlet weak var reviewCardBody: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var timeLabel: UILabel!
    
    let defaults = UserDefaults.standard
    
    var todoIndex:Int = 0
    
    struct Keys {
        static let goals = "goals"
    }
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
    
    var toDoList = [Todo]()
    
    var toDoText:String = ""
    var timeText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkForSaveGoals()
        
        goalsTitleCard.layer.cornerRadius = 12
        reviewCardBody.layer.cornerRadius = 70
        reviewCardBody.layer.maskedCorners = [.layerMaxXMinYCorner]
        yesButton.layer.cornerRadius = 25
        yesButton.layer.borderWidth = 3.0
        yesButton.layer.borderColor = UIColor.systemTeal.cgColor
        noButton.layer.cornerRadius = 25
        
        // Do any additional setup after loading the view.
        navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = .clear
        
        myGoalsTextView.text = toDoText
        timeLabel.text = timeText
    }
    
    func checkForSaveGoals() {
        let goals = defaults.value(forKey: Keys.goals) as? String ?? ""
        myGoalsTextView.text = goals
    }
    
    @IBAction func onYesTapped(_ sender: Any) {
        answer(isAchieved: 1)
        update(status: "success")
    }
    
    @IBAction func onNoTapped(_ sender: Any) {
        answer(isAchieved: 2)
        update(status: "failed")
    }
    
    func answer(isAchieved: Int) {
        let vc = storyBoard.instantiateViewController(withIdentifier: "answerView") as! AnswerViewController
        vc.modalPresentationStyle = .fullScreen
        vc.isAchieved = isAchieved
        vc.todoIndex = todoIndex
        self.present(vc, animated: true, completion: nil)
    }
    
    func update(status: String){
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        do {
            let toDo = try PersistenceService.context.fetch(fetchRequest)
            self.toDoList = toDo
        } catch {}
        
        let firstTodo = toDoList[todoIndex]
        firstTodo.status = status
        do {
            try PersistenceService.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }

}

//
//  ToDoViewController.swift
//  DailyGoalsApp
//
//  Created by Alvin Matthew Pratama on 11/04/20.
//  Copyright © 2020 Alvin Matthew Pratama. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController {
    
//    @IBOutlet weak var cardHeader: UIView!
//    @IBOutlet weak var goalsCardHeader: UIView!
//    @IBOutlet weak var myGoalsTextView: UITextView!
//    @IBOutlet weak var addListButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var isTodoEmptyLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    var toDoList = [Todo]()
    
    let defaults = UserDefaults.standard
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
    
    struct Keys {
        static let goals = "goals"
        static let todo = "todo"
    }
    
    let cellIdentifier = "TodoTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = .clear
        navigationBar.prefersLargeTitles = true
//        
        // Do any additional setup after loading the view.
//        cardHeader.layer.cornerRadius = 70
//        cardHeader.layer.maskedCorners = [.layerMaxXMinYCorner]
//        goalsCardHeader.layer.cornerRadius = 12
//        goalsCardHeader.layer.maskedCorners = [.layerMaxXMinYCorner]
//        addListButton.layer.cornerRadius = 6
        finishButton.layer.cornerRadius = 25
        finishButton.layer.borderWidth = 3.0
        finishButton.layer.borderColor = UIColor.systemTeal.cgColor
        
//        checkForSaveGoals()
        
        //fetch CoreData
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        var startSort = NSSortDescriptor(key: "start", ascending: true)
        fetchRequest.sortDescriptors = [startSort]
        do {
            let toDo = try PersistenceService.context.fetch(fetchRequest)
            self.toDoList = toDo
            self.tableView.reloadData()
            if toDo.isEmpty {
                isTodoEmptyLabel.isHidden = false
            } else {
                isTodoEmptyLabel.isHidden = true
            }
        } catch {}
        
    }
    
    @IBAction func onBackTapped(_ sender: Any) {
        backToGoals()
    }
    
    @IBAction func onFinishTapped(_ sender: Any) {
        if(toDoList.count > 0) {
            showFinishAlert()
        } else {
            showEmptyTodoAlert()
        }
    }
    
//    func checkForSaveGoals() {
//        let goals = defaults.value(forKey: Keys.goals) as? String ?? ""
//        myGoalsTextView.text = goals
//    }
    
    func finish() {
        defaults.set("todo", forKey: Keys.todo)
        let vc = storyBoard.instantiateViewController(withIdentifier: "homeView") as! HomeViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func showEmptyTodoAlert() {
        let alert = UIAlertController(title: "Empty Schedule", message: "Let's arrage your to do schedule first.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showFinishAlert() {
        let alert = UIAlertController(title: "Finish", message: "Are you sure you are finish?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(_: UIAlertAction!) in
            self.finish()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {(_: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

extension ToDoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellIdentifier") as? CustomCell {
            cell.configureCell(item: toDoList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PersistenceService.context.delete(toDoList[indexPath.row])
            do {
                try PersistenceService.context.save()
                tableView.reloadData()
                viewDidLoad()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func backToGoals() {
        let vc = storyBoard.instantiateViewController(withIdentifier: "DailyGoalsView") as! DailyGoalsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.hasGoal = 1
        self.present(vc, animated: true, completion: nil)
    }
}

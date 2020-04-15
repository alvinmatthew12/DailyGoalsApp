//
//  AddToDoViewController.swift
//  DailyGoalsApp
//
//  Created by Alvin Matthew Pratama on 11/04/20.
//  Copyright © 2020 Alvin Matthew Pratama. All rights reserved.
//

import UIKit
import CoreData

class AddToDoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var toDoTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker?
    @IBOutlet weak var untilDatePicker: UIDatePicker?
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var toDoList = [Todo]()
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
    
    var startTime:String = "09:00"
    var endTime:String = "09:00"
    var todoId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addButton.layer.cornerRadius = 25
        addButton.layer.borderWidth = 3.0
        addButton.layer.borderColor = UIColor.white.cgColor

        toDoTextField.layer.borderWidth = 1.0
        toDoTextField.layer.borderColor = UIColor.lightGray.cgColor
        toDoTextField.layer.cornerRadius = 4
        toDoTextField.setLeftPaddingPoints(10)
        toDoTextField.delegate = self
        toDoTextField.returnKeyType = .done
        toDoTextField.attributedPlaceholder = NSAttributedString(string: "E.g. Lunch", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = .clear
        
        startDatePicker?.datePickerMode = .time
        untilDatePicker?.datePickerMode = .time
        
        startDatePicker?.backgroundColor = .white
        untilDatePicker?.backgroundColor = .white
        
        startDatePicker?.setValue(UIColor.black, forKey: "textColor")
        untilDatePicker?.setValue(UIColor.black, forKey: "textColor")
        
        startDatePicker?.layer.borderWidth = 1
        startDatePicker?.layer.borderColor = UIColor.lightGray.cgColor
        startDatePicker?.layer.cornerRadius = 4
        startDatePicker?.layer.masksToBounds = true
        untilDatePicker?.layer.borderWidth = 1
        untilDatePicker?.layer.borderColor = UIColor.lightGray.cgColor
        untilDatePicker?.layer.cornerRadius = 4
        untilDatePicker?.layer.masksToBounds = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: "09:00")
        if let date = dateFormatter.date(from: "09:00") {
            startDatePicker?.date = date
            untilDatePicker?.date = date
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func startValueChanged(sender: UIDatePicker, forEvent Event:UIEvent) {
        let hour = String(format: "%02d",sender.date.getDate().hour)
        let minute = String(format: "%02d",sender.date.getDate().minute)
        startTime = "\(hour):\(minute)"
    }

    @IBAction func untilValueChanged(sender: UIDatePicker, forEvent Event:UIEvent) {
        let hour = String(format: "%02d",sender.date.getDate().hour)
        let minute = String(format: "%02d",sender.date.getDate().minute)
        endTime = "\(hour):\(minute)"
    }
    
    @IBAction func onAddTapped(_ sender: Any) {
        
        if(toDoTextField.text == "") {
            showEmptyTextFieldAlert(textField: "To Do")
        } else {
            let todo = toDoTextField?.text ?? "nil"
            let start = startTime
            let end = endTime
            print(todo)
            print(start)
            print(end)

            let toDo = Todo(context: PersistenceService.context)
            toDo.todo = todo
            toDo.start = start
            toDo.end = end
            toDo.status = "ongoing"
            
            PersistenceService.saveContext()
            self.toDoList.append(toDo)
            
            redirectToToDoList()
        }
    }
    
    @IBAction func onCancelTapped(_ sender: Any) {
        dismissModal()
    }
    
    func redirectToToDoList() {
        let vc = storyBoard.instantiateViewController(withIdentifier: "ToDoView") as! ToDoViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    func showEmptyTextFieldAlert(textField: String) {
        let alert = UIAlertController(title: "Empty \(textField)", message: "\(textField) can't be empty.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

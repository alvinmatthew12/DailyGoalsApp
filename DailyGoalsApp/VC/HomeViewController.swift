//
//  HomeViewController.swift
//  DailyGoalsApp
//
//  Created by Alvin Matthew Pratama on 12/04/20.
//  Copyright © 2020 Alvin Matthew Pratama. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myGoalsTextView: UITextView!
    @IBOutlet weak var goalsCardHeader: UIView!
//    @IBOutlet weak var reviewButton: UIButton!
//    @IBOutlet weak var goalsCardBody: UIView!
//    @IBOutlet weak var quotesTextView: UITextView!
    @IBOutlet weak var scheduleCardHeader: UIView!
    
    var toDoList = [Todo]()
    let defaults = UserDefaults.standard
    
    struct Keys {
        static let goals = "goals"
    }
    
    var notifications = [Notification]()
    struct Notification {
        var id:Int
        var todo:String
        var datetime:DateComponents
        var start:String
        var end:String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        goalsCardHeader.layer.cornerRadius = 12
        scheduleCardHeader.layer.cornerRadius = 12
        scheduleCardHeader.layer.maskedCorners = [.layerMaxXMinYCorner]
        
        checkForSaveGoals()
        
        scheduleReminder()
        listScheduledNotifications()
        
        //fetch CoreData
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        let startSort = NSSortDescriptor(key: "start", ascending: true)
        fetchRequest.sortDescriptors = [startSort]
        do {
            let toDo = try PersistenceService.context.fetch(fetchRequest)
            self.toDoList = toDo
            self.tableView.reloadData()
        } catch {}
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleReminder()
        listScheduledNotifications()
    }
    
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            for notification in notifications {
                print(notification)
            }
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied\n")
            }
        }
    }
    
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.setNotification()
            default:
                break // Do nothing
            }
        }
    }
    
    func scheduleReminder() {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        do {
            let toDoList = try PersistenceService.context.fetch(fetchRequest)
            let date = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            for toDo in toDoList {
                let todo = toDo.todo ?? "nill"
                let start = toDo.start ?? "nill"
                let end = toDo.end ?? "nill"
                
                let hour:Int = Int(start[0..<2])!
                let minute:Int = Int(start[3..<5])!
                
                let index = toDoList.firstIndex(of: toDo) ?? 0
                
                notifications.append(Notification(id: index + 1,todo: todo, datetime: DateComponents(calendar: Calendar.current, year: year, month: month, day: day, hour: hour, minute: minute), start: start, end: end))
                schedule()
            }
        } catch {}
    }
    

    func setNotification() {
        UNUserNotificationCenter.current().delegate = self
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.todo
            content.body = "You have schedule for \(notification.todo) from \(notification.start) until \(notification.end)"
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)

            let request = UNNotificationRequest(identifier: String(notification.id), content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }
    
    func checkForSaveGoals() {
        let goals = defaults.value(forKey: Keys.goals) as? String ?? ""
        myGoalsTextView.text = goals
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ReviewView") as? ReviewViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.todoIndex = indexPath.row
            vc.toDoText = toDoList[indexPath.row].todo ?? "nill"
            vc.timeText = "\(toDoList[indexPath.row].start ?? "nill") - \(toDoList[indexPath.row].end ?? "nill")"
            self.present(vc, animated: true, completion: nil)
        }
    }
}


extension HomeViewController : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.alert])
    }
}


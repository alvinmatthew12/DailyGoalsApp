//
//  CustomCell.swift
//  DailyGoalsApp
//
//  Created by Alvin Matthew Pratama on 11/04/20.
//  Copyright © 2020 Alvin Matthew Pratama. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var toDoLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var todoCard: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    
    func configureCell(item: Todo) {
        toDoLabel.text = item.todo
        startTimeLabel.text = item.start?.description ?? "nil"
        endTimeLabel.text = item.end?.description ?? "nil"
        
        if(item.status == "success") {
            statusImageView.image = UIImage.init(named: "Oval2")
        }
        else if(item.status == "failed") {
            statusImageView.image = UIImage.init(named: "Oval3")
        }
        else {
            statusImageView.image = UIImage.init(named: "Oval")
        }
        
        todoCard.layer.cornerRadius = 6
    }
}

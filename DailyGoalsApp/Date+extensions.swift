//
//  Date+extensions.swift
//  DailyGoalsApp
//
//  Created by Alvin Matthew Pratama on 12/04/20.
//  Copyright © 2020 Alvin Matthew Pratama. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func getDate() -> (hour: Int, minute: Int) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        return(hour, minute)
    }
}

//
//  Results.swift
//  SplitCal
//
//  Created by Long Nguyen on 1/14/21.
//

import Firebase
import UIKit

struct Results {
    var timeDate: Timestamp!
    let totalBill: String
    let percentT: String
    let splitPeople: String
    let billAndTip: String
    let eachPeopleBill: String
    let mainTitle: String
    
    init(dictionary: [String: Any]) {
        self.timeDate = dictionary["Timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.totalBill = dictionary["Your bill"] as? String ?? ""
        self.percentT = dictionary["Percent tip"] as? String ?? ""
        self.splitPeople = dictionary["Split between"] as? String ?? ""
        self.billAndTip = dictionary["Total bill"] as? String ?? ""
        self.eachPeopleBill = dictionary["Each pay"] as? String ?? ""
        self.mainTitle = dictionary["Title"] as? String ?? ""
        //the value inside the "" (the key) must match the values of array "resultData" of func saveResult() in ResultVC
    }
}


//
//  Struct.swift
//  SplitCal
//
//  Created by Long Nguyen on 1/14/21.
//

import Foundation

struct User {
    let firstName: String
    let lastName: String
    let emailAddress: String
    let userID: String
    let username: String
    
    init(dictionary: [String: Any]) {
        self.firstName = dictionary["first-name"] as? String ?? ""
        self.lastName = dictionary["last-name"] as? String ?? ""
        self.emailAddress = dictionary["email"] as? String ?? ""
        self.userID = dictionary["user-ID"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        //the value inside the "" (the key) must match the value (of "setData") indicated in the "upload user data" section in AppDelegate
    }
}

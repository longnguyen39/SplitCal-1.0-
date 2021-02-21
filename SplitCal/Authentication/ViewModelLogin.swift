//
//  ViewModelLogin.swift
//  SplitCal
//
//  Created by Long Nguyen on 2/7/21.
//

import UIKit

struct ViewModelLogin {
    
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        //if formIsValid == true, then we return the line below
        return email?.isEmpty == false && password?.isEmpty == false
    }
}


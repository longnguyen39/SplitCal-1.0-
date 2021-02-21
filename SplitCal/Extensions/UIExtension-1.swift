//
//  UIExtensions.swift
//  SplitCal
//
//  Created by Long Nguyen on 1/5/21.
//

import UIKit

//this file is for simplifying the auto layout stuff (using viewDidLayoutSubview func)

extension UIView {
    
    public var width: CGFloat {
        return self.frame.size.width
    }
    
    public var height: CGFloat {
        return self.frame.size.height
    }
    
    public var top: CGFloat {
        return self.frame.origin.y
    }
    
    public var bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    
    public var left: CGFloat {
        return self.frame.origin.x
    }
    
    public var right: CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
    
}

extension Notification.Name {
    static let didLogInNotification = Notification.Name("didLogInNotification")
    //static let didLogOutNotification = Notification.Name("didLogOutNotification")
    static let presentHistory = Notification.Name("presentHistory")
    
    static let LogInNotification = Notification.Name("LogInNotification")
    static let SignUpNotification = Notification.Name("SignInNotification")
    
    static let LogInLoader = Notification.Name("LogInLoader")
    static let LoaderDismiss = Notification.Name("LoaderDismiss")
    
    static let alertLogInNotificationCalVC = Notification.Name("alertLogInNotificationCalVC")
    
    static let didLogInNotificationCalVC = Notification.Name("didLogInNotificationCalVC")
    static let didLogOutNotificationCalVC = Notification.Name("didLogOutNotificationCalVC")
    
    static let didLogInNotificationResultVC = Notification.Name("didLogInNotificationResultVC")
    static let didLogOutNotificationResultVC = Notification.Name("didLogOutNotificationResultVC")

}



extension UIViewController {
//next time, just pass in parameters so that we dont have to create the same code version
    
    func configureGradientLayer (from: NSNumber, to: NSNumber) {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemGreen.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [from, to] //the gradient works vertically, the marks indicate where the gradient (2 or more colors equally divided) starts and stops. the entire screen is 0 -> 1
        
        //those lines insert the gradient into the view
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
}


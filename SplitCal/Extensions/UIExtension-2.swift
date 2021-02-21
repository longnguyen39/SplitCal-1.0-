//
//  ExtensionUI-1.swift
//  SplitCal
//
//  Created by Long Nguyen on 1/7/21.
//

import Foundation
import UIKit
import JGProgressHUD


extension UIView {
    
    //make top, left, bottom, right, width, height optional so we dont have to pass them in whenever we call this func (we can pass them in if needed)
    //The top, left, bottom, right are anchors, which indicate where to aim our constraints, the padding is to set the number (how wide or short the constraints are)
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
      
        
        //in case we pass some optionals above in, then gotta make them active
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
   
    
    
    //those 2 func below allow us to set up center X and Y
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    //those func below allow us to set up width and height
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}


extension UIViewController {
    
    //let's customize the navigation bar
    func configureNavigationBar (title: String, preferLargeTitle: Bool) {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() //just call it
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] //enables us to set our big titleColor to black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.4420939701, alpha: 1)
        
        //just call it for the sake of calling it
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance //when you scroll down, the nav bar just shrinks
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        //specify what show be showing up on the nav bar
        navigationController?.navigationBar.prefersLargeTitles = preferLargeTitle
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = .red //enables us to set the color for the image or any nav bar button
        navigationController?.navigationBar.isTranslucent = true
        
        //this line below specifies the status bar (battery, wifi display) to white, this line of code is only valid for large title nav bar
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
       
    }



    //let do some alerts
    func alert (error: String, buttonNote: String) {
        let alert = UIAlertController (title: "Error!!", message: "\(error).", preferredStyle: .alert)
        let tryAgain = UIAlertAction (title: buttonNote, style: .cancel, handler: nil)
                
        alert.addAction(tryAgain)
        present (alert, animated: true, completion: nil)
    }
    
    
    //let do some alerts log out
    func alertLogOut () {
        let alert = UIAlertController (title: "Successfully log out!", message: "You have been logged out. You have to log back in to save your result.", preferredStyle: .alert)
        let tryAgain = UIAlertAction (title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(tryAgain)
        present (alert, animated: true, completion: nil)
    }
    
    
    //let do some alerts log in
    func alertLogIn () {
        let alert = UIAlertController (title: "Successfully log in!", message: "You can now save your calculated results and view your profile.", preferredStyle: .alert)
        let tryAgain = UIAlertAction (title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(tryAgain)
        present (alert, animated: true, completion: nil)
    }
    
    
    //let's do the spinner of progressHUD
    static let hud = JGProgressHUD(style: .dark)  //each UIViewControllers only has 1 hud to share with each other across the entire project
    
    //the default text value is "loading"
    func showLoader(show: Bool, text: String? = "Loading", view: UIView) {
        
        UIViewController.hud.textLabel.text = text
        
        if show == true {
            print("DEBUG: showing loader..")
            UIViewController.hud.show(in: view) //present the loader
        } else {
            print("DEBUG: dismissing loader..")
            UIViewController.hud.dismiss(afterDelay: 0.2,animated: true)
        }
    }
    
    

}





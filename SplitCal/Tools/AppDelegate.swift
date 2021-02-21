//
//  AppDelegate.swift
//  SplitCal
//
//  Created by Long Nguyen on 1/5/21.
//

import UIKit
import Firebase
import GoogleSignIn
import JGProgressHUD
import IQKeyboardManagerSwift //this package has the "done" button on top of the keyboard, so it's great

//GGSignIn public nam "project-86965453037"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
//MARK: Origin of AppDelegate
//gotta put the origin up so it gets called first, which avoid our app to crash
    
    
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.
            
            // Use Firebase library to configure APIs
            FirebaseApp.configure()
            print("DEBUG: didFinishLaunchingWithOptions...")
            
            
            //these 2 lines below are for GG signIn
            GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
            GIDSignIn.sharedInstance().delegate = self
            
            
            //this line below is for the keyboard management
            IQKeyboardManager.shared.enable = true //this line is a must
            IQKeyboardManager.shared.enableAutoToolbar = true // enable the "done"button
            IQKeyboardManager.shared.shouldResignOnTouchOutside = true //tap anywhere to dismiss keyboard
            
            return true
        }
    
    
    
// MARK: UISceneSession Lifecycle

        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            // Called when a new scene session is being created.
            // Use this method to select a configuration to create the new scene with.
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        }

        func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
            // Called when the user discards a scene session.
            print("DEBUG: screen disappear")
            // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
            // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        }
    
    
    
//MARK: - GG signIn functions
//these functions are from Firebase docs and online tutorials
    
    //when the GGSignIn page is dismissed, the func below gets called to evaluate all the inputs we typed in the GGSignIn page
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      
        //let's send the notification to LoginVC to show loader
        NotificationCenter.default.post(name: .LogInLoader, object: nil)
        
        //now proceed to the login process
      if let e = error {
        print("DEBUG: from AppDelegate, maybe the GG signIn tab was dismissed, error GG sign in:", e.localizedDescription)
        
        //let's send the notification to LoginVC to dismiss loader
        NotificationCenter.default.post(name: .LoaderDismiss, object: nil)
        return
      }
        
//the block below is from us, we write ourself (online tutorial + improvise)
//----------------------------------------------------------------------begin
        
        guard let userEmail = user.profile.email,
              let profileUser = user.profile,
              let userFirstName = user.profile.givenName,
              let userLastName = user.profile.familyName else {
            print("DEBUG: Error in AppDelegate, cannot set userProfile..")
            return
        } //no userID cuz now it is nil, it is only assigned when we use the cammand "createUser"
        
        
        print("DEBUG: signing in with GG, user is \(userEmail)")
        print("DEBUG: user profile is \(profileUser), with firstName: \(userFirstName), and lastName: \(userLastName)")

        
        //let's set user's info in the FireStore
        let data = ["email": userEmail,
                    "first-name": userFirstName,
                    "last-name": userLastName] as [String: Any]
         
        //let's upload user data to Firebase under the file "collection"
        //gotta have the "merge" parameter in order to NOT replace the whole existing data of the "set data" stuff
        Firestore.firestore().collection("users").document(userEmail).setData(data, merge: true, completion: { error in
            
            if let e = error {
                    print("Fail to upload user data, \(e.localizedDescription)")
                    return
                }
            
            print("DEBUG: successfully created user profile")
        })
            
//----------------------------------------------------------------------done
        
        
        //the 2 commands below are from Firebase docs
      guard let authentication = user.authentication else {
        print("DEBUG: Missing auth object off of GG user")
        return
      }
        
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
      
        
//the block below is from us, we write ourself (online tutorial + improvise)
//----------------------------------------------------------------------begin
        //let's sign user in
        Firebase.Auth.auth().signIn(with: credential) { (authResult, error) in
            guard authResult != nil, error == nil else {
                print("DEBUG: fail to login with GG credential")
                return
            }
            
            print("DEBUG: user is:", userEmail)
            print("DEBUG: Successfully sign in with GG credential")
            
            //let's send the notification to LoginVC
            NotificationCenter.default.post(name: .didLogInNotification, object: nil)
            
        }
        
//----------------------------------------------------------------------done
        
    } //done this func: creating + signing up user
    
    
    //the func below is just procedure/protocol, and is useless
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        print("DEBUG: GG user was disconnected")
    }
    
    
    //the func below is for iOS 9 and above
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }



}



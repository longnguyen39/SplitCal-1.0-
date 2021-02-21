//
//  ProfileViewController.swift
//  SplitCal
//
//  Created by Long Nguyen on 1/5/21.
//

import UIKit
import Firebase
import GoogleSignIn
import JGProgressHUD


class ProfileViewController: UIViewController {
    
//MARK: Properties
    
    private let dismissButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        btn.imageView?.clipsToBounds = true
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        btn.backgroundColor = .clear
        
        btn.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    
    private let profileLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Profile"
        lb.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        lb.textColor = .black
        
        return lb
    }()
    
    private let profileImageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.clipsToBounds = true
        btn.contentMode = .scaleAspectFit
        btn.layer.borderWidth = 4
        btn.layer.borderColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        btn.tintColor = .white
        btn.layer.cornerRadius = 60
        btn.setBackgroundImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        btn.addTarget(self, action: #selector(pictureTapped), for: .touchUpInside)
        
        return btn
    }()
    
    private let noteLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Information"
        lb.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        lb.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lb.backgroundColor = .clear
        
        return lb
    }()
    
    private let userNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Username: "
        lb.numberOfLines = 1
        lb.adjustsFontSizeToFitWidth = true
        lb.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        lb.textColor = .black
        lb.isUserInteractionEnabled = true
        
        return lb
    }()
    
    private let userNameEditSign: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(UIImage(systemName: "pencil"), for: .normal)
        btn.tintColor = .purple
        btn.setWidth(width: 30)
        btn.addTarget(self, action: #selector(editUsername), for: .touchUpInside)
        
        return btn
    }()
    
    private let userNameRightView: UIView = {
        let uv = UIView()
        uv.backgroundColor = .clear
        uv.setWidth(width: 4)
        
        return uv
    }()
    
    private let dividerView: UIView = {
        let dv = UIView()
        dv.backgroundColor = .white
        
        return dv
    }()
    
    private let emailLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Email: "
        lb.numberOfLines = 1
        lb.adjustsFontSizeToFitWidth = true
        lb.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        lb.textColor = .black
        lb.isUserInteractionEnabled = true
        
        return lb
    }()
    
    private let emailEditSign: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(UIImage(systemName: "pencil"), for: .normal)
        btn.tintColor = .purple
        btn.setWidth(width: 30)
        btn.addTarget(self, action: #selector(editEmail), for: .touchUpInside)
        btn.isHidden = true //this is just for fun, if we implement this feature, gotta invest heavily on it
        
        return btn
    }()
    
    private let emailRightView: UIView = {
        let uv = UIView()
        uv.backgroundColor = .clear
        uv.setWidth(width: 4)
        
        return uv
    }()
    
    private let logOutButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Log out", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.backgroundColor = #colorLiteral(red: 1, green: 0.657790493, blue: 0.578125, alpha: 1)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        btn.layer.cornerRadius = 12
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowOpacity = 0.4
        btn.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    
    
    private var stuffChanged = "hey"
    private var mailUser = Auth.auth().currentUser?.email ?? "no email"
    
//MARK: View Scenes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGradientLayer(from: 0, to: 0.8)
        
        view.addSubview(dismissButton)
        view.addSubview(profileLabel)
        view.addSubview(profileImageButton)
        view.addSubview(noteLabel)
        view.addSubview(logOutButton)
        
        configureUI()
        fetchUserData()
        
    }
    
    
    func configureUI() {
        
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 16, paddingLeft: 16)
        dismissButton.setDimensions(height: 30, width: 30)
        
        profileLabel.anchor(top: dismissButton.topAnchor)
        profileLabel.centerX(inView: view)
        
        profileImageButton.anchor(top: profileLabel.bottomAnchor, paddingTop: 30)
        profileImageButton.centerX(inView: view)
        profileImageButton.setDimensions(height: 120, width: 120)
        
        noteLabel.anchor(top: profileImageButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 30, paddingLeft: 20)
        
        
        let stackUserName = UIStackView(arrangedSubviews: [userNameLabel, userNameEditSign, userNameRightView])
        userNameLabel.setHeight(height: 40)
        userNameEditSign.anchor(top: stackUserName.topAnchor, bottom: stackUserName.bottomAnchor, paddingTop: 7, paddingBottom: 7)
        stackUserName.axis = .horizontal
        stackUserName.spacing = 2
        
        let stackEmail = UIStackView(arrangedSubviews: [emailLabel, emailEditSign, emailRightView])
        emailLabel.setHeight(height: 40)
        emailEditSign.anchor(top: stackEmail.topAnchor, bottom: stackEmail.bottomAnchor, paddingTop: 7, paddingBottom: 7)
        stackEmail.axis = .horizontal
        stackEmail.spacing = 2
        
        
        let stack = UIStackView(arrangedSubviews: [stackUserName, dividerView, stackEmail])
        stack.axis = .vertical
        stack.spacing = 2
        stack.layer.cornerRadius = 10
        stack.layer.shadowOffset = CGSize(width: 4, height: 4)
        stack.layer.shadowOpacity = 0.4
        stack.backgroundColor = #colorLiteral(red: 0.3075484155, green: 0.8527728873, blue: 0.6987511004, alpha: 1)
        
        dividerView.setHeight(height: 2)
        dividerView.anchor(left: stack.leftAnchor, right: stack.rightAnchor, paddingLeft: 10, paddingRight: 10)
        
        view.addSubview(stack)
        stack.anchor(top: noteLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        
        
        logOutButton.anchor(top: stack.bottomAnchor, left: stack.leftAnchor, right: stack.rightAnchor, paddingTop: 40)
        logOutButton.setHeight(height: 46)
        
    }
    
    
//MARK: - Selectors, Functions
    
    @objc func editUsername() {
        print("DEBUG: username edit request..")
        textBox(mailOrUserName: "Please enter a new username", placeHolder: "New Username", nameOrMail: "name")
    }
    
    //we just edit the email in the "set data" section, we dont actually change the email of the user in the Authentication
    @objc func editEmail() {
        print("DEBUG: email edit request..")
        textBox(mailOrUserName: "Please enter a new email", placeHolder: "New Email", nameOrMail: "mail")
    }
    
    @objc func dismissButtonTapped() {
        print("DEBUG: dismissing ProfileVC..")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func pictureTapped() {
        print("DEBUG: picture tapped..")
        alert(error: "Uploading profile picture is not available for this version", buttonNote: "Cancel")
    }
    
//MARK: - TextBox and Alert
    
    @objc func logOutButtonTapped() {
        print("DEBUG: log out button tapped..")
        
        let alert = UIAlertController (title: "Logging out?", message: "Are you sure want to log out?", preferredStyle: .actionSheet)
        let cancel = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
        let logOut = UIAlertAction (title: "Log Out", style: .destructive, handler: { _ in
            
            self.dismiss(animated: true) {
                self.signOut()
                print("DEBUG: done signing out..")
            }
        })
        
        alert.addAction(cancel)
        alert.addAction(logOut)
        present (alert, animated: true, completion: nil)
        
    }
    
    func textBox(mailOrUserName: String, placeHolder: String, nameOrMail: String) {
        var textField = UITextField()
        
        let alertBox = UIAlertController(title: "Edit profile", message: mailOrUserName, preferredStyle: .alert)
        let cancel = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            //let's verify the textField
            if nameOrMail == "name" {
                if textField.text?.isEmpty == false && textField.text?.starts(with: " ") == false {
                    
                    self.showLoader(show: true, view: self.view)
                    self.stuffChanged = textField.text!
                    print("DEBUG: userName update: \(self.stuffChanged)")
                    self.updateProfile(nameOrMail: "name")
                    
                } else {
                    print("DEBUG: textField is empty..")
                    self.alert(error: "Please enter a valid input", buttonNote: "Try again")
                }
            }
            else if nameOrMail == "mail" {
                if textField.text?.isEmpty == false && textField.text?.starts(with: " ") == false, textField.text?.contains("@") == true {
                    
                    self.showLoader(show: true, view: self.view)
                    self.stuffChanged = textField.text!
                    print("DEBUG: email updated: \(self.stuffChanged)")
                    self.updateProfile(nameOrMail: "mail")
                    
                } else {
                    print("DEBUG: textField is empty or invalid..")
                    self.alert(error: "Please enter a valid input", buttonNote: "Try again")
                }
            }
            
        }
        
        alertBox.addTextField { (alertTextField) in
            alertTextField.placeholder = placeHolder
            alertTextField.autocapitalizationType = .words
            textField = alertTextField
        }
        alertBox.addAction(cancel)
        alertBox.addAction(action)
        present(alertBox, animated: true, completion: nil)
    }
    
    
    
    //MARK: - API stuff
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        let userEmail = Auth.auth().currentUser?.email ?? "No email"
        
        //let's log out from Google
        GIDSignIn.sharedInstance()?.signOut()
        
        do {
            try firebaseAuth.signOut()
            print("DEBUG: did SIGN OUT user \"\(userEmail)\".")
            
            //let's send the notification of signing out to CalVC
            NotificationCenter.default.post(name: .didLogOutNotificationCalVC, object: nil)
            
            //let's send the notification of signing out to ResultVC
            NotificationCenter.default.post(name: .didLogOutNotificationResultVC, object: nil)
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
      
    }
    
    func updateProfile(nameOrMail: String) {
        print("DEBUG: updating profile..")
        let userEmail = Auth.auth().currentUser?.email ?? "no email"
        var data = ["decoy": "decoy"] as [String: Any]
        
        if nameOrMail == "name" {
            data = ["username": stuffChanged] as [String: Any]
        } else if nameOrMail == "mail" {
            data = ["email": stuffChanged] as [String: Any]
            //self.emailChanged(newEmail: stuffChanged)
        }
        
        
        Firestore.firestore().collection("users").document(userEmail).updateData(data) { (error) in
            
            guard error == nil else {
                print("DEBUG: error updating profile")
                self.showLoader(show: false, view: self.view)
                self.alert(error: "Error updatin profile", buttonNote: "Try again")
                return
            }
            self.showLoader(show: false, view: self.view)
            print("DEBUG: successfully update data profile")
            self.fetchUserData()
        }
    }
    
    //email change required user authentication, ask for a password before doing this otherwise we got an error. when we change to a new email, make sure either it is a new email (then gotta create one in collection "user") or an existing email (give a warning)
    func emailChanged(newEmail: String) {
        print("DEBUG: \(mailUser) is changed to \(newEmail)")
        
        Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
            
            guard error == nil else {
                print("DEBUG: we got emailChanged error..")
                guard let e = error?.localizedDescription else { return }
                self.showLoader(show: false, view: self.view)
                self.alert(error: "Error changing email: \(e)", buttonNote: "Try again")
                return
            }
            
        })
        
    }
    
    
    //MARK: - Fetching stuff
    
    //let's fetch user data
    func fetchUserData() {
        print("DEBUG: fetching user data..")
        let userEmail = Auth.auth().currentUser?.email ?? "No email"
        showLoader(show: true, view: self.view)
        
        //we use "getDocument" command to access info in the "addData" section
        Firestore.firestore().collection("users").document(userEmail).getDocument { (snapshot, error) in
            
            guard error == nil else {
                print("DEBUG: error fetching user info,", error?.localizedDescription ?? "no error")
                self.showLoader(show: false, view: self.view)
                self.alert(error: "Unable to load your Profile, Please check your internet connection", buttonNote: "Cancel")
                return
            }
            
            guard let dictionaryUser = snapshot?.data() else {
                print("DEBUG: error setting user data..")
                self.showLoader(show: false, view: self.view)
                self.alert(error: "Error loading your Profile, Please check your internet connection", buttonNote: "Cancel")
                return
            }
            
            let userInfoFetched = User(dictionary: dictionaryUser)
            
            let usernameFetched = userInfoFetched.username
            let nameFetched = "\(userInfoFetched.firstName) \(userInfoFetched.lastName)"
            
            print("DEBUG: userInfo is \(userInfoFetched)")
            print("DEBUG: user's name is \(nameFetched)")
            print("DEBUG: email fetched:", userInfoFetched.emailAddress)
            
            if userInfoFetched.username == "Apple/Google user" {
                self.userNameEditSign.isHidden = true
            }
            self.userNameLabel.text = "Name: \(usernameFetched)"
            self.emailLabel.text = "Email: \(userInfoFetched.emailAddress)"
            self.showLoader(show: false, view: self.view)
        }
        
    }
    
    
    
    
}

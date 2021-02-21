//
//  LoginViewController.swift
//  SplitCal
//
//  Created by Long Nguyen on 1/5/21.
//

import UIKit
import GoogleSignIn
import FirebaseUI
import Firebase
import JGProgressHUD

//LET'S TRY THE FIREBASEUI TO IMPLEMENT APPLE SIGNIN, we can use FirebaseUI to makes signIn with 3rd-party account easier
//In fact, we implement the separate GG signin button for fun, we should not do that cuz it mhas many bugs when people switching back/forth signing for GG in either the login page or FirebaseUI

class LoginViewController: UIViewController, FUIAuthDelegate {
    
    
//MARK: - Properties
    
    let userEmail = Auth.auth().currentUser?.email ?? "No email"
    
    //MARK: - top components
    
    private let dismissButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        btn.tintColor = .red
        btn.addTarget(self, action: #selector(dismissLoginVC), for: .touchUpInside)
        
        return btn
    }()
    
    private let appLabel: UILabel = {
        let lb = UILabel()
        lb.text = "SplitCal"
        lb.textColor = .black
        lb.textAlignment = .center
        lb.font = UIFont.monospacedSystemFont(ofSize: 24, weight: .semibold)
        
        return lb
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "percent")
        iv.tintColor = .black //image's color is black
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    //MARK: - Authentication
    
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.font = UIFont.systemFont(ofSize: 20)
        field.returnKeyType = .continue
        field.layer.borderColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 10
        field.attributedPlaceholder = NSAttributedString(string: "Email address..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]) //let customize the placeHolder
        field.keyboardAppearance = .dark
        field.textColor = .black
        field.setHeight(height: 40)
        field.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        //let's make the text in the textfield NOT slush into the left
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .clear
        
        return field
    }()
    
    private let passwordTextField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.font = UIFont.systemFont(ofSize: 20)
        field.returnKeyType = .go
        field.layer.borderColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 10
        field.attributedPlaceholder = NSAttributedString(string: "Password..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray ]) //let customize the placeHolder
        field.keyboardAppearance = .dark
        field.textColor = .black
        field.setHeight(height: 40)
        field.isSecureTextEntry = true
        field.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        //let's make the text in the textfield NOT slush into the left
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .clear
        
        return field
    }()
    
    private let logInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign in", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.4625613345, green: 0.8433452073, blue: 0.2356247896, alpha: 1)
        btn.isEnabled = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //we got black here
        btn.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    
    private let signUpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign up", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.9259647442, green: 0.9686274529, blue: 0.1373965551, alpha: 1)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        btn.layer.cornerRadius = 16
        btn.layer.borderWidth = 1
        btn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //we got black here
        btn.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    
    //MARK: - Google and Apple signIn
    
    private let optionLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.adjustsFontSizeToFitWidth = true
        lbl.text = "Other sign in options:"
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.numberOfLines = .zero
        lbl.isHidden = true
        
        return lbl
    }()
    
    private let signInOptions: UIButton = {
        let btn = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString (string: "Other sign in options", attributes: [.font: UIFont.systemFont(ofSize: 22), .foregroundColor: UIColor.black])
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(showLoginOptions), for: .touchUpInside)
        btn.isHidden = true
        
        return btn
    }()
    
    //As we import the package above, the "GIDSignInButton()" is given by default
    private let googleLogInButton: GIDSignInButton = {
        let btn = GIDSignInButton()
        btn.isHidden = true
        btn.layer.cornerRadius = 10
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowOpacity = 0.4
        
        return btn
    }()
    
    
    private var viewModel = ViewModelLogin()
    private var loginObserver: NSObjectProtocol? //this is protocol from AppDelegate/GG signin
    private var loginLoader: NSObjectProtocol? //same as above
    private var loaderDismiss: NSObjectProtocol? //same
    
//MARK: - View Scenes
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        //keyboardButton()
        
        configureGradientLayer(from: 0, to: 1)
        addSubviews()
        GGSignInFunctions() //instead of protocols (sometimes not work), we should use this "loginObserver" feature when dealing with log in and out. Just send notification when log in or out.
        GIDSignIn.sharedInstance()?.presentingViewController = self //present the GG login button
        
    }
    
//let's deal with the keyboard
    
    @objc func DismissKeyboard() {
        print("DEBUG: dismissing keyboard...")
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
//now the general UI setup
    
    func addSubviews () {
        
        navigationController?.navigationBar.isHidden = true
        
        //let's test the TapGestureRecognizer (the tap has to be in the ViewDidLoad)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        iconImageView.addGestureRecognizer(tap)
        
        //now let's add the subViews
        view.addSubview(dismissButton)
        view.addSubview(appLabel)
        view.addSubview(iconImageView)
        view.addSubview(optionLabel)
        view.addSubview(googleLogInButton)
        view.addSubview(signUpButton)
        view.addSubview(logInButton)
        view.addSubview(signInOptions)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 6
        view.addSubview(stack)
        emailTextField.anchor(left: stack.leftAnchor, right: stack.rightAnchor)
        passwordTextField.anchor(left: stack.leftAnchor, right: stack.rightAnchor)
        stack.anchor(top: appLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 26, paddingLeft: 30, paddingRight: 30)
        
        
        logInButton.anchor(top: stack.bottomAnchor, left: stack.leftAnchor, paddingTop: 16, width: 120, height: 40)
        signUpButton.anchor(top: logInButton.topAnchor, right: stack.rightAnchor, width: 120, height: 40)
        
        optionLabel.anchor(top: logInButton.bottomAnchor,left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingRight: 12)
        
        signInOptions.anchor(top: optionLabel.bottomAnchor, left: stack.leftAnchor, right: stack.rightAnchor, paddingTop: 20)
        
        googleLogInButton.anchor(top: signInOptions.bottomAnchor, left: signInOptions.leftAnchor, right: signInOptions.rightAnchor, paddingTop: 20)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 15, paddingLeft: 15)
        dismissButton.setDimensions(height: 40, width: 40)
        
        iconImageView.frame = CGRect(x: view.frame.width/3,
                                     y: dismissButton.bottom + 20,
                                     width: view.frame.width/3,
                                     height: view.frame.width/3)
        
        appLabel.frame = CGRect(x: view.frame.width/4,
                                y: iconImageView.bottom + 14,
                                width: view.frame.width/2,
                                height: 40)
        
    }
  
//MARK: - Protocols
//the 2 func below are for GG sign in. It happen when we successfully sign in with GG acc. The "forName" key gets value from Extension-1
    func GGSignInFunctions() {
        
        loginLoader = NotificationCenter.default.addObserver(forName: .LogInLoader, object: nil, queue: .main) { [weak self] _ in
            
            print("DEBUG: logged in loader..")
            guard let strongSelf = self else { return }
            strongSelf.showLoader(show: true, view: strongSelf.view)
        }
        
        loaderDismiss = NotificationCenter.default.addObserver(forName: .LoaderDismiss, object: nil, queue: .main) { [weak self] _ in
            
            print("DEBUG: gotta dismiss loader..")
            guard let strongSelf = self else { return }
            strongSelf.showLoader(show: false, view: strongSelf.view)
        }
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main) { [weak self] _ in
            
            print("DEBUG: logged in notified..")
            guard let strongSelf = self else { return }
            strongSelf.showLoader(show: false, view: strongSelf.view)
            strongSelf.dismissLoginVC()
            
            //send the notification of signIn to CalVC for updating
            NotificationCenter.default.post(name: .didLogInNotificationCalVC, object: nil)
            
            //send the notification of signIn to ResultVC for updating
            NotificationCenter.default.post(name: .didLogInNotificationResultVC, object: nil)
        }
        
    }
    
    //this func is exclusively unique for GG sign in
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer1 = loginLoader {
            NotificationCenter.default.removeObserver(observer1)
        }
        if let observer2 = loaderDismiss {
            NotificationCenter.default.removeObserver(observer2)
        }
    }

    

    
//MARK: - Apple SignIn - FirebaseUI
    
    //for the tap, we just implement it for fun, in fact we should not put 2 Google SignIn on 2 different pages like this
    @objc func handleTap() {
        print("DEBUG: Activate Tap - sign in options appear..")
        //googleLogInButton.isHidden = !googleLogInButton.isHidden
        signInOptions.isHidden = !signInOptions.isHidden
      }
    
    
    @objc func showLoginOptions() {
        print("DEBUG: loading login options..")
        
        if let authUI = FUIAuth.defaultAuthUI() {
            
            authUI.providers = [FUIOAuth.appleAuthProvider(), FUIGoogleAuth()]
            authUI.delegate = self
            
            let authVC = authUI.authViewController()
            authVC.modalTransitionStyle = .crossDissolve
            authVC.modalPresentationStyle = .fullScreen
            self.present(authVC, animated: true, completion: nil)
            print("DEBUG: done presenting login options")
        }
    }
    
    //this func will handle all Signin options in the FirebaseUI, so the Google signIn here is different than the one hidden below SiginOption button.
    //this func gets called when this loginOptions page is dismissed
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        print("DEBUG: signing in using Apple/Google")
        showLoader(show: true, view: self.view)
        
        if let userInfo = authDataResult?.user {
            
            guard let mail = userInfo.email else {
                print("DEBUG: we got error")
                return
            }
            
            let data = ["email": mail,
                        "username": "Apple/Google user"] as [String: Any]
            
            print("DEBUG: the data collected is \(data)")
            
            //gotta have the "merge" parameter, otherwise every time this func gets called, a whole data in the "mail" document will be reset
            Firestore.firestore().collection("users").document(mail).setData(data, merge: true, completion: { error in
                
                print("DEBUG: creating profile")
                
                if let e = error?.localizedDescription {
                    print("Fail to upload user data, \(e)")
                    self.alert(error: "Oops, \(e)", buttonNote: "Try again")
                    return
                    }
                
                self.showLoader(show: false, view: self.view)
                self.dismissLoginVC()
                print("DEBUG: user sign in \(mail)")
                
                //let's send the notification to LoginVC
                NotificationCenter.default.post(name: .didLogInNotificationCalVC, object: nil) //we use the same notification as logging in by typing (which is implement below)
            })
            
        } else {
            print("DEBUG: no signin attempt detected..")
            self.showLoader(show: false, view: self.view) //insert this in case something goes wrong
        }
        
        
    }
    
    
    
//MARK: - Selectors, functions
    
    @objc func dismissLoginVC() {
        print("DEBUG: Dismissing LoginVC..")
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func signUpButtonTapped() {
        print("DEBUG: signUpButton tapped..")
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func textDidChange (sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        else if sender == passwordTextField {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    func checkFormStatus () {
        if viewModel.formIsValid {
            //this code is executed when viewModel.formIsValid == true
            logInButton.isEnabled = true
            logInButton.backgroundColor = #colorLiteral(red: 0.4889321203, green: 1, blue: 0.7424639802, alpha: 1)
        } else {
            logInButton.isEnabled = false
            logInButton.backgroundColor = #colorLiteral(red: 0.4625613345, green: 0.8433452073, blue: 0.2356247896, alpha: 1)
            logInButton.setTitleColor(.black, for: .normal)
        }
    }
    
    
    @objc func signInButtonTapped() {
        print("DEBUG: signInButton tapped..")
        guard let emailTyped = emailTextField.text else {return}
        guard let passwordtyped = passwordTextField.text else {return}
        
        showLoader(show: true, text: "Logging in", view: view)
        
        Auth.auth().signIn(withEmail: emailTyped, password: passwordtyped) { (result, error) in
            
            //the guard statement makes sure the error is nil
            guard error == nil else {
                print("DEBUG: error signing in..")
                self.showLoader(show: false, text: "Logging in", view: self.view)
                guard let e = error?.localizedDescription else { return }
                self.alert(error: "\(e)", buttonNote: "Try again")
                return
            }
            
            self.showLoader(show: false, text: "Logging in", view: self.view)
            print("DEBUG: user \(emailTyped) log in successfully")
            self.dismiss(animated: true, completion: nil)
            
            //let's send the notification to CalVC
            NotificationCenter.default.post(name: .LogInNotification, object: nil)
            
        }
    }
    
    
}


//MARK: - Protocol textField
//this is the default protocol for textField in Swift
//Remember to write emailTextField.delegate = self, passwordTextField.delegate = self in the ViewDidLoad
extension LoginViewController: UITextFieldDelegate {
    
    //this func will let u dictate what happens when the return key tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            print("DEBUG: signing user in..")
            passwordTextField.resignFirstResponder()
            signInButtonTapped()
        }
        
        return true
    }
    
}



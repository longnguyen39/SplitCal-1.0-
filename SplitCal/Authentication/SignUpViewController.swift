//
//  SignUpViewController.swift
//  SplitCal
//
//  Created by Long Nguyen on 2/7/21.
//

import UIKit
import Firebase
import JGProgressHUD

class SignUpViewController: UIViewController {
    
//MARK: - Properties
    
    private let label: UILabel = {
        let lb = UILabel()
        lb.text = "Sign Up to SplitCal"
        lb.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        lb.textColor = .black
        lb.textAlignment = .center
        
        return lb
    }()
    
    
    private let usernameTextField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.font = UIFont.systemFont(ofSize: 20)
        field.returnKeyType = .continue
        field.layer.borderColor = #colorLiteral(red: 0.08295284883, green: 0.3323201464, blue: 0.2138428611, alpha: 1)
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 10
        field.attributedPlaceholder = NSAttributedString(string: "Username..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray ]) //let customize the placeHolder
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
    
    
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.font = UIFont.systemFont(ofSize: 20)
        field.returnKeyType = .continue
        field.layer.borderColor = #colorLiteral(red: 0.08295284883, green: 0.3323201464, blue: 0.2138428611, alpha: 1)
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 10
        field.attributedPlaceholder = NSAttributedString(string: "Email address..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray ]) //let customize the placeHolder
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
        field.layer.borderColor = #colorLiteral(red: 0.08295284883, green: 0.3323201464, blue: 0.2138428611, alpha: 1)
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 10
        field.attributedPlaceholder = NSAttributedString(string: "Password..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray ]) //let customize the placeHolder
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
    
    private let signUpBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign up", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 1, green: 0.7611095416, blue: 0.2970196293, alpha: 1)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        btn.isEnabled = false
        btn.layer.cornerRadius = 12
        btn.layer.borderWidth = 1
        btn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //we got black here
        btn.addTarget(self, action: #selector(signUpBtnTapped), for: .touchUpInside)
        
        return btn
    }()
    
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString (string: "Already have an account?  ", attributes: [.font: UIFont.systemFont(ofSize: 22), .foregroundColor: UIColor.black])
        
        attributedTitle.append(NSMutableAttributedString(string: "Sign in", attributes: [.font: UIFont.boldSystemFont(ofSize: 22), .foregroundColor: UIColor.blue]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        
        //let's add some action
        btn.addTarget(self, action: #selector(backToLogIn), for: .touchUpInside)
        
        return btn
    }()
    
    
    private var viewModel = ViewModelSignUp()
    
//MARK: - View Scenes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGradientLayer(from: 0, to: 1)
        configureUI()
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    
    func configureUI() {
        view.addSubview(backButton)
        view.addSubview(label)
        view.addSubview(signUpBtn)
        
        label.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingRight: 30)
        
        let stack = UIStackView(arrangedSubviews: [usernameTextField, emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.spacing = 10
        view.addSubview(stack)
        stack.anchor(top: label.bottomAnchor, left: label.leftAnchor, right: label.rightAnchor, paddingTop: 32)
        
        signUpBtn.anchor(top: stack.bottomAnchor, left: stack.leftAnchor, right: stack.rightAnchor, paddingTop: 30, height: 45)
        
        backButton.anchor(top: signUpBtn.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
    }
    
    
//MARK: - Selectors , functions
    
    @objc func backToLogIn() {
        print("DEBUG: back to LoginVC..")
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange (sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        else if sender == usernameTextField {
            viewModel.username = sender.text
        }
        else if sender == passwordTextField {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    func checkFormStatus () {
        if viewModel.formIsValid {
            //this code is executed when viewModel.formIsValid == true
            signUpBtn.isEnabled = true
            signUpBtn.backgroundColor = #colorLiteral(red: 0.9191363793, green: 1, blue: 0.03090144106, alpha: 1)
        } else {
            signUpBtn.isEnabled = false
            signUpBtn.backgroundColor = #colorLiteral(red: 1, green: 0.7611095416, blue: 0.2970196293, alpha: 1)
        }
    }
    
    func dismissKeyboard() {
        print("DEBUG: dismissing keyboard..")
        resignFirstResponder()
    }
    
    //MARK: - sign user up
    
    @objc func signUpBtnTapped() {
        print("DEBUG: SignUpBtn tapped")
        dismissKeyboard()
        showLoader(show: true, text: "Signing up", view: view)
        
        guard let emailInput = emailTextField.text else {return}
        guard let usernameInput = usernameTextField.text else {return}
        guard let passwordInput = passwordTextField.text else {return}
        print("signing user up, \(emailInput) - \(usernameInput) - \(passwordInput)")
        
        
        Auth.auth().createUser(withEmail: emailInput, password: passwordInput) { (result, error) in
                
                if let e = error {
                    print("Fail to create user, \(e.localizedDescription)")
                    self.showLoader(show: false, text: "Signing up", view: self.view)
                    self.alert(error: e.localizedDescription, buttonNote: "Try again")
                    return
                }
                
                guard let uid = result?.user.uid else {return}
                
                //let's get on the database section
                let data = ["email": emailInput,
                            "uid": uid,
                            "password": passwordInput,
                            "username": usernameInput] as [String: Any]
                 
                //let's upload user data to Firebase under the file "collection"
                Firestore.firestore().collection("users").document(emailInput).setData(data, completion: { error in
                    
                    if let e = error?.localizedDescription {
                        print("Fail to upload user data, \(e)")
                        self.alert(error: "Oops, \(e)", buttonNote: "Try again")
                        return
                        }
                    
                    self.showLoader(show: false, view: self.view)
                    self.dismiss(animated: true, completion: nil)
                    print("DEBUG: successfully created user profile")
                    
                    //let's send the notification to calVC
                    NotificationCenter.default.post(name: .SignUpNotification, object: nil)
                })
            }
        
    }
    
    
    
}

//MARK: - Protocol textField
//this is the default protocol for textField in Swift
//Remember to write emailTextField.delegate = self, passwordTextField.delegate = self in the ViewDidLoad
extension SignUpViewController: UITextFieldDelegate {
    
    //this func will let u dictate what happens when the return key tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            emailTextField.becomeFirstResponder()
        }
        else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            signUpBtnTapped()
        }
        
        return true
    }
    
}

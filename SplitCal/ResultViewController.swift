//
//  ResultViewController.swift
//  SplitCal
//
//  Created by Long Nguyen on 1/5/21.
//

import UIKit
import JGProgressHUD
import Firebase

class ResultViewController: UIViewController {
    
//MARK: - Properties
    
    private let resultLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Your result:"
        lb.textColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        lb.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        
        return lb
    }()
    
    
    private let totalBillLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Your total bill plus tip is:"
        lb.textColor = .black
        lb.numberOfLines = .zero
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        return lb
    }()
    
    private let overallMoneyLabel: UILabel = {
        let lb = UILabel()
        lb.text = "%60"
        lb.textColor = .black
        lb.textAlignment = .center
        lb.numberOfLines = .zero
        lb.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        lb.backgroundColor = .clear
        
        return lb
    }()
    
    private let eachBillLabel: UILabel = {
        let lb = UILabel()
        lb.text = "For 4 people, each of you will pay:"
        lb.textColor = .black
        lb.numberOfLines = .zero
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        return lb
    }()
    
    private let eachMoneyLabel: UILabel = {
        let lb = UILabel()
        lb.text = "$15"
        lb.textColor = .black
        lb.numberOfLines = .zero
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        
        return lb
    }()
    
    private let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save", for: .normal)
        btn.setTitleColor( #colorLiteral(red: 0.09862159288, green: 0.2541805663, blue: 1, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.4772150784, green: 1, blue: 0.517582286, alpha: 1)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        
        btn.layer.cornerRadius = 12
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowOpacity = 0.4
        btn.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    
    private let doneButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        btn.setTitle("Done", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        btn.setTitleColor( .black, for: .normal)
        
        btn.layer.cornerRadius = 12
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowOpacity = 0.4
        btn.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    
    private let saveLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Press \"save\" to save this result in bookmark with a specified title"
        lb.textColor = .black
        lb.numberOfLines = .zero
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return lb
    }()
    
    var totalMoney: Double = 0 //need $ sign
    var percentTip: Double = 0 //need $ sign
    var overallMoney: Double = 0
    var numberOfPeople: Int = 0 //need "people" sign
    var eachMoney: Double = 0
    
    var titleNote: String = "Title"
    
    var userEmail = Auth.auth().currentUser?.email
    //var userUpdateResult = "nil"
    private var loginObserver: NSObjectProtocol?
    private var logOutObserver: NSObjectProtocol?
    
//MARK: - View Scenes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configureGradientLayerResultVC()
        configureGradientLayer(from: 0, to: 0.6)
        addSubView()
        configureUI()
        
        totalBillLabel.text = "Your total bill plus \(percentTip)% tip is:"
        overallMoneyLabel.text = "$\(String(format: "%0.2f", overallMoney))"
        eachMoneyLabel.text = "$\(String(format: "%0.2f", eachMoney))"
        eachBillLabel.text = "For \(numberOfPeople) people, each of you will pay:"
        
        GGSignInFunctions()
    }
    
    
    
    func addSubView() {
        view.addSubview(resultLabel)
        view.addSubview(totalBillLabel)
        view.addSubview(overallMoneyLabel)
        
        view.addSubview(eachBillLabel)
        view.addSubview(eachMoneyLabel)
        
        view.addSubview(saveButton)
        view.addSubview(doneButton)
        view.addSubview(saveLabel)
        
    }
    
    func configureUI() {
        
        resultLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 18)
        resultLabel.centerX(inView: view)
        
        totalBillLabel.anchor(top: resultLabel.bottomAnchor,left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 36, paddingLeft: 30, paddingRight: 30)
        
        overallMoneyLabel.anchor(top: totalBillLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 22, paddingLeft: 50, paddingRight: 50)
        
        eachBillLabel.anchor(top: overallMoneyLabel.bottomAnchor, left: totalBillLabel.leftAnchor, right: totalBillLabel.rightAnchor, paddingTop: 54)
        
        eachMoneyLabel.anchor(top: eachBillLabel.bottomAnchor, left: overallMoneyLabel.leftAnchor, right: overallMoneyLabel.rightAnchor, paddingTop: 22)
        
        doneButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: saveButton.bottomAnchor, paddingLeft: 24)
        doneButton.setDimensions(height: 48, width: 120)
        
        saveButton.anchor(bottom: saveLabel.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 14, paddingRight: 24)
        saveButton.setDimensions(height: 48, width: 120)
        
        saveLabel.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
    }
    
//MARK: - Authentification
    //the 2 func below are for GG sign in. We use the "loginObserver" to receive signal (that user has signed out) from ProfileVC.
    func GGSignInFunctions() {
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotificationResultVC, object: nil, queue: .main) { [weak self] _ in
            
            print("DEBUG: logged in ResultVC notified..")
            guard let strongSelf = self else { return }
            strongSelf.userEmail = Auth.auth().currentUser?.email ?? "no email"
            strongSelf.alertLogIn()
        }
        
        logOutObserver = NotificationCenter.default.addObserver(forName: .didLogOutNotificationResultVC, object: nil, queue: .main) { [weak self] _ in
            
            print("DEBUG: logged out ResultVC notified..")
            guard let strongSelf = self else { return }
            strongSelf.userEmail = "nil"
        }
        
    }
    
    //this func is exclusively unique for GG sign in
    deinit {
        if let observer1 = logOutObserver {
            NotificationCenter.default.removeObserver(observer1)
        }
        if let observer2 = loginObserver {
            NotificationCenter.default.removeObserver(observer2)
        }
    }
        
    
    //check for authentification
    func authentification() {
        if userEmail == nil {
            print("DEBUG: user not logged in..")
        } else {
            print("DEBUG: user logged in..")
            //userUpdateResult = userEmail ?? "nil"
            
        }
    }
    
//MARK: - Selectors, functions
    
    @objc func doneButtonTapped() {
        print("DEBUG: dismissing ResultVC..")
        dismiss(animated: true, completion: nil)
    }
    
    func successAlert() {
        let alertBox = UIAlertController(title: "Saved!", message: "Your result was successfully saved.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            print("DEBUG: dismissing ResultVC..")
            self.dismiss(animated: true, completion: nil)
        }
        
        alertBox.addAction(action)
        present(alertBox, animated: true, completion: nil)
    }
    
    func showSuccess() {
        print("DEBUG: showing success mark..")
        ResultViewController.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        ResultViewController.hud.show(in: view, animated: true)
        ResultViewController.hud.textLabel.text = "Saved"
        ResultViewController.hud.dismiss(afterDelay: 0.8, animated: false)
    }
    
    
    //let do some alerts signIn
    func alertSignIn () {
        
        let alert = UIAlertController (title: "Sign in required!", message: "Please sign in to save your result.", preferredStyle: .actionSheet)
        let action1 = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
        let action2 = UIAlertAction (title: "Sign in", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            
            //let's send the notification to LoginVC
            NotificationCenter.default.post(name: .alertLogInNotificationCalVC, object: nil)
            
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        present (alert, animated: true, completion: nil)
    }
    
    
    func presentLoginVC() {
        print("DEBUG: loading LoginVC..")
        let vc = LoginViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
//MARK: - Tap saveButton
    
    @objc func saveButtonTapped() {
        if userEmail == "nil" || userEmail == nil {
            print("DEBUG: user not signed in..")
            alertSignIn()
        } else {
            print("DEBUG: presenting textBox..")
            textBox()
        }
    }
    
    
    func textBox() {
        var textField = UITextField()
        
        let alertBox = UIAlertController(title: "Title", message: "Please add a title.", preferredStyle: .alert)
        let cancel = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            //let's verify the textField
            if textField.text?.isEmpty == false && textField.text?.starts(with: " ") == false {
                
                self.showLoader(show: true, view: self.view)
                self.titleNote = textField.text!
                print("DEBUG: title created: \(self.titleNote)")
                self.saveResult()
                
            } else {
                print("DEBUG: textField is empty..")
                self.alert(error: "Please enter a title", buttonNote: "Try again")
            }
        }
        
        alertBox.addTextField { (alertTextField) in
            alertTextField.placeholder = "New title"
            alertTextField.autocapitalizationType = .words
            textField = alertTextField
        }
        alertBox.addAction(cancel)
        alertBox.addAction(action)
        present(alertBox, animated: true, completion: nil)
    }
    
    
//MARK: - Call APIs, save results
    
    func saveResult () {
        print("DEBUG: saving result..")
        
        let saveTotalBill = "$\(totalMoney)"
        let saveOverallBill = overallMoneyLabel.text ?? "none"
        let savePercentTip = "\(percentTip)%"
        let saveSplit = "\(numberOfPeople) people"
        let saveEachMoney = eachMoneyLabel.text ?? "none"
        
        
//the block below upload data to Firebase
//-------------------------------------------------------------------------
  
        let currentUserEmail = Auth.auth().currentUser?.email ?? "No email"
        
        let resultData = ["User": currentUserEmail,
                      "Your bill": saveTotalBill,
                      "Percent tip": savePercentTip,
                      "Split between": saveSplit,
                      "Total bill": saveOverallBill,
                      "Each pay": saveEachMoney,
                      "Title": titleNote,
                      "Timestamp": Timestamp(date: Date())] as [String: Any]
        print("DEBUG: result is: ", resultData)
        
        
        //let's upload to Firebase
        //keep in mind that when user use the same titleNote, the old document/titleNote will get over-written
        Firestore.firestore().collection("users").document(currentUserEmail).collection("save-results").document(titleNote).setData(resultData) { error in
            
            print("DEBUG: uploading...")
            self.showLoader(show: false, view: self.view)
            
            if let e = error {
                    print("DEBUG: Fail to upload user result.., \(e.localizedDescription)")
                self.alert(error: "Oopps, \(e.localizedDescription)", buttonNote: "Try again")
                    return
                }
            //execute the code 0.2 seconds later so that the duration last little longer after results have been uploaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                print("DEBUG: successfully upload result")
                self.successAlert()
                //self.showSuccess() //no need to dismiss the loader since this func showSuccess will dismiss both
                }
        }
        
//-------------------------------------------------------------------------
        
    } //the end of this func

    
    
}

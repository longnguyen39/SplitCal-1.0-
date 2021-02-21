//
//  CalculationVC.swift
//  SplitCal
//
//  Created by Long Nguyen on 1/5/21.
//

import UIKit
import Firebase

class CalculationViewController: UIViewController {
    
    private var userEmail = Auth.auth().currentUser?.email
    
//MARK: - Properties
    
    private let profileButton: UIButton = {
        let btn = UIButton(type: .system) //make click animation for type .system
        btn.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        btn.imageView?.clipsToBounds = true
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        
        btn.addTarget(self, action: #selector(showProfilePage), for: .touchUpInside)
        
        return btn
    }()
    
    private let historyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(UIImage(systemName: "bookmark.circle"), for: .normal)
        btn.imageView?.clipsToBounds = true
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        
        btn.addTarget(self, action: #selector(showHistoryPage), for: .touchUpInside)
        
        return btn
    }()
    
    private let folderButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(UIImage(systemName: "folder.circle"), for: .normal)
        btn.imageView?.clipsToBounds = true
        btn.imageView?.contentMode = .scaleAspectFit
        btn.tintColor = .white
        
        btn.addTarget(self, action: #selector(showHistoryPage), for: .touchUpInside)
        
        return btn
    }()
    
    
    private let bigLabel: UILabel = {
        let lb = UILabel()
        lb.text = "SplitCal"
        lb.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        lb.textColor = .black
        
        return lb
    }()
    
    private let emailLabel: UILabel = {
        let lb = UILabel()
        lb.text = "(You not signed in)"
        lb.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lb.textColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        lb.textAlignment = .center
        lb.adjustsFontSizeToFitWidth = true
        
        return lb
    }()
    
    //MARK: - Bill tf
    
    private let billLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Bill:"
        lb.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        lb.textColor = .black
        
        return lb
    }()
    
    
    private let billTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.font = UIFont.systemFont(ofSize: 24)
        tf.textColor = .black
        tf.keyboardAppearance = .dark
        tf.keyboardType = .decimalPad
        //tf.autoresizesSubviews = true
        tf.adjustsFontSizeToFitWidth = true
        tf.attributedPlaceholder = NSAttributedString(string: "Your Bill..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]) //let customize the placeHolder
        
        return tf
    }()
    
    private let billUnder: UIView = {
        let uv = UIView()
        uv.backgroundColor = .black
        uv.setHeight(height: 2)
        
        return uv
    }()
    
    private let dollarSignLabel: UILabel = {
        let lb = UILabel()
        lb.text = "$"
        lb.font = UIFont.systemFont(ofSize: 24)
        lb.textColor = .black
        
        return lb
    }()
    
    //MARK: - Tip tf
    
    private let percentTipTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .clear
        tf.font = UIFont.systemFont(ofSize: 24)
        tf.textColor = .black
        tf.keyboardAppearance = .dark
        tf.keyboardType = .decimalPad
        tf.adjustsFontSizeToFitWidth = true
        tf.attributedPlaceholder = NSAttributedString(string: "Your tip..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]) //let customize the placeHolder
        
        return tf
    }()
    
    private let percentTipLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Tip:"
        lb.font = UIFont.systemFont(ofSize: 22)
        lb.textColor = .black
        
        return lb
    }()
    
    private let percentSignLabel: UILabel = {
        let lb = UILabel()
        lb.text = "%"
        lb.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lb.textColor = .black
        
        return lb
    }()
    
    private let tipUnder: UIView = {
        let uv = UIView()
        uv.backgroundColor = .black
        uv.setHeight(height: 2)
        
        return uv
    }()
    
    //MARK: - Tip button
    
    private let tipCustomButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        btn.setTitle("  Custom  ", for: .normal)
        btn.setTitleColor(.yellow, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        btn.layer.cornerRadius = 10
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowOpacity = 0.4
        btn.addTarget(self, action: #selector(customTipButton), for: .touchUpInside)
        
        return btn
    }()
    
    private let tip10Button: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        btn.setTitle("  10%  ", for: .normal)
        btn.setTitleColor(.yellow, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowOpacity = 0.4
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(tip10btn), for: .touchUpInside)
        
        return btn
    }()
    
    private let tip15Button: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        btn.setTitle("  15%  ", for: .normal)
        btn.setTitleColor(.yellow, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowOpacity = 0.4
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(tip15btn), for: .touchUpInside)
        
        return btn
    }()
    
    private let tip20Button: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        btn.setTitle("  20%  ", for: .normal)
        btn.setTitleColor(.yellow, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowOpacity = 0.4
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(tip20btn), for: .touchUpInside)
        
        return btn
    }()
    
    private let tip25Button: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        btn.setTitle("  25%  ", for: .normal)
        btn.setTitleColor(.yellow, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowOpacity = 0.4
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(tip25btn), for: .touchUpInside)
        
        return btn
    }()
    
    //MARK: - Split tf
    
    private let splitLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Split:"
        lb.font = UIFont.systemFont(ofSize: 22)
        lb.textColor = .black
        
        return lb
    }()
    
    private let splitNumberLabel: UILabel = {
        let lb = UILabel()
        lb.text = "1"
        lb.font = UIFont.systemFont(ofSize: 26)
        lb.textColor = .black
        
        return lb
    }()
    
    private let minusButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("-", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 50, weight: .medium)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(minusOnePeople), for: .touchUpInside)
        
        return btn
    }()
    
    private let plusButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 50, weight: .medium)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(plusOnePeople), for: .touchUpInside)
        
        return btn
    }()
    
    //MARK: - Down btn
    
    private let clearButton: UIButton = {
        let btn = UIButton(type: .system) //make click animation for type .system
        btn.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        btn.setTitle("Clear", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowOpacity = 0.4
        btn.layer.cornerRadius = 14
        btn.addTarget(self, action: #selector(clearForm), for: .touchUpInside)
        
        return btn
    }()
    
    private let calculateButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Calculate", for: .normal)
        btn.setTitleColor( #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .normal)
        //btn.backgroundColor = #colorLiteral(red: 0.2109099912, green: 0.9304302377, blue: 0.2503760916, alpha: 1)
        btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0, alpha: 1)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowOpacity = 0.4
        btn.layer.cornerRadius = 14
        btn.addTarget(self, action: #selector(calculateResult), for: .touchUpInside)
        
        return btn
    }()
    
    //MARK: - Keyboard stuff
    
    private let viewLeft: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let viewRight: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.setWidth(width: 8)
        
        return view
    }()
    
    private let doneButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(UIImage(systemName: "chevron.down.square"), for: .normal)
        btn.adjustsImageSizeForAccessibilityContentSizeCategory = true
        btn.tintColor = .white
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        btn.setDimensions(height: 34, width: 34)
        
        return btn
    }()
    

    private var logOutObserver: NSObjectProtocol?
    private var loginObserver: NSObjectProtocol?
    private var loginAlertObserver: NSObjectProtocol?
    private var loginAccount: NSObjectProtocol?
    private var signupAccount: NSObjectProtocol?
    private var presentHist: NSObjectProtocol?
    
//MARK: - ViewDidLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authentification()
        configureGradientLayer(from: 0, to: 1.2)
        keyboardButton()
        
        self.HideKeyBoard() //deal with the keyboard
        addSubview()
        configureUI()
        SignInFunctions()
    }
    
    //MARK: - Protocols
//We use the "loginObserver" to receive signal from many ViewControllers.
        func SignInFunctions() {
            
            loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotificationCalVC, object: nil, queue: .main) { [weak self] _ in
                
                print("DEBUG: logged in update notified..")
                guard let strongSelf = self else { return }
                strongSelf.userEmail = Auth.auth().currentUser?.email ?? "no mail"
                guard let mail = strongSelf.userEmail else { return } //use "guard let" to avoid "Optional" shit
                strongSelf.emailLabel.text = "(\(mail))"
                strongSelf.alertLogIn()
                
                }
            
            loginAccount = NotificationCenter.default.addObserver(forName: .LogInNotification, object: nil, queue: .main, using: { [weak self] _ in
                
                print("DEBUG: just login from typing..")
                guard let strongSelf = self else { return }
                strongSelf.userEmail = Auth.auth().currentUser?.email ?? "no mail"
                guard let mail = strongSelf.userEmail else { return } //use "guard let" to avoid "Optional" shit
                strongSelf.emailLabel.text = "(\(mail))"
                strongSelf.alertLogIn()
            })
            
            signupAccount = NotificationCenter.default.addObserver(forName: .SignUpNotification, object: nil, queue: .main, using: { [weak self] _ in
                
                print("DEBUG: just sign up from typing..")
                guard let strongSelf = self else { return }
                strongSelf.userEmail = Auth.auth().currentUser?.email ?? "no mail"
                guard let mail = strongSelf.userEmail else { return } //use "guard let" to avoid "Optional" shit
                strongSelf.emailLabel.text = "(\(mail))"
                strongSelf.alertLogIn()
            })
            
            loginAlertObserver = NotificationCenter.default.addObserver(forName: .alertLogInNotificationCalVC, object: nil, queue: .main, using: { [weak self] _ in
                
                print("DEBUG: presenting LoginVC after dismissing ResultVC")
                guard let strongSelf = self else { return }
                strongSelf.presentLoginVC()
            })
            
            
            logOutObserver = NotificationCenter.default.addObserver(forName: .didLogOutNotificationCalVC, object: nil, queue: .main) { [weak self] _ in
                    
                print("DEBUG: logged out notified..")
                guard let strongSelf = self else { return }
                strongSelf.userEmail = "nil"
                strongSelf.emailLabel.text = "(You are not signed in)"
                strongSelf.alertLogOut()
                
                }
            
            presentHist = NotificationCenter.default.addObserver(forName: .presentHistory, object: nil, queue: .main) { [weak self] _ in
                    
                print("DEBUG: presenting histVC after deleting..")
                guard let strongSelf = self else { return }
                let vc = HistoryCellViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                nav.modalTransitionStyle = .crossDissolve
                strongSelf.present(nav, animated: true)
                }
            
            }
        
        //this func is exclusively unique for protocol
        deinit {
            if let observer1 = logOutObserver {
                NotificationCenter.default.removeObserver(observer1)
            }
            if let observer2 = loginObserver {
                NotificationCenter.default.removeObserver(observer2)
            }
            if let observer3 = loginAlertObserver {
                NotificationCenter.default.removeObserver(observer3)
            }
            if let observer4 = loginAccount {
                NotificationCenter.default.removeObserver(observer4)
            }
            if let observer5 = signupAccount {
                NotificationCenter.default.removeObserver(observer5)
            }
            if let observer6 = presentHist {
                NotificationCenter.default.removeObserver(observer6)
            }
        }
    
    
//MARK: - selectors, functions
//let's deal with authentification
        
    func authentification() {
        if userEmail == nil || userEmail == "nil" {
            print("DEBUG: user not logged in..")
            
        } else {
            guard let email = Auth.auth().currentUser?.email else {
                return
            } //use "guard let" to avoid the "Optional" shit
            emailLabel.text = "(\(email))"
        }
        
    }
    
    
//let's deal with the keyboard without the use of IQKeyboardManager (tap anywhere to dismiss it)
        
    func HideKeyBoard() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
            view.addGestureRecognizer(tap)
        }
        
        @objc func DismissKeyboard() {
            print("DEBUG: dismissing keyboard..")
            view.endEditing(true)
        }
    
    
//let's deal with button above the keyboard (appears when keyboard pops up)
//keep in mind that when we create the inputAccessoryView of the keyboard, then the default "done" button from IQKeyboardManager will disappear
    
    func keyboardButton () {
        let stacks = UIStackView(arrangedSubviews: [viewLeft, doneButton, viewRight])
        stacks.axis = .horizontal
        doneButton.anchor(bottom: stacks.bottomAnchor, paddingBottom: 4)
        stacks.frame = CGRect(x: 0, y: 0, width: 10, height: 38) //only the height is adjustable
        billTextField.inputAccessoryView = stacks
        percentTipTextField.inputAccessoryView = stacks
    }

//MARK: - Anchor stuff
//General UI setup (this an be extremely long)
    
    func addSubview() {
        view.addSubview(profileButton)
        view.addSubview(bigLabel)
        view.addSubview(historyButton)
        view.addSubview(folderButton)
        view.addSubview(emailLabel)
        
        view.addSubview(billLabel)
        view.addSubview(billTextField)
        view.addSubview(dollarSignLabel)
        view.addSubview(billUnder)
        
        view.addSubview(percentTipTextField)
        view.addSubview(percentTipLabel)
        view.addSubview(percentSignLabel)
        view.addSubview(tipUnder)
        view.addSubview(tipCustomButton)
        view.addSubview(tip10Button)
        view.addSubview(tip15Button)
        view.addSubview(tip20Button)
        view.addSubview(tip25Button)
        
        view.addSubview(splitLabel)
        view.addSubview(splitNumberLabel)
        view.addSubview(minusButton)
        view.addSubview(plusButton)
        
        view.addSubview(clearButton)
        view.addSubview(calculateButton)
    }
    
    
    func configureUI () {
        
        profileButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 14, paddingLeft: 14)
        profileButton.setDimensions(height: 40, width: 40)
        profileButton.layer.cornerRadius = profileButton.height/2
        
        bigLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        bigLabel.centerX(inView: view)

        historyButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 14, paddingRight: 14)
        historyButton.setDimensions(height: 40, width: 40)
        
        folderButton.anchor(top: historyButton.bottomAnchor, paddingTop: 12)
        folderButton.centerX(inView: historyButton)
        folderButton.setDimensions(height: 40, width: 40)
        
        emailLabel.anchor(top: bigLabel.bottomAnchor, left: profileButton.rightAnchor, right: historyButton.leftAnchor, paddingTop: 6)
        
//MARK: - Bill anchor
        
        billLabel.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 20)
        billLabel.centerY(inView: billTextField)
        
        billTextField.anchor(top: emailLabel.bottomAnchor, paddingTop: 54) //gotta have the "safeArea" stuff
        billTextField.centerX(inView: view)
        billTextField.setDimensions(height: 34, width: 80)
        
        dollarSignLabel.anchor(right: billTextField.leftAnchor, paddingRight: 2)
        dollarSignLabel.centerY(inView: billTextField)
        
        billUnder.anchor(top: billTextField.bottomAnchor, left: dollarSignLabel.leftAnchor, right: billTextField.rightAnchor, paddingTop: 2)
        
//MARK: - Tip anchor
        
        percentTipTextField.anchor(top: billTextField.bottomAnchor, paddingTop: 50)
        percentTipTextField.centerX(inView: view)
        percentTipTextField.setDimensions(height: 34, width: 80)
        
        percentTipLabel.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 20)
        percentTipLabel.centerY(inView: percentTipTextField)
        
        percentSignLabel.anchor(right: percentTipTextField.leftAnchor, paddingRight: 2)
        percentSignLabel.centerY(inView: percentTipTextField)
        
        tipUnder.anchor(top: percentTipTextField.bottomAnchor, left: percentSignLabel.leftAnchor, right: percentTipTextField.rightAnchor, paddingTop: 2)
        
        tipCustomButton.anchor(right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 20)
        tipCustomButton.centerY(inView: percentTipTextField)
        
        let stack = UIStackView(arrangedSubviews: [tip10Button, tip15Button, tip20Button, tip25Button])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        //stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: tipUnder.bottomAnchor, left: percentTipLabel.leftAnchor, right: tipCustomButton.rightAnchor, paddingTop: 30)
        stack.setHeight(height: 40)
        
//MARK: - Split anchor
        
        splitNumberLabel.anchor(top: stack.bottomAnchor, paddingTop: 40)
        splitNumberLabel.centerX(inView: view)
        
        minusButton.anchor(right: splitNumberLabel.leftAnchor, paddingRight: 20)
        minusButton.centerY(inView: splitNumberLabel)
        
        plusButton.anchor(left: splitNumberLabel.rightAnchor, paddingLeft: 20)
        plusButton.centerY(inView: splitNumberLabel)
        
        splitLabel.anchor(left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 20)
        splitLabel.centerY(inView: splitNumberLabel)
        
//MARK: - Down btn anchor
        
        clearButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 20, paddingBottom: 110)
        clearButton.setDimensions(height: 62, width: 90)
        
        calculateButton.anchor(left: clearButton.rightAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 14, paddingRight: 20)
        calculateButton.centerY(inView: clearButton)
        calculateButton.setHeight(height: 62)
        
        
    }
    
    
    
//MARK: - Showing stuff
    
    @objc func showProfilePage () {
        
        if userEmail == nil || userEmail == "nil" {
            print("DEBUG: user not signed in, no profile page..")
            alertSignIn(Title: "Signed in required!", comment: "Please sign in to view your profile.", buttonNote1: "Cancel", buttonNote2: "Sign in")
        } else {
            print("DEBUG: Loading profile page..")
            let vc = ProfileViewController()
            vc.modalTransitionStyle = .coverVertical
            //vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    @objc func showHistoryPage() {
        
        if userEmail == nil || userEmail == "nil" {
            print("DEBUG: user not signed in, no History page..")
            alertSignIn(Title: "Sign in required!", comment: "Please sign in to see your bookmark where your saved results are stored.", buttonNote1: "Cancel", buttonNote2: "Sign in")
        } else {
            print("DEBUG: loading history page..")
            let vc = HistoryCellViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .coverVertical
            present(nav, animated: true)
        }
        
    }
    
    
    //let do some alerts signIn
    func alertSignIn (Title: String, comment: String, buttonNote1: String, buttonNote2: String) {
        
        let alert = UIAlertController (title: Title, message: comment, preferredStyle: .alert)
        let action1 = UIAlertAction (title: buttonNote1, style: .cancel, handler: nil)
        let action2 = UIAlertAction (title: buttonNote2, style: .default) { (action) in
            self.presentLoginVC()
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        present (alert, animated: true, completion: nil)
    }
    
    
    func presentLoginVC() {
        print("DEBUG: loading LoginVC..")
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    
//MARK: - other selectors, functions
    
    @objc func dismissKeyboard() {
        print("DEBUG: dismissing keyboard..")
        billTextField.resignFirstResponder()
        percentTipTextField.resignFirstResponder()
    }
    
    @objc func customTipButton() {
        print("DEBUG: customTipButton tapped..")
        percentTipTextField.becomeFirstResponder()
    }
    @objc func tip10btn() {
        print("DEBUG: tip 10 tapped..")
        percentTipTextField.text = "10"
        dismissKeyboard()
    }
    @objc func tip15btn() {
        print("DEBUG: tip 15 tapped..")
        percentTipTextField.text = "15"
        dismissKeyboard()
    }
    @objc func tip20btn() {
        print("DEBUG: tip 20 tapped..")
        percentTipTextField.text = "20"
        dismissKeyboard()
    }
    @objc func tip25btn() {
        print("DEBUG: tip 25 tapped..")
        percentTipTextField.text = "25"
        dismissKeyboard()
    }
    
    
    @objc func plusOnePeople() {
        print("DEBUG: adding 1 people..")
        
        if let number = Int(splitNumberLabel.text!) {
            splitNumberLabel.text = "\(number + 1)"
        } else {
            print("DEBUG: error adding people")
        }
        
    }
    
    
    @objc func minusOnePeople() {
        print("DEBUG: subtracting 1 people..")
        
        if let number = Int(splitNumberLabel.text!), number > 1 {
            splitNumberLabel.text = "\(number - 1)"
        } else {
            print("DEBUG: error subtracting people")
        }
        
    }
    
    
    @objc func clearForm() {
        print("DEBUG: clearing all form..")
        billTextField.text = ""
        percentTipTextField.text = ""
        splitNumberLabel.text = "1"
        
    }
    
//MARK: - Calculation stuff
    
    @objc func calculateResult () {
        print("DEBUG: Calculating result..")
        
        let data = calculation()
        
        //let's validate the input from func calculation
        print("DEBUG: experiment: ", data)
        if data["Result"] == 0 {
            print("DEBUG: gotta stop due to invalid input..")
            return //this command stops the code from running further
        }
        
        //let's pass data into another screen (ResultViewCOntroller)
        let vc = ResultViewController()
        
        vc.totalMoney = data["iBill"] ?? 0
        vc.percentTip = data["%tip"] ?? 0
        vc.overallMoney = data["fBill"] ?? 0
        vc.numberOfPeople = Int(data["people"] ?? 0)
        vc.eachMoney = data["sBill"] ?? 0
        
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true, completion: nil)
        
        print("DEBUG: presenting ResultVC..")
        
    }
    
    
    
    func calculation() -> [String: Double] {
        
        //let's check for input validation
        guard let billText = Double(billTextField.text!), let tipText = Double(percentTipTextField.text!), let splitLb = Double(splitNumberLabel.text!) else {
            
            if billTextField.hasText == false {
                print("DEBUG: billTextField is empty..")
                alert(error: "Please enter your bill", buttonNote: "OK")
                return ["Result": 0]
            }
            else if percentTipTextField.hasText == false {
                print("DEBUG: %tipTextField is empty..")
                alert(error: "Please enter your tip percentage", buttonNote: "OK")
                return ["Result": 0]
            } else {
                print("DEBUG: Error input..")
                alert(error: "Please make sure all inputs are valid", buttonNote: "OK")
                return ["Result": 0]
            }
            
        } //Done "else" block of guard let
        
        let overallBill = billText + (billText * tipText/100)
        let splitBill = overallBill / splitLb
        
        let dataDict: [String: Double] = ["fBill": overallBill, "sBill": splitBill, "people": splitLb, "iBill": billText, "%tip": tipText]
        
        return dataDict
    }
    
}




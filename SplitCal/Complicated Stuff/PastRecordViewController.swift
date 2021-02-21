//
//  PastRecordViewController.swift
//  SplitCal
//
//  Created by Long Nguyen on 1/5/21.
//

import UIKit
import Firebase
import JGProgressHUD

class PastRecordViewController: UIViewController {
    
//MARK: - Properties
    
    var titlePrivate = "No title" //this var will get its result from HistoryCellVC
    var timeSaved = Timestamp(date: Date())
    let userEmail = Auth.auth().currentUser?.email ?? "no email"
    var deletePro: NSObjectProtocol?
    
    private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Date: "
        lb.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        lb.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        return lb
    }()
    
    private let dividerView: UIView = {
        let dv = UIView()
        dv.backgroundColor = .black
        dv.setHeight(height: 2)
        
        return dv
    }()
    
    private let billLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Your bill was: $60"
        lb.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        lb.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        return lb
    }()
    
    private let percentTipLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Percent tip: "
        lb.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        lb.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        return lb
    }()
    
    private let splitLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Split: "
        lb.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        lb.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        return lb
    }()
    
    private let totalBillLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Total bill with tip: "
        lb.numberOfLines = 2
        lb.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        lb.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        return lb
    }()
    
    private let eachBillLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Each people payed: "
        lb.numberOfLines = 2
        lb.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        lb.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        return lb
    }()

    
//MARK: - View Scenes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        fetchResultsInfo()
        configureUI()
        
    }
    
    
    func configureUI () {
        
        configureNavigationBar(title: "\(titlePrivate)", preferLargeTitle: true)
        
        //we use the line below to customize the back button (if needed)
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(deleteAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(actionSheetDelete))

        
        let stack1 = UIStackView(arrangedSubviews: [dateLabel, billLabel, percentTipLabel, splitLabel])
        stack1.spacing = 8
        stack1.axis = .vertical
        view.addSubview(stack1)
        stack1.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 20, paddingLeft: 20)
        
        view.addSubview(dividerView)
        dividerView.anchor(top: stack1.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 14, paddingLeft: 16, paddingRight: 16)
        
        
        let stack2 = UIStackView(arrangedSubviews: [totalBillLabel, eachBillLabel])
        stack2.spacing = 8
        stack2.axis = .vertical
        view.addSubview(stack2)
        stack2.anchor(top: dividerView.bottomAnchor, left: stack1.leftAnchor, paddingTop: 20)
        
    }
    
    
//MARK: - Selectors
    
    
    @objc func actionSheetDelete() {
        print("DEBUG: presenting actionSheet deletion..")
        
        let alert = UIAlertController (title: "Delete?", message: "Items will be permanently deleted from the Database.", preferredStyle: .actionSheet)
        let cancel = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction (title: "Delete", style: .destructive, handler: { _ in
            
            self.deleteAction()
        })
        
        alert.addAction(cancel)
        alert.addAction(delete)
        present (alert, animated: true, completion: nil)
    }
    
    func deleteAction () {
        print("DEBUG: deleting items..")
        showLoader(show: true, text: "Deleting", view: view)
        
        Firestore.firestore().collection("users").document(userEmail).collection("save-results").document(titlePrivate).delete { (error) in
            
            guard error == nil else {
                print("DEBUG: error deleting save-results..")
                self.showLoader(show: false, view: self.view)
                self.alert(error: "Error deleting items", buttonNote: "Try again")
                return
            }
            
            self.showLoader(show: false, text: "deleting", view: self.view)
            print("DEBUG: successfully deleting item")
            
            //self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            
            //let's send the notification to CalVC to dismiss HistVC
            NotificationCenter.default.post(name: .presentHistory, object: nil)
        }
        
    }
    
    func timestampVM() -> String {
        let dateVM = timeSaved.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a - MMM d ,yyyy " //just search GG to find an appropriate date format
        
        return dateFormatter.string(from: dateVM)
    }
    
    //MARK: - Fetching results
    
    func fetchResultsInfo() {
        print("DEBUG: fetching results infomation..")
        showLoader(show: true, view: self.view)
       
        Firestore.firestore().collection("users").document(userEmail).collection("save-results").document(titlePrivate).getDocument { (snapshot, error) in
            
            if let e = error {
                print("DEBUG: we got error: \(e.localizedDescription)")
                self.showLoader(show: false, view: self.view)
                self.alert(error: "unable to load data", buttonNote: "Try again")
                return
            }
            
            guard let dictResult = snapshot?.data() else {
                print("DEBUG: cannot set snapshot..")
                self.showLoader(show: false, view: self.view)
                self.alert(error: "Cannot load data", buttonNote: "Try again")
                return
            }
            
            let userResultFetched = Results(dictionary: dictResult)
            
            self.timeSaved = userResultFetched.timeDate
            let timeL = self.timestampVM() //call the func after we set appropriate value for timeSaved
            
            let billT = userResultFetched.totalBill
            let percent = userResultFetched.percentT
            let splitP = userResultFetched.splitPeople
            let billPlusTip = userResultFetched.billAndTip
            let splitB = userResultFetched.eachPeopleBill
            
            self.dateLabel.text = "Date: \(timeL)"
            self.billLabel.text = "Your bill was: \(billT)"
            self.percentTipLabel.text = "Percent tip: \(percent)"
            self.splitLabel.text = "Split: \(splitP)"
            self.totalBillLabel.text = "Total bill with tip: \(billPlusTip)"
            self.eachBillLabel.text = "Each people payed: \(splitB)"
            
            self.showLoader(show: false, view: self.view)
        }
        
        print("DEBUG: done fetching results info..")
    } //end of func
    
    
    
}

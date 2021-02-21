//
//  HistoryCellViewController.swift
//  SplitCal
//
//  Created by Long Nguyen on 1/5/21.
//

import UIKit
import Firebase
import JGProgressHUD

class HistoryCellViewController: UIViewController {
    
//MARK: Properties
    
    private let identifier = "historyCell"
    private let userEmail = Auth.auth().currentUser?.email ?? "no email"
    private var arrayResults = [Results]()
    private var reloadTableProtocol: NSObjectProtocol?
    private var rowNumber = IndexPath(item: 0, section: 0)
    private var cellName = ""
    
    private let tableView: UITableView = {
        let tv = UITableView()
        
        return tv
    }()
    
    
    private let noResultSavedLabel: UILabel = {
        let lb = UILabel()
        lb.text = "No saved data."
        lb.textAlignment = .center
        lb.textColor = .link
        lb.numberOfLines = .zero
        lb.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        lb.backgroundColor = .clear
        lb.isHidden = true
        
        return lb
    }()
    
    
//MARK: - View Scenes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchResultInfo()
        configureUI()
        configureTableView()
        
    }
    
    
    //MARK: - UI stuff
    
    func configureUI() {
        configureNavigationBar(title: "History", preferLargeTitle: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss ", style: .done, target: self, action: #selector(dismissHistoryVC)) //style can be .plain
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        //tableView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.tableFooterView = UIView() //eliminate the unnecessary lines if there is no cell
        
        tableView.addSubview(noResultSavedLabel)
        noResultSavedLabel.anchor(top: tableView.topAnchor,left: tableView.leftAnchor, right: tableView.rightAnchor, paddingTop: 50, paddingLeft: 30, paddingRight: 30)
        noResultSavedLabel.centerX(inView: tableView)
    }
    
    
    
//MARK: - selectors
    
    @objc func dismissHistoryVC() {
        print("DEBUG: going back to calculationVC..")
        dismiss(animated: true, completion: nil)
        
        /*if cellName != "" {
            deleteItem(name: cellName)
            dismiss(animated: true, completion: nil)
        } else {
            print("DEBUG: regular dismiss")
            dismiss(animated: true, completion: nil)
        }*/
        
    }
    
    func timestampVM(number: Int) -> String {
        let dateVM = arrayResults[number].timeDate.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-d" //just search GG to find an appropriate date format
        
        return dateFormatter.string(from: dateVM)
    }
    
    //MARK: - API stuff
    
    func deleteItem(name: String) {
        showLoader(show: true, text: "Deleting", view: view)
        
        Firestore.firestore().collection("users").document(userEmail).collection("save-results").document(name).delete { (error) in
            
            guard error == nil else {
                print("DEBUG: error deleting save-results..")
                self.showLoader(show: false, view: self.view)
                self.alert(error: "Error deleting items", buttonNote: "Try again")
                return
            }
            
            self.showLoader(show: false, text: "deleting", view: self.view)
            print("DEBUG: successfully deleting item from Firebase")
            self.dismiss(animated: true, completion: nil)
            
            //let's send the notification to CalVC to dismiss HistVC
            NotificationCenter.default.post(name: .presentHistory, object: nil)
        }
        
    }
    
    func fetchResultInfo() {
        print("DEBUG: fetching result info..")
        showLoader(show: true, view: self.view)
        
        //we use this way, "query way", to show all documents in a collection.
        let query = Firestore.firestore().collection("users").document(userEmail).collection("save-results").order(by: "Timestamp")
        
        print("DEBUG: the query is \(query)")
        
        query.addSnapshotListener { (snapshot, error) in
            
            let saveVerify = snapshot?.count
            
            if saveVerify == 0 {
                print("DEBUG: no save result..")
                self.showLoader(show: false, view: self.view)
                self.noResultSavedLabel.isHidden = false
                
            } else {
                snapshot?.documentChanges.forEach({ change in
                    let dictResult = change.document.data()
                    let resultFetched = Results(dictionary: dictResult)
                    self.arrayResults.append(resultFetched)
                    self.tableView.reloadData() //this line will constantly update our tableView's cells to its latest version
                    self.showLoader(show: false, view: self.view)
                })
            } //done if - else
        
        }
        
    } //end of func
    
    
}


//MARK: - Extension Datasource

extension HistoryCellViewController: UITableViewDataSource {
    
    //this func is constantly called for every action we do
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("DEBUG: we have \(arrayResults.count) rows")
        return arrayResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let time = timestampVM(number: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.textLabel?.text = "\(time):  \(arrayResults[indexPath.row].mainTitle)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return cell
    }
    
    //this func creates a swipe gesture to delete a row, but cannot do anything with API database, so we gotta dismiss and present the view again
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
        print("DEBUG: swipe gesture activated")
        let index = IndexPath(item: indexPath.row, section: 0)
        rowNumber = index
        print("DEBUG: rowNo \(rowNumber)")
        
        
        let alert = UIAlertController (title: "Deleted this item?", message: "This item will be permanently deleted from the server", preferredStyle: .alert)
        let cancel  = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction (title: "Delete", style: .default) { (action) in
            print("DEBUG: deletion confirmed..")
            
            //the block below is to delete a row, but cantt do anything API
            /*if editingStyle == .delete {
                print("DEBUG: Deleting stuff from Datasource")
                self.cellName = self.arrayResults[self.rowNumber.row].mainTitle
                print("\(self.cellName)")
                self.arrayResults.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [self.rowNumber], with: .automatic)
            }*/
            self.cellName = self.arrayResults[self.rowNumber.row].mainTitle
            self.deleteItem(name: self.cellName)
            
        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    } // end of func
    
    
}

//MARK: - Extension delegate

extension HistoryCellViewController: UITableViewDelegate {
    
    //make each cell responsive each time we click on it
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true) //unhighlight the selected row/cell
        
        let vc = PastRecordViewController()
        vc.titlePrivate = arrayResults[indexPath.row].mainTitle
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


import UIKit

class DonorHomeVC: UIViewController {
 
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
   var allContacts: [BloodRequestData] = []
   var filteredContacts: [BloodRequestData] = []
   
    lazy var refreshControl: UIRefreshControl = {
          let refreshControl = UIRefreshControl()
          refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
          return refreshControl
      }()
    
  override func viewDidLoad() {
      super.viewDidLoad()
      self.tableView.registerCells([ChatListCell.self])
      self.tableView.delegate = self
      self.tableView.dataSource = self
      self.tableView.showsVerticalScrollIndicator = false
      self.searchTextField.delegate = self
      tableView.refreshControl = refreshControl
      
  }
    
    override func viewWillAppear(_ animated: Bool) {
        getBloodRequest()
    }
    
    @objc func refreshData() {
           // Call your getBloodRequest function
           getBloodRequest()
           // Stop refreshing animation
           refreshControl.endRefreshing()
       }
    
   
    
    func getBloodRequest(){
        
        FireStoreManager.shared.getBloodRequests(mobile: getMobile()) { err, data in
             
            if let err =  err {
                print(err)
                return
            }
            self.allContacts = data!.sorted(by: { $0.requestToName < $1.requestToName })
            self.filteredContacts = self.allContacts
            self.tableView.reloadData()
            
        }
    }
   
}



extension DonorHomeVC: UITableViewDelegate, UITableViewDataSource {
 
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
          return filteredContacts.count
       
  }
   
   
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = self.tableView.dequeueReusableCell(withIdentifier:"ChatListCell", for: indexPath) as! ChatListCell
    
          let contact = filteredContacts[indexPath.row]
          cell.contactName.text = "\(contact.requestByName)"
          cell.contactNumber.text = contact.requestByMobile
          cell.boldLabel.text = contact.requestByName.first!.description
          cell.bgView.backgroundColor = getRandomColor()
          cell.messageView.isHidden = true
          cell.lastMessage.text = "BloodGroup- \(contact.requestForBloodGroup)   Status : \(contact.status!)"
          cell.borderView.dropShadow()
       
   
      return cell
      
  }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
           let data = filteredContacts[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfileRequested") as! OtherUserProfileRequested
           vc.bloodRequestData = data
           vc.showForDonor = true
           vc.modalPresentationStyle = .fullScreen
           self.navigationController?.pushViewController(vc, animated: true)
       
   }


}



extension DonorHomeVC: UITextFieldDelegate {
   
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
         performSearch(searchText: currentText.lowercased())
         return true
   }
   
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
  }
  
  func performSearch(searchText: String) {
      if searchText.isEmpty {
          self.filteredContacts = allContacts
      } else {
          filteredContacts = allContacts.filter { contact in
              let contactText = "\(contact.requestToName) \(contact.requestToMobile)".lowercased()
              return contactText.contains(searchText)
          }
      }
      tableView.reloadData()
  }
}



 
import UIKit

class PatientVC: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var allContacts: [User] = []
    var filteredContacts: [User] = []
    
   override func viewDidLoad() {
       super.viewDidLoad()
       self.tableView.registerCells([ChatListCell.self])
       self.tableView.delegate = self
       self.tableView.dataSource = self
       self.tableView.showsVerticalScrollIndicator = false
       self.searchTextField.delegate = self
       
       FireStoreManager.shared.getAllUsersByType(userType: .Donor) { users in
           
           if(users.count > 0) {
               self.allContacts = users.sorted(by: { $0.name! < $1.name! })
               self.filteredContacts = self.allContacts
               self.tableView.reloadData()
           }
        
       }
       
   }
    
    @IBAction func onRequsetList(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestListVC") as! RequestListVC
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // Add this function in your ChatListVC class
    func getContactName(for mobileNumber: String) -> String {
        let formattedMobileNumber = formatPhoneNumber(mobileNumber)
        
        if let contact = allContacts.first(where: { formatPhoneNumber($0.mobile!).contains(formattedMobileNumber) }) {
            return "\(contact.name!)"
        } else {
            return "Admin"
        }
    }
   
}



extension PatientVC: UITableViewDelegate, UITableViewDataSource {
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
           return filteredContacts.count
        
   }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let cell = self.tableView.dequeueReusableCell(withIdentifier:"ChatListCell", for: indexPath) as! ChatListCell
     
           let contact = filteredContacts[indexPath.row]
           cell.contactName.text = "\(contact.name!)"
           cell.contactNumber.text = contact.mobile
           cell.boldLabel.text = contact.name?.first?.description
           cell.bgView.backgroundColor = getRandomColor()
           cell.messageView.isHidden = true
           cell.lastMessage.text = "Blood Group \(contact.bloodGroup!)"
           cell.borderView.dropShadow()
        
    
       return cell
       
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
            let user = filteredContacts[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
            vc.user = user
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        
    }


}



extension PatientVC: UITextFieldDelegate {
    
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
               let contactText = "\(contact.name!) \(contact.mobile!)".lowercased()
               return contactText.contains(searchText)
           }
       }
       tableView.reloadData()
   }
}

 

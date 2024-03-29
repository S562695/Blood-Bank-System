
import UIKit

class ReciversListVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
   var allContacts: [User] = []
   var filteredContacts: [User] = []
   
   var selectedIndex = 0
    
   override func viewDidLoad() {
       super.viewDidLoad()
     
       self.tableView.registerCells([ChatListCell.self])
       self.tableView.delegate = self
       self.tableView.dataSource = self
       self.tableView.showsVerticalScrollIndicator = false
       self.searchTextField.delegate = self
       
       navigationController?.setNavigationBarHidden(true, animated: true)
   }
    
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        FireStoreManager.shared.getAllUsersByType(userType: .Patient) { users in
            
            if(users.count > 0) {
                self.allContacts = users.sorted(by: { $0.name! < $1.name! })
                self.filteredContacts = self.allContacts
                self.tableView.reloadData()
            }
         
        }
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



extension ReciversListVC: UITableViewDelegate, UITableViewDataSource {
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filteredContacts.count
   }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let contact = filteredContacts[indexPath.row]
       
       let cell = self.tableView.dequeueReusableCell(withIdentifier:"ChatListCell", for: indexPath) as! ChatListCell
       
       cell.contactName.text = contact.name
       cell.contactNumber.text = contact.mobile
       cell.boldLabel.text = cell.contactName.text?.first?.description
       cell.bgView.backgroundColor = getRandomColor()
       cell.messageView.isHidden = true
       
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



extension ReciversListVC: UITextFieldDelegate {
    
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
 

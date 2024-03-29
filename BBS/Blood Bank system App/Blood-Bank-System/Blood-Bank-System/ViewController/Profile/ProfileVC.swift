
import UIKit

 
class ProfileVC: UIViewController {
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var profileTilte: UILabel!
    var documentId = ""
   
    override func viewWillAppear(_ animated: Bool) {
       
        self.email.text = UserDefaultsManager.shared.getEmail().capitalized
       
        FireStoreManager.shared.dbRef.document(UserDefaultsManager.shared.getDocumentId()).getDocument { (document, error) in
            if let error = error {
                print(error)
            } else {
                if let document = document, document.exists {
                    // Document exists, you can access its data
                    if let data = document.data() {
                        self.fullName.text = data["name"] as? String ?? ""
                        self.mobile.text = data["mobile"] as? String ?? ""
                        self.address.text = data["address"] as? String ?? ""
                        let userType = data["userType"] as? String ?? ""
                        let bloodGroup = data["bloodGroup"] as? String ?? ""
                        self.documentId = document.documentID
                        self.profileTilte.text = "\(userType) \(bloodGroup) Blood Group"
                    }
                } else {
                    print("Document does not exist")
                    // Handle the case where the document does not exist (e.g., show an alert)
                }
            }
        }
   }
    @IBAction func onAddress(_ sender: Any) {
        let commonVC = storyboard?.instantiateViewController(withIdentifier: "CommonUpdateVC") as! CommonUpdateVC
        commonVC.oldValue = address.text!
        commonVC.changeFor = "address"
        navigationController?.pushViewController(commonVC, animated: true)
    }
    
    @IBAction func onFullName(_ sender: Any) {
        let commonVC = storyboard?.instantiateViewController(withIdentifier: "CommonUpdateVC") as! CommonUpdateVC
        commonVC.oldValue = fullName.text!
        commonVC.changeFor = "name"
        navigationController?.pushViewController(commonVC, animated: true)
    }
    
    @IBAction func onMedical(_ sender: Any) {
        
        if(!self.documentId.isEmpty) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "DiseaseListVC" ) as! DiseaseListVC
            vc.documentId = documentId
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    @IBAction func onFaq(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "FaqVC" ) as! FaqVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   @IBAction func onLogotClicked(_ sender: Any) {
       
       showConfirmationAlert(message: "Are you sure want to logout?") { _ in
           UserDefaultsManager.shared.clearData()
           SceneDelegate.shared?.loginCheckOrRestart()
       }
      
   }
    
    @IBAction func onUpdatePasswordClicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "UpdatePasswordVC" ) as! UpdatePasswordVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}

 
import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginVC: UITableViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onLogin(_ sender: Any) {
    
        
            if(email.text!.isEmpty) {
                showAlerOnTop(message: "Please enter your email.")
                return
            }

            if(self.password.text!.isEmpty) {
                showAlerOnTop(message: "Please enter your password.")
                return
            }
         
            if(email.text == "admin@gmail.com" && password.text == "admin") {
               
               
                UserDefaultsManager.shared.saveData(name: "Admin", email: "admin@gmail.com", password: "admin", userType: UserType.Admin.rawValue,mobile:"1234512123", address: "")
                   
                    
                SceneDelegate.shared?.loginCheckOrRestart()
                
               
                
            }else {
                
                FireStoreManager.shared.login(email: email.text?.lowercased() ?? "", password: password.text ?? "") { success in
                    if success{
                            SceneDelegate.shared?.loginCheckOrRestart()
                    }
                    
                }
            }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "SignUpTableVC" ) as! SignUpTableVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


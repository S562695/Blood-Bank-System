 
import UIKit

class SignUpTableVC: UITableViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var userType: UITextField!
    @IBOutlet weak var bloodGroupType: UITextField!
    @IBOutlet weak var mobile: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userType.isEnabled = false
        self.bloodGroupType.isEnabled = false
        self.title = "Register"
    }
  
    @IBAction func onSignUp(_ sender: Any) {
        if validate(){
            
            var userType = UserType.Admin
            
            if((self.userType.text!.lowercased().contains("d"))) {
                userType = .Donor
            }
            if((self.userType.text!.lowercased().contains("p"))) {
                userType = .Patient
            }
            
            FireStoreManager.shared.signUp(email: self.email.text ?? "", name: self.name.text ?? "", password: self.password.text ?? "", userType:userType, bloodGroup: self.bloodGroupType.text!,mobile:mobile.text!)
        }
        
    }
    @IBAction func onUserType(_ sender: Any) {
        
        let picker = GlobalPicker()
        picker.stringArray = [UserType.Donor.rawValue,UserType.Patient.rawValue,UserType.Admin.rawValue]
               picker.onDone = { selectedIndex in
                
                   self.userType.text = picker.stringArray[selectedIndex]
               }
        picker.modalPresentationStyle = .overCurrentContext
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func onBloodGroup(_ sender: Any) {
        
        let picker = GlobalPicker()
        picker.stringArray =  bloodGroups
               picker.onDone = { selectedIndex in
                   self.bloodGroupType.text = picker.stringArray[selectedIndex]
               }
        picker.modalPresentationStyle = .overCurrentContext
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func onLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validate() ->Bool {
        
        if(self.name.text!.isEmpty) {
            showAlerOnTop(message: "Please enter full name.")
            return false
        }
        
        if(self.email.text!.isEmpty) {
            showAlerOnTop(message: "Please enter email.")
            return false
        }
        
        if !email.text!.emailIsCorrect() {
            showAlerOnTop(message: "Please enter valid email id")
            return false
        }
        
        
        if(self.userType.text!.isEmpty) {
            showAlerOnTop(message: "Please select User type.")
            return false
        }
        
        
        if(self.mobile.text!.isEmpty) {
            showAlerOnTop(message: "Please enter mobile number.")
            return false
        }
        
     
            
            if self.mobile.text!.count != 10 {
                showAlerOnTop(message: "Please enter a valid mobile number with exactly 10 digits")
                return false
            }
            
            if !self.mobile.text!.allSatisfy({ $0.isNumber }) {
                showAlerOnTop(message: "Please enter a valid mobile number with exactly 10 digits")
                return false
            }
        
        
        
        if(self.bloodGroupType.text!.isEmpty) {
            showAlerOnTop(message: "Please select Blood Group.")
            return false
        }
    
        if(self.password.text!.isEmpty) {
            showAlerOnTop(message: "Please enter password.")
            return false
        }
        
        return true
    }
}




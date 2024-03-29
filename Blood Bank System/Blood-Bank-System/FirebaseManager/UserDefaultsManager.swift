
import Foundation

class UserDefaultsManager  {
   
   static  let shared =  UserDefaultsManager()
   
   func clearUserDefaults() {
       
       let defaults = UserDefaults.standard
       let dictionary = defaults.dictionaryRepresentation()

           dictionary.keys.forEach
           {
               key in   defaults.removeObject(forKey: key)
           }
   }
       
   
   func isLoggedIn() -> Bool{
       
       let email = getEmail()
       
       if(email.isEmpty) {
           return false
       }else {
          return true
       }
     
   }
    
   func getEmail()-> String {
       
       let email = UserDefaults.standard.string(forKey: "email") ?? ""
       
       print(email)
      return email
   }
   
   func getName()-> String {
      return UserDefaults.standard.string(forKey: "name") ?? ""
   }
    
    func getAddress()-> String {
      return UserDefaults.standard.string(forKey: "address") ?? ""
    }
    
    func saveAddress(address:String){
        UserDefaults.standard.setValue(address, forKey: "address")
    }
   
   func getUserName()-> String {
      return UserDefaults.standard.string(forKey: "username") ?? ""
   }
   
   func getPhone()-> String {
      return UserDefaults.standard.string(forKey: "phone") ?? ""
   }
   
   func getPassword()-> String {
      return UserDefaults.standard.string(forKey: "password") ?? ""
   }

   func getMobile()-> String? {
       return UserDefaults.standard.string(forKey: "mobile") ?? ""
   }
   
   func getDocumentId()-> String {
      return UserDefaults.standard.string(forKey: "documentId") ?? ""
   }
   
    func saveData(name:String, email:String, password: String,userType:String,mobile:String,address:String) {
       UserDefaults.standard.setValue(name, forKey: "name")
       UserDefaults.standard.setValue(email, forKey: "email")
       UserDefaults.standard.setValue(password, forKey: "password")
       UserDefaults.standard.setValue(userType, forKey: "userType")
       UserDefaults.standard.setValue(mobile, forKey: "mobile")
       UserDefaults.standard.setValue(address, forKey: "address")
   }
 
    
    func getUserType() -> UserType {
        
        let userType = UserDefaults.standard.string(forKey: "userType") ?? ""
        
        if((userType.lowercased().contains("do"))) {
            return .Donor
        }
        else if((userType.lowercased().contains("p"))) {
            return .Patient
        }
        else {
            return .Admin
        }
    }
    
   func clearData(){
       UserDefaults.standard.removeObject(forKey: "email")
   }
    
    func saveFavourite(title: String) {
      
        UserDefaults.standard.set(true, forKey: getEmail().lowercased() + title.lowercased())
    }
    
    // Function to get favorites
    func getFavorites(title: String) -> Bool {
        
        return UserDefaults.standard.bool(forKey:  getEmail().lowercased() + title.lowercased())
    }
    
    func removeFavorite(title: String) {
           UserDefaults.standard.removeObject(forKey: getEmail().lowercased() + title.lowercased())
    }
}

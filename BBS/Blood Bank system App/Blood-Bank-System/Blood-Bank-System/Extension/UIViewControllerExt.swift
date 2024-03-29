import UIKit
extension UIViewController {

   
   func showAlert(message:String,completion: ((_ success:Bool)->Void)?){
       let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
       let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
           completion?(true)
       }
       alert.addAction(action)
       present(alert, animated: true, completion: nil)
   }
   
   func showAlert(message:String){
       let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
       let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
           
          // completion?(true)
       }
       alert.addAction(action)
       present(alert, animated: true, completion: nil)
   }
   
   
   func restartApp() {
       print("f")
       // get a reference to the app delegate
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
       // call didFinishLaunchWithOptions ... why?
     let _ = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
   }
   
   
   func  closeAllAndMoveHome() { // main
       self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
       
   }
   
    

   func showActionSheetPopup(actionsTitle:[String], title:String?,message:String,completion:@escaping (Int) -> Void){
       
       let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
       alert.popoverPresentationController?.sourceView = self.view
       alert.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 300, width: 300, height: 500)
       alert.view.tintColor = .appColor
       for (index,actionsTitle) in actionsTitle.enumerated(){
           
           alert.addAction(UIAlertAction(title: actionsTitle, style: UIAlertAction.Style.default, handler: {(UIAlertAction)in
               
               completion(index)
               
           }))}
       
       alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
       self.present(alert, animated: true, completion: nil)
   }
   
}



 

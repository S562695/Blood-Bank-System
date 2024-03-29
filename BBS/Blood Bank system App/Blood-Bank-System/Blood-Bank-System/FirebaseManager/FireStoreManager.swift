
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift
import FirebaseDatabase
import Photos
var showBanner = false

enum UserType:String {
    case Donor = "Donor"
    case Patient = "Patient"
    case Admin = "Admin"
}


let bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]

class FireStoreManager {
   
   public static let shared = FireStoreManager()
   var hospital = [String]()
   var storageRef: StorageReference!
    
    var lastMessagesData: [LastChatModel] = []
    var db: Firestore!
    var dbRef : CollectionReference!
    var lastMessages : CollectionReference!
    var chatDbRef : CollectionReference!
    var onLineOffLine : CollectionReference!
    var onlineOfflineListener: ListenerRegistration?
    var tempListnerLastmsg: ListenerRegistration?
    var lastMessageListner: ListenerRegistration?
    var buildVersion: CollectionReference?
   var gallary : CollectionReference!
   
   init() {
       let settings = FirestoreSettings()
       Firestore.firestore().settings = settings
       db = Firestore.firestore()
       dbRef = db.collection("Users")
       gallary = db.collection("Gallary")
       storageRef = Storage.storage().reference()
       lastMessages = db.collection("LastMessages")
       chatDbRef = db.collection("Chat")
       onLineOffLine = db.collection("OnLineOffLine")
   }
    
    
    
    func changeRequestStatus(request:BloodRequestData, _ newStatus: String, documentID: String, completion: @escaping (Bool) -> ()) {
           let batch = db.batch()

           // Update sender's documentpo
        let senderDocumentRef = db.collection("BloodRequests").document(request.requestByMobile!).collection("Request").document(request.senderDocumentID!)
           batch.updateData(["status": newStatus], forDocument: senderDocumentRef)

           // Update receiver's document
        let receiverDocumentRef = db.collection("BloodRequests").document(request.requestToMobile).collection("Request").document(request.receiverDocumentID!)

           batch.updateData(["status": newStatus], forDocument: receiverDocumentRef)
  
        
        
        let adminRef = db.collection("BloodRequests").document("Admin").collection("Request").document(request.adminDocumentID!)

           batch.updateData(["status": newStatus], forDocument: adminRef)

        
           // Commit the batch
           batch.commit { (error) in
               if let error = error {
                   print("Error updating document: \(error)")
                   completion(false)
               } else {
                   completion(true)
               }
           }
       }
    
    
    func uploadImageToStorage(imageData: Data, completion: @escaping (String?) -> ()) {
            let imageName = UUID().uuidString
            let imageRef = storageRef.child("gallery/\(imageName).jpg")

            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            _ = imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                guard error == nil else {
                    // Handle error
                    print("Error uploading image to storage: \(error!.localizedDescription)")
                    completion(nil)
                    return
                }

                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Handle error
                        print("Error getting download URL: \(error?.localizedDescription ?? "")")
                        completion(nil)
                        return
                    }

                    completion(downloadURL.absoluteString)
                }
            }
        }
    
    func saveImageURLToFirestore(url: String) {
        // Assuming you have a document ID where you want to store the image URLs
        let documentID = "Images" // Replace with your actual document ID
        
        // Get the reference to the document
        let documentReference = gallary.document(documentID)

        // Check if the document exists
        documentReference.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document exists, update the array field with the new image URL
                documentReference.updateData(["imageUrls": FieldValue.arrayUnion([url])]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document updated successfully with image URL: \(url)")
                    }
                }
            } else {
                // Document doesn't exist, create a new document with the image URL
                documentReference.setData(["imageUrls": [url]]) { error in
                    if let error = error {
                        print("Error creating document: \(error)")
                    } else {
                        print("Document created successfully with image URL: \(url)")
                    }
                }
            }
        }
    }

    
    
    func getAllUsers(completion: @escaping ([User])->()) {
        db.collection("Users").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
            } else {
                var list: [User] = []
                for document in querySnapshot!.documents {
                    do {
                        var temp = try document.data(as: User.self)
                        if(temp.mobile != getMobile()) {
                            temp.documentId = document.documentID
                            list.append(temp)
                        }
                      
                    } catch let error {
                        print(error)
                    }
                }
                completion(list)
            }
        }
    } 
    
    
    func getAllUsersByType(userType:UserType,completion: @escaping ([User])->()) {
        db.collection("Users").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
            } else {
                var list: [User] = []
                for document in querySnapshot!.documents {
                    do {
                        var temp = try document.data(as: User.self)
                        if(temp.mobile != getMobile()) {
                            
                            if(temp.userType!.lowercased() == userType.rawValue.lowercased() ){
                                temp.documentId = document.documentID
                                list.append(temp)
                            }
                           
                        }
                      
                    } catch let error {
                        print(error)
                    }
                }
                completion(list)
            }
        }
    }
    
    func getBloodRequests(mobile:String,completion: @escaping (Error?, [BloodRequestData]?)->()) {
    
        let  query = db.collection("BloodRequests").document(mobile).collection("Request")
        
        query.getDocuments { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                completion(err, nil)
            } else {
                var list: [BloodRequestData] = []
                for document in querySnapshot!.documents {
                    do {
                        var data = try document.data(as: BloodRequestData.self)
                        data.documentId = document.documentID
                        list.append(data)
                    }catch let error {
                        print(error)
                    }
                }
                completion(nil, list)
            }
        }
    }
    
    func getPendingRequestsAdmin(mobile:String,completion: @escaping (Error?, [BloodRequestData]?)->()) {
    
        let  query = db.collection("BloodRequests").document(mobile).collection("Request")
        
        query.getDocuments { (querySnapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
                completion(err, nil)
            } else {
                var list: [BloodRequestData] = []
                for document in querySnapshot!.documents {
                    do {
                        var data = try document.data(as: BloodRequestData.self)
                        data.documentId = document.documentID
                        if(data.status!.lowercased().contains("admin") )  {
                            list.append(data)
                        }
                     
                    }catch let error {
                        print(error)
                    }
                }
                completion(nil, list)
            }
        }
    }
    
    
    
    
    func getAllDesises(documentId:String,completion: @escaping ([Disease])->()) {
        db.collection("Users").document(documentId).collection("Disease").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
            } else {
                var list: [Disease] = []
                for document in querySnapshot!.documents {
                    do {
                        let temp = try document.data(as: Disease.self)
                        list.append(temp)
                      
                    } catch let error {
                        print(error)
                    }
                }
                completion(list)
            }
        }
    }
   
    
    func addDesises(desisesTitle:String,details:String,completion: @escaping (Bool)->()) {
        let data = ["desisesTitle":desisesTitle, "details":details] as [String : Any]
        db.collection("Users").document(UserDefaultsManager.shared.getDocumentId()).collection("Disease").addDocument(data: data) { err in
            if let err = err {
                showAlerOnTop(message: "Error adding document: \(err)")
            } else {
                completion(true)
            }
        }
    }
    func addBloodRequest(requestTo: String, data: [String: Any], completion: @escaping (Bool) -> ()) {
        let batch = db.batch()

        // Document reference for sender
        let senderDocumentRef = db.collection("BloodRequests").document(UserDefaultsManager.shared.getMobile()!).collection("Request").document()

        // Document reference for receiver
        let receiverDocumentRef = db.collection("BloodRequests").document(requestTo).collection("Request").document()

         let adminDocumentRef = db.collection("BloodRequests").document("Admin").collection("Request").document()

        
           let senderDocumentID = senderDocumentRef.documentID
           let receiverDocumentID = receiverDocumentRef.documentID
           let adminDocumentID = adminDocumentRef.documentID

           // Update data with document IDs
           var updatedData = data
           updatedData["senderDocumentID"] = senderDocumentID
           updatedData["receiverDocumentID"] = receiverDocumentID
           updatedData["adminDocumentID"] = adminDocumentID

        
        batch.setData(updatedData, forDocument: senderDocumentRef)
        batch.setData(updatedData, forDocument: receiverDocumentRef)
        batch.setData(updatedData, forDocument: adminDocumentRef)

        // Commit the batch
        batch.commit { error in
            if let error = error {
                print("Error adding blood request: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }

   
    
    
    func haveAlreadyRequested(requestTo:String,completion: @escaping (Error?, [BloodRequestData]?)->()) {
    
        let  query = db.collection("BloodRequests").document(requestTo).collection("Request").whereField("requestBy", isEqualTo: getMobile())
        
        query.getDocuments { (querySnapshot, err) in
            
            
            if let err = err {
                print("Error getting documents: \(err)")
                completion(err, nil)
            } else {
                var list: [BloodRequestData] = []
                for document in querySnapshot!.documents {
                    do {
                        var data = try document.data(as: BloodRequestData.self)
                        data.documentId = document.documentID
                        list.append(data)
                    }catch let error {
                        print(error)
                    }
                }
                completion(nil, list)
            }
        }
    }
    
    

    
    
    func signUp(email:String,name:String,password:String,userType:UserType,bloodGroup:String,mobile:String) {
       
        self.checkAlreadyExistAndSignup(name:name,email:email,password:password, userType: userType, bloodGroup: bloodGroup,mobile: mobile)
   }

   
   func login(email:String,password:String,completion: @escaping (Bool)->()) {
       let  query = db.collection("Users").whereField("email", isEqualTo: email)
       
       query.getDocuments { (querySnapshot, err) in
        
           if(querySnapshot?.count == 0) {
               showAlerOnTop(message: "Email not found!!")
           }else {

               for document in querySnapshot!.documents {
                   print("doclogin = \(document.documentID)")
                   UserDefaults.standard.setValue("\(document.documentID)", forKey: "documentId")

                   if let pwd = document.data()["password"] as? String{

                       if(pwd == password) {

                           let name = document.data()["name"] as? String ?? ""
                           let email = document.data()["email"] as? String ?? ""
                           let password = document.data()["password"] as? String ?? ""
                           let userType = document.data()["userType"] as? String ?? ""
                           let mobile = document.data()["mobile"] as? String ?? ""
                           let address = document.data()["address"] as? String ?? ""
                           
                           UserDefaultsManager.shared.saveData(name: name, email: email, password: password, userType: userType,mobile:mobile, address: address)
                           completion(true)

                       }else {
                           showAlerOnTop(message: "Password doesn't match")
                       }


                   }else {
                       showAlerOnTop(message: "Something went wrong!!")
                   }
               }
           }
       }
  }
       
   func getPassword(email:String,password:String,completion: @escaping (String)->()) {
       let  query = db.collection("Users").whereField("email", isEqualTo: email)
       
       query.getDocuments { (querySnapshot, err) in
        
           if(querySnapshot?.count == 0) {
               showAlerOnTop(message: "Email id not found!!")
           }else {

               for document in querySnapshot!.documents {
                   print("doclogin = \(document.documentID)")
                   UserDefaults.standard.setValue("\(document.documentID)", forKey: "documentId")
                   if let pwd = document.data()["password"] as? String{
                           completion(pwd)
                   }else {
                       showAlerOnTop(message: "Something went wrong!!")
                   }
               }
           }
       }
  }
   
    func checkAlreadyExistAndSignup(name:String,email:String,password:String,userType:UserType,bloodGroup:String,mobile:String) {
       
       getQueryFromFirestore(field: "email", compareValue: email) { querySnapshot in
            
           print(querySnapshot.count)
           
           if(querySnapshot.count > 0) {
               showAlerOnTop(message: "This Email is Already Registerd!!")
           }else {
               
               
               
               self.getQueryFromFirestore(field: "mobile", compareValue: mobile) { querySnapshot in
                   
                   print(querySnapshot.count)
                   
                   if(querySnapshot.count > 0) {
                       showAlerOnTop(message: "This Mobile is Already Registerd!!")
                   }else {
                       
                       let data = ["name":name,"email":email,"password":password , "userType" : userType.rawValue , "bloodGroup":bloodGroup,"mobile":mobile] as [String : Any]
                       
                       self.addDataToFireStore(data: data) { _ in
                           
                           
                           showOkAlertAnyWhereWithCallBack(message: "Registration Success!!") {
                               
                               DispatchQueue.main.async {
                                   SceneDelegate.shared?.loginCheckOrRestart()
                               }
                               
                           }
                           
                       }
                   }
               }
           }
       }
   }
   
   func getQueryFromFirestore(field:String,compareValue:String,completionHandler:@escaping (QuerySnapshot) -> Void){
       
       dbRef.whereField(field, isEqualTo: compareValue).getDocuments { querySnapshot, err in
           
           if let err = err {
               
               showAlerOnTop(message: "Error getting documents: \(err)")
                           return
           }else {
               
               if let querySnapshot = querySnapshot {
                   return completionHandler(querySnapshot)
               }else {
                   showAlerOnTop(message: "Something went wrong!!")
               }
              
           }
       }
       
   }
   
   func addDataToFireStore(data:[String:Any] ,completionHandler:@escaping (Any) -> Void){
       let dbr = db.collection("Users")
       dbr.addDocument(data: data) { err in
                  if let err = err {
                      showAlerOnTop(message: "Error adding document: \(err)")
                  } else {
                      completionHandler("success")
                  }
    }
       
       
   }
    
   
    
  
    
    func updateData(documentid:String, userData: [String:String] ,completion: @escaping (Bool)->()) {
        let  query = db.collection("Users").document(documentid)
        
        query.updateData(userData) { error in
            if let error = error {
                print("Error updating Firestore data: \(error.localizedDescription)")
                // Handle the error
            } else {
                print("Profile data updated successfully")
                completion(true)
                // Handle the success
            }
        }
    }
    
 
 
    
    func deleteImageUrlFromFirestore(imageUrlToDelete: String,completion: @escaping (Bool)->()) {
        let documentReference = FireStoreManager.shared.gallary.document("Images")

        documentReference.getDocument { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if document.exists {
                if var imageUrls = document.data()?["imageUrls"] as? [String] {
                    // Remove the imageUrlToDelete from the array
                    if let index = imageUrls.firstIndex(of: imageUrlToDelete) {
                        imageUrls.remove(at: index)

                        // Update the Firestore document with the modified array
                        documentReference.updateData(["imageUrls": imageUrls]) { error in
                            if let error = error {
                                print("Error updating document: \(error.localizedDescription)")
                            } else {
                                completion(true)
                                print("Image URL deleted successfully from Firestore")
                            }
                        }
                    } else {
                        print("Image URL not found in the array")
                    }
                } else {
                    print("Document doesn't contain 'imageUrls' field or it is not an array.")
                }
            } else {
                print("Document does not exist")
            }
        }
    }

     

 
    
}




 

extension FireStoreManager {
    
  
    func removeLastMessageListner() {
        self.lastMessageListner?.remove()
    }
    
    
    func uploadPhoto(image: UIImage, chatId: String, completion: @escaping (String) -> Void) {
        
           guard let imageData = image.jpegData(compressionQuality: 0.5) else {
               // Handle error if image data cannot be generated
               let _ = NSError(domain: "ImageDataErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate image data"])
               completion("")
               return
           }

        let timestampString = "\(Date().timeIntervalSince1970)"
        let fileName = "\(chatId)_\(timestampString).jpg"

        
          let imageRef = storageRef.child("Images").child(chatId).child(fileName)

           // Create metadata for the image (you can customize this as needed)
           let metadata = StorageMetadata()
           metadata.contentType = "image/jpeg"

           // Upload image data to Firebase Storage
           imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
               if let error = error {
                   print(error)
                   // Handle upload error
                   completion("")
               } else {
                   // Get download URL
                    let url = "https://firebasestorage.googleapis.com/v0/b/blood-bank-system-5c0ff.appspot.com/o/Images%2F\(chatId)%2F\(fileName)\(storageimageToken)"
                   print(url)
                   completion(url)
                   
               }
           }
       }
    
}
 
extension FireStoreManager {
    
    func resetMessageCount(mobile:String,chatID:String){
        
        lastMessages.document(mobile).collection("chats").document(chatID).updateData([ "messageCount": 0])
        
    }
}

extension FireStoreManager {
    
    func saveTextChat(sendToMobile:String,userEmail:String, text:String,time:Double,chatID:String,messageType:MessageType,filePath:String){
          
          let sendToMobile =  getFormatedNumber(mobile: sendToMobile)
          let chatDbRef = self.db.collection("Chat")
        
          let mobile = getFormatedNumber(mobile: getMobile())
         
         let msgType = messageType.rawValue
        
           
        
        let data = ["senderName" : mobile,"sender": mobile,"messageType":msgType,"dateSent":time,"chatId":chatID,"text" : text,"filePath":filePath] as [String : Any]
          
          let messagesCollection = chatDbRef.document(chatID).collection("Messages")
          let d = messagesCollection.addDocument(data: data)
          
        
          let ref2 = lastMessages.document(sendToMobile).collection("chats").document(chatID)
          let ref3 = lastMessages.document(mobile).collection("chats").document(chatID)

      
          let data3 = [
              "lastMessageDate": time,
              "lastMessageID": d.documentID,
              "lastMessageText": text,
              "lastMessageType": msgType,
              "messageCount": 0,
              "sender" : mobile,
              "sendTo" : sendToMobile,
              "filePath" : filePath
              
          ] as [String: Any]

          ref3.setData(data3) // set data under self message
                       
                       
              // Retrieve the current message count from the user's chat document
              ref2.getDocument { (document, error) in
                  if let document = document, document.exists {
                      var messageCount = document.data()?["messageCount"] as? Int ?? 0
                      messageCount += 1

                      let data2 = [
                          "lastMessageDate": time,
                          "lastMessageID": d.documentID,
                          "lastMessageText": text,
                          "lastMessageType": msgType,
                          "messageCount": messageCount,
                          "sender" : mobile,
                          "sendTo" : sendToMobile,
                          "filePath" : filePath
                      ] as [String: Any]

                      ref2.setData(data2)
                  }else {
                      
                      let data2 = [
                          "lastMessageDate": time,
                          "lastMessageID": d.documentID,
                          "lastMessageText": text,
                          "lastMessageType": msgType,
                          "messageCount": 1,
                          "sender" : mobile,
                          "sendTo" : sendToMobile,
                          "filePath" : filePath
                      ] as [String: Any]

                      ref2.setData(data2)
                      
                  }
           }
          
      }
    
      func getLatestMessages(chatID: String, completionHandler: @escaping ([QueryDocumentSnapshot]?, Error?) -> Void) {
          let chatDbRef = self.db.collection("Chat")
          let messagesCollection = chatDbRef.document(chatID).collection("Messages")
          
          // Query the last 1000 messages
          let query = messagesCollection.order(by: "dateSent", descending: true).limit(to: 1000)
          
          // Add a snapshot listener to the query
          query.addSnapshotListener { (querySnapshot, error) in
              if let error = error {
                  print("Error fetching documents: \(error)")
                  completionHandler(nil, error)
                  return
          }
              // Handle the snapshot data
              let documents = querySnapshot?.documents
              completionHandler(documents, nil)
          }
      }
    
}

extension FireStoreManager {
    
 
    
    func getLastMessagesAndMessageCount(completion: @escaping (Error?, [LastChatModel]?)->()) {
        
        lastMessageListner?.remove()
        
            let userId = getFormatedNumber(mobile: UserDefaultsManager.shared.getMobile()!)
            
            lastMessageListner = lastMessages.document(userId).collection("chats").addSnapshotListener { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        completion(err, nil)
                    } else {
                        var list: [LastChatModel] = []
                        for document in querySnapshot!.documents {
                            do {
                                var data = try document.data(as: LastChatModel.self)
                                data.documentId = document.documentID
                                list.append(data)
                            }catch let error {
                                print(error)
                            }
                        }
                        completion(nil, list)
                    }
              }
            
        
   
    }
    
    func getLiveAppVersion(completion: @escaping (String)->()) {
        
        buildVersion?.document("version").getDocument { (document, error) in
            if let document = document, document.exists {
                let version = document.data()?["version"] as? String ?? "0"
                completion(version)
                
            }
        }
    }
    
    
}


extension FireStoreManager {
    
    
    func checkLastMessages() {
        
        self.getLastMessagesAndMessageCount{ error, lastChatModel in
            self.lastMessagesData = lastChatModel ?? []
            chatListVC?.lastMessages = lastChatModel ?? []
           
            if let msg = lastChatModel?.first?.lastMessageText {
              
                if(lastChatModel?.first?.messageCount.description == "0") {
                    return
                }
                showBanner = true
                
                if(!onChatScreen) {
                    if(showBanner == true  && lastChatModel?.first?.messageCount ?? 0 > 0) {
                        
                        let type = lastChatModel?.first?.lastMessageType ?? .TEXT
                        
                        if( type == .TEXT) {
                            
                            showInAppNotification(messageFrom:lastChatModel?.first?.sender ?? "1",  documentId: lastChatModel?.first?.documentId ?? "1", dataType: "text", title: msg, body: msg)
                        }else {
                            showInAppNotification(messageFrom:lastChatModel?.first?.sender ?? "1",  documentId: lastChatModel?.first?.documentId ?? "1", dataType: "text", title: "New \(type) Received", body: "New \(type) Received")
                        }
                        playSound(soundName: "tweet", ext: ".mp3")
                    }
                }
              //  showBanner = true
            }
          
        }
    }
}

    private func deleteTemporaryFile(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            print("Temporary file deleted successfully.")
        } catch {
            print("Error deleting temporary file: \(error.localizedDescription)")
        }
    }
 


func getFormatedNumber(mobile:String)->String {
    
    return formatPhoneNumber(mobile)
 
}


func formatPhoneNumber(_ phoneNumber: String) -> String {
   var formattedNumber = phoneNumber
   
   // Remove "+91" or "91"
   formattedNumber = formattedNumber.replacingOccurrences(of: "+91", with: "")
//   formattedNumber = formattedNumber.replacingOccurrences(of: "91", with: "")
   formattedNumber = formattedNumber.replacingOccurrences(of: " ", with: "")
   
   // Remove spaces and special characters using a regular expression
   formattedNumber = formattedNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
   
   return formattedNumber
}


var storageimageToken = "?alt=media&token=93617b60-5d54-4fe4-9791-05600afbeb48"
 

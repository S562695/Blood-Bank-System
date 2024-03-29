
struct User : Codable {
    var address: String?
    var bloodGroup: String?
    var email: String?
    var mobile: String?
    var name: String?
    var password: String?
    var userType: String?
    var documentId:String?
}





struct BloodRequestData: Codable {
    let createdAt: Double
    let requestTimeStamp: Double?
    let requestTimeString: String
    let requestByName: String
    let requestByMobile: String?
    let requestByEmail: String?
    let requestByAddress: String?
    let status: String?
    let requestToMobile: String
    let requestToName: String
    let requestToEmail: String
    let requestForBloodGroup: String
    let requestToAddress :String?
    var documentId:String?
    var senderDocumentID:String?
    var receiverDocumentID:String?
    var adminDocumentID:String?
}

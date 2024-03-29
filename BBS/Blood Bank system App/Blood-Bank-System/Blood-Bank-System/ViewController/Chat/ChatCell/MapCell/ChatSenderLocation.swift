import UIKit
import MapKit
 
class ChatSenderLocation: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var viewButton: UIButton!
  
    func setData(message: MessageModel) {

        let latLongArray = message.text.components(separatedBy: ",")

        // Extract latitude and longitude from the array
        if latLongArray.count == 2,
            let latitude = Double(latLongArray[0]),
            let longitude = Double(latLongArray[1]) {

            print("Latitude: \(latitude), Longitude: \(longitude)")

            // Create a CLLocationCoordinate2D object
            let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            // Set the region of the MKMapView
            let region = MKCoordinateRegion(center: locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)

            // Optionally, add a pin at the location
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            mapView.addAnnotation(annotation)
        } else {
            print("Invalid latitude and longitude format")
        }
        
        viewButton.onTap {
            
            if latLongArray.count == 2 {
                openMap(userLat: latLongArray[0], userLong: latLongArray[1])
            }
            
        }
        

        self.timeStamp.text = message.dateSent.getFirebaseDateTime()
    }
}

func openMap(userLat: String, userLong: String) {
    if canOpenGoogleMaps() {
        openGoogleMaps(userLat, userLong)
    } else {
        openAppleMaps(userLat, userLong)
    }
}

func canOpenGoogleMaps() -> Bool {
    return UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
}

func openGoogleMaps(_ userLat: String, _ userLong: String) {
    
    if let url = URL(string:  "comgooglemaps://?saddr=&daddr=\(userLat),\(userLong)&directionsmode=driving") {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

func openAppleMaps(_ userLat: String, _ userLong: String) {

    if let url = URL(string: "http://maps.apple.com/maps?saddr=&daddr=\(userLat),\(userLong)") {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

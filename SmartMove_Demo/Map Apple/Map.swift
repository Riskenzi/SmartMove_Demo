//
//  Map.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 25.09.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//
import Foundation
import UIKit
import MapKit
import MapKitGoogleStyler
class Map: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate  {
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
       //  configureTileOverlay()
        mapView.backgroundColor = UIColor.red
        mapView.tintColor = UIColor.red
         loadJsonFile()
        if CLLocationManager.locationServicesEnabled() == true {
                   if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                       locationManager.requestWhenInUseAuthorization()}
        locationManager.desiredAccuracy = 1.0
        locationManager.delegate = self
        locationManager.startUpdatingLocation()}
        else {print("PLease turn on location services or GPS")}
               // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
    }
    
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
            
            if let location = locations.last {
                let span = MKCoordinateSpan(latitudeDelta: 0.00775, longitudeDelta: 0.00775)
                let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
                let region = MKCoordinateRegion(center: myLocation, span: span)
                mapView.setRegion(region, animated: true)
            }
            self.mapView.showsUserLocation = true
            locationManager.stopUpdatingLocation()
        }
        
    //    @IBAction func refLocation(_ sender: Any) {
    //        locationManager.startUpdatingLocation()
    //    }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Unable to access your current location")
        }
    
    
    private func configureTileOverlay() {
              // We first need to have the path of the overlay configuration JSON
              guard let overlayFileURLString = Bundle.main.path(forResource: "mapstyle", ofType: "json") else {
                      return
              }
              let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
              
              // After that, you can create the tile overlay using MapKitGoogleStyler
              guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
                  return
              }
              
              // And finally add it to your MKMapView
              mapView.addOverlay(tileOverlay)
         
    }
    
    func loadJsonFile(){
       DataManager.sharedCenter.DataPoints.removeAllObjects()
       let resultDictionary = NSMutableDictionary()
       if let url = Bundle.main.url(forResource: "point", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)

                let jsonDecoder = JSONDecoder()
                let jsonData = try jsonDecoder.decode(MapPin.self, from: data)
               // return jsonData
                for pins in jsonData{
                   
                    let resultat : PinLocations = PinLocations()
                    resultat.carID = pins.CarID
                    resultat.coordinateLatitude = pins.coordinate_latitude
                    resultat.coordinateLongitude = pins.coordinate_longitude
                    resultat.favouriteArtist = pins.favouriteArtist
                    resultat.name = pins.name
                    resultDictionary.setValue(resultat, forKey: resultat.carID!)
                    
                }
                DataManager.sharedCenter.DataPoints = resultDictionary
                //showPins()
                print("json oks")
            } catch {
                print("error:\(error)")
            }
        }
    }//loading map poin fron jsonfile
    
    
    func showPins(){
        for point in DataManager.sharedCenter.DataPoints{
            let id = point.key
            let artwork = CarItem(title: ((DataManager.sharedCenter.DataPoints.object(forKey: id) as! PinLocations).name!),locationName: "",discipline: "Sculpture",
                                  coordinate: CLLocationCoordinate2D(latitude: ((DataManager.sharedCenter.DataPoints.object(forKey: id) as! PinLocations).coordinateLatitude!), longitude: ((DataManager.sharedCenter.DataPoints.object(forKey: id) as! PinLocations).coordinateLongitude!)),carID: ((DataManager.sharedCenter.DataPoints.object(forKey: id) as! PinLocations).carID!))
                           mapView.addAnnotation(artwork)}
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        renderer.lineDashPhase = 2
        renderer.lineDashPattern = [NSNumber(value: 1),NSNumber(value:5)]
        
        return renderer
        
//        
//         if let tileOverlay = overlay as? MKTileOverlay {
//             return MKTileOverlayRenderer(tileOverlay: tileOverlay)
//            
//         } else {
//            let render = MKPolylineRenderer(overlay: overlay)
//            render.strokeColor = UIColor.blue
//            render.lineWidth = 10
//            return render
//            // return MKOverlayRenderer(overlay: overlay)
//         }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CarItem{
            
            self.mapView.removeOverlays(self.mapView.overlays)
            print("User tapped on annotation with id: \(annotation.carID)")
            //0
            let sourceCoordinate = locationManager.location?.coordinate
            let destCoordinate = annotation.coordinate
            let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate!)
            let destPlacenark = MKPlacemark(coordinate: destCoordinate)
            //1
            let sourceItem = MKMapItem(placemark: sourcePlacemark)
            let destItem = MKMapItem(placemark: destPlacenark)
            //2
            let directionRequest = MKDirections.Request()
            directionRequest.source = sourceItem
            directionRequest.destination = destItem
            directionRequest.transportType = .walking
            //3
            let directions = MKDirections(request: directionRequest)
            directions.calculate(completionHandler: {
                response,error in
                guard let response = response else{
                    if let error = error{
                        print("Wrong")
                    }
                    return
                }
                
                let route = response.routes[0]
               
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                //let rekt = route.polyline.boundingMapRect
              //  self.mapView.setRegion(MKCoordinateRegion(rekt), animated: true)
            })
            
            
            
            
            }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
              return nil
          }

          // Better to make this class property
          let annotationIdentifier = "AnnotationIdentifier"

          var annotationView: MKAnnotationView?
          if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
              annotationView = dequeuedAnnotationView
              annotationView?.annotation = annotation
          }
          else {
              let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
              av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
              annotationView = av
          }
          if let annotationView = annotationView {
              // Configure your annotation view here
              annotationView.canShowCallout = true
              annotationView.image = UIImage(named: "rapper")
              annotationView.frame.size = CGSize(width: 35, height: 35)
          }

          return annotationView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

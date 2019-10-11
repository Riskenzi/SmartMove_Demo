//
//  Extension_GoogleMaps.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 09.10.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import UIKit
import GoogleMaps
import FittedSheets
extension GoogleMap {
    
    //MARK:  Set the map style by passing the URL of the local file.
    func congigStyleMap(){
       do {
           
           if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
               mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)} else {
               NSLog("Unable to find style.json")}}
           catch {NSLog("One or more of the map styles failed to load. \(error)")}
       }
    
    // MARK: configeXib file CarLiveView
    func configeXib(){
        let allViewsInXibArray = Bundle.main.loadNibNamed("RounterView", owner: self, options: nil)
        
        let myView = allViewsInXibArray?.first as! RounterView
        
        myView.frame = self.CarLiveViewRouting.bounds
        self.CarLiveViewRouting.addSubview(myView)
        
        myView.AddressLabel.text = DataManager.sharedCenter.CarLiveAdress
        CarLiveViewRouting.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
        CarLiveViewRouting.alpha = 0
       
        UIView.animate(withDuration: 0.4)
        {
            self.CarLiveViewRouting.alpha = 1
            self.CarLiveViewRouting.transform = CGAffineTransform.identity
        }
        CarLiveViewRouting.isHidden = false
    }
    
    
    //MARK: create marker image
    
    func drawImageWithProfilePic(pp: UIImage, image: UIImage) -> UIImage {
            
           let imgView = UIImageView(image: image)
           imgView.frame = CGRect(x: 0, y: 0, width: 65, height: 65)

           let picImgView = UIImageView(image: pp)
           picImgView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)

           imgView.addSubview(picImgView)
           picImgView.center.x = imgView.center.x
           picImgView.center.y = imgView.center.y - 7
           picImgView.layer.cornerRadius = picImgView.frame.width/2
           picImgView.clipsToBounds = true
           imgView.setNeedsLayout()
           picImgView.setNeedsLayout()

           let newImage = imageWithView(view: imgView)
           return newImage
       }

    //MARK: create marker image
       func imageWithView(view: UIView) -> UIImage {
           var image: UIImage?
           UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
           if let context = UIGraphicsGetCurrentContext() {
               view.layer.render(in: context)
               image = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
           }
           return image ?? UIImage()
       }
    
    // MARK: cheak addres with coordiate
    func latLong(lat: Double,long: Double)  {

          let geoCoder = CLGeocoder()
          let location = CLLocation(latitude: lat , longitude: long)
          geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

              print("Response GeoLocation : \(placemarks)")
              var placeMark: CLPlacemark!
              placeMark = placemarks?[0]

              // Country
              if let country = placeMark.addressDictionary!["Country"] as? String {
                  print("Country :- \(country)")
                  // City
                  if let city = placeMark.addressDictionary!["City"] as? String {
                      print("City :- \(city)")
                      // State
                      if let state = placeMark.addressDictionary!["State"] as? String{
                          print("State :- \(state)")
                          // Street
                          if let street = placeMark.addressDictionary!["Street"] as? String{
                              print("Street :- \(street)")
                              DataManager.sharedCenter.CarLiveAdress = street
                              let str = street
                              let streetNumber = str.components(
                                  separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
                              print("streetNumber :- \(streetNumber)" as Any)
                              
                              // ZIP
                              if let zip = placeMark.addressDictionary!["ZIP"] as? String{
                                  print("ZIP :- \(zip)")
                                  // Location name
                                  if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                                      print("Location Name :- \(locationName)")
                                      // Street address
                                      if let thoroughfare = placeMark?.addressDictionary!["Thoroughfare"] as? NSString {
                                      print("Thoroughfare :- \(thoroughfare)")

                                      }
                                  }
                              }
                          }
                      }
                  }
              }
          })
      }
        //MARK: draw polilyne
    func drawPolilyne(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D, mode : String , state : String){
        
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)

                let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(src.latitude),\(src.longitude)&destination=\(dst.latitude),\(dst.longitude)&sensor=false&mode=\(mode)&key=AIzaSyDNaomwPpfEWP5YIwuK74m8-DNog7v5gho")!

                let task = session.dataTask(with: url, completionHandler: {
                    (data, response, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        do {
                            if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                            
                                let preRoutes = json["routes"] as! NSArray
                                
                                let routes = preRoutes[0] as! NSDictionary
                                let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                                
                                let polyString = routeOverviewPolyline.object(forKey: "points") as! String
                                let timeRoures : NSArray = routes.value(forKey: "legs") as! NSArray
                                let timeRoutes = timeRoures[0] as! NSDictionary
                                let distanceRoute : NSDictionary = timeRoutes.value(forKey: "distance") as! NSDictionary
                                let durationRoute : NSDictionary = timeRoutes.value(forKey: "duration") as! NSDictionary
                                
                                let distanceRoutes = distanceRoute.object(forKey: "text") as! String?
                                let durationRoutes = durationRoute.object(forKey: "text") as! String?
                               
                                DispatchQueue.main.async(execute: {
                                self.timeRound = distanceRoutes!
                                self.distRoud = durationRoutes!
                                self.showPath(polyStr: polyString)
                                    
                                switch state {
                                    case "Draw" :
                                        //MARK: part2 data
                                       if self.CarNumberStr != "" {
                                           //MARK: called showPopView
                                       self.ShowPopView(CarName: self.CarNameStr, CarNumber: self.CarNumberStr, CarDist: self.timeRound, CarTime: self.distRoud)
                                       }

                                    case "ButtonDraw" :
                                        //MARK: part2 data
                                       self.time.text = durationRoutes!
                                       self.distantion.text = distanceRoutes!
                                       self.CarLiveTime.text = durationRoutes!
                                    default:
                                        print("default")
                                    }
                                })
                            }
                        } catch {
                            print("parsing error")
                        }
                    }
                })
                task.resume()
            }//MARK: draw api
            
        //MARK: Draw polyline

        func showPath(polyStr :String) {
            
            guard let path = GMSMutablePath(fromEncodedPath: polyStr) else {return}
            //MARK: remove the old polyline from the GoogleMap
            self.removePolylinePath()

            let intervalDistanceIncrement: CGFloat = 10
            let circleRadiusScale = 1 / mapView.projection.points(forMeters: 1, at: mapView.camera.target)
            var previousCircle: GMSCircle?
            for coordinateIndex in 0 ..< path.count() - 1 {
                let startCoordinate = path.coordinate(at: coordinateIndex)
                let endCoordinate = path.coordinate(at: coordinateIndex + 1)
                let startLocation = CLLocation(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude)
                let endLocation = CLLocation(latitude: endCoordinate.latitude, longitude: endCoordinate.longitude)
                let pathDistance = endLocation.distance(from: startLocation)
                let intervalLatIncrement = (endLocation.coordinate.latitude - startLocation.coordinate.latitude) / pathDistance
                let intervalLngIncrement = (endLocation.coordinate.longitude - startLocation.coordinate.longitude) / pathDistance
                for intervalDistance in 0 ..< Int(pathDistance) {
                    let intervalLat = startLocation.coordinate.latitude + (intervalLatIncrement * Double(intervalDistance))
                    let intervalLng = startLocation.coordinate.longitude + (intervalLngIncrement * Double(intervalDistance))
                    let circleCoordinate = CLLocationCoordinate2D(latitude: intervalLat, longitude: intervalLng)
                    if let previousCircle = previousCircle {
                        let circleLocation = CLLocation(latitude: circleCoordinate.latitude,
                                                        longitude: circleCoordinate.longitude)
                        let previousCircleLocation = CLLocation(latitude: previousCircle.position.latitude,
                                                                longitude: previousCircle.position.longitude)
                        if mapView.projection.points(forMeters: circleLocation.distance(from: previousCircleLocation),
                                                     at: mapView.camera.target) < intervalDistanceIncrement {
                            continue
                        }
                    }
                    let circleRadius = 3 * CLLocationDistance(circleRadiusScale)
                    let circle = GMSCircle(position: circleCoordinate, radius: circleRadius)
                    circle.strokeWidth = 1.0
                    circle.strokeColor =  hexStringToUIColor(hex: "4285f4")
                    circle.fillColor = hexStringToUIColor(hex: "4285f4")
                    circle.map = mapView
                    circle.userData = "root"
                    polylineArray.append(circle)
                    previousCircle = circle
                }
            }
        } //path creator
    
    //MARK: - Removing dotted polyline
        func removePolylinePath() {
        for root: GMSCircle in self.polylineArray {
            if let userData = root.userData as? String,
                userData == "root" {
                root.map = nil
            }
        }
    }
    
    
    func callConfige(){
        let controller = SheetViewController(controller: UIStoryboard(name: "SliderUpView", bundle: nil).instantiateViewController(withIdentifier: "sheet1"))
               controller.blurBottomSafeArea = false
               self.present(controller, animated: false, completion: nil)
    }
    
    
    func configeSliderUpView( controller: @escaping () -> UIViewController ){
  
        let controller = controller()
        let text = "250,650"
        let stringSizes = text.components(separatedBy: ",")
        var sizes: [SheetSize] = stringSizes.compactMap({
            Int($0.trimmingCharacters(in: .whitespacesAndNewlines))
        }).map({
            SheetSize.fixed(CGFloat($0))
        })
        sizes.append(.fullScreen)
        let sheetController = SheetViewController(controller: controller, sizes: sizes)
        sheetController.blurBottomSafeArea = true
        sheetController.dismissOnBackgroundTap = true
        sheetController.extendBackgroundBehindHandle = true
        sheetController.topCornersRadius = true ? 50 : 0
        
        sheetController.willDismiss = { _ in
            print("Will dismiss ")
        }
        sheetController.didDismiss = { _ in
            print("Will dismiss")
        }
        self.present(sheetController, animated: false, completion: nil)
        
    }
}

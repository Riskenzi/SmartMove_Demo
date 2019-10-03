//
//  GoogleMap.swift
//  SmartMove_Demo
//
//  Created by Валерий Мельников on 26.09.2019.
//  Copyright © 2019 Valerii Melnykov. All rights reserved.
//

import UIKit
import GoogleMaps
class GoogleMap: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    @IBOutlet weak var ViewCars: UIView!
    ///view info
    @IBOutlet weak var time: UILabel!
    
    
    @IBOutlet weak var distantion: UILabel!
    
    
    @IBOutlet weak var CarName: UILabel!
    
    
    @IBOutlet weak var CarNumber: UILabel!
    
    @IBOutlet weak var ButtonCarDetail: UIButton! { didSet {
        ButtonCarDetail.layer.masksToBounds = false
        ButtonCarDetail.layer.cornerRadius = ButtonCarDetail.frame.width / 2
        ButtonCarDetail.layer.borderColor = UIColor.white.cgColor
        ButtonCarDetail.layer.borderWidth = 4
        }
    }
    
    @IBOutlet weak var ButtonDriving: UIButton!{ didSet {
    ButtonDriving.layer.masksToBounds = false
    ButtonDriving.layer.cornerRadius = ButtonCarDetail.frame.width / 3
        }
    }
    
    @IBOutlet weak var ButtonWalking: UIButton!{ didSet {
    ButtonWalking.layer.masksToBounds = false
    ButtonWalking.layer.cornerRadius = ButtonCarDetail.frame.width / 3
        }
    }
    
    //////
    @IBOutlet weak var mapView: GMSMapView!
    
//CarInfo
    
    var CarNameStr : String = ""
    var CarNumberStr : String = ""
    var timeRound : String = ""
    var distRoud : String = ""
    var CarPosition : CLLocationCoordinate2D?
// MARK: CarLiveView
    @IBOutlet weak var CarLiveView: UIView!
    
    @IBOutlet weak var navItemTitle: UINavigationItem!
    
    @IBOutlet weak var CarLiveName: UILabel!
    
    @IBOutlet weak var CarLiveNumber: UILabel!
    
    @IBOutlet weak var CarLiveColor: UILabel!
    
    @IBOutlet weak var CarLiveImage: UIImageView!
    
    @IBOutlet weak var CarLiveDriving: UIButton!{ didSet {
    CarLiveDriving.layer.masksToBounds = false
    CarLiveDriving.layer.cornerRadius = CarLiveDriving.frame.width / 3
        }
    }
    
    @IBOutlet weak var CarLiveWalking: UIButton!{ didSet {
    CarLiveWalking.layer.masksToBounds = false
    CarLiveWalking.layer.cornerRadius = CarLiveWalking.frame.width / 3
        }
    }
    
    @IBOutlet weak var CarLiveTime: UILabel!
    
    
    @IBOutlet weak var StatusBarMaskView: UIView!
    
    
//
    
    var locationManager = CLLocationManager()
    let MapApple : Map = Map()
    let marker_img = UIImage(named: "car")
    let car_img = UIImage(named: "marker")
    private var polylineArray:[GMSCircle] = [GMSCircle]() //global variable
    override func viewDidLoad() {
        super.viewDidLoad()
        MapApple.loadJsonFile()
        loadingPoint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         congigStyleMap()
        if CLLocationManager.locationServicesEnabled() == true {
                   if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                       locationManager.requestWhenInUseAuthorization()}
        locationManager.desiredAccuracy = 1.0
        locationManager.delegate = self
        locationManager.startUpdatingLocation()}
        else {print("PLease turn on location services or GPS")}
        mapView.isMyLocationEnabled = true
        self.mapView.delegate = self
        self.mapView.addSubview(ViewCars)
        self.mapView.addSubview(ButtonCarDetail)
        self.mapView.addSubview(CarLiveView)
        self.mapView.addSubview(StatusBarMaskView)
        ViewCars.isHidden = true
        //MARK: ViewCars hide
        ButtonCarDetail.isHidden = true
        
        CarLiveView.isHidden = true
        
        StatusBarMaskView.isHidden = true
        //MARK: buttoncardetail hide
    }
    
    func congigStyleMap(){
    do {
        //MARK:  Set the map style by passing the URL of the local file.
        if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)} else {
            NSLog("Unable to find style.json")}}
        catch {NSLog("One or more of the map styles failed to load. \(error)")}
    }
    
    func loadingPoint(){
      //MARK: loading point
        if let poins : NSMutableDictionary = DataManager.sharedCenter.DataPoints{
         for marker in DataManager.sharedCenter.DataPoints{
            let id =  marker.key
            let latitude = ((DataManager.sharedCenter.DataPoints.object(forKey: id) as! PinLocations).coordinateLatitude!)
            let longtitude = ((DataManager.sharedCenter.DataPoints.object(forKey: id) as! PinLocations).coordinateLongitude!)
            let posotion = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
             ///
//            var markerInfo = Dictionary<String, Any>()
//            markerInfo["CarID"] = id
            let marker = GMSMarker(position: posotion)
            marker.userData = id
            marker.icon = drawImageWithProfilePic(pp: marker_img!, image: car_img!)
            marker.appearAnimation = GMSMarkerAnimation.pop
            marker.map = mapView
        
                }
            }
       }
    
  //MARK: put this code in your viewController class
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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //MARK: Did tap
        //MARK:  remove  currently selected marker
        if let selectedMarker = mapView.selectedMarker{
            selectedMarker.icon = drawImageWithProfilePic(pp: marker_img!, image: car_img!)
            
            UIView.animate(withDuration: 0.3, animations: {
                      self.ViewCars.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                      self.ViewCars.alpha = 0
                      self.ButtonCarDetail.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                      self.ButtonCarDetail.alpha = 0
                      
                      
                  }){
                      (success: Bool) in
                    self.ViewCars.isHidden = true
                    self.ButtonCarDetail.isHidden = true
                  }
        }
        //MARK:  select new marker and make navigation and selected border
        mapView.selectedMarker = marker
        print("user tabed car from id :",marker.userData as! String)
        let id = marker.userData as! String
        let userPosition = locationManager.location?.coordinate
        let poinPosition = marker.position
        
        let marker_img_old = marker.icon
        let image_stoked =  marker_img_old?.stroked(with: .blue, size: 3)
        let marker_img_new = image_stoked?.rotate(radians: .pi)
        marker.icon = marker_img_new
        if userPosition != nil{
            
            draw(src: userPosition!, dst: poinPosition)
            //MARK: par1 data
            self.CarNameStr = ((DataManager.sharedCenter.DataPoints.object(forKey: id) as! PinLocations).name!)
            self.CarNumberStr = ((DataManager.sharedCenter.DataPoints.object(forKey: id) as! PinLocations).favouriteArtist!)
            self.CarPosition = marker.position
        }
        
        return true
    }
    
    func ShowPopView(CarName : String,CarNumber : String, CarDist : String, CarTime : String){
//MARK: Show popapView
        if CarName.count != 0 {
            self.CarName.text = CarName
            self.CarNumber.text = CarNumber
            self.time.text = CarTime
            self.distantion.text = CarDist
            ViewCars.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
            ViewCars.alpha = 0
            ButtonCarDetail.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
            ButtonCarDetail.alpha = 0
            UIView.animate(withDuration: 0.4)
            {
                self.ViewCars.alpha = 1
                self.ViewCars.transform = CGAffineTransform.identity
                self.ButtonCarDetail.alpha = 1
                self.ButtonCarDetail.transform = CGAffineTransform.identity
            }
            ViewCars.isHidden = false
            ButtonCarDetail.isHidden = false
        }
    }
//MARK: location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
              
              if let location = locations.last {
                mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 14.0)
                locationManager.stopUpdatingLocation() //need fix
              }
    }
          
      //    @IBAction func refLocation(_ sender: Any) {
      //        locationManager.startUpdatingLocation()
      //    }
          
          func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
              print("Unable to access your current location")
          }//MARK: current location user
  
    func draw(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D){
//MARK: draw polilyne
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(src.latitude),\(src.longitude)&destination=\(dst.latitude),\(dst.longitude)&sensor=false&mode=walking&key=AIzaSyDNaomwPpfEWP5YIwuK74m8-DNog7v5gho")!

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
                            //
                            self.showPath(polyStr: polyString)
                            //MARK: part2 data
                            
                            if self.CarNumberStr != "" {
                                //MARK: called showPopView
                            self.ShowPopView(CarName: self.CarNameStr, CarNumber: self.CarNumberStr, CarDist: self.timeRound, CarTime: self.distRoud)
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
    
    
    func drawButton(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D, mode : String){
    //MARK: draw polilyne
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
                                //
                                self.showPath(polyStr: polyString)
                                //MARK: part2 data
                                
                                self.time.text = durationRoutes!
                                self.distantion.text = distanceRoutes!
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
                circle.strokeColor = UIColor.blue
                circle.fillColor = UIColor.blue
                circle.map = mapView
                circle.userData = "root"
                polylineArray.append(circle)
                previousCircle = circle
             //

            }
        }
    } //path creator
  

    @IBAction func ClickDriving(_ sender: Any) {
        print("driving")
        //MARK: driving
        ButtonDriving.setImage(UIImage(named: "car_white"), for: .normal)
        ButtonWalking.setImage(UIImage(named: "walking_black"), for: .normal)
        ButtonDriving.backgroundColor = hexStringToUIColor(hex: "343C44")
        ButtonWalking.backgroundColor = hexStringToUIColor(hex: "ebeced")
        let location = locationManager.location?.coordinate
        if CarPosition != nil{
            drawButton(src: location!, dst: CarPosition!, mode: "driving")
               }
        
    }
    
    @IBAction func ClickWalking(_ sender: Any) {
        print("walking")
        ButtonDriving.setImage(UIImage(named: "drivingButton"), for: .normal)
        ButtonWalking.setImage(UIImage(named: "ButtonWalking"), for: .normal)
        ButtonDriving.backgroundColor = hexStringToUIColor(hex: "ebeced")
        ButtonWalking.backgroundColor = hexStringToUIColor(hex: "343C44")
        let location = locationManager.location?.coordinate
        if CarPosition != nil{
            drawButton(src: location!, dst: CarPosition!, mode: "walking")
        }
       
        //MARK: walking
    }
    
    @IBAction func ClickCarSelected(_ sender: Any) {
        print("ClickCarSelected")
        UIView.animate(withDuration: 0.3, animations: {
                            self.ViewCars.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                            self.ViewCars.alpha = 0
                            self.ButtonCarDetail.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                            self.ButtonCarDetail.alpha = 0
                            
                            
                        }){
                            (success: Bool) in
                          self.ViewCars.isHidden = true
                          self.ButtonCarDetail.isHidden = true
                        }
       if self.CarNumberStr != "" {
            //MARK: called showPopView
                          self.ShowLiveCar(CarName: self.CarNameStr, CarNumber: self.CarNumberStr,CarTime: self.timeRound)
        }
        //MARK: car liveView info detail
    }
    
    func ShowLiveCar(CarName : String,CarNumber : String, CarTime : String){
    //MARK: Show LiveView
            if CarName.count != 0 {
                self.CarLiveName.text = CarName
                self.CarLiveNumber.text = CarNumber
                self.time.text = CarTime
                CarLiveView.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                CarLiveView.alpha = 0
                StatusBarMaskView.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                StatusBarMaskView.alpha = 0
                self.navItemTitle.title = "You car is waiting for you"
                UIView.animate(withDuration: 0.4)
                {
                    self.CarLiveView.alpha = 1
                    self.CarLiveView.transform = CGAffineTransform.identity
                    self.StatusBarMaskView.alpha = 1
                    self.StatusBarMaskView.transform = CGAffineTransform.identity
                  
                }
                CarLiveView.isHidden = false
                StatusBarMaskView.isHidden = false
            }
        }
    
    @IBAction func CarViewTabClose(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
                           self.CarLiveView.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                           self.CarLiveView.alpha = 0
                           self.StatusBarMaskView.transform = CGAffineTransform.init(scaleX:1.3, y: 1.3)
                            self.StatusBarMaskView.alpha = 0
                           
                       }){
                           (success: Bool) in
                         self.CarLiveView.isHidden = true
                        self.StatusBarMaskView.isHidden = true
                       }
        
    }
    
        //MARK: - Removing dotted polyline
        func removePolylinePath() {
        for root: GMSCircle in self.polylineArray {
            if let userData = root.userData as? String,
                userData == "root" {
                root.map = nil
            }
        }
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

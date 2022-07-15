//
//  TodayViewController.swift
//  Weather
//
//  Created by Dima  on 15.07.2022.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import NVActivityIndicatorView

class TodayViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    let gradientLayer = CAGradientLayer()

    
    let apiKey = "b6103274efbe639f6a87ffb6d8902faf"
    var lat = 49.8670861
    var lon = 24.0400969
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
 //https://api.openweathermap.org/data/2.5/weather?lat=49.867001&lon=24.040297&appid=3733254d74175f06737517581d91a336&units=metric

    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGreyGradientBackground()
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponce = JSON(responseStr)
                let jsonWeather = jsonResponce["weather"].array![0]
                let jsonTemp = jsonResponce["main"]
                let jsonTempMax = jsonResponce["main"]
                let jsonTempMin = jsonResponce["main"]
                let iconName = jsonWeather["icon"].stringValue
                //let jsonTempMax = jsonResponce["main"]
                //let jsonTempMin = jsonResponce["main"]
                
                self.cityLabel.text = jsonResponce["name"].stringValue
                self.descriptionLabel.text = jsonWeather["main"].stringValue
                self.iconView.image = UIImage(named: iconName)
                self.tempLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))º"
                self.maxTempLabel.text = "\(Int(round(jsonTemp["temp_max"].doubleValue)))º"
                self.minTempLabel.text = "\(Int(round(jsonTemp["temp_min"].doubleValue)))º"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayLabel.text = dateFormatter.string(from: date)
                
                let suffix = iconName.suffix(1)
                if (suffix == "n") {
                    self.setGreyGradientBackground()
                }else{
                    self.setBlueGradientBackground()
                }
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func setBlueGradientBackground(){
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func setGreyGradientBackground(){
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }


}

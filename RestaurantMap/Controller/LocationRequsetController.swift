//
//  LocationRequsetController.swift
//  RestaurantMap
//
//  Created by Heng on 2020/3/14.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
import CoreLocation

class LocationRequestController: UIViewController{
    
    //MARK - Properties
    var locationManager: CLLocationManager?
    
    let allowLocationLabel: UILabel = {
       let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "Allow Location\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize:24)])
        
        attributedText.append(NSAttributedString(string: "Please enable location services so that we can track your movements", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize:16)]))
        
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedText
        label.textColor = .black
        
        return label
    }()
    
    let enableLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enable Location", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .mainOrange()
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleRequestLocation), for: .touchUpInside)
        
        return button
    }()
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        
        if locationManager != nil{
            print("Did set location manager..")
        }else{
            print("Error setting location manager..")
        }
    }
    
    //MARK: - Selectors
    
    @objc func handleRequestLocation(){
        guard let locationManager = self.locationManager else{ return }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: - Helper Function
    func configureViewComponents(){
        view.backgroundColor = .white
        
        view.addSubview(allowLocationLabel)
        allowLocationLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 172, paddingLeft: 12.5, paddingBottom: 0, paddingRight: 12.5, width: 0, height: 0)
        allowLocationLabel.centerX(inView: view)
        
        view.addSubview(enableLocationButton)
        enableLocationButton.anchor(top: allowLocationLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 12.5, paddingBottom: 0, paddingRight: 12.5, width: 0, height: 50)
    }
}

extension LocationRequestController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard locationManager?.location != nil else{
            print("Error setting location ..")
            return
        }
        dismiss(animated: true, completion: nil)
    }
}

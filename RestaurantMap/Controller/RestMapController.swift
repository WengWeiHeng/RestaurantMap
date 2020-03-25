//
//  RestMapController.swift
//  RestaurantMap
//
//  Created by Heng on 2020/3/16.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import AlamofireImage

var temp: Int = 0

private let reuseIdentifier = "RestListCell"

class RestMapController: UIViewController{
    
    //MARK: - Properties
    var restaurant: Restaurant!
    var restaurants = [Rest]()
    var searchResults = [Rest]()
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var tableView: UITableView!
    var expansionState: ExpansionState!
    var searchInputView: SearchInputView!
    
    var rect: CGRect?
    
    enum ExpansionState{
        case NotExpanded
        case PartiallyExpanded
        case FullyExpanded
    }
    
    lazy var listInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.addSubview(indicatorView)
        indicatorView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 8)
        indicatorView.centerX(inView: view)
       
        view.addSubview(listTitle)
        listTitle.anchor(top: indicatorView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        listTitle.textColor = .black
        listTitle.text = "検索結果"
       
        let dimension: CGFloat = 32
        view.addSubview(imageContainerView)
        imageContainerView.anchor(top: indicatorView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: dimension, height: dimension)
        imageContainerView.layer.cornerRadius = dimension / 2
        
        
        configureTableView()
        view.addSubview(tableView)
        tableView.anchor(top: listTitle.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
        
        return view
    }()
    
    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 5
        view.alpha = 0.8

        return view
    }()
    
    let listTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        
        return label
    }()
    
    lazy var imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(listCloseButton)
        listCloseButton.center(inView: view)
        listCloseButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        listCloseButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        return view
    }()
    
    let listCloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(listCloseAction), for: .touchUpInside)
        
        return button
        
    }()
    
    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "navigation").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(hendleCenterLocation), for: .touchUpInside)
        
        return button
    }()
    
    let searchFinishButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(searchFinishAction), for: .touchUpInside)
        button.backgroundColor = .black
        button.alpha = 0
        
        return button
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        expansionState = .NotExpanded
        configureViewComponents()
        enableLocationServices()
        getRestaurantInfo()
        configureGestureRecognizers()
        notificationKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerMapOnUserLocation(shouldLoadAnnotations: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestDetail"{
            let destinationController = segue.destination as! RestDetailController
            destinationController.restaurant = searchResults[temp]
        }
    }
    
    //MARK: - Selectors
    @objc func listCloseAction(){
        if expansionState == .FullyExpanded{
            animateInputView(targetPosition: listInputView.frame.origin.y + 650) { (_) in
                self.expansionState = .NotExpanded
            }
        }
        
        if expansionState == .PartiallyExpanded{
            animateInputView(targetPosition: listInputView.frame.origin.y + 400) { (_) in
                self.expansionState = .NotExpanded
            }
        }
    }
    
    @objc func searchFinishAction(){
        searchInputView.searchBar.endEditing(true)
        appearFinishButton()
    }
    
    @objc func hendleCenterLocation(){
        centerMapOnUserLocation(shouldLoadAnnotations: false)
    }
    
    @objc func handleSwipeGesture(sender: UISwipeGestureRecognizer){
        if sender.direction == .up{
            print("Did swipe up...")
            if expansionState == .NotExpanded{
                animateInputView(targetPosition: listInputView.frame.origin.y - 400) { (_) in
                    self.expansionState = .PartiallyExpanded
                }
            }
            
            if expansionState == .PartiallyExpanded{
                animateInputView(targetPosition: listInputView.frame.origin.y - 250) { (_) in
                    self.expansionState = .FullyExpanded
                }
            }
        } else {
            print("Did swipe down...")
            if expansionState == .FullyExpanded{
                animateInputView(targetPosition: listInputView.frame.origin.y + 250) { (_) in
                    self.expansionState = .PartiallyExpanded
                }
            }
            
            if expansionState == .PartiallyExpanded{
                animateInputView(targetPosition: listInputView.frame.origin.y + 400) { (_) in
                    self.expansionState = .NotExpanded
                }
            }
        }
    }
    
    @objc func keyboardWillShow(note: NSNotification){
        if searchInputView.searchBar == nil{
            return
        }
        
        let userInfo = note.userInfo!
        let keyboard = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let origin = (searchInputView?.frame.origin)!
        let height = (searchInputView?.frame.size.height)!
        let targetY = origin.y + height
        let visibleRectWithoutKeyboard = self.view.bounds.size.height - keyboard.height
        
        if targetY >= visibleRectWithoutKeyboard {
            var rect = self.rect!
            rect.origin.y -= (targetY - visibleRectWithoutKeyboard) + 5
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.view.frame = rect
            })
        }
    }
    
    @objc func keyboardWillHide(note: NSNotification){
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(truncating: keyboardAnimationDetail[UIResponder.keyboardAnimationDurationUserInfoKey]! as! NSNumber)
        
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.origin.y)
        })
    }
    
    //MARK: - Helper Functions
    func configureViewComponents(){
        configureMapView()
        
        view.addSubview(searchFinishButton)
        searchFinishButton.addConstraintsToFillView(view: view)
        
        searchInputView = SearchInputView()
        searchInputView.delegate = self
        view.addSubview(searchInputView)
        searchInputView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 170)
        
        view.addSubview(centerMapButton)
        centerMapButton.anchor(top: nil, left: nil, bottom: searchInputView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 16, width: 50, height: 50)
        
        view.addSubview(listInputView)
        listInputView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -650, paddingRight: 0, width: 0, height: 650)
    }
    
    func configureMapView(){
        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        view.addSubview(mapView)
        mapView.addConstraintsToFillView(view: view)
    }
    
    func configureTableView(){
        tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(RestListCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.allowsMultipleSelection = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureGestureRecognizers(){
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    //animate control
    func animateInputView(targetPosition: CGFloat, completion: @escaping(Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.listInputView.frame.origin.y = targetPosition
        }, completion: completion)
    }
    
    //get json data
    func getRestaurantInfo(){
        let urlString: String = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid= (( 自keyidに変更する )) &latitude=35.668441&longitude=139.600782&range=3&hit_per_page=100&offset_page=1"
        guard let url: URL = URL(string: urlString) else{ return }

        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            do{
                self.restaurant = try JSONDecoder().decode(Restaurant.self, from: data!)
                self.restaurants.append(contentsOf: self.restaurant.rest)
                self.searchResults.append(contentsOf: self.restaurant.rest)
                semaphore.signal()
            } catch(let message){
                print("error..")
                print(message)
                return
            }
        })
        task.resume()
        semaphore.wait()
    }
    
    //keyboard notification
    func notificationKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        rect = view.bounds
    }
}

extension RestMapController{
    
    //zoom to fit a users location and a selected restaurant location
    func zoomToFit(selectedAnnotation: MKAnnotation?){
        if mapView.annotations.count == 0{
            return
        }
        
        var topLeftCoordinate = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoordinate = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        if let selectedAnnotation = selectedAnnotation{
            for annotation in mapView.annotations{
                if let userAnno = annotation as? MKUserLocation{
                    topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, userAnno.coordinate.longitude)
                    topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, userAnno.coordinate.latitude)
                    bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, userAnno.coordinate.longitude)
                    bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, userAnno.coordinate.latitude)
                }
                
                if annotation.title == selectedAnnotation.title{
                    topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, annotation.coordinate.longitude)
                    topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, annotation.coordinate.latitude)
                    bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
                    bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
                }
            }
            
            var region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(topLeftCoordinate.latitude - (topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 0.65, topLeftCoordinate.longitude + (bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 0.65), span: MKCoordinateSpan(latitudeDelta: fabs(topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 3.0, longitudeDelta: fabs(bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 3.0))
            
            region = mapView.regionThatFits(region)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func centerMapOnUserLocation(shouldLoadAnnotations: Bool){
        guard let coordinates = locationManager.location?.coordinate else{ return }
        let coordinatesRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(coordinatesRegion, animated: true)
    }
    
    func removeAnnotations(){
        mapView.annotations.forEach { (annotation) in
            if let annotation = annotation as? MKPointAnnotation{
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    func configurePlacemark(){
        for restaurantData in 0..<searchResults.count{
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(searchResults[restaurantData].address!) { (placemarks, error) in
                if let error = error {
                  print(error)
                  return
                }
                
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    let annotation = MKPointAnnotation()
                    print(self.searchResults.count)
                    annotation.title = self.searchResults[restaurantData].name!
                    
                    if let location = placemark.location {
                        annotation.coordinate = location.coordinate
                        self.mapView.showAnnotations([annotation], animated: true)
                    }
                }
            }
        }
    }
    
    func selectedAnnoation(searchResults: Rest) {
        mapView.annotations.forEach { (annotation) in
            if annotation.title == searchResults.name{
                self.mapView.selectAnnotation(annotation, animated: true)
                self.zoomToFit(selectedAnnotation: annotation)
            }
        }
    }
}

//MARK: - searchInputView Delegate
extension RestMapController: SearchInputViewDelegate{
    func handleSearch(withSearchText searchText: String) {
        var directions: Double = 0

        for restData in 0..<searchResults.count{
            guard let user = locationManager.location else { return }
            
            if restaurants[restData].latitude!.isEmpty { continue }
            if restaurants[restData].longitude!.isEmpty { continue }
            guard let latitude = Double(restaurants[restData].latitude!) else { continue }
            guard let longitude = Double(restaurants[restData].longitude!) else { continue }
            let restCoordinate = CLLocation(latitude: latitude, longitude: longitude)
            directions = restCoordinate.distance(from: user)
        }
        
        searchResults = restaurants.filter({ (Rest) -> Bool in
            if let name: String = Rest.name, let category: String = Rest.category, let address: String = Rest.address{
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || category.localizedCaseInsensitiveContains(searchText) || address.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }

            return false
        })
        
        if directions >= searchInputView.region || searchResults.count == 0{
            let alert = UIAlertController(title: "該当なし", message: "別のキーワードまた範囲を設定してください", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            configurePlacemark()
            removeAnnotations()
            appearTableView()
        }
    }
    
    func appearFinishButton(){
        if searchFinishButton.alpha != 0.0{
            UIView.animate(withDuration: 0.4) {
                self.searchFinishButton.alpha = 0
            }
        }else{
            UIView.animate(withDuration: 0.4) {
                self.searchFinishButton.alpha = 0.5
            }
        }
    }
    
    func appearTableView(){
        animateInputView(targetPosition: listInputView.frame.origin.y - 400) { (_) in
            self.expansionState = .PartiallyExpanded
        }
    }

    func updateTableView(){
        tableView.reloadData()
    }
}

//MARK: - Table View Delegate
extension RestMapController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count != 0{
            return searchResults.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RestListCell
        cell.setRestaurantInfo(restaurant: searchResults[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let selectMapItem = searchResults[indexPath.row]
        selectedAnnoation(searchResults: selectMapItem)

        let cell = tableView.cellForRow(at: indexPath) as! RestListCell
        temp = indexPath.row
        self.performSegue(withIdentifier: "showRestDetail", sender: cell)
        
    }
}

//MARK: - CLLocationManagerDelegate
extension RestMapController: CLLocationManagerDelegate{
    func enableLocationServices(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
            print("Location auth Status is Not Determined")
            
            DispatchQueue.main.async {
                
                let controller = LocationRequestController()
                controller.locationManager = self.locationManager
                
                self.present(controller, animated: true, completion: nil)
            }
        case .restricted:
            print("Location auth Status is Restricted")
        case .denied:
            print("Location auth Status is Denied")
        case .authorizedAlways:
            print("Location auth Status is Authorized Always")
        case .authorizedWhenInUse:
            print("Location auth Status is Authorized When In Use")
        default:
            fatalError("enableLocationServices() has not been implemented")
        }
    }
}

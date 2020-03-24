//
//  SearchInputView.swift
//  RestaurantMap
//
//  Created by Heng on 2020/3/13.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "RestListCell"

protocol RestListInputViewDelegate{
    var frameWidth: CGFloat{ get }
    func getRestaurantInfo(indexOfCell: Int)
    func animateCenterMapButton(expansionState: RestListInputView.ExpansionState)
}

class RestListInputView: UIView{
    
    //MARK: - properties
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var expansionState: ExpansionState!
    var delegate: RestListInputViewDelegate!
    var restaurant: Restaurant!
    
    enum ExpansionState{
        case NotExpanded
        case FullyExpanded
    }
    
    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 5
        view.alpha = 0.8
        
        return view
    }()
    
    let listTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        
        return label
    }()
    
    lazy var imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainLightGray()
        view.addSubview(searchButton)
        searchButton.center(inView: view)
        searchButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        return view
    }()
    
    lazy var searchContainerView: UIView = {
        let view = UIView()
        
        
        return view
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        return button
        
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        expansionState = .NotExpanded
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func searchAction(){
        print("search Action..")
        UIView.animate(withDuration: 0.4, delay: 0.2, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.listTitle.alpha = 0
            self.imageContainerView.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 1.2, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.searchBar.frame.origin.x -= 404
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handleSwipeGesture(sender: UISwipeGestureRecognizer){
           
        if sender.direction == .up{
            print("Did swipe up...")
            if expansionState == .NotExpanded{
                delegate?.animateCenterMapButton(expansionState: self.expansionState)
                animateInputView(targetPosition: self.frame.origin.y - 250) { (_) in
                    self.expansionState = .FullyExpanded
                }
            }
        } else{
            print("Did swipe down...")
            if expansionState == .FullyExpanded{
                delegate?.animateCenterMapButton(expansionState: self.expansionState)
                animateInputView(targetPosition: self.frame.origin.y + 250) { (_) in
                    self.expansionState = .NotExpanded
                }
            }
        }
    }
    
    //MARK: - Helper Functions
    func configureViewComponents(){
        backgroundColor = .white
        
        addSubview(indicatorView)
        indicatorView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 8)
        indicatorView.centerX(inView: self)
        
        addSubview(listTitle)
        listTitle.anchor(top: indicatorView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        listTitle.text = "近所"
        
        let dimension: CGFloat = 32
        addSubview(imageContainerView)
        imageContainerView.anchor(top: indicatorView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: dimension, height: dimension)
        imageContainerView.layer.cornerRadius = dimension / 2
        
        configureTableView()
        configureSearchBar()
        configureGestureRecognizers()
        getRestaurantInfo()
    }
    
    func configureSearchBar(){
        searchBar = UISearchBar()
        searchBar.placeholder = "Search for a place or address"
        searchBar.delegate = self
        searchBar.barStyle = .black
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        addSubview(searchBar)
        searchBar.anchor(top: indicatorView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: -390, width: 390, height: 50)
        
    }

    func configureTableView(){
        tableView = UITableView()
        tableView.rowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RestListCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        
        addSubview(tableView)
        tableView.anchor(top: listTitle.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 100, paddingRight: 0, width: 0, height: 0)
    }
    
    func configureGestureRecognizers(){
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeUp.direction = .up
        addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    func animateInputView(targetPosition: CGFloat, completion: @escaping(Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.frame.origin.y = targetPosition
        }, completion: completion)
    }
    
    func dismissOnSearch(){
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        
        if expansionState == .FullyExpanded{
            animateInputView(targetPosition: self.frame.origin.y + 250) { (_) in
                self.delegate?.animateCenterMapButton(expansionState: self.expansionState)
                self.expansionState = .NotExpanded
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 2, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.searchBar.frame.origin.x += 404
            self.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 0.6, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.listTitle.alpha = 1
            self.imageContainerView.alpha = 1
        }, completion: nil)
    }
    
    func getRestaurantInfo(){
        let urlString: String = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=5a66e88db247132a34d94d837b79035c&latitude=35.668441&longitude=139.600782&range=3&hit_per_page=100&offset_page=1"
        guard let url: URL = URL(string: urlString) else{ return }
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            do{
                self.restaurant = try JSONDecoder().decode(Restaurant.self, from: data!)
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
}

//MARK: - TableView Delegate
extension RestListInputView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant.rest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RestListCell
        cell.setRestaurantInfo(restaurant: restaurant.rest[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(delegate != nil) {
            self.delegate.getRestaurantInfo(indexOfCell: indexPath.item)
        }
    }
}

//MARK: - SearchBar Delegate
extension RestListInputView: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if expansionState == .NotExpanded{
            delegate?.animateCenterMapButton(expansionState: self.expansionState)
            animateInputView(targetPosition: self.frame.origin.y - 250) { (_) in
                self.expansionState = .FullyExpanded
            }
        }
        
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissOnSearch()
    }
}

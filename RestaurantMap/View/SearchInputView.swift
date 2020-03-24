//
//  SearchInputView.swift
//  RestaurantMap
//
//  Created by Heng on 2020/3/17.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

protocol SearchInputViewDelegate {
    func handleSearch(withSearchText searchText: String)
    func appearFinishButton()
    func appearTableView()
    func updateTableView()
}

class SearchInputView: UIView{
    
    //MARK: - Properties
    var searchBar: UISearchBar!
    var restMapController: RestMapController!
    var delegate: SearchInputViewDelegate!
    var range: Int = 3
    var region: Double = 0.0
    
    let rangeTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .mainDarkGray()
        
        return label
    }()
    
    let rangeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 7
        slider.value = 3
        slider.minimumTrackTintColor = .mainOrange()
        slider.isContinuous = false
        slider.addTarget(self, action: #selector(sliderChangeValue), for: UIControl.Event.valueChanged)
        
        return slider
    }()
    
    let rangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .mainDarkGray()
        
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func sliderChangeValue(){
        rangeSlider.value.round()
        range = Int(rangeSlider.value)
        switch range{
        case 1:
            rangeLabel.text = "300m"
            region = 300.0
            return
        case 2:
            rangeLabel.text = "500m"
            region = 500.0
            return
        case 3:
            rangeLabel.text = "1km"
            region = 1000.0
            return
        case 4:
            rangeLabel.text = "2km"
            region = 2000.0
            return
        case 5:
            rangeLabel.text = "5km"
            region = 5000.0
            return
        case 6:
            rangeLabel.text = "10km"
            region = 10000.0
            return
        case 7:
            rangeLabel.text = "20km"
            region = 20000.0
            return
        default:
            break
        }
    }
    
    //MARK: - Helper Functions
    func configureViewComponents(){
        configureSearchBar()
        
        addSubview(rangeTitle)
        rangeTitle.anchor(top: searchBar.bottomAnchor, left: searchBar.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        rangeTitle.text = "検索範囲(半径)"
        
        addSubview(rangeSlider)
        rangeSlider.anchor(top: rangeTitle.bottomAnchor, left: rangeTitle.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(rangeLabel)
        rangeLabel.anchor(top: rangeSlider.topAnchor, left: rangeSlider.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 25, width: 0, height: 0)
        rangeLabel.text = "500m"
    }
    
    func configureSearchBar(){
        searchBar = UISearchBar()
        searchBar.placeholder = "レストランを検索する"
        searchBar.delegate = self
        searchBar.barStyle = .default
        searchBar.tintColor = .mainOrange()
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        addSubview(searchBar)
        searchBar.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
    }
}

//MARK: - SearchBar Delegate
extension SearchInputView: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text{
            delegate?.handleSearch(withSearchText: searchText)
            delegate?.updateTableView()
            delegate?.appearFinishButton()
        }
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        delegate?.appearFinishButton()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

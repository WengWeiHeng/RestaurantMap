//
//  InputViewCell.swift
//  RestaurantMap
//
//  Created by Heng on 2020/3/13.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RestListCell: UITableViewCell{
    
    //MARK: - Properties
    let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let restaurantTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        
        return label
    }()
    
    let restaurantCategory: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        
        return label
    }()
    
    let openTime: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    func configureViewComponents(){
        addSubview(restaurantImageView)
        restaurantImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 0, width: 100, height: 100)
        
        addSubview(restaurantTitle)
        restaurantTitle.anchor(top: restaurantImageView.topAnchor, left: restaurantImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
        addSubview(restaurantCategory)
        restaurantCategory.anchor(top: restaurantTitle.bottomAnchor, left: restaurantTitle.leftAnchor, bottom: nil, right: restaurantTitle.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(openTime)
        openTime.anchor(top: restaurantCategory.bottomAnchor, left: restaurantTitle.leftAnchor, bottom: nil, right: restaurantTitle.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func setRestaurantInfo(restaurant: Rest){
        restaurantTitle.text = restaurant.name
        restaurantCategory.text = restaurant.category
        
        //shop image
        if let imageURL = restaurant.imageUrl {
          Alamofire.request(imageURL.shopImage1).responseImage{ response in
            if let image = response.result.value {
              self.restaurantImageView.image = image
            }else{
              self.restaurantImageView.image = UIImage(named: "confessional")
            }
          }
        }
        
        //open time
        if restaurant.openTime != ""{
            openTime.text = restaurant.openTime
        }else{
            openTime.text = "*営業情報が更新中*"
        }
    }
}

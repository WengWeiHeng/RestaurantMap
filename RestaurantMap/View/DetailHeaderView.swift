//
//  DetailHeaderView.swift
//  RestaurantMap
//
//  Created by Heng on 2020/3/15.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class DetailHeaderView: UIView{
    
    //MARK: - properties
    let restName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = .black
        
        return label
    }()
    
    let restKanaName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = .black
        
        return label
    }()
    
    let restImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error..")
    }
    
    //MARK: - Helper Functions
    func configureViewComponents(){
        addSubview(restName)
        restName.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
        addSubview(restKanaName)
        restKanaName.anchor(top: restName.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
        addSubview(restImage)
        restImage.anchor(top: restKanaName.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)   
    }
}

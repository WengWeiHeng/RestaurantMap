//
//  DetailInfoCell.swift
//  RestaurantMap
//
//  Created by Heng on 2020/3/15.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class DetailInfoCell: UITableViewCell{
    
    //MARK: - Properties
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
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
        addSubview(iconImageView)
        iconImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        
        addSubview(infoLabel)
        infoLabel.anchor(top: topAnchor, left: iconImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
    }
}

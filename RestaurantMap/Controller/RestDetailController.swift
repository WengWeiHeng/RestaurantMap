//
//  RestaurantDetailController.swift
//  RestaurantMap
//
//  Created by Heng on 2020/3/15.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
import Alamofire

private let DetailInfoIdentifier = "DetailInfoCell"
private let DescriptionIdentifier = "DescriptionCell"

class RestDetailController: UIViewController{
    
    //MARK: - Properties
    var tableView: UITableView!
    var restaurant: Rest?
    var detailHeaderView: DetailHeaderView!
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        return button
    }()

    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureViewComponents()
    }
    
    //MARK: - Selectors
    @objc func closeAction(){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Function
    func configureViewComponents(){
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 20, height: 20)
        
        detailHeaderView = DetailHeaderView()
        view.addSubview(detailHeaderView)
        detailHeaderView.anchor(top: closeButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 28, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 350)
        detailHeaderView.restName.text = restaurant?.name
        detailHeaderView.restKanaName.text = restaurant?.nameKana
        //restaurant image
        if let imageURL: String = (restaurant?.imageUrl!.shopImage1){
            Alamofire.request(imageURL).responseImage{ response in
                if let image = response.result.value {
                    self.detailHeaderView.restImage.image = image
                }else{
                    self.detailHeaderView.restImage.image = UIImage(named: "confessional")
                }
            }
        }
        configureTableView()
    }
    
    func configureTableView(){
        tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(DetailInfoCell.self, forCellReuseIdentifier: DetailInfoIdentifier)
        tableView.register(DetailDescriptionCell.self, forCellReuseIdentifier: DescriptionIdentifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: detailHeaderView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}

extension RestDetailController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailInfoIdentifier, for: indexPath) as! DetailInfoCell
            cell.iconImageView.image = UIImage(named: "timeclockIcon")
            if restaurant?.openTime != ""{
                cell.infoLabel.text = restaurant?.openTime
            }else{
                cell.infoLabel.text = "*営業情報が更新中*"
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailInfoIdentifier, for: indexPath) as! DetailInfoCell
            cell.iconImageView.image = UIImage(named: "map")
            if restaurant?.address != ""{
                cell.infoLabel.text = restaurant?.address
            }else{
                cell.infoLabel.text = "*住所情報が更新中*"
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailInfoIdentifier, for: indexPath) as! DetailInfoCell
            cell.iconImageView.image = UIImage(named: "information")
            if restaurant?.tel != ""{
                cell.infoLabel.text = restaurant?.tel
            }else{
                cell.infoLabel.text = "*連絡情報が更新中*"
            }
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionIdentifier, for: indexPath) as! DetailDescriptionCell
            if restaurant?.pr?.prLong != ""{
                cell.descriptionLabel.text = restaurant?.pr?.prLong
            }else{
                cell.descriptionLabel.text = "*紹介情報が更新中*"
            }
            
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
}

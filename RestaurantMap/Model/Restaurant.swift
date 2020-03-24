//
//  Restaurant.swift
//  RestaurantMap
//
//  Created by Heng on 2020/3/14.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

struct Restaurant: Codable {
    var totalHitCount: Int
    var hitPerPage: Int
    var pageOffset: Int
    var rest: [Rest]
    
    enum CodingKeys: String, CodingKey{
        case totalHitCount = "total_hit_count"
        case hitPerPage = "hit_per_page"
        case pageOffset = "page_offset"
        case rest
    }
}

struct Rest: Codable {
    var id: String?
    var updateDate: String?
    var name: String?
    var nameKana: String?
    var latitude: String?
    var longitude: String?
    var category: String?
    var url: String?
    var urlMobile: String?
    var couponUrl: Coupon_url?
    var imageUrl: Image_url?
    var address: String?
    var tel: String?
    var telSub: String?
    var fax: String?
    var openTime: String?
    var holiday: String?
    var access: Access?
    var parkingLots: String?
    var pr: PR?
    var code: Code?
    var budget: Int?
    var party: Int?
    var lunch: Int?
    var creditCard: String?
    var eMoney: String?
    var flags: Flags?
    
    enum CodingKeys: String, CodingKey{
        case id
        case updateDate = "update_date"
        case name
        case nameKana = "name_kana"
        case latitude
        case longitude
        case category
        case url
        case urlMobile = "url_mobile"
        case couponUrl = "coupon_url"
        case imageUrl = "image_url"
        case address
        case tel
        case telSub = "tel_sub"
        case fax
        case openTime = "opentime"
        case holiday
        case access
        case parkingLots = "parking_lots"
        case pr
        case code
        case budget
        case party
        case lunch
        case creditCard = "credit_card"
        case eMoney = "e_money"
        case flags
    }
    
    func configureIntValues(values: KeyedDecodingContainer<CodingKeys>, forKey: CodingKeys) -> Int?{
        var intValue: Int?
        do{
            intValue = try values.decode(Int?.self, forKey: forKey)
        }catch{
            intValue = nil
        }
        return intValue
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try! values.decode(String.self, forKey: .id)
        updateDate = try! values.decode(String.self, forKey: .updateDate)
        name = try! values.decode(String.self, forKey: .name)
        nameKana = try! values.decode(String.self, forKey: .nameKana)
        latitude = try! values.decode(String.self, forKey: .latitude)
        longitude = try! values.decode(String.self, forKey: .longitude)
        category = try! values.decode(String.self, forKey: .category)
        url = try! values.decode(String.self, forKey: .url)
        urlMobile = try! values.decode(String.self, forKey: .urlMobile)
        couponUrl = try! values.decode(Coupon_url.self, forKey: .couponUrl)
        imageUrl = try! values.decode(Image_url.self, forKey: .imageUrl)
        address = try! values.decode(String.self, forKey: .address)
        tel = try! values.decode(String.self, forKey: .tel)
        telSub = try! values.decode(String.self, forKey: .telSub)
        fax = try! values.decode(String.self, forKey: .fax)
        openTime = try? values.decode(String.self, forKey: .openTime)
        holiday = try! values.decode(String.self, forKey: .holiday)
        access = try! values.decode(Access.self, forKey: .access)
        parkingLots = try! values.decode(String.self, forKey: .parkingLots)
        pr = try! values.decode(PR.self, forKey: .pr)
        code = try! values.decode(Code.self, forKey: .code)
        budget = configureIntValues(values: values, forKey: .budget)
        party = configureIntValues(values: values, forKey: .party)
        lunch = configureIntValues(values: values, forKey: .lunch)
        creditCard = try! values.decode(String.self, forKey: .creditCard)
        eMoney = try! values.decode(String.self, forKey: .eMoney)
        flags = try! values.decode(Flags.self, forKey: .flags)
    }
}

struct Coupon_url: Codable {
    var pc: String
    var mobile: String
    
    enum CodingKeys: String, CodingKey {
        case pc
        case mobile
    }
}

struct Image_url: Codable {
    var shopImage1: String
    var shopImage2: String
    var qrcode: String
    
    enum CodingKeys: String, CodingKey{
        case shopImage1 = "shop_image1"
        case shopImage2 = "shop_image2"
        case qrcode
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shopImage1 = try! values.decode(String.self ,forKey: .shopImage1)
        shopImage2 = try! values.decode(String.self ,forKey: .shopImage2)
        qrcode = try! values.decode(String.self ,forKey: .qrcode)
    }
}

struct Access: Codable {
    var line: String
    var station: String
    var stationExit: String
    var walk: String
    var note: String
    
    enum CodingKeys: String, CodingKey {
        case line
        case station
        case stationExit = "station_exit"
        case walk
        case note
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        line = try! values.decode(String.self ,forKey: .line)
        station = try! values.decode(String.self ,forKey: .station)
        stationExit = try! values.decode(String.self ,forKey: .stationExit)
        walk = try! values.decode(String.self ,forKey: .walk)
        note = try! values.decode(String.self ,forKey: .note)
    }
}

struct PR: Codable{
    var prShort: String
    var prLong: String
    
    enum CodingKeys: String, CodingKey {
        case prShort = "pr_short"
        case prLong = "pr_long"
    }
}

struct Code: Codable{
    var areacode: String
    var areaname: String
    var prefcode: String
    var prefname: String
    var areacodeS: String
    var areanameS: String
    var categoryCodeL: [String]
    var categoryNameL: [String]
    var categoryCodeS: [String]
    var categoryNameS: [String]
    
    enum CodingKeys: String, CodingKey {
        case areacode
        case areaname
        case prefcode
        case prefname
        case areacodeS = "areacode_s"
        case areanameS = "areaname_s"
        case categoryCodeL = "category_code_l"
        case categoryNameL = "category_name_l"
        case categoryCodeS = "category_code_s"
        case categoryNameS = "category_name_s"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        areacode = try! values.decode(String.self ,forKey: .areacode)
        areaname = try! values.decode(String.self ,forKey: .areaname)
        prefcode = try! values.decode(String.self ,forKey: .prefcode)
        prefname = try! values.decode(String.self ,forKey: .prefname)
        areacodeS = try! values.decode(String.self ,forKey: .areacodeS)
        areanameS = try! values.decode(String.self ,forKey: .areanameS)
        categoryCodeL = try! values.decode([String].self ,forKey: .categoryCodeL)
        categoryNameL = try! values.decode([String].self ,forKey: .categoryNameL)
        categoryCodeS = try! values.decode([String].self ,forKey: .categoryCodeS)
        categoryNameS = try! values.decode([String].self ,forKey: .categoryNameS)
    }
}

struct Flags: Codable {
    var mobile_site: Int
    var mobile_coupon: Int
    var pc_coupon: Int
}

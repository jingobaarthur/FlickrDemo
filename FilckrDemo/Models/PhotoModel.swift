//
//  PhotoModel.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/24.
//

import Foundation
struct PhotoResponseData : Codable {
    
    let photos : Photo?
    let stat : String
    
    enum CodingKeys: String, CodingKey {
        case photos = "photos"
        case stat = "stat"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        photos = try values.decodeIfPresent(Photo.self, forKey: .photos)
        stat = try values.decodeIfPresent(String.self, forKey: .stat) ?? ""
    }
    
}

struct Photo : Codable {
    
    let page : Int
    let pages : Int
    let perpage : Int
    let photo : [PhotoDetailData]
    let total : String
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case pages = "pages"
        case perpage = "perpage"
        case photo = "photo"
        case total = "total"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? 0
        pages = try values.decodeIfPresent(Int.self, forKey: .pages) ?? 0
        perpage = try values.decodeIfPresent(Int.self, forKey: .perpage) ?? 0
        photo = try values.decodeIfPresent([PhotoDetailData].self, forKey: .photo) ?? []
        total = try values.decodeIfPresent(String.self, forKey: .total) ?? ""
    }
    
}

struct PhotoDetailData : Codable {
    
    let farm : Int
    let id : String
    let isfamily : Int
    let isfriend : Int
    let ispublic : Int
    let owner : String
    let secret : String
    let server : String
    let title : String
    var urlString: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
    }
    enum CodingKeys: String, CodingKey {
        case farm = "farm"
        case id = "id"
        case isfamily = "isfamily"
        case isfriend = "isfriend"
        case ispublic = "ispublic"
        case owner = "owner"
        case secret = "secret"
        case server = "server"
        case title = "title"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        farm = try values.decodeIfPresent(Int.self, forKey: .farm) ?? -1
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        isfamily = try values.decodeIfPresent(Int.self, forKey: .isfamily) ?? 0
        isfriend = try values.decodeIfPresent(Int.self, forKey: .isfriend) ?? 0
        ispublic = try values.decodeIfPresent(Int.self, forKey: .ispublic) ?? 0
        owner = try values.decodeIfPresent(String.self, forKey: .owner) ?? ""
        secret = try values.decodeIfPresent(String.self, forKey: .secret) ?? ""
        server = try values.decodeIfPresent(String.self, forKey: .server) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
    }
}

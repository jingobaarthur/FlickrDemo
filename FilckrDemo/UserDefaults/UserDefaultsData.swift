//
//  UserDefaultsData.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/25.
//

import Foundation
enum UserDefaultsKeys: String{
    case photoData = "photoData"
}
class UserDefaultsData{
    
    static let sharedInstance = UserDefaultsData()
    private init() {}
    
    var completed: (() -> Void)?
    
    var photoData: [PhotoDetailData]{
        get{
            return getPhotoData(UserDefaultsKeys.photoData.rawValue)
        }
        set{
            savePhotoData(UserDefaultsKeys.photoData.rawValue, value: newValue)
            if let callback = self.completed{
                callback()
            }
        }
    }
    
    //UserDefaults setting
    func set(_ key:String,value: AnyObject){
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    func savePhotoData(_ key:String, value: [PhotoDetailData]){
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func getPhotoData(_ key:String) -> [PhotoDetailData]{
        
        if let data = UserDefaults.standard.object(forKey: key) as? Data{
            if let photoData = try? JSONDecoder().decode([PhotoDetailData].self, from: data){
                return photoData
            }
            return []
        }else{
            return []
        }
    }
    
}

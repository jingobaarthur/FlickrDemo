//
//  FavotiteViewModel.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/25.
//

import Foundation
class FavotiteViewModel {
    var photo : [PhotoDetailData] = []
    var completed: (() -> Void)?
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate), name: Notification.Name("didUpdateFavorite"), object: nil)
    }
    @objc func didUpdate(){
        self.photo = UserDefaultsData.sharedInstance.photoData
        if let callBack = self.completed{
            callBack()
        }
    }
}

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
        UserDefaultsData.sharedInstance.completed = { [weak self] in
            self?.didUpdate()
        }
    }
    @objc func didUpdate(){
        self.photo = UserDefaultsData.sharedInstance.photoData
        if let callBack = self.completed{
            callBack()
        }
    }
}

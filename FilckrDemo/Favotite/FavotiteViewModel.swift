//
//  FavotiteViewModel.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/25.
//

import Foundation
class FavotiteViewModel {
    var photo : [PhotoDetailData] = []
    var photoM: [PhotoMO] = []
    var completed: (() -> Void)?
    init() {
        FlickrCoreDataHelper.sharedInstance.completed = { [weak self](context) in
            self?.didUpdate()
        }
    }
    @objc func didUpdate(){
        self.photoM = FlickrCoreDataHelper.sharedInstance.photoData
        if let callBack = self.completed{
            callBack()
        }
    }
    func loadFromCoreData(){
        FlickrCoreDataHelper.sharedInstance.load()
    }
    func delete(at row: Int){
        FlickrCoreDataHelper.sharedInstance.delete(target: photoM[row])
    }
}

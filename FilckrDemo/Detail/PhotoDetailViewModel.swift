//
//  PhotoDetailViewModel.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/24.
//

import Foundation
class PhotoDetailViewModel{
    
    var completed: (() -> Void)?
    var photoResponseData: PhotoResponseData?
    var photo : [PhotoDetailData] = []
    
    var currentPage: Int = 1
    var searchTitle = ""
    var currentPrePage: Int = 0
    
    func fetchPhotoData(text: String, pages: String, prePage: String){
        APIManager.sharedInstance.searchRequest(HttpRequest(text: text, perPage: prePage, page: pages)) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                do {
                    let responseData = try JSONDecoder().decode(PhotoResponseData.self, from: data)
                    strongSelf.photoResponseData = responseData
                    
                    if let photoArray = responseData.photos?.photo, let page = responseData.photos?.page{
                        print("CurrentPage: \(page)")
                        if strongSelf.currentPage == 1{
                            strongSelf.photo = photoArray
                        }else{
                            strongSelf.photo += photoArray
                        }
                    }
                    if let callBack = strongSelf.completed{
                        callBack()
                    }
                } catch let error {
                    print("JSONDecod error:",error)
                }
            case .failure(let error):
                print("api error:",error)
            }
        }
    }
}

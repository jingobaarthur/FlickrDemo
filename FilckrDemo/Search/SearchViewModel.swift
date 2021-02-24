//
//  SearchViewModel.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/24.
//

import Foundation

class SearchViewModel{
    
    var photoResponseData: PhotoResponseData?
    
    var completed: (() -> Void)?
    
    func fetchPhotoData(text: String, pages: String, prePage: String){
        APIManager.sharedInstance.searchRequest(HttpRequest(text: text, perPage: prePage, page: pages)) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                do {
                    let responseData = try JSONDecoder().decode(PhotoResponseData.self, from: data)
                    strongSelf.photoResponseData = responseData
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

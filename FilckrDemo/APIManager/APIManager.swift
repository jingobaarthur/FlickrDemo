//
//  APIManager.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/24.
//

import Foundation
struct HttpRequest {
    var text: String = ""
    var perPage: String = ""
    var page: String = ""
    var urlString: String {
        return "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=6cfad9429d351aedd33167de5fb64f2d&text=\(text)&per_page=\(perPage)&page=\(page)&format=json&nojsoncallback=1"
    }
    var headers: [String: String] = [:]
    var body: Data? = nil
    var method: String! = "GET"
}
class APIManager {
    
    static let sharedInstance = APIManager()
    private init() {}
    
    func makeRequest(_ httpRequest: HttpRequest) -> URLRequest {
        let urlEncodeString = httpRequest.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: urlEncodeString)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = httpRequest.headers
        if let body = httpRequest.body {
            //request.httpBody = body.data(using: String.Encoding.utf8)
            request.httpBody = body
        }
        request.httpMethod = httpRequest.method
        return request
    }
    
    func searchRequest(_ httpRequest: HttpRequest, completion: @escaping(Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: makeRequest(httpRequest), completionHandler: {  (data, response, error) in
            guard error == nil else {
                return completion(Result.failure(error!))
            }
            DispatchQueue.main.async {
                completion(Result.success(data!))
            }
        }).resume()
    }
    
    func getPhotoRequest(_ httpRequest: URLRequest, completion: @escaping(Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: httpRequest, completionHandler: {  (data, response, error) in
            guard error == nil else {
                return completion(Result.failure(error!))
            }
            DispatchQueue.main.async {
                completion(Result.success(data!))
            }
        }).resume()
    }
    
}


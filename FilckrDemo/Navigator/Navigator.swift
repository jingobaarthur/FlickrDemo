//
//  Navigator.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/25.
//

import UIKit

protocol Navigatable {
    var navigator: Navigator { get }
}

extension Navigatable {
    var navigator: Navigator {
        return Navigator.sharedInstance
    }
}

class Navigator{
    
    static let sharedInstance = Navigator()
    private init() {}
    
    enum Destination{
        
        enum TransitionType{
            case root(in: UIWindow)
            case navigation
            case present
        }
        
        case search
        case favorite
        case photoDetail(searchText: String, prePage: Int, photoArray: [PhotoDetailData])
    }
    
    func getViewController(destination: Destination) -> UIViewController{
        switch destination{
        case .search:
            return SearchViewController.initViewController()
        case .favorite:
            return FavoriteViewController.initViewController()
        case .photoDetail(let searchText, let prePage, let photoData):
            return PhotoDetailViewController.initViewController(searchText: searchText, prePage: prePage, photoArray: photoData)
        }
    }
    
    func show(destination: Destination, sender: UIViewController, transitionType: Destination.TransitionType = .navigation){
        let targetVC = getViewController(destination: destination)
        showViewController(target: targetVC, sender: sender, transitionType: transitionType)
    }
    
   private func showViewController(target: UIViewController, sender: UIViewController?, transitionType: Destination.TransitionType){
        switch transitionType{
        case .root(in: _):
            break
        default:
            break
        }
        guard let sender = sender else {
            fatalError("You need to pass in a sender for .navigation or .modal transitions")
        }
        switch transitionType{
        case .navigation:
            if let nav = sender.navigationController{
                nav.pushViewController(target, animated: true)
            }else{
                fatalError("why no navigationController")
            }
        case .present:
            sender.present(target, animated: true, completion: nil)
        default:
            fatalError("who are you")
        }
    }
}

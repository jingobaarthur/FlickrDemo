//
//  UICollectionVIew+extension.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/24.
//

import UIKit
extension UICollectionView{
    func reload(completion:@escaping() -> ()){
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
            { _ in completion() }
    }
}

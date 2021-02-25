//
//  FavoriteViewController.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/24.
//

import UIKit

class FavoriteViewController: BaseViewController {
    
    let viewModel = FavotiteViewModel()
    lazy var collectionView = UICollectionView()
    var layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        initBind()
        self.viewModel.didUpdate()
    }
    
    override func setUp() {
        super.setUp()
        self.view.backgroundColor = .white
        title = "我的最愛"
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 2) - 10, height: (UIScreen.main.bounds.width / 2) + 15)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 5, bottom: 0, right: 5)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundView?.isHidden = true
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    override func initBind() {
        super.initBind()
        viewModel.completed = { [weak self] in
            print("DidFinish fetch photo data form loacl")
            self?.collectionView.reload(completion: {})
        }
    }
    
    static func initViewController() -> FavoriteViewController{
        let vc = FavoriteViewController()
        return vc
    }
    
}

//MARK: UICOllectionView delegate & datasource
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photo.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.config(text: viewModel.photo[indexPath.item].title, imgUrl: viewModel.photo[indexPath.item].urlString, isFavoriteMode: true, row: indexPath.item, id: viewModel.photo[indexPath.item].id)
        return cell
    }
}

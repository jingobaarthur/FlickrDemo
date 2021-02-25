//
//  PhotoDetailViewController.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/24.
//

import UIKit

class PhotoDetailViewController: BaseViewController {
    
    let viewModel = PhotoDetailViewModel()
    
    lazy var collectionView = UICollectionView()
    var layout = UICollectionViewFlowLayout()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullDownToUpdate), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "搜尋結果: " + viewModel.searchTitle
        print("搜尋結果: \(viewModel.searchTitle), prePage: \(viewModel.currentPrePage)")
        setUp()
        initBind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    static func initViewController(searchText: String, prePage: Int, photoArray: [PhotoDetailData]) -> PhotoDetailViewController{
        let vc = PhotoDetailViewController()
        vc.viewModel.searchTitle = searchText
        vc.viewModel.currentPrePage = prePage
        vc.viewModel.photo = photoArray
        return vc
    }
    override func setUp() {
        super.setUp()
        self.view.backgroundColor = .white
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
        
        collectionView.refreshControl = refreshControl
    }
    override func initBind() {
        super.initBind()
        viewModel.completed = { [weak self] in
            print("DidFinish fetch photo data")
            self?.refreshControl.endRefreshing()
            self?.collectionView.reload(completion: {})
        }
    }

}
//MARK: Selector
extension PhotoDetailViewController{
    @objc func didPullDownToUpdate(){
        print("下拉更新")
        viewModel.currentPage = 1
        viewModel.fetchPhotoData(text: viewModel.searchTitle, pages: "\(viewModel.currentPage)", prePage: "\(viewModel.currentPrePage)")
    }
}
//MARK: UICollectionView delegate & datasource
extension PhotoDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.config(text: viewModel.photo[indexPath.item].title, imgUrl: viewModel.photo[indexPath.item].urlString, isFavoriteMode: false, row: indexPath.item, id: viewModel.photo[indexPath.item].id)
        cell.didTappedFavorite = { [weak self] (callback) in
            self?.viewModel.addToFavorite(id: callback.id, row: callback.row)
        }
        return cell
    }
    
}
//MARK: UIScrollViewmdelegate
extension PhotoDetailViewController: UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentSize.height > collectionView.frame.height else {return}
        if scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y) <= -10 {
            print("上滑載入")
            viewModel.currentPage += 1
            viewModel.fetchPhotoData(text: viewModel.searchTitle, pages: "\(viewModel.currentPage)", prePage: "\(viewModel.currentPrePage)")
        }
    }
}

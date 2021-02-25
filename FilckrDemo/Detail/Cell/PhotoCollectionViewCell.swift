//
//  PhotoCollectionViewCell.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/24.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var didTappedFavorite: (((id: String, row: Int)) -> Void)?
    
    var currentRow = 0
    
    var currentID = ""
    
    let photoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .clear
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "--"
        return label
    }()
    
    let favoriteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icon_AddFavorite"), for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
    super.init(frame: frame)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        favoriteButton.removeTarget(nil, action: nil, for: .allEvents)
    }
}
extension PhotoCollectionViewCell{
    func setUpUI(){
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(photoImageView)
        self.contentView.addSubview(label)
        
        photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75).isActive = true
        
        label.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 0).isActive = true
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        self.contentView.addSubview(favoriteButton)
        favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        favoriteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        favoriteButton.addTarget(self, action: #selector(didTapedFavoriteButton), for: .touchUpInside)
    }
    func config(text: String, imgUrl: String, row: Int, id: String){
        label.text = text
        currentRow = row
        currentID = id
        favoriteButton.isHidden = FlickrCoreDataHelper.sharedInstance.inquire(id: id)
        if let url = URL(string: imgUrl) {
            let request = URLRequest(url: url)
            APIManager.sharedInstance.getPhotoRequest(request) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let data):
                    let photoImage = UIImage(data: data)
                    strongSelf.photoImageView.image = photoImage
                case .failure(let error):
                    print("getPhotoRequest:",error)
                    strongSelf.photoImageView.image = nil
                    strongSelf.photoImageView.backgroundColor = .lightGray
                }
            }
        }
    }
    
    
    func configWithFavorite(text: String, imgUrl: String, row: Int, id: String){
        label.text = text
        currentRow = row
        currentID = id
        favoriteButton.isHidden = true
        if let url = URL(string: imgUrl) {
            let request = URLRequest(url: url)
            APIManager.sharedInstance.getPhotoRequest(request) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let data):
                    let photoImage = UIImage(data: data)
                    strongSelf.photoImageView.image = photoImage
                case .failure(let error):
                    print("getPhotoRequest:",error)
                    strongSelf.photoImageView.image = nil
                    strongSelf.photoImageView.backgroundColor = .lightGray
                }
            }
        }
    }
    
    @objc func didTapedFavoriteButton(){
        print("didTapedFavoriteButton")
        favoriteButton.isHidden = true
        if let callBack = self.didTappedFavorite{
            callBack((id: self.currentID , row: self.currentRow))
        }
    }
}

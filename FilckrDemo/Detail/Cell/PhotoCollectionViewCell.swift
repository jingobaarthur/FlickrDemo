//
//  PhotoCollectionViewCell.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/24.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .clear
        imgView.contentMode = .scaleAspectFit
        imgView.backgroundColor = .lightGray
        return imgView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "--"
        return label
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
    }
}
extension PhotoCollectionViewCell{
    func setUpUI(){
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        
    }
    func config(text: String, imgUrl: String){
        label.text = text
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
                }
            }
        }
    }
}

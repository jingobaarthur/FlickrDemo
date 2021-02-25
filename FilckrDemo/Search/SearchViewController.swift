//
//  ViewController.swift
//  FilckrDemo
//
//  Created by Arthur on 2021/2/23.
//

import UIKit

class SearchViewController: BaseViewController {
    fileprivate let viewModel = SearchViewModel()
    /*搜尋內容*/
    lazy var contentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "欲搜尋內容"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
        return textField
    }()
    /*每頁筆數*/
    lazy var prePageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "每頁愈呈現數量"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
        return textField
    }()
    /*搜尋*/
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("搜尋", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTappedSearchButton), for: .touchUpInside)
        return button
    }()
    
    var stackView: UIStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        textFieldAction()
        initBind()
    }
    static func initViewController() -> SearchViewController{
        let vc = SearchViewController()
        return vc
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    override func setUp() {
        super.setUp()
        self.view.backgroundColor = .white
        
        contentTextField.translatesAutoresizingMaskIntoConstraints = false
        prePageTextField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentTextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        contentTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        prePageTextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        prePageTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        searchButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stackView = UIStackView(arrangedSubviews: [contentTextField, prePageTextField,searchButton])
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    override func initBind() {
        super.initBind()
        viewModel.completed = { [weak self] in
            print("DidFinish fetch photo data")
            if let contentString = self?.contentTextField.text, let page = self?.prePageTextField.text{
                //self?.showPhotDetail(searchText: contentString, prePage: page)
                self?.showPhotoDetailByNavigator(searchText: contentString, prePage: page)
            }
        }
    }
}

//MARK: Selector
extension SearchViewController{
    @objc func textFieldAction(){
        if let contentString = self.contentTextField.text, let page = self.prePageTextField.text{
            let btnEnable = contentString.count > 0 && page.count > 0
            changeButtonStatus(isEnable: btnEnable)
        }
    }
    func changeButtonStatus(isEnable: Bool){
        if isEnable{
            searchButton.isEnabled = true
            searchButton.backgroundColor = .blue
        }else{
            searchButton.isEnabled = false
            searchButton.backgroundColor = .lightGray
        }
    }
    @objc func didTappedSearchButton(){
        print("Tapped Search button")
        if let contentString = self.contentTextField.text, let page = self.prePageTextField.text{
            viewModel.fetchPhotoData(text: contentString, pages: "\(1)", prePage: page)
            changeButtonStatus(isEnable: false)
            self.view.endEditing(true)
        }
    }
    func showPhotDetail(searchText: String, prePage: String){
        let detailVC = PhotoDetailViewController()
        guard let prePage = Int(prePage), let photoArray = viewModel.photoResponseData?.photos?.photo else {return}
        detailVC.viewModel.currentPrePage = prePage
        detailVC.viewModel.searchTitle = searchText
        detailVC.viewModel.photo = photoArray
        contentTextField.text = ""
        prePageTextField.text = ""
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func showPhotoDetailByNavigator(searchText: String, prePage: String){
        guard let prePage = Int(prePage), let photoArray = viewModel.photoResponseData?.photos?.photo else {return}
        navigator.show(destination: .photoDetail(searchText: searchText, prePage: prePage, photoArray: photoArray), sender: self)
    }
}

//MARK: UITextField delegate
extension SearchViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension SearchViewController{
    
}

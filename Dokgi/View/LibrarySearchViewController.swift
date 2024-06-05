//
//  LibrarySearchViewController.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/4/24.
//

import SnapKit
import UIKit

class LibrarySearchViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    let sortButton = UIButton()
    
    lazy var libraryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 36
        layout.minimumInteritemSpacing = 0
        layout.itemSize = .init(width: 165, height: 260)
        layout.sectionInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LibraryCollectionViewCell.self, forCellWithReuseIdentifier: LibraryCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = false
        
        setSearchController()
        
        setConstraint()
        
        setSortButton()
        
        
    }
    
    //MARK: - searchController
    
    func setSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        let searchBar = searchController.searchBar
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.navigationItem.title = "서재"
        self.navigationItem.largeTitleDisplayMode = .always
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28, weight: .bold)
        ]
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        
        searchBar.placeholder = "기록된 책을 검색해보세요"
        searchBar.searchTextField.borderStyle = .line
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.layer.borderColor = UIColor.gray.cgColor // 수정필요
        searchBar.searchTextField.layer.backgroundColor = UIColor.white.cgColor
        searchBar.searchTextField.layer.cornerRadius = 20
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 14)
        
        // 돋보기 위치 변경
        if let leftView = searchBar.searchTextField.leftView as? UIImageView {
            leftView.frame = leftView.frame.offsetBy(dx: 14.5, dy: 0)
        }
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        dump(searchController.searchBar.text)
        
        guard let text = searchController.searchBar.text?.lowercased() else {
            return
        }
        
    }
    
    
    func setSortButton() {
        
        let resizedImage = UIImage(systemName: "chevron.down")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 10))
        sortButton.setImage(resizedImage, for: .normal )
        
        sortButton.backgroundColor = .lightGray
        sortButton.layer.cornerRadius = 15
        
//        let configuration = UIButton.Configuration.plain()
//        sortButton.configuration = configuration
        
        
        let seletedPriority = {(action: UIAction)  in
            
            if action.title == " 최신순" {
                
            } else if action.title == " 오래된순" {
                
            }
        }
        
        let latestFirst = UIAction(title: "최신순", state: .on, handler: seletedPriority)
        let oldestFirst = UIAction(title: "오래된순", state: .off, handler: seletedPriority)
        
        self.sortButton.menu = UIMenu(children: [latestFirst,oldestFirst])
        self.sortButton.showsMenuAsPrimaryAction = true
        self.sortButton.changesSelectionAsPrimaryAction = true
    }
    
    
    func setConstraint() {
        
        [sortButton, libraryCollectionView].forEach {
            view.addSubview($0)
        }
        sortButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(210)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(29)
        }
        
        libraryCollectionView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom)
            $0.bottom.left.right.equalToSuperview().inset(0)
        }
        
        
    }
    
}


//MARK: -CollectionView
extension LibrarySearchViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCollectionViewCell", for: indexPath) as? LibraryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}


//
//  LibrarySearchViewController.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/4/24.
//

import SnapKit
import UIKit

class LibrarySearchViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    
    lazy var searchController = UISearchController(searchResultsController: nil)
    let sortButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = false
        
        setSearchController()
        setSortButton()
        
        configUI()
        constraintLayout()
        
        
    }
    
    //MARK: - searchController
    
    func setSearchController() {
        
        let searchBar = searchController.searchBar
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.hidesNavigationBarDuringPresentation = true
        
        self.navigationItem.title = "서재"
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        
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
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 13)
        
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
        
        let configuration = UIButton.Configuration.plain()
        sortButton.configuration = configuration
        
        
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
    
    func configUI() {
        
        view.addSubview(sortButton)
        
    }
    
    func constraintLayout() {
        
        sortButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(29)
        }
    }
    
}

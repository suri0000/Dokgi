//
//  LibrarySearchViewController.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/4/24.
//

import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class LibraryViewController: UIViewController, UISearchBarDelegate {
    
    let libraryView = LibraryView()
    let collectionView = LibraryCollectionView()
    
    let libraryViewModel = LibraryViewModel()
    let disposeBag = DisposeBag()
    
    private var isFiltering: Bool = false
    private var isLatestFirst: Bool = true
    private var isOldestFirst: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        libraryView.searchBar.delegate = self
        
        initLayout()
     
        setFloatingButton()
        
        CoreDataManager.shared.bookData.subscribe(with: self) { (self, bookData) in
            self.libraryViewModel.dataFilter(verses: bookData)
        }.disposed(by: disposeBag)
        
        libraryViewModel.libraryData.subscribe(with: self) { (self, bookData) in
            self.collectionView.libraryCollectionView.reloadData()
        }.disposed(by: disposeBag)
        self.libraryView.searchBar.searchTextField.rx.controlEvent(.editingDidBegin).subscribe(with: self) { (self, _) in
            self.libraryView.searchBar.showsCancelButton = true
        }.disposed(by: disposeBag)
        self.libraryView.searchBar.rx.text.debounce(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(with: self) { (self, text) in
            guard let text = text else { return }
            self.libraryViewModel.dataSearch(text: text)
        }.disposed(by: disposeBag)
        
        self.libraryView.searchBar.rx.searchButtonClicked.subscribe(with: self) { (self, _) in
            self.libraryView.searchBar.resignFirstResponder()
            self.libraryView.searchBar.showsCancelButton = false
        }.disposed(by: disposeBag)
        
        self.libraryView.searchBar.rx.cancelButtonClicked.subscribe(with: self) { (self, _) in
            self.libraryView.searchBar.resignFirstResponder()
            self.libraryView.searchBar.showsCancelButton = false
        }.disposed(by: disposeBag)
        
        libraryView.oldestFirstButton.addTarget(self, action: #selector(tappedOldestFirst), for: .touchUpInside)
        libraryView.latestFirstButton.addTarget(self, action: #selector(tappedLatestFirst), for: .touchUpInside)
        libraryView.sortButton.addTarget(self, action: #selector(showOrHideSortMenuView), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        CoreDataManager.shared.readData()
        if libraryView.sortButtonTitleLabel.text == "오래된순" {
            self.libraryViewModel.dataOldest()
        }
    }
    
    private func initLayout() {
        view.addSubview(libraryView)
        
        libraryView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    //MARK: -버튼 클릭
    @objc private func showOrHideSortMenuView() {
        if libraryView.sortMenuView.isHidden {
            libraryView.sortMenuView.isHidden = false
            libraryView.bringSubviewToFront(libraryView.sortMenuView)
        } else {
            libraryView.sortMenuView.isHidden = true
        }
    }
    
    @objc private func tappedLatestFirst() {
        libraryView.sortButtonTitleLabel.text = "최신순"

        libraryView.latestFirstcheckImageView.isHidden = false
        libraryView.oldestFirstcheckImageView.isHidden = true
        self.libraryViewModel.dataLatest()
        libraryView.sortMenuView.isHidden = true
    }
    
    @objc private func tappedOldestFirst() {
        libraryView.sortButtonTitleLabel.text = "오래된순"
        
        libraryView.latestFirstcheckImageView.isHidden = true
        libraryView.oldestFirstcheckImageView.isHidden = false
        self.libraryViewModel.dataOldest()
        libraryView.sortMenuView.isHidden = true
    }
}

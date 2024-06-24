//
//  ParagraphViewController.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/10/24.
//

import RxSwift
import SnapKit
import UIKit

class PassageViewController: UIViewController {
    
    let passageView = PassageView()
    let collectionView = PassageCollectionView()
    
    let viewModel = PassageViewModel()
    var disposeBag = DisposeBag()
    
    var isFiltering: Bool = false
    
    private var isLatestFirst: Bool = true
    private var isOldestFirst: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        passageView.searchBar.delegate = self
        
        viewModel.passageData.subscribe(with: self) { (self, data) in
            if let layout = self.collectionView.passageCollectionView.collectionViewLayout as? PassageCollectionViewLayout {
                       layout.invalidateCache()
                   }
            self.collectionView.passageCollectionView.reloadData()
               }.disposed(by: disposeBag)
        
        initLayout()
        setFloatingButton()
        
        passageView.selectionButton.addTarget(self, action: #selector(tappedSelectionButton), for: .touchUpInside)
        passageView.sortButton.addTarget(self, action: #selector(showOrHideSortMenuView), for: .touchUpInside)
        passageView.latestFirstButton.addTarget(self, action: #selector(tappedLatestFirst), for: .touchUpInside)
        passageView.doneButton.addTarget(self, action: #selector(tappedDoneButton), for: .touchUpInside)
        passageView.oldestFirstButton.addTarget(self, action: #selector(tappedOldestFirst), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        if passageView.sortButton.titleLabel?.text != "최신순" {
            let sortedPassageAndDate = viewModel.passageData.value.sorted { $0.1 > $1.1 }
            
            isFiltering ? collectionView.searchResultItems.sort { $0.1 > $1.1 } : viewModel.passageData.accept(sortedPassageAndDate)
        }
        self.collectionView.passageCollectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        passageView.sortMenuView.isHidden = true
    }
    
    private func bindViewModel() {
    }
    
    private func initLayout() {
        view.addSubview(passageView)
        
        passageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - 설정버튼
    @objc private func showOrHideSortMenuView() {
        if passageView.sortMenuView.isHidden {
            passageView.sortMenuView.isHidden = false
            passageView.bringSubviewToFront(passageView.sortMenuView)
        } else {
            passageView.sortMenuView.isHidden = true
        }
    }
    
    @objc private func tappedLatestFirst() {
        passageView.sortButtonTitleLabel.text = "최신순"
        passageView.latestFirstcheckImageView.isHidden = false
        passageView.oldestFirstcheckImageView.isHidden = true
        passageView.sortMenuView.isHidden = true
        
        let sortedPassageAndDate = viewModel.passageData.value.sorted { $0.1 > $1.1 }
        
        isFiltering ? collectionView.searchResultItems.sort { $0.1 > $1.1 } : viewModel.passageData.accept(sortedPassageAndDate)
    }
    
    @objc private func tappedOldestFirst() {
        passageView.sortButtonTitleLabel.text = "오래된순"
        passageView.latestFirstcheckImageView.isHidden = true
        passageView.oldestFirstcheckImageView.isHidden = false
        passageView.sortMenuView.isHidden = true
        
        let sortedPassageAndDate = viewModel.passageData.value.sorted { $0.1 < $1.1 }
        
        isFiltering ? collectionView.searchResultItems.sort { $0.1 < $1.1 } : viewModel.passageData.accept(sortedPassageAndDate)
    }
    
    @objc private func tappedSelectionButton() {
        collectionView.isEditingMode = true
        passageView.selectionButton.isHidden = true
        passageView.doneButton.isHidden = false
        
        self.collectionView.passageCollectionView.reloadData()
    }
    
    @objc private func tappedDoneButton() {
        collectionView.isEditingMode = false
        passageView.selectionButton.isHidden = false
        passageView.doneButton.isHidden = true
        
        self.collectionView.passageCollectionView.reloadData()
    }
}

//MARK: - SearchBar
extension PassageViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isFiltering = true
        self.passageView.searchBar.showsCancelButton = true
        collectionView.searchResultItems = viewModel.passageData.value
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBarText.accept(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        passageView.searchBar.showsCancelButton = false
        self.passageView.searchBar.resignFirstResponder()
        self.isFiltering = false
        self.passageView.searchBar.text = ""
        self.collectionView.searchResultItems = []
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        viewModel.searchBarText.accept(searchText)
        
        self.passageView.searchBar.showsCancelButton = false
        self.passageView.searchBar.resignFirstResponder()
    }
}

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
    let passageCollectionVC = PassageCollectionVC()
    let passageCollectionView = PassageCollectionVC().passageCollectionView
    let viewModel = PassageViewModel()
    var disposeBag = DisposeBag()
    
    var isFiltering: Bool = false
    
    private var isLatestFirst: Bool = true
    private var isOldestFirst: Bool = false
    private var selectedIndexPaths = [IndexPath]()
    
    let sortMenuView = PassageView().sortMenuView
    let searchBar = PassageView().searchBar
  
    var searchResultItems = PassageCollectionVC().searchResultItems
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.paragraphData.subscribe { [weak self] data in
            print("viewMdoel에 paragraphData가 변경될 때 호출됨")
            // layout update
            // collectionView update
            
            self?.passageCollectionVC.searchResultItems = data
        }.disposed(by: disposeBag)
        
        viewModel.paragraphData.subscribe(with: self) { (self, data) in
            if let layout = self.passageCollectionView.collectionViewLayout as? PassageCollectionViewLayout {
                layout.invalidateCache()
            }
            
            self.passageCollectionView.reloadData()
        }.disposed(by: disposeBag)
        
        
        view.backgroundColor = .white

        passageView.searchBar.delegate = self
        setFloatingButton()
        
        passageView.latestFirstButton.addTarget(self, action: #selector(tappedLatestFirst), for: .touchUpInside)
        
        passageView.doneButton.addTarget(self, action: #selector(tappedDoneButton), for: .touchUpInside)
        
        passageView.oldestFirstButton.addTarget(self, action: #selector(tappedOldestFirst), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        if passageView.sortButton.titleLabel?.text != "최신순" {
            let sortedPassageAndDate = viewModel.paragraphData.value.sorted { $0.1 > $1.1 }
            
            isFiltering ? searchResultItems.sort { $0.1 > $1.1 } : viewModel.paragraphData.accept(sortedPassageAndDate)
        }
        self.passageCollectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        passageView.sortMenuView.isHidden = true
    }

    // MARK: - 설정버튼
    @objc private func showOrHideSortMenuView() {
        if sortMenuView.isHidden {
            sortMenuView.isHidden = false
            view.bringSubviewToFront(sortMenuView)
        } else {
            sortMenuView.isHidden = true
        }
    }
    
    @objc private func tappedLatestFirst() {
        passageView.sortButtonTitleLabel.text = "최신순"
        passageView.latestFirstcheckImageView.isHidden = false
        passageView.oldestFirstcheckImageView.isHidden = true
        sortMenuView.isHidden = true
        
        let sortedPassageAndDate = viewModel.paragraphData.value.sorted { $0.1 > $1.1 }
        
        isFiltering ? searchResultItems.sort { $0.1 > $1.1 } : viewModel.paragraphData.accept(sortedPassageAndDate)
    }
    
    @objc private func tappedOldestFirst() {
        passageView.sortButtonTitleLabel.text = "오래된순"
        passageView.latestFirstcheckImageView.isHidden = true
        passageView.oldestFirstcheckImageView.isHidden = false
        sortMenuView.isHidden = true
        
        let sortedPassageAndDate = viewModel.paragraphData.value.sorted { $0.1 < $1.1 }
        
        isFiltering ? searchResultItems.sort { $0.1 < $1.1 } : viewModel.paragraphData.accept(sortedPassageAndDate)
    }
    
    @objc private func tappedSelectionButton() {
        passageCollectionVC.isEditingMode = true
        passageView.selectionButton.isHidden = true
        passageView.doneButton.isHidden = false
        
        self.passageCollectionView.reloadData()
    }
    
    @objc private func tappedDoneButton() {
        passageCollectionVC.isEditingMode = false
        passageView.selectionButton.isHidden = false
        passageView.doneButton.isHidden = true
        
        self.passageCollectionView.reloadData()
    }
}

//MARK: - SearchBar
extension PassageViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isFiltering = true
        self.searchBar.showsCancelButton = true
        searchResultItems = viewModel.paragraphData.value
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // searchText -> 가나다
        viewModel.searchBarText.accept(searchText)
//        filterItems(with: searchText)
    }
    
    private func filterItems(with searchText: String) {
        if searchText.isEmpty {
            searchResultItems = viewModel.paragraphData.value
        } else {
            searchResultItems = viewModel.paragraphData.value.filter { $0.0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        passageView.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
        self.isFiltering = false
        self.searchBar.text = ""
        self.searchResultItems = []
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        filterItems(with: searchText)
        
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
}

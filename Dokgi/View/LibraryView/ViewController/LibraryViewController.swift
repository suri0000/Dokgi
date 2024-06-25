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
    
    let libraryViewModel = LibraryViewModel()
    let disposeBag = DisposeBag()
    
    private var isFiltering: Bool = false
    private var isLatestFirst: Bool = true
    private var isOldestFirst: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        libraryView.searchBar.delegate = self
      
        libraryView.libraryCollectionView.delegate = self
        libraryView.libraryCollectionView.dataSource = self
        
        initLayout()
        setBinding()
        setButtonActions()
        setFloatingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        
        CoreDataManager.shared.readBook()
        
        if sortButtonTitleLabel.text == "오래된순" {
            self.libraryViewModel.dataOldest()
        }
    }
    
    private func initLayout() {
        view.addSubview(libraryView)
        
        libraryView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setBinding() {
        libraryViewModel.libraryData.subscribe(with: self) { (self, bookData) in
            self.libraryCollectionView.reloadData()
        }.disposed(by: disposeBag)
        
        self.searchBar.searchTextField.rx.controlEvent(.editingDidBegin).subscribe(with: self) { (self, _) in
            self.searchBar.showsCancelButton = true
        }.disposed(by: disposeBag)
        
        self.searchBar.rx.text.debounce(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(with: self) { (self, text) in
            guard let text = text else { return }
            self.libraryViewModel.dataSearch(text: text)
        }.disposed(by: disposeBag)
    }
    
    private func setButtonActions() {
        libraryView.oldestFirstButton.addTarget(self, action: #selector(tappedOldestFirst), for: .touchUpInside)
        libraryView.latestFirstButton.addTarget(self, action: #selector(tappedLatestFirst), for: .touchUpInside)
        libraryView.sortButton.addTarget(self, action: #selector(showOrHideSortMenuView), for: .touchUpInside)
    }
    
    //MARK: -버튼 클릭 시
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
//MARK: - CollectionView
extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellCount = libraryViewModel.libraryData.value.count
        
        libraryView.emptyMessageLabel.isHidden = cellCount > 0
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCell.identifier, for: indexPath) as? LibraryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.authorNameLabel.text = libraryViewModel.libraryData.value[indexPath.row].author
        cell.bookNameLabel.text = libraryViewModel.libraryData.value[indexPath.row].title
        if let url = URL(string: libraryViewModel.libraryData.value[indexPath.row].image) {
            cell.bookImageView.kf.setImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookDetailViewController = BookDetailViewController()
        bookDetailViewController.viewModel.bookInfo.accept(libraryViewModel.libraryData.value[indexPath.row])
        self.navigationController?.pushViewController(bookDetailViewController, animated: true)
    }
}

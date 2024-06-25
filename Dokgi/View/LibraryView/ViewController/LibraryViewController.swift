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
import Then
import UIKit

class LibraryViewController: BaseLibraryAndPassageViewController, UISearchBarDelegate {
    
    let libraryCollectionView = LibraryCollectionView()
    
    let libraryViewModel = LibraryViewModel()
    let disposeBag = DisposeBag()
    
    private var isFiltering: Bool = false
    private var isLatestFirst: Bool = true
    private var isOldestFirst: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        searchBar.delegate = self
        
        libraryCollectionView.delegate = self
        libraryCollectionView.dataSource = self
        
        setLabelText(title: "서재", placeholder: "기록한 책을 검색해보세요", noResultsMessage: "기록한 책이 없어요\n구절을 등록해 보세요")
        
        initLayout()
        setBinding()
        setFloatingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        CoreDataManager.shared.readData()
        if sortButton.sortButtonTitleLabel.text == "오래된순" {
            self.libraryViewModel.dataOldest()
        }
        self.libraryCollectionView.reloadData()
    }
    
    private func initLayout() {
        view.backgroundColor = .white
        
        view.addSubview(libraryCollectionView)
        
        libraryCollectionView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom).offset(20)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setBinding() {
        CoreDataManager.shared.bookData.subscribe(with: self) { (self, bookData) in
            self.libraryViewModel.dataFilter(verses: bookData)
        }.disposed(by: disposeBag)
        
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
        
        self.searchBar.rx.searchButtonClicked.subscribe(with: self) { (self, _) in
            self.searchBar.resignFirstResponder()
            self.searchBar.showsCancelButton = false
        }.disposed(by: disposeBag)
        
        self.searchBar.rx.cancelButtonClicked.subscribe(with: self) { (self, _) in
            self.searchBar.resignFirstResponder()
            self.searchBar.showsCancelButton = false
        }.disposed(by: disposeBag)
    }
    
    //MARK: -버튼 클릭 시
    override func latestButtonAction() {
        self.libraryViewModel.dataLatest()
    }
    
    override func oldestButtonAction() {
        self.libraryViewModel.dataOldest()
    }
}
//MARK: - CollectionView
extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellCount = libraryViewModel.libraryData.value.count
        
        noResultsLabel.isHidden = cellCount > 0
        if isFiltering { noResultsLabel.text = "검색결과가 없습니다." }
        
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCell.identifier, for: indexPath) as? LibraryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.authorNameLabel.text = libraryViewModel.libraryData.value[indexPath.row].author
        cell.bookNameLabel.text = libraryViewModel.libraryData.value[indexPath.row].name
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

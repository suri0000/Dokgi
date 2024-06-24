//
//  LibraryCollectionVC.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/21/24.
//
import RxSwift
import UIKit

class LibraryCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let libraryViewModel = LibraryViewModel()
    var disposeBag = DisposeBag()
    
    var isEditingMode: Bool = false
    var isFiltering: Bool = false
    
    lazy var libraryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 36
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = .init(top: 0, left: 20, bottom: 20, right: 20)
        
        let spacing: CGFloat = 24
        let countForLine: CGFloat = 2
        let deviceWidth = UIScreen.main.bounds.width
        let inset: CGFloat = 20
        let cellWidth = (deviceWidth - spacing - inset * 2)/countForLine
        
        layout.itemSize = .init(width: cellWidth, height: cellWidth * 1.58)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LibraryCollectionViewCell.self, forCellWithReuseIdentifier: LibraryCollectionViewCell.identifier)
        collectionView.backgroundColor = .yellow
        return collectionView
    }()
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellCount = libraryViewModel.libraryData.value.count
        
        LibraryView().emptyMessageLabel.isHidden = cellCount > 0
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
        BookDetailViewModel.shared.bookInfo.accept(libraryViewModel.libraryData.value[indexPath.row])
        let bookDetailViewController = BookDetailViewController()
        PassageViewController().navigationController?.pushViewController(bookDetailViewController, animated: true)
    }
}

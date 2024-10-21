//
//  LibrarySearchViewController.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/4/24.
//
import UIKit

final class LibraryCollectionView: UICollectionView {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = .init(top: 0, left: 20, bottom: 20, right: 20)
        
        let spacing: CGFloat = 24
        let countForLine: CGFloat = 2
        let deviceWidth = UIScreen.main.bounds.width
        let inset: CGFloat = 20
        let cellWidth = (deviceWidth - spacing - inset * 2)/countForLine
        let cellHeight = cellWidth * 1.58
        
        layout.itemSize = .init(width: cellWidth, height: cellHeight)
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.register(LibraryCollectionViewCell.self, forCellWithReuseIdentifier: LibraryCollectionViewCell.identifier)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

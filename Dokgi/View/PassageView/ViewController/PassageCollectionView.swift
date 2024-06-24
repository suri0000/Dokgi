//
//  PassageCollectionView.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/21/24.
//
import UIKit

class PassageCollectionView: UICollectionView {
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        self.contentInset = UIEdgeInsets(top: 2, left: 14, bottom: 15, right: 14)
        self.register(PassageCollectionViewCell.self, forCellWithReuseIdentifier: PassageCollectionViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

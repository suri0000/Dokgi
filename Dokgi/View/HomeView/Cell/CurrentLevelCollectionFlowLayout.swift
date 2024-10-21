//
//  CurrentLevelCollectionFlowLayout.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/8/24.
//

import UIKit

final class CurrentLevelCollectionFlowLayout: UICollectionViewFlowLayout {
    
    private let itemWidth: CGFloat = 300
    private let itemHeight: CGFloat = 164
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        configureInsets()
    }
    
    private func setupLayout() {
        scrollDirection = .horizontal
        minimumInteritemSpacing = 0
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    private func configureInsets() {
        guard let collectionView = collectionView else { return }
        
        let horizontalInsets = (collectionView.frame.size.width - itemSize.width) / 2
        collectionView.contentInset = UIEdgeInsets(top: 0, left: horizontalInsets, bottom: 0, right: horizontalInsets)
        minimumLineSpacing = 0
    }
}

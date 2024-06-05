//
//  HomeViewController.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/4/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    private enum Const {
        static let itemSize = CGSize(width: 300, height: 164)
        static let itemSpacing = 10.0
        static var insetX: CGFloat {
            (UIScreen.main.bounds.width - Self.itemSize.width) / 2.0
        }
        static var CollectionViewContentInset: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: Self.insetX, bottom: 0, right: Self.insetX)
        }
    }
    
    let currentLengthLabel = UILabel()
    let currentLengthCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Const.itemSize
        layout.minimumLineSpacing = Const.itemSpacing
        layout.minimumInteritemSpacing = 0
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(CurrentLengthCell.self, forCellWithReuseIdentifier: CurrentLengthCell.identifier)
        view.isPagingEnabled = false
        view.contentInset = Const.CollectionViewContentInset
        view.decelerationRate = .fast
        return view
    }()
    
    
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLengthCollectionView.dataSource = self
        currentLengthCollectionView.delegate = self
        setupConstraints()
        configureUI()
    }
    
    func setupConstraints() {
        view.addSubview(currentLengthLabel)
        view.addSubview(currentLengthCollectionView)
        currentLengthLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(112)
            $0.leading.equalToSuperview().offset(29)
        }
        
        currentLengthCollectionView.snp.makeConstraints {
            $0.top.equalTo(currentLengthLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        currentLengthLabel.text = "현재 구절 길이"
        currentLengthLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    }

}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentLengthCell.identifier, for: indexPath) as? CurrentLengthCell else { return UICollectionViewCell() }
        cell.setCellConfig(viewModel.data[indexPath.row])
        return cell
    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
    let cellWidth = Const.itemSize.width + Const.itemSpacing
    let index = round(scrolledOffsetX / cellWidth)
    targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
  }
}

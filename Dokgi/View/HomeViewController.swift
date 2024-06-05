//
//  HomeViewController.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/4/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    let viewModel = HomeViewModel()
    
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
    
    let nextLengthLabel = UILabel()
    let lengthProgress = UIProgressView()
    let currentPosition = UIImageView()
    let currentPositionImage = UIImageView()
    let nextPosition = UIImageView()
    let nextpositionImage = UIImageView()
    let progressPosition = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLengthCollectionView.dataSource = self
        currentLengthCollectionView.delegate = self
        setupConstraints()
        configureUI()
    }
    
    func setupConstraints() {
        [currentLengthLabel, currentLengthCollectionView, nextLengthLabel, lengthProgress, currentPosition, currentPositionImage, nextPosition, nextpositionImage, progressPosition].forEach {
            view.addSubview($0)
        }
        
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
        
        nextLengthLabel.snp.makeConstraints {
            $0.top.equalTo(currentLengthCollectionView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(35)
            $0.trailing.equalToSuperview().offset(-35)
        }
        
        lengthProgress.snp.makeConstraints {
            $0.leading.trailing.equalTo(nextLengthLabel)
            $0.top.equalTo(nextLengthLabel.snp.bottom).offset(18)
        }
        
        progressPosition.snp.makeConstraints {
            $0.centerY.equalTo(lengthProgress.snp.centerY)
            $0.leading.equalTo(currentPosition.snp.leading).offset(11)
            $0.width.height.equalTo(16)
        }
        
        currentPosition.snp.makeConstraints {
            $0.width.equalTo(38)
            $0.height.equalTo(41)
            $0.top.equalTo(lengthProgress.snp.bottom).offset(7)
            $0.leading.equalTo(lengthProgress.snp.leading).offset(-17)
        }
        
        currentPositionImage.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(36)
            $0.top.equalTo(currentPosition.snp.top).offset(4)
            $0.centerX.equalTo(currentPosition.snp.centerX)
        }
        
        nextPosition.snp.makeConstraints {
            $0.width.equalTo(38)
            $0.height.equalTo(41)
            $0.top.equalTo(lengthProgress.snp.bottom).offset(7)
            $0.trailing.equalTo(lengthProgress.snp.trailing).offset(17)
        }
        
        nextpositionImage.snp.makeConstraints {
            $0.width.equalTo(36)
            $0.height.equalTo(36)
            $0.top.equalTo(nextPosition.snp.top).offset(4)
            $0.centerX.equalTo(nextPosition.snp.centerX)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        currentLengthLabel.text = "현재 구절 길이"
        currentLengthLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        
        nextLengthLabel.text = "다음까지 남은 길이는?"
        nextLengthLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        lengthProgress.progressViewStyle = .default
        lengthProgress.progressTintColor = .deepSkyBlue
        lengthProgress.transform = lengthProgress.transform.scaledBy(x: 1, y: 2)
        
        progressPosition.layer.cornerRadius = 9
        progressPosition.backgroundColor = .deepSkyBlue
        currentPosition.image = UIImage(named: "speechBubble1")
        nextPosition.image = UIImage(named: "speechBubble2")
        currentPositionImage.backgroundColor = .clear
        currentPositionImage.layer.cornerRadius = 18
        currentPositionImage.image = UIImage(named: "grape")
        currentPositionImage.layer.masksToBounds = true
        currentPositionImage.contentMode = .scaleAspectFit
        nextpositionImage.backgroundColor = .clear
        nextpositionImage.layer.cornerRadius = 18
        nextpositionImage.image = UIImage(named: "goni")
        nextpositionImage.contentMode = .scaleAspectFit
        nextpositionImage.layer.masksToBounds = true
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

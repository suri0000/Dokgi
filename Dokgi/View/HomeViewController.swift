//
//  HomeViewController.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/4/24.
//

import RxSwift
import RxCocoa
import SnapKit
import UIKit

class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = HomeViewModel()
    
    let currentLengthLabel = UILabel()
    let currentLevelCollectionView: UICollectionView = {
        let layout = CurrentLevelCollectionFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(CurrentLevelCell.self, forCellWithReuseIdentifier: CurrentLevelCell.identifier)
        view.isPagingEnabled = false
        view.decelerationRate = .fast
        return view
    }()
    
    let nextLengthLabel = UILabel()
    let lengthSlider = UISlider()
    let currentLevelBubble = UIImageView()
    let currentLevelImage = UIImageView()
    let nextLevelBubble = UIImageView()
    let nextLevelImage = UIImageView()
    
    var levelCollectionViewSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        configureUI()
        setupCollectionView()
        bindViewModel()
    }
    
    func setupConstraints() {
        [currentLengthLabel, currentLevelCollectionView, nextLengthLabel, lengthSlider, currentLevelBubble, nextLevelBubble].forEach {
            view.addSubview($0)
        }
        currentLevelBubble.addSubview(currentLevelImage)
        nextLevelBubble.addSubview(nextLevelImage)
        
        
        currentLengthLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(112)
            $0.leading.equalToSuperview().offset(29)
        }
        
        currentLevelCollectionView.snp.makeConstraints {
            $0.top.equalTo(currentLengthLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        nextLengthLabel.snp.makeConstraints {
            $0.top.equalTo(currentLevelCollectionView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(35)
            $0.trailing.equalToSuperview().offset(-35)
        }
        
        lengthSlider.snp.makeConstraints {
            $0.leading.trailing.equalTo(nextLengthLabel)
            $0.top.equalTo(nextLengthLabel.snp.bottom).offset(18)
        }
        
        currentLevelBubble.snp.makeConstraints {
            $0.width.equalTo(38)
            $0.height.equalTo(41)
            $0.top.equalTo(lengthSlider.snp.bottom)
            $0.leading.equalTo(lengthSlider.snp.leading).offset(-17)
        }
        
        currentLevelImage.snp.makeConstraints {
            $0.width.equalTo(28)
            $0.height.equalTo(28)
            $0.top.equalTo(currentLevelBubble.snp.top).offset(8)
            $0.centerX.equalTo(currentLevelBubble.snp.centerX)
        }
        
        nextLevelBubble.snp.makeConstraints {
            $0.width.equalTo(38)
            $0.height.equalTo(41)
            $0.top.equalTo(lengthSlider.snp.bottom)
            $0.trailing.equalTo(lengthSlider.snp.trailing).offset(17)
        }
        
        nextLevelImage.snp.makeConstraints {
            $0.width.equalTo(28)
            $0.height.equalTo(28)
            $0.top.equalTo(nextLevelBubble.snp.top).offset(8)
            $0.centerX.equalTo(nextLevelBubble.snp.centerX)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        currentLengthLabel.text = "현재 구절 길이"
        currentLengthLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        
        nextLengthLabel.text = "다음까지 남은 길이는?"
        nextLengthLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        if let thumbImage = UIImage(named: "currentThum") {
            lengthSlider.setThumbImage(thumbImage, for: .normal)
            lengthSlider.setThumbImage(thumbImage, for: .highlighted)
        }
        lengthSlider.isUserInteractionEnabled = false
        
        currentLevelBubble.image = UIImage(named: "speechBubble1")
        currentLevelBubble.clipsToBounds = true
        currentLevelImage.backgroundColor = .clear
        currentLevelImage.image = UIImage(named: "grape")
        currentLevelImage.layer.masksToBounds = true
        currentLevelImage.contentMode = .scaleAspectFit
        
        nextLevelBubble.image = UIImage(named: "speechBubble2")
        nextLevelBubble.clipsToBounds = true
        nextLevelImage.backgroundColor = .clear
        nextLevelImage.image = UIImage(named: "goni")
        nextLevelImage.contentMode = .scaleAspectFit
        nextLevelImage.layer.masksToBounds = true
    }
    
    func setupCollectionView() {
        currentLevelCollectionView.dataSource = self
        currentLevelCollectionView.delegate = self
        currentLevelCollectionView.layoutIfNeeded() // 레이아웃 새로고침
        currentLevelCollectionView.reloadData()
    }
    
    func bindViewModel() {
        viewModel.currentLevel
            .subscribe(onNext: { [weak self] value in
                print("currentLevel changed \(value)")
                self?.selectLevel(value, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentLevelPercent
            .subscribe(onNext: { [weak self] value in
                print("currentLevelPercent changed \(value)")
                self?.lengthSlider.value = Float(value)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentLevelImage
            .subscribe(onNext: { [weak self ] image in
                self?.currentLevelImage.image = image
            })
            .disposed(by: disposeBag)
        
        viewModel.nextLevelImage
            .subscribe(onNext: { [weak self ] image in
                self?.nextLevelImage.image = image
            })
            .disposed(by: disposeBag)
    }

    func selectLevel(_ level: Int, animated: Bool = true) {
        print("selectLevel \(level)")
        let index = max(0, min(level - 1, viewModel.levelCards.count - 1))
        let indexPath = IndexPath(item: index, section: 0)
        currentLevelCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    
        levelCollectionViewSelectedIndex = index
        
        updateCurrentLevelCollectionViewCell()
    }
    
    func updateCurrentLevelCollectionViewCell() {
        let prevIndex = max(0, levelCollectionViewSelectedIndex - 1)
        let currIndex = levelCollectionViewSelectedIndex
        let nextIndex = min(levelCollectionViewSelectedIndex + 1, viewModel.levelCards.count - 1)
        
        let prevCell = currentLevelCollectionView.cellForItem(at: IndexPath(row: Int(prevIndex), section: 0))
        let currCell = currentLevelCollectionView.cellForItem(at: IndexPath(row: Int(currIndex), section: 0))
        let nextCell = currentLevelCollectionView.cellForItem(at: IndexPath(row: Int(nextIndex), section: 0))
        
        if prevIndex != currIndex { prevCell?.transformToSmall() }
        currCell?.transformToStandard()
        if nextIndex != currIndex { nextCell?.transformToSmall() }
    }
    

}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let currentLevel = viewModel.currentLevel
        return min(currentLevel.value + 1, viewModel.levelCards.count)
        
//        viewModel.levelCards.count //이미지 확인용
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentLevelCell.identifier, for: indexPath) as? CurrentLevelCell else { return UICollectionViewCell() }
        
        cell.setCellConfig(viewModel.levelCards[indexPath.item])

        // 마지막 셀에만 블러 설정
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            cell.setupBlur(alpha: 0.6)
            
        } else {
            cell.removeBlur()
        }
        
        // 현재 보여지는 셀 크기 : Standard
        if levelCollectionViewSelectedIndex == indexPath.item {
            cell.transformToStandard()
        }
        else {
            cell.transformToSmall()
        }
        return cell
    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // 현재 드래그 되는 셀 작아지게
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let currentCell = currentLevelCollectionView.cellForItem(at: IndexPath(row: Int(levelCollectionViewSelectedIndex), section: 0))
        currentCell?.transformToSmall()
    }
    
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      guard scrollView == currentLevelCollectionView else { return }
      
      // pointee == 스크롤 도착 좌표
      targetContentOffset.pointee = scrollView.contentOffset
      
      let flowLayout = currentLevelCollectionView.collectionViewLayout as! CurrentLevelCollectionFlowLayout
      let cellWidthIncludingSpacing = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
      let offset = targetContentOffset.pointee
      let horizontalVelocity = velocity.x
      
      var selectedIndex = levelCollectionViewSelectedIndex
      
      switch horizontalVelocity {
      // 스크롤 시
      case _ where horizontalVelocity > 0 :
          selectedIndex = levelCollectionViewSelectedIndex + 1
      case _ where horizontalVelocity < 0:
          selectedIndex = levelCollectionViewSelectedIndex - 1
          
      // 정지 후에 스크롤 할 떄
      case _ where horizontalVelocity == 0:
          let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
          let roundedIndex = round(index)
          selectedIndex = Int(roundedIndex)
      default:
          print("Incorrect velocity for collection view")
      }
      
      let safeIndex = max(0, min(selectedIndex, viewModel.currentLevel.value))
//      let safeIndex = max(0, min(selectedIndex, viewModel.levelCards.count)) // 이미지 오류 확인용
      let selectedIndexPath = IndexPath(item: safeIndex, section: 0)
      currentLevelCollectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
      
      levelCollectionViewSelectedIndex = selectedIndexPath.item
      
      updateCurrentLevelCollectionViewCell()
  }
    
}

extension UICollectionViewCell {
    // 셀이 작아지게 설정
    func transformToSmall() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    // 기본 셀 크기로 지정
    func transformToStandard() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
        }
    }
}



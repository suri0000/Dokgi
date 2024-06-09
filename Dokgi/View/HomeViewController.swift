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
    let currentPosition = UIImageView()
    let currentPositionImage = UIImageView()
    let nextPosition = UIImageView()
    let nextpositionImage = UIImageView()
    let progressPosition = UIView()
    
    var levelCollectionViewSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        configureUI()
        setupCollectionView()
        bindViewModel()
    }
    
    func setupConstraints() {
        [currentLengthLabel, currentLevelCollectionView, nextLengthLabel, lengthSlider, currentPosition, currentPositionImage, nextPosition, nextpositionImage, progressPosition].forEach {
            view.addSubview($0)
        }
        
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
        
        progressPosition.snp.makeConstraints {
            $0.centerY.equalTo(lengthSlider.snp.centerY)
            $0.leading.equalTo(currentPosition.snp.leading).offset(11)
            $0.width.height.equalTo(16)
        }
        
        currentPosition.snp.makeConstraints {
            $0.width.equalTo(38)
            $0.height.equalTo(41)
            $0.top.equalTo(lengthSlider.snp.bottom).offset(7)
            $0.leading.equalTo(lengthSlider.snp.leading).offset(-17)
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
            $0.top.equalTo(lengthSlider.snp.bottom).offset(7)
            $0.trailing.equalTo(lengthSlider.snp.trailing).offset(17)
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
        
//        lengthProgress.progressViewStyle = .default
//        lengthProgress.progressTintColor = .deepSkyBlue
//        lengthSlider.transform = lengthSlider.transform.scaledBy(x: 1, y: 2)
        if let thumbImage = UIImage(named: "speechBubble1") {
            lengthSlider.setThumbImage(thumbImage, for: .normal)
            lengthSlider.setThumbImage(thumbImage, for: .highlighted)
        }
        lengthSlider.isUserInteractionEnabled = false
        
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
        viewModel.levelCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentLevelCell.identifier, for: indexPath) as? CurrentLevelCell else { return UICollectionViewCell() }
        
        cell.setCellConfig(viewModel.levelCards[indexPath.item])

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
    
    // 페이지 인덱스 구하기
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let x = scrollView.contentOffset.x + scrollView.contentInset.left
//        let flowLayout = currentLengthCollectionView.collectionViewLayout as! CurrentLevelCollectionFlowLayout
//        let cellWidthIncludingSpacing = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
//        let pageIndex = round(x / cellWidthIncludingSpacing)
//        print("scrollViewDidScroll \(scrollView.contentOffset.x) \(x) \(pageIndex) \(cellWidthIncludingSpacing)")
//    }
    
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
      // On swiping
      case _ where horizontalVelocity > 0 :
          selectedIndex = levelCollectionViewSelectedIndex + 1
      case _ where horizontalVelocity < 0:
          selectedIndex = levelCollectionViewSelectedIndex - 1
          
      // On dragging
      case _ where horizontalVelocity == 0:
          let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
          let roundedIndex = round(index)
          selectedIndex = Int(roundedIndex)
      default:
          print("Incorrect velocity for collection view")
      }
      
      let safeIndex = max(0, min(selectedIndex, viewModel.levelCards.count - 1))
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



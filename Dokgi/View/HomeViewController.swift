//
//  HomeViewController.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/4/24.
//

import SnapKit
import UIKit

class HomeViewController: UIViewController {
    let viewModel = HomeViewModel()
    
    let currentLengthLabel = UILabel()
    let currentLengthCollectionView: UICollectionView = {
        let layout = CurrentLevelCollectionFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(CurrentLengthCell.self, forCellWithReuseIdentifier: CurrentLengthCell.identifier)
        view.isPagingEnabled = false
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
    
    
    let test: [String] = ["안녕하세요", "안녕하세요. 누구입니다.", "hello", "안녕하세요", "안녕하세요"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLengthCollectionView.dataSource = self
        currentLengthCollectionView.delegate = self
        setupConstraints()
        configureUI()
        
        let totalLength = viewModel.getCurrentLength(from: test)
        print("총 글자 수: \(totalLength)")
        let currentLevel = viewModel.getCurrentLevel(for: totalLength)
        print("현재레벨: \(currentLevel)")
        
        
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

        // 현재 보여지는 셀 크기 : Standard
        if viewModel.currentSelectedIndex == indexPath.row {
            cell.transformToStandard()
        }
        return cell
    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // 현재 드래그 되는 셀 작아지게
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let totalLength = viewModel.getCurrentLength(from: test)
        let currentIndex = viewModel.getCardIndex(forTotalLength: totalLength)
        let currentCell = currentLengthCollectionView.cellForItem(at: IndexPath(row: Int(currentIndex), section: 0))

        currentCell?.transformToSmall()
        
    }
    
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

      
      guard scrollView == currentLengthCollectionView else {
          return
      }
      
      targetContentOffset.pointee = scrollView.contentOffset
      
      let flowLayout = currentLengthCollectionView.collectionViewLayout as! CurrentLevelCollectionFlowLayout
      let cellWidthIncludingSpacing = flowLayout.itemSize.width + flowLayout.minimumLineSpacing
      let offset = targetContentOffset.pointee
      let horizontalVelocity = velocity.x
      
      var selectedIndex = viewModel.currentSelectedIndex
      
      switch horizontalVelocity {
      // On swiping
      case _ where horizontalVelocity > 0 :
          selectedIndex = viewModel.currentSelectedIndex + 1
      case _ where horizontalVelocity < 0:
          selectedIndex = viewModel.currentSelectedIndex - 1
          
      // On dragging
      case _ where horizontalVelocity == 0:
          let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
          let roundedIndex = round(index)
          
          selectedIndex = Int(roundedIndex)
      default:
          print("Incorrect velocity for collection view")
      }
      
      let safeIndex = max(0, min(selectedIndex, viewModel.data.count - 1))
      let selectedIndexPath = IndexPath(row: safeIndex, section: 0)
      
      flowLayout.collectionView!.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
      
      let previousSelectedIndex = IndexPath(row: Int(viewModel.currentSelectedIndex), section: 0)
      let previousSelectedCell = currentLengthCollectionView.cellForItem(at: previousSelectedIndex)
      let nextSelectedCell = currentLengthCollectionView.cellForItem(at: selectedIndexPath)
      
      viewModel.currentSelectedIndex = selectedIndexPath.row
      previousSelectedCell?.transformToSmall()
      nextSelectedCell?.transformToStandard()
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



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
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let settingButton = UIButton()
    let currentLengthLabel = UILabel()
    let currentLevelCollectionView: UICollectionView = {
        let layout = CurrentLevelCollectionFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(CurrentLevelCell.self, forCellWithReuseIdentifier: CurrentLevelCell.identifier)
        view.decelerationRate = .fast
        return view
    }()
    
    let nextLengthLabel = UILabel()
    let lengthSlider = UISlider()
    let currentLevelBubble = UIImageView()
    let currentLevelImage = UIImageView()
    let nextLevelBubble = UIImageView()
    let nextLevelImage = UIImageView()
    let blurEffect = UIBlurEffect(style: .regular)
    
    let todayVersesLabel = UILabel()
    let todayVersesColletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.register(TodayVersesCell.self, forCellWithReuseIdentifier: TodayVersesCell.identifier)
        return view
    }()
    
    lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
            
    var levelCollectionViewSelectedIndex = 0
    var nowPage: Int = 0 {
        didSet {
            self.indicatorDots.currentPage = nowPage
        }
    }
    
    var indicatorDots = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        configureUI()
        setupCollectionView()
        bindViewModel()
//        configureNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentLevelBubble.snp.makeConstraints {
            $0.centerX.equalTo(self.lengthSlider.snp.leading).offset(self.lengthSlider.frame.width * CGFloat(lengthSlider.value))
            print("lengthSlider.value \(lengthSlider.value), lengthSlider.frame.width \(lengthSlider.frame.width)")
        }
        bannerTimer()
    }
    
    func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [settingButton,
         currentLengthLabel,
         currentLevelCollectionView,
         nextLengthLabel,
         lengthSlider,
         currentLevelBubble,
         nextLevelBubble,
         todayVersesLabel,
         todayVersesColletionView,
        indicatorDots].forEach {
            contentView.addSubview($0)
        }
        
        currentLevelBubble.addSubview(currentLevelImage)
        [nextLevelImage, blurEffectView].forEach {
            nextLevelBubble.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        settingButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(57)
            $0.trailing.equalToSuperview().offset(-24)
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
            $0.horizontalEdges.equalToSuperview().inset(35)
        }
        
        lengthSlider.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(35)
            $0.top.equalTo(nextLengthLabel.snp.bottom).offset(18)
        }
        
        currentLevelBubble.snp.makeConstraints {
            $0.width.equalTo(38)
            $0.height.equalTo(41)
            $0.top.equalTo(lengthSlider.snp.bottom)
            $0.centerX.equalTo(lengthSlider.snp.trailing).multipliedBy(1)
        }
        
        currentLevelImage.snp.makeConstraints {
            $0.width.height.equalTo(28)
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
            $0.width.height.equalTo(28)
            $0.top.equalTo(nextLevelBubble.snp.top).offset(8)
            $0.centerX.equalTo(nextLevelBubble.snp.centerX)
        }
        
        blurEffectView.snp.makeConstraints {
            $0.width.height.equalTo(36)
            $0.top.equalTo(nextLevelBubble.snp.top).offset(4)
            $0.centerX.equalTo(nextLevelBubble.snp.centerX)
        }
        
        todayVersesLabel.snp.makeConstraints {
            $0.top.equalTo(currentLevelBubble.snp.bottom).offset(53)
            $0.leading.equalTo(currentLengthLabel.snp.leading)
        }
        
        todayVersesColletionView.snp.makeConstraints {
            $0.top.equalTo(todayVersesLabel.snp.bottom).offset(14)
            $0.bottom.equalToSuperview().offset(-63)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(158)
        }
        
        indicatorDots.snp.makeConstraints {
            $0.centerX.equalTo(todayVersesColletionView.snp.centerX)
            $0.bottom.equalTo(todayVersesColletionView.snp.bottom).offset(-8)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        settingButton.setImage(.setting, for: .normal)
        settingButton.tintColor = .charcoalBlue
        settingButton.addTarget(self, action: #selector(didTapSetting), for: .touchUpInside)
        currentLengthLabel.text = "현재 구절 길이"
        currentLengthLabel.font = Pretendard.semibold.dynamicFont(style: .title3)
        nextLengthLabel.text = "다음 레벨까지 \(Int(Float(viewModel.currentLevelPercent.value) * 100)) % 달성했습니다!"
        nextLengthLabel.font = Pretendard.regular.dynamicFont(style: .subheadline)
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
        nextLevelBubble.layer.masksToBounds = true
        blurEffectView.frame = nextLevelImage.bounds
        blurEffectView.alpha = 0.7
        blurEffectView.backgroundColor = .white.withAlphaComponent(0.6)
        blurEffectView.layer.cornerRadius = 18
        blurEffectView.layer.masksToBounds = true
        nextLevelImage.backgroundColor = .clear
        nextLevelImage.image = UIImage(named: "goni")
        nextLevelImage.contentMode = .scaleAspectFit
        nextLevelImage.layer.masksToBounds = true
        todayVersesLabel.text = "오늘의 구절"
        todayVersesLabel.font = Pretendard.semibold.dynamicFont(style: .title3)
        todayVersesColletionView.layer.cornerRadius = 10
        indicatorDots.pageIndicatorTintColor = UIColor(.dotGray).withAlphaComponent(0.3)
        indicatorDots.currentPageIndicatorTintColor = UIColor(.dotBlue)
        indicatorDots.numberOfPages = 5
    }
    
    func setupCollectionView() {
        currentLevelCollectionView.dataSource = self
        currentLevelCollectionView.delegate = self
        todayVersesColletionView.dataSource = self
        todayVersesColletionView.delegate = self
        currentLevelCollectionView.layoutIfNeeded() // 레이아웃 새로고침
        currentLevelCollectionView.reloadData()
    }
    
    func bindViewModel() {
        
        // 현재 레벨
        viewModel.currentLevel
            .subscribe(onNext: { [ weak self ] value in
                print("currentLevel changed \(value)")
                self?.selectLevel(value, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 현재 레벨의 달성도(퍼센트)
        viewModel.currentLevelPercent
            .subscribe(onNext: { [ weak self ] value in
                guard let self else { return }
                print("currentLevelPercent changed \(value)")
                self.lengthSlider.value = Float(value)
                self.currentLevelBubble.snp.remakeConstraints {
                    $0.width.equalTo(38)
                    $0.height.equalTo(41)
                    $0.top.equalTo(self.lengthSlider.snp.bottom)
                }
            })
            .disposed(by: disposeBag)
        
        // 현재 레벨 이미지
        viewModel.currentLevelImage
            .subscribe(onNext: { [ weak self ] image in
                self?.currentLevelImage.image = image
            })
            .disposed(by: disposeBag)
        
        // 다음 레벨 이미지
        viewModel.nextLevelImage
            .subscribe(onNext: { [ weak self ] image in
                self?.nextLevelImage.image = image
            })
            .disposed(by: disposeBag)
        
        // 구절 랜덤 5개
        viewModel.randomVerses
            .subscribe(onNext: { [weak self] _ in
                self?.todayVersesColletionView.reloadData()
            })
            .disposed(by: viewModel.disposeBag)
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
    
    // 오늘의 구절 자동 넘기기
    func bannerTimer() {
        let _: Timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (Timer) in
            self.bannerMove()
        }
    }
    // 배너 움직이는 매서드
    func bannerMove() {
        // 현재페이지가 마지막 페이지일 경우
        if nowPage == 4 {
        // 맨 처음 페이지로 돌아감
            todayVersesColletionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
            nowPage = 0
            
            return
        } else {
            // 다음 페이지로 전환
            nowPage += 1
            todayVersesColletionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
        }
    }
    
    // 홈 상단에 설정 페이지 이동

    @objc func didTapSetting() {
        let settingVC = SettingViewController()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == currentLevelCollectionView {
            let currentLevel = viewModel.currentLevel
            return min(currentLevel.value + 1, viewModel.levelCards.count)
            //        viewModel.levelCards.count //이미지 확인용
        } else { return 5 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == currentLevelCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentLevelCell.identifier, for: indexPath) as? CurrentLevelCell else { return UICollectionViewCell() }
            
            cell.setCellConfig(viewModel.levelCards[indexPath.item])
            
            // 마지막 셀에만 블러 설정
            if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                cell.blurEffectView.isHidden = false
            } else {
                cell.blurEffectView.isHidden = true
            }
            
            if indexPath.item + 1 == viewModel.currentLevel.value {
                let length = viewModel.getVerseLength(from: viewModel.verses.value)
                cell.lengthLabel.text = MetricUtil.formatLength(length: length)
            }
            
            // 현재 보여지는 셀 크기 : Standard
            if levelCollectionViewSelectedIndex == indexPath.item {
                cell.transformToStandard()
            }
            else {
                cell.transformToSmall()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayVersesCell.identifier, for: indexPath) as? TodayVersesCell else { return UICollectionViewCell() }
            
            let randomVerses = viewModel.randomVerses.value
            if indexPath.item < randomVerses.count {
                cell.verse.text = randomVerses[indexPath.item]
            }
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 컬렉션 뷰의 크기에 맞게 셀 크기 설정
        if collectionView == todayVersesColletionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: 300, height: 164)
        }
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
          case _ where horizontalVelocity > 0:
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



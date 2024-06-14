//
//  LibrarySearchViewController.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/4/24.
//

import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class LibrarySearchViewController: UIViewController {
    
    private let libraryLabel = UILabel()
    private let searchBar = UISearchBar()
    private let sortButton = UIButton()
    private let sortButtonImageView = UIImageView()
    private let sortButtonTitleLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    private let sortMenuView = UIView()
    private let latestFirstButton = UIButton()
    private let oldestFirstButton = UIButton()
    private let latestFirstcheckImageView = UIImageView()
    private let oldestFirstcheckImageView = UIImageView()
    private let latestTextLabel = UILabel()
    private let oldestTextLabel = UILabel()
    
    private var isLatestFirst: Bool = true
    private var isOldestFirst: Bool = false
    
    private let emptyMessageLabel = UILabel()
    
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
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
        setSearchBar()
        setSortMenuView()
        setFloatingButton()
        
        CoreDataManager.shared.bookData.subscribe(with: self) { (self, bookData) in
            self.libraryCollectionView.reloadData()
        }.disposed(by: disposeBag)
        
        self.searchBar.rx.text.debounce(.milliseconds(500), scheduler: MainScheduler.instance).subscribe(with: self) { (self, text) in
            guard let text = text else { return }
            if text.isEmpty == true {
                CoreDataManager.shared.readData()
            } else {
                CoreDataManager.shared.readData()
                CoreDataManager.shared.bookData.accept(CoreDataManager.shared.bookData.value.filter { $0.name.contains(text) })
            }
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        libraryLabel.text = "서재"
        libraryLabel.font = Pretendard.bold.dynamicFont(style: .title1)
        
        sortButton.backgroundColor = .lightSkyBlue
        sortButton.layer.cornerRadius = 15
        sortButton.clipsToBounds = true
        sortButton.addTarget(self, action: #selector(showOrHideSortMenuView), for: .touchUpInside)
        
        sortButtonImageView.image = .down
        sortButtonTitleLabel.text = "최신순"
        sortButtonTitleLabel.font = Pretendard.regular.dynamicFont(style: .footnote)
        sortButtonTitleLabel.textColor = .charcoalBlue
        
        sortMenuView.backgroundColor = .white
        sortMenuView.layer.cornerRadius = 10
        
        sortMenuView.layer.shadowColor = UIColor.black.cgColor
        sortMenuView.layer.shadowOpacity = 0.5
        sortMenuView.layer.shadowOffset = CGSize(width: 1, height: 1)
        sortMenuView.layer.shadowRadius = 2
        
        latestFirstButton.backgroundColor = .white
        latestFirstButton.addTarget(self, action: #selector(tappedLatestFirst), for: .touchUpInside)
        latestFirstButton.layer.cornerRadius = 10
        
        oldestFirstButton.backgroundColor = .white
        oldestFirstButton.addTarget(self, action: #selector(tappedOldestFirst), for: .touchUpInside)
        oldestFirstButton.layer.cornerRadius = 10
        
        latestTextLabel.text = "최신순"
        latestTextLabel.font = Pretendard.regular.dynamicFont(style: .footnote)
        latestTextLabel.textColor = .charcoalBlue
        
        oldestTextLabel.text = "오래된순"
        oldestTextLabel.font = Pretendard.regular.dynamicFont(style: .footnote)
        oldestTextLabel.textColor = .charcoalBlue
        
        latestFirstcheckImageView.image = .check
        oldestFirstcheckImageView.image = .check // 체크 고민
        
        emptyMessageLabel.text = "기록한 책이 없어요\n구절을 등록해 보세요"
        emptyMessageLabel.font = Pretendard.regular.dynamicFont(style: .subheadline)
        emptyMessageLabel.isHidden = true
        emptyMessageLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: emptyMessageLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        emptyMessageLabel.attributedText = attrString
    }
    
    private func setConstraints() {
        [libraryLabel, searchBar, sortButton, sortMenuView, libraryCollectionView, emptyMessageLabel].forEach {
            view.addSubview($0)
        }
        
        libraryLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.left.equalToSuperview().inset(20)
            $0.height.equalTo(41)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(libraryLabel.snp.bottom)
            $0.left.trailing.equalToSuperview().inset(10)
        }
        
        sortButton.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(29)
            $0.width.greaterThanOrEqualTo(87)
        }
        
        [sortButtonImageView, sortButtonTitleLabel].forEach {
            sortButton.addSubview($0)
        }
        
        sortButtonImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.width.height.equalTo(18)
        }
        
        sortButtonTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(sortButtonImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        // 정렬 버튼 클릭 시 - 정렬 옵션 메뉴
        sortMenuView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom).offset(3)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        // 정렬 옵션 메뉴(최신순 버튼, 오래된순 버튼)
        [latestFirstButton, oldestFirstButton].forEach {
            sortMenuView.addSubview($0)
        }
        
        latestFirstButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(oldestFirstButton.snp.top)
        }
        
        oldestFirstButton.snp.makeConstraints {
            $0.top.equalTo(latestFirstButton.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        // 최신순 버튼
        [latestFirstcheckImageView, latestTextLabel].forEach {
            latestFirstButton.addSubview($0)
        }
        
        latestFirstcheckImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
            $0.height.width.equalTo(10)
        }
        
        latestTextLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(latestFirstcheckImageView.snp.trailing).offset(6)
        }
        
        //오래된순
        [oldestFirstcheckImageView, oldestTextLabel].forEach {
            oldestFirstButton.addSubview($0)
        }
        
        oldestFirstcheckImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
            $0.height.width.equalTo(10)
        }
        
        oldestTextLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(latestFirstcheckImageView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(25)
        }
        
        libraryCollectionView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom).offset(20)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        emptyMessageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    //MARK: - searchBar
    private func setSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.setPositionAdjustment(UIOffset(horizontal: 8, vertical: 0), for: .search)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -8, vertical: 0), for: .clear)
        searchBar.placeholder = "기록된 책을 검색해보세요"
        searchBar.searchTextField.borderStyle = .line
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.layer.borderColor = UIColor(resource: .searchBarLightGray).cgColor
        searchBar.searchTextField.layer.backgroundColor = UIColor.white.cgColor
        searchBar.searchTextField.layer.cornerRadius = 17
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.font = Pretendard.regular.dynamicFont(style: .caption2)
    }
    // MARK: - 설정버튼
    private func setSortMenuView() {
        sortMenuView.isHidden = true
        
        latestFirstcheckImageView.isHidden = false
        oldestFirstcheckImageView.isHidden = true
    }
    
    @objc private func showOrHideSortMenuView() {
        if sortMenuView.isHidden {
            sortMenuView.isHidden = false
            view.bringSubviewToFront(sortMenuView)
        } else {
            sortMenuView.isHidden = true
        }
    }
    
    @objc private func tappedLatestFirst() {
        sortButtonTitleLabel.text = "최신순"
        
        latestFirstcheckImageView.isHidden = false
        oldestFirstcheckImageView.isHidden = true
        
        sortMenuView.isHidden = true
    }
    
    @objc private func tappedOldestFirst() {
        sortButtonTitleLabel.text = "오래된순"
        
        latestFirstcheckImageView.isHidden = true
        oldestFirstcheckImageView.isHidden = false
        
        sortMenuView.isHidden = true
    }
}
//MARK: -CollectionView
extension LibrarySearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let cellCount = CoreDataManager.shared.bookData.value.count
        
        emptyMessageLabel.isHidden = cellCount > 0
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCell.identifier, for: indexPath) as? LibraryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.authorNameLabel.text = CoreDataManager.shared.bookData.value[indexPath.row].author
        cell.bookNameLabel.text = CoreDataManager.shared.bookData.value[indexPath.row].name
        if let url = URL(string: CoreDataManager.shared.bookData.value[indexPath.row].image) {
            cell.bookImageView.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        BookDetailViewModel.shared.bookInfo = CoreDataManager.shared.bookData.value[indexPath.row]
        let bookDetailViewController = BookDetailViewController()
        self.navigationController?.pushViewController(bookDetailViewController, animated: true)
    }
}

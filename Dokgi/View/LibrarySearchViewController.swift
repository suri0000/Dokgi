//
//  LibrarySearchViewController.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/4/24.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class LibrarySearchViewController: UIViewController {
    let disposeBag = DisposeBag()
    let libraryLabel = UILabel()
    let searchBar = UISearchBar()
    let sortButton = UIButton()
    let sortButtonImageView = UIImageView()
    let sortButtonTitleLabel = UILabel()
    
    let sortMenuView = UIView()
    let latestFirstButton = UIButton()
    let oldestFirstButton = UIButton()
    let latestFirstcheckImageView = UIImageView()
    let oldestFirstcheckImageView = UIImageView()
    let latestTextLabel = UILabel()
    let oldestTextLabel = UILabel()
    
    var isLatestFirst: Bool = true
    var isOldestFirst: Bool = false
    
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
        CoreDataManager.shared.bookData.subscribe(with: self){ (self, bookData) in
            self.libraryCollectionView.reloadData()
        }.disposed(by: disposeBag)
        
        self.searchBar.rx.text.debounce(.seconds(1), scheduler: MainScheduler.instance).subscribe(with: self) {(self, text) in
            guard let text = text else {return}
            if text.isEmpty == true {
                CoreDataManager.shared.getBookData()
                print("dd")
            }else {
                CoreDataManager.shared.getBookData()
                CoreDataManager.shared.bookData.accept(CoreDataManager.shared.bookData.value.filter{$0.name.contains(text)})
                print("ss")
            }
        }.disposed(by: disposeBag)
    }
    
    func setUI() {
        view.backgroundColor = .white
        
        libraryLabel.text = "서재"
        libraryLabel.font = Pretendard.bold.dynamicFont(style: .title1)
        libraryLabel.textColor = .black
        
        sortButton.backgroundColor = UIColor(named: "LightSkyBlue")
        sortButton.layer.cornerRadius = 15
        sortButton.clipsToBounds = true
        sortButton.addTarget(self, action: #selector(showSortMenuView), for: .touchUpInside)
        
        sortButtonImageView.image = UIImage(named: "down")
        
        sortButtonTitleLabel.text = "최신순"
        sortButtonTitleLabel.font = Pretendard.regular.dynamicFont(style: .footnote)
        sortButtonTitleLabel.textColor = UIColor(named: "CharcoalBlue")
        
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
        latestTextLabel.textColor = UIColor(named: "CharcoalBlue")
        
        oldestTextLabel.text = "오래된순"
        oldestTextLabel.font = Pretendard.regular.dynamicFont(style: .footnote)
        oldestTextLabel.textColor = UIColor(named: "CharcoalBlue")
        
        latestFirstcheckImageView.image = UIImage(named: "check")
        oldestFirstcheckImageView.image = UIImage(named: "check")
    }
    
    func setConstraints() {
        [libraryLabel, searchBar, sortButton, sortMenuView, libraryCollectionView].forEach {
            view.addSubview($0)
        }
        
        libraryLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.left.equalToSuperview().inset(20)
            $0.height.equalTo(41)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(libraryLabel.snp.bottom)
            $0.left.right.equalToSuperview().inset(10)
        }
        
        sortButton.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.right.equalToSuperview().inset(20)
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
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(60)
            $0.width.equalTo(113)
        }
        
        // 정렬 옵션 메뉴(최신순 버튼, 오래된순 버튼)
        [latestFirstButton, oldestFirstButton].forEach {
            sortMenuView.addSubview($0)
        }
        
        latestFirstButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(oldestFirstButton.snp.top)
            $0.height.equalTo(30)
        }
        
        oldestFirstButton.snp.makeConstraints {
            $0.top.equalTo(latestFirstButton.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
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
        }
        
        libraryCollectionView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom).offset(20)
            $0.bottom.left.right.equalToSuperview().inset(0)
        }
    }
    //MARK: - searchBar
    func setSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "기록된 책을 검색해보세요"
        searchBar.searchTextField.borderStyle = .line
        searchBar.searchTextField.layer.borderWidth = 1
        if let SearchBarLightGray = UIColor(named: "SearchBarLightGray")?.cgColor {
            searchBar.searchTextField.layer.borderColor = SearchBarLightGray
        }
        searchBar.searchTextField.layer.backgroundColor = UIColor.white.cgColor
        searchBar.searchTextField.layer.cornerRadius = 20
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.font = Pretendard.regular.dynamicFont(style: .caption2)
    }
    // MARK: - 설정버튼
    func setSortMenuView() {
        sortMenuView.isHidden = true
        
        latestFirstcheckImageView.isHidden = false
        oldestFirstcheckImageView.isHidden = true
    }
    
    @objc func showSortMenuView() {
        sortMenuView.isHidden = false
        view.bringSubviewToFront(sortMenuView)
    }
    
    @objc func tappedLatestFirst() {
        sortButtonTitleLabel.text = "최신순"
        
        latestFirstcheckImageView.isHidden = false
        oldestFirstcheckImageView.isHidden = true
        
        sortMenuView.isHidden = true
    }
    
    @objc func tappedOldestFirst() {
        sortButtonTitleLabel.text = "오래된순"
        
        latestFirstcheckImageView.isHidden = true
        oldestFirstcheckImageView.isHidden = false
        
        sortMenuView.isHidden = true
    }
}
//MARK: -CollectionView
extension LibrarySearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoreDataManager.shared.bookData.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCollectionViewCell.identifier, for: indexPath) as? LibraryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.authorNameLabel.text = CoreDataManager.shared.bookData.value[indexPath.row].author
        cell.bookNameLabel.text = CoreDataManager.shared.bookData.value[indexPath.row].name
        return cell
    }
}

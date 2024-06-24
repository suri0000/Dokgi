//
//  LibraryView.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/21/24.
//
import SnapKit
import Then
import UIKit

class LibraryView: UIView {
    
    private let libraryLabel = UILabel().then {
        $0.text = "서재"
        $0.font = Pretendard.bold.dynamicFont(style: .title1)
    }
    
    let searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.setPositionAdjustment(UIOffset(horizontal: 8, vertical: 0), for: .search)
        $0.setPositionAdjustment(UIOffset(horizontal: -8, vertical: 0), for: .clear)
        
        $0.placeholder = "기록된 책을 검색해보세요"
        $0.searchTextField.borderStyle = .line
        $0.searchTextField.layer.borderWidth = 1
        $0.searchTextField.layer.borderColor = UIColor(resource: .searchBarLightGray).cgColor
        $0.searchTextField.layer.backgroundColor = UIColor.white.cgColor
        $0.searchTextField.layer.cornerRadius = 17
        $0.searchTextField.layer.masksToBounds = true
        $0.searchTextField.font = Pretendard.regular.dynamicFont(style: .footnote)
    }
    
    let sortButton = UIButton().then {
        $0.backgroundColor = .lightSkyBlue
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    private let sortButtonImageView = UIImageView().then {
        $0.image = .down
    }
    
    let sortButtonTitleLabel = UILabel().then {
        $0.text = "최신순"
        $0.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.textColor = .charcoalBlue
    }
    
    let sortMenuView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 2
        $0.isHidden = true
    }
    
    let latestFirstButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    let oldestFirstButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    let latestFirstcheckImageView = UIImageView().then {
        $0.image = .check
        $0.isHidden = false
    }
    
    let oldestFirstcheckImageView = UIImageView().then {
        $0.image = .check
        $0.isHidden = true
    }
    
    private let latestTextLabel = UILabel().then {
        $0.text = "최신순"
        $0.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.textColor = .charcoalBlue
    }
    
    private let oldestTextLabel = UILabel().then {
        $0.text = "오래된순"
        $0.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.textColor = .charcoalBlue
    }
    
    let libraryCollectionView = LibraryCollectionView()
    
    let emptyMessageLabel = UILabel().then {
        $0.text = "기록한 책이 없어요\n구절을 등록해 보세요"
        $0.font = Pretendard.regular.dynamicFont(style: .subheadline)
        $0.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: $0.text!)
        let passageStyle = NSMutableParagraphStyle()
        passageStyle.alignment = .center
        passageStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: passageStyle, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        [libraryLabel, searchBar, sortButton, sortMenuView, libraryCollectionView, emptyMessageLabel].forEach {
            addSubview($0)
        }
        
        libraryLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(41)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(libraryLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(10)
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
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
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
}

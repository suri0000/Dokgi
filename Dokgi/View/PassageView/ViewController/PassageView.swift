//
//  PassageView.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/21/24.
//
import Then
import UIKit

class PassageView: UIView {
    
    let passageLabel = UILabel().then {
        $0.text = "구절"
        $0.font = Pretendard.bold.dynamicFont(style: .title1)
    }
    
    let selectionButton = UIButton().then {
        $0.backgroundColor = .white
        $0.sizeToFit()
    }
    
    let selectionButtonImageView = UIImageView().then {
        $0.image = .filter
    }
    
    let selectionButtonLabel = UILabel().then {
        $0.text = "선택"
        $0.font = Pretendard.semibold.dynamicFont(style: .headline)
        $0.textColor = .charcoalBlue
    }
    
    let doneButton = UIButton().then {
        $0.titleLabel?.font = Pretendard.semibold.dynamicFont(style: .headline)
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.brightRed, for: .normal)
        $0.isHidden = true
    }
    
    let searchBar = UISearchBar().then{
        $0.searchBarStyle = .minimal
        $0.setPositionAdjustment(UIOffset(horizontal: 8, vertical: 0), for: .search)
        $0.setPositionAdjustment(UIOffset(horizontal: -8, vertical: 0), for: .clear)
        
        $0.placeholder = "기록한 구절을 검색해보세요"
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
    
    let sortButtonImageView = UIImageView().then {
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
        $0.layer.shadowOpacity = 0.3
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
    
    let latestTextLabel = UILabel().then {
        $0.text = "최신순"
        $0.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.textColor = .charcoalBlue
    }
    
    let oldestTextLabel = UILabel().then {
        $0.text = "오래된순"
        $0.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.textColor = .charcoalBlue
    }
    
    let passageCollectionView = PassageCollectionVC().passageCollectionView
    
    let emptyMessageLabel = UILabel().then {
        $0.text = "기록한 구절이 없어요\n구절을 등록해 보세요"
        $0.font = Pretendard.regular.dynamicFont(style: .subheadline)
        $0.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
        $0.isHidden = true
    }
    
    private func setConstraints() {
        [passageLabel, selectionButton, doneButton, searchBar, sortButton, sortMenuView, passageCollectionView, emptyMessageLabel].forEach { addSubview($0)
        }
        
        passageLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(41)
        }
        
        //선택 버튼
        selectionButton.snp.makeConstraints {
            $0.centerY.equalTo(passageLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        [selectionButtonImageView, selectionButtonLabel].forEach {
            selectionButton.addSubview($0)
        }
        
        selectionButtonImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
            $0.width.equalTo(14.67)
            $0.height.equalTo(13.2)
        }
        
        selectionButtonLabel.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.leading.equalTo(selectionButtonImageView.snp.trailing).offset(5)
        }
        
        doneButton.snp.makeConstraints {
            $0.centerY.equalTo(passageLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(passageLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        //정렬 버튼
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
        
        passageCollectionView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom).offset(14)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        emptyMessageLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}

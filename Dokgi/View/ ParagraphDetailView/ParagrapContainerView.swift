//
//  ParagrapScrollView.swift
//  Dokgi
//
//  Created by 송정훈 on 6/7/24.
//

import SnapKit
import Then
import UIKit

class ParagrapContainerView: UIView {
    let textView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.backgroundColor = UIColor(named: "LavenderBlue")
    }
    
    let paragrapTextLbl = UILabel().then {
        $0.text = "뭘 쓰고 싶었는지 전혀 기억이 나지 않았다. "
        $0.textAlignment = .left
        $0.font = Pretendard.regular.dynamicFont(style: .callout)
        $0.numberOfLines = 20
    }
    
    let keywordStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 7
    }
    
    let keywordLabel = UILabel().then {
        $0.text = "키워드"
        $0.font = Pretendard.semibold.dynamicFont(style: .body)
    }
    
    lazy var keywordCollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: createBasicListLayout()).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = false
        $0.isScrollEnabled = true
        $0.snp.makeConstraints {
            $0.height.equalTo(42)
        }
    }
    
    let writeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    
    let writeDateTitle = UILabel().then {
        $0.text = "기록날짜"
        $0.font = Pretendard.semibold.dynamicFont(style: .body)
    }
    
    let writeDateDay = UILabel().then {
        $0.text = "2024.6.9"
        $0.font = Pretendard.regular.dynamicFont(style: .body)
        $0.textColor = UIColor(named: "AlarmSettingText")
    }
    
    let pageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    
    let pageTitle = UILabel().then {
        $0.text = "페이지"
        $0.font = Pretendard.semibold.dynamicFont(style: .body)
    }
    
    let pageWriteLbl = UILabel().then {
        $0.text = "2000"
        $0.font = Pretendard.regular.dynamicFont(style: .body)
        $0.textColor = UIColor(named: "AlarmSettingText")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    let paragrapTextField = UITextView().then {
        $0.font = Pretendard.regular.dynamicFont(style: .callout)
        $0.backgroundColor = .clear
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.isScrollEnabled = true
        $0.textContainer.lineBreakMode = .byWordWrapping
        $0.isHidden = true
    }
    
    let keywordTextField = UITextField().then {
        $0.font = Pretendard.regular.dynamicFont(style: .callout)
        $0.textColor = UIColor(named: "TextFieldGray")
        $0.placeholder = "키워드를 입력해 주세요"
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "KeywordBorder")?.cgColor
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 22.0, height: 0.0))
        $0.leftViewMode = .always
        $0.isHidden = true
        $0.snp.makeConstraints {
            $0.height.equalTo(33)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    func setupLayout() {
        addSubview(textView)
        textView.addSubview(paragrapTextLbl)
        textView.addSubview(paragrapTextField)
        addSubview(keywordStackView)
        [keywordLabel, keywordTextField,keywordCollectionView].forEach {
            keywordStackView.addArrangedSubview($0)
        }
        addSubview(writeStackView)
        [writeDateTitle, writeDateDay].forEach {
            writeStackView.addArrangedSubview($0)
        }
        addSubview(pageStackView)
        [pageTitle, pageWriteLbl].forEach {
            pageStackView.addArrangedSubview($0)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(256)
        }
        
        paragrapTextLbl.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(15)
        }
        
        paragrapTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(15)
        }
        
        keywordStackView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        writeStackView.snp.makeConstraints {
            $0.top.equalTo(keywordStackView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        pageStackView.snp.makeConstraints {
            $0.top.equalTo(writeStackView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(291)
        }
    }
    
    func createBasicListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(34))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(32))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(7)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 7
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func editLayout() {
        paragrapTextField.becomeFirstResponder()
        paragrapTextField.isHidden = false
        paragrapTextField.text = paragrapTextLbl.text
        paragrapTextLbl.isHidden = true
        keywordTextField.isHidden = false
    }
    
    func editCompleteLayout() {
        paragrapTextLbl.isHidden = false
        paragrapTextLbl.text = "keywordTextField.text"
        paragrapTextField.isHidden = true
        keywordTextField.isHidden = true
    }
    
    func paragrapTextLimit(_ str : String) {
        if str.count > 200 {
            let index = str.index(str.startIndex, offsetBy: 200)
            self.paragrapTextField.text = String(str[..<index])
        }
    }
    
    func keywordTextLimit(_ str : String) {
        if str.count > 20 {
            let index = str.index(str.startIndex, offsetBy: 20)
            self.keywordTextField.text = String(str[..<index])
        }
    }
}

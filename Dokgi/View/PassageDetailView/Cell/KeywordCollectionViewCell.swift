//
//  KeywordCollectionViewCell.swift
//  Dokgi
//
//  Created by 송정훈 on 6/9/24.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class KeywordCollectionViewCell: UICollectionViewCell {
    static let identifier = "KeywordCollectionViewCell"
    private var disposeBag = DisposeBag()
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 3
    }
    
    private let keywordLabel = UILabel().then {
        $0.font = Pretendard.regular.dynamicFont(style: .callout)
        $0.textColor = .brightBlue
    }
    
    private let xButton = UIButton().then {
        $0.setImage(.deleteKeyword, for: .normal)
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func setContentView() {
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.keywordBorderBlue.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 14
        self.clipsToBounds = true
    }
    
    // MARK: - Layout
    private func setupLayout() {
        addSubview(stackView)
        [keywordLabel, xButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview().inset(5)
        }
    }
}

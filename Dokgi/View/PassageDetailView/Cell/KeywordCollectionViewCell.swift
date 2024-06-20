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
    var disposeBag = DisposeBag()
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 3
    }
    
    let keywordLbl = UILabel().then {
        $0.text = "dddd"
        $0.font = Pretendard.regular.dynamicFont(style: .callout)
        $0.textColor = UIColor(named: "BrightBlue")
    }
    
    let xBtn = UIButton().then {
        $0.setImage(UIImage(named: "deleteKeyword"), for: .normal)
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.lightSkyBlue.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 14
        self.clipsToBounds = true
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    func setupLayout() {
        addSubview(stackView)
        [keywordLbl, xBtn].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview().inset(5)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

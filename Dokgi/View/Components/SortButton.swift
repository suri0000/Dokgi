//
//  SortButton.swift
//  Dokgi
//
//  Created by 예슬 on 6/21/24.
//

import SnapKit
import Then
import UIKit

class SortButton: UIButton {
    
    private let sortButtonImageView = UIImageView().then {
        $0.image = .down
    }
    
    let sortButtonTitleLabel = UILabel().then {
        $0.text = "최신순"
        $0.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.textColor = .charcoalBlue
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupButton() {
        self.backgroundColor = .lightSkyBlue
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }
    
    private func setLayout() {
        [sortButtonImageView, sortButtonTitleLabel].forEach {
            self.addSubview($0)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.width.greaterThanOrEqualTo(100)
        }
        
        sortButtonImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
        }
        
        sortButtonTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(sortButtonImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(15)
        }
    }
}

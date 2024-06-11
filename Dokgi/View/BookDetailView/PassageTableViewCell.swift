//
//  PassageTableViewCell.swift
//  Dokgi
//
//  Created by 예슬 on 6/11/24.
//

import SnapKit
import Then
import UIKit

class PassageTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: PassageTableViewCell.self)
    
    private let circleView = UIView().then {
        $0.backgroundColor = .charcoalBlue
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .timeLineGray
    }
    
    private let pageLabel = UILabel().then {
        let unit = "P"
        $0.font = Pretendard.regular.dynamicFont(style: .caption1)
        $0.text = "306 \(unit)"
    }
    
    private let passageLabel = PaddingLabel().then {
        $0.font = Pretendard.regular.dynamicFont(style: .subheadline)
        $0.textAlignment = .left
        $0.backgroundColor = .lightPastelBlue
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.numberOfLines = 3
        $0.text = "뭘 쓰고 싶었는지 전혀 기억이 나지 않았다. 아무 것도 쓰기 싫었다. 그저 빨리 돌아가 씻고 싶을 뿐이었다."
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        [lineView, circleView, pageLabel, passageLabel].forEach {
            contentView.addSubview($0)
        }
        
        circleView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
            $0.height.width.equalTo(16)
        }
        
        lineView.snp.makeConstraints {
            $0.centerX.equalTo(circleView)
            $0.width.equalTo(1)
            $0.height.equalToSuperview()
        }
        
        pageLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(38)
            $0.trailing.lessThanOrEqualTo(passageLabel.snp.leading).offset(-10)
        }
        
        passageLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.trailing.equalToSuperview()
            $0.width.lessThanOrEqualTo(277)
        }
    }
}

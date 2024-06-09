//
//  KeywordCollectionViewCell.swift
//  Dokgi
//
//  Created by 송정훈 on 6/9/24.
//

import SnapKit
import Then
import UIKit

class KeywordCollectionViewCell: UICollectionViewCell {
    static let identifier = "KeywordCollectionViewCell"
    
    lazy var keywordLbl = UILabel().then {
        $0.text = "dddd"
        $0.font = Pretendard.regular.dynamicFont(style: .callout)
        $0.textColor = UIColor(named: "BrightBlue")
    }
    
    lazy var xBtn = UIButton().then {
        $0.setImage(UIImage(named: "deleteKeyword"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "LavenderBlue")
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    func setupLayout() {
        addSubview(keywordLbl)
        
        keywordLbl.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview().inset(5)
        }
    }
}

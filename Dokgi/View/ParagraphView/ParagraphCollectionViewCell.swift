//
//  ParagraphCollectionViewCell.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/10/24.
//
import SnapKit
import UIKit

class ParagraphCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ParagraphCollectionViewCell"
    
    let paragraphLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCell()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell() {
        paragraphLabel.font = Pretendard.regular.dynamicFont(style: .subheadline)
        paragraphLabel.textColor = UIColor.black
        paragraphLabel.numberOfLines = 0  //자동 줄바꿈
        paragraphLabel.lineBreakMode = .byCharWrapping
        
        dateLabel.text = "24.05.26"
        dateLabel.font = Pretendard.regular.dynamicFont(style: .caption2)
        dateLabel.textColor = UIColor(named: "AlarmMemoGray")
        dateLabel.numberOfLines = 1
    }
    
    func setConstraints() {
        [paragraphLabel, dateLabel].forEach {
            contentView.addSubview($0)
        }
        
        paragraphLabel.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview().inset(15)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(paragraphLabel.snp.bottom).offset(30)
            $0.bottom.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(22)
        }
    }
}

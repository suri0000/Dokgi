//
//  ParagraphCollectionViewCell.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/10/24.
//
import SnapKit
import UIKit

protocol PassageCollectionViewCellDelegate: AnyObject {
    func tappedDeleteButton(in cell: PassageCollectionViewCell)
}

class PassageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PassageCollectionViewCell"
    
    let deleteButton = UIButton()
    let paragraphLabel = UILabel()
    let dateLabel = UILabel()
    weak var delegate: PassageCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCell()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell() {
        deleteButton.setImage(.deleteParagraph, for: .normal)
        deleteButton.addTarget(self, action: #selector(tappedDeleteButton), for: .touchUpInside)

        paragraphLabel.font = Pretendard.regular.dynamicFont(style: .subheadline)
        paragraphLabel.numberOfLines = 0  //자동 줄바꿈
        paragraphLabel.lineBreakMode = .byCharWrapping
        paragraphLabel.textColor = .black
        
        dateLabel.font = Pretendard.regular.dynamicFont(style: .caption2)
        dateLabel.textColor = .alarmMemoGray
        dateLabel.numberOfLines = 1
    }
    
    func setConstraints() {
        [deleteButton, paragraphLabel, dateLabel].forEach {
            contentView.addSubview($0)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(-7)
            $0.width.height.equalTo(26)
        }
        
        paragraphLabel.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview().inset(15)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(paragraphLabel.snp.bottom).offset(30)
            $0.bottom.trailing.equalToSuperview().inset(15)
        }
    }
    
    func setColor(with indexPath: IndexPath) {
        let colors = ["LightSkyBlue", "LightPastelBlue", "LavenderBlue", "LavenderDarkBlue"]
        let colorName = colors[indexPath.item % colors.count]
        contentView.backgroundColor = UIColor(named: colorName) ?? .gray
        contentView.layer.cornerRadius = 20
    }
    
    @objc private func tappedDeleteButton() {
        delegate?.tappedDeleteButton(in: self)
    }
}

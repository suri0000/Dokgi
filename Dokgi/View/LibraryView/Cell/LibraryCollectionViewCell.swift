//
//  LibraryCollectionViewCell.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/5/24.
//
import SnapKit
import UIKit

final class LibraryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LibraryCollectionViewCell"
    
    let bookImageView = UIImageView()
    let bookNameLabel = UILabel()
    let authorNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCell()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCell() {
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        bookImageView.backgroundColor = .white
        bookImageView.layer.cornerRadius = 15
        bookImageView.clipsToBounds = true
        bookImageView.layer.borderColor = UIColor(resource: .buttonLightGray).cgColor
        bookImageView.layer.borderWidth = 1
        bookImageView.contentMode = .scaleToFill
        
        bookNameLabel.font = Pretendard.bold.dynamicFont(style: .subheadline)
        bookNameLabel.textColor = .black
        bookNameLabel.textAlignment = .center
        bookNameLabel.numberOfLines = 2
        bookNameLabel.layer.masksToBounds = true
        
        authorNameLabel.font = Pretendard.regular.dynamicFont(style: .caption1)
        authorNameLabel.textColor = UIColor(named: "AuthorLabelGray")
        authorNameLabel.textAlignment = .center
        authorNameLabel.layer.masksToBounds = true
    }
    
    private func setConstraints() {
        [bookImageView,bookNameLabel, authorNameLabel].forEach {
            contentView.addSubview($0)
        }
        
        bookImageView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            // 기기 변경 시 오토레이아웃 깨지지 않게 -> 피그마 기준 이미지 크기 165:190 = 1:1.151515
            $0.height.equalTo(bookImageView.snp.width).multipliedBy(1.151515)
        }
        
        bookNameLabel.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.height.equalTo(40)
        }
        
        authorNameLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(bookNameLabel.snp.bottom).offset(3)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
    }
}

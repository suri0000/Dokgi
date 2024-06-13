//
//  BookCellTableViewCell.swift
//  Dokgi
//
//  Created by 한철희 on 6/11/24.
//

import UIKit
import Kingfisher

class BookCell: UITableViewCell {
    private let bookImageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(bookImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        
        titleLabel.font = Pretendard.semibold.dynamicFont(style: .body)
        authorLabel.font = Pretendard.semibold.dynamicFont(style: .body)
        authorLabel.textColor = .authorLabelGray
        
        bookImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(140)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(bookImageView.snp.trailing).offset(16)
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        authorLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(with item: Item) {
        titleLabel.text = item.title
        authorLabel.text = item.author
        
        if let url = URL(string: item.image) {
            bookImageView.kf.setImage(with: url)
        }
    }
}


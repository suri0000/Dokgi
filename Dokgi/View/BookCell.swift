//
//  BookCellTableViewCell.swift
//  Dokgi
//
//  Created by 한철희 on 6/11/24.
//

import UIKit

class BookCell: UITableViewCell {
    internal let bookImageView = UIImageView() // Renamed imageView to bookImageView
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
        contentView.addSubview(bookImageView) // Updated to add bookImageView
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        
        bookImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
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
        // 이미지 로드 및 설정
    }
}

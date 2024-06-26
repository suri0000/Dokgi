//
//  BookCellTableViewCell.swift
//  Dokgi
//
//  Created by 한철희 on 6/11/24.
//

import UIKit
import Kingfisher

class BookCell: UITableViewCell {
    static let identifier = "BookCell"
    
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
        self.backgroundColor = .white
        
        contentView.addSubview(bookImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        
        titleLabel.font = Pretendard.semibold.dynamicFont(style: .body)
        authorLabel.font = Pretendard.semibold.dynamicFont(style: .body)
        authorLabel.textColor = .authorLabelGray
        bookImageView.contentMode = .scaleAspectFill
        bookImageView.layer.cornerRadius = 15
        bookImageView.clipsToBounds = true
        
        bookImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(90)
            $0.height.equalTo(130)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalTo(bookImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(with item: Item) {
        titleLabel.text = item.title
        authorLabel.text = item.formattedAuthor
        
        if let url = URL(string: item.image) {
            bookImageView.kf.setImage(with: url)
        }
    }
}


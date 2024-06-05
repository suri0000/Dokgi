//
//  LibraryCollectionViewCell.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/5/24.
//

import UIKit
import CoreData

class LibraryCollectionViewCell: UICollectionViewCell {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    static let identifier = "LibraryCollectionViewCell"
    
    let bookImageView = UIImageView()
    let bookNameLabel = UILabel()
    let authorNameLabel = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCell()
        setConstraint()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell() {
       
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        bookImageView.image = UIImage(named: "book")
        bookImageView.backgroundColor = .yellow
        bookImageView.layer.cornerRadius = 15
        bookImageView.layer.borderColor = UIColor.gray.cgColor
        bookImageView.layer.borderWidth = 1
        bookImageView.contentMode = .scaleAspectFit
  
        bookNameLabel.text = "김태성의 별별 한국사 능력 검정시험"
        bookNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        bookNameLabel.textColor = UIColor.black
        bookNameLabel.textAlignment = .center
        bookNameLabel.numberOfLines = 2
        bookNameLabel.layer.masksToBounds = true

        authorNameLabel.text = "김6조"
        authorNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        authorNameLabel.textColor = UIColor.gray
        authorNameLabel.textAlignment = .center
        authorNameLabel.layer.masksToBounds = true
    }
    
    func setConstraint() {
        
        [bookImageView,bookNameLabel, authorNameLabel].forEach {
            contentView.addSubview($0)
        }
        
        
        bookImageView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
//            $0.height.equalTo(190)
            $0.height.equalTo(bookImageView.snp.width).multipliedBy(1.15)
        }

        bookNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(authorNameLabel.snp.top).offset(-5)
            $0.leading.trailing.equalToSuperview()
        }
        
        authorNameLabel.snp.makeConstraints {
            $0.top.equalTo(bookNameLabel.snp.bottom).inset(5)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(14)
        }


        
    }
    
}

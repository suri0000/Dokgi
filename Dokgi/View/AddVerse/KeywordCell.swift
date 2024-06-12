//
//  KeywordCell.swift
//  Dokgi
//
//  Created by 한철희 on 6/11/24.
//

import UIKit
import SnapKit
import Then

class KeywordCell: UICollectionViewCell {
    
    static let reuseIdentifier = "KeywordCell"
    
    private let label = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    private let deleteButton = UIButton().then {
        $0.setTitle("x", for: .normal)
        $0.setTitleColor(UIColor(named: "BrightBlue"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(label)
        addSubview(deleteButton)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        layer.cornerRadius = 10
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func deleteButtonTapped() {
        guard let collectionView = superview as? UICollectionView else { return }
        guard let indexPath = collectionView.indexPath(for: self) else { return }
        (collectionView.delegate as? AddVerseVC)?.removeKeyword(at: indexPath)
    }
    
    func configure(with text: String) {
        label.text = text
    }
}


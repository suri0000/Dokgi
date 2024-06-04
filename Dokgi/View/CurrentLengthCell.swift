//
//  CurrentLengthCell.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/5/24.
//

import UIKit
import SnapKit

class CurrentLengthCell: UICollectionViewCell {
    static let identifier = "CurrentLengthCell"
    
    let myView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubview(myView)
        
        myView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func setupConstraints() {
        myView.backgroundColor = .red
    }
}

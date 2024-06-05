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
    
    let cardView = UIView()
    let textView = UIView()
    let levelView = UIView()
    let levelLabel = UILabel()
    let descrptionLabel = UILabel()
    let lengthLabel = UILabel()
    let imageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupConstraints()
        setUpShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubview(cardView)
        [textView, imageView].forEach {
            cardView.addSubview($0)
        }
        [levelView, levelLabel, descrptionLabel, lengthLabel].forEach {
            textView.addSubview($0)
        }
        
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.height.width.equalTo(107)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32.5)
            $0.bottom.equalToSuperview().offset(-32.5)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(imageView.snp.leading)
        }
        
        levelView.snp.makeConstraints {
            $0.width.equalTo(63)
            $0.height.equalTo(22)
            $0.leading.top.equalToSuperview()
        }
        
        levelLabel.snp.makeConstraints {
            $0.center.equalTo(levelView)
        }
        
        descrptionLabel.snp.makeConstraints {
            $0.top.equalTo(levelView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        lengthLabel.snp.makeConstraints {
            $0.top.equalTo(descrptionLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        
    }
    
    func setupConstraints() {
        contentView.layer.cornerRadius = 8
        cardView.backgroundColor = .white
        
        
        imageView.backgroundColor = .gray
        textView.backgroundColor = .clear
        
        levelView.backgroundColor = .lightSkyBlue
        levelView.layer.cornerRadius = 10
        
        levelLabel.text = "LEVEL 0"
        levelLabel.textColor = .mediumSkyBlue
        levelLabel.font = .systemFont(ofSize: 12, weight: .heavy)
        
        descrptionLabel.text = "고니가 잰 길이만큼 (3cm)"
        descrptionLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        
        lengthLabel.text = "00mm"
        lengthLabel.textColor = .mediumSkyBlue
        lengthLabel.font = .monospacedDigitSystemFont(ofSize: 30, weight: .heavy)
    }
    
    func setUpShadow() {
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        self.prepare(color: nil)
//      }
//      
//      func prepare(color: UIColor?) {
//        self.myView.backgroundColor = color
//      }
}


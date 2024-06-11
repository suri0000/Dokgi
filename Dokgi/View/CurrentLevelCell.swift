//
//  CurrentLevelCell.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/5/24.
//

import SnapKit
import UIKit

class CurrentLevelCell: UICollectionViewCell {
    static let identifier = "CurrentLevelCell"
    
    let cardView = UIView()
    let textView = UIView()
    let levelView = UIView()
    let levelLabel = UILabel()
    let descrptionLabel = UILabel()
    let lengthLabel = UILabel()
    let cardImageView = UIImageView()
    var blurEffectView = UIVisualEffectView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupConstraints()
        setUpShadow()
        setupBlur(alpha: 0.8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        contentView.addSubview(cardView)
        [textView, cardImageView].forEach {
            cardView.addSubview($0)
        }
        [levelView, levelLabel, descrptionLabel, lengthLabel].forEach {
            textView.addSubview($0)
        }
        
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cardImageView.snp.makeConstraints {
            $0.height.width.equalTo(107)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(32.5)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(cardImageView.snp.leading)
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
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func configureUI() {
        contentView.layer.cornerRadius = 8
        cardView.backgroundColor = .white
        
        cardImageView.backgroundColor = .clear
        cardImageView.contentMode = .scaleAspectFit
        textView.backgroundColor = .clear
        
        levelView.backgroundColor = .lightSkyBlue
        levelView.layer.cornerRadius = 10
        
        levelLabel.textColor = .mediumSkyBlue
        levelLabel.font = Pretendard.bold.dynamicFont(style: .caption1)
        
        descrptionLabel.font = Pretendard.regular.dynamicFont(style: .footnote)
        descrptionLabel.numberOfLines = 2
        
        lengthLabel.textColor = .mediumSkyBlue
        lengthLabel.font = Pretendard.bold.dynamicFont(style: .largeTitle)
    }
    
    func setCellConfig(_ cardData: Card) {
        if let cardImage = cardData.cardImage {
            cardImageView.image = cardImage
        }
        
        let formattedLength = MetricUtil.formatLength(length: cardData.length)
        levelLabel.text = "LEVEL " + String(cardData.level)
        descrptionLabel.text = "\(cardData.descrption) 만큼 (\(formattedLength))"
        lengthLabel.text = String(formattedLength)
    }
    
    // 그림자 설정
    func setUpShadow() {
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 9
        layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }

    func setupBlur(alpha: CGFloat = 0.5) {
        // 블러 효과 생성
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        // 블러 효과 뷰의 크기와 위치 설정
        blurEffectView.frame = self.contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.backgroundColor = .white.withAlphaComponent(0.5)
        
        // 블러 효과 뷰를 셀의 contentView에 추가
        self.contentView.addSubview(blurEffectView)
        
        // 블러 효과의 알파값 설정
        blurEffectView.alpha = alpha
        
        self.blurEffectView = blurEffectView
    }
}


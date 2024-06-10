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
    var blurEffectView: UIVisualEffectView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupConstraints()
        setUpShadow()
        
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
            $0.top.equalToSuperview().offset(32.5)
            $0.bottom.equalToSuperview().offset(-32.5)
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
        
        levelLabel.text = "LEVEL 0"
        levelLabel.textColor = .mediumSkyBlue
        levelLabel.font = .systemFont(ofSize: 12, weight: .heavy)
        
        descrptionLabel.text = "고니가 잰 길이만큼 (3cm)"
        descrptionLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        descrptionLabel.numberOfLines = 2
        
        lengthLabel.text = "00mm"
        lengthLabel.textColor = .mediumSkyBlue
        lengthLabel.font = .monospacedDigitSystemFont(ofSize: 30, weight: .heavy)
    }
    
    func setCellConfig(_ cardData: Card) {
        if let cardImage = cardData.cardImage {
            cardImageView.image = cardImage
        }
        
        let formattedLength = formatLength(length: cardData.length)
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
    
    // 블러 효과
//    func setupBlur(alpha: CGFloat = 0.5) {
//        let blurEffect = UIBlurEffect(style: .regular)
//        let visualEffectView = UIVisualEffectView(effect: blurEffect)
//        visualEffectView.frame = self.contentView.frame
//        visualEffectView.alpha = alpha
//        self.contentView.addSubview(visualEffectView)
//    }
    
    func setupBlur(alpha: CGFloat = 0.5) {
        // 블러 효과 생성
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        // 블러 효과 뷰의 크기와 위치 설정
        blurEffectView.frame = self.contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.backgroundColor = .white
        
        // 블러 효과 뷰를 셀의 contentView에 추가
        self.contentView.addSubview(blurEffectView)
        
        // 블러 효과의 알파값 설정
        blurEffectView.alpha = alpha
        
        self.blurEffectView = blurEffectView
    }
    
    func removeBlur() {
        // 블러 효과 제거
        blurEffectView?.removeFromSuperview()
        blurEffectView = nil
    }
    
    // 길이 계산
    func formatLength(length: Int) -> String {
        switch length {
        case 0..<10:
            return "\(length) mm"
        case 10..<1000:
            let cmLength = Double(length) / 10.0
            return "\(cmLength) cm"
        case 1000..<1000000:
            let mLength = Double(length) / 1000.0
            return "\(mLength) m"
        default:
            let kmLength = Double(length) / 1000000.0
            return "\(kmLength) km"
        }
    }
}


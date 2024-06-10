//
//  BookDetailViewController.swift
//  Dokgi
//
//  Created by 예슬 on 6/10/24.
//

import SnapKit
import Then
import UIKit

class BookDetailViewController: UIViewController {
    
    private let contentsView = UIView()
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let backgroundBookImage = UIImageView().then {
        $0.image = UIImage(named: "testImage")
        $0.contentMode = .scaleAspectFill
    }
    
    private let blurView = UIVisualEffectView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.6)
        $0.effect = UIBlurEffect(style: .light)
        $0.alpha = 0.8
    }
    
    private let gradientLayerView = UIView()
    
    private lazy var gradientLayer = CAGradientLayer().then {
        let colors: [CGColor] = [
            UIColor(white: 1.0, alpha: 0.0).cgColor,
            UIColor(white: 1.0, alpha: 1.0).cgColor
        ]
        
        $0.type = .axial
        $0.frame = gradientLayerView.bounds
        $0.colors = colors
        $0.startPoint = CGPoint(x: 0.5, y: 0.0)
        $0.endPoint = CGPoint(x: 0.5, y: 0.8)
    }
    
    private let bookImage = UIImageView().then {
        $0.image = UIImage(named: "testImage")
        $0.contentMode = .scaleAspectFill
    }
    
    private let bookInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let bookTitleLabel = UILabel().then {
        $0.text = "하루 한 장 나의 어휘력을 위한 필사 노트"
        $0.font = Pretendard.semibold.dynamicFont(style: .headline)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let authorLabel = UILabel().then {
        $0.text = "쿠이 료코"
        $0.font = Pretendard.regular.dynamicFont(style: .subheadline)
        $0.numberOfLines = 2
        $0.textColor = .alarmSettingText
        $0.textAlignment = .center
    }
    
    private let firstDateRecordStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    private let firstRecordDateTitleLabel = UILabel().then {
        $0.text = "처음 기록 날짜"
        $0.font = Pretendard.regular.dynamicFont(style: .subheadline)
        $0.textAlignment = .left
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "2024. 06. 09"
        $0.font = Pretendard.regular.dynamicFont(style: .subheadline)
        $0.textColor = .alarmSettingText
        $0.textAlignment = .right
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blurLayer()
    }
    
    private func setConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        
        [backgroundBookImage,
         blurView,
         gradientLayerView,
         bookImage,
         bookInfoStackView,
         firstDateRecordStackView].forEach {
            contentsView.addSubview($0)
        }
        
        [bookTitleLabel,
         authorLabel].forEach {
            bookInfoStackView.addArrangedSubview($0)
        }
        
        [firstRecordDateTitleLabel,
         dateLabel].forEach {
            firstDateRecordStackView.addArrangedSubview($0)
        }
        
        scrollView.snp.makeConstraints { 
            $0.top.equalToSuperview()
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentsView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        backgroundBookImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(-290)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bookInfoStackView.snp.top)
        }
        
        blurView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(-200)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bookInfoStackView.snp.top)
        }
        
        gradientLayerView.snp.makeConstraints {
            $0.bottom.equalTo(blurView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.09)
        }
        
        bookImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(26)
            $0.horizontalEdges.equalToSuperview().inset(135)
        }
        
        bookInfoStackView.snp.makeConstraints {
            $0.top.equalTo(bookImage.snp.bottom).inset(-50)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        firstDateRecordStackView.snp.makeConstraints {
            $0.top.equalTo(bookInfoStackView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(900)
        }
        
    }
    
    private func blurLayer() {
        gradientLayer.frame = gradientLayerView.bounds
        gradientLayerView.layer.addSublayer(gradientLayer)
    }
}

#Preview {
    BookDetailViewController()
}

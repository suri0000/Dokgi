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
    var passageCount = 5
    
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
    
    private let passageTitleLabel = UILabel().then {
        $0.text = "구절"
        $0.font = Pretendard.semibold.dynamicFont(style: .title3)
    }
    
    private let passageTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 289
        $0.separatorStyle = .none
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        passageTableView.backgroundColor = .orange
        passageTableView.dataSource = self
        passageTableView.delegate = self
        passageTableView.register(PassageTableViewCell.self, forCellReuseIdentifier: PassageTableViewCell.identifier)
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blurLayer()
    }
    // MARK: - UI
    private func setConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        
        [backgroundBookImage,
         blurView,
         gradientLayerView,
         bookImage,
         bookInfoStackView,
         firstDateRecordStackView,
         passageTitleLabel,
         passageTableView].forEach {
            contentsView.addSubview($0)
        }
        
        [bookTitleLabel, authorLabel].forEach {
            bookInfoStackView.addArrangedSubview($0)
        }
        
        [firstRecordDateTitleLabel, dateLabel].forEach {
            firstDateRecordStackView.addArrangedSubview($0)
        }
        
        scrollView.snp.makeConstraints { 
            $0.top.equalToSuperview()
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
            $0.height.equalTo(1400)
//            $0.height.equalTo(self.view.frame.height + 420)
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
        }
        
        passageTitleLabel.snp.makeConstraints {
            $0.top.equalTo(firstDateRecordStackView.snp.bottom).offset(42)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        passageTableView.snp.makeConstraints {
            $0.top.equalTo(passageTitleLabel.snp.bottom).offset(11)
            $0.horizontalEdges.equalToSuperview().inset(20)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide)
//            $0.bottom.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
//            $0.bottom.equalTo()
        }
    }
    
    private func blurLayer() {
        gradientLayer.frame = gradientLayerView.bounds
        gradientLayerView.layer.addSublayer(gradientLayer)
    }
}

extension BookDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passageCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PassageTableViewCell.identifier, for: indexPath) as? PassageTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}

#Preview {
    BookDetailViewController()
}

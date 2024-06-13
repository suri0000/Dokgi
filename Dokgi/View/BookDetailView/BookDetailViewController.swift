//
//  BookDetailViewController.swift
//  Dokgi
//
//  Created by 예슬 on 6/10/24.
//

import Kingfisher
import SnapKit
import Then
import UIKit

class BookDetailViewController: UIViewController {
    private let viewModel = BookDetailViewModel.shared
    private var passageCount = 5
    lazy var bookInfo = viewModel.bookInfo
    
    private let contentsView = UIView()
    private let gradientLayerView = UIView()
    private let buttonBackgroundView = UIView()
    private let buttonBackgroundLayer = CAGradientLayer()
    private let gradientLayer = CAGradientLayer()
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let backgroundBookImage = UIImageView().then {
        $0.image = UIImage(named: "testImage")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let blurView = UIVisualEffectView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.6)
        $0.effect = UIBlurEffect(style: .light)
        $0.alpha = 0.8
    }
    
    private let bookImage = UIImageView().then {
        $0.image = UIImage(named: "testImage")
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = false
        $0.clipsToBounds = true
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
        $0.isScrollEnabled = false
    }
    
    private let addPassageButton = UIButton().then {
        $0.backgroundColor = .charcoalBlue
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    private let buttonLabel = UILabel().then {
        $0.text = "구절 추가하기"
        $0.font = Pretendard.semibold.dynamicFont(style: .headline)
        $0.textColor = .white
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        passageTableView.dataSource = self
        passageTableView.delegate = self
        passageTableView.register(PassageTableViewCell.self, forCellReuseIdentifier: PassageTableViewCell.identifier)
        setConstraints()
        setBookInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blurLayer(layer: gradientLayer, view: gradientLayerView)
        blurLayer(layer: buttonBackgroundLayer, view: buttonBackgroundView)
    }
    // MARK: - UI
    private func setConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        addPassageButton.addSubview(buttonLabel)
        
        [backgroundBookImage,
         blurView,
         gradientLayerView,
         bookImage,
         bookInfoStackView,
         firstDateRecordStackView,
         passageTitleLabel,
         passageTableView,
         buttonBackgroundView,
         addPassageButton].forEach {
            contentsView.addSubview($0)
        }
        
        [bookTitleLabel, authorLabel].forEach {
            bookInfoStackView.addArrangedSubview($0)
        }
        
        [firstRecordDateTitleLabel, dateLabel].forEach {
            firstDateRecordStackView.addArrangedSubview($0)
        }
        
        scrollView.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        passageTableView.snp.makeConstraints {
            $0.top.equalTo(passageTitleLabel.snp.bottom).offset(11)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(96 * passageCount)
            $0.bottom.equalToSuperview().inset(100)
        }
        
        backgroundBookImage.snp.makeConstraints {
            $0.top.equalTo(self.view)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bookInfoStackView.snp.top)
        }
        
        blurView.snp.makeConstraints {
            $0.top.equalTo(self.view)
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
            $0.height.equalTo(bookImage.snp.width).multipliedBy(1.4)
        }
        
        bookInfoStackView.snp.makeConstraints {
            $0.top.equalTo(bookImage.snp.bottom).offset(50)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        firstDateRecordStackView.snp.makeConstraints {
            $0.top.equalTo(bookInfoStackView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        firstRecordDateTitleLabel.setContentHuggingPriority(.init(rawValue: 251), for: .horizontal)
        
        passageTitleLabel.snp.makeConstraints {
            $0.top.equalTo(firstDateRecordStackView.snp.bottom).offset(42)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        addPassageButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalTo(buttonBackgroundView)
        }
        
        buttonLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(15)
        }
        
        buttonBackgroundView.snp.makeConstraints {
            $0.centerY.equalTo(addPassageButton)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.2)
        }
    }
    
    private func blurLayer(layer: CAGradientLayer, view: UIView) {
        let colors: [CGColor] = [
            UIColor(white: 1.0, alpha: 0.0).cgColor,
            UIColor(white: 1.0, alpha: 1.0).cgColor
        ]
        
        layer.type = .axial
        layer.frame = view.bounds
        layer.colors = colors
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 0.8)
        view.layer.addSublayer(layer)
    }
    
    private func setBookInfo() {
        bookTitleLabel.text = bookInfo?.name
        authorLabel.text = bookInfo?.author
        if let url = URL(string: bookInfo?.image ?? "") {
            bookImage.kf.setImage(with: url)
            backgroundBookImage.kf.setImage(with: url)
        }
    }
}
// MARK: - PassageTableView
extension BookDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return passageCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PassageTableViewCell.identifier, for: indexPath) as? PassageTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

#Preview {
    BookDetailViewController()
}

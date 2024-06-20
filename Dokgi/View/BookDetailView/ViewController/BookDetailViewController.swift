//
//  BookDetailViewController.swift
//  Dokgi
//
//  Created by 예슬 on 6/10/24.
//

import RxSwift
import Kingfisher
import SnapKit
import Then
import UIKit

class BookDetailViewController: UIViewController {
    private let viewModel = BookDetailViewModel.shared
    private var disposeBag = DisposeBag()
    
    private let contentsView = UIView()
    private let gradientLayerView = UIView()
    private let buttonBackgroundView = UIView()
    private let buttonBackgroundLayer = CAGradientLayer()
    private let gradientLayer = CAGradientLayer()
    
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let backgroundBookImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let blurView = UIVisualEffectView().then {
        $0.backgroundColor = .white.withAlphaComponent(0.6)
        $0.effect = UIBlurEffect(style: .light)
        $0.alpha = 0.8
    }
    
    private let bookImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = false
        $0.clipsToBounds = true
    }
    
    private let bookInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let bookTitleLabel = UILabel().then {
        $0.font = Pretendard.semibold.dynamicFont(style: .headline)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let authorLabel = UILabel().then {
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
    
    lazy var addPassageButton = UIButton().then {
        $0.backgroundColor = .charcoalBlue
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(didTabAddPassageButton), for: .touchUpInside)
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
        viewModel.makePassageDateOfBook()
        setConstraints()
        setBookInfo()
        
        CoreDataManager.shared.bookData.subscribe(with: self) { (self, bookData) in
            self.viewModel.makePassageDateOfBook()
            self.passageTableView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        blurLayer(layer: gradientLayer, view: gradientLayerView)
        blurLayer(layer: buttonBackgroundLayer, view: buttonBackgroundView)
        passageTableView.snp.remakeConstraints {
            $0.top.equalTo(passageTitleLabel.snp.bottom).offset(11)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(96 * viewModel.passagesData.value.count)
            $0.bottom.equalToSuperview().inset(60)
        }

    }
    // MARK: - UI
    private func setConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        addPassageButton.addSubview(buttonLabel)
        view.addSubview(buttonBackgroundView)
        view.addSubview(addPassageButton)
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
            $0.edges.equalTo(self.view)
        }
        
        contentsView.snp.makeConstraints {
            $0.edges.width.equalToSuperview()
        }
        
        passageTableView.snp.makeConstraints {
            $0.top.equalTo(passageTitleLabel.snp.bottom).offset(11)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(96 * viewModel.passagesData.value.count)
            $0.bottom.equalToSuperview().inset(60)
        }
        
        backgroundBookImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-100)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bookInfoStackView.snp.top)
        }
        
        blurView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-100)
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
            $0.centerX.equalToSuperview()
            $0.width.equalTo(174)
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
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.3)
        }
    }
    
    private func blurLayer(layer: CAGradientLayer, view: UIView) {
        let colors: [CGColor] = [
            UIColor(white: 1.0, alpha: 0.0).cgColor,
            UIColor(white: 1.0, alpha: 1.0).cgColor
        ]
        
        layer.type = .axial
        layer.colors = colors
        
        DispatchQueue.global(qos: .userInitiated).async {
            let startPoint = CGPoint(x: 0.5, y: 0.0)
            let endPoint: CGPoint
            if view == self.buttonBackgroundView {
                endPoint = CGPoint(x: 0.5, y: 0.5)
            } else {
                endPoint = CGPoint(x: 0.5, y: 0.8)
            }
            
            DispatchQueue.main.async {
                layer.frame = view.bounds
                layer.startPoint = startPoint
                layer.endPoint = endPoint
                view.layer.addSublayer(layer)
            }
        }
    }
    
    private func setBookInfo() {
        bookTitleLabel.text = viewModel.bookInfo.value.name
        authorLabel.text = viewModel.bookInfo.value.author
        dateLabel.text = viewModel.recordDateFormat()
        
        if let url = URL(string: viewModel.bookInfo.value.image) {
            bookImage.kf.setImage(with: url)
            backgroundBookImage.kf.setImage(with: url)
        }
    }
    
    @objc private func didTabAddPassageButton() {
        let addVerseVC = AddVerseViewController()
        addVerseVC.viewModel.selectedBook = viewModel.makeAddVerseViewData()
        self.navigationController?.pushViewController(addVerseVC, animated: true)
        addVerseVC.displayBookInfo()
    }
}
// MARK: - PassageTableView
extension BookDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.passagesData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PassageTableViewCell.identifier, for: indexPath) as? PassageTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.setPassageData(passage: viewModel.passagesData.value[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}

#Preview {
    BookDetailViewController()
}

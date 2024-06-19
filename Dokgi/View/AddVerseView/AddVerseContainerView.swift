//
//  AddVerseContainerLayout.swift
//  Dokgi
//
//  Created by 한철희 on 6/17/24.
//

import BetterSegmentedControl
import Kingfisher
import SnapKit
import Then
import UIKit

class AddVerseContainerView: UIView {
    
    // MARK: - Properties
    let scanButton = UIButton(configuration: .filled(), primaryAction: nil).then {
        $0.configurationUpdateHandler = { button in
            var configuration = button.configuration
            configuration?.title = "구절 스캔"
            configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = Pretendard.bold.dynamicFont(style: .subheadline)
                return outgoing
            }
            configuration?.baseForegroundColor = .charcoalBlue
            configuration?.baseBackgroundColor = .lightSkyBlue
            configuration?.image = UIImage(resource: .camera).withTintColor(UIColor(resource: .charcoalBlue), renderingMode: .alwaysOriginal)
            configuration?.imagePadding = 10
            button.configuration = configuration
        }
        $0.layer.cornerRadius = 17
        $0.clipsToBounds = true
    }
    
    let infoView = UIView().then {
        $0.layer.cornerRadius = 15
    }
    
    let overlayView = UIView().then {
        $0.backgroundColor = UIColor.lightSkyBlue.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 15
    }
    
    let searchButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.filled()
        config.title = "책 검색"
        $0.titleLabel?.font = Pretendard.semibold.dynamicFont(style: .headline)
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .charcoalBlue
        config.image = .magnifyingglass
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 15)
        $0.configuration = config
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.titleLabel?.numberOfLines = 1
    }
    
    var imageView = UIImageView().then {
        $0.image = UIImage(resource: .empty).withRenderingMode(.alwaysTemplate)
        $0.tintColor = .buttonLightGray
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    var titleLabel = UILabel().then {
        $0.text = "책 제목"
        $0.font = Pretendard.bold.dynamicFont(style: .body)
        $0.textColor = .bookTextGray
        $0.numberOfLines = 2
    }
    
    var authorLabel = UILabel().then {
        $0.text = "저자"
        $0.font = Pretendard.bold.dynamicFont(style: .body)
        $0.textColor = .bookTextGray
        $0.numberOfLines = 2
    }
    
    let overlapView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    lazy var verseTextView = UITextView().then {
        $0.text = "텍스트를 입력하세요"
        $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        $0.font = Pretendard.regular.dynamicFont(style: .body)
        $0.showsVerticalScrollIndicator = false
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.0
        let attributedString = NSAttributedString(string: $0.text ?? "", attributes: [.paragraphStyle: paragraphStyle])
        $0.attributedText = attributedString
        $0.textColor = .placeholderText
    }
    
    let characterCountLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = Pretendard.bold.dynamicFont(style: .footnote)
    }
    
    private let pencilImageView = UIImageView().then {
        $0.image = UIImage(named: "pencil")
        $0.contentMode = .scaleAspectFit
    }
    
    let keywordLabel = UILabel().then {
        $0.attributedText = AddVerseVC.createAttributedString(for: "키워드 (선택)")
        $0.textAlignment = .left
    }
    
    let keywordField = UITextField().then {
        let placeholder = "키워드를 입력해 주세요"
        $0.font = Pretendard.regular.dynamicFont(style: .subheadline)
        $0.placeholder = placeholder
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.borderGray.cgColor
    }
    
    lazy var keywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return layout
    }()).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
    }
    
    let pageLabel = UILabel().then {
        $0.text = "페이지"
        $0.font = Pretendard.semibold.dynamicFont(style: .headline)
        $0.textColor = .black
    }
    
    let pageNumberTextField = UITextField().then {
        $0.placeholder = "페이지"
        $0.textAlignment = .center
        $0.font = Pretendard.regular.dynamicFont(style: .subheadline)
        $0.borderStyle = .roundedRect
    }
    
    let pageSegment = SegmentControlView().then {
        $0.selectedIndex = 0
    }
    
    let recordButton = UIButton().then {
        $0.setTitle("기록 하기", for: .normal)
        $0.titleLabel?.font = Pretendard.bold.dynamicFont(style: .headline)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .charcoalBlue
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setupViews
    private func setupViews() {
        addSubview(scanButton)
        addSubview(infoView)
        infoView.addSubview(imageView)
        infoView.addSubview(titleLabel)
        infoView.addSubview(authorLabel)
        infoView.addSubview(overlayView)
        overlayView.addSubview(searchButton)
        addSubview(overlapView)
        addSubview(verseTextView)
        addSubview(characterCountLabel)
        addSubview(pencilImageView)
        addSubview(keywordLabel)
        addSubview(keywordField)
        addSubview(keywordCollectionView)
        addSubview(pageLabel)
        addSubview(pageNumberTextField)
        addSubview(pageSegment)
        addSubview(recordButton)
    }
    
    // MARK: - 제약조건
    private func initLayout() {
        scanButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(scanButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(200)
        }
        
        overlayView.snp.makeConstraints {
            $0.edges.equalTo(infoView)
        }
        
        searchButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(35)
        }
        
        imageView.snp.makeConstraints {
            $0.leading.equalTo(infoView.snp.leading)
            $0.centerY.equalTo(infoView.snp.centerY)
            $0.width.equalTo(103)
            $0.height.equalTo(146)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(infoView.snp.centerY).offset(-16)
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.trailing.equalTo(infoView.snp.trailing).offset(-16)
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.trailing.equalTo(infoView.snp.trailing).offset(-16)
        }
        
        overlapView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(329) // 원하는 높이로 설정
        }
        
        verseTextView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(35)
            $0.horizontalEdges.equalToSuperview().inset(18)
            $0.bottom.equalTo(pencilImageView.snp.top).inset(8)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(overlapView.snp.trailing).offset(-16)
            $0.bottom.equalTo(overlapView.snp.bottom).offset(-16)
        }
        
        pencilImageView.snp.makeConstraints {
            $0.bottom.equalTo(overlapView.snp.bottom).offset(-8)
            $0.leading.equalTo(overlapView.snp.leading).offset(8)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.top.equalTo(overlapView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        keywordField.snp.makeConstraints {
            $0.top.equalTo(keywordLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }
        
        keywordCollectionView.snp.makeConstraints {
            $0.top.equalTo(keywordField.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(35)
        }
        
        pageLabel.snp.makeConstraints {
            $0.top.equalTo(keywordCollectionView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(16)
        }
        
        pageNumberTextField.snp.makeConstraints {
            $0.centerY.equalTo(pageLabel.snp.centerY)
            $0.leading.equalTo(pageLabel.snp.trailing).offset(8)
            $0.width.equalTo(60)
            $0.height.equalTo(30)
        }
        
        pageSegment.snp.makeConstraints {
            $0.centerY.equalTo(pageLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(30)
            $0.width.equalTo(120)
        }
        
        recordButton.snp.makeConstraints {
            $0.top.equalTo(pageLabel.snp.bottom).offset(60)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
}

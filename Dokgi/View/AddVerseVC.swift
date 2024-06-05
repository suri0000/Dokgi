//
//  AddVerseVC.swift
//  Dokgi
//
//  Created by 한철희 on 6/4/24.
//

import UIKit
import SnapKit
import VisionKit

class AddVerseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        initLayout()
        setupActions()
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let viewInScroll: UIView = {
        let uv = UIView()
        uv.translatesAutoresizingMaskIntoConstraints = false
        return uv
    }()
    
    let scanButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("구절 스캔", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold) // 세미볼드 글꼴 설정
        btn.setTitleColor(UIColor(named: "CharcoalBlue"), for: .normal) // 글씨 색상을 검은색으로 설정
        btn.backgroundColor = .lightSkyBlue // 버튼 배경색 추가 (선택 사항)
        btn.setImage(UIImage(named: "camera.viewfinder"), for: .normal) // 버튼 이미지 설정
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0) // 이미지와 텍스트 간의 여백 조정
        btn.layer.cornerRadius = 18
        btn.tintColor = UIColor(named: "CharcoalBlue")
        return btn
    }()
    
    let infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightSkyBlue
        view.layer.cornerRadius = 15
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "camera") // 이미지 이름을 적절히 수정하세요
        imageView.contentMode = .scaleAspectFit // 이미지의 비율을 유지하면서 이미지뷰에 맞춥니다.
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "책 제목"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "저자"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(named: "BookTextGray")
        return label
    }()
    
    let textViewPlaceHolder = "텍스트를 입력하세요"
    lazy var verseTextField: UITextView = {
        let view = UITextView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        view.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        view.font = .systemFont(ofSize: 18)
        view.text = textViewPlaceHolder
        view.textColor = .lightGray
        view.layer.cornerRadius = 8
        // view.delegate = self
        return view
    }()
    
    let keywordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = AddVerseVC.createAttributedString(for: "키워드 (선택)")
        label.textAlignment = .left
        return label
    }()
    
    let keywordField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "키워드를 입력해 주세요"
        textField.borderStyle = .roundedRect
        //        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()
    
    // 컬렉션 뷰 추가
    lazy var keywordCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let pageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "페이지"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let pageNumberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "페이지 수"
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let percentageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("%", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(UIColor(named: "CharcoalBlue"), for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1.0 // 테두리 두께 설정
        if let charcoalBlueColor = UIColor(named: "CharcoalBlue") {
            button.layer.borderColor = charcoalBlueColor.cgColor
        }
        return button
    }()
    
    let pageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Page", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1.0 // 테두리 두께 설정
        if let charcoalBlueColor = UIColor(named: "CharcoalBlue") {
            button.layer.borderColor = charcoalBlueColor.cgColor
        }
        return button
    }()
    
    let recordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("기록 하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "CharcoalBlue") // 버튼 배경색 설정
        button.layer.cornerRadius = 8
        return button
    }()
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(viewInScroll)
        viewInScroll.addSubview(scanButton)
        viewInScroll.addSubview(infoView)
        infoView.addSubview(imageView)
        infoView.addSubview(titleLabel)
        infoView.addSubview(authorLabel)
        viewInScroll.addSubview(verseTextField)
        viewInScroll.addSubview(keywordLabel)
        viewInScroll.addSubview(keywordField)
        viewInScroll.addSubview(keywordCollectionView)
        viewInScroll.addSubview(pageLabel)
        viewInScroll.addSubview(pageNumberTextField)
        viewInScroll.addSubview(percentageButton)
        viewInScroll.addSubview(pageButton)
        viewInScroll.addSubview(recordButton)
    }
    
    func initLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        viewInScroll.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(1000) // 임시로 1000으로 설정
        }
        
        scanButton.snp.makeConstraints { make in
            make.top.equalTo(viewInScroll.snp.top).offset(10)
            make.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
            make.width.equalTo(112)
            make.height.equalTo(35)
        }
        
        infoView.snp.makeConstraints { make in
            make.centerY.equalTo(viewInScroll.snp.top).offset(170)
            make.leading.equalTo(viewInScroll.snp.leading).offset(16)
            make.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
            make.height.equalTo(200) // 적절한 높이 설정
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(infoView.snp.leading).offset(16)
            make.centerY.equalTo(infoView.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(16)
            make.top.equalTo(infoView.snp.top).offset(16)
            make.trailing.equalTo(infoView.snp.trailing).offset(-16)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.trailing.equalTo(infoView.snp.trailing).offset(-16)
        }
        
        verseTextField.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(32)
            make.leading.equalTo(viewInScroll.snp.leading).offset(16)
            make.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
            make.height.equalTo(329)
        }
        
        keywordLabel.snp.makeConstraints { make in
            make.top.equalTo(verseTextField.snp.bottom).offset(32)
            make.leading.equalTo(viewInScroll.snp.leading).offset(16)
            make.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
        }
        
        keywordField.snp.makeConstraints { make in
            make.top.equalTo(keywordLabel.snp.bottom).offset(8)
            make.leading.equalTo(viewInScroll.snp.leading).offset(16)
            make.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
            make.height.equalTo(40)
        }
        
        // 컬렉션 뷰의 제약 조건 설정
        keywordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(keywordField.snp.bottom).offset(16)
            make.leading.equalTo(viewInScroll.snp.leading).offset(16)
            make.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
            make.height.equalTo(35) // 적절한 높이 설정
        }
        
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(keywordCollectionView.snp.bottom).offset(50)
            make.leading.equalTo(viewInScroll.snp.leading).offset(16)
        }
        
        pageNumberTextField.snp.makeConstraints { make in
            make.centerY.equalTo(pageLabel.snp.centerY)
            make.leading.equalTo(pageLabel.snp.trailing).offset(8)
            make.width.equalTo(55)
            make.height.equalTo(30)
        }
        
        percentageButton.snp.makeConstraints { make in
            make.centerY.equalTo(pageLabel.snp.centerY)
            make.trailing.equalTo(pageButton.snp.leading).offset(-8)
            make.width.equalTo(60) // 적절한 폭 설정
            make.height.equalTo(pageLabel.snp.height) // pageLabel과 같은 높이 설정
        }
        
        pageButton.snp.makeConstraints { make in
            make.centerY.equalTo(percentageButton.snp.centerY)
            make.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
            make.width.equalTo(60) // 적절한 폭 설정
            make.height.equalTo(percentageButton.snp.height)
        }
        
        recordButton.snp.makeConstraints { make in
            make.top.equalTo(pageLabel.snp.bottom).offset(60)
            make.leading.equalTo(viewInScroll.snp.leading).offset(16)
            make.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
            make.centerX.equalToSuperview()
            make.height.equalTo(50) // 적절한 높이 설정
        }
        
        scrollView.contentSize = viewInScroll.bounds.size
    }
    
    func setupActions() {
        scanButton.addTarget(self, action: #selector(scanButtonTapped(_:)), for: .touchUpInside)
        percentageButton.addTarget(self, action: #selector(percentageButtonTapped(_:)), for: .touchUpInside)
        pageButton.addTarget(self, action: #selector(pageButtonButtonTapped(_:)), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func scanButtonTapped(_ sender: UIButton) {
        // 구절 스캔 버튼이 눌렸을 때 실행될 액션 구현
        print("구절 스캔 버튼이 눌렸습니다.")
    }
    
    @objc func percentageButtonTapped(_ sender: UIButton) {
        // 구절 스캔 버튼이 눌렸을 때 실행될 액션 구현
        print("% 버튼이 눌렸습니다.")
    }
    
    @objc func pageButtonButtonTapped(_ sender: UIButton) {
        // 구절 스캔 버튼이 눌렸을 때 실행될 액션 구현
        print("page 버튼이 눌렸습니다.")
    }
    
    @objc func recordButtonButtonTapped(_ sender: UIButton) {
        // 구절 스캔 버튼이 눌렸을 때 실행될 액션 구현
        print("기록하기 버튼이 눌렸습니다.")
    }
    
    // 텍스트 속성을 설정하는 함수
    private static func createAttributedString(for text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        
        // "키워드" 부분에 대한 속성 설정
        let keywordRange = (text as NSString).range(of: "키워드")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .semibold), range: keywordRange)
        
        // "선택" 부분에 대한 속성 설정
        let selectionRange = (text as NSString).range(of: "(선택)")
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16, weight: .regular), range: selectionRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: selectionRange)
        
        return attributedString
    }
}

// MARK: - CollectionView 관련 Extension
extension AddVerseVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 // 예시로 10개의 아이템을 반환
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor(named: "LightSkyBlue") // 예시로 셀의 배경색을 파란색으로 설정
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 40) // 예시로 셀의 크기를 설정
    }
}

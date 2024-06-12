//
//  AddVerseVC.swift
//  Dokgi
//
//  Created by 한철희 on 6/4/24.
//

import SnapKit
import Then
import UIKit
import Vision
import VisionKit

protocol BookSelectionDelegate: AnyObject {
    func didSelectBook(_ book: Item)
}

class AddVerseVC: UIViewController, UITextFieldDelegate {
    
    var selectedBook: Item?
    var images: [UIImage] = []
    var keywords: [String] = ["Example1", "Example2", "Example3", "Example4", "Example5"]
    weak var delegate: BookSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        keywordCollectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.reuseIdentifier)
        keywordField.delegate = self
        setupViews()
        initLayout()
        setupActions()
        setupHideKeyboardOnTap()
    }
    
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    let viewInScroll = UIView()
    
    let scanButton = UIButton().then {
        $0.setTitle("구절 스캔", for: .normal)
        $0.titleLabel?.font = Pretendard.bold.dynamicFont(style: .subheadline)
        $0.setTitleColor(UIColor(named: "CharcoalBlue"), for: .normal)
        $0.backgroundColor = .lightSkyBlue
        $0.setImage(UIImage(named: "camera.viewfinder")?.withTintColor(UIColor(named: "CharcoalBlue") ?? .black, renderingMode: .alwaysOriginal), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        $0.layer.cornerRadius = 18
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
        $0.titleLabel?.font = Pretendard.bold.dynamicFont(style: .headline)
        config.baseForegroundColor = .white
        config.baseBackgroundColor = UIColor(named: "CharcoalBlue")
        config.image = UIImage(systemName: "magnifyingglass")
        config.imagePadding = 8
        config.imagePlacement = .leading
        $0.configuration = config
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    var imageView = UIImageView().then {
        $0.image = UIImage(named: "emptyImage")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = UIColor(named: "LightGray")
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 15
    }
    
    var titleLabel = UILabel().then {
        $0.text = "책 제목"
        $0.font = Pretendard.bold.dynamicFont(style: .body)
        $0.textColor = UIColor(named: "BookTextGray")
        $0.numberOfLines = 2
    }
    
    var authorLabel = UILabel().then {
        $0.text = "저자"
        $0.font = Pretendard.bold.dynamicFont(style: .body)
        $0.textColor = UIColor(named: "BookTextGray")
    }
    
    lazy var verseTextView = UITextView().then {
        $0.text = "텍스트를 입력하세요"
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        $0.font = Pretendard.bold.dynamicFont(style: .footnote)
        $0.textColor = .placeholderText
        $0.layer.cornerRadius = 8
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
    }
    
    let characterCountLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = Pretendard.bold.dynamicFont(style: .footnote)
    }
    
    let keywordLabel = UILabel().then {
        $0.attributedText = AddVerseVC.createAttributedString(for: "키워드 (선택)")
        $0.textAlignment = .left
    }
    
    let keywordField = UITextField().then {
        $0.placeholder = "키워드를 입력해 주세요"
        $0.borderStyle = .roundedRect
        $0.layer.masksToBounds = true
    }
    
    lazy var keywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return layout
    }()).then {
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
        $0.showsHorizontalScrollIndicator = false
    }
    
    let pageLabel = UILabel().then {
        $0.text = "페이지"
        $0.font = Pretendard.bold.dynamicFont(style: .headline)
        $0.textColor = .black
    }
    
    let pageNumberTextField = UITextField().then {
        $0.placeholder = "페이지 수"
        $0.font = Pretendard.bold.dynamicFont(style: .subheadline)
        $0.borderStyle = .roundedRect
    }
    
    let percentageButton = UIButton().then {
        $0.setTitle("%", for: .normal)
        $0.titleLabel?.font = Pretendard.bold.dynamicFont(style: .footnote)
        $0.setTitleColor(UIColor(named: "CharcoalBlue"), for: .normal)
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1.0 // 테두리 두께 설정
        if let charcoalBlueColor = UIColor(named: "CharcoalBlue") {
            $0.layer.borderColor = charcoalBlueColor.cgColor
        }
    }

    let pageButton = UIButton().then {
        $0.setTitle("Page", for: .normal)
        $0.titleLabel?.font = Pretendard.bold.dynamicFont(style: .footnote)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1.0
        if let charcoalBlueColor = UIColor(named: "CharcoalBlue") {
            $0.layer.borderColor = charcoalBlueColor.cgColor
        }
    }
    
    let recordButton = UIButton().then {
        $0.setTitle("기록 하기", for: .normal)
        $0.titleLabel?.font = Pretendard.bold.dynamicFont(style: .headline)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "CharcoalBlue")
        $0.layer.cornerRadius = 8
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(viewInScroll)
        viewInScroll.addSubview(scanButton)
        viewInScroll.addSubview(infoView)
        infoView.addSubview(imageView)
        infoView.addSubview(titleLabel)
        infoView.addSubview(authorLabel)
        infoView.addSubview(overlayView)
        overlayView.addSubview(searchButton)
        viewInScroll.addSubview(verseTextView)
        viewInScroll.addSubview(characterCountLabel)
        viewInScroll.addSubview(keywordLabel)
        viewInScroll.addSubview(keywordField)
        viewInScroll.addSubview(keywordCollectionView)
        viewInScroll.addSubview(pageLabel)
        viewInScroll.addSubview(pageNumberTextField)
        viewInScroll.addSubview(percentageButton)
        viewInScroll.addSubview(pageButton)
        viewInScroll.addSubview(recordButton)
    }
    
    // MARK: - 제약조건
    func initLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        viewInScroll.snp.makeConstraints {
            $0.edges.equalTo(scrollView.snp.edges)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(1000) // 임시로 1000으로 설정
        }
        
        scanButton.snp.makeConstraints {
            $0.top.equalTo(viewInScroll.snp.top).offset(10)
            $0.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
            $0.width.equalTo(112)
            $0.height.equalTo(35)
        }
        
        infoView.snp.makeConstraints {            
            $0.centerY.equalTo(viewInScroll.snp.top).offset(170)
            $0.horizontalEdges.equalTo(viewInScroll).inset(16)
            $0.height.equalTo(200)
        }
        
        overlayView.snp.makeConstraints {
            $0.edges.equalTo(infoView)
        }
        
        searchButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(35)
            $0.horizontalEdges.equalTo(viewInScroll).inset(140)
        }
        
        imageView.snp.makeConstraints {
            $0.leading.equalTo(infoView.snp.leading).offset(16)
            $0.centerY.equalTo(infoView.snp.centerY)
            $0.width.equalTo(120)
            $0.height.equalTo(170)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.centerY.equalTo(infoView.snp.centerY).offset(-16)
            $0.trailing.equalTo(infoView.snp.trailing).offset(-16)
        }
        
        authorLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.trailing.equalTo(infoView.snp.trailing).offset(-16)
        }
        
        verseTextView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(329)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(verseTextView.snp.trailing).offset(-16)
            $0.bottom.equalTo(verseTextView.snp.bottom).offset(-8)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.top.equalTo(verseTextView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        keywordField.snp.makeConstraints {
            $0.top.equalTo(keywordLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(33)
        }
        
        keywordCollectionView.snp.makeConstraints {
            $0.top.equalTo(keywordField.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(35)
        }
        
        pageLabel.snp.makeConstraints {
            $0.top.equalTo(keywordCollectionView.snp.bottom).offset(50)
            $0.leading.equalTo(viewInScroll.snp.leading).offset(16)
        }
        
        pageNumberTextField.snp.makeConstraints {
            $0.centerY.equalTo(pageLabel.snp.centerY)
            $0.leading.equalTo(pageLabel.snp.trailing).offset(8)
            $0.width.equalTo(55)
            $0.height.equalTo(30)
        }
        
        percentageButton.snp.makeConstraints {
            $0.centerY.equalTo(pageLabel.snp.centerY)
            $0.trailing.equalTo(pageButton.snp.leading).offset(-8)
            $0.width.equalTo(60)
            $0.height.equalTo(pageLabel.snp.height)
        }
        
        pageButton.snp.makeConstraints {
            $0.centerY.equalTo(percentageButton.snp.centerY)
            $0.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
            $0.width.equalTo(60)
            $0.height.equalTo(percentageButton.snp.height)
        }
        
        recordButton.snp.makeConstraints {
            $0.top.equalTo(pageLabel.snp.bottom).offset(60)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        scrollView.contentSize = viewInScroll.bounds.size
    }
    
    func setupActions() {
        scanButton.addTarget(self, action: #selector(scanButtonTapped(_:)), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside)
        percentageButton.addTarget(self, action: #selector(percentageButtonTapped(_:)), for: .touchUpInside)
        pageButton.addTarget(self, action: #selector(pageButtonTapped(_:)), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(recordButtonTapped(_:)), for: .touchUpInside)
    }
    
    func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func visionKit() {
        let scan = VNDocumentCameraViewController()
        scan.delegate = self
        self.present(scan, animated: true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func scanButtonTapped(_ sender: UIButton) {
        images = []
        visionKit()
    }
    
    @objc func searchButtonTapped(_ sender: UIButton) {
        let bookSearchVC = BookSearchVC()
        bookSearchVC.delegate = self
        present(bookSearchVC, animated: true, completion: nil)
    }
    
    @objc func percentageButtonTapped(_ sender: UIButton) {
        print("% 버튼이 눌렸습니다.")
    }
    
    @objc func pageButtonTapped(_ sender: UIButton) {
        // 구절 스캔 버튼이 눌렸을 때 실행될 액션 구현
        print("page 버튼이 눌렸습니다.")
    }
    
    @objc func recordButtonTapped(_ sender: UIButton) {
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
    
    private func displayBookInfo() {
        if let book = selectedBook {
            titleLabel.text = book.title
            titleLabel.textColor = .black
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            authorLabel.text = book.author
            if let url = URL(string: book.image) {
                imageView.kf.setImage(with: url)
                imageView.layer.cornerRadius = 15
            }
        }
        overlayView.isHidden = true
        searchButton.isHidden = true
    }
    
    func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else {
            fatalError("UIImage에서 CGImage를 얻을 수 없습니다.")
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { [weak self] (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("텍스트 인식 오류: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }
            
            let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
            DispatchQueue.main.async {
                self?.verseTextView.text = recognizedStrings.joined(separator: "\n")
            }
        }
        let revision3 = VNRecognizeTextRequestRevision3
        request.revision = revision3
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko-KR"]
        request.usesLanguageCorrection = true
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("텍스트 인식 수행 실패: \(error.localizedDescription)")
        }
    }
    func removeKeyword(at indexPath: IndexPath) {
        keywords.remove(at: indexPath.item)
        keywordCollectionView.deleteItems(at: [indexPath])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return key pressed") // 로그 추가
        if let keyword = textField.text, !keyword.isEmpty {
            print("Keyword: \(keyword)") // 로그 추가
            keywords.append(keyword) // 키워드를 배열에 추가
            keywordCollectionView.reloadData() // 컬렉션 뷰 업데이트
            textField.text = "" // 텍스트 필드 비우기
        }
        textField.resignFirstResponder() // 키보드 내리기
        return true
    }
}

// MARK: - CollectionView 관련
extension AddVerseVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordCell", for: indexPath) as? KeywordCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: keywords[indexPath.item])
        cell.backgroundColor = UIColor(named: "LightSkyBlue")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 40)
    }
}

// MARK: - 텍스트뷰 placeholder 관련
extension AddVerseVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .placeholderText else { return }
        textView.textColor = .label
        textView.text = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "텍스트를 입력하세요"
            textView.textColor = .placeholderText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let currentCount = textView.text.count
        characterCountLabel.text = "\(currentCount)/200"
        
        // 최대 200자 제한
        if currentCount > 200 {
            textView.text = String(textView.text.prefix(200))
            characterCountLabel.text = "200/200"
        }
    }
}


extension AddVerseVC: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let image = scan.imageOfPage(at: 0)
        recognizeText(from: image)
        controller.dismiss(animated: true)
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print("문서 스캔 실패: \(error.localizedDescription)")
        controller.dismiss(animated: true)
    }
}

extension AddVerseVC: BookSelectionDelegate {
    func didSelectBook(_ book: Item) {
        self.selectedBook = book
        displayBookInfo()
    }
}

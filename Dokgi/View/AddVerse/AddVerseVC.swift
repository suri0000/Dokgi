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

class AddVerseVC: UIViewController {
    
    var selectedBook: Item?
    var images: [UIImage] = []
    var keywords: [String] = []
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
    
    let scanButton = UIButton(configuration: .filled(), primaryAction: nil).then {
        $0.configurationUpdateHandler = { button in
            var configuration = button.configuration
            configuration?.title = "구절 스캔"
            configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = Pretendard.bold.dynamicFont(style: .subheadline)
                return outgoing
            }
            configuration?.baseForegroundColor = UIColor(named: "CharcoalBlue")
            configuration?.baseBackgroundColor = .lightSkyBlue
            configuration?.image = UIImage(named: "camera.viewfinder")?.withTintColor(UIColor(named: "CharcoalBlue") ?? .black, renderingMode: .alwaysOriginal)
            configuration?.imagePadding = 10
            button.configuration = configuration
        }
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
        $0.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.textColor = .placeholderText
        $0.layer.cornerRadius = 8
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
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
        $0.font = Pretendard.semibold.dynamicFont(style: .headline)
        $0.textColor = .black
    }
    
    let pageNumberTextField = UITextField().then {
        $0.placeholder = "페이지 수"
        $0.font = Pretendard.regular.dynamicFont(style: .subheadline)
        $0.borderStyle = .roundedRect
    }
    
    let segmentedControl = UISegmentedControl(items: ["%", "Page"]).then {
        $0.selectedSegmentIndex = 0 // 초기 선택 세그먼트 인덱스
        // 선택되지 않은 상태의 폰트 및 색상 설정
        $0.setTitleTextAttributes([
            .font: Pretendard.bold.dynamicFont(style: .footnote),
            .foregroundColor: UIColor(named: "CharcoalBlue") ?? .black
        ], for: .normal)
        
        // 선택된 상태의 폰트 및 색상 설정
        $0.setTitleTextAttributes([
            .font: Pretendard.bold.dynamicFont(style: .footnote),
            .foregroundColor: UIColor.white
        ], for: .selected)
        
        $0.selectedSegmentTintColor = UIColor(named: "CharcoalBlue")
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 0.7
        $0.layer.borderColor = UIColor(named: "CharcoalBlue")?.cgColor
        $0.clipsToBounds = true
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
        viewInScroll.addSubview(pencilImageView)
        viewInScroll.addSubview(keywordLabel)
        viewInScroll.addSubview(keywordField)
        viewInScroll.addSubview(keywordCollectionView)
        viewInScroll.addSubview(pageLabel)
        viewInScroll.addSubview(pageNumberTextField)
        viewInScroll.addSubview(segmentedControl)
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
            $0.bottom.equalTo(verseTextView.snp.bottom).offset(-16)
        }
        
        pencilImageView.snp.makeConstraints {
            $0.bottom.equalTo(verseTextView.snp.bottom).offset(-8)
            $0.leading.equalTo(verseTextView.snp.leading).offset(8)
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
        
        segmentedControl.snp.makeConstraints {
            $0.centerY.equalTo(pageLabel.snp.centerY)
            $0.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
            $0.height.equalTo(30)
            $0.width.equalTo(120)
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
    
    @objc func recordButtonTapped(_ sender: UIButton) {
        print("기록하기 버튼이 눌렸습니다.")
        if searchButton.isHidden == false {
            showAlert(title: "책 정보 기록", message: "책 검색을 눌러 책 정보를 기록해주세요")
            return
        }
        
        if verseTextView.text.isEmpty || verseTextView.text == "텍스트를 입력하세요" {
            showAlert(title: "구절 입력", message: "구절을 입력해 주세요")
            return
        }
        
        if pageNumberTextField.text?.isEmpty == true {
            showAlert(title: "페이지", message: "페이지를 입력해 주세요")
            return
        }
        
        guard let book = selectedBook,
              let pageNumberText = pageNumberTextField.text,
              let pageNumber = Int(pageNumberText),
              !verseTextView.text.isEmpty,
              verseTextView.text != "텍스트를 입력하세요" else {
            showAlert(title: "경고", message: "모든 필수 정보를 입력해주세요.")
            return
        }
        
        let pageType: String
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            pageType = "%"
        case 1:
            pageType = "Page"
        default:
            pageType = "Page"
        }
        
        // 현재 날짜 정보 가져오기
        let currentDate = Date()

        // Verse 인스턴스 생성
        let verse = Verse(book: book, text: verseTextView.text, pageNumber: pageNumber, pageType: pageType, keywords: keywords, date: currentDate)
        
        // TODO: 생성된 Verse 인스턴스를 어딘가에 저장하기
        print(verse)
        // 저장이 완료되었다는 메시지
        showAlert(title: "저장 완료", message: "구절이 성공적으로 저장되었습니다.")
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 텍스트 속성을 설정하는 함수
    private static func createAttributedString(for text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        
        // "키워드" 부분에 대한 속성 설정
        let keywordRange = (text as NSString).range(of: "키워드")
        attributedString.addAttribute(.font, value: Pretendard.semibold.dynamicFont(style: .callout), range: keywordRange)
        
        // "선택" 부분에 대한 속성 설정
        let selectionRange = (text as NSString).range(of: "(선택)")
        attributedString.addAttribute(.font, value: Pretendard.regular.dynamicFont(style: .callout), range: selectionRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: selectionRange)
        
        return attributedString
    }
    
    private func displayBookInfo() {
        if let book = selectedBook {
            titleLabel.text = book.title
            titleLabel.textColor = .black
            titleLabel.font = Pretendard.semibold.dynamicFont(style: .headline)
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
}
// MARK: - UITextFieldDelegate
extension AddVerseVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text, !keyword.isEmpty {
            keywords.append(keyword)
            keywordCollectionView.reloadData()
            textField.text = ""
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - CollectionView
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
            // 특정 indexPath에 해당하는 키워드의 문자열을 가져옵니다.
            let keyword = keywords[indexPath.item]
            
            // 문자열의 크기를 계산합니다.
            let font = Pretendard.regular.dynamicFont(style: .callout)
            let attributes = [NSAttributedString.Key.font: font]
            let textSize = (keyword as NSString).size(withAttributes: attributes)
            
            // 셀의 너비를 계산하고 반환합니다. 좌우 여백을 추가하여 보다 깔끔하게 보이도록 합니다.
            let cellWidth = textSize.width + 35
            let cellHeight: CGFloat = 34 // 셀의 높이
            return CGSize(width: cellWidth, height: cellHeight)
        }
}

// MARK: - 텍스트뷰 placeholder
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

// MARK: - 스캔
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

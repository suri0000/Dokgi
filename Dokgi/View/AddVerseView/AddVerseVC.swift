//
//  AddVerseVC.swift
//  Dokgi
//
//  Created by 한철희 on 6/4/24.
//

import BetterSegmentedControl
import Kingfisher
import SnapKit
import Then
import UIKit
import Vision
import VisionKit

protocol BookSelectionDelegate: AnyObject {
    func didSelectBook(_ book: Item)
}

class AddVerseVC: UIViewController {
    
    let viewModel = AddVerseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        keywordCollectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.reuseIdentifier)
        keywordField.delegate = self
        setupViews()
        initLayout()
        setupActions()
        viewModel.setupHideKeyboardOnTap(view: view)
        updateCharacterCountLabel()
        setUserInfoTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
    
    lazy var verseTextView = UITextView().then {
        $0.text = "텍스트를 입력하세요"
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        $0.font = Pretendard.regular.dynamicFont(style: .callout)
        $0.textColor = .placeholderText
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
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
        let placeholder = "키워드를 입력해 주세요"
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
    
    let betterSegmentedControl: BetterSegmentedControl = {
        let segmentedControl = BetterSegmentedControl(
            frame: .zero,
            segments: LabelSegment.segments(
                withTitles: ["Page", "%"],
                normalFont: Pretendard.semibold.dynamicFont(style: .footnote),
                normalTextColor: .charcoalBlue,
                selectedFont: Pretendard.semibold.dynamicFont(style: .footnote),
                selectedTextColor: .white
            ),
            options: [
                .indicatorViewBackgroundColor(.charcoalBlue),
                .cornerRadius(15),
                .backgroundColor(.white)
            ]
        )

        // 초기 세그먼트 인덱스 설정
        segmentedControl.setIndex(0, animated: false, shouldSendValueChangedEvent: false)
        
        return segmentedControl
    }()

    let ControlBoder = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.charcoalBlue.cgColor
    }
    
    let recordButton = UIButton().then {
        $0.setTitle("기록 하기", for: .normal)
        $0.titleLabel?.font = Pretendard.bold.dynamicFont(style: .headline)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .charcoalBlue
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
        viewInScroll.addSubview(ControlBoder)
        viewInScroll.addSubview(betterSegmentedControl)
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
            $0.top.equalTo(viewInScroll.snp.top).offset(16)
            $0.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
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
        }
        
        imageView.snp.makeConstraints {
            $0.leading.equalTo(infoView.snp.leading)
            $0.centerY.equalTo(infoView.snp.centerY)
            $0.width.equalTo(103)
            $0.height.equalTo(146)
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
            $0.height.equalTo(36)
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
        
        betterSegmentedControl.snp.makeConstraints {
            $0.centerY.equalTo(pageLabel.snp.centerY)
            $0.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
            $0.height.equalTo(30)
            $0.width.equalTo(120)
        }
        
        ControlBoder.snp.makeConstraints {
            $0.centerY.equalTo(pageLabel.snp.centerY)
            $0.trailing.equalTo(viewInScroll.snp.trailing).offset(-15)
            $0.height.equalTo(32)
            $0.width.equalTo(122)
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
        betterSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        keywordField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func scanButtonTapped(_ sender: UIButton) {
        viewModel.visionKit(presenter: self)
    }

    
    @objc func searchButtonTapped(_ sender: UIButton) {
        let bookSearchVC = BookSearchVC()
        bookSearchVC.delegate = self
        present(bookSearchVC, animated: true, completion: nil)
    }
    
    @objc func segmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        switch sender.index {
        case 0:
            viewModel.pageType = "Page"
        case 1:
            viewModel.pageType = "%"
        default:
            break
        }
    }
    
    @objc func recordButtonTapped(_ sender: UIButton) {
        print("기록하기 버튼이 눌렸습니다.")
        if searchButton.isHidden == false {
            viewModel.showAlert(presenter: self, title: "책 정보 기록", message: "책 검색을 눌러 책 정보를 기록해주세요")
            return
        }
        
        if verseTextView.text.isEmpty || verseTextView.text == "텍스트를 입력하세요" {
            viewModel.showAlert(presenter: self, title: "구절 입력", message: "구절을 입력해 주세요")
            return
        }
        
        if pageNumberTextField.text?.isEmpty == true {
            viewModel.showAlert(presenter: self, title: "페이지", message: "페이지를 입력해 주세요")
            return
        }
        
        viewModel.saveVerse(selectedBook: viewModel.selectedBook,
                            verseText: verseTextView.text ?? "",
                            pageNumberText: pageNumberTextField.text ?? "",
                            pageType: viewModel.pageType,
                            keywords: viewModel.keywords) { success in
            if success {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.viewModel.showAlert(presenter: self, title: "경고", message: "모든 필수 정보를 입력해주세요.")
            }
        }
        

    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func setUserInfoTextField() {
        keywordField.backgroundColor = .white
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: keywordField.frame.height))
        
        keywordField.leftView = paddingView
        keywordField.leftViewMode = .always
        
        keywordField.rightView = paddingView
        keywordField.rightViewMode = .always
    }
    
    // 초기 텍스트뷰 글자 수 설정
    func updateCharacterCountLabel() {
        let currentCount = verseTextView.text == "텍스트를 입력하세요" ? 0 : verseTextView.text.count
        characterCountLabel.text = "\(currentCount)/200"
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
    
    func displayBookInfo() {
        if let book = viewModel.selectedBook {
            titleLabel.text = book.title
            titleLabel.font = Pretendard.semibold.dynamicFont(style: .headline)
            titleLabel.textColor = .black
            authorLabel.text = book.author
            if let url = URL(string: book.image) {
                imageView.kf.setImage(with: url)
                imageView.contentMode = .scaleAspectFill
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
        viewModel.keywords.remove(at: indexPath.item)
        keywordCollectionView.deleteItems(at: [indexPath])
    }
}

// MARK: - UITextFieldDelegate
extension AddVerseVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text, !keyword.isEmpty {
            viewModel.keywords[viewModel.keywords.count - 1] = keyword
            keywordCollectionView.reloadData()
        }
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            viewModel.keywords.append("")
            keywordCollectionView.reloadData()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if viewModel.keywords.isEmpty {
                viewModel.keywords.append(text)
            } else {
                viewModel.keywords[viewModel.keywords.count - 1] = text
            }
            keywordCollectionView.reloadData()
        }
    }
}

// MARK: - CollectionView
extension AddVerseVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordCell", for: indexPath) as? KeywordCell else {
            return UICollectionViewCell()
        }
        
        let reversedIndex = viewModel.keywords.count - 1 - indexPath.item
        cell.configure(with: viewModel.keywords[reversedIndex])
        cell.backgroundColor = .lightSkyBlue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let reversedIndex = viewModel.keywords.count - 1 - indexPath.item
        let keyword = viewModel.keywords[reversedIndex]
        let font = Pretendard.regular.dynamicFont(style: .callout)
        let attributes = [NSAttributedString.Key.font: font]
        let textSize = (keyword as NSString).size(withAttributes: attributes)
        let cellWidth = textSize.width + 35
        let cellHeight: CGFloat = 34
        
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
        updateCharacterCountLabel()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let currentCount = textView.text.count
        characterCountLabel.text = "\(currentCount)/200"
        
        // 최대 200자 제한
        if currentCount > 200 {
            textView.text = String(textView.text.prefix(200))
            characterCountLabel.text = "200/200"
        } else {
            characterCountLabel.text = "\(currentCount)/200"
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

// MARK: - 데이터 전달
extension AddVerseVC: BookSelectionDelegate {
    func didSelectBook(_ book: Item) {
        viewModel.selectedBook = book
        displayBookInfo()
    }
}

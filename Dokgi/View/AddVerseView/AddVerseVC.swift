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
    let containerView = AddVerseContainerView()
    
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.pageSegment.selectedIndex = 0
        setupViews()
        initLayout()
        setupActions()
        updateCharacterCountLabel()
        setUserInfoTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.keywordCollectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.reuseIdentifier)
        containerView.keywordCollectionView.delegate = self
        containerView.keywordCollectionView.dataSource = self
        containerView.keywordField.delegate = self
        containerView.verseTextView.delegate = self
    }
    
    // MARK: - 제약조건
    func initLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.greaterThanOrEqualTo(1000)
        }
    }
    
    func setupActions() {
        containerView.scanButton.addTarget(self, action: #selector(scanButtonTapped(_:)), for: .touchUpInside)
        containerView.searchButton.addTarget(self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside)
        containerView.recordButton.addTarget(self, action: #selector(recordButtonTapped(_:)), for: .touchUpInside)
        containerView.keywordField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        containerView.pageSegment.buttons.enumerated().forEach { index, button in
            button.addTarget(self, action: #selector(pageSegmentButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc func scanButtonTapped(_ sender: UIButton) {
        viewModel.visionKit(presenter: self)
    }
    
    @objc func searchButtonTapped(_ sender: UIButton) {
        let bookSearchVC = BookSearchVC()
        bookSearchVC.delegate = self
        present(bookSearchVC, animated: true, completion: nil)
    }
    
    @objc func pageSegmentButtonTapped(_ sender: UIButton) {
        guard let index = containerView.pageSegment.buttons.firstIndex(of: sender) else { return }
        containerView.pageSegment.selectedIndex = index
        
        switch index {
        case 0:
            viewModel.pageType = "Page"
        case 1:
            viewModel.pageType  = "%"
        default:
            break
        }
    }
    
    @objc func recordButtonTapped(_ sender: UIButton) {
        if containerView.searchButton.isHidden == false {
            viewModel.showAlert(presenter: self, title: "책 정보 기록", message: "책 검색을 눌러 책 정보를 기록해주세요")
            return
        }
        
        if containerView.verseTextView.text.isEmpty || containerView.verseTextView.text == "텍스트를 입력하세요" {
            viewModel.showAlert(presenter: self, title: "구절 입력", message: "구절을 입력해 주세요")
            return
        }
        
        if containerView.pageNumberTextField.text?.isEmpty == true {
            viewModel.showAlert(presenter: self, title: "페이지", message: "페이지를 입력해 주세요")
            return
        }
        
        viewModel.saveVerse(selectedBook: viewModel.selectedBook,
                            verseText: containerView.verseTextView.text ?? "",
                            pageNumberText: containerView.pageNumberTextField.text ?? "",
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
        containerView.keywordField.backgroundColor = .white
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: containerView.keywordField.frame.height))
        containerView.keywordField.leftView = paddingView
        containerView.keywordField.leftViewMode = .always
        containerView.keywordField.rightView = paddingView
        containerView.keywordField.rightViewMode = .always
    }
    
    // 초기 텍스트뷰 글자 수 설정
    func updateCharacterCountLabel() {
        let currentCount = containerView.verseTextView.text == "텍스트를 입력하세요" ? 0 : containerView.verseTextView.text.count
        containerView.characterCountLabel.text = "\(currentCount)/200"
    }
    
    // 텍스트 속성을 설정하는 함수
    static func createAttributedString(for text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        
        // "키워드" 부분에 대한 설정
        let keywordRange = (text as NSString).range(of: "키워드")
        attributedString.addAttributes([.font: Pretendard.semibold.dynamicFont(style: .headline)], range: keywordRange)
        
        // "선택" 부분에 대한 설정
        let selectionRange = (text as NSString).range(of: "(선택)")
        attributedString.addAttributes([.font: Pretendard.regular.dynamicFont(style: .headline), .foregroundColor: UIColor.gray], range: selectionRange)
        
        return attributedString
    }
    
    func displayBookInfo() {
        if let book = viewModel.selectedBook {
            containerView.titleLabel.text = book.title
            containerView.titleLabel.font = Pretendard.semibold.dynamicFont(style: .headline)
            containerView.titleLabel.textColor = .black
            containerView.authorLabel.text = book.author
            if let url = URL(string: book.image) {
                containerView.imageView.kf.setImage(with: url)
                containerView.imageView.contentMode = .scaleAspectFill
            }
        }
        containerView.overlayView.isHidden = true
        containerView.searchButton.isHidden = true
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
                self?.containerView.verseTextView.text = recognizedStrings.joined(separator: "\n")
            }
        }
        request.revision = VNRecognizeTextRequestRevision3
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
        let reversedIndex = viewModel.keywords.count - 1 - indexPath.item
        viewModel.keywords.remove(at: reversedIndex)
        containerView.keywordCollectionView.reloadData()
    }
}

// MARK: - UITextFieldDelegate
extension AddVerseVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let keyword = textField.text, !keyword.isEmpty {
            viewModel.keywords[viewModel.keywords.count - 1] = keyword
            containerView.keywordCollectionView.reloadData()
        }
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            // Only add a new empty keyword if there are no empty ones already
            if !viewModel.keywords.contains("") {
                viewModel.keywords.append("")
                containerView.keywordCollectionView.reloadData()
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if viewModel.keywords.isEmpty {
                viewModel.keywords.append(text)
            } else {
                viewModel.keywords[viewModel.keywords.count - 1] = text
            }
            containerView.keywordCollectionView.reloadData()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        let newText = currentText.replacingCharacters(in: range, with: string)
        return newText.count <= 20
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
        let keyword = viewModel.keywords[reversedIndex]
        cell.configure(with: keyword)
        cell.layer.borderColor = UIColor.lightSkyBlue.cgColor
        cell.layer.borderWidth = 2
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
        updateCharacterCountLabel()
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
        containerView.characterCountLabel.text = "\(currentCount)/200"
        
        if currentCount > 200 {
            textView.text = String(textView.text.prefix(200))
            containerView.characterCountLabel.text = "200/200"
        } else {
            containerView.characterCountLabel.text = "\(currentCount)/200"
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

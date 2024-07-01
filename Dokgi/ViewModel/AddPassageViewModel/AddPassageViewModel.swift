//
//  AddVerseViewModel.swift
//  Dokgi
//
//  Created by 한철희 on 6/17/24.
//

import UIKit
import Vision
import VisionKit

class AddPassageViewModel {
    // MARK: - Properties
    var onRecognizedTextUpdate: ((String) -> Void)?
    weak var delegate: BookSelectionDelegate?
    var selectedBook: Item?
    var images: [UIImage] = []
    var keywords: [String] = []
    var pageType: Bool = true
    var showUi: Bool = false
    var recognizedText: String = "" {
        didSet {
            onRecognizedTextUpdate?(recognizedText)
        }
    }
    
    // MARK: - func
    func removeEmptyKeywords() {
        keywords = keywords.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    func visionKit(presenter: UIViewController) {
        let scan = VNDocumentCameraViewController()
        scan.delegate = presenter as? VNDocumentCameraViewControllerDelegate
        presenter.present(scan, animated: true)
    }
    
    func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else {
            fatalError("UIImage에서 CGImage를 얻을 수 없습니다.")
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = createTextRecognitionRequest()
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("텍스트 인식 수행 실패: \(error.localizedDescription)")
        }
    }
    
    private func createTextRecognitionRequest() -> VNRecognizeTextRequest {
        return VNRecognizeTextRequest { [weak self] (request, error) in
            self?.handleTextRecognition(request: request, error: error)
        }.apply {
            $0.revision = VNRecognizeTextRequestRevision3
            $0.recognitionLevel = VNRequestTextRecognitionLevel.accurate
            $0.recognitionLanguages = ["ko-KR"]
            $0.usesLanguageCorrection = true
        }
    }
    
    private func handleTextRecognition(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
            print("텍스트 인식 오류: \(error?.localizedDescription ?? "알 수 없는 오류")")
            return
        }
        
        let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
        let joinedString = recognizedStrings.joined(separator: "\n")
        let limitedString = String(joinedString.prefix(200))
        
        DispatchQueue.main.async {
            self.recognizedText = limitedString
        }
    }
    
    func validatePassage(verseText: String, pageNumberText: String?) -> (Bool, String) {
        if selectedBook == nil {
            return (false, "책 검색을 눌러 책 정보를 기록해주세요")
        }
        
        if verseText.isEmpty || verseText == "텍스트를 입력하세요" {
            return (false, "구절을 입력해 주세요")
        }
        
        if verseText.count > 200 {
            return (false, "구절을 200자 이하로 작성해 주세요")
        }
        
        guard let pageNumberText = pageNumberText, let pageNumber = Int(pageNumberText) else {
            return (false, "숫자를 입력하세요.")
        }
        
        if pageType == true && pageNumber <= 0 {
            return (false, "0 이상을 입력하세요.")
        } else if pageType == false && (pageNumber < 0 || pageNumber > 100) {
            return (false, "0이상 100이하를 입력하세요.")
        }
        
        return (true, "")
    }
    
    
    func savePassage(selectedBook: Item?, passageText: String, pageNumberText: String?, pageType: Bool, keywords: [String], completion: @escaping (Bool) -> Void) {
        guard let book = selectedBook,
              let pageNumberText = pageNumberText,
              let pageNumber = Int(pageNumberText),
              !passageText.isEmpty,
              passageText != "텍스트를 입력하세요" else {
            completion(false)
            return
        }
        
        let currentDate = Date()
        
        // Verse 인스턴스 생성
        let passage = Passage(title: book.title, passage: passageText, page: pageNumber, pageType: pageType, date: currentDate, keywords: keywords)
        
        CoreDataManager.shared.saveData(author: book.formattedAuthor, image: book.image, passage: passage)
        completion(true)
    }
    
    func updateCharacterCountText(for text: String?, label: UILabel) {
        let count = text?.count ?? 0
        let currentCount = text == "텍스트를 입력하세요" ? 0 : count
        label.text = "\(currentCount)/200"
        label.textColor = count > 200 ? .red : .textFieldGray
    }
}

// MARK: - extension
private extension VNRecognizeTextRequest {
    func apply(configure: (VNRecognizeTextRequest) -> Void) -> VNRecognizeTextRequest {
        configure(self)
        return self
    }
}

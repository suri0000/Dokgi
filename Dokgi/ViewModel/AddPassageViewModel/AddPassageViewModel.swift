//
//  AddVerseViewModel.swift
//  Dokgi
//
//  Created by 한철희 on 6/17/24.
//

import UIKit
import VisionKit

class AddPassageViewModel {
    // MARK: - Properties
    weak var delegate: BookSelectionDelegate?
    var selectedBook: Item?
    var images: [UIImage] = []
    var keywords: [String] = []
    var pageType: String = "Page"
    var recognizedText: String = ""
    
    // MARK: - ViewModel Logic
    func visionKit(presenter: UIViewController) {
        let scan = VNDocumentCameraViewController()
        scan.delegate = presenter as? VNDocumentCameraViewControllerDelegate
        presenter.present(scan, animated: true)
    }
    
    func saveVerse(selectedBook: Item?, verseText: String, pageNumberText: String?, pageType: String, keywords: [String], completion: @escaping (Bool) -> Void) {
        guard let book = selectedBook,
              let pageNumberText = pageNumberText,
              let pageNumber = Int(pageNumberText),
              !verseText.isEmpty,
              verseText != "텍스트를 입력하세요" else {
            completion(false)
            return
        }
        
        let currentDate = Date()
        
        // Verse 인스턴스 생성
        let verse = Verse(name: book.title, author: book.author, image: book.image, text: verseText, pageNumber: pageNumber, pageType: pageType, keywords: keywords, date: currentDate)
        
        CoreDataManager.shared.saveData(verse: verse)
        completion(true)
    }
}

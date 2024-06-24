//
//  ParagraphViewModel.swift
//  Dokgi
//
//  Created by 예슬 on 6/17/24.
//

import Foundation
import RxCocoa
import RxSwift

class PassageViewModel {
    var disposeBag = DisposeBag()
    var passageData = BehaviorRelay<[(String, Date)]>(value: [("", Date())])
    var detailPassage = BehaviorRelay<Verse>(value: Verse(name: "", author: "", image: "", text: "", pageNumber: 1, pageType: "P", keywords: [], date: Date()))
    var isFiltering = BehaviorRelay<Bool>(value: false)
    var searchBarText = BehaviorRelay<String>(value: "")
    
    init() {
        CoreDataManager.shared.bookData
            .map { $0.map {
                return ($0.text, $0.date)
            }
            .sorted { $0.1 > $1.1 }
            }
            .subscribe(onNext: { [weak self] versesAndDates in
                self?.passageData.accept(versesAndDates)
            })
            .disposed(by: disposeBag)
    }
    
    func selectParagraph(text: String, at index: Int) {
            let selectedText = text
            if let selectedVerse = CoreDataManager.shared.bookData.value.first(where: { $0.text == selectedText }) {
                detailPassage.accept(selectedVerse)
            }
        }
}

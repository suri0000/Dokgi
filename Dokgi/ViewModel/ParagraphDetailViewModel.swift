//
//  ParagraphDetailViewModel.swift
//  Dokgi
//
//  Created by 송정훈 on 6/12/24.
//

import Foundation
import RxCocoa
import RxSwift

class ParagraphDetailViewModel {
    var detailParagraph = BehaviorRelay<Verse>(value: Verse(name: "", author: "", image: "", text: "", pageNumber: 1, pageType: "%", keywords: [], date: Date()))
    
    func deleteDetailKeyword(keyword: Int) {
        var verse = self.detailParagraph.value
        verse.keywords.remove(at: keyword)
        detailParagraph.accept(verse)
    }
    
    func addDetailKeyword(keyword: String) {
        var verse = self.detailParagraph.value
        verse.keywords.insert(keyword, at: 0)
        detailParagraph.accept(verse)
    }
    
    func saveDetail(paragraph: String) {
        var verse = self.detailParagraph.value
        verse.text = paragraph
        CoreDataManager.shared.updateData(verse: verse)
    }
}

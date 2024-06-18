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
    var keywords = BehaviorRelay<[String]>(value: [])
    
    func deleteDetailKeyword(keyword: Int) {
        var tmp = self.keywords.value
        if tmp.isEmpty == false {
            tmp.remove(at: keyword)
        }
        keywords.accept(tmp)
    }
    
    func updateDetailKeyword(keyword: String) {
        var keywordTmp = self.keywords.value
        if keywordTmp.isEmpty == false && keyword != "" {
            keywordTmp[0] = keyword
        }
        keywords.accept(keywordTmp)
    }
    
    func addDetailKeyword(keyword: String) {
        var keywordTmp = self.keywords.value
        keywordTmp.insert(keyword, at: 0)
        keywords.accept(keywordTmp)
    }
    
    func saveDetail(paragraph: String, page: String, pageType: Int) {
        var verse = self.detailParagraph.value
        verse.text = paragraph
        verse.keywords = keywords.value.filter{ $0 != "" }
        verse.pageNumber = Int(page) ?? 0
        verse.pageType = pageType == 0 ? "%" : "Page"
        detailParagraph.accept(verse)
        CoreDataManager.shared.updateData(verse: verse)
        CoreDataManager.shared.readData()
    }
}

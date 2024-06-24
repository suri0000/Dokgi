//
//  ParagraphDetailViewModel.swift
//  Dokgi
//
//  Created by 송정훈 on 6/12/24.
//

import Foundation
import RxCocoa
import RxSwift

class PassageDetailViewModel {
    var detailPassage = BehaviorRelay<Verse>(value: Verse(name: "", author: "", image: "", text: "", pageNumber: 1, pageType: "%", keywords: [], date: Date()))
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
            if keywordTmp.count <= 10 {
                keywordTmp[0] = keyword
            }
        }
        keywords.accept(keywordTmp)
    }
    
    func addDetailKeyword(keyword: String) {
        var keywordTmp = self.keywords.value
        if keywordTmp.count < 10 {
            keywordTmp.insert(keyword, at: 0)
        }
        keywords.accept(keywordTmp)
    }
    
    func saveDetail(paragraph: String, page: String, pageType: Int) {
        var verse = self.detailPassage.value
        let before = self.detailPassage.value.text
        verse.text = paragraph
        verse.keywords = keywords.value.filter{ $0 != "" }
        verse.pageType = pageType == 0 ? "Page" : "%"
        verse.pageNumber = (pageType == 0 ? Int(page.page()) : Int(page.percent()))!
        detailPassage.accept(verse)
        CoreDataManager.shared.updateData(verse: verse, before: before)
        CoreDataManager.shared.readData()
    }
}

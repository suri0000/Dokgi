//
//  ParagraphDetailViewModel.swift
//  Dokgi
//
//  Created by 송정훈 on 6/12/24.
//

import RxCocoa
import RxSwift
import Foundation

class ParagraphDetailViewModel {
    var detailParagraph = PublishSubject<Verse>()
    let disposeBag = DisposeBag()
    
    var paragraph : Verse?
    var previous = ""
    
    func deleteDetailKeyword(keyword: Int) {
        paragraph?.keywords.remove(at: keyword)
    }
    
    func addDetailKeyword(keyword: String) {
        paragraph?.keywords.insert(keyword, at: 0)
    }
    
    func saveDetail(str: String) {
        guard var paragraph = self.paragraph else { return }
        
        paragraph.text = str
        self.detailParagraph.onNext(paragraph)
        CoreDataManager.shared.updateData(verse: paragraph)
    }
}

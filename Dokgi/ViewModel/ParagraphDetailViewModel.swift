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
    var detailParagraph = PublishSubject<Paragraph>()
    let disposeBag = DisposeBag()
    
    var paragraph : Paragraph?
    var previous = ""
    
    func deleteDetailKeyword(keyword: Int) {
        paragraph?.keyword.remove(at: keyword)
    }
    
    func addDetailKeyword(keyword: String) {
        paragraph?.keyword.insert(keyword, at: 0)
    }
    
    func saveDetail(str: String) {
        guard var paragraph = self.paragraph else { return }
        
        paragraph.paragraph = str
        self.detailParagraph.onNext(paragraph)
        CoreDataManager.shared.updateParagraph(paragraph: paragraph, text: self.previous)
    }
}

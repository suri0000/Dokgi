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
    static var detailParagraph = PublishRelay<Paragraph>()
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
        ParagraphDetailViewModel.detailParagraph.accept(paragraph)
        CoreDataManager.shared.updateParagraph(paragraph: paragraph, text: self.previous)
    }
}

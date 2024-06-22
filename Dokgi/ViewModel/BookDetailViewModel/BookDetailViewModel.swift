//
//  BookDetailViewModel.swift
//  Dokgi
//
//  Created by 예슬 on 6/13/24.
//

import Foundation
import RxCocoa

class BookDetailViewModel {
    
    static let shared = BookDetailViewModel()
    var bookInfo = BehaviorRelay(value: Verse(name: "", author: "", image: "", text: "", pageNumber: 0, pageType: "", keywords: [], date: Date()))
    var passagesData = BehaviorRelay(value: [Passage(text: "", pageType: "", pageNumber: 0)])
    
    func recordDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        let recordDate =  dateFormatter.string(from: bookInfo.value.date)
        
        return recordDate
    }
    
    func makePassageDateOfBook() {
        let sameTitleBook =  CoreDataManager.shared.bookData.value.filter { $0.name == bookInfo.value.name }
        passagesData.accept(sameTitleBook.map { book in
            Passage(text: book.text, pageType: book.pageType, pageNumber: book.pageNumber)
        })
    }
    
    func pageTypeToP(_ pageType: String) -> String {
        if pageType == "Page" || pageType == "page" {
            return "P"
        }
        
        return pageType
    }
    
    func makeAddVerseViewData() -> Item {
        let item = Item(title: bookInfo.value.name, image: bookInfo.value.image, author: bookInfo.value.author)
        
        return item
    }
}
//
//struct Passage {
//    var text: String
//    var pageType: String
//    var pageNumber: Int
//}

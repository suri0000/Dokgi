//
//  BookDetailViewModel.swift
//  Dokgi
//
//  Created by 예슬 on 6/13/24.
//

import Foundation

class BookDetailViewModel {
    
    static let shared = BookDetailViewModel()
    var bookInfo: Verse?
    var passagesData: [Passage] = []
    
    func recordDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        let recordDate =  dateFormatter.string(from: bookInfo?.date ?? Date())
        
        return recordDate
    }
    
    func makePassageDateOfBook() {
        let sameTitleBook =  CoreDataManager.shared.bookData.value.filter { $0.name == bookInfo?.name }
        
        passagesData = sameTitleBook.map { book in
            Passage(text: book.text, pageType: book.pageType, pageNumber: book.pageNumber)
        }
    }
    
    func pageTypeToP(_ pageType: String) -> String {
        if pageType == "page" {
            return "P"
        }
        
        return pageType
    }
}

struct Passage {
    var text: String
    var pageType: String
    var pageNumber: Int
}

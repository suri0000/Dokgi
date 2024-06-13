//
//  BookDetailViewModel.swift
//  Dokgi
//
//  Created by 예슬 on 6/13/24.
//

import Foundation
import RxSwift

class BookDetailViewModel {
    static let shared = BookDetailViewModel()
    
    var bookInfo: Verse?
    
    func recordDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        let recordDate =  dateFormatter.string(from: bookInfo?.date ?? Date())
        
        return recordDate
    }
}

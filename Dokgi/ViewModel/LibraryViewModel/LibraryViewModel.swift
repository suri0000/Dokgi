//
//  LibrarySearchViewModel.swift
//  Dokgi
//
//  Created by 송정훈 on 6/18/24.
//

import Foundation
import RxCocoa
import RxSwift

class LibraryViewModel {
    var libraryData = BehaviorRelay<[Book]>(value: [])
    
    func dataLatest() {
        let latestSortedBooks = libraryData.value.sorted {
                    guard let date1 = $0.passages.first?.date, let date2 = $1.passages.first?.date else { return false }
                    return date1 > date2
                }
        self.libraryData.accept(latestSortedBooks)
    }
    
    func dataOldest() {
        let oldestSortedBooks = libraryData.value.sorted {
                    guard let date1 = $0.passages.first?.date, let date2 = $1.passages.first?.date else { return false }
                    return date1 > date2
                }
        self.libraryData.accept(oldestSortedBooks)
    }
}

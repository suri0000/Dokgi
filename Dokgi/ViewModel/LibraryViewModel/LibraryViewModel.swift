//
//  LibrarySearchViewModel.swift
//  Dokgi
//
//  Created by 송정훈 on 6/18/24.
//

import Foundation
import RxCocoa
import RxSwift

final class LibraryViewModel {
    func dataLatest() {
        let latestSortedBooks = CoreDataManager.shared.bookData
            .value.sorted {
                    guard let date1 = $0.passages.first?.date, let date2 = $1.passages.first?.date else { return false }
                    return date1 > date2
                }
        CoreDataManager.shared.bookData.accept(latestSortedBooks)
    }
    
    func dataOldest() {
        let oldestSortedBooks = CoreDataManager.shared.bookData
            .value.sorted {
                    guard let date1 = $0.passages.first?.date, let date2 = $1.passages.first?.date else { return false }
                    return date1 < date2
                }
        CoreDataManager.shared.bookData.accept(oldestSortedBooks)
    }
}

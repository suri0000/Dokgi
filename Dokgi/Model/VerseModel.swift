//
//  VerseModel.swift
//  Dokgi
//
//  Created by 한철희 on 6/12/24.
//

import Foundation

struct Verse {
    let book: Item
    let text: String
    let pageNumber: Int
    let pageType: PageType // 예: .percent 또는 .page
    let keywords: [String] // 키워드 저장

    enum PageType {
        case percent
        case page
    }

    init(book: Item, text: String, pageNumber: Int, pageType: PageType, keywords: [String]) {
        self.book = book
        self.text = text
        self.pageNumber = pageNumber
        self.pageType = pageType
        self.keywords = keywords // 키워드 저장
    }
}


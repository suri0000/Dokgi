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
    let pageType: String
    let keywords: [String]
    let date: Date

    init(book: Item, text: String, pageNumber: Int, pageType: String, keywords: [String], date: Date) {
        self.book = book
        self.text = text
        self.pageNumber = pageNumber
        self.pageType = pageType
        self.keywords = keywords
        self.date = date
    }
}



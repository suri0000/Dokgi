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
    let pageType: PageType
    let keywords: [String]
    let year: Int
    let month: Int
    let day: Int

    enum PageType {
        case percent
        case page
    }

    init(book: Item, text: String, pageNumber: Int, pageType: PageType, keywords: [String], year: Int, month: Int, day: Int) {
            self.book = book
            self.text = text
            self.pageNumber = pageNumber
            self.pageType = pageType
            self.keywords = keywords
            self.year = year
            self.month = month
            self.day = day
        }
}


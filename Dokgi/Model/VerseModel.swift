//
//  VerseModel.swift
//  Dokgi
//
//  Created by 한철희 on 6/12/24.
//

import Foundation

struct Verse {
    let name: String
    let author: String
    let image: String
    var text: String
    let pageNumber: Int
    let pageType: String
    var keywords: [String]
    let date: Date

    init(name: String, author: String, image: String, text: String, pageNumber: Int, pageType: String, keywords: [String], date: Date) {
        self.name = name
        self.author = author
        self.image = image
        self.text = text
        self.pageNumber = pageNumber
        self.pageType = pageType
        self.keywords = keywords
        self.date = date
    }
}



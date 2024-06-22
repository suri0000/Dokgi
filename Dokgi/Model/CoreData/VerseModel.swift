//
//  VerseModel.swift
//  Dokgi
//
//  Created by 한철희 on 6/12/24.
//

import Foundation

struct Book {
    let title: String
    let author: String
    let image: String
    var passages: [Passage]
}

struct Passage {
    let title: String?
    var passage: String
    var page: Int
    var pageType: Bool
    let date: Date
    var keywords: [String]
}

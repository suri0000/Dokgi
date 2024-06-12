//
//  CoreDataModel.swift
//  Dokgi
//
//  Created by 송정훈 on 6/11/24.
//

import Foundation

struct Book {
    let id: Int32
    let name: String
    let author: String
    let image: String
    let paragraphs: [Paragraph]
}

struct Paragraph {
    let bookId: Int32
    let bookName: String
    let bookAuthor: String
    let paragraph: String
    let page: String
    let date: Date
    let keyword: [String]
}

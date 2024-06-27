//
//  BookModel.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/3/24.
//

import Foundation

// MARK: - SearchBookResponse
struct SearchBookResponse: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title, image: String
    let author: String
    
    enum CodingKeys: String, CodingKey {
        case title, image, author
    }
}

extension Item {
    var formattedAuthor: String {
        return author.replacingOccurrences(of: "^", with: ", ")
    }
}


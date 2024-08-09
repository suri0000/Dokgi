//
//  BookManager.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/3/24.
//

import Foundation

final class BookManager {
    static let shared = BookManager()
    private init() {}
    
    private let url = "https://openapi.naver.com/v1/search/book.json"
    private let clientID = Bundle.main.object(forInfoDictionaryKey: "API_ID") as? String
    private let clientKEY = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    
    func fetchBookData(queryValue: String, startIndex: Int = 0, completion: @escaping (Result<SearchBookResponse, Error>) -> Void) {
        
        guard var urlComponents = URLComponents(string: url) else {
            print("Invalid URL")
            return
        }
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: queryValue),
            URLQueryItem(name: "start", value: "\(startIndex)")
        ]
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error \(error)")
                completion(.failure(error))
                return
            }
            guard let data = data else {
                print("No data")
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SearchBookResponse.self, from: data)
                completion(.success(response))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

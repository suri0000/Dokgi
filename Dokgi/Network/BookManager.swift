//
//  BookManager.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/3/24.
//

import Foundation

class BookManager {
    static let shared = BookManager()
    private init() {}

    private let url = "https://openapi.naver.com/v1/search/book.json"
    private let clientID = Bundle.main.object(forInfoDictionaryKey: "API_ID") as? String
    private let clientKEY = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String

    func fetchBookData(queryValue: String, completion: @escaping (Result<SearchBookResponse, Error>) -> Void) {
        
        guard var urlComponents = URLComponents(string: url) else {
            print("Invalid URL")
            return
        }
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: queryValue)
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
            // 에러 처리
            if let error = error {
                print("Error \(error)")
                return
            }
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                // JSON 응답 출력
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Raw JSON response: \(json)")
                }
                
                let response = try JSONDecoder().decode(SearchBookResponse.self, from: data)
                print("response: \(response)")
                completion(.success(response))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}




//
//  BookSearchViewModel.swift
//  Dokgi
//
//  Created by 한철희 on 6/18/24.
//

import Foundation
import Network

class BookSearchViewModel {
    
    private let bookManager = BookManager.shared
    private var monitor: NWPathMonitor?
    
    var searchResults: [Item] = []
    var isLoading = false
    var isLoadingLast = false
    var query: String = ""
    var startIndex: Int = 1
    
    func fetchBooks(query: String, startIndex: Int, completion: @escaping (Result<[Item], Error>) -> Void) {
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            if path.status == .satisfied {
                self.isLoading = true
                self.bookManager.fetchBookData(queryValue: query, startIndex: startIndex) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            completion(.success(response.items))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                        self.isLoading = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noConnection))
                }
            }
            self.monitor?.cancel()
        }
    }
    
    func clearRecentSearches() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.recentSearches.rawValue)
    }
    
    func saveRecentSearch(_ text: String) {
        var recentSearches = loadRecentSearches()
        
        recentSearches.removeAll(where: { $0 == text })
        recentSearches.insert(text, at: 0)
        
        if recentSearches.count > 10 {
            recentSearches.removeLast()
        }
        UserDefaults.standard.set(recentSearches, forKey: UserDefaultsKeys.recentSearches.rawValue)
    }
    
    func loadRecentSearches() -> [String] {
        return UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.recentSearches.rawValue) ?? []
    }
    
    func removeRecentSearch(at indexPath: IndexPath) {
        var recentSearches = loadRecentSearches()
        recentSearches.remove(at: indexPath.item)
        UserDefaults.standard.set(recentSearches, forKey: UserDefaultsKeys.recentSearches.rawValue)
    }
}

enum NetworkError: Error {
    case noConnection
}

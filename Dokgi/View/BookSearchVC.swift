//
//  BookSearchVC.swift
//  Dokgi
//
//  Created by 한철희 on 6/11/24.
//

import UIKit
import SnapKit

class BookSearchVC: UIViewController {
    // Create an instance of BookManager
    let bookManager = BookManager.shared
    
    // Create a label to display search results
    let searchResultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 검색 바 생성
        let searchBar = UISearchBar()
        searchBar.placeholder = "책을 검색해보세요"
        searchBar.searchBarStyle = .minimal
        
        // 라벨 생성
        let label = UILabel()
        label.text = "검색화면 입니다."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        view.addSubview(searchBar)
        view.addSubview(label)
        view.addSubview(searchResultLabel) // Add searchResultLabel to the view
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        searchResultLabel.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16) // Position below the search bar
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        // Setup search bar delegate
        searchBar.delegate = self
    }
}

// MARK: - UISearchBarDelegate
extension BookSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Perform search when the search button is clicked
        if let query = searchBar.text {
            bookManager.fetchBookData(queryValue: query) { result in
                switch result {
                case .success(let response):
                    // Handle success, update UI with response items
                    DispatchQueue.main.async {
                        // Update the label's text with search results
                        self.searchResultLabel.text = self.formatSearchResults(response.items)
                    }
                case .failure(let error):
                    // Handle failure
                    print("Error: \(error)")
                }
            }
        }
        
        // Dismiss keyboard
        searchBar.resignFirstResponder()
    }
    
    // Helper method to format search results
    private func formatSearchResults(_ items: [Item]) -> String {
        var resultText = ""
        for item in items {
            resultText += "Title: \(item.title)\n"
            resultText += "Author: \(item.author)\n"
            resultText += "Publisher: \(item.publisher)\n"
            resultText += "\n"
        }
        return resultText
    }
}




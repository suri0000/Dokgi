//
//  BookSearchVC.swift
//  Dokgi
//
//  Created by 한철희 on 6/11/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class BookSearchVC: UIViewController {
    
    let bookManager = BookManager.shared
    
    let tableView = UITableView().then {
        $0.rowHeight = 150
    }
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "책을 검색해보세요"
        $0.searchBarStyle = .minimal
    }
    
    var searchResults: [Item] = [] // 검색 결과 저장
    weak var delegate: BookSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    // Setup UI components
    private func setupUI() {
        view.backgroundColor = .white
        searchBar.delegate = self
        
        addSubviews()
        setupConstraints()
    }
    
    // Add subviews to the main view
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    // Setup constraints using SnapKit
    private func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // Setup TableView
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BookCell.self, forCellReuseIdentifier: "BookCell")
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
                        self.searchResults = response.items
                        self.tableView.reloadData()
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
}

// MARK: - UITableViewDataSource
extension BookSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell else {
            return UITableViewCell()
        }
        
        let item = searchResults[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BookSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = searchResults[indexPath.row]
        
        // 선택된 책 정보를 delegate를 통해 전달
        delegate?.didSelectBook(item)
        dismiss(animated: true, completion: nil)
    }
}

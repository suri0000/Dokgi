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
    
    var searchResults: [Item] = [] // 검색 결과 저장
    weak var delegate: BookSelectionDelegate?
    
    let tableView = UITableView().then {
        $0.rowHeight = 150
    }
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "책을 검색해보세요"
        $0.searchBarStyle = .minimal
        $0.searchTextField.borderStyle = .line
        $0.searchTextField.layer.borderWidth = 1
        $0.searchTextField.layer.borderColor = UIColor(resource: .searchBarLightGray).cgColor
        $0.searchTextField.layer.backgroundColor = UIColor.white.cgColor
        $0.searchTextField.layer.cornerRadius = 15
        $0.searchTextField.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        searchBar.delegate = self
        
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BookCell.self, forCellReuseIdentifier: "BookCell")
    }
}

// MARK: - UISearchBarDelegate
extension BookSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            bookManager.fetchBookData(queryValue: query) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.searchResults = response.items
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
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
        
        delegate?.didSelectBook(item)
        dismiss(animated: true, completion: nil)
    }
}

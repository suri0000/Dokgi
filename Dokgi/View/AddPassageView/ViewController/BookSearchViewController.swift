//
//  BookSearchVC.swift
//  Dokgi
//
//  Created by 한철희 on 6/11/24.
//

import Kingfisher
import Network
import Then
import UIKit
import SnapKit

final class BookSearchViewController: UIViewController {
    
    weak var delegate: BookSelectionDelegate?
    private let addPassage = AddPassageViewController()
    private let viewModel = BookSearchViewModel()
    private let containerView = BookSearchContainerView()
    private let monitor = NWPathMonitor()
    private var isNetworkAvailable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpAction()
        startNetworkMonitoring()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupSearchBar()
        setupTableView()
        setupCollectionView()
        initLayout()
    }
    
    private func initLayout() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setUpAction() {
        containerView.clearAllButton.addTarget(self, action: #selector(clearAllButtonTapped), for: .touchUpInside)
    }
    
    private func setupSearchBar() {
        containerView.searchBar.delegate = self
    }
    
    private func setupTableView() {
        containerView.tableView.separatorStyle = .none
        containerView.tableView.dataSource = self
        containerView.tableView.delegate = self
        containerView.tableView.register(BookCell.self, forCellReuseIdentifier: BookCell.identifier)
    }
    
    private func setupCollectionView() {
        containerView.collectionView.dataSource = self
        containerView.collectionView.delegate = self
        containerView.collectionView.register(RecentSearchCell.self, forCellWithReuseIdentifier: RecentSearchCell.identifier)
    }
    
    private func showNoResults() {
        containerView.noResultsLabel.isHidden = false
        containerView.tableView.isHidden = true
    }
    
    private func showSearchResults() {
        containerView.noResultsLabel.isHidden = true
        containerView.tableView.isHidden = false
    }
    
    private func hideSearchResults() {
        containerView.noResultsLabel.isHidden = true
        containerView.tableView.isHidden = true
    }
    
    private func startNetworkMonitoring() {
        let queue = DispatchQueue.global(qos: .background)
        monitor.pathUpdateHandler = { path in
            self.isNetworkAvailable = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func fetchBooks(query: String, startIndex: Int) {
        viewModel.isLoading = true
        viewModel.fetchBooks(query: query, startIndex: startIndex) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    if items.isEmpty {
                        self.showNoResults()
                    } else {
                        self.viewModel.searchResults.append(contentsOf: items)
                        self.containerView.tableView.reloadData()
                        self.showSearchResults()
                    }
                    self.viewModel.isLoading = false
                }
            case .failure(let error):
                print("Error: \(error)")
            }
            self.viewModel.isLoading = false
        }
    }
    
    private func loadMore() {
        if viewModel.isLoading { return }
        viewModel.isLoading = true
        viewModel.startIndex += 10
        
        viewModel.fetchBooks(query: viewModel.query, startIndex: viewModel.startIndex) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                if items.isEmpty {
                    self.viewModel.isLoadingLast = true
                } else {
                    self.viewModel.searchResults.append(contentsOf: items)
                    DispatchQueue.main.async {
                        self.containerView.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
            self.viewModel.isLoading = false
        }
    }
    
    @objc private func clearAllButtonTapped() {
        viewModel.clearRecentSearches()
        containerView.collectionView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        performSearch(query: query)
        viewModel.saveRecentSearch(query)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard isNetworkAvailable else {
            self.showAlert(title: "인터넷 연결", message: "인터넷이 연결되어 있지 않습니다.\n 설정에서 인터넷 연결상태를 확인해주세요.")
            searchBar.resignFirstResponder()
            return
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.searchResults = []
            containerView.tableView.reloadData()
            hideSearchResults()
            showRecentSearches()
        } else {
            guard let query = searchBar.text, !query.isEmpty else { return }
            performSearch(query: query)
        }
    }
    
    private func performSearch(query: String) {
        viewModel.query = query
        viewModel.startIndex = 1
        viewModel.searchResults = []
        fetchBooks(query: query, startIndex: viewModel.startIndex)
        showSearchResults()
        hideRecentSearches()
    }
    
    private func hideRecentSearches() {
        containerView.recentSearchStackView.isHidden = true
        containerView.collectionView.isHidden = true
    }
    
    private func showRecentSearches() {
        containerView.recentSearchStackView.isHidden = false
        containerView.collectionView.isHidden = false
        containerView.collectionView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension BookSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier, for: indexPath) as? BookCell else {
            return UITableViewCell()
        }
        let item = viewModel.searchResults[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BookSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 현재 searchBar의 텍스트를 가져옵니다.
        if let lastSearched = containerView.searchBar.text {
            viewModel.saveRecentSearch(lastSearched)
        }
        
        let item = viewModel.searchResults[indexPath.row]
        delegate?.didSelectBook(item)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.searchResults.count - 1 && !viewModel.isLoading {
            loadMore()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension BookSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.loadRecentSearches().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell else {
            return UICollectionViewCell()
        }
        let recentSearches = viewModel.loadRecentSearches()
        cell.configure(with: recentSearches[indexPath.item], viewModel: viewModel)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension BookSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard isNetworkAvailable else {
            self.showAlert(title: "인터넷 연결", message: "인터넷이 연결되어 있지 않습니다.\n 설정에서 인터넷 연결상태를 확인해주세요.")
            return
        }
        let recentSearches = viewModel.loadRecentSearches()
        containerView.searchBar.text = recentSearches[indexPath.item]
        searchBarSearchButtonClicked(containerView.searchBar)
        containerView.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BookSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let recentSearches = viewModel.loadRecentSearches()
        let text = recentSearches[indexPath.item]
        let font = Pretendard.regular.dynamicFont(style: .callout)
        let attributes = [NSAttributedString.Key.font: font]
        let textSize = (text as NSString).size(withAttributes: attributes)
        let width = textSize.width + 40
        let height: CGFloat = 42
        return CGSize(width: width, height: height)
    }
}

// MARK: - BookSelectionDelegate
extension BookSearchViewController: BookSelectionDelegate {
    func didSelectBook(_ book: Item) {
        delegate?.didSelectBook(book)
        dismiss(animated: true, completion: nil)
    }
}

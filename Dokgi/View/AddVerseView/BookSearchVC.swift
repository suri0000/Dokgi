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
    
    var searchResults: [Item] = []
    weak var delegate: BookSelectionDelegate?
    
    let tableView = UITableView().then {
        $0.rowHeight = 150
        $0.showsVerticalScrollIndicator = false
        $0.isHidden = true
    }
    
    let searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.setPositionAdjustment(UIOffset(horizontal: 8, vertical: 0), for: .search)
        $0.setPositionAdjustment(UIOffset(horizontal: -8, vertical: 0), for: .clear)
        
        $0.placeholder = "책을 검색해보세요"
        $0.searchTextField.borderStyle = .line
        $0.searchTextField.layer.borderWidth = 1
        $0.searchTextField.layer.borderColor = UIColor(resource: .searchBarLightGray).cgColor
        $0.searchTextField.layer.backgroundColor = UIColor.white.cgColor
        $0.searchTextField.layer.cornerRadius = 17
        $0.searchTextField.layer.masksToBounds = true
        $0.searchTextField.font = Pretendard.regular.dynamicFont(style: .subheadline)
    }
    
    let recentSearchLabel = UILabel().then {
        $0.text = "최근 검색"
        $0.font = Pretendard.semibold.dynamicFont(style: .headline)
        $0.textColor = .black
    }
    
    let clearAllButton = UIButton().then {
        $0.setTitle("전체 삭제", for: .normal)
        $0.titleLabel?.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.setTitleColor(.placeholderText, for: .normal)
        $0.addTarget(self, action: #selector(clearAllButtonTapped), for: .touchUpInside)
    }
    
    let noResultsLabel = UILabel().then {
        $0.text = "검색어와 일치하는 책이 없습니다"
        $0.font = Pretendard.regular.dynamicFont(style: .subheadline)
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    let recentSearchStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 30)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .white
            $0.isHidden = false
            $0.showsHorizontalScrollIndicator = false
        }
    }()
    
    var isLoading = false
    var query: String = ""
    var startIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupCollectionView()
        
        let recentSearches = loadRecentSearches()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        searchBar.delegate = self
        
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(recentSearchStackView)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        view.addSubview(noResultsLabel)
        
        recentSearchStackView.addArrangedSubview(recentSearchLabel)
        recentSearchStackView.addArrangedSubview(clearAllButton)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        recentSearchStackView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(recentSearchStackView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        noResultsLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BookCell.self, forCellReuseIdentifier: "BookCell")
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecentSearchCell.self, forCellWithReuseIdentifier: RecentSearchCell.identifier)
    }
    
    private func fetchBooks(query: String, startIndex: Int) {
        isLoading = true
        bookManager.fetchBookData(queryValue: query, startIndex: startIndex) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response.items.isEmpty {
                        self.noResultsLabel.isHidden = false
                        self.tableView.isHidden = true
                    } else {
                        self.noResultsLabel.isHidden = true
                        self.searchResults.append(contentsOf: response.items)
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                    }
                    self.isLoading = false
                }
            case .failure(let error):
                print("Error: \(error)")
                self.isLoading = false
            }
        }
    }
    
    @objc private func clearAllButtonTapped() {
        print("전체 삭제")
        UserDefaults.standard.removeObject(forKey: "recentSearches")
        collectionView.reloadData()
    }
    
    private func saveRecentSearch(_ text: String) {
        var recentSearches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
        recentSearches.insert(text, at: 0)
        if recentSearches.count > 10 {
            recentSearches.removeLast()
        }
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
    }
    
    private func loadRecentSearches() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
    }
    
    func removeRecentSearch(at indexPath: IndexPath) {
        var recentSearches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
        recentSearches.remove(at: indexPath.item)
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
        collectionView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension BookSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            self.query = query
            self.startIndex = 1
            self.searchResults = []
            fetchBooks(query: query, startIndex: startIndex)
            recentSearchStackView.isHidden = true
            collectionView.isHidden = true
            noResultsLabel.isHidden = true
            tableView.isHidden = false
            
            saveRecentSearch(query) // 검색어를 저장합니다.
        }
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDataSource
extension BookSearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loadRecentSearches().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell else {
            return UICollectionViewCell()
        }
        
        let recentSearches = loadRecentSearches()
        cell.layer.borderColor = UIColor.lightSkyBlue.cgColor
        cell.layer.borderWidth = 2
        cell.configure(with: recentSearches[indexPath.item])
        return cell
    }
}

extension BookSearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let recentSearches = loadRecentSearches()
        let text = recentSearches[indexPath.item]
        let font = Pretendard.regular.dynamicFont(style: .callout)
        let attributes = [NSAttributedString.Key.font: font]
        let textSize = (text as NSString).size(withAttributes: attributes)
        let width = textSize.width + 35
        let height: CGFloat = 34
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDelegate
extension BookSearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recentSearches = loadRecentSearches()
        searchBar.text = recentSearches[indexPath.item]
        searchBarSearchButtonClicked(searchBar)
    }
}

// MARK: - UITableViewDataSource
extension BookSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier, for: indexPath) as? BookCell else {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (contentHeight - 100 - scrollViewHeight) && !isLoading {
            startIndex += 10
            fetchBooks(query: query, startIndex: startIndex)
        }
    }
}

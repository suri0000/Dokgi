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
    
    let viewModel = BookSearchViewModel()
    weak var delegate: BookSelectionDelegate?
    
    var searchResults: [Item] = []
    var isLoading = false
    var isLoadingLast = false
    var query: String = ""
    var startIndex: Int = 1
    
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
        let poundKeyImage: UIImage? = .poundKey
        $0.text = "최근 검색"
        $0.font = Pretendard.semibold.dynamicFont(style: .headline)
        $0.textColor = .black
        if let image = poundKeyImage {
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRect(x: 0, y: -3, width: image.size.width, height: image.size.height)
            let attachmentString = NSAttributedString(attachment: attachment)
            let mutableAttributedString = NSMutableAttributedString(string: " ")
            mutableAttributedString.append(attachmentString)
            mutableAttributedString.append(NSAttributedString(string: " 최근 검색어"))
            $0.attributedText = mutableAttributedString
        }
    }
    
    let clearAllButton = UIButton().then {
        $0.setTitle("전체 삭제", for: .normal)
        $0.titleLabel?.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.setTitleColor(.placeholderText, for: .normal)
        $0.addTarget(self, action: #selector(clearAllButtonTapped), for: .touchUpInside)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupCollectionView()
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
            $0.horizontalEdges.equalToSuperview().inset(14)
        }
        
        recentSearchStackView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(17)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(recentSearchStackView.snp.bottom).offset(8)
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
        tableView.register(BookCell.self, forCellReuseIdentifier: BookCell.identifier)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecentSearchCell.self, forCellWithReuseIdentifier: RecentSearchCell.identifier)
    }
    
    private func fetchBooks(query: String, startIndex: Int) {
        isLoading = true
        viewModel.fetchBooks(query: query, startIndex: startIndex) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    if items.isEmpty {
                        self.noResultsLabel.isHidden = false
                        self.tableView.isHidden = true
                    } else {
                        self.noResultsLabel.isHidden = true
                        self.searchResults.append(contentsOf: items)
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
    
    func loadMore() {
        if isLoading { return }
        isLoading = true
        startIndex += 1
        
        viewModel.fetchBooks(query: query, startIndex: startIndex) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                if items.isEmpty {
                    self.isLoadingLast = true
                } else {
                    self.searchResults.append(contentsOf: items)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
            self.isLoading = false
        }
    }
    
    @objc private func clearAllButtonTapped() {
        viewModel.clearRecentSearches()
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
            viewModel.saveRecentSearch(query)
            tableView.isHidden = false
            recentSearchStackView.isHidden = true
            collectionView.isHidden = true
            noResultsLabel.isHidden = true
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.searchResults = []
            self.tableView.reloadData()
            tableView.isHidden = true
            recentSearchStackView.isHidden = false
            collectionView.isHidden = false
        }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == searchResults.count - 1 && !isLoading {
            loadMore()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension BookSearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.loadRecentSearches().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell else {
            return UICollectionViewCell()
        }
        
        let recentSearches = viewModel.loadRecentSearches()
        cell.configure(with: recentSearches[indexPath.item], viewModel: viewModel)
        cell.layer.cornerRadius = 14
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.lightSkyBlue.cgColor
        cell.layer.borderWidth = 2
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension BookSearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recentSearches = viewModel.loadRecentSearches()
        searchBar.text = recentSearches[indexPath.item]
        searchBarSearchButtonClicked(searchBar)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BookSearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let recentSearches = viewModel.loadRecentSearches()
        let text = recentSearches[indexPath.item]
        let font = Pretendard.regular.dynamicFont(style: .callout)
        let attributes = [NSAttributedString.Key.font: font]
        let textSize = (text as NSString).size(withAttributes: attributes)
        let width = textSize.width + 35
        let height: CGFloat = 34
        return CGSize(width: width, height: height)
    }
}

// MARK: - BookSelectionDelegate
extension BookSearchVC: BookSelectionDelegate {
    func didSelectBook(_ book: Item) {
        delegate?.didSelectBook(book)
        dismiss(animated: true, completion: nil)
    }
}

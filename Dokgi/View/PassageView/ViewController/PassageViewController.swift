//
//  ParagraphViewController.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/10/24.
//

import RxSwift
import SnapKit
import UIKit

class PassageViewController: UIViewController {
    
    let passageView = PassageView()
    
    let viewModel = PassageViewModel()
    var disposeBag = DisposeBag()
    
    var isFiltering: Bool = false
    var isEditingMode: Bool = false
    
    private var isLatestFirst: Bool = true
    private var isOldestFirst: Bool = false
    
    private var searchResultItems: [(String, Date)] = [] {
        didSet {
            if let layout = passageView.passageCollectionView.collectionViewLayout as? PassageCollectionViewLayout {
                layout.invalidateCache()
            }
            passageView.passageCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        passageView.searchBar.delegate = self
        
        passageView.passageCollectionView.delegate = self
        passageView.passageCollectionView.dataSource = self
        
        let layout = PassageCollectionViewLayout()
        passageView.passageCollectionView.collectionViewLayout = layout
        layout.delegate = self

        initLayout()
        setBinding()
        setButtonActions()
        setFloatingButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        if passageView.sortButton.titleLabel?.text != "최신순" {
            let sortedPassageAndDate = viewModel.passageData.value.sorted { $0.1 > $1.1 }
            isFiltering ? searchResultItems.sort { $0.1 > $1.1 } : viewModel.passageData.accept(sortedPassageAndDate)
        }
        self.passageView.passageCollectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        passageView.sortMenuView.isHidden = true
    }
    
    private func initLayout() {
        view.addSubview(passageView)
        passageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setBinding() {
        viewModel.passageData.subscribe(with: self) { (self, data) in
            if let layout = self.passageView.passageCollectionView.collectionViewLayout as? PassageCollectionViewLayout {
                layout.invalidateCache()
            }
            self.passageView.passageCollectionView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    private func setButtonActions() {
        passageView.selectionButton.addTarget(self, action: #selector(tappedSelectionButton), for: .touchUpInside)
        passageView.sortButton.addTarget(self, action: #selector(showOrHideSortMenuView), for: .touchUpInside)
        passageView.latestFirstButton.addTarget(self, action: #selector(tappedLatestFirst), for: .touchUpInside)
        passageView.doneButton.addTarget(self, action: #selector(tappedDoneButton), for: .touchUpInside)
        passageView.oldestFirstButton.addTarget(self, action: #selector(tappedOldestFirst), for: .touchUpInside)
    }
    
    // MARK: - 설정버튼
    @objc private func showOrHideSortMenuView() {
        if passageView.sortMenuView.isHidden {
            passageView.sortMenuView.isHidden = false
            passageView.bringSubviewToFront(passageView.sortMenuView)
        } else {
            passageView.sortMenuView.isHidden = true
        }
    }
    
    @objc private func tappedLatestFirst() {
        passageView.sortButtonTitleLabel.text = "최신순"
        passageView.latestFirstcheckImageView.isHidden = false
        passageView.oldestFirstcheckImageView.isHidden = true
        passageView.sortMenuView.isHidden = true
        
        let sortedPassageAndDate = viewModel.passageData.value.sorted { $0.1 > $1.1 }
        
        isFiltering ? searchResultItems.sort { $0.1 > $1.1 } : viewModel.passageData.accept(sortedPassageAndDate)
    }
    
    @objc private func tappedOldestFirst() {
        passageView.sortButtonTitleLabel.text = "오래된순"
        passageView.latestFirstcheckImageView.isHidden = true
        passageView.oldestFirstcheckImageView.isHidden = false
        passageView.sortMenuView.isHidden = true
        
        let sortedPassageAndDate = viewModel.passageData.value.sorted { $0.1 < $1.1 }
        isFiltering ? searchResultItems.sort { $0.1 < $1.1 } : viewModel.passageData.accept(sortedPassageAndDate)
    }
    
    @objc private func tappedSelectionButton() {
        isEditingMode = true
        passageView.selectionButton.isHidden = true
        passageView.doneButton.isHidden = false
        self.passageView.passageCollectionView.reloadData()
    }
    
    @objc private func tappedDoneButton() {
        isEditingMode = false
        passageView.selectionButton.isHidden = false
        passageView.doneButton.isHidden = true
        self.passageView.passageCollectionView.reloadData()
    }
}

//MARK: - SearchBar
extension PassageViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isFiltering = true
        self.passageView.searchBar.showsCancelButton = true
        searchResultItems = viewModel.passageData.value
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterItems(with: searchText)
    }
    
    private func filterItems(with searchText: String) {
        if searchText.isEmpty {
            searchResultItems = viewModel.passageData.value
        } else {
            searchResultItems = viewModel.passageData.value.filter { $0.0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.passageView.searchBar.showsCancelButton = false
        self.passageView.searchBar.resignFirstResponder()
        self.isFiltering = false
        self.passageView.searchBar.text = ""
        self.searchResultItems = []
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        filterItems(with: searchText)
        
        self.passageView.searchBar.showsCancelButton = false
        self.passageView.searchBar.resignFirstResponder()
    }
}
//MARK: -CollectionView
extension PassageViewController: UICollectionViewDelegate, UICollectionViewDataSource, PassageCollectionViewLayoutDelegate, PassageCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellCount = viewModel.passageData.value.count
        let resultCount = searchResultItems.count
        let itemCount = isFiltering ? resultCount : cellCount
        
        passageView.emptyMessageLabel.isHidden = itemCount > 0
        if isFiltering { passageView.emptyMessageLabel.text = "검색결과가 없습니다." }
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PassageCollectionViewCell.identifier, for: indexPath) as? PassageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setColor(with: indexPath)
        cell.deleteButton.isHidden = !isEditingMode
        cell.delegate = self
        
        let (text, date) = isFiltering ? searchResultItems[indexPath.item] : viewModel.passageData.value[indexPath.item]
        cell.paragraphLabel.text = text
        let dateString = String(date.toString()).suffix(10)
        cell.dateLabel.text = String(dateString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForTextAtIndexPath indexPath: IndexPath) -> CGFloat {
        let text = isFiltering ? searchResultItems[indexPath.item].0 : viewModel.passageData.value[indexPath.item].0
        let date = isFiltering ? searchResultItems[indexPath.item].1 : viewModel.passageData.value[indexPath.item].1
        return calculateCellHeight(for: text, for: date.toString(), in: collectionView)
    }
    
    func heightForText(_ text: String, width: CGFloat) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0  // 멀티라인
        label.preferredMaxLayoutWidth = width
        label.lineBreakMode = .byCharWrapping
        label.font = Pretendard.regular.dynamicFont(style: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        
        let constraintSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = label.sizeThatFits(constraintSize)
        
        return size.height
    }
    
    func heightForDateText(_ date: String, width: CGFloat) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = width
        label.font = Pretendard.regular.dynamicFont(style: .caption2)
        label.adjustsFontForContentSizeCategory = true
        label.text = date
        
        let constraintSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = label.sizeThatFits(constraintSize)
        
        return size.height
    }
    
    func calculateCellHeight(for text: String, for date: String, in collectionView: UICollectionView) -> CGFloat {
        let cellPadding: CGFloat = 6
        let leftRightinsets: CGFloat = 15 * 2
        let width = (collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right + cellPadding * 4)) / 2 - leftRightinsets + 0.5
        
        let paragraphLabelHeight = heightForText(text, width: width)
        let paragraphDateSpacing: CGFloat = 30
        let dateLabelHeight: CGFloat = heightForDateText(date, width: width)
        let topBottomPadding: CGFloat = 14 * 2
        return paragraphLabelHeight + paragraphDateSpacing + dateLabelHeight + topBottomPadding
    }
    
    func tappedDeleteButton(in cell: PassageCollectionViewCell) {
        guard let indexPath = passageView.passageCollectionView.indexPath(for: cell) else { return }
        self.viewModel.selectParagraph(text: isFiltering ? searchResultItems[indexPath.item].0 : viewModel.passageData.value[indexPath.item].0, at: indexPath.item)
        var currentParagraph = isFiltering ? searchResultItems : viewModel.passageData.value
        currentParagraph.remove(at: indexPath.item)
        viewModel.passageData.accept(currentParagraph)
        searchResultItems = currentParagraph
        CoreDataManager.shared.deleteData(verse: viewModel.detailPassage.value)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let modalVC = PassageDetailViewController()
        
        viewModel.selectParagraph(text: isFiltering ? searchResultItems[indexPath.item].0 : viewModel.passageData.value[indexPath.item].0, at: indexPath.item)
        modalVC.viewModel.detailPassage.accept(viewModel.detailPassage.value)
        present(modalVC, animated: true, completion: nil)
    }
}

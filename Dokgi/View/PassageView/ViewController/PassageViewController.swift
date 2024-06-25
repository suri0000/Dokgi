//
//  ParagraphViewController.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/10/24.
//

import RxSwift
import SnapKit
import Then
import UIKit

class PassageViewController: BaseLibraryAndPassageViewController {
    
    let passageViewModel = PassageViewModel()
    var disposeBag = DisposeBag()
    
    let selectionButton = UIButton().then {
        $0.backgroundColor = .white
        $0.sizeToFit()
    }
    
    let selectionButtonImageView = UIImageView().then {
        $0.image = .filter
    }
    
    let selectionButtonLabel = UILabel().then {
        $0.text = "선택"
        $0.font = Pretendard.semibold.dynamicFont(style: .headline)
        $0.textColor = .charcoalBlue
    }
    
    let doneButton = UIButton().then {
        $0.titleLabel?.font = Pretendard.semibold.dynamicFont(style: .headline)
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.brightRed, for: .normal)
        $0.isHidden = true
    }
    
    let passageCollectionView = PassageCollectionView()
    
    var isEditingMode: Bool = false
    
    private var isLatestFirst: Bool = true
    private var isOldestFirst: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passageCollectionView.delegate = self
        passageCollectionView.dataSource = self
        
        let layout = PassageCollectionViewLayout()
        passageCollectionView.collectionViewLayout = layout
        layout.delegate = self
        setLabelText(title: "구절", placeholder: "기록한 구절을 검색해보세요", noResultsMessage: "기록한 구절이 없어요\n구절을 등록해 보세요")
        setButtonActions()
        initLayout()
        setBinding()
        CoreDataManager.shared.passageData.subscribe(with: self) { (self, data) in
            if let layout = self.passageCollectionView.collectionViewLayout as? PassageCollectionViewLayout {
                layout.invalidateCache()
            }
            self.passageCollectionView.isHidden = data.count < 0
            self.noResultsLabel.isHidden = data.count > 0
            self.noResultsLabel.text = "검색결과가 없습니다."
            self.passageCollectionView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
    }
    
    override func initLayout() {
        view.backgroundColor = .white
        
        [selectionButton, doneButton, passageCollectionView].forEach {
            view.addSubview($0)
        }
        
        selectionButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        [selectionButtonImageView, selectionButtonLabel].forEach {
            selectionButton.addSubview($0)
        }
        
        selectionButtonImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(4)
            $0.width.equalTo(14.67)
            $0.height.equalTo(13.2)
        }
        
        selectionButtonLabel.snp.makeConstraints {
            $0.centerY.trailing.equalToSuperview()
            $0.leading.equalTo(selectionButtonImageView.snp.trailing).offset(5)
        }
        
        doneButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        passageCollectionView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom).offset(20)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        view.sendSubviewToBack(passageCollectionView)
    }
    
    override func setBinding() {
        searchBar.searchTextField.rx.controlEvent(.editingDidBegin).subscribe(with: self) { (self, _) in
            self.searchBar.showsCancelButton = true
        }.disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.subscribe(with: self) { (self, _) in
            self.searchBar.resignFirstResponder()
            self.searchBar.showsCancelButton = false
        }.disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked.subscribe(with: self) { (self, _) in
            self.searchBar.resignFirstResponder()
            self.searchBar.showsCancelButton = false
            self.searchBar.text = ""
        }.disposed(by: disposeBag)
        
        searchBar.rx.text.debounce(.milliseconds(250), scheduler: MainScheduler.instance).subscribe(with: self) { (self, text) in
            CoreDataManager.shared.readPassage(text: text ?? "")
            if self.sortButton.sortButtonTitleLabel.text == "최신순"{
                self.passageViewModel.dataLatest()
            } else {
                self.passageViewModel.dataOldest()
            }
        }.disposed(by: disposeBag)
    }
    // MARK: - 버튼 Action
    private func setButtonActions() {
        selectionButton.rx.tap.subscribe(with: self) { (self, _) in
            self.isEditingMode = true
            self.selectionButton.isHidden = true
            self.doneButton.isHidden = false
            self.passageCollectionView.reloadData()
        }.disposed(by: disposeBag)
        
        doneButton.rx.tap.subscribe(with: self) { (self, _) in
            self.isEditingMode = false
            self.selectionButton.isHidden = false
            self.doneButton.isHidden = true
            self.passageCollectionView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    override func latestButtonAction() {
        self.passageViewModel.dataLatest()
    }
    
    override func oldestButtonAction() {
        self.passageViewModel.dataOldest()
    }
}

//MARK: -CollectionView
extension PassageViewController: UICollectionViewDelegate, UICollectionViewDataSource, PassageCollectionViewLayoutDelegate, PassageCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoreDataManager.shared.passageData.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PassageCollectionViewCell.identifier, for: indexPath) as? PassageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setColor(with: indexPath)
        cell.deleteButton.isHidden = !isEditingMode
        cell.delegate = self

        cell.paragraphLabel.text = CoreDataManager.shared.passageData.value[indexPath.item].passage
        let dateString = String(CoreDataManager.shared.passageData.value[indexPath.item].date.toString()).suffix(10)
        cell.dateLabel.text = String(dateString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForTextAtIndexPath indexPath: IndexPath) -> CGFloat {
        let text = CoreDataManager.shared.passageData.value[indexPath.item].passage
        let date = String(CoreDataManager.shared.passageData.value[indexPath.item].date.toString()).suffix(10)
        return calculateCellHeight(for: text, for: String(date), in: collectionView)
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
        guard let indexPath = passageCollectionView.indexPath(for: cell) else { return }
        let alert = UIAlertController(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            CoreDataManager.shared.deleteData(passage: CoreDataManager.shared.passageData.value[indexPath.item])
            CoreDataManager.shared.readPassage(text: self?.searchBar.text ?? "")
        }
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditingMode {
            let modalVC = PassageDetailViewController()
            modalVC.viewModel.detailPassage.accept(CoreDataManager.shared.passageData.value[indexPath.item])
            present(modalVC, animated: true, completion: nil)
        }
    }
}

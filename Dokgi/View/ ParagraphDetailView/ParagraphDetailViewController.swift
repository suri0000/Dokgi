//
//  ParagrapViewController.swift
//  Dokgi
//
//  Created by 송정훈 on 6/7/24.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class ParagraphDetailViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let viewModel = ParagraphDetailViewModel()
    
    let titleStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    
    lazy var titleLbl = UILabel().then {
        $0.text = self.viewModel.paragraph?.bookName
        $0.font = Pretendard.semibold.dynamicFont(style: .title3)
    }
    
    let xBtn = UIButton().then {
        $0.setImage(UIImage(named: "deleteKeyword")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = UIColor(named: "ModelxGray")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.backgroundColor = UIColor(named: "ModelxBackground")
        $0.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
    }
    
    let editBtn = UIButton().then {
        $0.setTitle("수정하기", for: .normal)
        $0.titleLabel?.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(named: "modalEdit"), for: .normal)
    }
    
    let ParagrapScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    lazy var containerView = ParagraphDetailContainerView()
    
    let smallId = UISheetPresentationController.Detent.Identifier("small")
    lazy var smallDetent = UISheetPresentationController.Detent.custom(identifier: smallId) { context in
        return UIScreen.main.bounds.size.height - 228
    }
    let largeId = UISheetPresentationController.Detent.Identifier("large")
    lazy var largeDetent = UISheetPresentationController.Detent.custom(identifier: self.largeId) { context in
        return UIScreen.main.bounds.size.height - 115
    }
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let sheet = sheetPresentationController {
            sheet.detents = [smallDetent]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 8
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        containerView.keywordCollectionView.dataSource = self
        containerView.keywordCollectionView.delegate = self
        containerView.keywordCollectionView.register(KeywordCollectionViewCell.self, forCellWithReuseIdentifier: KeywordCollectionViewCell.identifier)
        setupLayout()
        dataBinding()
    }
    
    // MARK: - Layout
    func setupLayout() {
        view.addSubview(titleStack)
        [titleLbl, xBtn].forEach {
            titleStack.addArrangedSubview($0)
        }
        view.addSubview(editBtn)
        view.addSubview(ParagrapScrollView)
        ParagrapScrollView.addSubview(containerView)
        
        titleStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        editBtn.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(22)
        }
        
        ParagrapScrollView.snp.makeConstraints {
            $0.top.equalTo(editBtn.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(ParagrapScrollView.snp.width)
        }
    }
    
    func dataBinding() {
        ParagraphDetailViewModel.detailParagraph.subscribe(with: self) { (self, data) in
            self.viewModel.paragraph = data
            self.viewModel.previous = data.paragraph
            self.titleLbl.text = data.bookName
            self.containerView.paragrapTextLbl.text = data.paragraph
            self.containerView.pageWriteLbl.text = data.page
            self.containerView.writeDateDay.text = data.date.formatted()
        }.disposed(by: disposeBag)
        
        self.xBtn.rx.tap.subscribe(with: self) { (self, _) in
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        self.editBtn.rx.tap.subscribe(with: self) { (self, _) in
            if self.editBtn.titleLabel?.text == "수정하기" {
                self.containerView.keywordCollectionView.reloadData()
                self.containerView.editLayout()
                self.sheetPresentationController?.detents = [self.largeDetent]
                self.editBtn.setTitle("완료", for: .normal)
                self.editBtn.titleLabel?.font = Pretendard.semibold.dynamicFont(style: .callout)
                self.editBtn.setTitleColor(UIColor(named: "SkyBlue"), for: .normal)
                self.editBtn.setImage(nil, for: .normal)
            } else {
                self.containerView.keywordCollectionView.reloadData()
                self.containerView.editCompleteLayout()
                self.sheetPresentationController?.detents = [self.smallDetent]
                self.editBtn.setTitle("수정하기", for: .normal)
                self.editBtn.titleLabel?.font = Pretendard.regular.dynamicFont(style: .footnote)
                self.editBtn.setTitleColor(.black, for: .normal)
                self.editBtn.setImage(UIImage(named: "modalEdit"), for: .normal)
                self.viewModel.saveDetail(str: self.containerView.paragrapTextField.text)
            }
        }.disposed(by: disposeBag)
        
        containerView.paragrapTextField.rx.text.orEmpty.subscribe(with: self) { (self, text) in
            self.containerView.paragrapTextLimit(text)
        }.disposed(by: disposeBag)
        
        containerView.keywordTextField.rx.text.orEmpty.subscribe(with: self) { (self, text) in
            self.containerView.keywordTextLimit(text)
        }.disposed(by: disposeBag)
        
        containerView.keywordTextField.rx.controlEvent(.editingDidEnd).subscribe(with: self) { (self, _) in
            if let text = self.containerView.keywordTextField.text {
                self.viewModel.addDetailKeyword(keyword: text)
                self.containerView.keywordCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
}

extension ParagraphDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.paragraph?.keyword.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCollectionViewCell.identifier, for: indexPath) as? KeywordCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.keywordLbl.text = viewModel.paragraph?.keyword[indexPath.row]
        cell.xBtn.rx.tap.subscribe(with: self) { (self, data) in
            self.viewModel.deleteDetailKeyword(keyword: indexPath.row)
            self.containerView.keywordCollectionView.reloadData()
        }.disposed(by: cell.disposeBag)
        if self.editBtn.titleLabel?.text == "수정하기" {
            cell.xBtn.isHidden = true
        } else {
            cell.xBtn.isHidden = false
        }
        return cell
    }
}

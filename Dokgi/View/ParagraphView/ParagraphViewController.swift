//
//  ParagraphViewController.swift
//  Dokgi
//
//  Created by t2023-m0095 on 6/10/24.
//

import UIKit

class ParagraphViewController: UIViewController {
    
    let paragraphLabel = UILabel()
    let selectionButton = UIButton()
    let selectionButtonImageView = UIImageView()
    let selectionButtonLabel = UILabel()
    let searchBar = UISearchBar()
    
    let sortButton = UIButton()
    let sortButtonImageView = UIImageView()
    let sortButtonTitleLabel = UILabel()
    
    let sortMenuView = UIView()
    let latestFirstButton = UIButton()
    let oldestFirstButton = UIButton()
    let latestFirstcheckImageView = UIImageView()
    let oldestFirstcheckImageView = UIImageView()
    let latestTextLabel = UILabel()
    let oldestTextLabel = UILabel()
    
    var isLatestFirst: Bool = true
    var isOldestFirst: Bool = false
    
    lazy var paragraphCollectionView: UICollectionView = {
        let layout = ParagraphCollectionViewLayout()
        layout.delegate = self
//        layout.minimumLineSpacing = 12
//        layout.minimumInteritemSpacing = 10
//        layout.sectionInset = .init(top: 0, left: 15, bottom: 20, right: 15) // 좌우에 15의 간격
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ParagraphCollectionViewCell.self, forCellWithReuseIdentifier: ParagraphCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    var sampleTexts = [
        "짧은 텍스트입니다.",
        "이 텍스트는 좀 더 길어서 셀의 높이가 달라질 것입니다.",
        "여기에는 아주 길고 긴 텍스트가 들어갑니다. 이 텍스트는 여러 줄로 분할되어 표시될 것입니다. 이를 통해 셀의 높이가 텍스트 길이에 맞게 조절되는지 확인할 수 있습니다. 더 길게 작성해도 셀의 높이가 제대로 조절되는지 확인할 수 있습니다.",
        "짧은 텍스트입니다."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setConstraints()
        setSearchBar()
        setSortMenuView()
    }
    
    func setUI() {
        view.backgroundColor = .white
        
        paragraphLabel.text = "서재"
        paragraphLabel.font = Pretendard.bold.dynamicFont(style: .title1)
        paragraphLabel.textColor = .black
        
        selectionButton.backgroundColor = .white
        selectionButton.addTarget(self, action: #selector(tappedSelectionButton), for: .touchUpInside)
        
        selectionButtonImageView.image = UIImage(named: "Filter")
        
        selectionButtonLabel.text = "선택"
        selectionButtonLabel.font = Pretendard.medium.dynamicFont(style: .subheadline)
        selectionButtonLabel.textColor = UIColor(named: "CharcoalBlue")
        
        sortButton.backgroundColor = UIColor(named: "LightSkyBlue")
        sortButton.layer.cornerRadius = 15
        sortButton.clipsToBounds = true
        sortButton.addTarget(self, action: #selector(showSortMenuView), for: .touchUpInside)
        
        sortButtonImageView.image = UIImage(named: "down")
        
        sortButtonTitleLabel.text = "최신순"
        sortButtonTitleLabel.font = Pretendard.regular.dynamicFont(style: .footnote)
        sortButtonTitleLabel.textColor = UIColor(named: "CharcoalBlue")
        
        sortMenuView.backgroundColor = .white
        sortMenuView.layer.cornerRadius = 10
        
        sortMenuView.layer.shadowColor = UIColor.black.cgColor
        sortMenuView.layer.shadowOpacity = 0.3
        sortMenuView.layer.shadowOffset = CGSize(width: 1, height: 1)
        sortMenuView.layer.shadowRadius = 2
        
        latestFirstButton.backgroundColor = .white
        latestFirstButton.addTarget(self, action: #selector(tappedLatestFirst), for: .touchUpInside)
        latestFirstButton.layer.cornerRadius = 10
        
        oldestFirstButton.backgroundColor = .white
        oldestFirstButton.addTarget(self, action: #selector(tappedOldestFirst), for: .touchUpInside)
        oldestFirstButton.layer.cornerRadius = 10
        
        latestTextLabel.text = "최신순"
        latestTextLabel.font = Pretendard.regular.dynamicFont(style: .footnote)
        latestTextLabel.textColor = UIColor(named: "CharcoalBlue")
        
        oldestTextLabel.text = "오래된순"
        oldestTextLabel.font = Pretendard.regular.dynamicFont(style: .footnote)
        oldestTextLabel.textColor = UIColor(named: "CharcoalBlue")
        
        latestFirstcheckImageView.image = UIImage(named: "check")
        oldestFirstcheckImageView.image = UIImage(named: "check")
    }
    
    func setConstraints() {
        [paragraphLabel, selectionButton, searchBar, sortButton, sortMenuView, paragraphCollectionView].forEach {
            view.addSubview($0)
        }
        
        paragraphLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(41)
        }
        
        //선택 버튼
        selectionButton.snp.makeConstraints {
            $0.centerY.equalTo(paragraphLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(22)
            $0.width.equalTo(53)
        }
        
        [selectionButtonImageView, selectionButtonLabel].forEach {
            selectionButton.addSubview($0)
        }
        
        selectionButtonImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(14.67)
            $0.height.equalTo(13.2)
        }
        
        selectionButtonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(selectionButtonImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(paragraphLabel.snp.bottom)
            $0.left.right.equalToSuperview().inset(10)
        }
        
        //정렬 버튼
        sortButton.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(29)
            $0.width.greaterThanOrEqualTo(87)
        }
        
        [sortButtonImageView, sortButtonTitleLabel].forEach {
            sortButton.addSubview($0)
        }
        
        sortButtonImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.width.height.equalTo(18)
        }
        
        sortButtonTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(sortButtonImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        // 정렬 버튼 클릭 시 - 정렬 옵션 메뉴
        sortMenuView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom).offset(3)
            $0.right.equalToSuperview().inset(20)
            $0.height.equalTo(60)
            $0.width.equalTo(113)
        }
        
        // 정렬 옵션 메뉴(최신순 버튼, 오래된순 버튼)
        [latestFirstButton, oldestFirstButton].forEach {
            sortMenuView.addSubview($0)
        }
        
        latestFirstButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(oldestFirstButton.snp.top)
            $0.height.equalTo(30)
        }
        
        oldestFirstButton.snp.makeConstraints {
            $0.top.equalTo(latestFirstButton.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        // 최신순 버튼
        [latestFirstcheckImageView, latestTextLabel].forEach {
            latestFirstButton.addSubview($0)
        }
        
        latestFirstcheckImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
            $0.height.width.equalTo(10)
        }
        
        latestTextLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(latestFirstcheckImageView.snp.trailing).offset(6)
        }
        
        //오래된순
        [oldestFirstcheckImageView, oldestTextLabel].forEach {
            oldestFirstButton.addSubview($0)
        }
        
        oldestFirstcheckImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
            $0.height.width.equalTo(10)
        }
        
        oldestTextLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(latestFirstcheckImageView.snp.trailing).offset(6)
        }
        
        paragraphCollectionView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom).offset(20)
            $0.bottom.left.right.equalToSuperview().inset(0)
        }
    }
    
    //MARK: - searchBar
    func setSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "기록한 구절을 검색해보세요"
        searchBar.searchTextField.borderStyle = .line
        searchBar.searchTextField.layer.borderWidth = 1
        if let SearchBarLightGray = UIColor(named: "SearchBarLightGray")?.cgColor {
            searchBar.searchTextField.layer.borderColor = SearchBarLightGray
        }
        searchBar.searchTextField.layer.backgroundColor = UIColor.white.cgColor
        searchBar.searchTextField.layer.cornerRadius = 20
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.font = Pretendard.regular.dynamicFont(style: .caption2)
    }
    // MARK: - 설정버튼
    func setSortMenuView() {
        sortMenuView.isHidden = true
        
        latestFirstcheckImageView.isHidden = false
        oldestFirstcheckImageView.isHidden = true
    }
    
    @objc func showSortMenuView() {
        sortMenuView.isHidden = false
        view.bringSubviewToFront(sortMenuView)
    }
    
    @objc func tappedLatestFirst() {
        sortButtonTitleLabel.text = "최신순"
        
        latestFirstcheckImageView.isHidden = false
        oldestFirstcheckImageView.isHidden = true
        
        sortMenuView.isHidden = true
    }
    
    @objc func tappedOldestFirst() {
        sortButtonTitleLabel.text = "오래된순"
        
        latestFirstcheckImageView.isHidden = true
        oldestFirstcheckImageView.isHidden = false
        
        sortMenuView.isHidden = true
    }
    
    @objc func tappedSelectionButton() {
        sortMenuView.isHidden = true
        selectionButtonImageView.isHidden = true
    }
}
//MARK: -CollectionView
extension ParagraphViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ParagraphCollectionViewLayoutDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleTexts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParagraphCollectionViewCell.identifier, for: indexPath) as? ParagraphCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let text = sampleTexts[indexPath.item]
        cell.paragraphLabel.text = text
        
        let colors = ["LightSkyBlue", "LightPastelBlue", "LavenderBlue", "LavenderDarkBlue"]
        let colorName = colors[indexPath.item % colors.count]
        cell.backgroundColor = UIColor(named: colorName) ?? .gray
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = true
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, heightForTextAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        let width = (collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)) / 2 - 4
        let text = sampleTexts[indexPath.item]
        let paragraphLabelHeight = heightForText(text, width: width)
        let dataLabelHeight : CGFloat = 22
        return paragraphLabelHeight + dataLabelHeight + 150
    }
    
    private func heightForText(_ text: String, width: CGFloat) -> CGFloat {
        let font = Pretendard.regular.dynamicFont(style: .subheadline)
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}

//
//  BaseLibraryAndPassageViewController.swift
//  Dokgi
//
//  Created by 예슬 on 6/21/24.
//

import RxSwift
import SnapKit
import Then
import UIKit

class BaseLibraryAndPassageViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var isFiltering: Bool = false
    private var isLatestFirst: Bool = true
    private var isOldestFirst: Bool = false
    
    private let titleLabel = UILabel().then {
        $0.font = Pretendard.bold.dynamicFont(style: .title1)
        $0.textColor = .black
    }
    
    private let searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.setPositionAdjustment(UIOffset(horizontal: 8, vertical: 0), for: .search)
        $0.setPositionAdjustment(UIOffset(horizontal: -8, vertical: 0), for: .clear)
        $0.searchTextField.borderStyle = .line
        $0.searchTextField.layer.borderWidth = 1
        $0.searchTextField.layer.borderColor = UIColor(resource: .searchBarLightGray).cgColor
        $0.searchTextField.layer.backgroundColor = UIColor.white.cgColor
        $0.searchTextField.layer.cornerRadius = 17
        $0.searchTextField.layer.masksToBounds = true
        $0.searchTextField.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.searchTextField.textColor = .black
//        $0.delegate = self
    }
    
//    private let sortButton = UIButton().then {
//        $0.backgroundColor = .lightSkyBlue
//        $0.layer.cornerRadius = 15
//        $0.clipsToBounds = true
//        $0.addTarget(self, action: #selector(showOrHideSortMenuView), for: .touchUpInside)
//    }
//    
//    private let sortButtonImageView = UIImageView().then {
//        $0.image = .down
//    }
//    
//    private let sortButtonTitleLabel = UILabel().then {
//        $0.text = "최신순"
//        $0.font = Pretendard.regular.dynamicFont(style: .footnote)
//        $0.textColor = .charcoalBlue
//    }
    
    private let sortMenuView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 2
    }
    
    private let latestFirstButton = UIButton().then {
        $0.backgroundColor = .white
        $0.addTarget(self, action: #selector(tappedLatestButton), for: .touchUpInside)
        $0.layer.cornerRadius = 10
    }
    
    private let oldestFirstButton = UIButton().then {
        $0.backgroundColor = .white
        $0.addTarget(self, action: #selector(tappedOldestButton), for: .touchUpInside)
        $0.layer.cornerRadius = 10
    }
    
    private let latestFirstcheckImageView = UIImageView().then {
        $0.image = .check
    }
    
    private let oldestFirstcheckImageView = UIImageView().then {
        $0.image = .check
    }
    
    private let latestTextLabel = UILabel().then {
        $0.text = "최신순"
        $0.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.textColor = .charcoalBlue
    }
    
    private let oldestTextLabel = UILabel().then {
        $0.text = "오래된순"
        $0.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.textColor = .charcoalBlue
    }
    
    private let emptyMessageLabel = UILabel().then {
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        
        $0.font = Pretendard.regular.dynamicFont(style: .subheadline)
        $0.isHidden = true
        $0.numberOfLines = 0
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
//        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - UI
    
    func setTitleLabel(title: String, placeholder: String, emptyMessage: String) {
        titleLabel.text = title
        searchBar.placeholder = placeholder
        emptyMessageLabel.text = emptyMessage
    }
    
//    @objc func showOrHideSortMenuView() {
//        
//    }
    
    @objc func tappedLatestButton() {
        
    }
    
    @objc func tappedOldestButton() {
        
    }
}

// placdholder 색깔
// 서치바 델리게이트
// 글자색 확인

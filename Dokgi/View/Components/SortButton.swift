//
//  SortButton.swift
//  Dokgi
//
//  Created by 예슬 on 6/21/24.
//

import SnapKit
import Then
import UIKit

class SortButton: UIButton {
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
    }
    
    private let sortButtonImageView = UIImageView().then {
        $0.image = .down
    }
    
    private let sortButtonTitleLabel = UILabel().then {
        $0.text = "최신순"
        $0.font = Pretendard.regular.dynamicFont(style: .footnote)
        $0.textColor = .charcoalBlue
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupButton() {
        self.backgroundColor = .lightSkyBlue
        self.layer.cornerRadius = 18
        self.clipsToBounds = true
        self.addTarget(self, action: #selector(showOrHideSortMenuView), for: .touchUpInside)
       }
    
    private func setLayout() {
        self.addSubview(stackView)
        
        [sortButtonImageView, sortButtonTitleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        sortButtonImageView.snp.makeConstraints {
            $0.width.height.equalTo(18)
        }
    }
    
    @objc func showOrHideSortMenuView() {
//        if sortMenuView.isHidden {
//            sortMenuView.isHidden = false
//            view.bringSubviewToFront(sortMenuView)
//        } else {
//            sortMenuView.isHidden = true
//        }
    }
    
}

#Preview {
    SortButton()
}

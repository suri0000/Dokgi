//
//  SegmentControlView.swift
//  Dokgi
//
//  Created by 송정훈 on 6/14/24.
//

import UIKit
import SnapKit
import Then

final class SegmentControlView: UIView {
    private let segmentTitles = ["Page", "%"]
    var buttons: [UIButton] = []
    
    var selectedIndex: Int = 0 {
        didSet {
            updateButtonColors()
        }
    }
    
    private var selectedColor: UIColor? {
        didSet {
            updateButtonColors()
        }
    }
    
    private let stackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 0
        $0.layer.cornerRadius = 13
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(resource: .charcoalBlue).cgColor
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        setupButtons()
    }
    
    private func setupButtons() {
        segmentTitles.enumerated().forEach { index, title in
            let button = UIButton(type: .system).then {
                $0.setTitle(title, for: .normal)
                $0.titleLabel?.textAlignment = .center
                $0.tag = index
            }
            
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    private func updateButtonColors() {
        buttons.enumerated().forEach { index, button in
            button.backgroundColor = (index == selectedIndex) ? .charcoalBlue : .clear
            button.titleLabel?.font = (index == selectedIndex) ? Pretendard.medium.dynamicFont(style: .footnote) : Pretendard.medium.dynamicFont(style: .footnote)
            button.setTitleColor((index == selectedIndex) ? .white : .charcoalBlue, for: .normal)
            button.titleLabel?.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview().inset(6)
                $0.horizontalEdges.equalToSuperview().inset(12)
            }
        }
    }
}

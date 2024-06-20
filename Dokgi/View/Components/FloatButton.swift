//
//  FloatButton.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/13/24.
//

import UIKit

class FloatButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFloatButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFloatButton()
    }

    private func setupFloatButton() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 35
        self.backgroundColor = .charcoalBlue
        self.setImage(.plus, for: .normal)
        self.tintColor = .white
    }
}

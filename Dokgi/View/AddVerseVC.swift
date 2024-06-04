//
//  AddVerseVC.swift
//  Dokgi
//
//  Created by 한철희 on 6/4/24.
//

import UIKit
import SnapKit

class AddVerseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        initLayout()
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .systemRed
        return sv
    }()
    
    let viewInScroll: UIView = {
        let uv = UIView()
        uv.translatesAutoresizingMaskIntoConstraints = false
        uv.backgroundColor = .systemBlue
        return uv
    }()
    
    let scanButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("구절 스캔", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold) // 세미볼드 글꼴 설정
        btn.setTitleColor(.black, for: .normal) // 글씨 색상을 검은색으로 설정
        btn.backgroundColor = .lightSkyBlue // 버튼 배경색 추가 (선택 사항)
        btn.setImage(UIImage(named: "camera.viewfinder"), for: .normal) // 버튼 이미지 설정
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0) // 이미지와 텍스트 간의 여백 조정
        btn.layer.cornerRadius = 15
        return btn
    }()

    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(viewInScroll)
        view.addSubview(scanButton)
    }
    
    func initLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        viewInScroll.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.width.equalTo(scrollView.snp.width)
            // Height constraint can be added if content is known
            make.height.equalTo(1000)
        }
        
        scanButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.width.equalTo(112)
            make.height.equalTo(35)
        }
    }
}

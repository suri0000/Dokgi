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
        setupActions()
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let viewInScroll: UIView = {
        let uv = UIView()
        uv.translatesAutoresizingMaskIntoConstraints = false
        return uv
    }()
    
    let scanButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("구절 스캔", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold) // 세미볼드 글꼴 설정
        btn.setTitleColor(UIColor(named: "CharcoalBlue"), for: .normal) // 글씨 색상을 검은색으로 설정
        btn.backgroundColor = .lightSkyBlue // 버튼 배경색 추가 (선택 사항)
        btn.setImage(UIImage(named: "camera.viewfinder"), for: .normal) // 버튼 이미지 설정
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0) // 이미지와 텍스트 간의 여백 조정
        btn.layer.cornerRadius = 18
        btn.tintColor = UIColor(named: "CharcoalBlue")
        return btn
    }()
    
    let infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightSkyBlue
        view.layer.cornerRadius = 15
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "camera") // 이미지 이름을 적절히 수정하세요
        imageView.contentMode = .scaleAspectFit // 이미지의 비율을 유지하면서 이미지뷰에 맞춥니다.
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "책 제목"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "저자"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(named: "BookTextGray")
        return label
    }()
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(viewInScroll)
        viewInScroll.addSubview(scanButton)
        viewInScroll.addSubview(infoView)
        infoView.addSubview(imageView)
        infoView.addSubview(titleLabel)
        infoView.addSubview(authorLabel)
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
            make.height.equalTo(1000) // 임시로 1000으로 설정
        }
        
        scanButton.snp.makeConstraints { make in
            make.top.equalTo(viewInScroll.snp.top).offset(10)
            make.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
            make.width.equalTo(112)
            make.height.equalTo(35)
        }
        
        infoView.snp.makeConstraints { make in
            make.centerY.equalTo(viewInScroll.snp.top).offset(170)
            make.leading.equalTo(viewInScroll.snp.leading).offset(16)
            make.trailing.equalTo(viewInScroll.snp.trailing).offset(-16)
            make.height.equalTo(200) // 적절한 높이 설정
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(infoView.snp.leading).offset(16)
            make.centerY.equalTo(infoView.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(16)
            make.top.equalTo(infoView.snp.top).offset(16)
            make.trailing.equalTo(infoView.snp.trailing).offset(-16)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.trailing.equalTo(infoView.snp.trailing).offset(-16)
        }
        
        scrollView.contentSize = viewInScroll.bounds.size
    }
    
    func setupActions() {
        scanButton.addTarget(self, action: #selector(scanButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func scanButtonTapped(_ sender: UIButton) {
        // 구절 스캔 버튼이 눌렸을 때 실행될 액션 구현
        print("구절 스캔 버튼이 눌렸습니다.")
    }
}

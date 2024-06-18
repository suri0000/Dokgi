//
//  WidgetViewModel.swift
//  Dokgi
//
//  Created by 예슬 on 6/19/24.
//

import Combine
import Foundation
import RxSwift
import RxCocoa

class WidgetViewModel: ObservableObject {
    @Published var verses: [String] = []
    private var disposeBag = DisposeBag()
    
    init() {
        CoreDataManager.shared.bookData
            .asObservable()
            .subscribe(onNext: { [weak self] verses in
                self?.verses = verses.map { $0.text }
            })
            .disposed(by: disposeBag)
    }
}

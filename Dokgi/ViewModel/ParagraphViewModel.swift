//
//  ParagraphViewModel.swift
//  Dokgi
//
//  Created by 예슬 on 6/17/24.
//

import Foundation
import RxCocoa
import RxSwift

class ParagraphViewModel {
    var disposeBag = DisposeBag()
    var paragraphData = BehaviorRelay<[(String, String)]>(value: [("", "")])
    
    init() {
        CoreDataManager.shared.bookData
            .map { $0.map {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yy. MM. dd"
                let dateString = dateFormatter.string(from: $0.date)
                return ($0.text, dateString)
            }
            .sorted { $0.1 > $1.1 }
            }
            .subscribe(onNext: { [weak self] versesAndDates in
                self?.paragraphData.accept(versesAndDates)
            })
            .disposed(by: disposeBag)
    }
}

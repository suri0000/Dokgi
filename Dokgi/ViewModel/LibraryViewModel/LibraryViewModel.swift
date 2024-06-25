//
//  LibrarySearchViewModel.swift
//  Dokgi
//
//  Created by 송정훈 on 6/18/24.
//
import Foundation
import RxCocoa
import RxSwift

class LibraryViewModel {
    var libraryData = BehaviorRelay<[Verse]>(value: [])
    private var saveData = [Verse]()
    
    func dataFilter(verses: [Verse]) {
        let tmpVerse = verses.sorted { $0.date > $1.date }
        self.saveData = []
        for verse in tmpVerse {
            if saveData.filter({ $0.name == verse.name }).isEmpty == true {
                self.saveData.append(verse)
            }
        }
        self.libraryData.accept(saveData)
    }
    
    func dataSearch(text: String) {
        if text.isEmpty == true {
            self.libraryData.accept(self.saveData)
        } else {
            let verse = self.saveData.filter { $0.name.contains(text) }
            self.libraryData.accept(verse)
        }
    }
    
    func dataLatest() {
        let verse = self.libraryData.value.sorted { $0.date > $1.date }
        self.libraryData.accept(verse)
    }
    
    func dataOldest() {
        let verse = self.libraryData.value.sorted { $0.date < $1.date }
        self.libraryData.accept(verse)
    }
}

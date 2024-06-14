//
//  CoreDataManager.swift
//  Dokgi
//
//  Created by 송정훈 on 6/10/24.
//
import CoreData
import RxCocoa
import RxSwift
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    var bookData = BehaviorRelay<[Verse]>(value: [])
    
    var persistent: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    func saveData(verse: Verse) {
        guard let context = self.persistent?.viewContext else { return }
        
        do {
            let newVerse = ParagraphEntity(context: context)
            newVerse.name = verse.name
            newVerse.author = verse.author
            newVerse.image = verse.image
            newVerse.text = verse.text
            newVerse.pageNum = Int32(verse.pageNumber)
            newVerse.pageType = verse.pageType == "%" ? true : false
            newVerse.date = verse.date
            newVerse.keywords = verse.keywords
            try context.save()
        } catch {
            print("Failed to fetch or save data: \(error)")
        }
        
        CoreDataManager.shared.bookData.accept(CoreDataManager.shared.bookData.value + [verse])
    }
    
    func readData() {
        guard let context = self.persistent?.viewContext else { return }
        let fetchRequest: NSFetchRequest<ParagraphEntity> = ParagraphEntity.fetchRequest()
        
        do {
            let books = try context.fetch(fetchRequest)
            var verse = [Verse]()
            for book in books {
                verse.append(Verse(name: book.name!, author: book.author!, image: book.image!, text: book.text!, pageNumber: Int(book.pageNum), pageType: book.pageType == true ? "%" : "page", keywords: book.keywords ?? [], date: book.date!))
            }
            bookData.accept(verse)
        } catch {
            print("Failed to fetch or read data: \(error)")
        }
    }
    
    func deleteData(verse: Verse) {
        guard let context = self.persistent?.viewContext else { return }
        let fetchRequest: NSFetchRequest<ParagraphEntity> = ParagraphEntity.fetchRequest()
        let namePredicate = NSPredicate(format: "name == %@", verse.name)
        let textPredicate = NSPredicate(format: "text == %@", verse.text)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, textPredicate])
        
        do {
            let books = try context.fetch(fetchRequest)
            if let book = books.first {
                context.delete(book)
                try context.save()
            }
        } catch {
            print("Failed to fetch or delete data: \(error)")
        }
    }
    
    func updateData(verse: Verse) {
        guard let context = self.persistent?.viewContext else { return }
        let fetchRequest: NSFetchRequest<ParagraphEntity> = ParagraphEntity.fetchRequest()
        let namePredicate = NSPredicate(format: "name == %@", verse.name)
        let textPredicate = NSPredicate(format: "text == %@", verse.text)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, textPredicate])
        
        do {
            let books = try context.fetch(fetchRequest)
            if books.first != nil {
                let book = books.first
                book?.text = verse.text
                book?.keywords = verse.keywords
                try context.save()
            }
        } catch {
            print("Failed to fetch or update data: \(error)")
        }
    }
}

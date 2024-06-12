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
    
    var bookData = BehaviorRelay<[Book]>(value: [])
    var paragraphData = BehaviorRelay<[Paragraph]>(value: [])
    var persistent: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    func saveData(paragraph: Paragraph, bookImage: String) {
        guard let context = self.persistent?.viewContext else { return }
        
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        let namePredicate = NSPredicate(format: "name == %@", paragraph.bookName)
        let authorPredicate = NSPredicate(format: "author == %@", paragraph.bookAuthor)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, authorPredicate])
        do {
            let books = try context.fetch(fetchRequest)
            if let book = books.first {
                let newParagraph = ParagraphEntity(context: context)
                newParagraph.paragraph = paragraph.paragraph
                newParagraph.page = paragraph.page
                newParagraph.date = paragraph.date
                for keyword in paragraph.keyword {
                    let newKeyword = KeywordEntity(context: context)
                    newKeyword.keyword = keyword
                    newParagraph.addToKeyword(newKeyword)
                }
                book.addToParagraph(newParagraph)
                try context.save()
            } else {
                let newbook = BookEntity(context: context)
                newbook.name = paragraph.bookName
                newbook.author = paragraph.bookAuthor
                newbook.id = Int32(bookData.value.count)
                newbook.image = bookImage
                
                let newParagraph = ParagraphEntity(context: context)
                newParagraph.paragraph = paragraph.paragraph
                newParagraph.page = paragraph.page
                newParagraph.date = paragraph.date
                
                for keyword in paragraph.keyword {
                    let newKeyword = KeywordEntity(context: context)
                    newKeyword.keyword = keyword
                    newParagraph.addToKeyword(newKeyword)
                }
                newbook.addToParagraph(newParagraph)
                try context.save()
            }
        } catch {
            print("Failed to fetch or save user: \(error)")
        }
    }
    
    func getParagraphData() {
        guard let context = self.persistent?.viewContext else { return }
        let requestParagraph = NSFetchRequest<ParagraphEntity>(entityName: "ParagraphEntity")
        let requestKeyword = NSFetchRequest<KeywordEntity>(entityName: "KeywordEntity")
        
        do {
            let paragraphs = try context.fetch(requestParagraph)
            let keywords = try context.fetch(requestKeyword)
            var tmpParagraph = [Paragraph]()
            var tmpKeyword = [String]()
            
            for keyword in keywords {
                tmpKeyword.append(keyword.keyword!)
            }
            
            for paragraph in paragraphs {
                tmpParagraph.append(Paragraph(bookId: (paragraph.book?.id)!, bookName: (paragraph.book?.name)!, bookAuthor: (paragraph.book?.author)!, paragraph: paragraph.paragraph!, page: paragraph.page!, date: paragraph.date!, keyword: tmpKeyword))
            }
            
            CoreDataManager.shared.paragraphData.accept(tmpParagraph)
        } catch {
            print("ERROR FETCHING CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func getBookData() {
        guard let context = self.persistent?.viewContext else { return }
        let requestBook = NSFetchRequest<BookEntity>(entityName: "BookEntity")
        let requestParagraph = NSFetchRequest<ParagraphEntity>(entityName: "ParagraphEntity")
        let requestKeyword = NSFetchRequest<KeywordEntity>(entityName: "KeywordEntity")
        
        do {
            let books = try context.fetch(requestBook)
            let paragraphs = try context.fetch(requestParagraph)
            let keywords = try context.fetch(requestKeyword)
            
            var tmpBook = [Book]()
            var tmpParagraph = [Paragraph]()
            var tmpKeyword = [String]()
            
            for keyword in keywords {
                tmpKeyword.append(keyword.keyword!)
            }
            
            for paragraph in paragraphs {
                tmpParagraph.append(Paragraph(bookId: (paragraph.book?.id)!, bookName: (paragraph.book?.name)!, bookAuthor: (paragraph.book?.author)!, paragraph: paragraph.paragraph!, page: paragraph.page!, date: paragraph.date!, keyword: tmpKeyword))
            }
            
            for book in books {
                tmpBook.append(Book(id: book.id, name: book.name!, author: book.author!, image: book.image!,paragraphs: tmpParagraph.filter {$0.bookId == book.id}))
            }
            CoreDataManager.shared.bookData.accept(tmpBook)
            CoreDataManager.shared.paragraphData.accept(tmpParagraph)
        } catch {
            print("ERROR FETCHING CORE DATA")
            print(error.localizedDescription)
        }
    }
    
    func deleteKeyword(paragraph: Paragraph, keyword: String) {
        guard let context = self.persistent?.viewContext else { return }
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", paragraph.bookId)
        
        do {
            let books = try context.fetch(fetchRequest)
            if books.first != nil {
                let request: NSFetchRequest<ParagraphEntity> = ParagraphEntity.fetchRequest()
                request.predicate = NSPredicate(format: "paragraph == %@", paragraph.paragraph)
                let paragraphRequest = try context.fetch(request)
                if let paragraphFirst = paragraphRequest.first {
                    let request: NSFetchRequest<KeywordEntity> = KeywordEntity.fetchRequest()
                    request.predicate = NSPredicate(format: "keyword == %@", keyword)
                    let keywordRequest = try context.fetch(request)
                    paragraphFirst.removeFromKeyword(keywordRequest.first!)
                }
                try context.save()
            }
        } catch {
            print("삭제 실패 하였습니다.")
        }
    }
    
    func deleteParagraph(paragraph: Paragraph) {
        guard let context = self.persistent?.viewContext else { return }
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", paragraph.bookId)
        
        do {
            let books = try context.fetch(fetchRequest)
            if let book = books.first {
                let request: NSFetchRequest<ParagraphEntity> = ParagraphEntity.fetchRequest()
                request.predicate = NSPredicate(format: "paragraph == %@", paragraph.paragraph)
                let paragraphRequest = try context.fetch(request)
                if let paragraphFirst = paragraphRequest.first {
                    book.removeFromParagraph(paragraphFirst)
                }
                try context.save()
            }
        } catch {
            print("삭제 실패 하였습니다.")
        }
    }
    
    func deleteBook(book: Book) {
        guard let context = self.persistent?.viewContext else { return }
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", book.id)
        
        do {
            let books = try context.fetch(fetchRequest)
            if let book = books.first {
                context.delete(book)
                try context.save()
            }
        } catch {
            print("삭제 실패 하였습니다.")
        }
    }
    
    func updateParagraph(paragraph: Paragraph, text: String) {
        guard let context = self.persistent?.viewContext else { return }
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", paragraph.bookId)
        
        do {
            let books = try context.fetch(fetchRequest)
            if books.first != nil {
                let request: NSFetchRequest<ParagraphEntity> = ParagraphEntity.fetchRequest()
                request.predicate = NSPredicate(format: "paragraph == %@", text)
                let paragraphRequest = try context.fetch(request)
                if let paragraphFirst = paragraphRequest.first {
                    paragraphFirst.paragraph = paragraph.paragraph
                    for keyword in paragraph.keyword {
                        let newKeyword = KeywordEntity(context: context)
                        newKeyword.keyword = keyword
                        paragraphFirst.addToKeyword(newKeyword)
                    }
                }
                try context.save()
            }
        } catch {
            print("삭제 실패 하였습니다.")
        }
    }
}

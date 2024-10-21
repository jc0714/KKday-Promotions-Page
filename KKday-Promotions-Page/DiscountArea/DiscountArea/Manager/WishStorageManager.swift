

import Foundation
import UIKit
import CoreData


class WishStorageManager {
    
    static let shared = WishStorageManager()
    
    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
        }
        self.persistentContainer = appDelegate.persistentContainer
    }
    
    func toggleWishlistStatus(for productId: String, isSelected: Bool) {
        if isSelected {
            saveOrder(productId: productId)
        } else {
            deleteOrder(productId: productId)
        }
    }
    
    func isProductInWishlist(productId: String) -> Bool {
        let fetchRequest: NSFetchRequest<WishList> = WishList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %@", productId)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to check if product is in wishlist: \(error)")
            return false
        }
    }
    
    // MARK: - Private methods
    
    private func saveOrder(productId: String) {
        let wishList = WishList(context: context)
        wishList.productId = productId
        saveContext()
    }
    
    private func deleteOrder(productId: String) {
        let fetchRequest: NSFetchRequest<WishList> = WishList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %@", productId)
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                context.delete(result)
            }
            saveContext()
            
        } catch {
            print("Failed to delete product with ID \(productId): \(error)")
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
            
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

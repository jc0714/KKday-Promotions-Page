

import Foundation
import CoreData


extension WishList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WishList> {
        return NSFetchRequest<WishList>(entityName: "WishList")
    }

    @NSManaged public var productId: String?

}

extension WishList : Identifiable {

}

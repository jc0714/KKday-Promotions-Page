

import Foundation

//MARK: - Page Data
struct ResponsePageData: Codable {
    let code: String
    let errmsg: String?
    let data: ResponsePageData2
}

struct ResponsePageData2: Codable {
    let code: String
    let errmsg: String?
    let data: PageData
}

struct PageData: Codable {
    let dealPageOid: Int
    let name: String
    let market: String
    let platform: String
    let startTime: String
    let endTime: String
    let categories: [Category]
    let title: String?
    let ctaUrl: String?
    let layout: String?
    let ctaText: String?
    let subtitle: String?
}

struct Category: Codable {
    let dealPageCategoryOid: Int
    let name: String
    let sort: Int
    var config: [Config]
}

struct Config: Codable {
    let sort: Int
    let type: String
    var detail: Detail
}

struct Detail: Codable {
    var tabs: [Tab]?
    let title: String?
    let ctaUrl: String?
    let layout: String?
    let ctaText: String?
    let endTime: String?
    let subtitle: String?
    let startTime: String?
    var products: [Product]?
    let merchantCoupons: [MerchantCoupon]?
    let coupons: [Coupon]?
    let guides: [Guide]?
    let contents: [String]?
    
    var productDetails: [ProductData]?
}

struct Tab: Codable {
    let name: String
    let products: [Product]
    
    var productDetails: [ProductData]?
}

struct Product: Codable {
    let name: String?
    let label: String?
    let productUrlId: String
}

struct Guide: Codable {
    let title: String
    let imageUrl: String
    let link: String
    let isShowVideoPlayIcon: Bool
}


struct MerchantCoupon: Codable {
    let desc: String
    let title: String
    let endTime: String
    let imageUrl: String
    let startTime: String
    let logoImageUrl: String
}

//MARK: - Product Data
struct ResponseProductData: Codable {
    let code: String
    let data: [ProductData]
    let errmsg: String?
}

struct ProductData: Codable {
    let currency: String
    let discount: Float
    let id: String
    let imgUrl: String
    let name: String
    let originPrice: String
    let price: String
    let ratingCount: Int
    let ratingStar: Double
}

//MARK: - Coupon
struct Coupon: Codable {
    let desc: String
    let title: String
    let endTime: String?
    let startTime: String?
    let couponCode: String
    
    var isExpired: Bool {
        guard let endDate = parseDate(from: endTime) else { return false }
        return endDate < Date()
    }
    
    var daysRemaining: Int {
        return timeRemainingComponent(.day)
    }
  
    var hoursRemaining: Int {
        return timeRemainingComponent(.hour)
    }
    
    var minutesRemaining: Int {
        return timeRemainingComponent(.minute)
    }
    
   
    var secondsRemaining: Int {
        return timeRemainingComponent(.second)
    }
    
    private func timeRemainingComponent(_ component: Calendar.Component) -> Int {
        guard let endDate = parseDate(from: endTime) else { return 0 }
        let currentDate = Date()
        
        if endDate < currentDate {
            return 0
        }
        
        let remainingTime = Calendar.current.dateComponents([component], from: currentDate, to: endDate)
        return remainingTime.value(for: component) ?? 0
    }
    
    func parseDate(from dateString: String?) -> Date? { 
        guard let dateString = dateString else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: dateString)
    }
}

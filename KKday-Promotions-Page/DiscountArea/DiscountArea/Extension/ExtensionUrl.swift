

import Foundation
import UIKit

func open(urlString: String) {
    guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
        print("Invalid URL or cannot open URL")
        return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
}

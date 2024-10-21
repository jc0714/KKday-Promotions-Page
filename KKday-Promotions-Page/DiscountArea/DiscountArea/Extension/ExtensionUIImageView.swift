

import UIKit

extension UIImageView {
    
    func loadImage(from url: URL, completion: ((UIImage?) -> Void)? = nil) {
        
        //self.image = UIImage(systemName: "photo")?.withTintColor(.gray)
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self, let data = data, error == nil else {
                print("Error fetching image: \(String(describing: error))")
                return
            }
            
            if let downloadedImage = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    self.image = downloadedImage
                    completion?(downloadedImage)
                }
            }
        }
        task.resume()
    }

    func loadImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("Failed to download image: \(error)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to convert data to image")
                return
            }

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

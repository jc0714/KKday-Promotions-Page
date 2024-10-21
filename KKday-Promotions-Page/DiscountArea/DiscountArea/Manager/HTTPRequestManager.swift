

import Foundation

protocol HTTPRequestManagerDelegate: AnyObject  {
    func manager(_ manager: HTTPRequestManager, didGet pageData: ResponsePageData)

    func manager(_ manager: HTTPRequestManager, didFailWith error: Error)
}

class HTTPRequestManager {
    
    weak var delegate: HTTPRequestManagerDelegate?
    
    func fetchPageData() {
        guard let url = URL(string: "https://aw-api.creziv.com/pages") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic Z3Vhbmh1YTp3YW5n", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.manager(self, didFailWith: error)
                    print("Error: ", error)
                }
            }
            
            if let data {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let pageData = try decoder.decode(ResponsePageData.self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.manager(self, didGet: pageData)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.delegate?.manager(self, didFailWith: error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func fetchProductData(productList: [String], completion: @escaping (Result<[ProductData], Error>) -> Void) {
        guard let url = URL(string: "https://aw-api.creziv.com/search") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic Z3Vhbmh1YTp3YW5n", forHTTPHeaderField: "Authorization")
        
        let json: [String: Any] = [
            "product_id": productList
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from post data")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    let serverError = NSError(domain: "ServerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Server error"])
                    completion(.failure(serverError))
                }
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let productData = try decoder.decode(ResponseProductData.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(productData.data))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                        print("Decoding error: \(error)")
                    }
                }
            }
        }
        
        task.resume()
    }

}

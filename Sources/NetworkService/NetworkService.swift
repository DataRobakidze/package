// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

enum ForError: Error {
    case decodeError
    case wrongResponse
    case wrongStatusCode(code: Int)
}


public class NetworkService {
    public init() {
        
    }
    public func getData<T: Decodable>(urlString: String, completion: @escaping (Result<T,Error>) -> (Void)) {
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) {  data, response, error in
            if let error {
                print(error.localizedDescription)
            }
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                print("error")
                return
            }
            
            guard let data else { return }
                 
            do {
                let Json = try JSONDecoder().decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(Json))
                }
            } catch {
                completion(.failure(ForError.decodeError))
            }
        }.resume()
    }
}

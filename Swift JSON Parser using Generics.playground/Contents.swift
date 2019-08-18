//
//  Swift JSON Parser using Generics
//
//  Created by Tim Mikelj.

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidData
    case decodingError
    case serverError
}

class JSONParser {
    
    typealias result<T> = (Result<[T], Error>) -> Void
    
    func downloadList<T: Decodable>(of type: T.Type, from url: URL, completion: @escaping result<T>) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(DataError.invalidResponse))
                return
            }
            
            if 200 ... 299 ~= response.statusCode {
                if let data = data {
                    do {
                        let decodedData: [T] = try JSONDecoder().decode([T].self, from: data)
                        completion(.success(decodedData))
                    }
                    catch {
                        completion(.failure(DataError.decodingError))
                    }
                } else {
                    completion(.failure(DataError.invalidData))
                }
            } else {
                completion(.failure(DataError.serverError))
            }
        }.resume()
    }
    
}

//////////////
// Example //
/////////////

struct Animal: Decodable {
    let name: String
    let description: String
    let maxWeightInLbs: Int
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case maxWeightInLbs = "max_weight_lbs"
    }
}

let url = URL(string: "http://www.json-generator.com/api/json/get/cgtNBfTPiq?indent=2")!
let jsonParser = JSONParser()

jsonParser.downloadList(of: Animal.self, from: url) { (result) in
    switch result {
        
    case .failure(let error):
        if error is DataError {
            print(error)
        } else {
            print(error.localizedDescription)
        }
        print(error.localizedDescription)
        
    case .success(let animals):
        print(animals)
    }
}

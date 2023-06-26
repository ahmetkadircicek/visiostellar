//
//  APICaller.swift
//  Visio
//
//  Created by Ahmet on 26.06.2023.
//

import Foundation

struct Constants {
    static let API_KEY = "xTUhqt4AF4maIdflNmPxNNM9jZ29eaKgUDSdqmK8"
    static let baseURL = "https://api.spaceflightnewsapi.net/v3/articles?_limit=10"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getSpaceNews(completion: @escaping (Result<[Data], Error>) -> Void) {
        guard let url = URL(string: Constants.baseURL) else {
            completion(.failure(APIError.failedToGetData))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let results = try JSONDecoder().decode([Data].self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

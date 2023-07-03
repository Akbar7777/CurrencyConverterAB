//
//  NetworkAdapter.swift
//  CurrencyConverterAB
//
//  Created by Akbar on 03/07/23.
//

import Foundation


struct NetworkManager {
    func sendRequest<Target: RouterProtocol, Response: GeneralResponse>(target: Target, completion: @escaping (Result<Response, Error>) -> Void) {
        var request = URLRequest(url: target.url)
        request.httpMethod = target.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let responseObject = try decoder.decode(Response.self, from: data)

                if (200...299).contains(httpResponse.statusCode) && responseObject.error == nil {
                    completion(.success(responseObject))
                } else {
                    completion(.failure(NetworkError.httpError(statusCode: httpResponse.statusCode, response: responseObject.error)))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
//    private func setBody() {
//        if let requestBody = requestBody {
//            do {
//                let jsonData = try JSONEncoder().encode(requestBody)
//                request.httpBody = jsonData
//            } catch {
//                completion(.failure(error))
//                return
//            }
//        }
//    }
}

enum NetworkError: Error {
    case invalidResponse
    case noData
    case httpError(statusCode: Int, response: Any)
}

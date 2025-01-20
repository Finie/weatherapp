//
//  ApiClient.swift
//  weatherapp
//
//  Created by fin on 19/01/2025.
//

import Foundation

class ApiClient{
    static let shared = ApiClient()
    
    @EnvironmentKey("API_URL")
    var baseURL:String
    
    
    
    private init(){
        
    }
    
    
    func createURL(endpoint:String,  method:String, parameters: [String: Any]? = nil) -> URL? {
        
        let urlString = baseURL + endpoint
        
        var components = URLComponents(string: urlString)
        
        if method == "GET", let parameters = parameters {
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        return components?.url
    }
    
    
    func request<T:Codable>(endpoint:String,  method:NetworkMethod, parameters: [String: Any]? = nil, completion:@escaping (Result<T,Error>)->Void){
        
        guard let requestUrl = createURL(endpoint: endpoint,  method: method.rawValue, parameters: parameters) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        
        
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            
   
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "InvalidResponse", code: -2, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -3, userInfo: nil)))
                return
            }
            
            
        
            
            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let decodedResponse = try decoder.decode(T.self, from: data)
                
                
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
        
        
    }
    
    
}

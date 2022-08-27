//
//  Network.swift
//  unsplashSearch
//
//  Created by Ashutosh Mane on 26/08/22.
//

//import Foundation
//
//protocol APIResource{
//    associatedtype ModelType:Decodable
//    var searchTerm:String?{ get }
//    var path:String{ get }
//}
//
//extension APIResource{
//    //computed property url
//    
//    
////Authorization: Client-ID YOUR_ACCESS_KEY
//    var url:URL{
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "api.unsplash.com"
//        components.path=path
//        components.queryItems = [URLQueryItem(name: "client_id", value:                "1l_6Ii8HHJk8jNGMJyL7AjqLCidwY9DkXojXwBJaqA8"),
//                                  URLQueryItem(name: "query", value: searchTerm),
//                                  URLQueryItem(name: "per_page", value: "1")]
//        
//    
//        return (components.url)!
//        
//    }
//    
//    
//}
//
//protocol NetworkRequest: AnyObject {
//    
//    associatedtype ModelType
//    func decode(_ data: Data) -> [ModelType]?
//    func execute(withCompletion completion: @escaping (Result<([ModelType]?),APIError>) -> Void)
//    
//}
//
//
//extension NetworkRequest{
//    
//    func load(_ url: URL, withCompletion completion: @escaping (Result<([ModelType]?),APIError>) -> Void) {
//            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error ) -> Void in
//
//                guard let data = data, let value = self?.decode(data) else {
//                    DispatchQueue.main.async { completion(.failure(.generic))
//                        
//                        print(response! as URLResponse)
//                    }
//                    return
//                }
//                DispatchQueue.main.async { completion(.success(value)) }
//            }
//            task.resume()
//        }
//
//}

//
//  Network.swift
//  unsplashSearch
//
//  Created by Ashutosh Mane on 26/08/22.
//

import Foundation

protocol APIResource{
    associatedtype ModelType:Decodable
    var searchTerm:String?{ get }
    var path:String{ get }
    var page:Int?{get}
}

extension APIResource{
    //computed property url
    
    
    //Authorization: Client-ID YOUR_ACCESS_KEY
    var url:URL?{
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path=path
        var queryItems:[URLQueryItem] = [URLQueryItem(name: "client_id", value:                "1l_6Ii8HHJk8jNGMJyL7AjqLCidwY9DkXojXwBJaqA8"),
                                 URLQueryItem(name: "query", value: searchTerm),
                                 URLQueryItem(name: "per_page", value: "30"),
                                         URLQueryItem(name: "orientation", value: "portrait"), URLQueryItem(name: "page", value: String(page!))]
        components.queryItems = queryItems
       
       guard let url = components.url else {
            return nil
        }
        return url
        
    }
    
    
}

protocol NetworkRequest: AnyObject {
    
    associatedtype ModelType:Decodable
    func decode(_ data: Data) throws -> Wrapper<ModelType>?
    func execute(withCompletion completion: @escaping (Result<(Wrapper<ModelType>?),Error>) -> Void)
    
    func cancelTask()
    
    
}


extension NetworkRequest{
    
    func cancelTask() {
    
    }
    
    func loadTask(_ url: URL, withCompletion completion: @escaping (Result<(Wrapper<ModelType>?),Error>) -> Void)-> URLSessionDataTask{
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error ) -> Void in

            let response = response as! HTTPURLResponse
            guard let data = data, response.statusCode == 200 else {
                
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            do {
                
                    let ImageData = try self?.decode(data)
                    DispatchQueue.main.async {
                         completion(.success(ImageData))
                    }
               
            }
            catch {
                DispatchQueue.main.async {
                    let e = error
                    completion(.failure(e))
                }
            }
            
            
        }
        
        return task
    }
    
}




class ImageSearchResource:APIResource{
    var page: Int?
    
    var searchTerm: String?
    
    var path: String = "/search/photos"
    
    typealias ModelType = Image
    
    init(with searchTerm: String, onPage page:Int?){
        self.searchTerm = searchTerm
        guard let page = page else {
            self.page = 1
            return
        }
        self.page = page
        
       
    }
    
    func nextPage() {
        let tempPage = page
        self.page! = tempPage! + 1
        print("page value found and changed")
    }
}


class ImageSearchRequest<Resource:APIResource>{
    
    var resource: Resource
    
    var task : URLSessionDataTask?
    
    init(for resource: Resource) {
        self.resource = resource
    }
    
    
}

extension ImageSearchRequest:NetworkRequest{
    
    func cancelTask() {

        guard let task = task, task.state == .running else {
            print("stat says\(task?.state)")
            return
            
        }
        print("stat cancelled\(task.state)")
        task.cancel()
        
    }
   
    
    typealias ModelType = Resource.ModelType
    
    func decode(_ data: Data) throws -> Wrapper<Resource.ModelType>? {
        let decoder = JSONDecoder()
        do{
            let wrapper = try decoder.decode(Wrapper<Resource.ModelType>.self, from: data)
            return wrapper
        }
        catch {
            throw error
            
        }
        
        
    }
    
    func execute(withCompletion completion: @escaping (Result<(Wrapper<ModelType>?), Error>) -> Void) {
        self.task =  loadTask(resource.url!, withCompletion: completion)
        task?.resume()
    }
    
    
    
}

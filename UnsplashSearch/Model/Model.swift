//
//  Model.swift
//  unsplashSearch
//
//  Created by Ashutosh Mane on 22/08/22.
//

import Foundation

//MARK: JSON Sample for image search

/*
 {
   "total": 133,
   "total_pages": 7,
   "results": [
     {
       "id": "eOLpJytrbsQ",
       "created_at": "2014-11-18T14:35:36-05:00",
       "width": 4000,
       "height": 3000,
       "color": "#A7A2A1",
       "blur_hash": "LaLXMa9Fx[D%~q%MtQM|kDRjtRIU",
       "likes": 286,
       "liked_by_user": false,
       "description": "A man drinking a coffee.",
       "user": {
         "id": "Ul0QVz12Goo",
         "username": "ugmonk",
         "name": "Jeff Sheldon",
         "first_name": "Jeff",
         "last_name": "Sheldon",
         "instagram_username": "instantgrammer",
         "twitter_username": "ugmonk",
         "portfolio_url": "http://ugmonk.com/",
         "profile_image": {
           "small": "https://images.unsplash.com/profile-1441298803695-accd94000cac?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32&s=7cfe3b93750cb0c93e2f7caec08b5a41",
           "medium": "https://images.unsplash.com/profile-1441298803695-accd94000cac?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64&s=5a9dc749c43ce5bd60870b129a40902f",
           "large": "https://images.unsplash.com/profile-1441298803695-accd94000cac?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128&s=32085a077889586df88bfbe406692202"
         },
         "links": {
           "self": "https://api.unsplash.com/users/ugmonk",
           "html": "http://unsplash.com/@ugmonk",
           "photos": "https://api.unsplash.com/users/ugmonk/photos",
           "likes": "https://api.unsplash.com/users/ugmonk/likes"
         }
       },
       "current_user_collections": [],
       "urls": {
         "raw": "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f",
         "full": "https://hd.unsplash.com/photo-1416339306562-f3d12fefd36f",
         "regular": "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&s=92f3e02f63678acc8416d044e189f515",
         "small": "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&s=263af33585f9d32af39d165b000845eb",
         "thumb": "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=8aae34cf35df31a592f0bef16e6342ef"
       },
       "links": {
         "self": "https://api.unsplash.com/photos/eOLpJytrbsQ",
         "html": "http://unsplash.com/photos/eOLpJytrbsQ",
         "download": "http://unsplash.com/photos/eOLpJytrbsQ/download"
       }
     },
     // more photos ...
   ]
 }

 */
struct Image:Decodable{
    let imageURL: ImageURL
    let description:String?
    let likes:Int?
    let photographer:Person
    let createdOn:String
    
    enum ImageKeys: String, CodingKey {
        case description
        case likes
        case user = "user"
        case createdOn = "created_at"
        case urls = "urls"
    }
    
    
    struct Person: Decodable{
        let username:String
        let name:String?
        let instagram:String?
        let twitter:String?
        let portfolio:String?
        
    }
    enum PhotographerKeys: String, CodingKey{
        case username
        case name
        case portfolio = "portfolio_url"
        case instagram = "instagram_username"
        case twitter = "twitter_username"
        
    }
    
    
    struct ImageURL: Decodable{
        let small:String
        let regular:String
        
    }
    

  
    
    
    init(from decoder: Decoder) throws {
        do{
            
            let imageContainer = try decoder.container(keyedBy: ImageKeys.self)
            self.description = try imageContainer.decodeIfPresent(String.self, forKey: .description)
            self.photographer = try imageContainer.decode(Person.self, forKey: .user)
            self.imageURL = try imageContainer.decode(ImageURL.self, forKey: .urls)
            self.createdOn = try imageContainer.decode(String.self, forKey: .createdOn)
            self.likes = try imageContainer.decodeIfPresent(Int.self, forKey: .likes)
        }
        
        catch {
            throw AppError.decodingError
        }
        
        
    }
    
}


struct Wrapper<T:Decodable>:Decodable{
    var searchTerm:String?
    var totalPages:Int
    var results:[T]
    
    enum Wrapperkeys:String, CodingKey{
        case totalPages = "total_pages"
        case results
    }
    
    init(from decoder: Decoder) throws {
        do {
            let wrapperContainer = try decoder.container(keyedBy: Wrapperkeys.self)
            self.results = try wrapperContainer.decode([T].self, forKey: .results)
            self.totalPages = try wrapperContainer.decode(Int.self, forKey: .totalPages)
            self.searchTerm = nil
            
        }
        catch{
            throw AppError.decodingError
        }
        
    }
    
    init(){
        self.searchTerm=nil
        self.totalPages=0
        self.results = []
    }
    
    
    
}

//
//  RootViewModel.swift
//  FlickerImageApp
//
//  Created by Rahul Nair on 30/06/18.
//  Copyright © 2018 Rahul. All rights reserved.
//

import UIKit

class RootViewModel {
    
    var page = 1
    let perPage = 100
    var total_pages = 0
    
    var dataSource : [ImageDataModel] = []
    
     let networkHelperObj : NetworkHelper = NetworkHelper()

    
    init(){
        
    }
    
    
    func getData(search :String, callBack: @escaping (Result<Bool, Error>) -> Void) {
        
        weak var weakSelf = self
        if page < total_pages {
            page = page + 1
        }
        
        let paramDict :  [URLQueryItem] =  [URLQueryItem(name: "method", value: "flickr.photos.search"),
                                            URLQueryItem(name: "api_key", value: "3e7cc266ae2b0e0d78e279ce8e361736"),
                                            URLQueryItem(name: "format", value: "json"),
                                            URLQueryItem(name: "nojsoncallback", value: "1"),
                                            URLQueryItem(name: "safe_search", value: "1"),
                                            URLQueryItem(name: "text", value: search),
                                            URLQueryItem(name: "page", value: String(page))]
        
        
        
        networkHelperObj.fetchGET_URL(urlString: "https://api.flickr.com/services/rest/", queryItems: paramDict) { (result) in
            
            switch result {
            case .success(let value):
                let jsonString = String(data: value, encoding: String.Encoding.utf8)
                if let dictionary = self.convertDictionaryFromString(jsonString: jsonString!){
                    if let photos : [String:Any] = dictionary["photos"] as? [String : Any] {
                        if let pageNo : Int = photos["page"] as? Int {
                            weakSelf?.page = pageNo
                        }
                        if let totalNo : Int = photos["pages"] as? Int {
                            weakSelf?.total_pages = totalNo
                        }
                        
                        if let photoList : [[String:Any]] = photos["photo"] as? [[String : Any]] {
                            for dict in photoList{
                                var newDataModel : ImageDataModel = ImageDataModel()
                                newDataModel.setData(dictObj: dict)
                                self.dataSource.append(newDataModel)
                            }
                            let result =  Result<Bool, Error>.success(true)
                            callBack(result)
                        }
                    }
                }
            case .failure(let value):
                let result =  Result<Bool, Error>.failure(value)
                callBack(result)

            }
            
            
            
            
        }
        
    }
    
    
    
    private func convertDictionaryFromString(jsonString: String) -> [String: Any]? {
        if let data = jsonString.data(using: .utf8) {
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                return jsonDict
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    


}

//
//  NetworkHelper.swift
//  FlickerImageApp
//
//  Created by Rahul Nair on 28/06/18.
//  Copyright © 2018 Rahul. All rights reserved.
//

import Foundation
import UIKit


enum Result<U, T> {
    case success(U)
    case failure(T)
}


class NetworkHelper {
    private var defaultSession: URLSession?
    
    private var absolutePathForDictionary : String {
        
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        
        print()
        
        return urls.first!.absoluteString
        
        
    }
    private var pathForDictionary : String {
        
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        
        print()
        
        return urls.first!.path

        
    }
  
    init() {
        defaultSession =  URLSession(configuration: .default)

    }
    
     func fetchGET_URL(urlString: String,  queryItems: [URLQueryItem]? ,callBack: @escaping (Result<Data, Error>) -> Void) {
        var encodedUrl: String!
        var dataTask: URLSessionDataTask?

        if var urlComponents = URLComponents(string: urlString ) {
            
            urlComponents.queryItems = queryItems
            guard let url = urlComponents.url else { return }
            var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            dataTask = defaultSession?.dataTask(with: request) { data, response, error in
                defer { dataTask = nil }
                
                if error != nil {
                    let result =  Result<Data, Error>.failure(error!)
                    callBack(result)
                } else {
                    let result =  Result<Data, Error>.success(data!)
                    callBack(result)
                }
            }
            dataTask?.resume()
        }
    }
   
    func  fetchImageFrom(name:String,urlString:String,callBack: @escaping (Result<UIImage, Error>) -> Void) {
        
        print("rrrrrrtrue \(urlString) ")

        
        if FileManager.default.fileExists(atPath: pathForDictionary+"/"+name ){
            //read from filepath
            if let data = NSData(contentsOf: URL(string: absolutePathForDictionary+name)!) {
                if let imageObj = UIImage(data: data as Data){
                    let result =  Result<UIImage, Error>.success(imageObj)
                    callBack(result)
                }
                
            }

            
        }else{
            //download and save and return back
            let queue1 = DispatchQueue(label: "myflickerapp", qos: DispatchQoS.background)

            queue1.async {
                if let url = URL(string: urlString){
                    self.defaultSession?.dataTask(with: url, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            print(error!)
                            let result =  Result<UIImage, Error>.failure(error!)
                            callBack(result)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            if let imageObj = UIImage(data: data!){
                                if let data = UIImageJPEGRepresentation(imageObj, 0.8) {
                                    let filename = URL(string: self.absolutePathForDictionary+name )
                                    try? data.write(to: filename!)
                                    let result =  Result<UIImage, Error>.success(imageObj)
                                    callBack(result)
                                }
                                
                            }
                        }
                    }).resume()
                }
                }
            
            }
        
        
        
    }
}

//
//  ImageDataModel.swift
//  FlickerImageApp
//
//  Created by Rahul Nair on 30/06/18.
//  Copyright © 2018 Rahul. All rights reserved.
//

import Foundation



struct ImageDataModel  {
    var farm : Int?
    var id : String?
    var isfamily : Int?
    var isfriend : Int?
    var ispublic : Int?
    var owner :  String?
    var secret : String?
    var server : String?
    var title:   String?
    var image_url : String?
    var image_name : String?
    mutating func setData(dictObj : [String:Any])  {
        if let farm : Int = dictObj["farm"] as? Int{
            self.farm = farm
        }
        
        if let id : String = dictObj["id"] as? String{
            self.id = id
        }
        
        if let isfamily : Int = dictObj["isfamily"] as? Int{
            self.isfamily = isfamily
        }
        
        if let isfriend : Int = dictObj["isfriend"] as? Int{
            self.isfriend = isfriend
        }
        
        if let ispublic : Int = dictObj["ispublic"] as? Int{
            self.ispublic = ispublic
        }
       
        if let owner : String = dictObj["owner"] as? String{
            self.owner = owner
        }
        
        if let secret : String = dictObj["secret"] as? String{
            self.secret = secret
        }
        
        
        if let server : String = dictObj["server"] as? String{
            self.server = server
        }
        
        if let title : String = dictObj["title"] as? String{
            self.title = title
        }
        
        
        //http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg
        self.image_name = id!+"_"+secret!+".jpg"
        self.image_url = "farm"+String(describing: farm!)+".static.flickr.com/"
        self.image_url = "https://"+self.image_url! + server!+"/"+self.image_name!

        
    }
    
}

//
//  ImageCell.swift
//  FlickerImageApp
//
//  Created by Rahul Nair on 28/06/18.
//  Copyright © 2018 Rahul. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicatior: UIActivityIndicatorView!
    
    var queue = OperationQueue()
    
    override func prepareForReuse() {
        imageView.image = nil
        imageView.image = UIImage(named: "default")
        queue.cancelAllOperations()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showLoading(show:Bool)  {
        self.activityIndicatior.isHidden = show
        self.imageView.isHidden = !show
        
        
    }
    
    func setImageData(data: ImageDataModel){
        imageView.image = nil
        imageView.image = UIImage(named: "default")


        weak var weakSelf = self
        
        
        queue.addOperation {
            NetworkHelper().fetchImageFrom(name: data.image_name!, urlString: data.image_url!, callBack: { (results) in
                
                
                switch results {
                case .success(let image):
                    weakSelf?.imageView.image = image
                case .failure(let val):
                    print("000 \(val)")
                }
            })
        }
        
        
        
        
      
        
    }

}

//
//  ViewController.swift
//  FlickerImageApp
//
//  Created by Rahul Nair on 26/06/18.
//  Copyright © 2018 Rahul. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let rootViewModel : RootViewModel = RootViewModel ()
    var lastIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "image_cell_Identifier")
        
        self.searchBar.enablesReturnKeyAutomatically = false
        self.loadData(search: nil)
        
      
    
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loadData(search:String?){
        
        if search != nil{
            
            
            rootViewModel.getData(search: search!, callBack: { (result) in
                switch result {
                case .success(let _):
                    DispatchQueue.main.async {
                        if(self.rootViewModel.page > 1){
                            self.collectionView.reloadData()
                            self.collectionView.scrollToItem(at: IndexPath(row: self.lastIndex, section: 0), at: UICollectionViewScrollPosition.bottom, animated: false)
                        }else{
                            self.collectionView.reloadData()
                        }
                        
                        
                        
                    }
                    
                    
                case .failure(let _): break
                    
                }
            })
        
        }
        
    }

}

extension RootViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if (searchBar.text?.count)! > 0 {
            self.rootViewModel.dataSource.removeAll()
            self.loadData(search: searchBar.text)
            
        }
    }
   
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("--searchBarTextDidBeginEditing- \(searchBar.text)")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
    }
    
    
}


extension RootViewController :UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = self.collectionView.frame.size.width - 20
        var height : CGFloat = 50.0
        
        if indexPath.row < self.rootViewModel.dataSource.count{
            
            width = (self.collectionView.frame.size.width/3.0) - 10
            height = width
            
        }
        return CGSize(width: width, height: height)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rootViewModel.dataSource.count + 1
    }
    
    
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "image_cell_Identifier", for: indexPath) as! ImageCell
        cell.imageView.image = nil
        
        if indexPath.row < self.rootViewModel.dataSource.count{
            if let data = rootViewModel.dataSource[indexPath.row] as? ImageDataModel {
                NetworkHelper().fetchImageFrom(name: data.image_name!, urlString: data.image_url!, callBack: { (results) in
                    switch results {
                    case .success(let image):
                             currentcell.imageView.image = image
                    }
                    case .failure(let val):
                        print("000 \(val)")
                    }
                })
                
                cell.showLoading(show: true)
            }
        }else{
                cell.showLoading(show: false)
            
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.rootViewModel.dataSource.count{
            lastIndex = indexPath.row
            self.loadData(search: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
       
    }
}

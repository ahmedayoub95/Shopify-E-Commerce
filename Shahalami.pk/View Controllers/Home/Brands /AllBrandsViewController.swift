//
//  AllBrandsViewController.swift
//  Shahalami.pk
//
//  Created by Ahmed on 10/01/2022.
//

import UIKit

class AllBrandsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    var brandsData : Brands?
    
    @IBOutlet var brandCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutSetting(brandCollectionView)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return brandsData?.data?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allBrandCell", for: indexPath as IndexPath) as! allBrandsCollectionViewCell
        
        cell.cellView.addShadow(opacity: 0.4, cornerRadius: 6, shadowRadius: 4.0)
    
        let data = brandsData?.data?[indexPath.row]
        let image_url = data?.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if  image_url != nil {
            cell.brandImageView.sd_setImage(with: URL(string: image_url ?? ""), placeholderImage: UIImage(named: "ic_placeholder")) {
                image, error, _, _ in
                // your code
                if error == nil {
                    cell.brandImageView.contentMode = .scaleAspectFill
                } else {
                    cell.brandImageView.contentMode = .scaleAspectFit
                }
                print(image ?? "")
            }
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cv = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewAllBrandsVC") as! AllBrandsProductsViewController
        let brandName = brandsData?.data?[indexPath.row].title ?? ""
        cv.brandName = brandName
        cv.navigationItem.title = brandsData?.data?[indexPath.row].title ?? ""
        self.navigationController?.pushViewController(cv, animated: true)
    }
    
    // MARK: - Collection View Data Source

    fileprivate func layoutSetting(_ collection: UICollectionView) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width * 0.31, height: view.frame.height * 0.15)
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        collection.collectionViewLayout = layout
    }


}

//
//  BarsVC.swift
//  DIGO
//
//  Created by ADMS on 21/10/21.
//

import UIKit
import MBProgressHUD
import SDWebImage
import Toaster

class BarsVC: UIViewController {

    // MARK: - IBOutlat
    @IBOutlet weak var tblBarsList:UITableView!
    var arrProductList = [productList]()
    var strBarValue:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tblBarsList.showsHorizontalScrollIndicator = false

        tblBarsList.register(UINib(nibName: "GoldCell", bundle: nil), forCellReuseIdentifier: "GoldCell")
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        coinsListApiCall()
    }
}
// MARK: - extension

extension BarsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProductList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoldCell", for: indexPath) as! GoldCell

        cell.imageOfGold.sd_setImage(with: URL(string: API.imageUrl + arrProductList[indexPath.row].ProductImage), placeholderImage: UIImage(named: "placeholder"))
        cell.imageOfGold.contentMode = .scaleToFill
//        cell.imageOfGold.image = UIImage(named: "coin.png")

//        cell.lblEMITitle.text = "\(arrProductList[indexPath.row].ProductName) ₹\(arrProductList[indexPath.row].SalesAmount) EMI \(NSLocalizedString("Digo_Dash_Start", comment: ""))"
        cell.lblEMITitle.text = "\(arrProductList[indexPath.row].ProductName)"

        cell.imageOfGold.layer.cornerRadius = cell.imageOfGold.layer.frame.height/2.0
        cell.imageOfGold.layer.masksToBounds = true

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        productDetailVC.obj = arrProductList[indexPath.row]
        productDetailVC.goldBarCoinsTitle = arrProductList[indexPath.row].ProductName
            //"\(NSLocalizedString("Digo_Gold_Bars", comment: ""))"
        productDetailVC.ProductID =  "\(arrProductList[indexPath.row].ProductID)"
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
}
// MARK: - ApiCalling
extension BarsVC{
    func coinsListApiCall()
    {
        self.arrProductList.removeAll()

        let dispetchGroup = DispatchGroup()
        MBProgressHUD.showAdded(to: self.view, animated: true)

        dispetchGroup.enter()


        var params = [String : Any]()
        params = ["ProductTypeID":"2"]

        ApiHttpUtility.sharedUHttp.callPostHttpUtility(urlString: API.GetProductlist, params: params) { (responceJson) in
            if(responceJson["status"] == "true")
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let arrData = responceJson["data"].array
                for value in arrData! {
                    let pckgDetModel:productList = productList.init(ProductID: value["ProductID"].intValue, ProductType: value["ProductType"].stringValue, PurchasePrice: value["PurchasePrice"].stringValue, ProductTypeID: value["ProductTypeID"].intValue, SalesAmount: value["SalesAmount"].stringValue, Description: value["Description"].stringValue, ProductImage: value["ProductImage"].stringValue, NoofInstallment: value["NoofInstallment"].stringValue, IsActive: value["IsActive"].boolValue, CreateDate: value["CreateDate"].stringValue, ProductName: value["ProductName"].stringValue, InterestRate: value["InterestRate"].stringValue)
                    self.arrProductList.append(pckgDetModel)
                }
                dispetchGroup.leave()
//                DispatchQueue.main.async {
//                    self.tblBarsList.reloadData()
//                }


            }else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        } errorComplition: { (errorMessage) in
            MBProgressHUD.hide(for: self.view, animated: true)
           // self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
            let toast =  Toast(text: errorMessage, duration: 3.0)
            toast.show()

        }

        dispetchGroup.notify(queue: .main) {
            self.tblBarsList.reloadData()
        }

    }
}

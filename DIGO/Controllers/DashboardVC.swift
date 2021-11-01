//
//  DashboardVC.swift
//  DIGO
//
//  Created by ADMS on 21/10/21.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import SDWebImage

class DashboardVC: UIViewController ,UIScrollViewDelegate{

    // MARK: - IBOutlat
    @IBOutlet weak var tblFicility:UITableView!
    @IBOutlet weak var tblProduct:UITableView!
    @IBOutlet weak var tblFicilityHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var tblProductHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collOfProduct:UICollectionView!
//    @IBOutlet weak var collOfVController:UICollectionView!
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var lblUsername:UILabel!
    @IBOutlet weak var lblGoldPrice:UILabel!
    @IBOutlet weak var lblPer:UILabel!

//    @IBOutlet weak var lblQuickLinks:UILabel!

    @IBOutlet weak var btnPriceHighLow:UIButton!


    // MARK: - Varible
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var arrProductList = [allProductofGold]()
    var arrsliderList = [sliderModel]()



    var lblTitleHeight:CGFloat = 0.0

    let arrFacility = [NSLocalizedString("Digo_Dash_Karat_Gold", comment: ""),NSLocalizedString("Digo_Dash_Safe_Home", comment: ""),NSLocalizedString("Digo_Dash_Best_Prices", comment: ""),NSLocalizedString("Digo_Dash_Easy_Installment", comment: "")]
    let arrVcList = [NSLocalizedString("Digo_Dash_Account", comment: ""),NSLocalizedString("Digo_Dash_About", comment: ""),NSLocalizedString("Digo_Dash_Best_EMI", comment: ""),NSLocalizedString("Digo_Dash_Gold Prices", comment: "")]
    let arrVcimageList = ["user_pic.png","info_i.png","account.png","rupees_pic.png"]

    override func viewDidLoad() {
        super.viewDidLoad()

//        lblQuickLinks.text = "\(NSLocalizedString("Digo_Quick_Links", comment: ""))"


        if let result  = UserDefaults.standard.value(forKey: "isLogin"){
            if (result as! String == "1")
            {
                if let result1  = UserDefaults.standard.value(forKey: "logindata"){
                    let json = JSON(result1)
                    lblUsername.text = "\(NSLocalizedString("Digo_Hi", comment: "")) \(json["FirstName"].stringValue)"
                }
            }
        }

        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.navigationController?.navigationBar.isHidden = true

        //        scrollView.delegate = self



        //        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * CGFloat(arrProduct1.count),height: self.scrollView.frame.size.height)



        tblFicility.register(UINib(nibName: "FacilityCell", bundle: nil), forCellReuseIdentifier: "FacilityCell")
        tblProduct.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
//        collOfVController.register(UINib(nibName: "CollectiontabListCell", bundle: .main), forCellWithReuseIdentifier: "CollectiontabListCell")

        tblProduct.estimatedRowHeight = 114.0
        tblProduct.rowHeight = UITableView.automaticDimension


        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height

        // Do any additional setup after loading the view, typically from a nib
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: 98)
        layout.scrollDirection = .horizontal

        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collOfProduct!.collectionViewLayout = layout
        collOfProduct.showsVerticalScrollIndicator = false
        collOfProduct.showsHorizontalScrollIndicator = false

        // Do any additional setup after loading the view, typically from a nib
//        let layout1: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout1.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout1.itemSize = CGSize(width: collOfVController.bounds.width/4, height: 125)
//        layout1.minimumInteritemSpacing = 0
//        layout1.scrollDirection = .horizontal
//
//        layout1.minimumLineSpacing = 0
//        collOfVController!.collectionViewLayout = layout1
//
//        collOfVController.showsVerticalScrollIndicator = false
//        collOfVController.showsHorizontalScrollIndicator = false

        self.collOfProduct.isPagingEnabled = true
//        self.collOfVController.isPagingEnabled = true



    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        apiCallAllProductList()

    }
    override func viewDidLayoutSubviews()
    {

        tblFicility.isScrollEnabled = false
        tblProduct.isScrollEnabled = false
        print(tblProduct.contentSize.height)
        print(tblFicility.contentSize.height)
        let bottomPedding:CGFloat = 30
        tblProductHeightConstraint.constant = tblProduct.contentSize.height
        tblFicilityHeightConstraint.constant = tblFicility.contentSize.height

        scrollView.contentSize = CGSize.init(width: scrollView.contentSize.width, height:tblFicility.contentSize.height + bottomPedding + tblProduct.contentSize.height + 290)
    }
}
extension DashboardVC
{
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @IBAction func changePage(sender: AnyObject) -> () {

        self.pageControl.currentPage = sender.currentPage


        self.collOfProduct.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)

        //            let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        //            scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }

    //        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //
    //            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
    //            pageControl.currentPage = Int(pageNumber)
    //        }
}


// MARK: - extension for tablview

extension DashboardVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblProduct
        {
            return arrProductList.count
        }else if tableView == tblFicility
        {
            return arrFacility.count
        }else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        if tableView == tblProduct
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell

            if indexPath.row == 0
            {

            }else{
                if arrProductList.count > 1
                {
                    cell.lblHeightConstraint.constant = 0
                    cell.vwHeightConstraint.constant = cell.vwHeightConstraint.constant - 30
                }
            }
            cell.imageOfGold.sd_setImage(with: URL(string: API.imageUrl + arrProductList[indexPath.row].ProductIcon), placeholderImage: UIImage(named: "placeholder"))

    //        cell.imageOfGold.image = UIImage(named: "coin.png")

            cell.lblProductTitle.text = "\(NSLocalizedString("Digo_Dash_proTitle", comment: ""))"

            cell.lblEMITitle.text = "\(arrProductList[indexPath.row].ProductTypeName)"


         //   UserDefaults.standard.setValue("en", forKey:"ISLanguage")

            if "en" == UserDefaults.standard.value(forKey: "ISLanguage") as! String
            {
                cell.lblEMIPrice.text = " \(NSLocalizedString("Digo_Dash_Start", comment: "")) ₹\(arrProductList[indexPath.row].Startingpricefrom)"


            }else if "hi" == UserDefaults.standard.value(forKey: "ISLanguage") as! String
            {
                cell.lblEMIPrice.text = "₹\(arrProductList[indexPath.row].Startingpricefrom) \(NSLocalizedString("Digo_Dash_Start", comment: ""))"

            }
            else if "gu" == UserDefaults.standard.value(forKey: "ISLanguage") as! String
            {
                cell.lblEMIPrice.text = "₹\(arrProductList[indexPath.row].Startingpricefrom) \(NSLocalizedString("Digo_Dash_Start", comment: ""))"

            }



            cell.imageOfGold.layer.cornerRadius = cell.imageOfGold.layer.frame.height/2.0
            cell.imageOfGold.layer.masksToBounds = true

            return cell

        }else if tableView == tblFicility
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FacilityCell", for: indexPath) as! FacilityCell
            cell.lblFicility.text = arrFacility[indexPath.row]
            return cell
        }else{
            return UITableViewCell()
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblProduct
        {
           // let storyboard = UIStoryboard(name: "Main", bundle: nil)

            if arrProductList[indexPath.row].ProductTypeID == 1
            {
//                let coinObj = storyboard.instantiateViewController(withIdentifier: "CoinsVC") as! CoinsVC
//                self.navigationController?.pushViewController(coinObj, animated: false)
                self.tabBarController?.selectedIndex = 1

            }else if arrProductList[indexPath.row].ProductTypeID == 2
            {
//                let coinObj = storyboard.instantiateViewController(withIdentifier: "BarsVC") as! BarsVC
//                self.navigationController?.pushViewController(coinObj, animated: false)
                self.tabBarController?.selectedIndex = 2

            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tblProduct
        {
            return UITableView.automaticDimension
        }else if tableView == tblFicility
        {
            return 50
        }else{
            return 0
        }
    }
}
// MARK: - extension for collectionview

extension DashboardVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collOfProduct
        {
            return arrsliderList.count
        }
//        else if collectionView == collOfVController
//        {
//            return arrVcList.count
//        }
        else{
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


        if collectionView == collOfProduct
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collProductCell", for: indexPath) as! collProductCell
            cell.btnNext.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
            cell.btnNext.tag = indexPath.row

            cell.imgPro.sd_setImage(with: URL(string: API.imageUrl + arrsliderList[indexPath.row].Photo), placeholderImage: UIImage(named: "placeholder"))

            cell.lblText.text = arrsliderList[indexPath.row].Description
            cell.imgPro.layer.cornerRadius = cell.imgPro.layer.frame.height/2.0
            cell.imgPro.layer.masksToBounds = true

            return cell

        }
//        else if collectionView == collOfVController
//        {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectiontabListCell", for: indexPath) as! CollectiontabListCell
//            cell.lblTitle.text = arrVcList[indexPath.row]
//            cell.imgVC.image = UIImage(named: arrVcimageList[indexPath.row])
//            return cell
//
//        }
        else{
            return UICollectionViewCell()
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {


        if collectionView == collOfProduct
        {
            // let collectionViewWidth = collectionView.bounds.width
            return CGSize(width: screenWidth-20, height: 98)

        }
//        else if collectionView == collOfVController
//        {
//            //            let collectionViewWidth = collectionView.bounds.width-20
//            print("dhjasgdhjgash",lblTitleHeight)
//            return CGSize(width: collectionView.bounds.width/4, height: 125)
//
//        }
        else{
            return CGSize.zero
        }

    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
        //        self.collOfProduct.scrollToItem(at: IndexPath(row: self.pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: true)

    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == collOfVController
//        {
//
//            if arrVcList[indexPath.row] == NSLocalizedString("Digo_Dash_Account", comment: "")
//            {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let productDetailVC = storyboard.instantiateViewController(withIdentifier: "TimeLineVC") as! TimeLineVC
//                self.navigationController?.pushViewController(productDetailVC, animated: true)
//            }else if arrVcList[indexPath.row] == NSLocalizedString("Digo_Dash_About", comment: "")
//            {
//
//            }
//            else if arrVcList[indexPath.row] == NSLocalizedString("Digo_Dash_Best_EMI", comment: "")
//            {
//
//            }
//            else if arrVcList[indexPath.row] == NSLocalizedString("Digo_Dash_Gold Prices", comment: "")
//            {
//
//            }
//
//        }else
//        {
//
//        }
//
//    }
    @objc func connected(sender: UIButton){

        if arrsliderList.count - 1 != sender.tag
        {
            let buttonTag = sender.tag
            self.pageControl.currentPage = sender.tag + 1


            self.collOfProduct.scrollToItem(at: IndexPath(row: sender.tag + 1, section: 0), at: .centeredHorizontally, animated: true)

        }
    }
}
extension DashboardVC{
    func apiCallAllProductList()
    {
          self.arrProductList.removeAll()
//        let lock = NSLock()
        let dispetchGroup = DispatchGroup()
        MBProgressHUD.showAdded(to: self.view, animated: true)

        dispetchGroup.enter()
        print("first api call")
     //   lock.lock()

        ApiHttpUtility.sharedUHttp.callGetMultipleApiHttpUtility(urlString: API.GetProductType) { (responceJson, error) in
            MBProgressHUD.hide(for: self.view, animated: true)

            if let error = error {
                print(error.localizedDescription)
                return
            }

            let arrData = responceJson?["data"].array
            for value in arrData! {
                let pckgDetModel:allProductofGold = allProductofGold.init(ProductTypeID: value["ProductTypeID"].intValue, ProductTypeName: value["ProductTypeName"].stringValue, Startingpricefrom: value["Startingpricefrom"].stringValue, ProductIcon: value["ProductIcon"].stringValue)
                self.arrProductList.append(pckgDetModel)
            }
           // lock.unlock()
            dispetchGroup.leave()

        }

//        ApiHttpUtility.sharedUHttp.callGetHttpUtility(urlString: API.GetProductType) { (responceJson) in
//            if(responceJson["status"] == "true")
//            {
//                MBProgressHUD.hide(for: self.view, animated: true)
//
//                let arrData = responceJson["data"].array
//                for value in arrData! {
//                    let pckgDetModel:allProductofGold = allProductofGold.init(ProductTypeID: value["ProductTypeID"].intValue, ProductTypeName: value["ProductTypeName"].stringValue, Startingpricefrom: value["Startingpricefrom"].stringValue, ProductIcon: value["ProductIcon"].stringValue)
//                    self.arrProductList.append(pckgDetModel)
//                }
//                lock.unlock()
//                dispetchGroup.leave()
//
//                //self.callSliderApiList()
//            }else
//            {
//                MBProgressHUD.hide(for: self.view, animated: true)
//            }
//        } errorComplition: { (errorMessage) in
//            MBProgressHUD.hide(for: self.view, animated: true)
//            self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
//        }




        dispetchGroup.enter()
        print("second api call")

      //  lock.lock()

//        ApiHttpUtility.sharedUHttp.callGetHttpUtility(urlString: API.GetSlider) { (responceJson) in
//            if(responceJson["status"] == "true")
//            {
//               // MBProgressHUD.hide(for: self.view, animated: true)
//
//                let arrData = responceJson["data"].array
//                for value in arrData! {
//                    let pckgDetModel:sliderModel = sliderModel.init(SliderName: value["SliderName"].stringValue, Description: value["Description"].stringValue, Photo: value["Photo"].stringValue)
//                    self.arrsliderList.append(pckgDetModel)
//                }
//            }else
//            {
//                MBProgressHUD.hide(for: self.view, animated: true)
//            }
//        } errorComplition: { (errorMessage) in
//            MBProgressHUD.hide(for: self.view, animated: true)
//            self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
//        }
//

        ApiHttpUtility.sharedUHttp.callGetMultipleApiHttpUtility(urlString: API.GetSlider) { (responceJson, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.arrsliderList.removeAll()
            if let error = error {
                print(error.localizedDescription)
                return
            }

            let arrData = responceJson?["data"].array
            for value in arrData! {
                let pckgDetModel:sliderModel = sliderModel.init(SliderName: value["SliderName"].stringValue, Description: value["Description"].stringValue, Photo: value["Photo"].stringValue)
                self.arrsliderList.append(pckgDetModel)
            }
           // lock.unlock()
            dispetchGroup.leave()

        }

        dispetchGroup.enter()
        var params = [String : Any]()
        params = ["ProductTypeID":"1"]

        var goldPriceValue: String = ""
        var goldFlag: String = ""
        var goldPersantag: String = ""

        ApiHttpUtility.sharedUHttp.callPostMultipleApiHttpUtility(urlString: API.GetGoldPrice, params: params) { (responceJson, error) in
            MBProgressHUD.hide(for: self.view, animated: true)

            if let error = error {
                print(error.localizedDescription)
                return
            }

            let arrData = responceJson?["data"].array


            if let arr = arrData
            {
                goldPriceValue = "\(arr[0]["Price"])"
                goldFlag = "\(arr[0]["Flag"])"
                goldPersantag = "\(arr[0]["percentage"])"
            }

//            for value in arrData! {
//                let pckgDetModel:sliderModel = sliderModel.init(SliderName: value["SliderName"].stringValue, Description: value["Description"].stringValue, Photo: value["Photo"].stringValue)
//                self.arrsliderList.append(pckgDetModel)
//            }
           // lock.unlock()
            dispetchGroup.leave()

        }




//        lock.unlock()
//        dispetchGroup.leave()

        dispetchGroup.notify(queue: .main) {
            print("all task done")
            DispatchQueue.main.async {

                self.pageControl.numberOfPages = self.arrsliderList.count
                self.pageControl.currentPage = 0
                self.pageControl.tintColor = UIColor.red
                self.pageControl.pageIndicatorTintColor = UIColor.black
                self.pageControl.currentPageIndicatorTintColor = UIColor.darkGray
print("dasdsadsa","\(NSLocalizedString("Digo_gold_price", comment: "")) \(goldPriceValue)")

                if goldFlag == "1"
                {
                    self.btnPriceHighLow.setImage(UIImage(named: "green_arrw.png"), for: .normal)
                }else{
                    self.btnPriceHighLow.setImage(UIImage(named: "red_arrw.png"), for: .normal)
                }

                self.lblGoldPrice.text = "\(NSLocalizedString("Digo_gold_price", comment: "")) ₹\(goldPriceValue)"
                self.lblPer.text = "\(goldPersantag) %"

                goldPriceValue = ""
                goldFlag = ""
                goldPersantag = ""
                self.tblProduct.reloadData()
                self.collOfProduct.reloadData()
            }
        }

    }
}


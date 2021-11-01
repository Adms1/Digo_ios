//
//  TimeLineVC.swift
//  DIGO
//
//  Created by ADMS on 26/10/21.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import Razorpay

class TimeLineVC: UIViewController {

    @IBOutlet weak var tblTimeLine:UITableView!
    @IBOutlet weak var lblOrderList:UILabel!

    var arremiList = [emiMainModel]()
    var arrSub = [emiModel]()

    var selectedSection:Int = -1
    var selectedRow:Int = -1

    var razorpayObj : RazorpayCheckout? = nil
    var arrGenerateData = [generatePaymentModel]()
    var contactNom:String = ""
    var userEmailId:String = ""
    var userName:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        lblOrderList.text = NSLocalizedString("Digo_Order_List", comment: "")

        tblTimeLine.showsHorizontalScrollIndicator = false

        tblTimeLine.register(UINib(nibName: "TimeLineCell", bundle: nil), forCellReuseIdentifier: "TimeLineCell")
        tblTimeLine.register(UINib(nibName: "ExpandableCell", bundle: nil), forCellReuseIdentifier: "ExpandableCell")


        self.navigationController?.navigationBar.isHidden = false

        tblTimeLine.estimatedRowHeight = 81
        tblTimeLine.rowHeight = UITableView.automaticDimension
        apiCallEmiList()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
// MARK: - extension

extension TimeLineVC:UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arremiList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.arremiList[section].isExpandable != true
        {
            return 0
        }

        return arremiList[section].EMI_SUB.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell", for: indexPath) as! TimeLineCell
        
        cell.vwSquare.layer.cornerRadius = cell.vwSquare.layer.frame.height/2.0
        cell.vwSquare.layer.masksToBounds = true

        cell.vwSub.layer.cornerRadius = 4.0
        cell.vwSub.layer.masksToBounds = true


        cell.mainView.layer.cornerRadius = 4.0
        cell.mainView.layer.masksToBounds = true
        cell.vwHideSHow.layer.cornerRadius = 4.0
        cell.vwHideSHow.layer.masksToBounds = true

        // cell.lblTitle.text = arremiList[indexPath.section].ProductName
        cell.lblDate.text = arremiList[indexPath.section].EMI_SUB[indexPath.row].EMIDueDate
        cell.lblEmiAmount.text = "\(NSLocalizedString("Digo_EMI_Price", comment: "")) \(arremiList[indexPath.section].EMI_SUB[indexPath.row].EMIAmount)"
        cell.btnPayNow.addTarget(self, action: #selector(payNow(sender:)), for: .touchUpInside)
        cell.btnPayNow.tag = indexPath.row

        cell.btnPayNow.layer.cornerRadius = 6.0
        cell.btnPayNow.layer.masksToBounds = true

        if arremiList[indexPath.section].EMI_SUB[indexPath.row].OrderNo == ""
        {
            cell.vwHideSHow.isHidden = true
            cell.vwSquare.backgroundColor = UIColor.gray
            cell.vwVertical.backgroundColor = UIColor.gray
            cell.btnPayNow.isHidden = false
            cell.btnPayNow.setTitle(NSLocalizedString("Digo_pay_now", comment: ""), for: .normal)
        }else
        {
            cell.vwHideSHow.isHidden = false
            cell.btnPayNow.setTitle("", for: .normal)
            cell.btnPayNow.isHidden = true
            cell.vwSquare.backgroundColor = UIColor(red: 0/255.0, green: 170.0/255.0, blue: 0/255.0, alpha: 1)
            cell.vwVertical.backgroundColor = UIColor(red: 0/255.0, green: 170.0/255.0, blue: 0/255.0, alpha: 1)
        }




        let heightWidth = cell.vwTriangle.frame.size.width
        let path = CGMutablePath()

        path.move(to: CGPoint(x: heightWidth/2, y: 0))
        path.addLine(to: CGPoint(x:0, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth/2, y:heightWidth))
        path.addLine(to: CGPoint(x:heightWidth/2, y:0))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.white.cgColor
        cell.vwTriangle.backgroundColor = .clear
        cell.vwTriangle.layer.insertSublayer(shape, at: 0)


        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell") as! ExpandableCell

        if arremiList[section].isExpandable == true
        {
            header.imageExpand.image = UIImage(named: "back_arrw_down.png")
        }else{
            header.imageExpand.image = UIImage(named: "back_arrw.png")
        }

        let sectionTitle = arremiList[section].ProductName
        header.lblTitle.text = sectionTitle
        header.btnExpand.addTarget(self, action: #selector(connected), for: .touchUpInside)
        header.btnExpand.tag = section
        return header

    }
    @objc func connected(sender: UIButton)
    {

        if self.arremiList[sender.tag].isExpandable == true
        {
            self.arremiList[sender.tag].isExpandable = false
        }else{
            selectedSection = -1
            for (index,_) in arremiList.enumerated()
            {
                self.arremiList[index].isExpandable = false
            }
            selectedSection = sender.tag
            self.arremiList[sender.tag].isExpandable = !self.arremiList[sender.tag].isExpandable



        }
        DispatchQueue.main.async {
            self.tblTimeLine.reloadData()
        }

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //        let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
    //        productDetailVC.obj = arrProductList[indexPath.row]
    //        productDetailVC.goldBarCoinsTitle = arrProductList[indexPath.row].ProductType
    //        productDetailVC.ProductID = "\(arrProductList[indexPath.row].ProductID)"
    //        self.navigationController?.pushViewController(productDetailVC, animated: true)
    //    }
    @objc func payNow(sender: UIButton){
        print(sender.tag)
        selectedRow = sender.tag
        print(selectedRow)
        print(selectedSection)
        callApiGeneratePaymentRequest_Razor()
    }

}
extension TimeLineVC{
    func apiCallEmiList()
    {
        self.arremiList.removeAll()

        let dispetchGroup = DispatchGroup()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var params = [String : Any]()
        if let result  = UserDefaults.standard.value(forKey: "isLogin"){
            if (result as! String == "1")
            {
                if let result1  = UserDefaults.standard.value(forKey: "logindata"){
                    let json = JSON(result1)
                    params = ["CustomerID":json["CustomerID"].stringValue]
                }
            }
        }
        dispetchGroup.enter()
        print("first api call")
        let lock = NSLock()
        lock.lock()

        ApiHttpUtility.sharedUHttp.callPostHttpUtility(urlString: API.GetEMI, params: params) { (responceJson) in
            if(responceJson["status"] == "true")
            {
                MBProgressHUD.hide(for: self.view, animated: true)

                let arrData = responceJson["data"].array
                for value in arrData!
                {
                    let arrData1 = value["EMI_SUB"].array
                    self.arrSub.removeAll()
                    for value1 in arrData1!
                    {
                        let emiModelObject:emiModel = emiModel.init(EMINo: value1["EMINo"].stringValue, OrderID: value1["OrderID"].stringValue, OrderNo: value1["OrderNo"].stringValue, EMIAmount: value1["EMIAmount"].stringValue, EMIDueDate: value1["EMIDueDate"].stringValue, Date: value1["Date"].stringValue, CustomerID: value1["CustomerID"].stringValue, ProductID: value1["ProductID"].stringValue,ProductAmount:value1["ProductAmount"].stringValue,EMIID:value1["EMIID"].stringValue)
                        self.arrSub.append(emiModelObject)
                    }
                    let pckgDetModel:emiMainModel = emiMainModel.init(ProductName: value["ProductName"].stringValue, isExpandable: false, EMI_SUB: self.arrSub)
                    self.arremiList.append(pckgDetModel)
                }
                lock.unlock()
                dispetchGroup.leave()
            }else
            {
                self.view.makeToast(responceJson["Msg"].stringValue, duration: 3.0, position: .bottom)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        } errorComplition: { (errorMessage) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
        }

        dispetchGroup.notify(queue: .main) {
            print("all task done")
            DispatchQueue.main.async {
                self.tblTimeLine.reloadData()
            }

        }
    }
    func callApiGeneratePaymentRequest_Razor()
    {
        self.arrGenerateData.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)

        var params = [String : Any]()

        if let result  = UserDefaults.standard.value(forKey: "isLogin"){
            if (result as! String == "1")
            {
                if let result1  = UserDefaults.standard.value(forKey: "logindata"){
                    let json = JSON(result1)
//                    params = ["CustomerID":json["CustomerID"].stringValue]
                    userEmailId = json["Email"].stringValue
                    contactNom = json["Mobile"].stringValue
                    userName = json["FirstName"].stringValue

                    let inputFormatter = DateFormatter()
                    inputFormatter.dateFormat = "dd/MM/yyyy"
                    let showDate = inputFormatter.date(from: self.arremiList[self.selectedSection].EMI_SUB[self.selectedRow].EMIDueDate)
                    inputFormatter.dateFormat = "yyyy-MM-dd"
                    let resultString = inputFormatter.string(from: showDate!)
                    print(resultString)


//                    params = ["CustomerID":self.arremiList[self.selectedSection].EMI_SUB[self.selectedRow].CustomerID,"ProductID":self.arremiList[self.selectedSection].EMI_SUB[self.selectedRow].ProductID,"OrderID":self.arremiList[self.selectedSection].EMI_SUB[self.selectedRow].OrderID,"DueDate":"\(resultString)","ProductAmount":self.arremiList[self.selectedSection].EMI_SUB[self.selectedRow].ProductAmount,"EMIAmount":self.arremiList[self.selectedSection].EMI_SUB[self.selectedRow].EMIAmount,"EMINo":self.arremiList[self.selectedSection].EMI_SUB[self.selectedRow].EMINo]
                    params = ["EMIAmount":self.arremiList[self.selectedSection].EMI_SUB[self.selectedRow].EMIAmount,"EmiID":self.arremiList[self.selectedSection].EMI_SUB[self.selectedRow].EMIID]

                    print("GeneratePaymentRequest_Razor(",params)


                }
            }
        }


        ApiHttpUtility.sharedUHttp.callPostHttpUtility(urlString: API.GeneratePaymentRequest_Razor_EMI, params: params) { (responceJson) in
            if(responceJson["status"] == "true")
            {
                MBProgressHUD.hide(for: self.view, animated: true)

                let arrData = responceJson["data"].array
                for value in arrData! {
                    let pckgDetModel:generatePaymentModel = generatePaymentModel.init(CustomerPaymentID: value["CustomerPaymentID"].intValue, ExternalPaymentID: value["ExternalPaymentID"].stringValue, PaymentAmount: value["PaymentAmount"].stringValue, ExternalTransactionID: value["ExternalTransactionID"].stringValue)
                    self.arrGenerateData.append(pckgDetModel)
                }
                self.showPaymentForm(amount: self.arrGenerateData[0].PaymentAmount, currency: "INR", description: "", order_id: "\(self.arrGenerateData[0].ExternalPaymentID)", image: "ItunesArtwork@2x.png", name: self.userName, contact: self.contactNom, email: self.userEmailId)
            }else{
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        } errorComplition: { (errorMessage) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
        }
    }
    func callApiUpdatePayment(payment_id:String,StatusID:String)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)

        var params = [String : Any]()
        params = ["orderid":self.arrGenerateData[0].CustomerPaymentID,"ExternalPaymentID":payment_id,"EMIID":"\(self.arremiList[self.selectedSection].EMI_SUB[self.selectedRow].EMIID)","StatusID":StatusID]
        print("UpdatePayment(",params)


        ApiHttpUtility.sharedUHttp.callPostHttpUtility(urlString: API.UpdatePayment_Emi, params: params) { (responceJson) in
            if(responceJson["status"] == "true")
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let storyboard = UIStoryboard(name:"Main", bundle: nil)
                let obj = storyboard.instantiateViewController(withIdentifier: "SuccessVC") as! SuccessVC
                obj.strSuccess = "success"
                self.navigationController?.pushViewController(obj, animated: false)

//                self.navigationController?.popViewController(animated: false)
            }else{
                MBProgressHUD.hide(for: self.view, animated: true)
                let storyboard = UIStoryboard(name:"Main", bundle: nil)
                let obj = storyboard.instantiateViewController(withIdentifier: "SuccessVC") as! SuccessVC
                obj.strSuccess = "failed"
                self.navigationController?.pushViewController(obj, animated: false)

//                self.navigationController?.popViewController(animated: false)
            }
        } errorComplition: { (errorMessage) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
        }
    }
}
extension TimeLineVC:RazorpayPaymentCompletionProtocol
{
    internal func showPaymentForm(amount:String, currency:String, description:String, order_id:String, image:String, name:String, contact:String, email:String){
        razorpayObj = RazorpayCheckout.initWithKey(razorpayKey, andDelegate: self)
        let options: [String:Any] = [
            "amount":amount,//"100", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": currency,//"INR",//We support more that 92 international currencies.
            "description": "purchase description",//description,//"purchase description",
            "order_id": order_id,//"order_4xbQrmEoA5WJ0G",
            "image": UIImage(named: "AppIcon60x60") ?? UIImage(),//"https://url-to-image.png",
            "name": name,//"business or product name",
            "prefill": [
                "contact": "",//"9797979797",
                "email": email,//"foo@bar.com"
            ],
//            "theme": [
//                "color": "#F37254"
//            ]
        ]
        print("razorpay fdsfdsfds",options)
//        razorpay.open(options)
        if let rzp = self.razorpayObj {
            rzp.open(options)
        } else {
            print("Unable to initialize")
        }
    }
    func onPaymentError(_ code: Int32, description str: String) {
        print("error1: ", code, str)
        callApiUpdatePayment(payment_id: "\(code)", StatusID: "2")
    }

    func onPaymentSuccess(_ payment_id: String) {
        print("success1: ", payment_id)
        callApiUpdatePayment(payment_id: payment_id, StatusID: "3")
    }



}

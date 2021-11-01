//
//  ProductDetailVC.swift
//  DIGO
//
//  Created by ADMS on 25/10/21.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import SDWebImage
import Razorpay
import Toast_Swift


class ProductDetailVC: UIViewController {

    @IBOutlet weak var tblInstallMentList:UITableView!
    @IBOutlet weak var tblInstallMentListHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var vwDescHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgOfProduct: UIImageView!
    @IBOutlet weak var lblproductPrice: UILabel!
    @IBOutlet weak var btnPayNow:UIButton!

    var arrinstallment = [installmentModel]()
    var obj:productList!
    var goldBarCoinsTitle:String = ""
    var ProductID:String = ""
    var selectedNoOfInstallment:String = ""
    var emiAmount:String = ""
    var contactNom:String = ""
    var userEmailId:String = ""
    var userName:String = ""

    var arrSelected = [String]()
    var razorpayObj : RazorpayCheckout? = nil
   var arrGenerateData = [generatePaymentModel]()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true

        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.navigationController?.navigationBar.isHidden = true

        installmentListApiCall()
        tblInstallMentList.register(UINib(nibName: "ProductDetailCell", bundle: nil), forCellReuseIdentifier: "ProductDetailCell")

        btnPayNow.layer.cornerRadius = btnPayNow.layer.frame.height/2.0
        btnPayNow.layer.masksToBounds = true

    }
    override func viewDidLayoutSubviews()
    {

        tblInstallMentList.isScrollEnabled = false
        print(tblInstallMentList.contentSize.height)
        let bottomPedding:CGFloat = 30

        tblInstallMentListHeightConstraint.constant = tblInstallMentList.contentSize.height

        vwDescHeightConstraint.constant = lblDescription.frame.height + 60
        scrollView.contentSize = CGSize.init(width: scrollView.contentSize.width, height: bottomPedding + tblInstallMentListHeightConstraint.constant + 434 + vwDescHeightConstraint.constant)
    }
    @IBAction func btnClick()
    {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btnPayNowClick()
    {
        if selectedNoOfInstallment == ""
        {
            self.view.makeToast(NSLocalizedString("Digo_error_msg8", comment: ""), duration: 3.0, position: .bottom)

        }else{
            callApiGeneratePaymentRequest_Razor()
        }
    }
}
// MARK: - extension for tablview

extension ProductDetailVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return arrinstallment.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailCell", for: indexPath) as! ProductDetailCell
        cell.selectionStyle = .none

//        if arrSelected.count > 0
//        {
            if selectedNoOfInstallment == arrinstallment[indexPath.row].NoOfInstallment
            {
    //            cell.btnSelectDeselect.setImage(UIImage(named: "radio_selected.png"), for: .normal)
                cell.btnSelectDeselect.backgroundColor = UIColor.black
                cell.btnSelectDeselect.layer.borderWidth = 0.5
                cell.btnSelectDeselect.layer.borderColor = UIColor.black.cgColor

            }else{
                cell.btnSelectDeselect.backgroundColor = UIColor.white
                cell.btnSelectDeselect.layer.borderWidth = 0.5
                cell.btnSelectDeselect.layer.borderColor = UIColor.lightGray.cgColor

            }
//        }else{
//            cell.btnSelectDeselect.backgroundColor = UIColor.white
//            cell.btnSelectDeselect.layer.borderWidth = 0.5
//            cell.btnSelectDeselect.layer.borderColor = UIColor.lightGray.cgColor
//
//        }



        cell.btnSelectDeselect.layer.cornerRadius = cell.btnSelectDeselect.layer.frame.height/2.0
        cell.btnSelectDeselect.layer.masksToBounds = true

            cell.lblInstallmentTitle.text = "\(arrinstallment[indexPath.row].NoOfInstallment) \(NSLocalizedString("Digo_installments", comment: ""))"
            cell.lblInstallmentPrice.text = "₹\(arrinstallment[indexPath.row].InstallmentAmount) \(NSLocalizedString("Digo_per_installments", comment: ""))"


            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let indexPath = IndexPath(item: indexPath.row, section: 0)
        selectedNoOfInstallment = ""
        emiAmount = ""
        selectedNoOfInstallment = arrinstallment[indexPath.row].NoOfInstallment
        emiAmount = arrinstallment[indexPath.row].InstallmentAmount

//        arrSelected.removeAll()
//        arrSelected.append(arrinstallment[indexPath.row].NoOfInstallment)
//        print(arrSelected)
//        selectedIndex = arrinstallment[indexPath.row].ProductID
        tblInstallMentList.reloadData()
//        tblInstallMentList.reloadRows(at: [indexPath], with: .none)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
            return 90
    }
}
// MARK: - ApiCalling
extension ProductDetailVC{
    func installmentListApiCall()
    {
        self.arrinstallment.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)

        var params = [String : Any]()
        params = ["ProductID":ProductID]

        ApiHttpUtility.sharedUHttp.callPostHttpUtility(urlString: API.GetProductInstallment, params: params) { (responceJson) in
            if(responceJson["status"] == "true")
            {
                MBProgressHUD.hide(for: self.view, animated: true)

                let arrData = responceJson["data"].array
                for value in arrData! {
                    let pckgDetModel:installmentModel = installmentModel.init(ProductInstallmentID: value["ProductInstallmentID"].intValue, ProductID: value["ProductID"].intValue, NoOfInstallment: value["NoOfInstallment"].stringValue, InstallmentAmount: value["InstallmentAmount"].stringValue, Datetime: value["Datetime"].stringValue)
                    self.arrinstallment.append(pckgDetModel)
                }
                DispatchQueue.main.async {
                    self.lblproductPrice.text = self.goldBarCoinsTitle
                      //  "₹\(self.obj.SalesAmount) \(self.goldBarCoinsTitle)"
                    self.lblDescription.text = "\(self.obj.Description)"
                    self.imgOfProduct.sd_setImage(with: URL(string: API.imageUrl + self.obj.ProductImage), placeholderImage: UIImage(named: "placeholder"))

//                    self.imgOfProduct.layer.cornerRadius = self.imgOfProduct.layer.frame.height/2.0
//                    self.imgOfProduct.layer.masksToBounds = true

                    self.tblInstallMentList.reloadData()
                }


            }else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        } errorComplition: { (errorMessage) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
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
                    params = ["CustomerID":json["CustomerID"].stringValue,"ProductID":ProductID,"ProductAmount":self.obj.SalesAmount,"EMIAmount":emiAmount,"NoofInstallment":selectedNoOfInstallment]
                    print("GeneratePaymentRequest_Razor(",params)


                }
            }
        }


        ApiHttpUtility.sharedUHttp.callPostHttpUtility(urlString: API.GeneratePaymentRequest_Razor, params: params) { (responceJson) in
            if(responceJson["status"] == "true")
            {
                MBProgressHUD.hide(for: self.view, animated: true)

                let arrData = responceJson["data"].array
                for value in arrData! {
                    let pckgDetModel:generatePaymentModel = generatePaymentModel.init(CustomerPaymentID: value["CustomerPaymentID"].intValue, ExternalPaymentID: value["ExternalPaymentID"].stringValue, PaymentAmount: value["PaymentAmount"].stringValue, ExternalTransactionID: value["ExternalTransactionID"].stringValue)
                    self.arrGenerateData.append(pckgDetModel)
                }
                self.showPaymentForm(amount: self.arrGenerateData[0].PaymentAmount, currency: "INR", description: "", order_id: "\(self.arrGenerateData[0].ExternalPaymentID)", image: "AppIcon", name: self.userName, contact: self.contactNom, email: self.userEmailId)
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
        params = ["orderid":self.arrGenerateData[0].CustomerPaymentID,"ExternalPaymentID":payment_id,"EMIAmount":emiAmount,"StatusID":StatusID]
        print("UpdatePayment(",params)


        ApiHttpUtility.sharedUHttp.callPostHttpUtility(urlString: API.UpdatePayment, params: params) { (responceJson) in
            if(responceJson["status"] == "true")
            {
                MBProgressHUD.hide(for: self.view, animated: true)

//                if StatusID == "2"
//                {
//                    let storyboard = UIStoryboard(name:"Main", bundle: nil)
//                    let obj = storyboard.instantiateViewController(withIdentifier: "SuccessVC") as! SuccessVC
//                    obj.strSuccess = "failed"
//                    self.navigationController?.pushViewController(obj, animated: false)
//
//                }else{
                    let storyboard = UIStoryboard(name:"Main", bundle: nil)
                    let obj = storyboard.instantiateViewController(withIdentifier: "SuccessVC") as! SuccessVC
                    obj.strSuccess = "success"
                    self.navigationController?.pushViewController(obj, animated: false)

              //  }

//                self.navigationController?.popViewController(animated: false)
            }else
            {
                MBProgressHUD.hide(for: self.view, animated: true)

                let storyboard = UIStoryboard(name:"Main", bundle: nil)
                let obj = storyboard.instantiateViewController(withIdentifier: "SuccessVC") as! SuccessVC
                obj.strSuccess = "failed"
                self.navigationController?.pushViewController(obj, animated: false)

            }
        } errorComplition: { (errorMessage) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
        }
    }
}
extension ProductDetailVC:RazorpayPaymentCompletionProtocol
{
    internal func showPaymentForm(amount:String, currency:String, description:String, order_id:String, image:String, name:String, contact:String, email:String){
        razorpayObj = RazorpayCheckout.initWithKey(razorpayKey, andDelegate: self)
        let options: [String:Any] = [
            "amount":amount,//"100", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": currency,//"INR",//We support more that 92 international currencies.
            "description": "",//description,//"purchase description",
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
extension ProductDetailVC: RazorpayPaymentCompletionProtocolWithData {

    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("error: ", code)
//        self.presentAlert(withTitle: "Alert", message: str)
    }

    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("success: ", payment_id)
    }
}

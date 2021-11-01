//
//  Helper.swift
//  DIGO
//
//  Created by ADMS on 22/10/21.
//

import Foundation
import UIKit

var razorpayKey = "rzp_test_5CMT01q5qHF9iS" //test
//var razorpayKey = "rzp_live_ACc68Sz0Iyoahn" //Live


struct API {



    static let strVersion:String  = "Ver. No.: 1.620200407"
    static let strGameID:String   = "6616E8DC-917C-473D-ACA1-4540D7AC9488"

    static let hostName:String    = "http://digo.admssvc.com/" //"\(bundleDisplayName == "TestCraft" ? "https://webservice.testcraft.in/" : "http://demowebservice.testcraft.in/")" //"LIVE" : "TEST"
    static let baseUrl:String     = "\(hostName)webservice.asmx/"

    static let imageUrl:String     = "http://digo.admssvc.com/Product_Images/"

    static let AddCustomer = "\(baseUrl)AddCustomer"

    static let UserLogin = "\(baseUrl)UserLogin"
    static let CheckEmailDuplicate = "\(baseUrl)CheckEmailDuplicate"
    static let GetProductlist = "\(baseUrl)GetProductlist"
    static let GetProductType = "\(baseUrl)GetProductType"
    static let GetProductInstallment = "\(baseUrl)GetProductInstallment"
    static let GetEMI = "\(baseUrl)GetEMI"
    static let GeneratePaymentRequest_Razor = "\(baseUrl)GeneratePaymentRequest_Razor"
    static let Update_GeneratePaymentRequest_Razor = "\(baseUrl)Update_GeneratePaymentRequest_Razor"
    static let GeneratePaymentRequest_Razor_EMI = "\(baseUrl)GeneratePaymentRequest_Razor_EMI"
    static let UpdatePayment_Emi = "\(baseUrl)UpdatePayment_Emi"
    static let GetSlider = "\(baseUrl)GetSlider"
    static let GetGoldPrice = "\(baseUrl)GetGoldPrice"
    static let Add_ReferredFriends = "\(baseUrl)Add_ReferredFriends"





    static let UpdatePayment = "\(baseUrl)UpdatePayment"



//    static let AddVehicleDetail = "\(baseUrl)AddVehicleDetail"
//    static let AddVehiclePhoto = "\(baseUrl)AddVehiclePhoto"
//    static let GetVehicleType = "\(baseUrl)GetVehicleType"
//    static let DeleteVehiclephoto = "\(baseUrl)DeleteVehiclephoto"
//
//
//    static let uploadImageUrl:String = "http://srpl.admssvc.com/UploadImage.ashx"

}
func add(asChildViewController viewController: UIViewController, _ selfVC:UIViewController) {

    selfVC.addChild(viewController)
    selfVC.view.addSubview(viewController.view)
    viewController.view.frame = selfVC.view.bounds
    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    viewController.didMove(toParent: selfVC)
}

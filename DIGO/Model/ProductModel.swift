//
//  ProductModel.swift
//  DIGO
//
//  Created by ADMS on 22/10/21.
//

import Foundation

class product{
    var status:String
    var data:[productList]
    var Msg:String

    init(status:String,data:[productList],Msg:String) {
        self.Msg = Msg
        self.data = data
        self.status = status
    }

}
class productList{
    var ProductID:Int
    var ProductType:String
    var PurchasePrice:String
    var ProductTypeID:Int
    var SalesAmount:String
    var Description:String
    var ProductImage:String
    var NoofInstallment:String
    var IsActive:Bool
    var CreateDate:String
    var ProductName:String
    var InterestRate:String

    init(ProductID:Int,ProductType:String,PurchasePrice:String,ProductTypeID:Int,SalesAmount:String,Description:String,ProductImage:String,NoofInstallment:String,IsActive:Bool,CreateDate:String,ProductName:String,InterestRate:String) {
        self.ProductID = ProductID
        self.ProductType = ProductType
        self.PurchasePrice = PurchasePrice
        self.ProductTypeID = ProductTypeID
        self.SalesAmount = SalesAmount
        self.Description = Description
        self.ProductImage = ProductImage
        self.NoofInstallment = NoofInstallment
        self.IsActive = IsActive
        self.CreateDate = CreateDate
        self.ProductName = ProductName
        self.InterestRate = InterestRate
    }


}


class allProductofGold {
    var ProductTypeID:Int
    var ProductTypeName:String
    var Startingpricefrom:String
    var ProductIcon:String

    init(ProductTypeID:Int,ProductTypeName:String,Startingpricefrom:String,ProductIcon:String) {
        self.ProductTypeID = ProductTypeID
        self.ProductTypeName = ProductTypeName
        self.Startingpricefrom = Startingpricefrom
        self.ProductIcon = ProductIcon
    }

}
class installmentModel {
    var ProductInstallmentID:Int
    var ProductID:Int
    var NoOfInstallment:String
    var InstallmentAmount:String
    var Datetime:String

    init(ProductInstallmentID:Int,ProductID:Int,NoOfInstallment:String,InstallmentAmount:String,Datetime:String) {
        self.ProductInstallmentID = ProductInstallmentID
        self.ProductID = ProductID
        self.NoOfInstallment = NoOfInstallment
        self.InstallmentAmount = InstallmentAmount
        self.Datetime = Datetime

    }

}
class emiMainModel {
    var ProductName:String
    var isExpandable:Bool
    var EMI_SUB:[emiModel]

    init(ProductName:String,isExpandable:Bool,EMI_SUB:[emiModel]) {
        self.ProductName = ProductName
        self.isExpandable = isExpandable
        self.EMI_SUB = EMI_SUB
    }

}
class emiModel {
    var EMINo:String
    var OrderID:String
    var OrderNo:String
    var EMIAmount:String
    var EMIDueDate:String
    var Date:String
    var CustomerID:String
    var ProductID:String
    var ProductAmount:String
    var EMIID:String
    init(EMINo:String,OrderID:String,OrderNo:String,EMIAmount:String,EMIDueDate:String,Date:String,CustomerID:String,ProductID:String,ProductAmount:String,EMIID:String) {
        self.EMINo = EMINo
        self.OrderID = OrderID
        self.OrderNo = OrderNo
        self.EMIAmount = EMIAmount
        self.EMIDueDate = EMIDueDate
        self.Date = Date
        self.CustomerID = CustomerID
        self.ProductID = ProductID
        self.ProductAmount = ProductAmount
        self.EMIID = EMIID
    }

}
class generatePaymentModel {
    var CustomerPaymentID:Int
    var ExternalPaymentID:String
    var PaymentAmount:String
    var ExternalTransactionID:String

    init(CustomerPaymentID:Int,ExternalPaymentID:String,PaymentAmount:String,ExternalTransactionID:String) {
        self.CustomerPaymentID = CustomerPaymentID
        self.ExternalPaymentID = ExternalPaymentID
        self.PaymentAmount = PaymentAmount
        self.ExternalTransactionID = ExternalTransactionID
    }
}

class sliderModel{
    var SliderName:String
    var Description:String
    var Photo:String

    init(SliderName:String,Description:String,Photo:String) {
        self.SliderName = SliderName
        self.Description = Description
        self.Photo = Photo
    }

}

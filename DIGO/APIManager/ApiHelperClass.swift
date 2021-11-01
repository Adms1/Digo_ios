//
//  ApiHelperClass.swift
//  DIGO
//
//  Created by ADMS on 22/10/21.
//

import Foundation
import MBProgressHUD
import Alamofire
import SwiftyJSON

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class ApiHttpUtility {

    static let sharedUHttp = ApiHttpUtility()

    typealias successComplitionHelder = ((_ success:JSON) -> ())
    typealias errorComplitionHelder = ((_ errorMessage:String?) -> ())

    func callPostHttpUtility(urlString:String,params:[String:Any],successComplition:@escaping successComplitionHelder,errorComplition:@escaping errorComplitionHelder)
    {


        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
        ]

        print("API, Params: \n",urlString)


        if !Connectivity.isConnectedToInternet() {
            print("The network is not reachable")
            return
        }

        Alamofire.request(urlString, method: .post, parameters: params, headers: headers).validate().responseJSON { response in

//            MBProgressHUD.hide(true)

            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //Bhargav Hide
                print("persion detail",json)

                if(json["status"] == "true") {
                    successComplition(json)
                }else
                {
                    successComplition(json)
                }

            case .failure(let error):
//                ProgressHUD.dismiss()
                errorComplition(error.localizedDescription)
                if !Connectivity.isConnectedToInternet() {
                    print("The network is not reachable")
                    return
                }
                print(error.localizedDescription)
            }
        }
    }

    func callApiEmailCheckPostHttpUtility(urlString:String,params:[String:Any],successComplition:@escaping successComplitionHelder,errorComplition:@escaping errorComplitionHelder)
    {


        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
        ]

        print("API, Params: \n",urlString)


        if !Connectivity.isConnectedToInternet() {
            print("The network is not reachable")
            return
        }

        Alamofire.request(urlString, method: .post, parameters: params, headers: headers).validate().responseJSON { response in

//            MBProgressHUD.hide(true)

            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //Bhargav Hide
                print("persion detail",json)

                if(json["status"] == "false") {
                    successComplition(json)
                }else{
                    successComplition(json)
                }

            case .failure(let error):
//                ProgressHUD.dismiss()
                errorComplition(error.localizedDescription)
                if !Connectivity.isConnectedToInternet() {
                    print("The network is not reachable")
                    return
                }
                print(error.localizedDescription)
            }
        }
    }

    func callGetHttpUtility(urlString:String,successComplition:@escaping successComplitionHelder,errorComplition:@escaping errorComplitionHelder)
    {
//        ProgressHUD.show()

        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
        ]

        print("API, Params: \n",urlString)


        if !Connectivity.isConnectedToInternet() {
            print("The network is not reachable")
            return
        }

        Alamofire.request(urlString, method: .post, parameters: nil, headers: headers).validate().responseJSON { response in

//            ProgressHUD.dismiss()

            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //Bhargav Hide
                print("persion detail",json)

                if(json["status"] == "true") {
                    successComplition(json)
                }
            case .failure(let error):
//                ProgressHUD.dismiss()
                errorComplition(error.localizedDescription)
                if !Connectivity.isConnectedToInternet() {
                    print("The network is not reachable")
                    return
                }
                print(error.localizedDescription)
            }
        }
    }

    func callPostMultipleApiHttpUtility(urlString:String,params:[String:Any],compltionHandler: @escaping (JSON?, Error?) -> ())
    {

        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
        ]

        print("API, Params: \n",urlString)


        if !Connectivity.isConnectedToInternet() {
            print("The network is not reachable")
            return
        }

        Alamofire.request(urlString, method: .post, parameters: params, headers: headers).validate().responseJSON { response in


            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //Bhargav Hide
                print("persion detail",json)

                if(json["status"] == "true") {
                    compltionHandler(json,nil)
                }
            case .failure(_):
                compltionHandler(nil,response.result.error)
                if !Connectivity.isConnectedToInternet() {
                    print("The network is not reachable")
                    return
                }
            }
        }
    }

    func callGetMultipleApiHttpUtility(urlString:String,compltionHandler: @escaping (JSON?, Error?) -> ())
    {

        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
        ]

        print("API, Params: \n",urlString)


        if !Connectivity.isConnectedToInternet() {
            print("The network is not reachable")
            return
        }

        Alamofire.request(urlString, method: .post, parameters: nil, headers: headers).validate().responseJSON { response in


            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //Bhargav Hide
                print("persion detail",json)

                if(json["status"] == "true") {
                    compltionHandler(json,nil)
                }
            case .failure(_):
                compltionHandler(nil,response.result.error)
                if !Connectivity.isConnectedToInternet() {
                    print("The network is not reachable")
                    return
                }
            }
        }
    }
}

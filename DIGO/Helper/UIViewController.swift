//
//  UIViewController.swift
//  DIGO
//
//  Created by ADMS on 02/11/21.
//

import Foundation
import UIKit

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height-50, width: self.view.frame.size.width-40, height: 35))
    toastLabel.backgroundColor = UIColor.black
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}
//    func showToast(message : String, seconds: Double){
//            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//            alert.view.backgroundColor = .black
//            alert.view.alpha = 0.5
//            alert.view.layer.cornerRadius = 15
//            self.present(alert, animated: true)
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
//                alert.dismiss(animated: true)
//            }
//        }

}


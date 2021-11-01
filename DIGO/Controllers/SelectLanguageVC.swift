//
//  SelectLanguageVC.swift
//  DIGO
//
//  Created by ADMS on 20/10/21.
//

import UIKit

class SelectLanguageVC: UIViewController {

    // MARK: - IBOutlat
    @IBOutlet weak var langCollection:UICollectionView!

    // MARK: - Varible
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    let arrLanguage = ["English","Hindi","Gujarati"]
    let arrTranslateLang = ["English","हिंदी","ગુજરાતી"]
//"Marathi","Punjabi","Tamil","Malayalam","Bangla","Kannada","Telugu",
    //"मराठी","ਪੰਜਾਬੀ","தமிழ்","മലയാളം","বাংলা","ಕನ್ನಡ","తెలుగు",
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true

        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height

        // Do any additional setup after loading the view, typically from a nib
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2, height: 130)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        langCollection!.collectionViewLayout = layout

        langCollection.showsVerticalScrollIndicator = false
        langCollection.showsHorizontalScrollIndicator = false

    }

}
// MARK: - extension using collectionview
extension SelectLanguageVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrLanguage.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LanguageCell", for: indexPath) as! LanguageCell

        cell.vwlangCell.layer.cornerRadius = 20.0
        cell.vwlangCell.layer.masksToBounds = true
//        cell.frame.size.width = screenWidth / 3
//        cell.frame.size.height = screenWidth / 3

        cell.lblTitle.text = arrLanguage[indexPath.row]
        cell.lblSubTitle.text = arrTranslateLang[indexPath.row]

        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth/2, height: 130)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {

        if arrLanguage[indexPath.row] == "English"
        {
            Bundle.set(language: "en")
            UserDefaults.standard.setValue("en", forKey:"ISLanguage")
            UserDefaults.standard.setValue(1, forKey:"langType")
        }else if arrLanguage[indexPath.row] == "Hindi"
        {
            Bundle.set(language: "hi")
            UserDefaults.standard.setValue("hi", forKey:"ISLanguage")
            UserDefaults.standard.setValue(1, forKey:"langType")
        }
        else if arrLanguage[indexPath.row] == "Gujarati"
        {
            Bundle.set(language: "gu")
            UserDefaults.standard.setValue("gu", forKey:"ISLanguage")
            UserDefaults.standard.setValue(1, forKey:"langType")
        }

        if let result  = UserDefaults.standard.value(forKey: "isLogin"){
            if (result as! String == "1")
            {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate

                let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController
             //   rootVC.view.backgroundColor = UIColor.white
                let frontNavigationController = UINavigationController(rootViewController: rootVC)
                appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                appDelegate.window?.rootViewController = frontNavigationController
                appDelegate.window?.backgroundColor = UIColor.white
                appDelegate.window?.makeKeyAndVisible()
            }
        }else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(loginVC, animated: true)

        }



    }
}

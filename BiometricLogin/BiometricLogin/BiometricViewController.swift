//
//  ViewController.swift
//  BiometricLogin
//
//  Created by Meenakshi Pathani on 11/01/22.
//

import UIKit
import LocalAuthentication

class BiometricViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }
    
    @IBAction func loginButtonAction(_ sender: Any){
        self.authenticateBiometrics()
    }
    
    fileprivate func setup(){
        if (BiometricAuthenticator.canAuthenticate())
        {
            if BiometricAuthenticator.shared.isFaceIdDevice(){
                titleLabel.text = "Login using Face Id"
                descriptionLabel.text = "Your Face should be in front of the camera to Login"
            } else{
                titleLabel.text = "Login using Fingerprint"
                descriptionLabel.text = "Place your finger on fingerprint scanner to Login"
            }
        }
    }

    fileprivate func showHomeScreen(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                self.present(viewController, animated: true, completion: nil)
            }
    }


}

extension BiometricViewController{
    
    fileprivate func authenticateBiometrics(){
        BiometricAuthenticator.authenticateWithBiometric(reason: ""){ [weak self] (result) in
            
            switch result{
            case .success(let status):
                if status{
                    debugPrint("Login sucessfully")
                    self?.showHomeScreen()
                }
            case .failure( let error):
                switch error{
                case .biometryLockedOut:
                    self?.showPasscodeAuthentication(message: error.message())
                case .biometryNotEnrolled:
                    self?.showSettingAlert(message: error.message())
                default:
                    debugPrint(error.message())
                }
            }
        
            
        }
    }
    
    fileprivate func showPasscodeAuthentication(message: String){
        BiometricAuthenticator.authenticateWithPasscode(reason: message){[weak self] (result) in
            switch result{
            case .success(let status):
                if (status){
                    debugPrint("Login sucessfully")
                }
            case .failure(let error):
                debugPrint(error.message())
            }
        }
    }
    
    fileprivate func showSettingAlert(message:String){
        let alertCtrl = UIAlertController(title: "App Name", message: message, preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "Settings", style: .default){ (_) -> Void in
            guard let setingUrl = URL(string: UIApplication.openSettingsURLString) else{
                return
            }
            if UIApplication.shared.canOpenURL(setingUrl){
                UIApplication.shared.open(setingUrl, completionHandler: { (sucess) in
                    debugPrint("Setting opened \(sucess)")
                })
            }
        }
        alertCtrl.addAction(settingAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertCtrl.addAction(cancelAction)
        present(alertCtrl, animated: true, completion: nil)
    }
}


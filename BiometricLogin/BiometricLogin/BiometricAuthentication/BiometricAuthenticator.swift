//
//  BiometricAuthenticator.swift
//  BiometricLogin
//
//  Created by Meenakshi Pathani on 11/01/22.
//

import Foundation
import UIKit
import LocalAuthentication

class BiometricAuthenticator: NSObject{
    
    static let shared = BiometricAuthenticator()
    fileprivate override init(){}
    fileprivate lazy var context:LAContext? = {
        return LAContext()
    }()
    
    var allowableResuseDuration: TimeInterval? = nil{
        didSet{
            guard let duration = allowableResuseDuration else{
                return
            }
            if #available(iOS 9.0, *){
                self.context?.touchIDAuthenticationAllowableReuseDuration = duration
            }
        }
    }
    
    fileprivate func defaultBiometricAuthenticationReason() -> String{
        return faceIDAvailable() ? kFaceIdAuthenticationReason : kTouchIdAuthenticationReason
    }
    
    fileprivate func defaultPasscodeAuthenticationReason() -> String{
        return faceIDAvailable() ? kFaceIdPasscodeAuthenticationReason : kTouchIdPasscodeAuthenticationReason
    }
    
    fileprivate func isReuseDurationSet() -> Bool{
        guard allowableResuseDuration != nil else{
            return false
        }
        return true
    }
    
    func evaluate(policy: LAPolicy, with context:LAContext, reason:String, completion: @escaping(Result<Bool, AuthenticationError>) -> Void){
        context.evaluatePolicy(policy, localizedReason: reason){ (sucess, err) in
            DispatchQueue.main.async {
                if sucess{
                    completion(.success(true))
                }else{
                    guard let error = err as? LAError else{
                        return
                    }
                    let errorType = AuthenticationError.initWithError(error)
                    completion(.failure(errorType))
                }
            }
        }
    }
    
    func faceIDAvailable() -> Bool{
//        let context = LAContext()
//        var error:NSError?
//        let canEvaluate = LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        let canEvaluate = BiometricAuthenticator.canAuthenticate()

        if #available(iOS 11.0, *){
            return canEvaluate && LAContext().biometryType == .faceID
        }
        return canEvaluate
    }
    
    func touchIDAvailable() -> Bool{
//        let context = LAContext()
//        var error:NSError?
//        let canEvaluate = LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
        let canEvaluate = BiometricAuthenticator.canAuthenticate()
        if #available(iOS 11.0, *){
            return canEvaluate && LAContext().biometryType == .touchID
        }
        return canEvaluate
    }
    
    func isFaceIdDevice() -> Bool{
        let context = LAContext()
        _ = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
        if #available(iOS 11.0, *){
            return context.biometryType == .faceID
        }
        return false
    }
    
    class func canAuthenticate() -> Bool{
        var isBiometricAuthenticationAvailable = false
        var error:NSError? = nil
        if LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error){
            isBiometricAuthenticationAvailable = (error == nil)
        }
        return isBiometricAuthenticationAvailable
    }
    
    class func authenticateWithBiometric(reason:String, fallbackTitle: String? = "", cancelTitle:String? = "", completion: @escaping(Result<Bool, AuthenticationError>) -> Void){
        let reasonString = reason.isEmpty ? BiometricAuthenticator.shared.defaultBiometricAuthenticationReason(): reason
        
        var context:LAContext!
        if BiometricAuthenticator.shared.isReuseDurationSet(){
            context = BiometricAuthenticator.shared.context
        } else{
            context = LAContext()
        }
        context.localizedFallbackTitle = fallbackTitle
        if #available(iOS 10, *){
            context.localizedCancelTitle = cancelTitle
        }
        
        BiometricAuthenticator.shared.evaluate(policy: .deviceOwnerAuthenticationWithBiometrics, with: context, reason: reasonString, completion: completion)
    }
    
    class func authenticateWithPasscode(reason:String, fallbackTitle: String? = "", cancelTitle:String? = "", completion: @escaping(Result<Bool, AuthenticationError>) -> Void){
        let reasonString = reason.isEmpty ? BiometricAuthenticator.shared.defaultBiometricAuthenticationReason(): reason
        
        var context:LAContext!
        if BiometricAuthenticator.shared.isReuseDurationSet(){
            context = BiometricAuthenticator.shared.context
        } else{
            context = LAContext()
        }
        context.localizedFallbackTitle = fallbackTitle
        if #available(iOS 10, *){
            context.localizedCancelTitle = cancelTitle
        }
        
        if #available(iOS 9.0, *){
            BiometricAuthenticator.shared.evaluate(policy: .deviceOwnerAuthentication, with: context, reason: reasonString, completion: completion)
        }
        else{
            BiometricAuthenticator.shared.evaluate(policy: .deviceOwnerAuthenticationWithBiometrics, with: context, reason: reasonString, completion: completion)
        }
    }
}

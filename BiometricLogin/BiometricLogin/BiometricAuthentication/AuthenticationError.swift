//
//  AuthenticationError.swift
//  BiometricLogin
//
//  Created by Meenakshi Pathani on 11/01/22.
//

import LocalAuthentication

enum AuthenticationError:Error{
    case failed, canceledByUser, fallback, cancelledBySystem, passcodeNotSet, biometryNotAvailable, biometryNotEnrolled, biometryLockedOut, other
    
    static func initWithError(_ error:LAError) -> AuthenticationError{
        switch Int32(error.errorCode){
        case kLAErrorAuthenticationFailed:
            return failed
        case kLAErrorUserCancel:
            return canceledByUser
        case kLAErrorUserFallback:
            return fallback
        case kLAErrorSystemCancel:
            return cancelledBySystem
        case kLAErrorPasscodeNotSet:
            return passcodeNotSet
        case kLAErrorBiometryNotAvailable:
            return biometryNotAvailable
        case kLAErrorBiometryNotEnrolled:
            return biometryNotEnrolled
        case kLAErrorBiometryLockout:
            return biometryLockedOut
        default:
            return other
            
        }
    }
    // error message based on type
    
    func message() -> String{
        
        let isFaceIdDevice = BiometricAuthenticator.shared.isFaceIdDevice()
        
        switch self {
        case .canceledByUser, .cancelledBySystem, .fallback:
            return ""
        case .passcodeNotSet:
            return isFaceIdDevice ? kSetPasscodeToUserFaceID : kSetPasscodeToUserTouchID
        case .biometryNotAvailable:
            return kBiometricNotAvailableReason
        case .biometryNotEnrolled:
            return isFaceIdDevice ? kNoFaceIdentityEnrolled : kNoFingerprintEnrolled
        case .biometryLockedOut:
            return isFaceIdDevice ? kFaceIdPasscodeAuthenticationReason : kTouchIdPasscodeAuthenticationReason
        default:
            return isFaceIdDevice ? kDefaultFaceIDAuthnticationFailReason : kTouchIdAuthFailReason
        }
    }
}

//
//  BiometricAuthenticationConstants.swift
//  BiometricLogin
//
//  Created by Meenakshi Pathani on 11/01/22.
//

import Foundation

 let kBiometricNotAvailableReason = "Biometric authentication is not available for this device."

// TOUCH ID
let kTouchIdAuthenticationReason = "Confirm your fingerprint to authenticate."
let kTouchIdPasscodeAuthenticationReason = "Touch ID is locked now, because of too many failed attempts. Enter passcode to unlock Touch ID."

let kSetPasscodeToUserTouchID = "Please set dveice passcode to use Touch ID for authentication."
let kNoFingerprintEnrolled = "There are no fingerprints enrolled in the dveice. Please go to device Settings -> Touch Id & Passcode and enroll your fingerprints."
let kTouchIdAuthFailReason = "Touch ID does not recognise your fingerprint. Please try again."

// FACE ID
let kFaceIdAuthenticationReason = "Confirm your face to authenticate."
let kFaceIdPasscodeAuthenticationReason = "Face ID is locked now, because of too many failed attempts. Enter passcode to unlock Face ID."

let kSetPasscodeToUserFaceID = "Please set dveice passcode to use Face ID for authentication."
let kNoFaceIdentityEnrolled = "There is no face enrolled in the dveice. Please go to device Settings -> Face Id & Passcode and enroll your fingerprints."
let kDefaultFaceIDAuthnticationFailReason = "Face ID does not recognise your face. Please try again."

//
//  Constants.swift
//
//  Created by C237 on 30/10/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

let GET = "GET"
let POST = "POST"
let MEDIA = "MEDIA"

let DEFAULT_TIMEOUT:TimeInterval = 180.0

//http://45.55.42.45/WebService/service
let Server_URL          = "http://45.55.42.45/WebService/service"
let Profile_Pic_URL     = "http://45.55.42.45/upload/update_user_proimage"
let Get_Profile_Pic_URL = "http://45.55.42.45/uploads/product_image/"
let WorkWithUs_URL      = "http://45.55.42.45/upload/workWithUs/"
let SearchURL           = "http://45.55.42.45/upload/search/"
let UploadChatImageURL  = "http://45.55.42.45/upload/chat_image"
let ChatImageURL        = "http://45.55.42.45/uploads/chat_image/"
let getHelperDetails      = "http://45.55.42.45/upload/getWorkWithUs/"
/*let Server_URL = "http://luckbyspin.tk/helpme/WebService/service"
let Profile_Pic_URL = "http://luckbyspin.tk/helpme/upload/update_user_proimage"
let Get_Profile_Pic_URL = "http://luckbyspin.tk/helpme/uploads/product_image/"
let WorkWithUs_URL = "http://luckbyspin.tk/helpme/upload/work_with_us/"
let SearchURL = "http://luckbyspin.tk/helpme/upload/search/"
let UploadChatImageURL = "http://luckbyspin.tk/helpme/upload/chat_image"
let ChatImageURL = "http://luckbyspin.tk/helpme/upload/chat_image"*/

/*let Server_URL = "http://192.168.0.145/helpme/WebService/service"
let Profile_Pic_URL = "http://192.168.0.145/helpme/upload/update_user_proimage"
let Get_Profile_Pic_URL = "http://192.168.0.145/helpme/uploads/product_image/"
let WorkWithUs_URL = "http://192.168.0.145/helpme/upload/work_with_us/"
let SearchURL = "http://192.168.0.145/helpme/upload/search/"
let UploadChatImageURL = "http://luckbyspin.tk/helpme/upload/chat_image"
let ChatImageURL = "http://luckbyspin.tk/helpme/uploads/chat_image/"*/

//MARK: Response Keys

let kData = "data"
let kMessage = "message"
let kStatus = "success"
let kToken = "token"
let kCode = "code"
let kSecret_log_id = "secret_log_id"


//MARK - API MESSAGES
let APICountryList = "Loading Countries"
let APIEmailCheck = "Checking Email Avaibility"
let APISendingCode = "Sending Verification Code"
let APIVerificationCode = "Verifying Code"
let APISignUpMessage = "REGISTERING"
let APISocialLoginMessage = "Login In"
let APISocialLogOutMessage = "Logout"
let APIPasswordRecovery = "Requesting Password"
let APIUpdateProfileMessage = "Updating Profile Details"
let APIUpdateProfilePicMessage = "Updating Profile Pic"
let APIUpdatePasswordMessage = "Updating Password"
let APINotificationMessage = "Loading Notification"
let APIMenuMessage = "Loading Menu"
let APICategoryMessage = "Loading Category"
let APISubCategoryMessage = "Loading Subcategory"
let APISkillsMessage = "Loading Skills"
let APISendRequestMessage = "Sending Request"
let APIRequestsMessage = "Loading Requests"
let APIRejectRequestMessage = "Rejecting Request"
let APIAddCostingMessage = "Accepting Request"
let APIConfirmJobMessage = "Confirming"
let APIDelineJobMessage = "Declining"
let APIProjectCompletionMessage = "Completing"
let APIProjectReworkMessage = "Sending for Rework"
let APIPaymentTransferMessage = "Paying to Helper"
let APIGetUserBalanceMessage = "Loading Balance"
let APIGetCostingDetailMessage = "Loading Costing Details"
let APIStripePaymentMessage = "Processing Payment"
let APIGetEphemeralKeyMessage = "Loading"


//API Services

let APILogin = "login"
let APILoginKey = "data"

let APILogOut = "logout"

let APIForgotPassword = "forgotpassword"

let APISignupKey = "data"
let APISignUp = "signup"

let APIUpdatePassword = "changepassword"

let APIUpdateProfilePic = "updateProfilepic"
let APIUpdateProfilePicKey = "data"

let APIUpdateProfile = "update_user"
let APIUpdateProfileKey = "data"

let APIGetCategory = "categorylist"
let APIGetCategoryKey = "data"

let APIGetSubCategory = "get_all_sub_category"
let APIGetSubCategoryKey = "data"

let APIGetSkills = "get_all_skills"
let APIGetSkillsKey = "data"

let APISentRequestsList = "send_request_list"
let APIReceivedRequestsList = "receive_request_list"
let APISentAndReceivedRequestsListKey = "data"

let APIAllRequests = "get_all_request"
let APIAllRequestsData = "data"

let APISendRequest = "send_request"
let APISendRequestKey = "data"

let APIRejectRequest = "user_reject_request"
let APIAddCosting = "add_cost"

let APIConfirmJob = "confirm_job"
let APIDeclineJob = "decline_job"

let APIGetCostDetail = "get_cost_detail"
let APIGetCostDetailKey = "data"

let APIProjectCompletion = "project_completion"
let APIProjectCompletionKey = "data"

let APIProjectRework = "project_rework"
let APIProjectReworkKey = "data"

let APIPaymentTransfer = "payment_to_employee"
let APIPaymentTransferKey = "data"

let APIGetUserBalance = "get_user_balance"

let APIGetEphemeralKey = "get_ephemeral_key"

let APIStripePayment = "stripe_payment"

let APIGetCountyPhonecodeKey = "data"
let APIGetCountyPhonecode = "getCountyPhonecode"

let APISendCode = "SendCode"
let APIVeifyCode = "verifycode"

let APISocialLoginKey = "data"
let APISocialLogin = "sociallogin"

let APIGetCookerKey = "data"
let APIGetCooker = "getNearCookers"

let APIGetCookerCategoryKey = "data"
let APIGetCookerCategory = "getFoodMenuCategory"

let APIGetNotificationKey = "data"
let APIGetNotification = "getNotification"

let APISearchCookerKey = "data"
let APISearchCooker = "searchBarForNearCooker"

let APIMenuKey = "data"
let APIMenu = "getFoodMenuById"

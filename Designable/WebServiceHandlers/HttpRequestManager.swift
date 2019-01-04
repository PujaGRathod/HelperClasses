//
//  HttpRequestManager.swift
//  Copyright © 2016 PayalUmraliya. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON

//Encoding Type
let URL_ENCODING = URLEncoding.default
let JSON_ENCODING = JSONEncoding.default

//Web Service Result

public enum RESPONSE_STATUS : NSInteger
{
    case INVALID
    case VALID
    case MESSAGE
}
protocol UploadProgressDelegate
{
    func didReceivedProgress(progress:Float)
}
    
protocol DownloadProgressDelegate
{
    func didReceivedDownloadProgress(progress:Float,filename:String)
    func didFailedDownload(filename:String)
}

class HttpRequestManager
{
    static let sharedInstance = HttpRequestManager()
    let additionalHeader = ["User-Agent": "iOS"]
    var responseObjectDic = Dictionary<String, AnyObject>()
    var URLString : String!
    var Message : String!
    var resObjects:AnyObject!
    var alamoFireManager = Alamofire.SessionManager.default
    var delegate : UploadProgressDelegate?
    var downloadDelegate : DownloadProgressDelegate?
    // METHODS
    init()
    {
        alamoFireManager.session.configuration.timeoutIntervalForRequest = 120 //seconds
        alamoFireManager.session.configuration.httpAdditionalHeaders = additionalHeader
    }
    //MARK:- Cancel Request
    func cancelAllAlamofireRequests(responseData:@escaping ( _ status: Bool?) -> Void)
    {
        alamoFireManager.session.getTasksWithCompletionHandler
            {
                dataTasks, uploadTasks, downloadTasks in
                dataTasks.forEach { $0.cancel() }
                uploadTasks.forEach { $0.cancel() }
                downloadTasks.forEach { $0.cancel() }
                responseData(true)
        }
    }
    
    //MARK:- GET
    //CURRENTLY NOT IN USE BECAUSE THIS IS GET
    func getRequest(endpointurl:String,
                    service:String,
                    parameters:NSDictionary,
                    keyname:NSString,
                    message:String,
                    showLoader:Bool,
                    responseData:@escaping  (_ error: NSError?,_ responseArray: NSArray?, _ responseDict: NSDictionary?) -> Void)
    {
        DLog(message: "URL : \(endpointurl) \nParam :\( parameters) ")
        ShowNetworkIndicator(xx: true)
        alamoFireManager.request(endpointurl, method: .get, parameters: parameters as? [String : AnyObject]).responseString(completionHandler: { (responseString) in
            
            print(responseString.value ?? "error")
            ShowNetworkIndicator(xx: false)
            if(responseString.value == nil)
            {
                hideLoaderHUD()
                responseData(responseString.error as NSError?,nil,nil)
            }
            else
            {
                //let strResponse = "\(responseString.value!)"
                //let arr = strResponse.components(separatedBy: "\n")
                //let dict =  convertStringToDictionary(str:(arr.last  ?? "")!)
                
                var strResponse = "\(responseString.value!)"
                strResponse = strResponse.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
                let arr = strResponse.components(separatedBy: "\n")
                
                var dict : [String:Any]?
                for jsonString in arr{
                    if let jsonDataToVerify = jsonString.data(using: String.Encoding.utf8)
                    {
                        do {
                            dict = try JSONSerialization.jsonObject(with: jsonDataToVerify) as? [String : Any]
                            print("JSON is valid.")
                        } catch {
                            //print("Error deserializing JSON: \(error.localizedDescription)")
                        }
                    }
                }
                
                let str = dict?[kMessage] as? String ?? ServerResponseError
                
                self.Message = str
                let responseStatus = dict?[kStatus] as? Int ?? 0
                print(responseStatus)
                switch (responseStatus)
                {
                case RESPONSE_STATUS.VALID.rawValue:
                    self.resObjects = dict as AnyObject
                    
                    if(keyname != "")
                    {
                        self.parseData(
                            dicResponse: self.resObjects as! NSDictionary,
                            service: service,
                            parseKey:keyname,
                            completionData: {(arrData) -> () in
                                hideLoaderHUD()
                                if(arrData.count > 0)
                                {
                                    responseData(nil,arrData,self.resObjects as? NSDictionary)
                                }
                                else
                                {
                                    showStatusbarMessage(self.Message!, 3)
                                }
                        })
                    }
                    else
                    {
                        hideLoaderHUD()
                        responseData(nil,nil,self.resObjects as? NSDictionary)
                    }
                    
                    break
                case RESPONSE_STATUS.INVALID.rawValue:
                    hideLoaderHUD()
                    self.resObjects = nil
                    showMessage(self.Message)
                    break
                default :
                    break
                }
            }
            
        })
        
    }
    
    //MARK:- POST
    func requestWithPostMultipartParam(endpointurl:String, isImage:Bool,parameters:NSDictionary,responseData:@escaping (_ data: AnyObject?, _ error: NSError?, _ message: String?, _ responseDict: AnyObject?) -> Void)
    {
        if isConnectedToNetwork()
        {
            DLog(message: "URL : \(endpointurl) \nParam :\( parameters) ")
            alamoFireManager.upload(multipartFormData:
            { multipartFormData in
                for (key, value) in parameters
                {
                    if value is Data {
                        multipartFormData.append(value as! Data, withName: key as! String, fileName: "helpme.jpg", mimeType: "image/jpeg")
                    }
                    else if value is URL{
                        
                        let url = value as! URL
                        
                        let fileExt = (url.lastPathComponent.components(separatedBy: ".").last!).lowercased()
                        var mime = ""
                        
                        switch fileExt{
                        case "xls":
                            mime = "application/vnd.ms-excel"
                            break
                        case "xlsx":
                            mime = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                            break
                        case "doc":
                            mime = "application/msword"
                            break
                        case "docx":
                            mime = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
                            break
                        case "pdf":
                            mime = "application/pdf"
                            break
                        case "rtf":
                            mime = "application/rtf"
                            break
                        case "txt":
                            mime = "text/plain"
                            break
                        default:
                            break
                        }
                        
                        var fileData:Data? = nil
                        do{
                            fileData = try Data.init(contentsOf: url)
                            multipartFormData.append(fileData!, withName: key as! String, fileName: "helpme.\(fileExt)", mimeType: mime)
                        }catch{
                            print(error.localizedDescription)
                        }
                        
                        
                    }
                    else {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
                    }
                }
            }, to: endpointurl,encodingCompletion:
            { encodingResult in
                switch encodingResult
                {
                    case .success(let upload, _, _):
                        upload.responseString(completionHandler:{(responseString) in
                            print(responseString.value ?? "error")
                            ShowNetworkIndicator(xx: false)
                            if(responseString.value == nil)
                            {
                                responseData(nil, responseString.error as NSError?, nil, responseString.error as AnyObject?)
                            }
                            else
                            {
                                //let strResponse = "\(responseString.value!)"
                                //let arr = strResponse.components(separatedBy: "\n")
                                
                                //let dict =  convertStringToDictionary(str:(arr.last  ?? "")!)
                                
                                var strResponse = "\(responseString.value!)"
                                strResponse = strResponse.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                                
                                let arr = strResponse.components(separatedBy: "\n")
                                
                                var dict : [String:Any]?
                                for jsonString in arr{
                                    if let jsonDataToVerify = jsonString.data(using: String.Encoding.utf8)
                                    {
                                        do {
                                            dict = try JSONSerialization.jsonObject(with: jsonDataToVerify) as? [String : Any]
                                            print("JSON is valid.")
                                        } catch {
                                            //print("Error deserializing JSON: \(error.localizedDescription)")
                                        }
                                    }
                                }
                                
                                let str = dict?[kMessage] as? String ?? ServerResponseError
                                
                                self.Message = str
                                let responseStatus = dict?[kStatus] as? Int ?? 0
                                print(responseStatus)
                                switch (responseStatus)
                                {
                                case RESPONSE_STATUS.VALID.rawValue:
                                    self.resObjects = dict as AnyObject
                                    break
                                case RESPONSE_STATUS.INVALID.rawValue:
                                    self.resObjects = nil
                                    break
                                    
                                default :
                                    break
                                }
                                responseData(self.resObjects, nil, self.Message, responseString.value as AnyObject?)
                            }
                    })
                    break
                    case .failure(let encodingError):
                            print("ENCODING ERROR: ",encodingError)
                            responseData(nil, nil, nil, nil)
                }
            })
        }
    }
    //requestWithPostJsonParam
    func requestWithPostJsonParam( endpointurl:String,
                                                    service:String,
                                                    parameters:NSDictionary,
                                                    keyname:NSString,
                                                    message:String,
                                                    showLoader:Bool,
                                                    responseData:@escaping  (_ error: NSError?,_ responseArray: NSArray?, _ responseDict: NSDictionary?) -> Void)
    {
        if isConnectedToNetwork()
        {
            if(showLoader)
            {
                showLoaderHUD(strMessage: message)
            }
            DLog(message: "URL : \(endpointurl) \nParam :\( parameters) ")
            ShowNetworkIndicator(xx: true)
            alamoFireManager.request(endpointurl, method: .post, parameters: parameters as? Parameters, encoding: JSONEncoding.default, headers: additionalHeader)
                .responseString(completionHandler: { (responseString) in
                    print(responseString.value ?? "error")
                    ShowNetworkIndicator(xx: false)
                    if(responseString.value == nil)
                    {
                        hideLoaderHUD()
                        responseData(responseString.error as NSError?,nil,nil)
                    }
                    else
                    {
                        //let strResponse = "\(responseString.value!)"
                        //let arr = strResponse.components(separatedBy: "\n")
                        //let dict =  convertStringToDictionary(str:(arr.last  ?? "")!)
                        
                        var strResponse = "\(responseString.value!)"
                        strResponse = strResponse.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                        
                        let arr = strResponse.components(separatedBy: "\n")
                        
                        var dict : [String:Any]?
                        for jsonString in arr{
                            if let jsonDataToVerify = jsonString.data(using: String.Encoding.utf8)
                            {
                                do {
                                    dict = try JSONSerialization.jsonObject(with: jsonDataToVerify) as? [String : Any]
                                    print("JSON is valid.")
                                } catch {
                                    //print("Error deserializing JSON: \(error.localizedDescription)")
                                }
                            }
                        }
                        
                        let str = dict?[kMessage] as? String ?? ServerResponseError
                        self.Message = str
                        let responseStatus = dict?[kStatus] as? Int ?? 0
                        print(responseStatus)
                        switch (responseStatus)
                        {
                        case RESPONSE_STATUS.VALID.rawValue:
                            self.resObjects = dict as AnyObject
                            
                            if(keyname != "")
                            {
                                self.parseData(
                                    dicResponse: self.resObjects as! NSDictionary,
                                    service: service,
                                    parseKey:keyname,
                                    completionData: {(arrData) -> () in
                                        hideLoaderHUD()
                                        if(arrData.count > 0)
                                        {
                                            responseData(nil,arrData,self.resObjects as? NSDictionary)
                                        }
                                        else
                                        {
                                            showStatusbarMessage(self.Message!, 3)
                                        }
                                })
                            }
                            else
                            {
                                hideLoaderHUD()
                                responseData(nil,nil,self.resObjects as? NSDictionary)
                            }
                            
                            break
                        case RESPONSE_STATUS.INVALID.rawValue:
                            hideLoaderHUD()
                            self.resObjects = nil
                            showMessage(self.Message)
                            let err = NSError.init(domain: "Domain", code: 7874, userInfo: ["description" : self.Message])
                            responseData(err,nil,nil)
                            break
                        default :
                            break
                        }
                    }
                })
        }
    }
    
    func parseData(
                   dicResponse:NSDictionary,
                   service:String,
                   parseKey:NSString,
                   completionData:@escaping(_ arrData:NSMutableArray)->())
    {
       
        let arrResponseData = NSMutableArray()
        for (key, _) in dicResponse
        {
            if(key as! String == parseKey as String)
            {
                switch service{
                case APILogin:
                    let jsonData = JSON(dicResponse[parseKey] as! NSDictionary)
                    let objData:AppUser = AppUser.init(json: jsonData)
                    arrResponseData.add(objData)
                    
                    //Set User Data In User Defaults
                    UserDefaultManager.setStringToUserDefaults(value: dicResponse["token"] as! String, key:kToken )
                    UserDefaultManager.setStringToUserDefaults(value: "\(dicResponse["secret_log_id"]!)", key:kSecret_log_id )

                    UserDefaultManager.setBooleanToUserDefaults(value: true, key: UD_IsLoggedIn)
                    setUpUserData(objData)
                    UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: dicResponse[parseKey] as! NSDictionary, key: kAppUser)
                    completionData(arrResponseData)
                    break
                    
                case APISignUp:
                    let jsonData = JSON(dicResponse[parseKey] as! NSDictionary)
                    let objData:AppUser = AppUser.init(json: jsonData)
                    arrResponseData.add(objData)
                    
                    //Set User Data In User Defaults
                    UserDefaultManager.setStringToUserDefaults(value: dicResponse["token"] as! String, key:kToken )
                    UserDefaultManager.setStringToUserDefaults(value: "\(dicResponse["secret_log_id"]!)", key:kSecret_log_id )

                    UserDefaultManager.setBooleanToUserDefaults(value: true, key: UD_IsLoggedIn)
                    setUpUserData(objData)
                    UserDefaultManager.setCustomObjToUserDefaults(CustomeObj: dicResponse[parseKey] as! NSDictionary, key: kAppUser)
                    completionData(arrResponseData)
                    break
                    
                case APIGetCategory:
                    let arrData = dicResponse[parseKey] as! NSArray
                    for dicData in arrData
                    {
                        let jsonData = JSON(dicData)
                        let objData:Category = Category.init(json: jsonData)
                        arrResponseData.add(objData)
                    }
                    completionData(arrResponseData)
                    break
                    
                case APIGetSubCategory:
                    let arrData = dicResponse[parseKey] as! NSArray
                    for dicData in arrData
                    {
                        let jsonData = JSON(dicData)
                        let objData:SubCategory = SubCategory.init(json: jsonData)
                        arrResponseData.add(objData)
                    }
                    completionData(arrResponseData)
                    break
                    
                case APIGetSkills:
                    let arrData = dicResponse[parseKey] as! NSArray
                    for dicData in arrData
                    {
                        let jsonData = JSON(dicData)
                        let objData:Skill = Skill.init(json: jsonData)
                        arrResponseData.add(objData)
                    }
                    completionData(arrResponseData)
                    break
                    
                case APIReceivedRequestsList:
                    let arrData = dicResponse[parseKey] as! NSArray
                    for dicData in arrData
                    {
                        let jsonData = JSON(dicData)
                        let objData:ReceivedRequest = ReceivedRequest.init(json: jsonData)
                        arrResponseData.add(objData)
                    }
                    completionData(arrResponseData)
                    break
                    
                case APISentRequestsList:
                    let arrData = dicResponse[parseKey] as! NSArray
                    for dicData in arrData
                    {
                        let jsonData = JSON(dicData)
                        let objData:SentRequest = SentRequest.init(json: jsonData)
                        arrResponseData.add(objData)
                    }
                    completionData(arrResponseData)
                    break
                    
                case APIAllRequests:
                    let arrData = dicResponse[parseKey] as! NSArray
                    for dicData in arrData
                    {
                        let jsonData = JSON(dicData)
                        let objData:Request = Request.init(json: jsonData)
                        arrResponseData.add(objData)
                    }
                    completionData(arrResponseData)
                    break
                    
                case APIGetCostDetail:
                    let arrData = dicResponse[parseKey] as! NSArray
                    for dicData in arrData
                    {
                        let jsonData = JSON(dicData)
                        let objData:CostingDetail = CostingDetail.init(json: jsonData)
                        arrResponseData.add(objData)
                    }
                    completionData(arrResponseData)
                    break
                    
                default:
                    completionData(arrResponseData)
                    break
                }
                return
            }
        }
    }
    
    func setUpUserData(_  objUser:AppUser)  {
        UserDefaultManager.setStringToUserDefaults(value: objUser.firstname ?? "", key: kAppUserFName)
        UserDefaultManager.setStringToUserDefaults(value: objUser.lastname ?? "", key: kAppUserLName)
        UserDefaultManager.setStringToUserDefaults(value: objUser.email ?? "", key: kAppUserEmail)
        UserDefaultManager.setStringToUserDefaults(value: objUser.userId ?? "", key: kAppUserId)
        UserDefaultManager.setStringToUserDefaults(value: objUser.image ?? "", key: kAppUserProfile)
        UserDefaultManager.setStringToUserDefaults(value: objUser.contactno ?? "", key: kAppUserMobile)
        UserDefaultManager.setStringToUserDefaults(value: objUser.userType ?? "", key: kAppUserType)
        UserDefaultManager.setStringToUserDefaults(value: objUser.isConsultant ?? "", key: kAppIsConsultant)

        print("AuthenticationToken: " + UserDefaultManager.getStringFromUserDefaults(key: kToken))
        print("LoginID: " + UserDefaultManager.getStringFromUserDefaults(key: kAppUserId))
    }
}

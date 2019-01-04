//
//  Downloader.swift
//  StoryExample
//
//  Created by Admin on 13/03/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Alamofire

class Downloader {
    class func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = "get"
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }
                
                completion()
                
            } else {
                print("Failure: %@", "\(error?.localizedDescription ?? "ERROR")");
            }
        }
        task.resume()
    }
    
    class func download(url: URL, completion: @escaping () -> ()){
//        LoadingHud.showHUD(withText: "DOWNLOADING")
        let destination = DownloadRequest.suggestedDownloadDestination()
        
        Alamofire.download(url, to: destination).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { (progress) in
            print("Progress: \(progress.fractionCompleted)")
            } .validate().responseData { ( response ) in
                
                if let error = response.error{
                    print("Error: \(error.localizedDescription)")
                }
                else{
                    print(response.destinationURL!.lastPathComponent)
                    completion()
                }
//                LoadingHud.dismissHUD()
        }
    }
    
}

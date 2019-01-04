//
//  CD_Messages+CoreDataClass.swift
//
//
//  Created by Admin on 31/03/18.
//
//

import UIKit
import CoreData
import Contacts

class CoreDBManager: NSObject {
    
     static let sharedDatabase = CoreDBManager()
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "HelpMe", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
       
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("HelpMe.sqlite")
        NSLog("Database Path: \(url)")

        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
           
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
               
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
/*
extension CoreDBManager{
    
    //MARK:- CHAT MESSAGES
    
    func saveMessageInLocalDB(objmessgae:StructChat) -> Bool
    {
        let objContext = self.managedObjectContext
        let fetchRequest = NSFetchRequest<CD_Messages>(entityName: ENTITY_CHAT)
        let disentity: NSEntityDescription = NSEntityDescription.entity(forEntityName: ENTITY_CHAT, in: objContext)!
        let predicate = NSPredicate(format:"id == %@",objmessgae.kid)
        fetchRequest.predicate = predicate
        fetchRequest.entity = disentity
        
        do{
            let results = try  managedObjectContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [CD_Messages]
            if(results.count > 0)
            {
                let chatObj = results[0] as CD_Messages
                chatObj.id = objmessgae.kid
                chatObj.createddate = objmessgae.kcreateddate
                chatObj.platform = objmessgae.kdevicetype
                chatObj.textmessage = objmessgae.kchatmessage
                chatObj.receiverid = objmessgae.kreceiverid
                chatObj.senderid = objmessgae.ksenderid
                chatObj.isdeleted = objmessgae.kisdeleted
                chatObj.isread = objmessgae.kisread
                chatObj.mediaurl = objmessgae.kmediaurl
                chatObj.messagetype = objmessgae.kmessagetype
                chatObj.chatid = objmessgae.kchatid
                chatObj.image = objmessgae.kuserprofile
                chatObj.is_online = objmessgae.kuseronline
                chatObj.last_login = objmessgae.kuserlastlogin
                chatObj.username = objmessgae.kusername
                chatObj.user_id = objmessgae.kuserid
            }
            else
            {
                
                let  chatObj = (NSEntityDescription.insertNewObject(forEntityName:ENTITY_CHAT,into:managedObjectContext) as? CD_Messages)!
                chatObj.id = objmessgae.kid
                chatObj.createddate = objmessgae.kcreateddate
                chatObj.platform = objmessgae.kdevicetype
                chatObj.textmessage = objmessgae.kchatmessage
                chatObj.receiverid = objmessgae.kreceiverid
                chatObj.senderid = objmessgae.ksenderid
                chatObj.isdeleted = objmessgae.kisdeleted
                chatObj.isread = objmessgae.kisread
                chatObj.mediaurl = objmessgae.kmediaurl
                chatObj.messagetype = objmessgae.kmessagetype
                chatObj.chatid = objmessgae.kchatid
                chatObj.image = objmessgae.kuserprofile
                chatObj.is_online = objmessgae.kuseronline
                chatObj.last_login = objmessgae.kuserlastlogin
                chatObj.username = objmessgae.kusername
                chatObj.user_id = objmessgae.kuserid
                
                //UPDATE FRIENDS TABLE'S RECORD FOR USERID
                
                updateFriend(for: objmessgae)
                
            }
            self.saveContext()
            return true
            
        }
        catch
        {
            return false
        }
    }
    
    func getChatMessagesForUserID(userId:String) -> [StructChat]{
        let objContext = CoreDBManager.sharedDatabase.managedObjectContext
        let fetchRequest = NSFetchRequest<CD_Friends>(entityName: ENTITY_CHAT)
        fetchRequest.returnsObjectsAsFaults = true
        let disentity: NSEntityDescription = NSEntityDescription.entity(forEntityName: ENTITY_CHAT, in: objContext)!
        fetchRequest.entity = disentity
        let predicate1 = NSPredicate(format:"senderid == %@",userId)
        let predicate2 = NSPredicate(format:"receiverid == %@",userId)
        fetchRequest.predicate = NSCompoundPredicate.init(type: .or, subpredicates: [predicate1, predicate2])
        
        do{
            let results = try  CoreDBManager.sharedDatabase.managedObjectContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [CD_Messages]
            if(results.count > 0)
            {
                var arr = [StructChat]()
                for result  in results {
                    var friendObj = StructChat(dictionary: [:])
                    friendObj.kid = result.id ?? ""
                    friendObj.kcreateddate = result.createddate ?? ""
                    friendObj.kdevicetype = result.platform ?? ""
                    friendObj.kchatmessage = result.textmessage ?? ""
                    friendObj.kreceiverid = result.receiverid ?? ""
                    friendObj.ksenderid = result.senderid ?? ""
                    friendObj.kisdeleted = result.isdeleted ?? ""
                    friendObj.kisread = result.isread ?? ""
                    friendObj.kmessagetype = result.messagetype ?? ""
                    friendObj.kmediaurl = result.mediaurl ?? ""
                    friendObj.kchatid = result.chatid ?? ""
                    friendObj.kuserprofile = result.image ?? ""
                    friendObj.kuseronline = result.is_online ?? ""
                    friendObj.kuserlastlogin = result.last_login ?? ""
                    friendObj.kusername = result.username ?? ""
                    friendObj.kuserid = result.user_id ?? ""
                    arr.append(friendObj)
                }
                return arr
            }
        }
        catch
        {
            return []
        }
        return []

    }
    
    /*func getUnreadMessagesCountFor(userID:String) -> Int{
        var unreadCount:Int = 0
        let messages = getChatMessagesForUserID(userId: userID)
        for msg in messages{
            if msg.kreceiverid == userID && msg.kisread == "0"{
                unreadCount += 1
            }
        }
        
        return unreadCount
    }*/
    
    //MARK:- FRIEND LIST
    
    func saveFriendInLocalDB(objFriend:StructChat) -> Bool{
        let objContext = self.managedObjectContext
        let fetchRequest = NSFetchRequest<CD_Friends>(entityName: ENTITY_FRIENDS)
        let disentity: NSEntityDescription = NSEntityDescription.entity(forEntityName: ENTITY_FRIENDS, in: objContext)!
        let predicate = NSPredicate(format:"user_id == %@",objFriend.kuserid)
        fetchRequest.predicate = predicate
        fetchRequest.entity = disentity
        
        do{
            let results = try  managedObjectContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [CD_Friends]
            if(results.count > 0)
            {
                let friendObj = results[0] as CD_Friends
                friendObj.id = objFriend.kid
                friendObj.createddate = objFriend.kcreateddate
                friendObj.platform = objFriend.kdevicetype
                friendObj.textmessage = objFriend.kchatmessage
                friendObj.receiverid = objFriend.kreceiverid
                friendObj.senderid = objFriend.ksenderid
                friendObj.isdeleted = objFriend.kisdeleted
                friendObj.isread = objFriend.kisread
                friendObj.mediaurl = objFriend.kmediaurl
                friendObj.messagetype = objFriend.kmessagetype
                friendObj.chatid = objFriend.kchatid
                friendObj.image = objFriend.kuserprofile
                friendObj.is_online = objFriend.kuseronline
                friendObj.last_login = objFriend.kuserlastlogin
                friendObj.username = objFriend.kusername
                friendObj.user_id = objFriend.kuserid
            }
            else
            {
                
                let  friendObj = (NSEntityDescription.insertNewObject(forEntityName:ENTITY_FRIENDS,into:managedObjectContext) as? CD_Friends)!
                friendObj.id = objFriend.kid
                friendObj.createddate = objFriend.kcreateddate
                friendObj.platform = objFriend.kdevicetype
                friendObj.textmessage = objFriend.kchatmessage
                friendObj.receiverid = objFriend.kreceiverid
                friendObj.senderid = objFriend.ksenderid
                friendObj.isdeleted = objFriend.kisdeleted
                friendObj.isread = objFriend.kisread
                friendObj.mediaurl = objFriend.kmediaurl
                friendObj.messagetype = objFriend.kmessagetype
                friendObj.chatid = objFriend.kchatid
                friendObj.image = objFriend.kuserprofile
                friendObj.is_online = objFriend.kuseronline
                friendObj.last_login = objFriend.kuserlastlogin
                friendObj.username = objFriend.kusername
                friendObj.user_id = objFriend.kuserid
                friendObj.unreadCount = "0"
                
            }
            self.saveContext()
            return true
            
        }
        catch
        {
            return false
        }
    }
    
    func getFriendList() -> NSMutableArray{
        
        let objContext = CoreDBManager.sharedDatabase.managedObjectContext
        let fetchRequest = NSFetchRequest<CD_Friends>(entityName: ENTITY_FRIENDS)
        fetchRequest.returnsObjectsAsFaults = true
        let disentity: NSEntityDescription = NSEntityDescription.entity(forEntityName: ENTITY_FRIENDS, in: objContext)!
        fetchRequest.entity = disentity
        
        do{
            let results = try  CoreDBManager.sharedDatabase.managedObjectContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [CD_Friends]
            if(results.count > 0)
            {
                let arr = NSMutableArray()
                for result  in results {
                    
                    var shouldCheck = false
                    if SupportUserID == UserDefaultManager.getStringFromUserDefaults(key: kAppUserId){
                        //DON'T FILTER OUT
                    }
                    else{
                        //CHECK IF kreceiverid OR ksenderid != SupportUserID
                        shouldCheck = true
                    }
                    
                    var friendObj = StructChat(dictionary: [:])
                    friendObj.kid = result.id ?? ""
                    friendObj.kcreateddate = result.createddate ?? ""
                    friendObj.kdevicetype = result.platform ?? ""
                    friendObj.kchatmessage = result.textmessage ?? ""
                    friendObj.kreceiverid = result.receiverid ?? ""
                    friendObj.ksenderid = result.senderid ?? ""
                    friendObj.kisdeleted = result.isdeleted ?? ""
                    friendObj.kisread = result.isread ?? ""
                    friendObj.kmessagetype = result.messagetype ?? ""
                    friendObj.kmediaurl = result.mediaurl ?? ""
                    friendObj.kchatid = result.chatid ?? ""
                    friendObj.kuserprofile = result.image ?? ""
                    friendObj.kuseronline = result.is_online ?? ""
                    friendObj.kuserlastlogin = result.last_login ?? ""
                    friendObj.kusername = result.username ?? ""
                    friendObj.kuserid = result.user_id ?? ""
                    friendObj.kunreadcount = result.unreadCount ?? "0"
                    
                    if shouldCheck{
                        if friendObj.ksenderid == SupportUserID || friendObj.kreceiverid == SupportUserID{
                            //THIS WAS SUPPORT USER ID
                        }else{
                            arr.add(friendObj)
                        }
                    }else{
                        arr.add(friendObj)
                    }
                    
                }
                return arr
            }
        }
        catch
        {
            return []
        }
        return []
    }
    
    func updateFriend(for ChatMessage:StructChat){
        
        let predi0_1 = NSPredicate(format:"receiverid == %@", ChatMessage.kreceiverid)
        let predi0_2 = NSPredicate(format:"senderid == %@", ChatMessage.ksenderid)
        let predicate1 = NSCompoundPredicate.init(type: .and, subpredicates: [predi0_1, predi0_2])
        
        let predi1_1 = NSPredicate(format:"receiverid == %@", ChatMessage.ksenderid)
        let predi1_2 = NSPredicate(format:"senderid == %@", ChatMessage.kreceiverid)
        let predicate2 = NSCompoundPredicate.init(type: .and, subpredicates: [predi1_1, predi1_2])
        
        let predicate = NSCompoundPredicate.init(type: .or, subpredicates: [predicate1, predicate2])
        
        let fetchRequest = NSBatchUpdateRequest(entityName: ENTITY_FRIENDS)
        fetchRequest.propertiesToUpdate = [
            "chatid" : ChatMessage.kchatid,
            "createddate" : ChatMessage.kcreateddate,
            "isdeleted" : ChatMessage.kisdeleted,
            "isread" : ChatMessage.kisread,
            "mediaurl" : ChatMessage.kmediaurl,
            "messagetype" : ChatMessage.kmessagetype,
            "platform" : ChatMessage.kdevicetype,
            "textmessage" : ChatMessage.kchatmessage,
            //"unreadCount" : ""
        ]
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .updatedObjectsCountResultType
        do{
            let result = try managedObjectContext.execute(fetchRequest) as! NSBatchUpdateResult
            //Will print the number of rows affected/updated
            print(result)
            print(predicate)
            print("Success")
            self.saveContext()
        }catch{
        }
    }
    
    func getUnreadCountForFriend(chatUser:StructChat) -> Int{
        let friends = getFriendList() as! [StructChat]
        for friend in friends{
            if (chatUser.kreceiverid == friend.kreceiverid && chatUser.ksenderid == friend.ksenderid) || (chatUser.kreceiverid == friend.ksenderid && chatUser.ksenderid == friend.kreceiverid) {
                return Int(friend.kunreadcount)!
            }
        }
        return 0
    }
    
    func increaseUnreadCount(for chatUser:StructChat){
        
        let predi0_1 = NSPredicate(format:"receiverid == %@", chatUser.kreceiverid)
        let predi0_2 = NSPredicate(format:"senderid == %@", chatUser.ksenderid)
        let predicate1 = NSCompoundPredicate.init(type: .and, subpredicates: [predi0_1, predi0_2])
        
        let predi1_1 = NSPredicate(format:"receiverid == %@", chatUser.ksenderid)
        let predi1_2 = NSPredicate(format:"senderid == %@", chatUser.kreceiverid)
        let predicate2 = NSCompoundPredicate.init(type: .and, subpredicates: [predi1_1, predi1_2])
        
        let predicate = NSCompoundPredicate.init(type: .or, subpredicates: [predicate1, predicate2])
        
        let fetchRequest = NSBatchUpdateRequest(entityName: ENTITY_FRIENDS)
        
        let unreadCount = getUnreadCountForFriend(chatUser: chatUser)
        
        fetchRequest.propertiesToUpdate = [
            "chatid" : chatUser.kchatid,
            "createddate" : chatUser.kcreateddate,
            "isdeleted" : chatUser.kisdeleted,
            "isread" : chatUser.kisread,
            "mediaurl" : chatUser.kmediaurl,
            "messagetype" : chatUser.kmessagetype,
            "platform" : chatUser.kdevicetype,
            "textmessage" : chatUser.kchatmessage,
            "unreadCount" : "\(unreadCount + 1)" //INCREASE HERE
        ]
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .updatedObjectsCountResultType
        do{
            let result = try managedObjectContext.execute(fetchRequest) as! NSBatchUpdateResult
            //Will print the number of rows affected/updated
            print(result)
            print(predicate)
            print("Success")
            self.saveContext()
        }catch{
        }
    }
    
    func setUnreadCountToZero(for chatUser:StructChat){
        let predi0_1 = NSPredicate(format:"receiverid == %@", chatUser.kreceiverid)
        let predi0_2 = NSPredicate(format:"senderid == %@", chatUser.ksenderid)
        let predicate1 = NSCompoundPredicate.init(type: .and, subpredicates: [predi0_1, predi0_2])
        
        let predi1_1 = NSPredicate(format:"receiverid == %@", chatUser.ksenderid)
        let predi1_2 = NSPredicate(format:"senderid == %@", chatUser.kreceiverid)
        let predicate2 = NSCompoundPredicate.init(type: .and, subpredicates: [predi1_1, predi1_2])
        
        let predicate = NSCompoundPredicate.init(type: .or, subpredicates: [predicate1, predicate2])
        
        let fetchRequest = NSBatchUpdateRequest(entityName: ENTITY_FRIENDS)
        
        fetchRequest.propertiesToUpdate = [
            "unreadCount" : "0"
        ]
        fetchRequest.predicate = predicate
        fetchRequest.resultType = .updatedObjectsCountResultType
        do{
            let result = try managedObjectContext.execute(fetchRequest) as! NSBatchUpdateResult
            //Will print the number of rows affected/updated
            print(result)
            print(predicate)
            print("Success")
            self.saveContext()
        }catch{
        }
    }
    
    //MARK:- CLEAR DB
    
    func deleteAllMessageFromLocalDB()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_CHAT)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.managedObjectContext.execute(deleteRequest)
            try self.managedObjectContext.save()
        } catch {
            print (error)
        }
    }
    
    func deleteAllFriendsFromLocalDB()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_FRIENDS)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.managedObjectContext.execute(deleteRequest)
            try self.managedObjectContext.save()
        } catch {
            print (error)
        }
    }
    
}
*/

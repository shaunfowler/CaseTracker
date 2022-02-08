//
//  NotificationService.swift
//  CaseTrackerNotificationServiceExtension
//
//  Created by Shaun Fowler on 2/7/22.
//

import UserNotifications
import OneSignal

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var receivedRequest: UNNotificationRequest!
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        self.receivedRequest = request
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            // contentHandler(bestAttemptContent)
            OneSignal.didReceiveNotificationExtensionRequest(
                request,
                with: bestAttemptContent,
                withContentHandler: contentHandler)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if
            let contentHandler = contentHandler,
            let bestAttemptContent =  bestAttemptContent {
            OneSignal.serviceExtensionTimeWillExpireRequest(receivedRequest, with: bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
    
}

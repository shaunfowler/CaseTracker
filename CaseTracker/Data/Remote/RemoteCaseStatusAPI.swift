//
//  RemoteCaseStatusAPI.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation
import OSLog
import CocoaLumberjack

actor RemoteCaseStatusAPI: CaseStatusReadable {

    var urlSession: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        return URLSession(configuration: config)
    }()

    func get(forCaseId id: String) async -> Result<CaseStatus, Error> {
        defer { os_signpost(.end, log: OSLog.caseTrackerPoi, name: "RemoteCaseStatusAPI_get") }
        os_signpost(.begin, log: OSLog.caseTrackerPoi, name: "RemoteCaseStatusAPI_get")
        do {
            let urlContainer = CaseStatusURL.get(id)
            let url = urlContainer.url

            DDLogInfo("Requesting URL: \(url.absoluteString).")
            let (data, response) = try await urlSession.data(for: URLRequest(url: url))
            await urlSession.reset()

            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard let statusCode = statusCode, statusCode < 400 else {
                DDLogError("Status code \(statusCode ?? 0) for URL \(url.absoluteString).")
                throw CSError.http(id, statusCode)
            }

            guard let htmlString = String(data: data, encoding: .utf8) else {
                throw CSError.corrupt(id)
            }

            return .success(try CaseStatus(receiptNumber: id, htmlString: htmlString))
        } catch {
            DDLogError("Error requesting case. Error: \(error.localizedDescription).")
            return .failure(error)
        }
    }
}

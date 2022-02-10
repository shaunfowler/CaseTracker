//
//  RemoteCaseStatusAPI.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation
import OSLog

protocol CaseStatusWritable {
    @discardableResult
    func set(caseStatus: CaseStatus) async -> Result<(), Error>
    func remove(receiptNumber: String) async -> Result<(), Error>
}

actor RemoteCaseStatusAPI: CaseStatusReadable {

    var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return URLSession(configuration: config)
    }()

    func get(forCaseId id: String) async -> Result<CaseStatus, Error> {
        do {
            let urlContainer = CaseStatusURL.get(id)
            let url = urlContainer.url

            Logger.api.log("Requesting URL: \(urlContainer.url.absoluteString, privacy: .public).")
            let (data, response) = try await urlSession.data(for: URLRequest(url: url))

            guard let response = (response as? HTTPURLResponse), response.statusCode < 400 else {
                throw CSError.http
            }

            guard let htmlString = String(data: data, encoding: .utf8) else {
                throw CSError.corrupt
            }

            return .success(try CaseStatus(receiptNumber: id, htmlString: htmlString))
        } catch {
            Logger.api.error("Error requesting case. Error: \(error.localizedDescription, privacy: .public).")
            return .failure(error)
        }
    }
}

//
//  RemoteCaseStatusAPI.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation

actor RemoteCaseStatusAPI: CaseStatusReadable {

    var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return URLSession(configuration: config)
    }()

    func get(forCaseId id: String) async -> Result<CaseStatus, Error> {
        do {
            let url = CaseStatusURL.get(id).url
            print("Requesting", url)
            let (data, response) = try await urlSession.data(for: URLRequest(url: url))

            guard let response = (response as? HTTPURLResponse), response.statusCode < 400 else {
                throw CSError.http
            }

            guard let htmlString = String(data: data, encoding: .utf8) else {
                throw CSError.corrupt
            }

            return .success(try CaseStatus(receiptNumber: id, htmlString: htmlString))
        } catch {
            print("remote error", error)
            return .failure(error)
        }
    }
}

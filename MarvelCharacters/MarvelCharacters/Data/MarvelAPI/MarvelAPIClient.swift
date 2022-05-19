//
//  APIClient.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 15/05/2022.
//

import Foundation
import Combine
import CryptoSwift

enum MarvelAPIError: Error {

    case apiError(Error)

    var underlying: Error {
        switch self {
        case .apiError(let error):
            return error
        }
    }
}

/// API Client to communicate with Marvel's service
protocol MarvelAPIClient {

    /// Get a list of characters [See Marvel's API documentation](https://developer.marvel.com/docs#!/public/getCreatorCollection_get_0)
    func getCharacters(nameStartsWith: String?, limit: Int?, offset: Int?) -> AnyPublisher<CharacterDataWrapperResponse, MarvelAPIError>
}

extension MarvelAPIClient {

    var maxPageSize: Int {
        return 100
    }

    static var baseURL: String {
        "https://gateway.marvel.com:443/v1/public/"
    }

    static var authorizationParams: [String: Any] {

        let publicKey = String("ac2dda3238455b6c8323c51ed2077e53".reversed())
        let privateKey = String("100de184000693c64e7e01b92a1018ba09cf607d".reversed())

        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = (timestamp + privateKey + publicKey).md5()
        return ["apikey": publicKey,
                "ts": timestamp,
                "hash": hash]
    }
}

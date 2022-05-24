//
//  MoyaMarvelAPIClient.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 15/05/2022.
//

import Foundation
import Combine
import Moya

enum MarvelTarget {

    case characters(nameStartsWith: String?, limit: Int?, offset: Int?)

}

extension MarvelTarget: TargetType {
    var baseURL: URL {
        guard let url = URL(string: MoyaMarvelAPIClient.baseURL) else {
            fatalError("Failed creating base url")
        }
        return url
    }

    var path: String {
        switch self {
        case .characters: return "characters"
        }
    }

    var method: Moya.Method {
        switch self {
        case .characters: return .get
        }
    }

    var task: Task {

        var params = MoyaMarvelAPIClient.authorizationParams

        switch self {
        case let .characters(nameStartsWith, limit, offset):
            params["offset"] = offset
            params["limit"] = limit
            params["nameStartsWith"] = nameStartsWith
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        nil
    }
}

final class MoyaMarvelAPIClient: MarvelAPIClient {

    private let moyaProvider = MoyaProvider<MarvelTarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])

    func getCharacters(nameStartsWith: String?, limit: Int?, offset: Int?) -> AnyPublisher<CharacterDataWrapperResponse, MarvelAPIError> {
        return moyaProvider.requestPublisher(
            .characters(nameStartsWith: nameStartsWith, limit: limit, offset: offset)
        ).filterSuccessfulStatusCodes()
        .map(CharacterDataWrapperResponse.self)
        .mapError { error in
            MarvelAPIError.apiError(error)
        }.eraseToAnyPublisher()
    }
}

//
//  MockMarvelAPIClient.swift
//  MarvelCharactersTests
//
//  Created by Emiliano Galitiello on 16/05/2022.
//

import Foundation
import Combine

@testable import MarvelCharacters

struct MockMarvelAPIClient: MarvelAPIClient {

    var getCharactersCallback: (_ nameStartsWith: String?, _ limit: Int?, _ offset: Int?) -> AnyPublisher<CharacterDataWrapperResponse, MarvelAPIError>

    func getCharacters(nameStartsWith: String?, limit: Int?, offset: Int?) -> AnyPublisher<CharacterDataWrapperResponse, MarvelAPIError> {
            getCharactersCallback(nameStartsWith, limit, offset)

    }
}

struct MockError: Error {

}

class MockMarvelAPIClientPublisher: Publisher {

    typealias Output = CharacterDataWrapperResponse

    typealias Failure = MarvelAPIError

    func receive<S>(subscriber: S) where S: Subscriber, MarvelAPIError == S.Failure, CharacterDataWrapperResponse == S.Input {
        subscriber.receive(completion: Subscribers.Completion.failure(MarvelAPIError.apiError(MockError())))
    }

}

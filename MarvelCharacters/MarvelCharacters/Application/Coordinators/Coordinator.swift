//
//  Coordinator.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 11/05/2022.
//

import UIKit

protocol Coordinator: AnyObject {

    var environment: Environment { get }

    var navigationController: UINavigationController? { get }

    func start()
}

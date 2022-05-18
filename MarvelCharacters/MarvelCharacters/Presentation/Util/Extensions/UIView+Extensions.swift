//
//  UIView+Extensions.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 17/05/2022.
//

import UIKit
import Anchorage

extension UIView {

    static func spacer(height: CGFloat) -> UIView {
        let stackView =  UIStackView()
        stackView.heightAnchor == height
        stackView.isUserInteractionEnabled = false
        return stackView
    }

    static func hairline(color: UIColor? = UIColor.systemGray6, axis: NSLayoutConstraint.Axis = .horizontal) -> UIView {
        let thickness = max(2, (1 / UIScreen.main.scale))
        let view = UIView()
        view.backgroundColor = color
        defer {
            UIView.performWithoutAnimation {
                switch axis {
                case .horizontal:
                    view.frame.size.height = thickness
                    view.heightAnchor == thickness
                case .vertical:
                    view.frame.size.width = thickness
                    view.widthAnchor == thickness
                @unknown default:
                    fatalError("Unknown axis \(axis)")
                }
                view.isUserInteractionEnabled = false
            }
        }
        return view
    }

    static func flexibleSpace() -> UIView {
        let stackView = UIStackView()
        stackView.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        stackView.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)
        stackView.sizeAnchors == UIView.layoutFittingExpandedSize ~ 1
        stackView.isUserInteractionEnabled = false
        return stackView
    }
}

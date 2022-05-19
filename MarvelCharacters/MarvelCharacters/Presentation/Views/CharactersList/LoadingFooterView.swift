//
//  LoadingFooterView.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 13/05/2022.
//

import UIKit
import Anchorage

final class LoadingFooterView: UICollectionReusableView {

    static let elementKind = "footer-element-kind"

    weak var activityIndicatorView: UIActivityIndicatorView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let activityIndicatorView = activityIndicatorView else {
            return
        }
        if !subviews.contains(activityIndicatorView) {
            addSubview(activityIndicatorView)
        }
        activityIndicatorView.centerAnchors == centerAnchors
        if traitCollection.horizontalSizeClass == .regular {
            activityIndicatorView.style = .large
            activityIndicatorView.heightAnchor == 200
        } else {
            activityIndicatorView.style = .medium
            activityIndicatorView.heightAnchor == 44
        }
    }
}

//
//  LoadingFooterView.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 13/05/2022.
//

import UIKit
import Anchorage

final class LoadingFooterView: UICollectionReusableView {

    let activityIndicatorView = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityIndicatorView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.centerAnchors == centerAnchors
        activityIndicatorView.heightAnchor == 44

    }
}

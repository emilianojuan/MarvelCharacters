//
//  TotalShowingHeaderView.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 18/05/2022.
//

import UIKit
import Anchorage

final class TotalShowingHeaderView: UICollectionReusableView {

    static let elementKind = "header-element-kind"

    weak var showingTotalLabel: UILabel?

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .systemBackground
        guard let showingTotalLabel = showingTotalLabel else {
            return
        }
        if !subviews.contains(showingTotalLabel) {
            addSubview(showingTotalLabel)
        }
        showingTotalLabel.textColor = .secondaryLabel
        showingTotalLabel.edgeAnchors == layoutMarginsGuide.edgeAnchors
    }
}

//
//  ScrollingStrackView.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 17/05/2022.
//

import UIKit
import Anchorage

final class ScrollingStackView: UIScrollView {

    let content: UIStackView

    var spacing: CGFloat? {
        didSet {
            content.spacing = spacing ?? 0
        }
    }

    init(axis: NSLayoutConstraint.Axis, arrangedSubviews: [UIView] = []) {
        content = UIStackView(axis: axis, arrangedSubviews: arrangedSubviews)

        super.init(frame: .zero)

        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false

        let contentWrapper = UIView()

        addSubview(contentWrapper)
        contentWrapper.topAnchor == topAnchor
        contentWrapper.leadingAnchor == leadingAnchor

        switch axis {
        case .horizontal:
            alwaysBounceHorizontal = true
            contentWrapper.heightAnchor == heightAnchor
            contentWrapper.bottomAnchor == bottomAnchor
            contentWrapper.trailingAnchor <= trailingAnchor

        case .vertical:
            alwaysBounceVertical = true
            contentWrapper.widthAnchor == widthAnchor
            contentWrapper.trailingAnchor == trailingAnchor
            contentWrapper.bottomAnchor <= bottomAnchor
        @unknown default:
            fatalError("Unknown axis \(axis)")
        }

        contentWrapper.addSubview(content)
        content.edgeAnchors == contentWrapper.edgeAnchors
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func insertArrangedSubview(_ view: UIView, at stackIndex: Int) {
        content.insertArrangedSubview(view, at: stackIndex)
    }

    func doesNeedScroll() -> Bool {
        layoutIfNeeded()
        if content.axis == .vertical {
            return content.frame.size.height > frame.size.height
        } else {
            return content.frame.size.width > frame.size.width
        }
    }

}

//
//  CharacterDetailView.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 17/05/2022.
//

import UIKit
import Anchorage

final class CharacterDetailView: UIView {

    enum Constants {
        static let contentViewBottomMargin: CGFloat = 24.0
        static let closeButtonSize: CGSize = CGSize(width: 97, height: 44)
        static let contentStackViewSpacing: CGFloat = 8.0
        static let contentStackViewContainerEdgeInsets = EdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        static let linkButtonCornerRadius: CGFloat = 8.0
        static let linkButtonHeight: CGFloat = 44.0
        static let linksButtonsStackViewSpacing: CGFloat = 16
        static let compactCloseButtonFontSize: CGFloat = 18.0
        static let regularCloseButtonFontSize: CGFloat = 24.0
    }

    private let containerStackView: UIStackView

    let closeButton = UIButton()
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let descriptionTextView = UITextView()
    let featuresInComicsLabel = UILabel()
    let featuresInSeriesLabel = UILabel()
    let featuresInStoriesLabel = UILabel()
    let featuresInEventsLabel = UILabel()
    let detailButton = UIButton()
    let wikiButton = UIButton()
    let comicButton = UIButton()

    init() {
        containerStackView = UIStackView()
        super.init(frame: .zero)
        setUpSubview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpSubview() {
        backgroundColor = UIColor.systemBackground

        setUpCloseButton()
        setUpNameAndDescriptionViews()

        containerStackView.distribution = .fillEqually
        containerStackView.addArrangedSubview(setUpImageView())
        containerStackView.addArrangedSubview(setUpContentView())
        let contentView = UIStackView(axis: .vertical,
                                      arrangedSubviews: [UIStackView(axis: .horizontal,
                                                                     arrangedSubviews: [.flexibleSpace(),
                                                                                        closeButton]),
                                                         containerStackView,
                                                         .spacer(height: Constants.contentViewBottomMargin)])
        addSubview(contentView)
        contentView.edgeAnchors == edgeAnchors
    }

    private func setUpNameAndDescriptionViews() {
        nameLabel.font = .preferredFont(forTextStyle: .title1)

        descriptionTextView.font = .preferredFont(forTextStyle: .body)
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = false
    }

    private func setUpCloseButton() {
        closeButton.setTitle(NSLocalizedString("Character.Detail.Close", comment: "Close button title"),
                             for: .normal)
        closeButton.setTitleColor(UIColor.label, for: .normal)
        closeButton.setTitleColor(UIColor.tertiaryLabel, for: .highlighted)

        closeButton.sizeAnchors == Constants.closeButtonSize
    }

    private func setUpImageView() -> UIView {
        imageView.contentMode = .scaleAspectFill
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true

        let imageViewContainer = UIView()
        imageViewContainer.addSubview(imageView)
        imageViewContainer.clipsToBounds = true
        imageView.edgeAnchors == imageViewContainer.edgeAnchors
        return imageViewContainer
    }

    private func setUpContentView() -> UIView {
        let appearsInTitleLabel = UILabel()
        appearsInTitleLabel.font = .preferredFont(forTextStyle: .title3)
        appearsInTitleLabel.text = NSLocalizedString("Character.Detail.AppearsIn", comment: "Features In")

        let contentStackView = UIStackView(axis: .vertical,
                                           arrangedSubviews: [nameLabel,
                                                              .hairline(axis: .horizontal),
                                                              descriptionTextView,
                                                              .hairline(axis: .horizontal),
                                                              appearsInTitleLabel,
                                                              setUpFeaturesInView(),
                                                              .hairline(axis: .horizontal),
                                                              setUpLinksView()])
        contentStackView.spacing = Constants.contentStackViewSpacing
        let contentStackViewContainer = UIView()
        contentStackViewContainer.addSubview(contentStackView)
        contentStackViewContainer.layoutMargins = Constants.contentStackViewContainerEdgeInsets
        contentStackView.edgeAnchors == contentStackViewContainer.layoutMarginsGuide.edgeAnchors
        return contentStackViewContainer
    }

    private func setUpFeaturesInView() -> UIStackView {
        let appearsInValueTitleLabel: (_ localizedStringKey: String) -> UILabel = { localizedStringKey in
            let titleLabel = UILabel()
            titleLabel.font = .preferredFont(forTextStyle: .callout)
            titleLabel.text = NSLocalizedString(localizedStringKey, comment: "")
            return titleLabel
        }

        [featuresInComicsLabel, featuresInSeriesLabel, featuresInStoriesLabel, featuresInEventsLabel].forEach { label in
            label.font = .preferredFont(forTextStyle: .body)
        }

        let appearsInComicsStackView = UIStackView(axis: .vertical,
                                                   alignment: .center,
                                                   arrangedSubviews: [featuresInComicsLabel,
                                                                      appearsInValueTitleLabel("Character.Detail.AppearsIn.Comics")])

        let appearsInSeriesStackView = UIStackView(axis: .vertical,
                                                   alignment: .center,
                                                   arrangedSubviews: [featuresInSeriesLabel,
                                                                      appearsInValueTitleLabel("Character.Detail.AppearsIn.Series")])

        let appearsInStoriesStackView = UIStackView(axis: .vertical,
                                                    alignment: .center,
                                                    arrangedSubviews: [featuresInStoriesLabel,
                                                                       appearsInValueTitleLabel("Character.Detail.AppearsIn.Stories")])

        let appearsInEventsStackView = UIStackView(axis: .vertical,
                                                   alignment: .center,
                                                   arrangedSubviews: [featuresInEventsLabel,
                                                                      appearsInValueTitleLabel("Character.Detail.AppearsIn.Events")])

        let featuresInStackView = UIStackView(axis: .horizontal, alignment: .center, arrangedSubviews: [appearsInComicsStackView,
                                                                                                        appearsInSeriesStackView,
                                                                                                        appearsInStoriesStackView,
                                                                                                        appearsInEventsStackView])
        featuresInStackView.distribution = .fillEqually
        return featuresInStackView
    }

    private func setUpLinksView() -> UIStackView {
        detailButton.setTitle(NSLocalizedString("Character.Detail.GoToDetail", comment: ""), for: .normal)
        wikiButton.setTitle(NSLocalizedString("Character.Detail.GoToWiki", comment: ""), for: .normal)
        comicButton.setTitle(NSLocalizedString("Character.Detail.GoToComics", comment: ""), for: .normal)

        [detailButton, wikiButton, comicButton].forEach { button in
            button.setBackgroundImage(UIImage.imageWithColor(tintColor: UIColor(named: "MarvelRed") ?? .systemRed), for: .normal)
            button.setBackgroundImage(UIImage.imageWithColor(tintColor: .secondarySystemFill), for: .disabled)
            button.layer.cornerRadius = Constants.linkButtonCornerRadius
            button.clipsToBounds = true
            button.tintColor = .secondaryLabel
            button.heightAnchor == Constants.linkButtonHeight
        }

        let linksButtonsStackView = UIStackView(axis: .horizontal, arrangedSubviews: [detailButton, wikiButton, comicButton])
        linksButtonsStackView.distribution = .fillEqually
        linksButtonsStackView.spacing = Constants.linksButtonsStackViewSpacing
        return linksButtonsStackView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerStackView.axis = axis(for: traitCollection.verticalSizeClass)
        let closeButtonFontSize = (traitCollection.horizontalSizeClass == .compact ||
                                   traitCollection.verticalSizeClass == .compact) ? Constants.compactCloseButtonFontSize :
                                                                                    Constants.regularCloseButtonFontSize
        closeButton.titleLabel?.font = .systemFont(ofSize: closeButtonFontSize, weight: .regular)

    }

    private func axis(for sizeClass: UIUserInterfaceSizeClass) -> NSLayoutConstraint.Axis {
        return sizeClass == UIUserInterfaceSizeClass.regular ? .vertical : .horizontal
    }
}

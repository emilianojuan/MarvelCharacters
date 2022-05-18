//
//  CharacterDetailViewController.swift
//  MarvelCharacters
//
//  Created by Emiliano Galitiello on 17/05/2022.
//

import UIKit
import Anchorage
import Kingfisher

class CharacterDetailViewController: UIViewController {

    let characterViewModel: CharacterDetailViewModel

    init(characterViewModel: CharacterDetailViewModel) {
        self.characterViewModel = characterViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let characterDetailView = CharacterDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(characterDetailView)
        characterDetailView.edgeAnchors == view.edgeAnchors
        characterDetailView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        if let thumbnailURL = characterViewModel.thumbnailURL {
            characterDetailView.imageView.kf.setImage(with: thumbnailURL)
        }
        characterDetailView.nameLabel.text = characterViewModel.name

        characterDetailView.descriptionTextView.text = characterViewModel.description
        characterDetailView.featuresInComicsLabel.text = characterViewModel.comicsCount
        characterDetailView.featuresInSeriesLabel.text = characterViewModel.seriesCount
        characterDetailView.featuresInStoriesLabel.text = characterViewModel.storiesCount
        characterDetailView.featuresInEventsLabel.text = characterViewModel.eventsCount

        if characterViewModel.showDetailLink {
            characterDetailView.detailButton.isEnabled = true
            characterDetailView.detailButton.addTarget(self, action: #selector(goToDetail), for: .touchUpInside)
        } else {
            characterDetailView.detailButton.isEnabled = false
        }

        if characterViewModel.showWikiLink {
            characterDetailView.wikiButton.isEnabled = true
            characterDetailView.detailButton.addTarget(self, action: #selector(goToWiki), for: .touchUpInside)
        } else {
            characterDetailView.wikiButton.isEnabled = false
        }

        if characterViewModel.showComicLink {
            characterDetailView.comicButton.isEnabled = true
            characterDetailView.detailButton.addTarget(self, action: #selector(goToComic), for: .touchUpInside)
        } else {
            characterDetailView.comicButton.isEnabled = false
        }
    }

    @objc func close(_ sender: Any) {
        dismiss(animated: true)
    }

    @objc func goToDetail(_ sender: Any) {
        characterViewModel.goToDetails()
    }

    @objc func goToWiki(_ sender: Any) {
        characterViewModel.goToWiki()
    }

    @objc func goToComic(_ sender: Any) {
        characterViewModel.goToComics()
    }

}

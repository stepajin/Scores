//
//  CompetitionViewController.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import UIKit

final class CompetitionViewController: UITabBarController {

    var viewModel: CompetitionViewModel!

    private var favoriteImage: UIImage {
        viewModel?.isFavorite == true
            ? UIImage(systemName: "star.fill")!
            : UIImage(systemName: "star")!
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = viewModel.competition.name
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(favoriteAction))
    }
    
    @objc private func favoriteAction() {
        viewModel.toggleFavorite()
        navigationItem.rightBarButtonItem?.image = favoriteImage
    }
}

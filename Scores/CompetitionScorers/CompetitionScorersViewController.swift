//
//  CompetitionScorersViewController.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import Foundation
import UIKit

final class CompetitionScorersViewController: UIViewController {
    
    var viewModel: CompetitionScorersViewModel!
    
    private let standingsView = CompetitionStandingsView()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        bindViewModel()
        viewModel.fetchScorers()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        standingsView.translatesAutoresizingMaskIntoConstraints = false
        standingsView.emblemImageView.setImage(url: viewModel.competition.emblemURL)
        view.addSubview(standingsView)
    }
    
    private func setupLayout() {
        view.addConstraints([
            standingsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            standingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            standingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            standingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Scorers"
        tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: "g.circle"),
            selectedImage: UIImage(systemName: "g.circle.fill")
        )
    }
    
    private func bindViewModel() {
        viewModel.onScorersUpdated = { [weak self] scorers in
            self?.displayScorers(scorers)
        }
        standingsView.onRowSelected = { [weak self] id in
            self?.viewModel.selectPlayer(id)
        }
    }
    
    private func displayScorers(_ scorers: [Scorer]) {
        let items = scorers.enumerated().map { position, scorer in
            CompetitionStandingsView.Item(
                id: scorer.player.id,
                position: position + 1,
                name: scorer.player.name ?? "",
                imageURL: scorer.team?.crestURL,
                points: scorer.goals ?? 0
            )
        }
        standingsView.displayStandings(items)
    }
}

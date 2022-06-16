//
//  AppRouter.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import UIKit
import SwiftUI

final class AppRouter {
    private let window: UIWindow
    
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        navigationController = window.rootViewController as! UINavigationController
    }
    
    func start() {
        let viewModel = CompetitionsListViewModel()
        viewModel.delegate = self
        let viewController = navigationController.topViewController as! CompetitionsListViewController
        viewController.viewModel = viewModel
    }
}

extension AppRouter: CompetitionsListViewModelDelegate {
    func routeToCompetition(_ competition: Competition) {
        let competitionViewController = CompetitionViewController()
        competitionViewController.viewModel = CompetitionViewModel(competition: competition)
        
        let standingsViewController = CompetitionStandingsViewController()
        let standingsViewModel = CompetitionStandingsViewModel(competition: competition)
        standingsViewModel.delegate = self
        standingsViewController.viewModel = standingsViewModel
        
        let fixturesViewController = CompetitionFixturesViewController()

        let scorersViewModel = CompetitionScorersViewModel(competition: competition)
        scorersViewModel.delegate = self
        let scorersViewController = CompetitionScorersViewController()
        scorersViewController.viewModel = scorersViewModel

        competitionViewController.viewControllers = [
            standingsViewController,
            fixturesViewController,
            scorersViewController
        ]
        
        navigationController.pushViewController(competitionViewController, animated: true)
    }
}

extension AppRouter: CompetitionStandingsViewModelDelegate {
    func routeToTeam(_ team: Team) {
        let teamViewController = TeamViewController()
        teamViewController.team = team
        
        let squadViewController = TeamSquadViewController()
        let squadViewModel = TeamSquadViewModel(team: team)
        squadViewModel.delegate = self
        squadViewController.viewModel = squadViewModel
        
        let fixturesViewController = TeamFixturesViewController()
        
        teamViewController.viewControllers = [squadViewController, fixturesViewController]
        navigationController.pushViewController(teamViewController, animated: true)
    }
}

extension AppRouter: TeamSquadViewModelDelegate {
    private func routeToPlayer(_ player: Player, maybeTeam: Team?) {
        let viewModel = PlayerViewModel(player: player, team: maybeTeam)
        let view = PlayerView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: view)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func routeToPlayer(_ player: Player, team: Team) {
        routeToPlayer(player, maybeTeam: team)
    }
}

extension AppRouter: CompetitionScorersViewModelDelegate {
    func routeToScorer(_ scorer: Scorer) {
        routeToPlayer(scorer.player, maybeTeam: scorer.team)
    }
}

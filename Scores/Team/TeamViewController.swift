//
//  TeamViewController.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import UIKit

final class TeamViewController: UITabBarController {
    
    var team: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = team?.name
    }
}

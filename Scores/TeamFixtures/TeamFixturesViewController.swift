//
//  TeamFixturesViewController.swift
//  Scores
//
//  Created by Jindrich Stepanek on 14.06.2022.
//

import UIKit

final class TeamFixturesViewController: UIViewController {
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupNavigationBar() {
        title = "Fixtures"
        tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: "sportscourt"),
            selectedImage: UIImage(systemName: "sportscourt.fill")
        )
    }

}

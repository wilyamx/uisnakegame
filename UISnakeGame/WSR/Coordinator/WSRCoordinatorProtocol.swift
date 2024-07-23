//
//  WSRCoordinatorProtocol.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit

protocol WSRCoordinatorProtocol {
    var childCoordinators: [WSRCoordinatorProtocol] { get set }
    var navigationController: UINavigationController? { get set }
    
    func start()
}

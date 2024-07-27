//
//  SNKSettingsViewController.swift
//  UISnakeGame
//
//  Created by William Rena on 7/23/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import UIKit
import Eureka

class SNKSettingsViewController: FormViewController {
    weak var coordinator: SNKHomeCoordinator?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        navigationController?.isNavigationBarHidden = false
        
        form +++ Section("Gameplay")
        <<< TextRow() { row in
            row.title = "Active User"
            row.placeholder = "Enter name to use"
        }
        <<< StepperRow() {
            $0.title = "Default Game Level"
            $0.value = 1
        }.cellSetup({ cell, row in
            cell.stepper.minimumValue = 1
            cell.stepper.maximumValue = 10
        }).cellUpdate({ cell, row in
            if let value = row.value {
                row.cell.valueLabel.text = "\(Int(value))"
            }
        })
        <<< SwitchRow() { row in
            row.title = "Portrait Orientation"
            row.value = SNKConstants.shared.isPortraitOrientation
        }.onChange({ row in
            guard let value = row.value else { return }
            SNKConstants.shared.isPortraitOrientation = value
        })
        <<< SwitchRow() { row in
            row.title = "Show Grid"
            row.value = SNKConstants.shared.displayGrid
        }.onChange({ row in
            guard let value = row.value else { return }
            SNKConstants.shared.displayGrid = value
        })
        +++ Section("Sounds")
        <<< SwitchRow() { row in
            row.title = "Background"
            row.value = SNKConstants.shared.backgroundSound
        }.onChange({ row in
            guard let value = row.value else { return }
            SNKConstants.shared.backgroundSound = value
        })
        <<< SwitchRow() { row in
            row.title = "Character"
            row.value = SNKConstants.shared.characterSound
        }.onChange({ row in
            guard let value = row.value else { return }
            SNKConstants.shared.characterSound = value
        })
        <<< SwitchRow() { row in
            row.title = "Alerts"
            row.value = SNKConstants.shared.alertSound
        }.onChange({ row in
            guard let value = row.value else { return }
            SNKConstants.shared.alertSound = value
        })

        wsrLogger.info(message: "viewDidLoad")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

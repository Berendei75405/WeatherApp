//
//  Extension WeatherController.swift
//  Weather Now
//
//  Created by user on 29.04.2023.
//

import UIKit

extension WeatherViewController {
    
    //MARK: - createTownButton
    func createTownButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 40, y: 0, width: 200, height: 30))
        var config = UIButton.Configuration.plain()
        
        config.titleAlignment = .center
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming  in
            var outcoming = incoming
            outcoming.font = UIFont.boldSystemFont(ofSize: 16)
            outcoming.foregroundColor = .white
            
            return outcoming
        }
        
        button.configuration = config
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        
        return button
    }
    
    //MARK: - createDateLabel
    func createDateLabel() -> UILabel {
        let lab = UILabel(frame: CGRect(x: 40, y: 45, width: 200, height: 14))
        lab.textColor = .white
        lab.textAlignment = .center
        lab.font = .systemFont(ofSize: 13)
        
        return lab
    }
    
    //MARK: - createReloadLabel
    func createReloadLabel() -> UILabel {
        let lab = UILabel(frame: CGRect(x: 40, y: -60, width: 200, height: 30))
        lab.textColor = .white
        lab.textAlignment = .center
        lab.font = .systemFont(ofSize: 13)
        lab.text = "Обновление!"
        
        return lab
    }
    
    //MARK: - create titleView
    func createTitleView() {
        self.navigationItem.titleView = customView(townName: "",
                   currentDate: viewModel.currentDateForTitle(),
                   dateIsHiden: true)
    }
    
}


//
//  TabBarCustom.swift
//  Weather Now
//
//  Created by user on 24.05.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    weak var view1: WeatherViewController!
    
    //MARK: - mainView
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        return view
    }()
    
    //MARK: - firstView
    private let firstView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - secondView
    private let secondView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - firstImage
    private let firstImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "weather")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    //MARK: - secondImage
    private let secondImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "lypa")
        
        return imageView
    }()
    
    //MARK: - firstLabel
    private let firstLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Прогноз"
        label.textColor = .white
        
        return label
    }()
    
    //MARK: - secondLabel
    private let secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Места"
        label.textColor = .white
        
        return label
    }()
    
    //MARK: - firstButton
    private var firstButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    //MARK: - secondButton
    private var secondButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    
        constraints()
        
    }
    //MARK: - constraints
    private func constraints() {
        self.tabBar.addSubview(mainView)
        
        mainView.frame = self.tabBar.frame
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.tabBar.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.tabBar.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.tabBar.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.tabBar.bottomAnchor)
        ])
        
        //MARK: - firstView
        mainView.addSubview(firstView)
        
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: mainView.topAnchor),
            firstView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            firstView.trailingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: mainView.frame.width/2),
            firstView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        //MARK: - secondView
        mainView.addSubview(secondView)
        
        NSLayoutConstraint.activate([
            secondView.topAnchor.constraint(equalTo: mainView.topAnchor),
            secondView.leadingAnchor.constraint(equalTo: firstView.trailingAnchor),
            secondView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            secondView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        //MARK: - firstImage
        firstView.addSubview(firstImage)
        
        NSLayoutConstraint.activate([
            firstImage.topAnchor.constraint(equalTo: firstView.topAnchor, constant: 3),
            firstImage.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: mainView.frame.width/8),
            firstImage.heightAnchor.constraint(equalTo: firstView.heightAnchor, multiplier: 0.5),
            firstImage.widthAnchor.constraint(equalTo: firstView.widthAnchor, multiplier: 0.5)
        ])
        
        //MARK: - firstLabel
        firstView.addSubview(firstLabel)
        
        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalTo: firstImage.bottomAnchor),
            firstLabel.leadingAnchor.constraint(equalTo: firstImage.leadingAnchor, constant: 15),
            firstLabel.trailingAnchor.constraint(equalTo: firstLabel.trailingAnchor),
            firstLabel.bottomAnchor.constraint(equalTo: firstLabel.bottomAnchor)
        ])
        
        //MARK: - firstButton
        view.addSubview(firstButton)
        firstButton.addTarget(self, action: #selector(firstButtonTap(sender:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            firstButton.topAnchor.constraint(equalTo: firstView.topAnchor),
            firstButton.leadingAnchor.constraint(equalTo: firstView.leadingAnchor),
            firstButton.trailingAnchor.constraint(equalTo: firstView.trailingAnchor),
            firstButton.bottomAnchor.constraint(equalTo: firstView.bottomAnchor)
        ])
        
        //MARK: - secondImage
        secondView.addSubview(secondImage)
        
        NSLayoutConstraint.activate([
            secondImage.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 3),
            secondImage.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: mainView.frame.width/7.5),
            secondImage.heightAnchor.constraint(equalTo: secondView.heightAnchor, multiplier: 0.5),
            secondImage.widthAnchor.constraint(equalTo: secondView.widthAnchor, multiplier: 0.5)
        ])
        
        //MARK: - secondLabel
        secondView.addSubview(secondLabel)
        
        NSLayoutConstraint.activate([
            secondLabel.topAnchor.constraint(equalTo: secondImage.bottomAnchor),
            secondLabel.leadingAnchor.constraint(equalTo: secondImage.leadingAnchor, constant: 23),
            secondLabel.trailingAnchor.constraint(equalTo: secondLabel.trailingAnchor),
            secondLabel.bottomAnchor.constraint(equalTo: secondLabel.bottomAnchor)
        ])
        
        //MARK: - secondButton
        view.addSubview(secondButton)
        secondButton.addTarget(self, action: #selector(secondButtonTap(sender:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            secondButton.topAnchor.constraint(equalTo: secondView.topAnchor),
            secondButton.leadingAnchor.constraint(equalTo: secondView.leadingAnchor),
            secondButton.trailingAnchor.constraint(equalTo: secondView.trailingAnchor),
            secondButton.bottomAnchor.constraint(equalTo: secondView.bottomAnchor)
        ])
        
    }
    
    @objc func firstButtonTap(sender: UIButton) {
        view1.viewModel.router.popToRoot()
    }
    
    @objc private func secondButtonTap(sender: UIButton) {
        view1.viewModel.router.showDetail(city: view1.viewModel.townName)
    }
    
    
}

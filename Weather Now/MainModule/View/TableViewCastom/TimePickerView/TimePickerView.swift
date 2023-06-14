//
//  TimePickerView.swift
//  Weather Now
//
//  Created by user on 09.05.2023.
//

import UIKit
import Combine

protocol TimePickerViewDataSource {
    func timePickerCount(_ timePicker: TimePickerView) -> Int
}

final class TimePickerView: UIControl {
    
    public var dataSource: TimePickerViewDataSource? {
        didSet {
            setupView()
        }
    }
    
    //property
    var images: [UIImageView] = []
    var tempLabels: [UILabel] = []
    var timeLabels: [UILabel] = []
    private var views: [UIView] = []
    private var stackView: UIStackView!
    var indexDayPicker = 0
    
    //сообщит если нажмут на кнопку и отдаст индекс
    var tapOnButton = PassthroughSubject<Int, Never>()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    //MARK: - setupConstraints
    func setupView() {
        let count = dataSource?.timePickerCount(self)
        guard let countNotOptional = count else {return}
        
        for item in 0..<countNotOptional {
            //MARK: - view
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            //MARK: - image
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
            image.image = UIImage(named: "skc_d")
            
            view.addSubview(image)
            NSLayoutConstraint.activate([
                image.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
                image.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
            
            //MARK: - tempLabel
            let tempLabel = UILabel()
            tempLabel.font = .boldSystemFont(ofSize: 18)
            tempLabel.textAlignment = .center
            tempLabel.text = "10°"
            tempLabel.textColor = .white
            tempLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(tempLabel)
            
            NSLayoutConstraint.activate([
                tempLabel.topAnchor.constraint(equalTo: image.bottomAnchor),
                tempLabel.heightAnchor.constraint(equalTo: tempLabel.heightAnchor),
                tempLabel.widthAnchor.constraint(equalTo: image.widthAnchor)
            ])
            
            //MARK: - timeLabel
            let timeLabel = UILabel()
            timeLabel.font = .boldSystemFont(ofSize: 18)
            timeLabel.textAlignment = .center
            timeLabel.textColor = .white
            timeLabel.text = "12:00"
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(timeLabel)
            
            NSLayoutConstraint.activate([
                timeLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
                timeLabel.heightAnchor.constraint(equalTo: image.heightAnchor, multiplier: 1, constant: -20),
                timeLabel.widthAnchor.constraint(equalTo: image.widthAnchor)
            ])
            
            //MARK: - button
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
            button.tag = item
            
            view.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalTo: view.heightAnchor),
                button.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
            
            images.append(image)
            tempLabels.append(tempLabel)
            timeLabels.append(timeLabel)
            views.append(view)
            
        }
        //MARK: - stackView
        stackView = UIStackView(arrangedSubviews: self.views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        stackView.spacing = 3
        //ось на которой расположены элементы
        stackView.axis = .horizontal
        stackView.alignment = .fill
        //Распределение упорядоченных представлений вдоль оси представления стека.
        stackView.distribution = .fillEqually
        
        self.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.2196078431, blue: 0.3411764706, alpha: 1)
        self.alpha = 0.7
    }
    
    @objc func tap(sender: UIButton) {
        self.tapOnButton.send(sender.tag)
    }
    
}


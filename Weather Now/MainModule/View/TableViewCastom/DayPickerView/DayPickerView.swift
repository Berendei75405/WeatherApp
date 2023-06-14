//
//  TimePickerView.swift
//  Weather Now
//
//  Created by user on 09.05.2023.
//

import UIKit
import Combine

protocol DayPickerViewDataSource {
    
    func dayPickerCount(_ dayPicker: DayPickerView) -> Int
  
    
}

final class DayPickerView: UIControl {
    
    public var dataSource: DayPickerViewDataSource? {
        didSet {
            setupView()
        }
    }
    
    //property
    var imageViewArray: [UIImageView] = []
    var dayOfWeekLabelArray: [UILabel] = []
    var dateLabelArray: [UILabel] = []
    var tempMinLabelArray: [UILabel] = []
    var tempMaxLabelArray: [UILabel] = []
    
    private var selectLabelArray: [UILabel] = []
    private var views: [UIView] = []
    private var stackView: UIStackView!
    
    //сообщит если нажмут на кнопку и отдаст индекс
    var tapOnButton = PassthroughSubject<Int, Never>()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    //MARK: - setupConstraints
    func setupView() {
        let count = dataSource?.dayPickerCount(self)
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
                image.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9),
                image.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)
            ])
            
            //MARK: - dayOfWeekLabel
            let dayOfWeekLabel = UILabel()
            dayOfWeekLabel.translatesAutoresizingMaskIntoConstraints = false
            dayOfWeekLabel.textColor = .white
            dayOfWeekLabel.font = .boldSystemFont(ofSize: 14)
            if item == 0 {
                dayOfWeekLabel.text = "Сегодня"
            } else {
                dayOfWeekLabel.text = "Пт"
            }
            
            view.addSubview(dayOfWeekLabel)
            NSLayoutConstraint.activate([
                dayOfWeekLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 2),
                dayOfWeekLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
                dayOfWeekLabel.widthAnchor.constraint(equalTo: dayOfWeekLabel.widthAnchor)
            ])
            
            //MARK: - dateLabel
            let dateLabel = UILabel()
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.textColor = .white
            dateLabel.font = .boldSystemFont(ofSize: 14)
            if item != 0 {
                dateLabel.text = "7 апр."
            }
            
            view.addSubview(dateLabel)
            NSLayoutConstraint.activate([
                dateLabel.leadingAnchor.constraint(equalTo: dayOfWeekLabel.trailingAnchor, constant: 2),
                dateLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
                dateLabel.widthAnchor.constraint(equalTo: dateLabel.widthAnchor)
            ])
            
            //MARK: - tempMaxLabel
            let tempMaxLabel = UILabel()
            tempMaxLabel.translatesAutoresizingMaskIntoConstraints = false
            tempMaxLabel.font = .boldSystemFont(ofSize: 16)
            tempMaxLabel.textColor = .white
            tempMaxLabel.text = "12°"
            
            view.addSubview(tempMaxLabel)
            NSLayoutConstraint.activate([
                tempMaxLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: -6),
                tempMaxLabel.leadingAnchor.constraint(equalTo: dayOfWeekLabel.leadingAnchor, constant: 2),
                tempMaxLabel.heightAnchor.constraint(equalTo: tempMaxLabel.heightAnchor),
                tempMaxLabel.widthAnchor.constraint(equalTo: tempMaxLabel.widthAnchor)
            ])
            
            //MARK: - tempMinLabel
            let tempMinLabel = UILabel()
            tempMinLabel.translatesAutoresizingMaskIntoConstraints = false
            tempMinLabel.font = .boldSystemFont(ofSize: 16)
            tempMinLabel.textColor = .white
            tempMinLabel.text = "-12'"
            
            view.addSubview(tempMinLabel)
            NSLayoutConstraint.activate([
                tempMinLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: -6),
                tempMinLabel.leadingAnchor.constraint(equalTo: tempMaxLabel.trailingAnchor, constant: 10),
                tempMinLabel.heightAnchor.constraint(equalTo: tempMinLabel.heightAnchor),
                tempMinLabel.widthAnchor.constraint(equalTo: tempMinLabel.widthAnchor)
            ])
            
            //MARK: - selectLabel
            let selectLabel = UILabel()
            selectLabel.backgroundColor = .white
            selectLabel.alpha = 0
            selectLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(selectLabel)
            NSLayoutConstraint.activate([
                selectLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                selectLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                selectLabel.heightAnchor.constraint(equalToConstant: 5),
                selectLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
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
            
            imageViewArray.append(image)
            dayOfWeekLabelArray.append(dayOfWeekLabel)
            dateLabelArray.append(dateLabel)
            tempMaxLabelArray.append(tempMaxLabel)
            tempMinLabelArray.append(tempMinLabel)
            selectLabelArray.append(selectLabel)
            views.append(view)
            
        }
        stackView = UIStackView(arrangedSubviews: self.views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.2196078431, blue: 0.3411764706, alpha: 1)
        self.alpha = 0.7
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        //MARK: - lineLabel
        let lineLabel = UILabel()
        
        lineLabel.backgroundColor = .white
        lineLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(lineLabel)
        NSLayoutConstraint.activate([
            lineLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            lineLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        
        stackView.spacing = 10
        //ось на которой расположены элементы
        stackView.axis = .horizontal
        stackView.alignment = .fill
        //Распределение упорядоченных представлений вдоль оси представления стека.
        stackView.distribution = .fillEqually
    }
    
    //MARK: - tap
    @objc func tap(sender: UIButton) {
        UIView.animate(withDuration: 0.1) { [selectLabelArray] in
            for i in selectLabelArray {
                i.alpha = 0
            }
        }
        UIView.animate(withDuration: 1) { [selectLabelArray] in
            selectLabelArray[sender.tag].alpha = 1
        }
        
        self.tapOnButton.send(sender.tag)
        
    }
    
}


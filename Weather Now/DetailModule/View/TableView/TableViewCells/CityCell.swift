//
//  CityCell.swift
//  Weather Now
//
//  Created by user on 02.06.2023.
//

import UIKit

class CityCell: UITableViewCell {
    
    static let identifier = "CityCell"
    
    //MARK: - weatherImageView
    private var weatherImageView: UIImageView = {
        var img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "ovc")
        
        return img
    }()
    
    //MARK: - cityLabel
    private var cityLabel: UILabel = {
        var lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .white
        lab.font = .boldSystemFont(ofSize: 20)
        lab.text = "Город"
        
        return lab
    }()
    
    //MARK: - weatherLabel
    private var weatherLabel: UILabel = {
        var lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 16)
        lab.text = "Облачно"
        
        return lab
    }()
    
    //MARK: - tempLabel
    private var tempLabel: UILabel = {
        var lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false

        lab.textColor = .white
        lab.font = .systemFont(ofSize: 40)
        lab.text = "33°"
        
        return lab
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        //MARK: - weatherImageView
        contentView.addSubview(weatherImageView)
        
        NSLayoutConstraint.activate([
            weatherImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.frame.height/2),
            weatherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            weatherImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            weatherImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2)
        ])
        
        //MARK: - cityLabel
        contentView.addSubview(cityLabel)
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: weatherImageView.topAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 5),
            cityLabel.trailingAnchor.constraint(equalTo: cityLabel.trailingAnchor),
            cityLabel.bottomAnchor.constraint(equalTo: cityLabel.bottomAnchor)
        ])
        
        //MARK: - weatherLabel
        contentView.addSubview(weatherLabel)
        
        NSLayoutConstraint.activate([
            weatherLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor),
            weatherLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            weatherLabel.trailingAnchor.constraint(equalTo: weatherLabel.trailingAnchor),
            weatherLabel.bottomAnchor.constraint(equalTo: weatherLabel.bottomAnchor)
        ])
        
        //MARK: - tempLabel
        contentView.addSubview(tempLabel)
        
        NSLayoutConstraint.activate([
            tempLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -10),
            tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tempLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -80),
            tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configurate(city: String, image: String, weather: String, temp: String) {
        cityLabel.text = city
        weatherImageView.image = UIImage(named: image)
        weatherLabel.text = weather
        tempLabel.text = temp + "°"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

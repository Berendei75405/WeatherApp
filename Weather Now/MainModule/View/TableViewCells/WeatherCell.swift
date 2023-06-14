//
//  WeatherCell.swift
//  Weather Now
//
//  Created by user on 06.04.2023.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    static let identifier = "weatherCell"
    
    private var vc: WeatherViewController!

    private var view = UIScreen.main.bounds.size
    
    //MARK: - shadowBall
    private var shadowBallLabel: UILabel = {
        var lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.3058823529, blue: 0.5294117647, alpha: 1)
        lab.alpha = 0.4
        
        return lab
    }()
    
    //MARK: - ballLabel
    private var ballLabel: UILabel = {
        var lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.2196078431, blue: 0.3411764706, alpha: 1)
        lab.alpha = 1
        lab.layer.borderWidth = 1.5
        lab.layer.borderColor = .init(red: 255, green: 255, blue: 255, alpha: 1)
        
        return lab
    }()
    
    //MARK: - tempLabel
    private var tempLabel: UILabel = {
        var lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.alpha = 1
        lab.font = .boldSystemFont(ofSize: 45)
        lab.textAlignment = .center
        lab.textColor = .white
        
        return lab
    }()
    
    //MARK: - feelsLikeLabel
    private var feelsLikeLabel: UILabel = {
        var lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.alpha = 1
        lab.text = "По ощущениям "
        lab.font = .systemFont(ofSize: 16)
        lab.textAlignment = .left
        lab.textColor = #colorLiteral(red: 0.7568627451, green: 0.7843137255, blue: 0.8235294118, alpha: 1)
        
        return lab
    }()
    
    //MARK: - tempFeelsLabel
    private var tempFeelsLabel: UILabel = {
        var lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.alpha = 1
        lab.font = .boldSystemFont(ofSize: 17)
        lab.textAlignment = .left
        lab.textColor = .white
        
        return lab
    }()
    
    //MARK: - weatherImageView
    private var weatherImageView: UIImageView = {
        var img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit

        
        return img
    }()
    
    //MARK: - conditionLabel
    private var conditionLabel: UILabel = {
        var lab = UILabel(frame: .zero)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.font = .boldSystemFont(ofSize: 16)
        lab.textAlignment = .center
        lab.textColor = .white
        
        return lab
    }()
    
    //MARK: - tempMaxLabel
    private var tempMaxLabel: UILabel = {
        var lab = UILabel(frame: .zero)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = #colorLiteral(red: 0.7568627451, green: 0.7843137255, blue: 0.8235294118, alpha: 1)
        lab.text = "Макс"
        lab.font = .systemFont(ofSize: 14)
        
        return lab
    }()
    
    //MARK: - valueTempMaxLabel
    private var valueTempMaxLabel: UILabel = {
        var lab = UILabel(frame: .zero)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .white
        lab.font = .boldSystemFont(ofSize: 14)
        
        return lab
    }()
    
    //MARK: - tempMinLabel
    private var tempMinLabel: UILabel = {
        var lab = UILabel(frame: .zero)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = #colorLiteral(red: 0.7568627451, green: 0.7843137255, blue: 0.8235294118, alpha: 1)
        lab.text = "Мин"
        lab.font = .systemFont(ofSize: 14)
        
        return lab
    }()
    
    //MARK: - valueTempMinLabel
    private var valueTempMinLabel: UILabel = {
        var lab = UILabel(frame: .zero)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .white
        lab.font = .boldSystemFont(ofSize: 14)
        
        return lab
    }()
    
    //MARK: - lineLeftImageView
    private var lineLeftImageView: UIImageView = {
        var img = UIImageView(image: UIImage(named: "line"))
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleToFill
        
        return img
    }()
    
    //MARK: - lineRightImageView
    private var lineRightImageView: UIImageView = {
        var img = UIImageView(image: UIImage(named: "line"))
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleToFill
        
        return img
    }()
    
    //MARK: - waterPrecipitationLabel
    private var waterPrecipitationLabel: UILabel = {
        var lab = UILabel(frame: .zero)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = #colorLiteral(red: 0.7568627451, green: 0.7843137255, blue: 0.8235294118, alpha: 1)
        lab.text = "Осадки"
        lab.font = .systemFont(ofSize: 14)
        
        return lab
    }()
    
    //MARK: - variatyLabel
    private var variatyLabel: UILabel = {
        var lab = UILabel(frame: .zero)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = #colorLiteral(red: 0.7568627451, green: 0.7843137255, blue: 0.8235294118, alpha: 1)
        lab.text = "Вероятн."
        lab.font = .systemFont(ofSize: 14)
        
        return lab
    }()
    
    //MARK: - valueWaterLabel
    private  var valueWaterLabel: UILabel = {
        var lab = UILabel(frame: .zero)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .white
        lab.font = .boldSystemFont(ofSize: 14)
        
        return lab
    }()
    
    //MARK: - valueWaterLabel
    private var valueVariatyLabel: UILabel = {
        var lab = UILabel(frame: .zero)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .white
        lab.font = .boldSystemFont(ofSize: 14)
        
        return lab
    }()
    
    //MARK: - windDirectionLabel
    private var windDirectionLabel: UILabel = {
        var lab = UILabel(frame: .zero)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = #colorLiteral(red: 0.7568627451, green: 0.7843137255, blue: 0.8235294118, alpha: 1)
        lab.font = .systemFont(ofSize: 14)
        
        return lab
    }()
    
    //MARK: - speedWindLabel
    private var speedWindLabel: UILabel = {
        var lab = UILabel(frame: .zero)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .white
        lab.font = .boldSystemFont(ofSize: 14)
        
        return lab
    }()
    
    //MARK: - lineBottomImgView
    private var lineBottomImgView: UIImageView = {
        var img = UIImageView(image: UIImage(named: "line"))
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleToFill
        
        return img
    }()
    
    //MARK: - dateLabel
    private var dateLabel: UILabel = {
        var lab = UILabel(frame: .zero)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = #colorLiteral(red: 0.7568627451, green: 0.7843137255, blue: 0.8235294118, alpha: 1)
        lab.text = "14:35 ЧТ"
        lab.font = .boldSystemFont(ofSize: 14)
        
        return lab
    }()
    
    //MARK: - scrollViewForTime
    private var scrollViewForTime: UIScrollView = {
        var scrl = UIScrollView()
        scrl.translatesAutoresizingMaskIntoConstraints = false
        scrl.showsHorizontalScrollIndicator = false
        scrl.decelerationRate = .normal
        scrl.bounces = false
        
        return scrl
    }()
    
    //MARK: - scrollViewForDay
    private var scrollViewForDay: UIScrollView = {
        var scrl = UIScrollView()
        scrl.translatesAutoresizingMaskIntoConstraints = false
        scrl.showsHorizontalScrollIndicator = false
        scrl.decelerationRate = .normal
        scrl.bounces = false
        
        return scrl
    }()
    
    
    //MARK: - timePicker
    lazy var timePicker: TimePickerView = {
        var picker = TimePickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        scrollViewForTime.addSubview(picker)
        
        return picker
    }()
    
    //MARK: - dayPicker
    lazy var dayPicker: DayPickerView = {
        var picker = DayPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        scrollViewForDay.addSubview(picker)
        
        return picker
    }()

    //MARK: - Макеты перерисовывает
    override func layoutSubviews() {
        super .layoutSubviews()
        shadowBallLabel.layer.cornerRadius = shadowBallLabel.frame.height/2
        shadowBallLabel.clipsToBounds = true
        
        ballLabel.layer.cornerRadius = ballLabel.frame.height/2
        ballLabel.clipsToBounds = true
        
    }
    
    //MARK: - ContentView
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        

        //MARK: - constraint shadowBall
        contentView.addSubview(shadowBallLabel)
        shadowBallLabel.centerXAnchor.constraint(
            equalTo: contentView.centerXAnchor)
            .isActive = true
        
        shadowBallLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: view.height/28)
            .isActive = true
        
        shadowBallLabel.widthAnchor.constraint(
            equalToConstant: contentView.frame.width)
        .isActive = true
        
        shadowBallLabel.heightAnchor.constraint(
            equalToConstant: contentView.frame.width)
        .isActive = true
        
        //MARK: - constraint ball
        contentView.addSubview(ballLabel)
        
        ballLabel.topAnchor.constraint(
            equalTo: shadowBallLabel.topAnchor, constant: 10)
            .isActive = true
        
        ballLabel.leadingAnchor.constraint(
            equalTo: shadowBallLabel.leadingAnchor, constant: 10)
            .isActive = true
        
        ballLabel.trailingAnchor.constraint(
            equalTo: shadowBallLabel.trailingAnchor, constant: -10)
            .isActive = true
        
        ballLabel.bottomAnchor.constraint(
            equalTo: shadowBallLabel.bottomAnchor, constant: -10)
            .isActive = true
        
        //MARK: - constraint tempLabel
        contentView.addSubview(tempLabel)
        
        tempLabel.topAnchor.constraint(
            equalTo: ballLabel.topAnchor, constant: 10)
            .isActive = true
        
        tempLabel.centerXAnchor.constraint(
            equalTo: contentView.centerXAnchor, constant: +8)
            .isActive = true
        
        //MARK: constraint feelsLikesLabel
        contentView.addSubview(feelsLikeLabel)
        
        feelsLikeLabel.topAnchor.constraint(
            equalTo: tempLabel.bottomAnchor)
            .isActive = true
        
        feelsLikeLabel.leadingAnchor.constraint(
            equalToSystemSpacingAfter: ballLabel.leadingAnchor, multiplier: 10)
            .isActive = true
        
        //MARK: - constraint tempFeelsLabel
        contentView.addSubview(tempFeelsLabel)
        
        tempFeelsLabel.leadingAnchor.constraint(
            equalTo: feelsLikeLabel.trailingAnchor)
            .isActive = true
        
        tempFeelsLabel.bottomAnchor.constraint(
            equalTo: feelsLikeLabel.bottomAnchor)
            .isActive = true
        
        
        //MARK: - constraint weatherView
        contentView.addSubview(weatherImageView)
        
        weatherImageView.topAnchor.constraint(
            equalTo: feelsLikeLabel.bottomAnchor, constant: 2)
            .isActive = true
        
        weatherImageView.leadingAnchor.constraint(
            equalTo: feelsLikeLabel.leadingAnchor, constant: 5)
            .isActive = true
        
        weatherImageView.heightAnchor.constraint(
            equalToConstant: contentView.frame.width/2.65)
            .isActive = true
        
        weatherImageView.widthAnchor.constraint(
            equalToConstant: contentView.frame.width/2.35)
            .isActive = true
        
        
        //MARK: - constraint conditionLabel
        contentView.addSubview(conditionLabel)
        
        conditionLabel.topAnchor.constraint(
            equalTo: weatherImageView.bottomAnchor, constant: 2)
            .isActive = true
        
        conditionLabel.leadingAnchor.constraint(
            equalToSystemSpacingAfter: ballLabel.leadingAnchor, multiplier: 3)
            .isActive = true
        
        conditionLabel.trailingAnchor.constraint(
            equalToSystemSpacingAfter: ballLabel.leadingAnchor, multiplier: 35.3)
            .isActive = true
        
        //MARK: - constraint valueTempMaxLabel
        contentView.addSubview(valueTempMaxLabel)
        
        valueTempMaxLabel.topAnchor.constraint(
            equalToSystemSpacingBelow: ballLabel.topAnchor, multiplier: 15.5)
            .isActive = true
        
        valueTempMaxLabel.trailingAnchor.constraint(
            equalTo: weatherImageView.leadingAnchor, constant: -10)
            .isActive = true
        
        //MARK: - constraint tempMaxLabel
        contentView.addSubview(tempMaxLabel)
        
        tempMaxLabel.bottomAnchor.constraint(
            equalTo: valueTempMaxLabel.bottomAnchor)
            .isActive = true
        
        tempMaxLabel.trailingAnchor.constraint(
            equalTo: valueTempMaxLabel.leadingAnchor, constant: -1)
            .isActive = true
        
        //MARK: - constraint tempMinLabel
        contentView.addSubview(tempMinLabel)
        
        tempMinLabel.bottomAnchor.constraint(
            equalTo: tempMaxLabel.bottomAnchor)
            .isActive = true
        
        tempMinLabel.leadingAnchor.constraint(
            equalTo: weatherImageView.trailingAnchor, constant: 10)
            .isActive = true
        
        //MARK: - constraint valueTempMinLabel
        contentView.addSubview(valueTempMinLabel)
        
        valueTempMinLabel.bottomAnchor.constraint(
            equalTo: tempMaxLabel.bottomAnchor)
            .isActive = true
        
        valueTempMinLabel.leadingAnchor.constraint(
            equalTo: tempMinLabel.trailingAnchor, constant: 1)
            .isActive = true
        
        //MARK - constraint lineLeftImageView
        contentView.addSubview(lineLeftImageView)
        
        lineLeftImageView.topAnchor.constraint(
            equalTo: tempMaxLabel.bottomAnchor, constant: -7)
            .isActive = true
        
        lineLeftImageView.leadingAnchor.constraint(
            equalTo: tempMaxLabel.leadingAnchor,constant: -10)
            .isActive = true
        
        lineLeftImageView.heightAnchor.constraint(
            equalToConstant: contentView.frame.width/15)
            .isActive = true
        
        lineLeftImageView.widthAnchor.constraint(
            equalToConstant: contentView.frame.width/4.4)
            .isActive = true
        
        //MARK: - constraint lineRightImageView
        contentView.addSubview(lineRightImageView)
        
        lineRightImageView.topAnchor.constraint(
            equalTo: tempMinLabel.bottomAnchor, constant: -7)
            .isActive = true
        
        lineRightImageView.leadingAnchor.constraint(
            equalTo: tempMinLabel.leadingAnchor, constant: -10)
            .isActive = true
        
        lineRightImageView.heightAnchor.constraint(
            equalToConstant: contentView.frame.width/15)
            .isActive = true
        
        lineRightImageView.widthAnchor.constraint(
            equalToConstant: contentView.frame.width/4.4)
            .isActive = true
        
        //MARK: - constraint waterPrecipitationLabel
        contentView.addSubview(waterPrecipitationLabel)
        
        waterPrecipitationLabel.topAnchor.constraint(
            equalTo: lineLeftImageView.bottomAnchor, constant: -7)
            .isActive = true
        
        waterPrecipitationLabel.leadingAnchor.constraint(
            equalTo: tempMaxLabel.leadingAnchor, constant: -1)
            .isActive = true
        
        //MARK: - constraint variatyLabel
        contentView.addSubview(variatyLabel)
        
        variatyLabel.topAnchor.constraint(
            equalTo: lineRightImageView.bottomAnchor, constant: -7)
            .isActive = true
        
        variatyLabel.leadingAnchor.constraint(
            equalTo: tempMinLabel.leadingAnchor, constant: -1)
            .isActive = true
        
        //MARK: - constraint valueWaterLabel
        contentView.addSubview(valueWaterLabel)
        
        valueWaterLabel.topAnchor.constraint(
            equalTo: waterPrecipitationLabel.bottomAnchor)
            .isActive = true
        
        valueWaterLabel.leadingAnchor.constraint(
            equalTo: waterPrecipitationLabel.leadingAnchor, constant: 5)
            .isActive = true
        
        //MARK: - constraint valueVariatyLabel
        contentView.addSubview(valueVariatyLabel)
        
        valueVariatyLabel.topAnchor.constraint(
            equalTo: variatyLabel.bottomAnchor)
            .isActive = true
        
        valueVariatyLabel.leadingAnchor.constraint(
            equalTo: variatyLabel.leadingAnchor, constant: 6)
            .isActive = true
        
        //MARK: - constraint windDirectionLabel
        contentView.addSubview(windDirectionLabel)
        
        windDirectionLabel.topAnchor.constraint(
            equalTo: conditionLabel.bottomAnchor, constant: 10)
            .isActive = true
        
        windDirectionLabel.leadingAnchor.constraint(
            equalToSystemSpacingAfter: ballLabel.leadingAnchor, multiplier: 12)
            .isActive = true
        
        //MARK: - constraint speedWindLabel
        contentView.addSubview(speedWindLabel)
        
        speedWindLabel.topAnchor.constraint(
            equalTo: conditionLabel.bottomAnchor, constant: 10)
            .isActive = true
        
        speedWindLabel.leadingAnchor.constraint(
            equalTo: windDirectionLabel.trailingAnchor, constant: 2)
            .isActive = true
        
        //MARK: - constraint lineBottomImgView
        contentView.addSubview(lineBottomImgView)
        
        lineBottomImgView.topAnchor.constraint(
            equalTo: windDirectionLabel.bottomAnchor)
            .isActive = true
        
        lineBottomImgView.leadingAnchor.constraint(
            equalToSystemSpacingAfter: ballLabel.leadingAnchor, multiplier: 11)
            .isActive = true
        
        lineBottomImgView.heightAnchor.constraint(
            equalToConstant: contentView.frame.width/30)
            .isActive = true
        
        lineBottomImgView.widthAnchor.constraint(
            equalToConstant: contentView.frame.width/2.5)
            .isActive = true
        
        //MARK: - constraint dateLabel
        contentView.addSubview(dateLabel)
        
        dateLabel.topAnchor.constraint(
            equalTo: lineBottomImgView.bottomAnchor)
            .isActive = true
        
        dateLabel.leadingAnchor.constraint(
            equalToSystemSpacingAfter: ballLabel.leadingAnchor, multiplier: 16)
            .isActive = true
        
        //MARK: - constraint scrollViewForDay
        contentView.addSubview(scrollViewForDay)
        
        scrollViewForDay.topAnchor.constraint(
            equalTo: shadowBallLabel.bottomAnchor, constant: view.height/12)
            .isActive = true
        
        scrollViewForDay.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor)
            .isActive = true
        
        scrollViewForDay.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor)
            .isActive = true
        
        scrollViewForDay.bottomAnchor.constraint(
            equalTo: scrollViewForDay.topAnchor, constant: view.height/12)
            .isActive = true
        
        //MARK: - constraint timePicker
        NSLayoutConstraint.activate([
            dayPicker.topAnchor.constraint(equalTo: scrollViewForDay.topAnchor),
            dayPicker.leadingAnchor.constraint(equalTo: scrollViewForDay.leadingAnchor),
            dayPicker.trailingAnchor.constraint(equalTo: scrollViewForDay.trailingAnchor),
            dayPicker.bottomAnchor.constraint(equalTo: scrollViewForDay.bottomAnchor),
            dayPicker.heightAnchor.constraint(equalTo: scrollViewForDay.heightAnchor),
            dayPicker.widthAnchor.constraint(equalToConstant: 450)
        ])
    
        //MARK: - constraint scrollView
        contentView.addSubview(scrollViewForTime)
        
        scrollViewForTime.topAnchor.constraint(
            equalTo: scrollViewForDay.bottomAnchor,constant: 2)
            .isActive = true
        
        scrollViewForTime.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor)
            .isActive = true
        
        scrollViewForTime.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor)
            .isActive = true
        
        scrollViewForTime.bottomAnchor.constraint(
            equalTo: scrollViewForTime.topAnchor, constant: view.height/8)
            .isActive = true
        
        //MARK: - constraint timePicker
        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: scrollViewForTime.topAnchor),
            timePicker.leadingAnchor.constraint(equalTo: scrollViewForTime.leadingAnchor),
            timePicker.trailingAnchor.constraint(equalTo: scrollViewForTime.trailingAnchor),
            timePicker.bottomAnchor.constraint(equalTo: scrollViewForTime.bottomAnchor),
            timePicker.heightAnchor.constraint(equalTo: scrollViewForTime.heightAnchor),
            timePicker.widthAnchor.constraint(equalToConstant: 1000)
        ])
        
        
    }
    
    //MARK: - configurate
    func configurate(temp: Int, feelsLike: Int, windSpeed: Double,
                     condition: String, windDirection: String,
                     date: String, image: UIImage, tempMax: Int,
                     tempMin: Int, precMM: Double, precProb: Double) {
        
        tempLabel.text = String(temp) + "°"
        tempFeelsLabel.text = String(feelsLike) + "°"
        speedWindLabel.text = String(windSpeed) + "м/ч"
        conditionLabel.text = condition
        windDirectionLabel.text = windDirection + " ветер"
        dateLabel.text = date
        weatherImageView.image = image
        valueTempMaxLabel.text = String(tempMax) + "°"
        valueTempMinLabel.text = String(tempMin) + "°"
        valueWaterLabel.text = String(precMM) + "мм"
        valueVariatyLabel.text = String(precProb) + "%"
    
    }
    
    //MARK: - configurateTimePicker
    func configurateTimePicker(tempArray: [String], timeArray: [String], imageArray: [String]) {
        for i in 0..<timeArray.count {
            timePicker.tempLabels[i].text = tempArray[i]
            timePicker.timeLabels[i].text = timeArray[i]
            timePicker.images[i].image = UIImage(named: imageArray[i])
        }
    }
    
    //MARK: - configurateTimePicker
    func configurateDayPicker(imageArray: [String], minTempArray: [String],
                              maxTempArray: [String], dayOfWeek: [String], date: [String]) {
        for i in 0..<imageArray.count {
            dayPicker.imageViewArray[i].image = UIImage(named: imageArray[i])
            dayPicker.tempMinLabelArray[i].text = minTempArray[i]
            dayPicker.tempMaxLabelArray[i].text = maxTempArray[i]
            dayPicker.dayOfWeekLabelArray[i].text = dayOfWeek[i]
            dayPicker.dateLabelArray[i].text = date[i]
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
}

extension WeatherCell: TimePickerViewDataSource {
    func timePickerCount(_ timePicker: TimePickerView) -> Int {
        return 12
    }
}

extension WeatherCell: DayPickerViewDataSource {
    func dayPickerCount(_ dayPicker: DayPickerView) -> Int {
        return 3
    }
}

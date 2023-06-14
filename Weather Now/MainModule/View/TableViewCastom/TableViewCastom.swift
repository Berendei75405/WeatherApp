//
//  TableViewCastom.swift
//  Weather Now
//
//  Created by user on 06.04.2023.
//

import UIKit
import Combine

class TableViewCastom: UITableView {
    //MARK: - Состояние таблицы
    var tableState: TableState = .initial {
        //при изменении требовать перерисовать
        didSet {
            reloadData()
        }
    }
    
    var cancellable = Set<AnyCancellable>()
    
    //MARK: - property
    var vc: WeatherViewController!
    private lazy var tableContentOffSetY = self.contentOffset.y
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .plain)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
        
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func reloadData() {
        super.reloadData()
        
        switch tableState {
        case .initial:
            print("initial")
        case .loading:
            print("loading")
            vc.reloadLable.text = "Обновление!"
            UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
                self?.vc?.townButton.frame.origin.y = -30
                self?.vc?.reloadLable.frame.origin.y = 0
            }
        case .success:
            print("success")
            vc.reloadLable.text = "Обновление успешно"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
                    self?.vc?.townButton.frame.origin.y = 0
                    self?.vc?.reloadLable.frame.origin.y = -60
                }
            })
            
        case .failure:
            print("failure")
            vc.reloadLable.text = "Не удалось получить данные("
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
                    self?.vc?.townButton.frame.origin.y = 0
                    self?.vc?.reloadLable.frame.origin.y = -60
                }
            })
        }
        
    }
}

//MARK: - Delegate, DataSource
extension TableViewCastom: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //MARK: - configurate cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as? WeatherCell {
            let fact = vc.viewModel.weatherInfo?.fact
            let day = vc.viewModel.weatherInfo?.forecasts.first?.parts.day
            let img = UIImage(named: fact?.icon ?? "skc_d")
            
            //отключение затемнения яйчейки
            cell.selectionStyle = .none
           
            cell.configurate(temp: fact?.temp ?? 0,
                             feelsLike: fact?.feelsLike ?? 0,
                             windSpeed: fact?.windSpeed ?? 0,
                             condition: fact?.condition ?? "",
                             windDirection: fact?.windDir ?? "➔ Ю",
                             date: vc.viewModel.currentDateForBall(),
                             image: img ?? UIImage(),
                             tempMax: day?.tempMax ?? 0,
                             tempMin: day?.tempMin ?? 0,
                             precMM: day?.precMM ?? 0,
                             precProb: day?.precProb ?? 0)
            //фон
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: vc.viewModel.getImageForBackground(weatherIcon: fact?.icon ?? "sun"))
            cell.backgroundView = imageView
            
            //MARK: - timePicker
            let timePickConfig = vc.viewModel.getInfoForTimePicker(index: 0)
            cell.configurateTimePicker(tempArray: timePickConfig.0, timeArray: timePickConfig.1, imageArray: timePickConfig.2)
            
            //MARK: - dayPicker
            let dayPickConfig = vc.viewModel.getInfoForDayPicker()
            
            cell.configurateDayPicker(imageArray: dayPickConfig.0, minTempArray: dayPickConfig.1, maxTempArray: dayPickConfig.2, dayOfWeek: dayPickConfig.3, date: dayPickConfig.4)

            cell.dayPicker.tapOnButton.sink { [self] index in
                let config = self.vc!.viewModel.getInfoForTimePicker(index: index)
                cell.timePicker.indexDayPicker = index
                cell.configurateTimePicker(tempArray: config.0, timeArray: config.1, imageArray: config.2)
            }.store(in: &cancellable)
            
            cell.timePicker.tapOnButton.sink { [self] index in
                let config = self.vc.viewModel.getInfoForBall(indexDay: cell.timePicker.indexDayPicker, indexTime: index)
                cell.configurate(temp: config.0.temp, feelsLike: config.0.feelsLike, windSpeed: config.0.windSpeed, condition: config.0.condition, windDirection: config.0.windDir, date: self.vc.viewModel.currentDateForBall(), image: (UIImage(named: config.0.icon) ?? UIImage(named: "ovc"))!, tempMax: config.1.tempMax, tempMin: config.1.tempMin, precMM: config.0.precMM, precProb: config.0.precProb)
                
                //фон
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.image = UIImage(named: vc.viewModel.getImageForBackground(weatherIcon: config.0.icon ))
                cell.backgroundView = imageView
                
            }.store(in: &cancellable)
            
            
            
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: - height Cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return vc.view.frame.height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > tableContentOffSetY {
            vc.navigationItem.titleView = vc.customView(townName: vc.viewModel.townName, currentDate: vc.viewModel.currentDateForTitle(), dateIsHiden: false)
        } else if scrollView.contentOffset.y < tableContentOffSetY {
            vc.navigationItem.titleView = vc.customView(townName: vc.viewModel.townName, currentDate: vc.viewModel.currentDateForTitle(), dateIsHiden: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + 60 < tableContentOffSetY {
            vc.viewModel.fetch()
        }
    }
    
}


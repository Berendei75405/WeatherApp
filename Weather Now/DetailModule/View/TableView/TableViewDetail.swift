//
//  TableViewDetail.swift
//  Weather Now
//
//  Created by user on 01.06.2023.
//

import UIKit
import Combine


enum DetailTableViewState {
    //failure используется чтобы показывать города уже добавленные
    case initial
    case failure
    //success используется чтобы показывать результаты поисков городов через интернет запрос
    case success
}

class TableViewDetail: UITableView {
    //MARK: - Состояние таблицы
    var tableState: DetailTableViewState = .initial {
        //при изменении требовать перерисовать
        didSet {
            reloadData()
        }
    }
    
    var vc: DetailViewController!
    var cancellable = Set<AnyCancellable>()
    
    //MARK: - init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .grouped)
        self.translatesAutoresizingMaskIntoConstraints = false
        //регистрация яйчеек
        self.register(CityCell.self, forCellReuseIdentifier: CityCell.identifier)
        self.register(SearchCities.self, forCellReuseIdentifier: SearchCities.identifier)
        
        self.separatorColor = .white
        
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - extension
extension TableViewDetail: UITableViewDelegate, UITableViewDataSource {
    //количество секций
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //кол яйчеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableState == .initial || tableState == .failure {
            return UserDefaults.standard.array(forKey: "cities")?.count ?? 0
        } else {
            return vc.viewModel.citiesForSearch?.response.geoObjectCollection.featureMember.count ?? 0
        }
        
    }
    //название секций
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Места"
        } else {
            return ""
        }
    }
    
    //Настройки текста + названия
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView

        var config = header.defaultContentConfiguration()
        
        config.text = "Места"
        config.textProperties.color = .white
        config.textProperties.font = UIFont(name: "HelveticaNeue-Bold", size: 30) ?? .systemFont(ofSize: 20)
        config.textProperties.transform = .none
        
        if section == 0 {
            header.contentConfiguration = config
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableState == .initial || tableState == .failure {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.identifier) as? CityCell {
                let array = UserDefaults.standard.array(forKey: "cities") as? [String]
                let name = array?[indexPath.row] ?? ""
                let city = vc.viewModel.coreDataManager.fetchWeather(name: name)
                
                cell.configurate(city: name , image: city?.fact.icon ?? "", weather: city?.fact.condition ?? "", temp: String(city?.fact.temp ?? 0))
                
                return cell
            }
        } else if tableState == .success {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SearchCities.identifier) as? SearchCities {
                let name = vc.viewModel.citiesForSearch?.response.geoObjectCollection.featureMember[indexPath.row].geoObject.name ?? ""
                
                let admArea = vc.viewModel.citiesForSearch?.response.geoObjectCollection.featureMember[indexPath.row].geoObject.description ?? ""
    
                cell.configurate(info: name + ", " + admArea)
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    //высота яйчеек
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableState == .failure || tableState == .initial {
            return 100
        } else {
            return 80
        }
    }
    //что происходит при нажатии на яйчейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableState == .failure || tableState == .initial {
            let array = UserDefaults.standard.array(forKey: "cities") as! [String]
            vc.viewModel.router.popToRootAndSend(city: array[indexPath.row])
        } else if tableState == .success{
            //добавляем в массив городов город
            var array = UserDefaults.standard.array(forKey: "cities") as! [String]
            let geoObject = vc.viewModel.citiesForSearch?.response.geoObjectCollection.featureMember[indexPath.row].geoObject
            let name = geoObject?.name ?? ""
            array.append(name)
            UserDefaults.standard.setValue(array, forKey: "cities")
            //добавляем координаты к каждому городу
            let coordinates = geoObject?.point.pos.split(separator: " ")
            let lon = String(coordinates?[0] ?? "")
            let lat = String(coordinates?[1] ?? "")
            let coordinatesArray = [lon, lat]
            UserDefaults.standard.setValue(coordinatesArray, forKey: name)
            vc.viewModel.fetchWeather(city: geoObject?.name ?? "")
        }
    }
    //удаление яйчеек
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableState == .failure || tableState == .initial {
            return .delete
        } else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.row > 0 {
                //удаляем из массива городов и из массива где хранятся координаты
                var arrayCities = UserDefaults.standard.value(forKey: "cities") as! [String]
                let city = arrayCities[indexPath.row]
                arrayCities.remove(at: indexPath.row)
                UserDefaults.standard.setValue(arrayCities, forKey: "cities")
                UserDefaults.standard.removeObject(forKey: city)
                self.vc.viewModel.coreDataManager.removeWeather(name: city)
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        }
    }
    
}

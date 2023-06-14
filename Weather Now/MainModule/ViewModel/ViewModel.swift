//
//  ViewModel.swift
//  Weather Now
//
//  Created by user on 04.04.2023.
//

import Foundation
import Combine
import CoreLocation

//MARK: - ViewModelProtocol
protocol ViewModelProtocol {
    var weatherInfo: TableState.Model? {get set}
    var updateTableState: ((TableState) -> ())? {get set}
    var townPublisher: PassthroughSubject<String, Never> {get set}
    var townName: String {get set}
    var coreDataManager: CoreDataManager! {get set}
    var router: MainRouter! {get set}
    var cityForWeather: String {get set}
    
    func getLocation()
    func fetch()
    func getInfoForTimePicker(index: Int) -> ([String], [String], [String])
    func getInfoForDayPicker() -> ([String], [String], [String], [String], [String])
    func getInfoForBall(indexDay: Int, indexTime: Int) -> (TableState.Model.Hours, TableState.Model.Parts.Day)
    func currentDateForBall() -> String
    func currentDateForTitle() -> String
    func getImageForBackground(weatherIcon: String) -> String
    func createDayOfWeek() -> [String]
    func createDateForDayPicker() -> [String]
    func getWeatherWithoutErrors() -> TableState.Model
    
}

class ViewModel: NSObject, ViewModelProtocol {
    
    var router: MainRouter!
    var weatherInfo: TableState.Model?
    //состояние экрана обновление
    var updateTableState: ((TableState) -> ())?
    //широта
    var latitude = CLLocationDegrees(integerLiteral: 0)
    //долгота
    var longitude = CLLocationDegrees(integerLiteral: 0)
    //издатель события об изменении города
    var townPublisher = PassthroughSubject<String, Never>()
    var townName = "" {
        didSet {
            if townName == cityForWeather || townName == "" {
                townName = cityForWeather
            }
            townPublisher.send(townName)
        }
    }
    var coreDataManager: CoreDataManager!
    let locationManager = CLLocationManager()
    private var cancellable = Set<AnyCancellable>()
    var cityForWeather: String = ""
    
    override init() {
        super.init()
        updateTableState?(.initial)
    }
    
    //MARK: - fetch
    func fetch() {
        var urlOptional: URL? = nil
        
        //если пользователь не разрешил отслеживать местоположение и нету города в переменной cityForWeather
        if (locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .notDetermined) && (cityForWeather == "" ) {
            let city = UserDefaults.standard.array(forKey: "cities") as? [String]
            if city?.first != nil {
                let coordinates = UserDefaults.standard.array(forKey: (city?.first)!)
                townName = (city?.first)!
                guard let url = URL(string: "https://api.weather.yandex.ru/v2/forecast?lat=\(coordinates?[1] ?? "")&lon=\(coordinates?[0] ?? "")&limit=3&hours=true") else {return}
                urlOptional = url
            }
            //если пользователь не разрешил отслеживать местоположение и есть город в списке добавленный вручную
        } else if (locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .notDetermined) && (cityForWeather != "" ) {
            let coordinates = UserDefaults.standard.array(forKey: cityForWeather) as? [String]
            townName = cityForWeather
            guard let url = URL(string: "https://api.weather.yandex.ru/v2/forecast?lat=\(coordinates?[1] ?? "")&lon=\(coordinates?[0] ?? "")&limit=3&hours=true") else {return}
            urlOptional = url
            //если пользователь разрешил местоположение
        }else if cityForWeather == "" {
            if longitude != 0.0 && latitude != 0.0 {
                guard let url = URL(string: "https://api.weather.yandex.ru/v2/forecast?lat=\(latitude)&lon=\(longitude)&limit=3&hours=true") else {return}
                urlOptional = url
            }
            //если пользователь разрешил местоположение и есть город
        } else {
            let coordinates = UserDefaults.standard.array(forKey: cityForWeather) as! [String]
            print(cityForWeather)
            townName = cityForWeather
            guard let url = URL(string: "https://api.weather.yandex.ru/v2/forecast?lat=\(coordinates[1])&lon=\(coordinates[0])&limit=3&hours=true") else {return}
            urlOptional = url
        }
        guard let url = urlOptional else {return}
        updateTableState?(.loading)
        let apiKey = "685d9471-d6f9-4af7-96cf-fa5321b68e57"
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Yandex-API-Key")
        //издатель
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: TableState.Model.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        
        publisher.sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                print("publisher is finished!")
            case .failure(let error):
                //выдаст либо стандартные значения, либо из coreData последние данные
                self?.weatherInfo = self?.getWeatherWithoutErrors()
                
                self?.updateTableState?(.failure)
                print("error - \(error)")
            }
        }, receiveValue: { [self] result in
            var weatherNew = result
            weatherNew.fact.condition = self.filterForCondition(result: result.fact.condition)
            weatherNew.fact.windDir = self.filterForWindDir(result: result.fact.windDir)
            
            for item in 0..<weatherNew.forecasts.count {
                for elem in 0..<weatherNew.forecasts[item].hours.count {
                    weatherNew.forecasts[item].hours[elem].condition = self.filterForCondition(result: weatherNew.forecasts[item].hours[elem].condition)
                    weatherNew.forecasts[item].hours[elem].windDir = self.filterForWindDir(result: weatherNew.forecasts[item].hours[elem].windDir)
                }
            }
            
            self.weatherInfo = weatherNew
            
            if weatherInfo != nil {
                self.coreDataManager.addWeatherInfo(model: weatherInfo!, name: townName)
            }
            
            self.updateTableState?(.success)
        }).store(in: &cancellable)
    }
    
    //MARK: - getLocation
    func getLocation() {
        DispatchQueue.global(qos: .userInteractive).async { [locationManager] in
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: - getInfoForTimePicker
    func getInfoForTimePicker(index: Int) -> ([String], [String], [String]) {
        var tempArray: [String] = []
        var timeArray: [String] = []
        var imageArray: [String] = []
        if self.coreDataManager.fetchWeather(name: townName) != nil {
            let forecast = self.coreDataManager.fetchWeather(name: townName)!.forecasts[index]
            for item in forecast.hours {
                if (Int(item.hour) ?? 0) % 2 == 0 {
                    timeArray.append("\(item.hour):00")
                    tempArray.append("\(item.temp)°")
                    imageArray.append(item.icon)
                }
            }
        }
        return (tempArray, timeArray, imageArray)
    }
    
    //MARK: - getInfoForDayPicker
    func getInfoForDayPicker() -> ([String], [String], [String], [String], [String]) {
        var imageArray: [String] = []
        var minTempArray: [String] = []
        var maxTempArray: [String] = []
        var dayOfWeek: [String] = []
        var date: [String] = []
        
        if self.coreDataManager.fetchWeather(name: townName) != nil {
            for item in 0..<(self.coreDataManager.fetchWeather(name: townName)!.forecasts.count) {
                let day = self.coreDataManager.fetchWeather(name: townName)!.forecasts[item].parts.day
                imageArray.append(day.icon)
                minTempArray.append("\(day.tempMin)°")
                maxTempArray.append("\(day.tempMax)°")
                dayOfWeek = self.createDayOfWeek()
                date = self.createDateForDayPicker()    
            }
        }
        return (imageArray, minTempArray, maxTempArray, dayOfWeek, date)
    }
    
    //MARK: - getInfoForBall
    func getInfoForBall(indexDay: Int, indexTime: Int) -> (TableState.Model.Hours, TableState.Model.Parts.Day) {
        var hours: [TableState.Model.Hours] = []
        var day: TableState.Model.Parts.Day!
        let weather = getWeatherWithoutErrors()
        //достаем четные часы
        for i in weather.forecasts[indexDay].hours {
            if (Int(i.hour) ?? 0) % 2 == 0 {
                hours.append(TableState.Model.Hours.init(hour: i.hour, windSpeed: i.windSpeed, temp: i.temp, feelsLike: i.feelsLike, condition: i.condition, windDir: i.windDir, icon: i.icon, precMM: i.precMM, precProb: i.precProb))
                
                day = .init(icon: "ovc", precMM: 0, tempMax: weather.forecasts[indexDay].parts.day.tempMax,  tempMin: weather.forecasts[indexDay].parts.day.tempMin, precProb: 0)
            }
        }
        return (hours[indexTime], day)
    }
    
    //MARK: - getWeatherWithoutErrors
    //в случае ошибки обновления вызовется этот метод
    func getWeatherWithoutErrors() -> TableState.Model {
        var forecast: [TableState.Model.Forecasts] = []
        for _ in 0..<3 {
            let day = TableState.Model.Parts.Day.init(icon: "ovc", precMM: 0, tempMax: 0, tempMin: 0, precProb: 0)
            var hours: [TableState.Model.Hours] = []
            for _ in 0..<12 {
                let hoursNew = TableState.Model.Hours.init(hour: "0:00", windSpeed: 0, temp: 0, feelsLike: 0, condition: "Ясно", windDir: "↑ С", icon: "ovc", precMM: 0, precProb: 0)
                hours.append(hoursNew)
            }
            forecast.append(TableState.Model.Forecasts(parts: TableState.Model.Parts.init(day: day), hours: hours))
        }
        let fact = TableState.Model.Fact.init(windSpeed: 0, temp: 0, feelsLike: 0, condition: "Ясно", windDir: "↑ С", icon: "ovc")
        let model = TableState.Model(fact: fact, forecasts: forecast)
        
        if coreDataManager.fetchWeather(name: townName) != nil {
            return coreDataManager.fetchWeather(name: townName)!
        } else {
            return model
        }
    }
    
    //MARK: - getImageForBackground
    func getImageForBackground(weatherIcon: String) -> String {
        switch weatherIcon {
        case "skc_d":
            return "sun"
        case "ovc":
            return "clounds"
        case "skc_n":
            return "night"
        case "ovc_sn":
            return "snow"
        case "ovc_ra":
            return "rain"
        case "ovc_-ra":
            return "rain"
        case "ovc_ra_sn":
            return "rain"
        case "bkn_sn_n":
            return "snowNight"
        case "bkn_sn_d":
            return "snow"
        case "bkn_ra_n":
            return "rain"
        case "bkn_ra_d":
            return "rain"
        case "bkn_n":
            return "nightWithClounds"
        case "bkn_d":
            return "clounds"
        case "bkn_-sn-d":
            return "snow"
        case "bkn_-sn_n":
            return "snowNight"
        case "bkn_-ra_d":
            return "rain"
        case "ovc_+ra":
            return "rain"
        case "bkn_+ra_d":
            return "rain"
        default: return "sun"
        }
    }
    
}

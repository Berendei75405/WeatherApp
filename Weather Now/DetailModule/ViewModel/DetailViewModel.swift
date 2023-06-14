//
//  DetailViewModel.swift
//  Weather Now
//
//  Created by user on 01.06.2023.
//

import Foundation
import Combine  

protocol DetailViewModelProtocol {
    var router: MainRouter! {get set}
    var citiesForSearch: City? {get}
    var coreDataManager: CoreDataManager {get set}
    var updateTableState: ((DetailTableViewState) -> ())? {get set}
    func fetchCities(city: String)
    func fetchWeather(city: String)
}

class DetailViewModel: DetailViewModelProtocol {
    var router: MainRouter!
    var vc: DetailViewController!
    var citiesForSearch: City?
    var coreDataManager = CoreDataManager.share
    var updateTableState: ((DetailTableViewState) -> ())?
    
    private var cancellable = Set<AnyCancellable>()
    
    init(city: String) {
        if UserDefaults.standard.value(forKey: "cities") == nil {
            let array: [String] = []
            UserDefaults.standard.setValue(array, forKey: "cities")
        }
        if !city.isEmpty && city != "Город" {
            if UserDefaults.standard.value(forKey: "cities") == nil {
                let array: [String] = []
                UserDefaults.standard.setValue(array, forKey: "cities")
            }
            
            var array = UserDefaults.standard.array(forKey: "cities") as! [String]
            let bool = array.contains(where: { item in
                item == city
            })
            
            if bool == false {
                array.append(city)
                UserDefaults.standard.setValue(array, forKey: "cities")
            }
            for i in array {
                fetchWeather(city: i)
            }
        }
        updateTableState?(.initial)
    }
    
    //MARK: - fetchCities
    func fetchCities(city: String) {
        let russianWord = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let string = "https://geocode-maps.yandex.ru/1.x/?apikey=495d8ac5-d573-4880-b69d-d536539908c3&results=10&format=json&geocode=\(russianWord ?? "")"
        guard let url = URL(string: string) else {
            print("invalid URL")
            return}
        
        let request = URLRequest(url: url)
        //издатель
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: City.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        publisher.sink { [self] completion in
            switch completion {
            case .finished:
                print("FetchCities pulisher is finished!")
                self.updateTableState?(.success)
            case .failure(let error):
                print(error)
                self.updateTableState?(.failure)
            }
        } receiveValue: { result in
            self.citiesForSearch = result
        }.store(in: &cancellable)
    }
    
    //MARK: - fetchWeather
    func fetchWeather(city: String) {
        let coordinates = UserDefaults.standard.array(forKey: city) as! [String]
        
        guard let url = URL(string: "https://api.weather.yandex.ru/v2/forecast?lat=\(coordinates[1])&lon=\(coordinates[0])&limit=3&hours=true") else {return}
        let apiKey = "685d9471-d6f9-4af7-96cf-fa5321b68e57"
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Yandex-API-Key")
        //издатель
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: TableState.Model.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        
        publisher.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("publisher is finished!")
            case .failure(let error):
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
            
            self.coreDataManager.addWeatherInfo(model: weatherNew, name: city)
            //чтобы показал города которые уже добавлены
            updateTableState?(.failure)
        }).store(in: &cancellable)
    }
    
}


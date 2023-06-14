//
//  ExtensionViewModel.swift
//  Weather Now
//
//  Created by user on 10.04.2023.
//

import Foundation
import CoreLocation

extension ViewModel: CLLocationManagerDelegate {
    //MARK: - filterForCondition
    func filterForCondition(result: String) -> String {
        switch result {
        case "clear":
            return "Ясно"
        case "partly-cloudy":
            return "Переменная облачность"
        case "cloudy":
            return "Облачно"
        case "overcast":
            return "Пасмурно"
        case "drizzle":
            return "Легкий дождь"
        case "light-rain":
            return "Легкий дождь"
        case "rain":
            return "Дождь"
        case "moderate-rain":
            return "Умеренный дождь"
        case "heavy-rain":
            return "Сильный дождь"
        case "continuous-heavy-rain":
            return "Сильный дождь"
        case "showers":
            return "Ливень"
        case "wet-snow":
            return "Легкий снег"
        case "light-snow":
            return "Легкий снег"
        case "snow":
            return "Снег"
        case "snow-showers":
            return "Снегопад"
        case "hail":
            return "Град"
        case "thunderstorm":
            return "Гроза"
        case "thunderstorm-with-rain":
            return "Дождь с грозой"
        case "thunderstorm-with-hail":
            return "Град с грозой"
        default:
            return ""
        }
    }
    //MARK: - filterForWindDir
    func filterForWindDir(result: String) -> String {
        switch result {
        case "nw":
            return "↖ CЗ"
        case "n":
            return "↑ С"
        case "ne":
            return "↗ СВ"
        case "e":
            return "→ В"
        case "se":
            return "↘ ЮВ"
        case "s":
            return "↓ Ю"
        case "sw":
            return "↙ ЮЗ"
        case "w":
            return "← З"
        default:
            return "   "
        }
    }
    //MARK: - currentDateForBall
    func currentDateForBall() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM EEE"
        formatter.locale = Locale(identifier: "ru_RU")
        let dateString = formatter.string(from: currentDate)
        
        return dateString
    }
    
    //MARK: - currentDateForTitle
    func currentDateForTitle() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd, HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        let dateString = formatter.string(from: currentDate)
        
        return dateString
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let queue = DispatchQueue(label: "Location", attributes: .concurrent)
        let workItem = DispatchWorkItem {
            if let location = locations.last {
                //широта
                self.latitude = location.coordinate.latitude
                //долгота
                self.longitude = location.coordinate.longitude
            }
            self.locationManager.stopUpdatingLocation()
        }
        
        workItem.notify(queue: .main) {
            self.fetch()
        }
        
        queue.sync(execute: workItem)
        
        queue.async {
            self.getTownName(latitude: self.latitude,
                             longtitude: self.longitude)
        }

    }
    
    //MARK: - getTown
    private func getTownName(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
            let location = CLLocation(latitude: latitude, longitude: longtitude)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let placemark = placemarks?.first else {print("PlaceMarks not found!"); return }
                if let townName = placemark.locality {
                    if self.townName == "" || self.townName == "Город" {
                        self.townName = townName
                        //добавим город и его координаты в UserDefauls
                        if UserDefaults.standard.value(forKey: townName) == nil {
                            var array: [String] = []
                            array.append(String(longtitude))
                            array.append(String(latitude))
                            UserDefaults.standard.set(array, forKey: townName)
                        }
                    }
                } else {
                    print("No town name found!")
                }
            }
    }
    //MARK: - createDayOfWeek
    func createDayOfWeek() -> [String] {
        var weekArray: [String] = []
        let calendar = Calendar.current
        let formatter = DateFormatter()
        for day in 0...6 {
            if day != 0 {
                formatter.dateFormat = "EEE"
                formatter.locale = Locale(identifier: "ru_RU")
                let nextDay = calendar.date(byAdding: .day, value: day, to: Date())!
                let dayOfWeek = formatter.string(from: nextDay)
                weekArray.append(dayOfWeek)
            } else {
                weekArray.append("Cегодня")
            }
        }
        return weekArray
    }
    
    //MARK: - createDateForDayPicker
    func createDateForDayPicker() -> [String] {
        var weekArray: [String] = []
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        for i in 1...7 {
            
            if i != 1 {
                formatter.dateFormat = "dd MMM."
                formatter.locale = Locale(identifier: "ru_RU")
                let nextDay = calendar.date(byAdding: .day, value: i, to: Date())!
                let day = formatter.string(from: nextDay)
                weekArray.append(day)
            } else {
                weekArray.append("")
            }
        }
        return weekArray
    }
}

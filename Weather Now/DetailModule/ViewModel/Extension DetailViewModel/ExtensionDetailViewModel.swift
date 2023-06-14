//
//  ExtensionDetailViewModel.swift
//  Weather Now
//
//  Created by user on 06.06.2023.
//
import Foundation

extension DetailViewModel {
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
}

//
//  Model.swift
//  Weather Now
//
//  Created by user on 04.04.2023.
//

import Foundation

//MARK: - TableState
enum TableState {
    case initial
    case success
    case failure
    case loading
    //MARK: - Model
    struct Model: Codable {
        var fact: Fact
        var forecasts: [Forecasts]
        
        //MARK: - Fact
        struct Fact: Codable {
            let windSpeed: Double
            let temp: Int
            let feelsLike: Int
            var condition: String
            var windDir: String
            let icon: String
            
            private enum CodingKeys: String, CodingKey {
                case feelsLike = "feels_like"
                case windSpeed = "wind_speed"
                case windDir = "wind_dir"
                case temp
                case condition
                case icon
                
            }
        }
        //MARK: - Forecasts
        struct Forecasts: Codable {
            let parts: Parts
            var hours: [Hours]
        }
        //MARK: - Parts
        struct Parts: Codable {
            let day: Day
            //MARK: - Day
            struct Day: Codable {
                let icon: String
                let precMM: Double
                let tempMax: Int
                let tempMin: Int
                let precProb: Double
                
                private enum CodingKeys: String, CodingKey {
                    case icon
                    case precMM = "prec_mm"
                    case tempMax = "temp_max"
                    case tempMin = "temp_min"
                    case precProb = "prec_prob"
                }
            }
        }
        
        //MARK: - Hourse
        struct Hours: Codable {
            
            let hour: String
            let windSpeed: Double
            let temp: Int
            let feelsLike: Int
            var condition: String
            var windDir: String
            let icon: String
            let precMM: Double
            let precProb: Double
            
            private enum CodingKeys: String, CodingKey {
                case hour
                case feelsLike = "feels_like"
                case windSpeed = "wind_speed"
                case windDir = "wind_dir"
                case temp
                case condition
                case icon
                case precMM = "prec_mm"
                case precProb = "prec_prob"
                
            }
        }
    }
    
}

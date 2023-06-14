//
//  CoreDataManager.swift
//  Weather Now
//
//  Created by user on 01.05.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    //singletone
    static let share = CoreDataManager()
    
    //MARK: - init
    private init() {}
    
    //create container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weather_Now")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK: - NSManagedObjectContext
    lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext
    lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()
    
    //MARK: - queue add and featching weather
    private var queue = DispatchQueue(label: "add and featching weather", qos: .userInteractive)
    
    
    //MARK: - addWeatherInfo
    func addWeatherInfo(model: TableState.Model, name: String) {
        let addWeatheritem = DispatchWorkItem() {
            if name != "" || name != "Город" {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Fact")
                let nsPredicate = NSPredicate(format: "city == %@", name)
                fetchRequest.predicate = nsPredicate
                //если найден найдена погода с названием города, то он обновит ее, иначе он добавит ее
                if let fact = try? self.viewContext.fetch(fetchRequest).first as? Fact {
                    fact.icon = model.fact.icon
                    fact.condition = model.fact.condition
                    fact.feelsLike = Int16(model.fact.feelsLike)
                    fact.temp = Int16(model.fact.temp)
                    fact.windDir = model.fact.windDir
                    fact.windSpeed = model.fact.windSpeed
                    
                    for i in 0..<model.forecasts.count {
                        if let forecast = fact.foreCast?.allObjects as? [ForeCast] {
                            let forecastNew = forecast.first { result in
                                result.id == i
                            }
                            forecastNew?.parts?.day?.icon = model.forecasts[i].parts.day.icon
                            forecastNew?.parts?.day?.precMM = model.forecasts[i].parts.day.precMM
                            forecastNew?.parts?.day?.precProb = model.forecasts[i].parts.day.precProb
                            forecastNew?.parts?.day?.tempMax = Int16(model.forecasts[i].parts.day.tempMax)
                            forecastNew?.parts?.day?.tempMin = Int16(model.forecasts[i].parts.day.tempMin)
                            
                            for j in 0..<(model.forecasts.first?.hours.count ?? 0) {
                                if let hours = forecastNew?.parts?.hours?.allObjects as? [Hours] {
                                    let hoursNew = hours.first { results in
                                        results.id == j
                                    }
                                    hoursNew?.condition = model.forecasts[i].hours[j].condition
                                    hoursNew?.feelsLike = Int16(model.forecasts[i].hours[j].feelsLike)
                                    hoursNew?.temp = Int16(model.forecasts[i].hours[j].temp)
                                    hoursNew?.icon = model.forecasts[i].hours[j].icon
                                    hoursNew?.hour = model.forecasts[i].hours[j].hour
                                    hoursNew?.precProb = model.forecasts[i].hours[j].precProb
                                    hoursNew?.precMM = model.forecasts[i].hours[j].precMM
                                    hoursNew?.windDir = model.forecasts[i].hours[j].windDir
                                    hoursNew?.windSpeed = model.forecasts[i].hours[j].windSpeed
                                }
                            }
                        }
                    }
                } else {
                    let fact = Fact(context: self.viewContext)
                    var foreCastArray: [ForeCast] = []
                    
                    fact.city = name
                    fact.icon = model.fact.icon
                    fact.condition = model.fact.condition
                    fact.feelsLike = Int16(model.fact.feelsLike)
                    fact.temp = Int16(model.fact.temp)
                    fact.windDir = model.fact.windDir
                    fact.windSpeed = model.fact.windSpeed
                    
                    for i in 0..<model.forecasts.count {
                        let foreCast = ForeCast(context: self.viewContext)
                        let parts = Parts(context: self.viewContext)
                        let day = Day(context: self.viewContext)
                        var hoursArray: [Hours] = []
                        
                        //заполнение day
                        foreCast.parts = parts
                        foreCast.id = Int16(i)
                        foreCast.parts?.day = day
                        foreCast.parts?.day?.icon = model.forecasts[i].parts.day.icon
                        foreCast.parts?.day?.precMM = model.forecasts[i].parts.day.precMM
                        foreCast.parts?.day?.precProb = model.forecasts[i].parts.day.precProb
                        foreCast.parts?.day?.tempMax = Int16(model.forecasts[i].parts.day.tempMax)
                        foreCast.parts?.day?.tempMin = Int16(model.forecasts[i].parts.day.tempMin)
                        
                        //создание hours
                        for j in 0..<(model.forecasts.first?.hours.count ?? 24) {
                            let hours = Hours(context: self.viewContext)
                            hours.id = Int16(j)
                            hours.hour = model.forecasts[i].hours[j].hour
                            hours.condition = model.forecasts[i].hours[j].condition
                            hours.feelsLike = Int16(model.forecasts[i].hours[j].feelsLike)
                            hours.icon = model.forecasts[i].hours[j].icon
                            hours.precMM = model.forecasts[i].hours[j].precMM
                            hours.precProb = model.forecasts[i].hours[j].precProb
                            hours.temp = Int16(model.forecasts[i].hours[j].temp)
                            hours.windSpeed = model.forecasts[i].hours[j].windSpeed
                            hours.windDir = model.forecasts[i].hours[j].windDir
                            hoursArray.append(hours)
                        }
                        
                        foreCast.parts?.hours = NSSet(array: hoursArray)
                        foreCastArray.append(foreCast)
                        
                    }
                    fact.foreCast = NSSet(array: foreCastArray)
                }
            }
        }
        
        let saveChanges = DispatchWorkItem { [self] in
            do {
                try self.viewContext.save()
            } catch {
                let nsError = error as NSError
                print("dont save weather \(nsError)")
            }
        }
        
        queue.sync { [self] in
            addWeatheritem.perform()
            addWeatheritem.notify(queue: self.queue, execute: saveChanges)
        }
    }
    
    //MARK: - fetchWeather
    func fetchWeather(name: String) -> TableState.Model? {
        var model: TableState.Model?
        let featchWorkItem = DispatchWorkItem {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Fact")
            let nsPredicate = NSPredicate(format: "city == %@", name)
            fetchRequest.predicate = nsPredicate
            var modelFact: TableState.Model.Fact!
            var modelForecasts: [TableState.Model.Forecasts] = []
            var modelDay: TableState.Model.Parts.Day!
            
            if let fact = try? self.viewContext.fetch(fetchRequest).first as? Fact {
                //создание modelFact
                modelFact = .init(windSpeed: fact.windSpeed, temp: Int(fact.temp), feelsLike: Int(fact.feelsLike), condition: fact.condition ?? "" , windDir: fact.windDir ?? "", icon: fact.icon ?? "")
                if let forecasts = fact.foreCast?.allObjects as? [ForeCast] {
                    for i in 0..<forecasts.count {
                        let forecastNew = forecasts.first { result in
                            result.id == Int16(i)
                        }
                        //cоздание modelDay
                        modelDay = TableState.Model.Parts.Day(icon: forecastNew?.parts?.day?.icon ?? "", precMM: forecastNew?.parts?.day?.precMM ?? 0, tempMax: Int(forecastNew?.parts?.day?.tempMax ?? 0), tempMin: Int(forecastNew?.parts?.day?.tempMin ?? 0), precProb: forecastNew?.parts?.day?.precProb ?? 0)
                        //modelHour
                        var modelHour: [TableState.Model.Hours] = []
                        
                        //создание modelHour
                        if let hours = forecastNew?.parts?.hours?.allObjects as? [Hours] {
                            for j in 0..<hours.count {
                                let hourNew = hours.first { result in
                                    result.id == Int16(j)
                                }
                                let hourForModel = TableState.Model.Hours.init(hour: hourNew?.hour ?? "", windSpeed: hourNew?.windSpeed ?? 0, temp: Int(hourNew?.temp ?? 0), feelsLike: Int(hourNew?.feelsLike ?? 0), condition: hourNew?.condition ?? "", windDir: hourNew?.windDir ?? "", icon: hourNew?.icon ?? "", precMM: hourNew?.precMM ?? 0, precProb: hourNew?.precProb ?? 0)
                                modelHour.append(hourForModel)
                            }
                            let forecastForModel = TableState.Model.Forecasts(parts: TableState.Model.Parts(day: modelDay), hours: modelHour)
                            modelForecasts.append(forecastForModel)
                            
                        }
                    }
                }
                model = TableState.Model(fact: modelFact, forecasts: modelForecasts)
            }
        }
        queue.sync {
            featchWorkItem.perform()
        }
        return model
    }
    //MARK: - removeWeather
    func removeWeather(name: String) {
        DispatchQueue.global(qos: .utility).sync {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Fact")
            let nsPredicate = NSPredicate(format: "city == %@", name)
            deleteFetch.predicate = nsPredicate
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            DispatchQueue.global(qos: .utility).sync { [self] in
                do {
                    try backgroundContext.execute(deleteRequest)
                    try backgroundContext.save()
                } catch {
                    print(error)
                }
                
            }
        }
    }
}

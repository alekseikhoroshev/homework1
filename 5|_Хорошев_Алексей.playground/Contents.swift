import Cocoa

enum carAction{
    case changeEngineState
    case changeWindowsState
    case load(condition: Double)
    case unload(condition: Double)
}

protocol Car{
    var carMark: String {get set}
    var releaseYear: Int {get set}
    var carColor: String {get set}
    var maxCargoVolume: Double {get set}
    var wheelsCount: Int {get set}
    
    var isEngineWork: Bool {get set}
    var isWindowsOpen: Bool {get set}
    var cargoVolume: Double {get set}
    
    func useCarAction(_ action: carAction)
    
}

extension Car{
    func changeEngineState() -> Bool{
        print("\(isEngineWork ? "Глушим двигатель " : "Заводим двигатель" ) \(carMark)")
        return !isEngineWork
    }
    
    func changeWindowsState()-> Bool{
        print("\(isWindowsOpen ? "Закрываем окна " : "Открываем окна" ) в \(carMark)")
        return !isWindowsOpen
    }
    
    func changeCargo(_ loading: Bool, _ value: Double) -> Double{
        var result: Double = 0
        if loading{
            if cargoVolume + value <= maxCargoVolume{
                result = cargoVolume + value
            }else{
                print("Мало места. \((cargoVolume + value) - maxCargoVolume) не удалось затолкать.")
                result = maxCargoVolume
            }
        }else{
            if cargoVolume >= value{
                result = cargoVolume - value
            }
            else{
                print("Удалось выгрузить только \(cargoVolume)")
                result = 0
            }
        }
        return result
    }
}

class trunkCar: Car{
    var carMark: String
    
    var releaseYear: Int
    
    var carColor: String
    
    var maxCargoVolume: Double
    
    var wheelsCount: Int
    
    var isEngineWork: Bool = false
    
    var isWindowsOpen: Bool = false
    
    var cargoVolume: Double = 0
    
    var trailerVolume: Double = 0
    let hasTowingHook: Bool
    
    init(mark: String, year: Int, color: String, maxCargo: Double, wheels: Int, hasHook: Bool){
        self.carMark = mark
        self.releaseYear = year
        self.carColor = color
        self.maxCargoVolume = maxCargo
        self.wheelsCount = wheels
        self.hasTowingHook = hasHook
    }
    
    func useCarAction(_ action: carAction) {
        switch action {
        case .changeEngineState:
            self.isEngineWork = changeEngineState()
        case .changeWindowsState:
            self.isWindowsOpen = changeWindowsState()
        case .load(condition: let volume):
            self.cargoVolume = changeCargo(true, volume)
            
        case .unload(condition: let volume):
            self.cargoVolume = changeCargo(false, volume)
        }
        
    }
    
    func hookTrailer(_ trailerVolume: Double){
        if self.hasTowingHook{
        self.maxCargoVolume += trailerVolume
        self.trailerVolume = trailerVolume
        }else{
            print("Нельзя использовать прицеп")
        }
    }
    
    func dropTrailer(){
        if self.trailerVolume != 0{
        self.maxCargoVolume -= self.trailerVolume
        self.trailerVolume = 0
            if self.cargoVolume > self.maxCargoVolume{
                self.cargoVolume = self.maxCargoVolume
                print("Часть груза осталась в прицепе")
            }
        }else{
            print("Нечего отцеплять")
        }
    }
    
}

struct Person {
    let name: String
    let weight: Double
}

class sportСar: Car{
    var carMark: String
    
    var releaseYear: Int
    
    var carColor: String
    
    var maxCargoVolume: Double
    
    var wheelsCount: Int
    
    var isEngineWork: Bool = false
    
    var isWindowsOpen: Bool = false
    
    var cargoVolume: Double = 0
    
    let maxPassengerCount: Int
    var passengers:[Person] = []
    
    init(mark: String, year: Int, color: String, maxCargo: Double, wheels: Int, maxPassengers: Int){
        self.carMark = mark
        self.releaseYear = year
        self.carColor = color
        self.maxCargoVolume = maxCargo
        self.wheelsCount = wheels
        self.maxPassengerCount = maxPassengers
    }
    
    
    func useCarAction(_ action: carAction) {
        switch action {
        case .changeEngineState:
            self.isEngineWork = changeEngineState()
        case .changeWindowsState:
            self.isWindowsOpen = changeWindowsState()
        case .load(condition: let volume):
            self.cargoVolume = changeCargo(true, volume)
            
        case .unload(condition: let volume):
            self.cargoVolume = changeCargo(false, volume)
        }
        
    }
    
    func seat(_ person: Person){
        if passengers.count == self.maxPassengerCount{
            print("Нет свободных мест")
        }
        if self.cargoVolume + person.weight > self.maxCargoVolume{
            print("Перегруз, \(self.carMark) не поедет")
        }
        self.passengers.append(person)
        self.cargoVolume += person.weight
        print("\(person.name) сел в машину")
    }
    
    func leaveCar(_ person: Person){
        if passengers.count == 0 || !passengers.contains(where: {$0.name == person.name && $0.weight == person.weight}){
            print("\(person.name) не в машине")
        }
        let index = self.passengers.firstIndex(where: {$0.name == person.name && $0.weight == person.weight})
        self.passengers.remove(at: index!)
        self.cargoVolume -= person.weight
        print("\(person.name) покинул \(self.carMark)")
    }
    
    func printPassengers(){
        if self.passengers.count > 0{
        for person in self.passengers{
            print("\(person.name)")
        }
        }else{
            print("В машине никого нет")
        }
    }
    
}

extension trunkCar: CustomStringConvertible{
    var description: String {
        return "\(self.carColor)  \(self.carMark) \(self.releaseYear) имеет \(self.wheelsCount)  колес(а), может везти \(self.maxCargoVolume) груза. Сейчас загружено \(self.cargoVolume), двигатель \(self.isEngineWork ? "работает" : "выключен") окна \(self.isWindowsOpen ? "открыты" : "закрыты") \(self.hasTowingHook ? self.trailerVolume != 0 ? ", есть прицеп, объемом \(self.trailerVolume)" : ", нет прицепа" : "")"
    }
    

}

extension sportСar: CustomStringConvertible{
    var description: String {
        return "\(self.carColor)  \(self.carMark) \(self.releaseYear) имеет \(self.wheelsCount)  колес(а), может везти \(self.maxCargoVolume) груза. Сейчас загружено \(self.cargoVolume), двигатель \(self.isEngineWork ? "работает" : "выключен") окна \(self.isWindowsOpen ? "открыты" : "закрыты"). Может везти \(self.maxPassengerCount) человек(а). Сейчас в машине \(passengers.count) человек(а)."
    }
    
    
}

var veryBigTruck = trunkCar(mark: "MAN", year: 2006, color: "Серый", maxCargo: 15, wheels: 8, hasHook: false)

var parovoz = trunkCar(mark: "П36-001", year: 1950, color: "Зеленый", maxCargo: 6, wheels: 8, hasHook: true)

var someCar = sportСar(mark: "Honda", year: 2017, color: "Желтый", maxCargo: 3, wheels: 4, maxPassengers: 2)

var electroCar = sportСar(mark: "Tesla", year: 2021, color: "Синий", maxCargo: 3, wheels: 4, maxPassengers: 5)


print(veryBigTruck)
veryBigTruck.useCarAction(.changeEngineState)
veryBigTruck.hookTrailer(10)
veryBigTruck.useCarAction(.load(condition: 12))
print(veryBigTruck)

print(parovoz)
parovoz.hookTrailer(40)
parovoz.useCarAction(.load(condition: 35))
print(parovoz)
parovoz.useCarAction(.unload(condition: 6))
print(parovoz)
parovoz.dropTrailer()
print(parovoz)


print(someCar)
someCar.useCarAction(.changeEngineState)
someCar.useCarAction(.changeWindowsState)
someCar.seat(Person(name: "Себастьян", weight: 0.6))
print(someCar)


print(electroCar)
electroCar.useCarAction(.changeEngineState)
electroCar.useCarAction(.changeWindowsState)
electroCar.seat(Person(name: "Себастьян", weight: 0.6))
electroCar.seat(Person(name: "Мария", weight: 0.4))
print(electroCar)
electroCar.seat(Person(name: "Антон", weight: 0.5))
electroCar.seat(Person(name: "Гриша", weight: 0.5))
electroCar.seat(Person(name: "Маша", weight: 0.7))
print(electroCar)
electroCar.printPassengers()
electroCar.useCarAction(.load(condition: 1))
electroCar.leaveCar(electroCar.passengers[3])
print(electroCar)
electroCar.printPassengers()

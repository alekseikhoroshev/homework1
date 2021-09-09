import Cocoa

class Car{
    enum tireType: String{
        case summer = "Летняя"
        case winter = "Зимняя"
        case combined = "Гибридная"
        case none = ""
    }
    
    enum engineType: String{
        case gas = "Бензиновый"
        case diesel = "Дизельный"
        case electro = "Электрический"
        case steam = "Паровой"
    }
    
    let carMark: String
    let releaseYear: Int
    var carColor: String
    var maxCargoVolume: Double
    let wheelsCount: Int
    var wheelsTire: tireType
    var engine: engineType
    
    var isEngineWork: Bool = false
    var isWindowsOpen: Bool = false
    var cargoVolume: Double = 0.0
    
    init(mark: String, year: Int, color: String, maxCargo: Double, wheels: Int, tire: tireType, engine: engineType){
        self.carMark = mark
        self.releaseYear = year
        self.carColor = color
        self.maxCargoVolume = maxCargo
        self.wheelsCount = wheels
        self.wheelsTire = tire
        self.engine = engine
    }
    
    func carAction(_ action: carBasicActions){
        
    }
    
    func printCarInfo(){
        print("\(self.carColor)  \(self.carMark) \(self.releaseYear) имеет \(self.wheelsCount)  колес(а), \(self.wheelsTire != .none ? "резина " + self.wheelsTire.rawValue : "") тип двигателя \(self.engine.rawValue) может везти \(self.maxCargoVolume) груза. Сейчас загружено \(self.cargoVolume), двигатель \(self.isEngineWork ? "работает" : "выключен") окна \(self.isWindowsOpen ? "открыты" : "закрыты")")
    }
    
}

struct Person {
    let name: String
    let weight: Double
}

enum carBasicActions{
    case activateDrive
    case shutDownDrive
    case openWindows
    case closeWindows
    case load(condition: Double)
    case unload(condition: Double)
    
    case seat(condition: Person)
    case leaveCar(condition: Person)
    
    case useBodyworkLift
    case hookTrailer(condition: Double)
    case dropTrailer
}

class TrunkCar: Car{
    var isBodyworkLifted: Bool = false {willSet{
        print("Кузов \(newValue ? "поднят" : "опущен")")
        if newValue{
            self.cargoVolume = 0
            print("Весь груз вывалился")
        }
    }}
    var trailerVolume: Double = 0
    let hasTowingHook: Bool
    
    init(mark: String, year: Int, color: String, maxCargo: Double, wheels: Int, tire: tireType, engine: engineType, hook: Bool) {
        self.hasTowingHook = hook
        super.init(mark: mark, year: year, color: color, maxCargo: maxCargo, wheels: wheels, tire: tire, engine: engine)
        
    }
    
    override func printCarInfo() {
        super.printCarInfo()
        print("В данный момент кузов \(self.isBodyworkLifted ? "поднят" : "опущен"), \(self.hasTowingHook ? self.trailerVolume != 0 ? " есть прицеп, объемом \(self.trailerVolume)" : "нет прицепа" : "")")
    }
    
    override func carAction(_ action: carBasicActions) {
        switch action {
        case .activateDrive:
            self.isEngineWork = true
        case .shutDownDrive:
            self.isEngineWork = false
        case .openWindows:
            self.isWindowsOpen = true
        case .closeWindows:
            self.isWindowsOpen = false
        case .load(condition: let volume):
            if isBodyworkLifted{
                print("Кузов поднят, погрузка невозможна")
                break
            }
            if self.cargoVolume + volume > self.maxCargoVolume{
                print("Погружено \(self.maxCargoVolume - self.cargoVolume) Не уместилось \((self.cargoVolume + volume) - self.maxCargoVolume)")
                self.cargoVolume = self.maxCargoVolume
                break
            }
            self.cargoVolume += volume
            print("Погружено \(volume)")
        case .unload(condition: let volume):
            if self.cargoVolume - volume < 0{
                self.cargoVolume = 0
                print("Удалось выгрузить только \(self.cargoVolume)")
                break
            }
            self.cargoVolume -= volume
            print("Выгружено \(volume)")
            
        case .useBodyworkLift:
            self.isBodyworkLifted = !self.isBodyworkLifted
            print("Кузов \(self.isBodyworkLifted ? "поднят" : "опущен")")
            
        case .hookTrailer(condition: let trailerVolume):
            if self.hasTowingHook{
            self.maxCargoVolume += trailerVolume
            self.trailerVolume = trailerVolume
            }else{
                print("Нельзя использовать прицеп")
                break
            }
        case .dropTrailer:
            if self.trailerVolume != 0{
            self.maxCargoVolume -= self.trailerVolume
            self.trailerVolume = 0
                if self.cargoVolume > self.maxCargoVolume{
                    self.cargoVolume = self.maxCargoVolume
                }
            }else{
                print("Нечего отцеплять")
                break
            }
        default :
            print("недоступное действие")
        }
    }
}

class SportCar: Car{
    let maxPassengerCount: Int
    var passengers:[Person] = []
    
    init(mark: String, year: Int, color: String, maxCargo: Double, wheels: Int, tire: tireType, engine: engineType, passengers: Int) {
        self.maxPassengerCount = passengers
        super.init(mark: mark, year: year, color: color, maxCargo: maxCargo, wheels: wheels, tire: tire, engine: engine)
        
    }
    
    override func carAction(_ action: carBasicActions) {
        switch action {
        case .activateDrive:
            self.isEngineWork = true
        case .shutDownDrive:
            self.isEngineWork = false
        case .openWindows:
            self.isWindowsOpen = true
        case .closeWindows:
            self.isWindowsOpen = false
        case .seat(condition: let person):
            if passengers.count == self.maxPassengerCount{
                print("Нет свободных мест")
                break
            }
            if self.cargoVolume + person.weight > self.maxCargoVolume{
                print("Перегруз, \(self.carMark) не поедет")
                break
            }
            self.passengers.append(person)
            self.cargoVolume += person.weight
            print("\(person.name) сел в машину")
        case .leaveCar(condition: let person):
            if passengers.count == 0 || !passengers.contains(where: {$0.name == person.name && $0.weight == person.weight}){
                print("\(person.name) не в машине")
                break
            }
            let index = self.passengers.firstIndex(where: {$0.name == person.name && $0.weight == person.weight})
            self.passengers.remove(at: index!)
            self.cargoVolume -= person.weight
            print("\(person.name) покинул \(self.carMark)")
        default :
            print("недоступное действие")
        }
    }
    
    override func printCarInfo() {
        super.printCarInfo()
        print("Может везти \(self.maxPassengerCount) человек(а). Сейчас в машине \(passengers.count) человек(а).")
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

var veryBigTruck = TrunkCar(mark: "MAN", year: 2006, color: "Серый", maxCargo: 15, wheels: 8, tire: .summer, engine: .diesel, hook: false)

var parovoz = TrunkCar(mark: "П36-001", year: 1950, color: "Зеленый", maxCargo: 6, wheels: 8, tire: .none, engine: .steam, hook: true)

var someCar = SportCar(mark: "Honda", year: 2017, color: "Желтый", maxCargo: 3, wheels: 4, tire: .summer, engine: .gas, passengers: 2)

var electroCar = SportCar(mark: "Tesla", year: 2021, color: "Синий", maxCargo: 3, wheels: 4, tire: .combined, engine: .electro, passengers: 5)

veryBigTruck.printCarInfo()
veryBigTruck.carAction(.activateDrive)
veryBigTruck.carAction(.hookTrailer(condition: 10))
veryBigTruck.carAction(.load(condition: 12))
veryBigTruck.printCarInfo()

parovoz.printCarInfo()
parovoz.carAction(.hookTrailer(condition: 40))
parovoz.carAction(.load(condition: 35))
parovoz.printCarInfo()
parovoz.carAction(.unload(condition: 6))
parovoz.printCarInfo()
parovoz.carAction(.dropTrailer)
parovoz.printCarInfo()


someCar.printCarInfo()
someCar.carAction(.activateDrive)
someCar.carAction(.openWindows)
someCar.carAction(.seat(condition: Person(name: "Себастьян", weight: 0.6)))
someCar.printCarInfo()


electroCar.printCarInfo()
electroCar.carAction(.activateDrive)
electroCar.carAction(.openWindows)
electroCar.carAction(.seat(condition: Person(name: "Себастьян", weight: 0.6)))
electroCar.carAction(.seat(condition: Person(name: "Мария", weight: 0.4)))
electroCar.printCarInfo()
electroCar.carAction(.seat(condition: Person(name: "Антон", weight: 0.5)))
electroCar.carAction(.seat(condition: Person(name: "Гриша", weight: 0.5)))
electroCar.carAction(.seat(condition: Person(name: "Маша", weight: 0.7)))
electroCar.printCarInfo()
electroCar.printPassengers()
electroCar.carAction(.load(condition: 1))
electroCar.carAction(.leaveCar(condition: electroCar.passengers[3]))
electroCar.printCarInfo()
electroCar.printPassengers()

import Cocoa

var cargo: Double = 1.25

struct SportCar{
    let carMark: String
    let releaseYear: Int
    let carColor: String
    let maxCargoVolume: Double
    
    var isDriveActive: Bool = false {willSet{
        print("Двигатель \(newValue ? "запущен" : "выключен")")
        if !isSeatBeltFasten && newValue{
            print("!!! Вы не пристегнуты !!!")
        }
    }}
    var isWindowsOpen: Bool = false {willSet{
        print("Окна \(newValue ? "открыты" : "закрыты")")
    }}
    var cargoVolume: Double = 0
    
    var isConditionerWork: Bool = false {willSet{
        print("Кондиционер \(newValue ? "включен" : "выключен")")}}
    var isRadioWork: Bool = false {willSet{
        print("Радио \(newValue ? "включено" : "выключено")")}}
    var isSeatBeltFasten: Bool = false {willSet{
        print("Ремень безопасности \(newValue ? "пристегнут" : "не пристегнут")")}}
    
    init(_ mark: String, _ releaseYear: Int, _ color: String, maxCargo: Double) {
        self.carMark = mark
        self.releaseYear = releaseYear
        self.carColor = color
        self.maxCargoVolume = maxCargo
    }
    
    enum specificActions{
        case activateConditioner
        case deactivateConditioner
        case activateRadio
        case deactivateRadio
        case useSeatBelt
    }
    
    enum actions{
        case basic(condition: carBasicActions)
        case specific(condition: specificActions)
    }
    
    mutating func useAction(_ action: actions){
        switch action {
        case .basic(condition: let basicAction):
            switch basicAction {
            case .activateDrive:
                self.isDriveActive = true
            case .shutDownDrive:
                self.isDriveActive = false
            case .openWindows:
                self.isWindowsOpen = true
            case .closeWindows:
                self.isWindowsOpen = false
            case .load(condition: let volume):
                if self.cargoVolume + volume > self.maxCargoVolume{
                    self.cargoVolume = self.maxCargoVolume
                    print("Не уместилось \((self.cargoVolume + volume) - self.maxCargoVolume)")
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
            }
            
        case .specific(condition: let specAction):
            switch specAction {
            case .activateConditioner:
                self.isConditionerWork = true
            case .deactivateConditioner:
                self.isConditionerWork = false
            case .activateRadio:
                self.isRadioWork = true
            case .deactivateRadio:
                self.isRadioWork = false
            case .useSeatBelt:
                self.isSeatBeltFasten = !self.isSeatBeltFasten
            }
        }
        
    }
}

struct TrunkCar{
    let carMark: String
    let releaseYear: Int
    let carColor: String
    let maxCargoVolume: Double
   // let maxCargoWeight: Double
    
    var isDriveActive: Bool = false {willSet{
        print("Двигатель \(newValue ? "запущен" : "выключен")")
    }}
    var isWindowsOpen: Bool = false {willSet{
        print("Окна \(newValue ? "открыты" : "закрыты")")
    }}
    var cargoVolume: Double = 0
    
    var isBodyworkLifted: Bool = false {willSet{
        print("Кузов \(newValue ? "поднят" : "опущен")")
        if newValue{
            self.cargoVolume = 0
            print("Весь груз вывалился")
        }
    }}
    
    init(_ mark: String, _ releaseYear: Int, _ color: String, maxCargo: Double) {
        self.carMark = mark
        self.releaseYear = releaseYear
        self.carColor = color
        self.maxCargoVolume = maxCargo
    }
    
    enum specificActions{
        case useBodyworkLift
    }
    
    enum actions{
        case basic(condition: carBasicActions)
        case specific(condition: specificActions)
    }
    
    mutating func useAction(_ action: actions){
        switch action {
        case .basic(condition: let basicAction):
            switch basicAction {
            case .activateDrive:
                self.isDriveActive = true
            case .shutDownDrive:
                self.isDriveActive = false
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
            }
            
        case .specific(condition: let specAction):
            switch specAction {
            case .useBodyworkLift:
                self.isBodyworkLifted = !self.isBodyworkLifted
            }
        }
        
    }
}

enum carBasicActions{
    case activateDrive
    case shutDownDrive
    case openWindows
    case closeWindows
    case load(condition: Double)
    case unload(condition: Double)
}



var sportCar = SportCar("Honda", 2017, "Зелёная", maxCargo: 0.75)
var truck = TrunkCar("MAN", 1994, "Серый", maxCargo: 12)

print("\(sportCar.carColor) \(sportCar.carMark) \(sportCar.releaseYear) года")
sportCar.useAction(.basic(condition: .activateDrive))
sportCar.useAction(.basic(condition: .shutDownDrive))
sportCar.useAction(.specific(condition: .useSeatBelt))
sportCar.useAction(.basic(condition: .activateDrive))
sportCar.useAction(.basic(condition: .openWindows))
sportCar.useAction(.specific(condition: .activateConditioner))
sportCar.useAction(.specific(condition: .activateRadio))
sportCar.useAction(.specific(condition: .deactivateRadio))
print()

print("\(truck.carColor) \(truck.carMark) \(truck.releaseYear) года")
truck.useAction(.basic(condition: .activateDrive))
truck.useAction(.basic(condition: .load(condition: 8)))
truck.useAction(.basic(condition: .unload(condition: 2)))
truck.useAction(.basic(condition: .load(condition: 8)))
truck.useAction(.specific(condition: .useBodyworkLift))
truck.useAction(.basic(condition: .load(condition: 8)))
truck.useAction(.specific(condition: .useBodyworkLift))
truck.useAction(.basic(condition: .load(condition: 4)))
truck.useAction(.basic(condition: .shutDownDrive))
truck.useAction(.basic(condition: .openWindows))

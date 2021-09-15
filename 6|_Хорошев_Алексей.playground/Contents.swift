import Cocoa

struct universalQueue<T> {
    private var queueElements: [T] = []
    
    mutating func push(_ element: T) {
        queueElements.append(element)
    }
    
    mutating func pop() -> T? {
        return queueElements.removeFirst()
    }
    
    func empty() -> Bool {
        return queueElements.count == 0
    }
    
    func size() ->Int {
        return queueElements.count
    }
    
    subscript(_ index: Int) -> String?{
        if index < queueElements.count{
            return "\(index + 1 <= queueElements.count/2 ? "Скоро покинет очередь" : "Подождет еще немного")"
        }
        return nil
    }
}


struct Passenger {
    var name: String
    var hasTicket: Bool
}

func addPassenger(_ queue: inout universalQueue<Passenger>, _ person: Passenger){
    if person.hasTicket{
        queue.push(person)
        return
    }
    print("\(person.name) не может встать в очередь без билета.")
}

var numbersQueue = universalQueue<Double>()
var stringQueue = universalQueue<String>()
var busStopQueue = universalQueue<Passenger>()

numbersQueue.push(1)
numbersQueue.push(3)
numbersQueue.push(9)
numbersQueue.push(2.15)
print(numbersQueue.size())
let lastIndex = !numbersQueue.empty() ? numbersQueue.size()-1 : 0
print(numbersQueue[lastIndex] ?? "не в очереди")
print(numbersQueue.pop() ?? "не удалось извлечь")
print(numbersQueue.size())
print(numbersQueue[lastIndex] ?? "не в очереди")

stringQueue.push("Карл")
stringQueue.push("у")
stringQueue.push("Клары")
stringQueue.push("Украл")
stringQueue.push("Кораллы")
stringQueue.size()

while !stringQueue.empty(){
    print(stringQueue.pop() ?? "")
}


addPassenger(&busStopQueue, Passenger(name: "Иван", hasTicket: true ))
addPassenger(&busStopQueue, Passenger(name: "Маша", hasTicket: true ))
addPassenger(&busStopQueue, Passenger(name: "Аристарх", hasTicket: true ))
busStopQueue.push(Passenger(name: "Антошка", hasTicket: false )) //добавляем безбилетника
addPassenger(&busStopQueue, Passenger(name: "Жорик", hasTicket: true ))
addPassenger(&busStopQueue, Passenger(name: "Вася", hasTicket: true ))

print(busStopQueue[2] != nil ? "Пассажир №3 \(busStopQueue[2]!)" : "В очереди нет пассажира №3")
print(busStopQueue[3] != nil ? "Пассажир №4 \(busStopQueue[3]!)" : "В очереди нет пассажира №4")
print(busStopQueue[6] != nil ? "Пассажир №7 \(busStopQueue[6]!)" : "В очереди нет пассажира №7")


while !busStopQueue.empty(){
    if let passenger = busStopQueue.pop(){
        print("\(passenger.hasTicket ? "\(passenger.name) вошел(а) в автобус" : "\(passenger.name) изгнан(а) кондуктором")")
        print("В очереди еще ", busStopQueue.size(), " пассажиов")
    }
}

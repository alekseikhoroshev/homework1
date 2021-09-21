import Cocoa


enum storageError: Error{
    case lostConnection
    case unknownFormat
    case invalidFileSize
    case duplicateFile
    case fileNotLoaded
    case emptyFileName
    case fileNotFound
}

enum validFormats: String{
    case png = "png"
    case text = "txt"
    case swift = "swift"
    case mp3 = "mp3"
    case mp4 = "mp4"
    case doc = "doc"
}

enum netState{
    case connected
    case disconnected
}

struct StoredFile{
    var name: String
    var size: Double
    var format: String
}

struct StoredItem{
    var name: String
    var file: StoredFile
}

class FileStorage{
    var maxSize:Double = 256
    var networkStatus: netState = .connected
    
    var storage = [StoredItem(name: "flover.png", file: StoredFile(name: "flover", size: 24, format: "png")), StoredItem(name: "veryBoringPoem.txt", file: StoredFile(name: "veryBoringPoem", size: 59, format: "txt")),
                   StoredItem(name: "hello_world.swift", file: StoredFile(name: "hello_world", size: 9, format: "swift")), StoredItem(name: "SaberDance.mp3", file: StoredFile(name: "SaberDance", size: 52, format: "mp3"))
    ]
    
    func upLoadFile(_ file:StoredFile?) ->storageError?{
        guard let storageItem = file else{return .fileNotLoaded}
        
        guard storageItem.name.count > 0 else{return .emptyFileName}
        guard storageItem.size <= maxSize else{return .invalidFileSize}
        guard validFormats(rawValue: storageItem.format) != nil else{return .unknownFormat}
        guard networkStatus == .connected else{return .lostConnection}
        if let _ = storage.first(where: {$0.name == "\(storageItem.name).\(storageItem.format)"}){
            return .duplicateFile
        }
        storage.append(StoredItem(name: "\(storageItem.name).\(storageItem.format)", file: storageItem))
        return nil
    }
    
    func downLoadFile(_ fileName: String, fileFormat: validFormats) ->(StoredFile?, storageError?){
        guard networkStatus == .connected else{return (nil, .lostConnection)}
        
        guard let storedItem = storage.first(where: {$0.name == "\(fileName).\(fileFormat.rawValue)"})else{return (nil, .fileNotFound)}
        
        return (storedItem.file, nil)
    }
}

let myCloudStorage = FileStorage()

let file1 = myCloudStorage.downLoadFile("flover", fileFormat: validFormats.png)

myCloudStorage.networkStatus = .disconnected

let file2 = myCloudStorage.downLoadFile("SaberDance", fileFormat: .mp3)

myCloudStorage.networkStatus = .connected

let file3 = myCloudStorage.downLoadFile("RandomFileName", fileFormat: .text)

if let error = myCloudStorage.upLoadFile(StoredFile(name: "photo_2021_05_01", size: 15, format: "png")){
    print("Произошла ошибка: \(error.localizedDescription)")

}else{
    print("Файл загружен")
}

if let error = myCloudStorage.upLoadFile(StoredFile(name: "myRoom", size: 674, format: "mp4")){
    print("Произошла ошибка: \(error.localizedDescription)")

}else{
    print("Файл загружен")
}

if let error = myCloudStorage.upLoadFile(StoredFile(name: "fatCat", size: 254, format: "psd")){
    print("Произошла ошибка: \(error.localizedDescription)")

}else{
    print("Файл загружен")
}

if let error = myCloudStorage.upLoadFile(nil){
    print("Произошла ошибка: \(error.localizedDescription)")

}else{
    print("Файл загружен")
}

if let error = myCloudStorage.upLoadFile(StoredFile(name: "", size: 55, format: "doc")){
    print("Произошла ошибка: \(error.localizedDescription)")

}else{
    print("Файл загружен")
}

if let error = myCloudStorage.upLoadFile(file1.0){
    print("Произошла ошибка: \(error.localizedDescription)")

}else{
    print("Файл загружен")
}



struct Empoyee{
    var name: String
    var role: String
    var securityCode: String
    var inLaboratory: Bool
}

enum EmployeeError: Error{
    case employeeNotFound
    case invalidCode
    case alert
}


class LaboratoryEmployees{
    
    var masterCode = "37KHkld93J9783_jd222sDjRoV863"
    
    private var employees = [Empoyee(name: "Антон Геннадьевич", role: "Профессор", securityCode: "27лр90В2", inLaboratory: false), Empoyee(name: "Гриша", role: "Лаборант", securityCode: "ла3892ВВ", inLaboratory: false), Empoyee(name: "Алевтина", role: "СНС", securityCode: "7210473И", inLaboratory: false), Empoyee(name: "Маша", role: "МНС", securityCode: "СМ712ВЗ9", inLaboratory: false)
    ]
    
    func move(_ name: String, _ code: String, goInto: Bool) throws -> String{
        guard var employee = employees.first(where: {name == $0.name})else{
            throw EmployeeError.employeeNotFound
        }
        guard employee.securityCode == code else{
            throw EmployeeError.invalidCode
        }
        
        guard employee.inLaboratory == goInto else{
            throw EmployeeError.alert
        }
        
        let index = employees.firstIndex(where: {$0.securityCode == code})
        employee.inLaboratory = goInto
        employees[index!] = employee
        return "\(employee.role) \(employee.name) вошел в лабораторию"
        
    }
    
    func getProfile(_ name: String)throws -> Empoyee{
        guard let employee = employees.first(where: {name == $0.name})else{
            throw EmployeeError.employeeNotFound
        }
        
        return employee
    }
    
    func setNewRole(_ name: String, code: String, role: String) throws {
        guard var employee = employees.first(where: {name == $0.name})else{
            throw EmployeeError.employeeNotFound
        }
        
        guard code == masterCode else{throw EmployeeError.alert}
        
        let index = employees.firstIndex(where: {$0.securityCode == employee.securityCode})
        employee.role = role
        employees[index!] = employee
    }
}

let labNumber1 = LaboratoryEmployees()

do {
    let move1 = try labNumber1.move("Антон Геннадьевич", "27лр90В2", goInto: true)
    print(move1)
}catch EmployeeError.employeeNotFound{
    print("Сотрудник не найден")
}catch EmployeeError.invalidCode{
    print("Не верный код")
}catch EmployeeError.alert{
    print("Недопустимое действие, вызов охраны")
}
                                                             
do {
    let move2 = try labNumber1.move("Антон Геннадьевич", "27лр90В2", goInto: false)
    print(move2)
}catch EmployeeError.employeeNotFound{
    print("Сотрудник не найден")
}catch EmployeeError.invalidCode{
    print("Не верный код")
}catch EmployeeError.alert{
    print("Недопустимое действие, вызов охраны")
}

do {
    let move3 = try labNumber1.move("Гриша", "ла3892ВВ", goInto: false)
    print(move3)
}catch EmployeeError.employeeNotFound{
    print("Сотрудник не найден")
}catch EmployeeError.invalidCode{
    print("Не верный код")
}catch EmployeeError.alert{
    print("Недопустимое действие, вызов охраны")
}

do {
    let move4 = try labNumber1.move("Маша", "ла3892ВВ", goInto: false)
    print(move4)
}catch EmployeeError.employeeNotFound{
    print("Сотрудник не найден")
}catch EmployeeError.invalidCode{
    print("Не верный код")
}catch EmployeeError.alert{
    print("Недопустимое действие, вызов охраны")
}

do {
    let getProfile = try labNumber1.getProfile("Маша")
    print("\(getProfile.name) \(getProfile.role)")
}catch EmployeeError.employeeNotFound{
    print("Сотрудник не найден")
}

do {
    _ = try labNumber1.setNewRole("Перт Иванович", code: "37KHkld93J9783_jd222sDjRoV863", role: "Лаборант")
}catch EmployeeError.employeeNotFound{
    print("Сотрудник не найден")
}catch EmployeeError.alert{
    print("У вас нет доступа. Вызов охраны")
}

do {
    _ = try labNumber1.setNewRole("Маша", code: "37KHkld93J9783_jd222sDjRoV8d3", role: "Лаборант")
}catch EmployeeError.employeeNotFound{
    print("Сотрудник не найден")
}catch EmployeeError.alert{
    print("У вас нет доступа. Вызов охраны")
}


do {
    _ = try labNumber1.setNewRole("Маша", code: "37KHkld93J9783_jd222sDjRoV863", role: "СНС")
}catch EmployeeError.employeeNotFound{
    print("Сотрудник не найден")
}catch EmployeeError.alert{
    print("У вас нет доступа. Вызов охраны")
}


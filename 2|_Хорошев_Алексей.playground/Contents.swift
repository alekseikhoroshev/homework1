import Cocoa

//Задание 1
print("Задание 1")

func evenNumbered(_ number: Int)-> Bool{
    return number % 2 == 0
}

let numberToCheck = 4

print("Введенное число \(evenNumbered(numberToCheck) ? "четное" : "нечетное")")


//Задание 2
print("Задание 2")


func canDivideToThree(_ number: Int)-> Bool{
    return number % 3 == 0
}

let numberToDivide = 4

print("Введенное число \(canDivideToThree(numberToDivide) ? "делится без остатка на 3" : "не делится без остатка на 3")")



//Задание 3
print("Задание 3")

var arrayOfNumbers: [Int]
arrayOfNumbers = [1]

func createArray(){
    var n = 2
    while arrayOfNumbers.count < 100 {
        let element = 2*n - 1
        arrayOfNumbers.append(element)
        n+=1
    }
}
createArray()
print(arrayOfNumbers)


//Задание 4
print("Задание 4")

var arrayForRemove: [Int] = []

for item in arrayOfNumbers{
    if evenNumbered(item) || !canDivideToThree(item){
        arrayForRemove.append(item)
    }
}

var resultArray = Array(Set(arrayOfNumbers).subtracting(Set(arrayForRemove))).sorted()

print("Редактированный массив")
print(resultArray)



//Задание 5
print("Задание 5")
var arrayFib: [Int] = [0,1]

func addFibonachchi(){
    let index = arrayFib.count - 1
    let newElement = arrayFib[index] + arrayFib[index - 1]
    arrayFib.append(newElement)
}

for _ in 1...50{
    addFibonachchi()
}

print(arrayFib)



//Задание 6
print("Задание 6")

var arraySimple: [Int] = []
var numbersPage: [Int] = []
var numbersForRemove: [Int] = []
var p = 2
// Число с которого начинается выборка
var firstInPage = 2
//Количество элементов в выборке. Ставлю 1000 чтобы точно набралось искомое количество простых чисел
var n = 1000
    //заполняю выборку натуральными числами
    for i in firstInPage...n{
        numbersPage.append(i)
    }
    //Ищу простые числа пока это возможно
    while numbersPage.last != p {
        for j in stride(from: p+p, through: n, by: p){
            if let itemForRemoveIndex = numbersPage.firstIndex(of: j){
                numbersForRemove.append(numbersPage[itemForRemoveIndex])
            }
            //numbersPage.remove(at: numbersPage.firstIndex(of: j)!)
        }
        numbersPage = Array(Set(numbersPage).subtracting(Set(numbersForRemove))).sorted()
        p = numbersPage.first(where:{ $0 > p}) ?? firstInPage
        numbersForRemove = []
    }
    
    //Записываю найденные числа в массив
    for elem in numbersPage{
        if arraySimple.count < 100{
            arraySimple.append(elem)
        }else{
            break
        }
    }


print("Простые числа: ",arraySimple)


//Задание 7
print("Задание 7 Дополнительное")
print("Преобразование строки в массив")

let testString = "1,7,8,3,4,6,4,8,7,9,7,8,3,3,6,3"
let chars = testString.components(separatedBy: ",")
let numbers = chars.map{Int($0) ?? 0}

print(numbers)

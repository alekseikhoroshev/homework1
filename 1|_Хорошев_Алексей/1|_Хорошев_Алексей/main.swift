//
//  main.swift
//  1|_Хорошев_Алексей
//
//  Created by Хорошев Алексей on 25.08.2021.
//

import Foundation

/*Задание 1
Решить квадратное уравнение.
*/

// Коэффициенты уравнения
let a = 3
let b = 7
let c = -6

//прерменные для ранения коэффициента k и дискриминанта
var k: Double?
var D:Double = 0

//корни уравнения
var x1 = 0.0
var x2 = 0.0

print("Задание 1")

//Определяем метод для решения уравнения и вычисляем дисикиминант
if b % 2 == 0 {
    k = Double(b/2)
    print("k:= \(k ?? 0)")
    setD()
}else{
    setD()
}

//Вычисляем корни уравнения
findX()

//функция для вычисления дискриминанта
func setD(){
    if let valueK = k{
        D = pow(valueK, 2) - Double(a * c)
    }else{
        D = pow(Double(b), 2) - Double(4 * a * c)
    }
    
    print("Дискриминант:= \(D)")
}

//Функция для нахождения корней уравнения
func findX(){
    if let valueK = k{
        if D > 0 {
            print("Дискриминант больше 0. Уравнение имеет 2 корня")
            x1 = (Double(-valueK) + sqrt(Double(D))) / Double(a)
            x2 = (Double(-valueK) - sqrt(Double(D))) / Double(a)
            print("x1:= \(x1)")
            print("x2:= \(x2)")
        }else if D == 0{
            print("Дискриминант равен 0. Уравнение имеет 1 корень")
            x1 = -valueK / Double(a)
            print("x1:= \(x1)")
        }else{
            print("Дискриминант меньше 0. Корней нет")
        }
    }else{
        if D > 0 {
            print("Дискриминант больше 0. Уравнение имеет 2 корня")
            x1 = (Double(-b) + sqrt(Double(D))) / Double((2 * a))
            x2 = (Double(-b) - sqrt(Double(D))) / Double((2 * a))
            print("x1:= \(x1)")
            print("x2:= \(x2)")
        }else if D == 0{
            print("Дискриминант равен 0. Уравнение имеет 1 корень")
            x1 = Double(-b) / (2 * Double(a))
            print("x1:= \(x1)")
        }else{
            print("Дискриминант меньше 0. Корней нет")
        }
        
    }
}

/*
Задание 2
Даны катеты прямоугольного треугольника. Найти площадь, периметр и гипотенузу треугольника.
*/

//Даны катеты треугольника
let catA = 3.0
let catB = 4.0

//Вычисляем площадь треугольника, так как угол между катетими прямой, площадь можно вычистить как половину площади треугольника
let S = (catA * catB)/2

//Вычисляем гипотенузу по теореме Пифагора
let g = sqrt((pow(catA, 2) + pow(catB, 2)))

//Вычисляем периметр треугольника
let P = catA + catB + g

print()
print("Задание 2")

//Выводим результат
print("Катет a:= \(catA)")
print("Катет b:= \(catB)")
print("Гипотенуза c:= \(g)")
print("Площадь треугольника S:= \(S)")
print("Периметр треугольника P:= \(P)")


/*
Задание 3
 Пользователь вводит сумму вклада в банк и годовой процент. Найти сумму вклада через 5 лет.
*/

print()
print("Задание 3")

print("Введите сумму вклада: ")
let summ = Double(readLine() ?? "0.0")

print("Введите годовой процент: ")
let yearPercent = Double(readLine() ?? "0.0")

if var clientSumm = summ, let percent = yearPercent {
    for _ in 1...5 {
        clientSumm += ((clientSumm/100)*percent)
    }
    
    print("Итоговая сумма вычисяемая простым циклом: \(clientSumm)")
}



var calendar = Calendar.current
var daysCount = 0
var date = Date()

if var clientSumm = summ, let percent = yearPercent {
    for _ in 1...5 {
        let range = calendar.range(of: .day, in: .year, for: date)
        daysCount = range?.count ?? 0
        date = calendar.date(byAdding: .year, value: 1, to: date)!
        
        clientSumm += (clientSumm * percent * Double(daysCount)/365)/100
    }
    print("Проверка вычисления с использованием формулы: \(clientSumm)")
}

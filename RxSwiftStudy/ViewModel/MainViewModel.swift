//
//  MainViewModel.swift
//  RxSwiftStudy
//
//  Created by 김서연 on 3/13/24.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    static let shared = MainViewModel()
    
    let disposeBag = DisposeBag()
    var items = BehaviorSubject<[String: [TableDataModel]]>(value: [:])
    
    lazy var totalPrice = self.items.map { items in
        items.reduce(0) { total, item in
            total + item.value.reduce(0) { $0 + $1.price }
        }
    }
    
    private init() {
        let initialItems: [String: [TableDataModel]] = [
            "example": [
                TableDataModel(name: "A", price: 0, category: "example"),
                TableDataModel(name: "B", price: 100, category: "example"),
                TableDataModel(name: "C", price: 200, category: "example"),
                TableDataModel(name: "D", price: 300, category: "example"),
                TableDataModel(name: "E", price: 400, category: "example")
            ]
        ]
        
        self.items.onNext(initialItems)
    }
    
    func addItem(name: String, price: Int, category: String) {
        var currentItems = try! self.items.value()
        if var categoryItems = currentItems[category] {
            categoryItems.append(TableDataModel(name: name, price: price, category: category))
            currentItems[category] = categoryItems
        } else {
            currentItems[category] = [TableDataModel(name: name, price: price, category: category)]
        }
        self.items.onNext(currentItems)
    }
    
    func deleteItemSelections(at index: Int, in cellCategory: String) {
        var currentItems = try! self.items.value()
        for (category, var categoryItems) in currentItems {
            if index < categoryItems.count {
                if cellCategory == category {
                    categoryItems.remove(at: index)
                    currentItems[category] = categoryItems
                    break
                }
            }
        }
        self.items.onNext(currentItems)
    }
}

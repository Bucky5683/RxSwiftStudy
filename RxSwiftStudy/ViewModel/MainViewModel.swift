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
    // BehaviorSubject를 사용하여 초기 데이터를 포함한 Observable 생성
    var tableObservable = BehaviorSubject<[TableDataModel]>(value: [])
    
    lazy var totalPrice = self.tableObservable.map {
        $0.map { $0.price }.reduce(0, +)
    }
    
    private init() {
        let dataes: [TableDataModel] = [
            TableDataModel(name: "A", price: 0),
            TableDataModel(name: "B", price: 100),
            TableDataModel(name: "C", price: 200),
            TableDataModel(name: "D", price: 300),
            TableDataModel(name: "E", price: 400)
        ]
        
        self.tableObservable.onNext(dataes)
    }
    
    func clearAllItemSelections() {
        self.tableObservable
            .map { dataes in
                return dataes.map {
                    TableDataModel(name: $0.name, price: $0.price)
                }
            }
            .take(1)
            .subscribe(onNext: {
                self.tableObservable.onNext($0)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteItemSelections(at index: Int) {
        // 현재 Obaservable의 값을 가져옴
        var currentData = try! self.tableObservable.value()
        
        // 해당 인덱스의 아이템을 삭제
        currentData.remove(at: index)
        
        // 변경된 데이터로 Obaservable을 업데이트
        self.tableObservable.onNext(currentData)
    }
}

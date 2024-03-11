//
//  ViewController.swift
//  RxSwiftStudy
//
//  Created by 김서연 on 3/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    test()
  }
  
  deinit {
    print("deinit ViewController")
  }

  func test() {
    Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
      .take(10)
      .subscribe(onNext: { value in
        print(value)
      }, onError: { error in
        print(error)
      }, onCompleted: {
        print("onCompleted")
      }, onDisposed: {
        print("“onDisposed”")
      })
      .disposed(by: disposeBag)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      UIApplication.shared.keyWindow?.rootViewController = nil
    }
  }
}


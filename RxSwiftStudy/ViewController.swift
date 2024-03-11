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
    @IBOutlet weak var logLabel: UILabel!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ArrayCheck()
    }
    
    func ArrayCheck() {
        self.checkArrayObservable(items: [4, 3, 1, 5, 2])
            .subscribe { event in
                switch event {
                case .next(let value):
                    print(value)
                    self.logLabel.text = "\(value)"
                case .error(let error):
                    print(error)
                    self.logLabel.text = "\(error)"
                case .completed:
                    print("completed")
                    self.logLabel.text = "completed"
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func checkArrayObservable(items: [Int]) -> Observable<Int> {
        //배열의 엘리멘트 중에 0이 나오면 에러가 나는 Observable
        //rx에서 지원하는 operater도 있지만, 여기선 없이 생성
        return Observable<Int>.create { observer -> Disposable in
            for item in items {
                if item == 0 {
                    observer.onError(NSError(domain: "ERROR: value is zero.", code: 0, userInfo: nil))
                    break
                }
                observer.onNext(item)
                sleep(1)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
}


//
//  MainViewController.swift
//  RxSwiftStudy
//
//  Created by 김서연 on 3/13/24.
//

import UIKit
import RxCocoa
import RxSwift

//https://velog.io/@wansook0316/03.-RxSwift-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EC%A0%81%EC%9A%A9%ED%95%98%EA%B8%B0

class MainViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    let viewModel = MainViewModel.shared
    var disposeBag = DisposeBag()
    let cellID = "TableItemViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addEditButtonToNavigationItem()
        self.setupTableViewDelegate()
    }
    private func addEditButtonToNavigationItem() {
        navigationItem.rightBarButtonItem = editButtonItem
    }
    private func setupTableViewDelegate() {
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.viewModel.tableObservable
            .bind(to: tableView.rx.items(cellIdentifier: self.cellID, cellType: TableItemViewCell.self)) { index, item, cell in
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
            }
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.deleteItemSelections(at: indexPath.row)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.totalPrice
            .map { "\($0)" }
            .bind(to: self.totalPriceLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    func deleteCell(at indexPath: IndexPath) {
        // 현재 Obaservable의 값을 가져옴
        var currentData = try! self.viewModel.tableObservable.value()
        
        // 해당 인덱스의 아이템을 삭제
        currentData.remove(at: indexPath.row)
        
        // 변경된 데이터로 Obaservable을 업데이트
        self.viewModel.tableObservable.onNext(currentData)
    }
    
}


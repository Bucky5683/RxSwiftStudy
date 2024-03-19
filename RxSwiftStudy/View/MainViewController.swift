//
//  MainViewController.swift
//  RxSwiftStudy
//
//  Created by 김서연 on 3/13/24.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

//https://velog.io/@wansook0316/03.-RxSwift-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EC%A0%81%EC%9A%A9%ED%95%98%EA%B8%B0

class MainViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    let viewModel = MainViewModel.shared
    var disposeBag = DisposeBag()
    let cellID = "TableItemViewCell"
    let plussCellID = "TableItemPlussViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.isHidden = true
        self.addEditButtonToNavigationItem()
        self.setupTableViewDelegate()
    }
    private func addEditButtonToNavigationItem() {
        navigationItem.rightBarButtonItem = editButtonItem
    }
    private func setupTableViewDelegate() {
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.viewModel.items
            .map { items in
                var sectionModels = [SectionModel<String, TableDataModel>]()
                for (category, dataModels) in items {
                    let sectionModel = SectionModel(model: category, items: dataModels)
                    sectionModels.append(sectionModel)
                }
                return sectionModels
            }
            .bind(to: tableView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemInserted
            .subscribe(onNext: { item in
                print("아이템 추가 = \(item)")
            }).disposed(by: disposeBag)
        
        self.tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let cell = self?.tableView.cellForRow(at: indexPath) as? TableItemViewCell else {
                    return
                }
                let category = cell.category // 이 부분은 셀의 데이터 모델에 따라 적절한 프로퍼티로 변경되어야 합니다.
                self?.viewModel.deleteItemSelections(at: indexPath.row, in: category)
            })
            .disposed(by: disposeBag)
        
        self.editButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleEditMode()
            }).disposed(by: disposeBag)
        
        self.tableView.rx.itemMoved
            .subscribe(onNext: { indexPath in
                print("아이템 이동 = \(indexPath)")
            }).disposed(by: disposeBag)
        
        self.viewModel.totalPrice
            .map { "\($0)" }
            .bind(to: self.totalPriceLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    private func createDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, TableDataModel>> {
        return RxTableViewSectionedReloadDataSource<SectionModel<String, TableDataModel>>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! TableItemViewCell
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.category = item.category
                return cell
            },
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].model
            }
        )
    }
    private func toggleEditMode() {
        let toggleEditMode = !tableView.isEditing
        self.tableView.setEditing(toggleEditMode, animated: true)
        self.addButton.isHidden = !self.addButton.isHidden
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        showAlert("데이터 추가하기", "")
        
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addTextField { textField in
            textField.placeholder = "Name"
        }
        alertVC.addTextField { textField in
            textField.placeholder = "Price"
            textField.keyboardType = .numberPad
        }
        alertVC.addTextField { textField in
            textField.placeholder = "Category"
        }
        let addAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let name = alertVC.textFields?[0].text, let priceString = alertVC.textFields?[1].text, let price = Int(priceString), let category = alertVC.textFields?[2].text else { return }
            self?.viewModel.addItem(name: name, price: price, category: category)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(addAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
}


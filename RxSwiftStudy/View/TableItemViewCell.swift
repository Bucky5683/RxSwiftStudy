//
//  TableItemViewCell.swift
//  RxSwiftStudy
//
//  Created by 김서연 on 3/13/24.
//

import UIKit
import RxSwift
import RxCocoa

class TableItemViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var onDeleteButtonTapped: (() -> Void)?
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with item: TableDataModel) {
        self.title.text = item.name
        self.price.text = "\(item.price)"
    }
}

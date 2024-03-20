//
//  DetailViewController.swift
//  RxSwiftStudy
//
//  Created by 김서연 on 3/19/24.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var backView: UIView!
    var nameText: String = ""
    var categoryText: String = ""
    var priceText: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    private func configUI() {
        self.backView.frame.size.height = 500
        self.name.text = self.nameText
        self.category.text = self.categoryText
        self.price.text = "\(self.priceText)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

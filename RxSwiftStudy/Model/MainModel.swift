//
//  MainModel.swift
//  RxSwiftStudy
//
//  Created by 김서연 on 3/13/24.
//

import Foundation
import RxDataSources

struct TableDataModel {
    var name : String
    var price : Int
}

extension TableDataModel: IdentifiableType, Equatable {
    var identity: String {
        return UUID().uuidString
    }
}

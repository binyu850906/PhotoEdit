//
//  FilterProp.swift
//  PhotoEdit
//
//  Created by binyu on 2021/4/17.
//

import Foundation

class FilterProp {
    let type: ColorControlMode
    let defaultValue: Float
    var value: Float
    
    init(type: ColorControlMode,
         defaultValue: Float,
         value: Float) {
        self.type = type
        self.defaultValue = defaultValue
        self.value = value
    }
}

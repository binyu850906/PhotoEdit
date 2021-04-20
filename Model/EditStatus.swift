//
//  EditStatus.swift
//  PhotoEdit
//
//  Created by binyu on 2021/4/17.
//

import Foundation
import UIKit

class EditStatus {
    var isMirrored: Bool = false
    var rotateCounts: Int = 0
    var colorControls: Array<FilterProp> = [
        FilterProp(type: .brightness, defaultValue: 0, value: 0),
        FilterProp(type: .contrast, defaultValue: 1, value: 1),
        FilterProp(type: .saturation, defaultValue: 1, value: 1)
    ]
    var effect: PhotoEffect? = nil
    var textField: TextFieldInfo? = nil
}

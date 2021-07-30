//
//  Nib.swift
//  IMusic
//
//  Created by Платон on 13.11.2020.
//  Copyright © 2020 Платон Конкилов. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T:UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

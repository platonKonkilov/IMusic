//
//  CNTime+Extention.swift
//  IMusic
//
//  Created by Платон on 12.11.2020.
//  Copyright © 2020 Платон Конкилов. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    
    func toDisplayString()-> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSecond = Int(CMTimeGetSeconds(self))
        let seconds = totalSecond % 60
        let minuts = totalSecond / 60
        let timeFormatString = String(format: "%02d:%02d", minuts, seconds)
        return timeFormatString
    }
}

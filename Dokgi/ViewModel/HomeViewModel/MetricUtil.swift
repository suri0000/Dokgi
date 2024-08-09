//
//  MetricUtil.swift
//  Dokgi
//
//  Created by IMHYEONJEONG on 6/11/24.
//

import Foundation

final class MetricUtil {
    // 길이 계산
    static func formatLength(length: Int) -> String {
        switch length {
        case 0..<1000:
            return "\(length) mm"

        case 1000..<1000000:
            let mLength = Double(length) / 1000.0
            return "\(mLength) m"
        default:
            let kmLength = Double(length) / 1000000.0
            return "\(kmLength) km"
        }
    }
}

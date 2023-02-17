//
//  PageModel.swift
//  Pinch
//
//  Created by Александр Карпов on 17.02.2023.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}

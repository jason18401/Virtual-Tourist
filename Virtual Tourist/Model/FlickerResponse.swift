//
//  FlickerResponse.swift
//  Virtual Tourist
//
//  Created by Jason Yu on 8/7/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import Foundation

struct FlickerResponse: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    let url: String
    let heightN, widthN: Int

    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
        case url = "url_n"
        case heightN = "height_n"
        case widthN = "width_n"
    }
}

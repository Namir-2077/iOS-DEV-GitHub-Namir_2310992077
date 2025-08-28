//
//  Registration.swift
//  Hotel Codable
//
//  Created by Student on 28/08/25.
//

import Foundation

struct Registration {
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfChildren: Int
    var numberOfAdults: Int
    
    var wifi: Bool
    var roomType: RoomType
}

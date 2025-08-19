//
//  SendToContact.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 18/08/25.
//

import Foundation

struct SendToContact: Identifiable, Hashable {
    
    let id = UUID()
    let name: String
    let phoneNumber: String
    let initials: String
    
}

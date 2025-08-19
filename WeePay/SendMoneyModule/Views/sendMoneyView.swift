//
//  sendMoneyView.swift
//  WeePay
//
//  Created by Anshuman Bhatt on 18/08/25.
//

import SwiftUI

struct sendMoneyDetailView: View {
    let contact: SendToContact
    var body: some View {
        VStack(spacing: 20){
            VStack {
                Text(contact.initials)
                    .font(.system(size: 60))
            }
        }
    }
}
struct sendMoneyView: View {
    
   
    
    var body: some View {
        Text("Hello")
    }
}

struct SendMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        sendMoneyView()
    }
}

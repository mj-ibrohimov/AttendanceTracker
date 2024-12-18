//
//  TapButtonView.swift
//  AirBadge
//
//  Created by Muhammadjon on 12/18/24.
//

import SwiftUI

struct TapButtonView: View {
    var isTappedIn: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isTappedIn ? Color.green : Color.blue)
                    .frame(width: 120, height: 120)  // Increased size
                    .shadow(radius: 10)
                
                Text(isTappedIn ? "Tap Out" : "Tap In")
                    .font(.system(size: 22, weight: .bold)) // Adjusted font size
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 50)
    }
}

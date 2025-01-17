//
//  SwiftUIView.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 17.01.2025.
//

import SwiftUI

public struct AlertView: View {
    
    var deviceParameters: DeviceParameters = DMDeviceParameters()
     
     @Binding var shown: Bool
//     @Binding var closureA: AlertAction?
     var isSuccess: Bool
     var message: String
    
    private var deviceScreenSize: CGSize {
        return type(of: deviceParameters).deviceScreenSize
    }
     
    public var body: some View {
         VStack {
//             Color.orange.ignoresSafeArea()
             
             let ddd = min(deviceScreenSize.width, deviceScreenSize.height)
             Image(isSuccess ? "check":"remove").resizable().frame(width: ddd/9, height: ddd/9).padding(.top, ddd * 10 / 100)
             Spacer()
             Text(message).foregroundColor(Color.white)
             Spacer()
             Divider()
             HStack {
                 //TODO: need to adopt that button for various device types (iOS\ watchOS)
                 Button("X") {
//                     closureA = .cancel
                     shown.toggle()
                 }.frame(width: deviceScreenSize.width/2-30, height: 40)
                 .foregroundColor(.white)
                 
                 Button("Retry") {
//                     closureA = .ok
                     shown.toggle()
                 }.frame(width: deviceScreenSize.width/2-30, height: 40)
                 .foregroundColor(.white)
             }
             Spacer()
             
         }.frame(width: deviceScreenSize.width-50, height: 200)
         
         .background(Color.black.opacity(0.5))
         .cornerRadius(12)
         .clipped()
         
     }
 }

#Preview {
    AlertView(shown: .constant(true), isSuccess: true, message: "Some success message")
}
#Preview {
    AlertView(shown: .constant(false), isSuccess: false, message: "Some error message")
}

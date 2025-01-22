//
//  CustomPopUp.swift
//  weatherapp
//
//  Created by fin on 22/01/2025.
//
import SwiftUI

public struct CustomPopUp<PopupContent>: ViewModifier where PopupContent: View {
    
    @Binding var isPresented: Bool
    var view: () -> PopupContent
    
    // Initializer
    init(isPresented: Binding<Bool>, view: @escaping () -> PopupContent) {
        self._isPresented = isPresented
        self.view = view
    }
    
    // This is the required body function for a ViewModifier
    public func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)  
                    .onTapGesture {
                        isPresented = false
                    }
                view()
                    .transition(.scale) // Popup transition effect
                    .zIndex(1) // Ensures the popup appears above the content
            }
        }
    }
}

extension View {
    public func customPopup<PopupContent: View>(
        isPresented: Binding<Bool>,
        view: @escaping () -> PopupContent
    ) -> some View {
        self.modifier(CustomPopUp(isPresented: isPresented, view: view))
    }
}

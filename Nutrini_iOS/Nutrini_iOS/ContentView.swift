//
//  ContentView.swift
//  Nutrini_iOS
//
//  Created by Administrador on 2025-09-21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 60) {
                
                ProgressView(value: 0.5)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 80/255, green: 151/255, blue: 29/255)))
                    .frame(height: 25)
                    .padding(.top, 30)
                    .padding(.horizontal)

                Image("mascota_icon")
                
                HStack {
                    HStack(spacing: 10) {
                        NavigationLink(destination: FoodView()) {
                            MenuButton(iconName: "comida_icon", label: "Comida")
                        }
                            
                        NavigationLink(destination: WaterView()) {
                            MenuButton(iconName: "agua_icon", label: "Agua")
                        }
                            
                        NavigationLink(destination: ExerciseView()) {
                            MenuButton(iconName: "ejercicio_icon", label: "Ejercicio")
                        }
                            
                        NavigationLink(destination: ClosetView()) {
                            MenuButton(iconName: "compras_icon", label: "Closet")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 45/255, green: 114/255, blue: 218/255))
            .ignoresSafeArea()
        }
    }
}

struct MenuButton: View {
    let iconName: String
    let label: String

    var body: some View {
        VStack {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(height: 60)
            Text(label)
                
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    ContentView()
}

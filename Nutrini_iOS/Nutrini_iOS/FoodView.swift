//
//  FoodView.swift
//  Nutrini_iOS
//
//  Created by Administrador on 2025-09-21.
//

import SwiftUI

struct FoodView: View {
    var body: some View {
            VStack(spacing: 0) {
                
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }

                
                VStack {
                    HStack(spacing: 40) {
                        FoodDraggableItem(imageName: "pollo_icon", label: "Pollo")
                        FoodDraggableItem(imageName: "brocoli_icon", label: "Brócoli")
                        FoodDraggableItem(imageName: "queso_icon", label: "Queso")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)
                }
                .frame(height: 180)
                .frame(maxWidth: .infinity)
                .background(Color(red: 45/255, green: 114/255, blue: 218/255))

                
                ZStack(alignment: .topTrailing) {
                    Color.white

                    VStack {
                        Spacer()
                        Image("plato_icon")
                            .resizable()
                            .scaledToFit()
                            .padding()

                        Spacer()
                    }

                    Image(systemName: "trash")
                        .font(.title)
                        .padding()
                }
                .frame(maxHeight: .infinity)

               
                Button(action: {
                    
                }) {
                    Text("Listo")
                        .fontWeight(.bold)
                        .frame(minWidth: 120, minHeight: 44)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 80/255, green: 151/255, blue: 29/255))
                .padding(.bottom)
            }
            .ignoresSafeArea(edges: .top)
        }
    }

    struct FoodDraggableItem: View {
        let imageName: String
        let label: String

        var body: some View {
            VStack {
                Image(imageName)
                    .resizable()
                    .frame(width: 80, height: 80)

                Text(label)
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
}

#Preview {
    FoodView()
}

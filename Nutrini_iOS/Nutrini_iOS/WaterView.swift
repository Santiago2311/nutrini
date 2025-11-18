//
//  WaterView.swift
//  Nutrini_iOS
//
//  Created by Administrador on 2025-09-21.
//

import SwiftUI

struct WaterView: View {
    //Crear una instancia del ViewModel
    @StateObject var waterModel = WaterModel()
    
    var body: some View {
        ZStack {
            backgroundView //Fondo
            
            nutriniView //Nutrini
            
            objectsView //Latas y vasos
            
            textView //Vidas y vasos tomados
            
            if waterModel.isGameOver {
                gameOverOverlay
            }
        }
        .onAppear {
            waterModel.startGame()
        }
        .onDisappear {
            //Cuando desaparece se detiene el juego
            waterModel.stopGame()
        }
        .gesture (
            DragGesture(minimumDistance: 0)
                .onChanged{ value in
                    waterModel.nutriniX = value.location.x
                }
        )
        .ignoresSafeArea()
    }
    
    var textView: some View {
        HStack {
            Spacer() // Empuja todo hacia la derecha
            
            VStack() {
                Text("Vidas: \(waterModel.lives)")
                    .font(.custom("CherryBombOne-Regular", size: 32))
                    .foregroundColor(.white)
                    .padding(.top, 30)
                    .padding(.bottom, 0)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                Text("Vasos tomados: \(waterModel.vasosTomados)")
                    .font(.custom("CherryBombOne-Regular", size: 32))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                Spacer()
            }
            .padding(.trailing, 30)
        }
        .padding()
    }
    
    var backgroundView: some View {
        Image("fondoWater")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        
    }
    
    var objectsView: some View {
        ZStack {
            ForEach(waterModel.objects) { object in
                if (object.visible) {
                    if object.refresco == true {
                        Image("lata_icon")
                            .resizable()
                            .frame(width: object.width, height: object.height)
                            .position(
                                x: object.xPos,
                                y: object.yPos)
                    }
                    else {
                        Image("vaso_icon")
                            .resizable()
                            .frame(width: object.width, height: object.height)
                            .position(
                                x: object.xPos,
                                y: object.yPos)
                    }
                }
            }
            
        }
    }
    
    var nutriniView: some View {
        Image("mascota_icon")
            .resizable()
            .scaledToFit()
            .frame(width: waterModel.nutriniWidth,
                   height: waterModel.nutriniHeight)
            .position(
                x: waterModel.nutriniX,
                y: waterModel.nutriniY)
    }
    
    var gameOverOverlay: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Perdiste")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
                
                Button(action: {
                    waterModel.restartGame()
                }) {
                    Text("Reintertar")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
            }
        }
    }
}

#Preview {
    WaterView()
}

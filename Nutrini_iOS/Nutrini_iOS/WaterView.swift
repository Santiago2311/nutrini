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
            
            objectsView //Latas y vasos
            
            nutriniView //Nutrini
            
            if waterModel.isGameOver {
                gameOverOverlay
            }
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
    
    var backgroundView: some View {
        Image("fondoWater")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        
    }
    
    var objectsView: some View {
        ZStack {
            ForEach(waterModel.objects) { object in
                if object.refresco == true {
                    Image("lata_icon")
                        .resizable()
                        .frame(width: object.width, height: object.height)
                        .position(
                            x: object.xPos,
                            y: object.xPos)
                }
                else {
                    Image("vaso_icon")
                        .resizable()
                        .frame(width: object.width, height: object.height)
                        .position(
                            x: object.xPos,
                            y: object.xPos)
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

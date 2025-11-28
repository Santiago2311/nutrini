//
//  WaterView.swift
//  Nutrini_iOS
//
//  Created by Administrador on 2025-09-21.
//

import SwiftUI

private func getGameResult() -> (stars: Int, message: String) {
    @StateObject var waterModel = WaterModel()
    let vasos = waterModel.vasosTomados
        
    switch vasos {
    case 0...2:
        return (0, "Buen intento. Sigue practicando")
    case 3...5:
        return (1, "Buen inicio, pero aún necesitas tomar un poco mas de agua")
    case 6...7:
        return (2, "¡Muy bien! Tomaste bastante agua, pero intenta alcanzar el objetivo diario")
    default:
        return (3, "¡Excelente! alcanzaste el objetivo diario de 8 vasos")
    }
}

struct WaterView: View {
    // Para poder regresar a la pantalla anterior (Inicio)
    @Environment(\.dismiss) var dismiss
    
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
        let result = getGameResult()
        
        return ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Resultado")
                    .font(.custom("CherryBombOne-Regular", size: 30))
                    .foregroundColor(.black)
                
                HStack(spacing: 8) {
                    ForEach(0..<result.stars, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.largeTitle)
                            .foregroundColor(
                                Color(uiColor: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1.0))
                            )
                    }
                }
                Text(result.message)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .font(.custom("CherryBombOne-Regular", size: 20))
                    .foregroundColor(.black)
                
                HStack(spacing: 16) {
                    Button("Inicio") {
                        dismiss()   // vuelve a ContentView (pantalla anterior)
                    }
                    .font(.custom("CherryBombOne-Regular", size: 20))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    
                    Button("Volver a jugar") {
                        waterModel.restartGame()
                    }
                    .font(.custom("CherryBombOne-Regular", size: 20))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(red: 80/255, green: 151/255, blue: 29/255))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal, 40)
        }
    }
}
#Preview {
    WaterView()
}

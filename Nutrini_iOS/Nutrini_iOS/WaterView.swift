//
//  WaterView.swift
//  Nutrini_iOS
//
//  Created by Administrador on 2025-09-21.
//

import SwiftUI

private func getGameResult(vasos: Int) -> (stars: Int, message: String) {
    switch vasos {
    case 0...5:
        return (1, "Buen inicio, pero aún necesitas tomar más agua")
    case 6...7:
        return (2, "¡Muy bien! Tomaste bastante agua, intenta llegar a 8 vasos")
    default:
        return (3, "¡Excelente! Alcanzaste el objetivo diario de 8 vasos")
    }
}

struct WaterView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var waterModel = WaterModel()
    
    @AppStorage("waterStars") private var waterStars: Int = 0
    @AppStorage("waterStarsDate") private var waterStarsDate: String = ""

    var body: some View {
        ZStack {
            backgroundView
            nutriniView
            objectsView
            textView
            
            if waterModel.isGameOver {
                gameOverOverlay
            }
        }
        .onAppear { waterModel.startGame() }
        .onDisappear { waterModel.stopGame() }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    waterModel.nutriniX = value.location.x
                }
        )
        .ignoresSafeArea()
    }

    
    
    
    
    
    // MARK: - TEXTOS SUPERIORES

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
                    
                    Text("Vasos: \(waterModel.vasosTomados)")
                        .font(.custom("CherryBombOne-Regular", size: 32))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Spacer()
                }
                .padding(.trailing, 30)
            }
            .padding()
        }

    // MARK: - FONDO

    var backgroundView: some View {
        Image("fondoWater")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }

    // MARK: - OBJETOS (VASOS Y LATAS)

    var objectsView: some View {
        ZStack {
            ForEach(waterModel.objects) { object in
                if object.visible {
                    if object.refresco {
                        Image("lata_icon")
                            .resizable()
                            .frame(width: object.width, height: object.height)
                            .position(x: object.xPos, y: object.yPos)
                    } else {
                        Image("vaso_icon")
                            .resizable()
                            .frame(width: object.width, height: object.height)
                            .position(x: object.xPos, y: object.yPos)
                    }
                }
            }
        }
    }

    // MARK: - NUTRINI

    var nutriniView: some View {
        Image("mascota_icon")
            .resizable()
            .scaledToFit()
            .frame(width: waterModel.nutriniWidth,
                   height: waterModel.nutriniHeight)
            .position(
                x: waterModel.nutriniX,
                y: waterModel.nutriniY
            )
    }

    // MARK: - POPUP FINAL

    var gameOverOverlay: some View {
        let result = getGameResult(vasos: waterModel.vasosTomados)

        return ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()

            VStack(spacing: 16) {

                // TÍTULO SOLO SI GANA ESTRELLAS (igual que comida)
                if result.stars > 0 {
                    Text("Resultado")
                        .font(.custom("CherryBombOne-Regular", size: 30))
                        .foregroundColor(.black)

                    // ESTRELLAS IGUALES QUE EN COMIDA
                    HStack(spacing: 8) {
                        ForEach(0..<result.stars, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.largeTitle)
                                .foregroundColor(
                                    Color(uiColor: UIColor(
                                        red: 255/255,
                                        green: 198/255,
                                        blue: 0/255,
                                        alpha: 1.0
                                    ))
                                )
                        }
                    }
                }

                Text(result.message)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .font(.custom("CherryBombOne-Regular", size: 20))
                    .foregroundColor(.black)

                // BOTONES
                HStack(spacing: 16) {

                    Button("Inicio") {
                        dismiss()
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
        .onAppear {
                saveWaterStars(stars: result.stars)
        }
    }
    
    private func saveWaterStars(stars: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        waterStars = stars
        
        
        
        
        waterStarsDate = today
    }

}

#Preview {
    WaterView()
}

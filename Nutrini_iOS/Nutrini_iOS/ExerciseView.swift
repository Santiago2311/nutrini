//
//  ExerciseView.swift
//  Nutrini_iOS
//
//  Created by Alumno on 14/11/25.
//

import SwiftUI

private func getGameResult(time: Double) -> (stars: Int, message: String) {
    switch time {
    case 0...10:
        return (1, "Buen inicio, pero aún necesitas hacer un poco más de ejercicio")
    case 11...20:
        return (2, "¡Muy bien! Hiciste bastante ejercicio, intenta llegar a 30 segundos (minutos)")
    default:
        return (3, "¡Excelente! Alcanzaste el objetivo diario de 30 minutos (segundos) de ejercicio")
    }
}

struct ExerciseView: View {
    @AppStorage("exerciseStars") private var exerciseStars: Int = 0
    @AppStorage("exerciseStarsDate") private var exerciseStarsDate: String = ""
    
    // Para poder regresar a la pantalla anterior (Inicio)
    @Environment(\.dismiss) var dismiss
    
    //Crear una instancia del ViewModel
    @StateObject var exerciseModel = ExerciseModel()
    
    var body: some View {
        ZStack {
            backgroundView
            platformsView
            nutriniView
            
            if exerciseModel.isGameOver {
                gameOverOverlay
            }
        }
        .onAppear {
            exerciseModel.generateInitialPlatforms()
            OrientationManager.lockOrientation(.landscape) // 🔒 horizontal
        }
        .onDisappear {
            exerciseModel.stopGame()
            OrientationManager.lockOrientation(.portrait) // 🔓 restaurar vertical
        }
        .gesture(
            TapGesture()
                .onEnded { _ in
                    if !exerciseModel.gameStarted {
                        exerciseModel.startGame()
                    } else if exerciseModel.isGameOver {
                        exerciseModel.restartGame()
                    } else {
                        exerciseModel.jump()
                    }
                }
        )
        .ignoresSafeArea()
    }
    
    // SUBVISTAS
    var backgroundView: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            HStack {
                Image("nube")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .opacity(0.7)
                    .position(x:-40, y: 90)
                Image("nube")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .opacity(0.7)
                    .position(x: 90, y: 230)
                Image("nube")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .opacity(0.7)
                    .position(x: 150, y: 30)
                Image("nube")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .opacity(0.7)
                    .position(x: 190, y: 300)
            }
        }
    }
    
    var platformsView: some View {
        ZStack {
            ForEach(exerciseModel.platforms) { platform in
                Image("plataforma")
                    .resizable()
                    .frame(width: platform.width, height: platform.height)
                    .position(
                        x: platform.xPos - exerciseModel.cameraOffsetX,
                        y: platform.yPos)
            }
        }
    }
    
    var nutriniView: some View {
        Image("mascota_icon")
            .resizable()
            .scaledToFit()
            .frame(width: exerciseModel.nutriniWidth,
                   height: exerciseModel.nutriniHeight)
            .position(
                x: exerciseModel.nutriniX,
                y: exerciseModel.nutriniY)
    }
    
    var gameOverOverlay: some View {
        let result = getGameResult(time: exerciseModel.timeElapsed)
        
        return ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            
            VStack(spacing: 16) {
                if result.stars > 0 {
                    Text("Resultado")
                        .font(.custom("CherryBombOne-Regular", size: 30))
                        .foregroundColor(.black)
                    
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
                        exerciseModel.restartGame()
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
            saveExerciseStars(stars: result.stars)
        }
    }
    
    private func saveExerciseStars(stars: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        exerciseStars = stars
        exerciseStarsDate = today
    }
}

#Preview(traits: .landscapeLeft) {
    ExerciseView()
}


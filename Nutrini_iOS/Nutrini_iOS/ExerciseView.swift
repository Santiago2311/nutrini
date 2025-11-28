//
//  ExerciseView.swift
//  Nutrini_iOS
//
//  Created by Alumno on 14/11/25.
//

import SwiftUI

private func getGameResult(vasos: Int) -> (stars: Int, message: String) {
    //@StateObject var waterModel = WaterModel()
    //let vasos = waterModel.vasosTomados
        
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

struct ExerciseView: View {
    // Para poder regresar a la pantalla anterior (Inicio)
    @Environment(\.dismiss) var dismiss
    
    //Crear una instancia del ViewModel t
    @StateObject var exerciseModel = ExerciseModel()
    
    var body: some View {
        ZStack {
            backgroundView //Fondo
            
            platformsView //Plataformas
            
            nutriniView //Nutrini
            
            if exerciseModel.isGameOver {
                gameOverOverlay
            }
        }
        .onAppear {
            //Cuando aparece se generan las plataformas iniciales
            exerciseModel.generateInitialPlatforms()
            OrientationManager.lockOrientation(.landscape) // 🔒 horizontal
        }
        .onDisappear {
            //Cuando desaparece se detiene el juego
            exerciseModel.stopGame()
            OrientationManager.lockOrientation(.portrait) // 🔓 restaurar vertical
        }
        .gesture (
            TapGesture()
                .onEnded { _ in
                    if !exerciseModel.gameStarted {
                        // Primer tap: Iniciar juego
                        exerciseModel.startGame()
                    } else if exerciseModel.isGameOver {
                        // Si perdió: Reiniciar
                        exerciseModel.restartGame()
                    } else {
                        // Taps siguientes: Saltar
                        exerciseModel.jump()
                    }
                }
        )
        .ignoresSafeArea()
    }
    
    //SUBVISTAS
    var backgroundView: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            HStack { //aqui van a ir todas las nubes
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
        //Dibujar todas las plataformas
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
        
        let result = getGameResult(vasos: waterModel.vasosTomados)
        
        return ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Resultado")
                    .font(.custom("CherryBombOne-Regular", size: 30))
                    .foregroundColor(.black)
                
                HStack(spacing: 8) {
                    ForEach(0..<result.stars, id: \.self) { _ in
                        Image("estrella_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            //.font(.largeTitle)
                            //.foregroundColor(
                              //  Color(uiColor: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1.0))
                            //)
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
    }
}

#Preview(traits: .landscapeLeft) {
    ExerciseView()
        //.previewInterfaceOrientation(.landscapeLeft)
}

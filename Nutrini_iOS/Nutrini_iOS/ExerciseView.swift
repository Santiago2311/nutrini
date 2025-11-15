//
//  ExerciseView.swift
//  Nutrini_iOS
//
//  Created by Alumno on 14/11/25.
//

import SwiftUI

struct ExerciseView: View {
    //Crear una instancia del ViewModel
    @StateObject var exerciseModel = ExerciseModel()
    
    var body: some View {
        ZStack {
            backgroundView //Fondo
            
            platformsView //Plataformas
            
            nutriniView //Nutrini
            
            //No entiendo esto
            if exerciseModel.isGameOver {
                gameOverOverlay
            }
        }
        .onAppear {
            //Cuando aparece inica el juego
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
                    if exerciseModel.isGameOver {
                        exerciseModel.startGame()
                    } else {
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
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Perdiste")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
                
                Button(action: {
                    exerciseModel.restartGame()
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

#Preview(traits: .landscapeLeft) {
    ExerciseView()
        //.previewInterfaceOrientation(.landscapeLeft)
}

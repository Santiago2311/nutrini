//
//  ExerciseView.swift
//  Nutrini_iOS
//
//  Created by Alumno on 14/11/25.
//

import SwiftUI

struct ExerciseView: View {
    var body: some View {
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
            
            HStack {
                VStack(spacing: 0) {
                    Image("plataforma")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                        .position(x: 60, y: 390)
                }
                
                HStack(spacing: 0) {
                    Image("plataforma")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    Image("plataforma")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    Image("plataforma")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    //.position(x:290, y: 355)
                    Image("plataforma")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    //.position(x:290, y: 355)
                    //.position(x:290, y: 355)
                }
                .position(x: 120, y: 260)
                
                HStack(spacing: 0) {
                    Image("plataforma")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    Image("plataforma")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    Image("plataforma")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    //.position(x:290, y: 355)
                    //.position(x:290, y: 355)
                }
                .position(x: 200, y: 180)
                
                HStack(spacing: 0) {
                    Image("plataforma")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    Image("plataforma")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                    //.position(x:290, y: 355)
                }
                .position(x: 300, y: 180)
                
                Image("Nutrini")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .position(x: -650, y: 260)
            }
            .ignoresSafeArea()
        }
        .onAppear {
                OrientationManager.lockOrientation(.landscape) // 🔒 horizontal
        }
        .onDisappear {
                OrientationManager.lockOrientation(.portrait) // 🔓 restaurar vertical
        }
    }
}

#Preview(traits: .landscapeLeft) {
    ExerciseView()
        //.previewInterfaceOrientation(.landscapeLeft)
}

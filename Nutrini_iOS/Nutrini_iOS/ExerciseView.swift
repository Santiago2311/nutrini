// ExerciseView.swift

import SwiftUI

// --- Función de Lógica de Resultado (No necesita cambios) ---
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

// --- Estructura Principal de la Vista ---
struct ExerciseView: View {
    @AppStorage("exerciseStars") private var exerciseStars: Int = 0
    @AppStorage("exerciseStarsDate") private var exerciseStarsDate: String = ""
    
    // Para poder regresar a la pantalla anterior (Inicio)
    @Environment(\.dismiss) var dismiss
    
    //Crear una instancia del ViewModel
    @StateObject private var exerciseModel = ExerciseModel()
    @StateObject private var tts = TTSManager() // Necesario para el botón de instrucciones
    
    var body: some View {
        ZStack {
            // Capa del Juego con Gesto de Salto
            ZStack {
                backgroundView
                platformsView
                nutriniView
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
            
            // 🔥 CAPA CORREGIDA: Textos y Botón de Instrucciones
            // Esta capa está FUERA del gesto de toque del juego.
            textView
            
            if exerciseModel.isGameOver {
                gameOverOverlay
            }
        }
        .onAppear {
            exerciseModel.generateInitialPlatforms()
            // Asume que OrientationManager.lockOrientation es una función válida
            OrientationManager.lockOrientation(.landscape) // 🔒 horizontal
        }
        .onDisappear {
            exerciseModel.stopGame()
            OrientationManager.lockOrientation(.portrait) // 🔓 restaurar vertical
        }
        .ignoresSafeArea()
    }
    
    // MARK: - SUBVISTAS
    
    // 🔥 NUEVA SUBVISTA PARA TEXTOS Y BOTÓN (Corrige el problema del botón)
    var textView: some View {
        HStack {
            
            VStack(alignment: .leading) {
                // Muestra el tiempo de juego
                Text("Tiempo: \(String(format: "%.1f", exerciseModel.timeElapsed))s")
                    .font(.custom("CherryBombOne-Regular", size: 32))
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Spacer()
            }
            .padding(.leading, 30)
            
            Spacer()
            
            VStack {
                // Se usa el componente InstructionsButton de WaterView
                InstructionsButton(tts: tts, message: "Toca la pantalla para hacer que Nutrini salte de plataforma en plataforma. Intenta mantenerlo corriendo por 30 segundos")
                    .padding(.trailing, 30)
                    .padding(.top, 30)
                
                Spacer()
            }
        }
        .padding()
    }
    
    // --- Subvista de Fondo (Sin cambios) ---
    var backgroundView: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            // ... (nubes)
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
    
    // --- Subvista de Plataformas (Sin cambios) ---
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
    
    // --- Subvista de Nutrini (Sin cambios) ---
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
    
    // --- Subvista de Game Over (Sin cambios) ---
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
    
    // MARK: - FUNCIONES
    
    // --- Función para guardar estrellas (Sin cambios) ---
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

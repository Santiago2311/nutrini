import SwiftUI

struct ContentView: View {
    @StateObject var tts = TTSManager()
    
    // Progreso diario del juego de comida
    @AppStorage("foodStars") private var foodStars: Int = 0
    @AppStorage("foodStarsDate") private var foodStarsDate: String = ""
    
    // Progreso diario del juego de agua
    @AppStorage("waterStars") private var waterStars: Int = 0
    @AppStorage("waterStarsDate") private var waterStarsDate: String = ""
    
    // Progreso (0.25, 0.5, 0.75, 1.0) según estrellas
    private var foodProgress: Double {
        switch foodStars {
        case 3: return 1.0
        case 2: return 0.75
        case 1: return 0.5
        default: return 0.25
        }
    }
    
    // Color según estrellas
    private var foodColor: Color {
        switch foodStars {
        case 3:
            return Color(red: 80/255, green: 151/255, blue: 29/255) // verde
        case 2:
            return .yellow
        case 1:
            return .orange
        default:
            return .red
        }
    }
    
    // Progreso (0.25, 0.5, 0.75, 1.0) según estrellas de agua
    private var waterProgress: Double {
        switch waterStars {
        case 3: return 1.0
        case 2: return 0.75
        case 1: return 0.5
        default: return 0.25    // no ha jugado o 0 estrellas
        }
    }

    // Color según estrellas de agua
    private var waterColor: Color {
        switch waterStars {
        case 3:
            return Color(red: 80/255, green: 151/255, blue: 29/255) // verde
        case 2:
            return .yellow
        case 1:
            return .orange
        default:
            return .red
        }
    }

    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // Fondo
                Color(red: 45/255, green: 114/255, blue: 218/255)
                    .ignoresSafeArea()
                
                VStack {
                    
                    
                    Spacer()
                    Spacer()
                    
                    // Mascota en el centro
                    Image("mascota_icon")
                        .onTapGesture {
                            tts.textToSpeech = "¡Hola, soy tu amigo Nutrini!"
                            tts.speak()
                        }
                    
                    Spacer()
                    
                    // HStack inferior
                    HStack(spacing: 10) {
                        NavigationLink(destination: FoodView()) {
                            // Progreso Comida
                            MenuButton(
                                iconName: "comida_icon",
                                label: "Comida",
                                progress: foodProgress,
                                progressColor: foodColor
                            )
                        }
                        
                        NavigationLink(destination: WaterView()) {
                            MenuButton(
                                iconName: "agua_icon",
                                label: "Agua",
                                progress: waterProgress,
                                progressColor: waterColor
                            )
                        }

                        
                        NavigationLink(destination: ExerciseView()) {
                            // Por ahora, base 25% rojo
                            MenuButton(
                                iconName: "ejercicio_icon",
                                label: "Ejercicio",
                                progress: 0.25,
                                progressColor: .red
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Logo en esquina superior izquierda
                VStack {
                    HStack {
                        VStack {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 75)
                        }
                        .padding(.leading, 30)
                        
                        Spacer()
                    }
                    Spacer()
                    
                }
            }
        }
        .onAppear {
            resetFoodProgressIfNeeded()
            resetWaterProgressIfNeeded()
        }
    }
    
    // Resetea el progreso de comida si cambió el día
    private func resetFoodProgressIfNeeded() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        if foodStarsDate != today {
            foodStars = 0          // vuelve al estado 0 estrellas → 25% rojo
            foodStarsDate = today  // marca el día actual
        }
    }
    
    // Resetea el progreso de agua si cambió el día
    private func resetWaterProgressIfNeeded() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        if waterStarsDate != today {
            waterStars = 0          // vuelve al estado base → 25% rojo
            waterStarsDate = today  // marca el día actual
        }
    }

}

struct MenuButton: View {
    @StateObject var tts = TTSManager()
    let iconName: String
    let label: String
    let progress: Double
    let progressColor: Color

    var body: some View {
        VStack(spacing: 7) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
            
            Text(label)
                .font(.custom("CherryBombOne-Regular", size: 26))
                .foregroundColor(.white)
            
            ZStack {
                // Contorno
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(height: 26)
                
                ProgressView(value: progress)
                    .progressViewStyle(
                        LinearProgressViewStyle(
                            tint: progressColor
                        )
                    )
                    .scaleEffect(x: 1, y: 6, anchor: .center) // barra gruesa
                    .padding(.horizontal, 2)
            }
            .padding(.horizontal, 10)
            
        }
        .frame(maxWidth: .infinity)
        .onLongPressGesture {
            tts.textToSpeech = label
            tts.speak()
        }
    }
}

#Preview {
    ContentView()
}


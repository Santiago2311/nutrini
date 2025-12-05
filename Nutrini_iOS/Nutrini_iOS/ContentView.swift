///ContentView

import SwiftUI

struct ContentView: View {
    @StateObject var tts = TTSManager()
    
    // Progreso diario del juego de comida
    @AppStorage("foodStars") private var foodStars: Int = 0
    @AppStorage("foodStarsDate") private var foodStarsDate: String = ""
    
    // Progreso diario del juego de agua
    @AppStorage("waterStars") private var waterStars: Int = 0
    @AppStorage("waterStarsDate") private var waterStarsDate: String = ""
    
    // Progreso diario del juego de ejercicio
    @AppStorage("exerciseStars") private var exerciseStars: Int = 0
    @AppStorage("exerciseStarsDate") private var exerciseStarsDate: String = ""
    
    private var mascotIconName: String {
        // 1. Prioridad: Juego Agua < 2 estrellas
        if waterStars < 2 {
            return "mascota_deshidratada"
        }
        // 2. Siguiente Prioridad: Juego Ejercicio < 2 estrellas
        else if exerciseStars < 2 {
            return "mascota_sedentaria"
        }
        // 3. Siguiente Prioridad: Juego Comida < 2 estrellas
        else if foodStars < 2 {
            return "mascota_desnutrida"
        }
        // 4. Si todas las condiciones anteriores son falsas
        else {
            return "mascota_icon" // Ícono de mascota saludable
        }
    }
    
    // === COMIDA ===
    private var foodProgress: Double {
        switch foodStars {
        case 3: return 1.0
        case 2: return 0.75
        case 1: return 0.5
        default: return 0.25
        }
    }
    
    private var foodColor: Color {
        switch foodStars {
        case 3:
            return Color(red: 80/255, green: 151/255, blue: 29/255)
        case 2:
            return .yellow
        case 1:
            return .orange
        default:
            return .red
        }
    }
    
    // === AGUA ===
    private var waterProgress: Double {
        switch waterStars {
        case 3: return 1.0
        case 2: return 0.75
        case 1: return 0.5
        default: return 0.25
        }
    }

    private var waterColor: Color {
        switch waterStars {
        case 3:
            return Color(red: 80/255, green: 151/255, blue: 29/255)
        case 2:
            return .yellow
        case 1:
            return .orange
        default:
            return .red
        }
    }
    
    // === EJERCICIO ===
    private var exerciseProgress: Double {
        switch exerciseStars {
        case 3: return 1.0
        case 2: return 0.75
        case 1: return 0.5
        default: return 0.25
        }
    }
    
    private var exerciseColor: Color {
        switch exerciseStars {
        case 3:
            return Color(red: 80/255, green: 151/255, blue: 29/255)
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
                Color(red: 45/255, green: 114/255, blue: 218/255)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Spacer()
                    
                    Image(mascotIconName)
                        .resizable()             // Permite cambiar el tamaño
                        .scaledToFit()           // Mantiene la proporción de la imagen
                        .frame(height: 350)
                        .onTapGesture {
                            tts.textToSpeech = "¡Hola, soy tu amigo Nutrini!"
                            tts.speak()
                        }
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        NavigationLink(destination: FoodView()) {
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
                            MenuButton(
                                iconName: "ejercicio_icon",
                                label: "Ejercicio",
                                progress: exerciseProgress,
                                progressColor: exerciseColor
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
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
                        
                        Button(action: {
                            tts.textToSpeech = "Selecciona una actividad para empezar a jugar y aprender sobre alimentación saludable"
                            tts.speak()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 50, height: 50)
                                
                                Text("?")
                                    .font(.custom("CherryBombOne-Regular", size: 28))
                                    .foregroundColor(Color(red: 45/255, green: 114/255, blue: 218/255))
                            }
                        }
                        .padding(.trailing, 30)
                    }
                
                    Spacer()
                }
            }
        }
        .onAppear {
            resetFoodProgressIfNeeded()
            resetWaterProgressIfNeeded()
            resetExerciseProgressIfNeeded()
        }
    }
    
    // === RESET DIARIO ===
    private func resetFoodProgressIfNeeded() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        if foodStarsDate != today {
            foodStars = 0
            foodStarsDate = today
        }
    }
    
    private func resetWaterProgressIfNeeded() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        if waterStarsDate != today {
            waterStars = 0
            waterStarsDate = today
        }
    }
    
    private func resetExerciseProgressIfNeeded() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        if exerciseStarsDate != today {
            exerciseStars = 0
            exerciseStarsDate = today
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
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(height: 26)
                
                ProgressView(value: progress)
                    .progressViewStyle(
                        LinearProgressViewStyle(
                            tint: progressColor
                        )
                    )
                    .scaleEffect(x: 1, y: 6, anchor: .center)
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


import SwiftUI

struct ContentView: View {
    @StateObject var tts = TTSManager()
    
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
                            MenuButton(iconName: "comida_icon", label: "Comida")
                        }
                        
                        NavigationLink(destination: WaterView()) {
                            MenuButton(iconName: "agua_icon", label: "Agua")
                        }
                        
                        NavigationLink(destination: ExerciseView()) {
                            MenuButton(iconName: "ejercicio_icon", label: "Ejercicio")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Logo de la organizacion
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
    }
}

struct MenuButton: View {
    @StateObject var tts = TTSManager()
    let iconName: String
    let label: String

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
                
                
                ProgressView(value: 0.5)
                    .progressViewStyle(
                        LinearProgressViewStyle(
                            tint: Color(red: 80/255, green: 151/255, blue: 29/255)
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

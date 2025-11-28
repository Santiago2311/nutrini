
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
                    
                    // Mascota en el centro
                    Image("mascota_icon")
                        .onTapGesture {
                            tts.textToSpeech = "¡Hola, soy tu amigo Nutrini!"
                            tts.speak()
                        }
                    
                    Spacer()
                    
                    // HStack inferior SIN closet
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
                
                // Botón de closet en esquina superior derecha
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: ClosetView()) {
                            VStack {
                                Image("compras_icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 70)
                                
                                Text("Tienda")
                                    .font(.custom("CherryBombOne-Regular", size: 24))
                                    .foregroundColor(.white)
                            }
                            .padding(.trailing, 15)
                            .padding(.top, 5)
                        }
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

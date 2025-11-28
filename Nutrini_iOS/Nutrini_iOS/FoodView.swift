import SwiftUI

struct FoodView: View {
    @State private var droppedItems: [DroppedFood] = []
    @State private var draggingItem: DraggingItem?
    
    // Estados para el pop up
    @State private var showPopup: Bool = false
    @State private var popupMessage: String = ""
    @State private var starCount: Int = 0
    
    // guarda las estrellas de comida para usar en ContentView
    @AppStorage("foodStars") private var foodStars: Int = 0
    
    // Para poder regresar a la pantalla anterior (Inicio)
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {

        ZStack(alignment: .topLeading) {
            
            // Fondo global para evitar alteraciones
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                Color.clear
                    .frame(height: 60)

                
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 0) {
                            
                            Spacer().frame(height: 16)
                            
                            HStack(spacing: 40) {
                                FoodDraggableItem(imageName: "origen_animal/res", label: "Res", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "origen_animal/pollo", label: "Pollo", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "origen_animal/queso", label: "Queso", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "origen_animal/huevo", label: "Huevo", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "origen_animal/pescado", label: "Pescado", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "granos_cereales/bolillo", label: "Bolillo", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "granos_cereales/cuerno", label: "Cuernito", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "granos_cereales/pan", label: "Pan", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "granos_cereales/papa", label: "Papa", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "granos_cereales/tortilla", label: "Tortilla", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "grasas_saludables/aguacate", label: "Aguacate", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "grasas_saludables/almendra", label: "Almendra", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "grasas_saludables/mani", label: "Maní", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "frutas_verduras/brocoli", label: "Brócoli", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "frutas_verduras/pera", label: "Pera", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "frutas_verduras/pina", label: "Piña", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "frutas_verduras/tomate", label: "Tomate", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "frutas_verduras/zanahoria", label: "Zanahoria", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "leguminosas/frijol", label: "Frijol", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "leguminosas/garbanzos", label: "Garbanzo", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "leguminosas/haba", label: "Haba", droppedItems: $droppedItems, draggingItem: $draggingItem)
                                FoodDraggableItem(imageName: "leguminosas/lentejas", label: "Lenteja", droppedItems: $droppedItems, draggingItem: $draggingItem)
                            }
                            .padding(.horizontal)
                            
                            Spacer().frame(height: 16) // espacio ABAJO para scrollear
                        }
                        .contentShape(Rectangle())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)
                }
                .frame(height: 180)
                .background(Color(red: 45/255, green: 114/255, blue: 218/255))

                
                ZStack(alignment: .topTrailing) {
                    Color.white

                    ZStack {
                        VStack {
                            Spacer()
                            Image("plato_icon")
                                .resizable()
                                .scaledToFit()
                                .padding()

                            Spacer()
                        }
                        
                        // Comida en el plato que también se puede arrastrar
                        ForEach(droppedItems) { item in
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .position(item.position)
                                .opacity(draggingItem?.droppedId == item.id ? 0.3 : 1.0)
                                .gesture(
                                    DragGesture(coordinateSpace: .global)
                                        .onChanged { value in
                                            // Arrastrando un alimento que ya estaba en el plato
                                            draggingItem = DraggingItem(
                                                imageName: item.imageName,
                                                position: value.location,
                                                droppedId: item.id
                                            )
                                        }
                                        .onEnded { value in
                                            let dropLocation = value.location
                                            let screenHeight = UIScreen.main.bounds.height
                                            
                                            if dropLocation.y > 310 && dropLocation.y < screenHeight - 200 {
                                                // Lo reubicamos dentro del plato (mismos límites)
                                                if let index = droppedItems.firstIndex(where: { $0.id == item.id }) {
                                                    droppedItems[index] = DroppedFood(
                                                        imageName: item.imageName,
                                                        position: CGPoint(
                                                            x: dropLocation.x,
                                                            y: dropLocation.y - 240
                                                        )
                                                    )
                                                }
                                            } else {
                                                // Fuera del área válida, se descarta
                                                droppedItems.removeAll { $0.id == item.id }
                                            }
                                            
                                            draggingItem = nil
                                        }
                                )
                        }
                    }

                    Image("eliminar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding()
                }
                .frame(maxHeight: .infinity)

               
                Button(action: {
                    evaluatePlate()
                }) {
                    Text("Listo")
                        .font(.custom("CherryBombOne-Regular", size: 28))
                        .frame(minWidth: 120, minHeight: 44)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 80/255, green: 151/255, blue: 29/255))
                .padding(.bottom)
            }
            .ignoresSafeArea(edges: .top)
            
            // Botón flotante
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
            }
            .padding(.top, 50)

            
            // Item siendo arrastrado (desde menú o desde plato)
            if let dragging = draggingItem {
                Image(dragging.imageName)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .position(dragging.position)
            }
            
            // POP UP de resultado
            if showPopup {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        
                        if starCount > 0 {
                            Text("Resultado")
                                .font(.custom("CherryBombOne-Regular", size: 30))
                                .foregroundColor(.black)
                            
                            HStack(spacing: 8) {
                                ForEach(0..<starCount, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(
                                            Color(uiColor: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1.0))
                                        )
                                }
                            }
                        } else {
                            Text("¡Espera!")
                                .font(.custom("CherryBombOne-Regular", size: 30))
                                .foregroundColor(.black)
                        }
                        
                        Text(popupMessage)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .font(.custom("CherryBombOne-Regular", size: 20))
                            .foregroundColor(.black)
                        
                        // Botones según estrellas
                        if starCount == 3 {
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
                                    resetGame()
                                }
                                .font(.custom("CherryBombOne-Regular", size: 20))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color(red: 80/255, green: 151/255, blue: 29/255))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        } else {
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
                                
                                Button("Continuar") {
                                    showPopup = false
                                }
                                .font(.custom("CherryBombOne-Regular", size: 22))
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(Color(red: 80/255, green: 151/255, blue: 29/255))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            
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
    }
    
    private func evaluatePlate() {
        if droppedItems.isEmpty {
            starCount = 0
            popupMessage = "Primero tienes que escoger alimentos y arrastrarlos al plato."
            showPopup = true
            return
        }
        
        let categories: Set<String> = Set(
            droppedItems.compactMap { item in item.category }
        )
        
        let count = categories.count
        var stars = 0
        var message = ""
        
        switch count {
        case 5:
            stars = 3
            message = "¡Excelente! Tienes alimentos de todas las categorías. Tu plato está súper balanceado."
        case 3...4:
            stars = 2
            message = "¡Muy bien! Tienes variedad de alimentos. Intenta agregar de las categorías que faltan."
        case 1...2:
            stars = 1
            message = "Buen inicio, pero aún puedes mejorar tu variedad."
        default:
            stars = 1
            message = "Buen intento. Sigue practicando."
        }
        
        starCount = stars
        foodStars = stars          // manda el resultado a ContentView
        popupMessage = message
        showPopup = true
    }
    
    private func resetGame() {
        droppedItems.removeAll()
        starCount = 0
        popupMessage = ""
        showPopup = false
    }
}

struct DroppedFood: Identifiable {
    let id = UUID()
    let imageName: String
    let position: CGPoint
    
    var category: String {
        imageName.split(separator: "/").first.map(String.init) ?? ""
    }
}

struct DraggingItem {
    let imageName: String
    let position: CGPoint
    let droppedId: UUID?   // nil si viene del menú, id si viene del plato
}

struct FoodDraggableItem: View {
    let imageName: String
    let label: String
    @Binding var droppedItems: [DroppedFood]
    @Binding var draggingItem: DraggingItem?
    @StateObject var tts = TTSManager()

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .frame(width: 80, height: 80)
                .opacity(
                    (draggingItem?.imageName == imageName && draggingItem?.droppedId == nil)
                    ? 0.3 : 1.0
                )
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged { value in
                            // Arrastrando desde el menú (no tiene id aún)
                            draggingItem = DraggingItem(
                                imageName: imageName,
                                position: value.location,
                                droppedId: nil
                            )
                        }
                        .onEnded { value in
                            let dropLocation = value.location
                            let screenHeight = UIScreen.main.bounds.height
                            
                            if dropLocation.y > 310 && dropLocation.y < screenHeight - 200 {
                                droppedItems.append(DroppedFood(
                                    imageName: imageName,
                                    position: CGPoint(
                                        x: dropLocation.x,
                                        y: dropLocation.y - 240
                                    )
                                ))
                            }
                            
                            draggingItem = nil
                        }
                )
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { value in
                            tts.textToSpeech = label
                            tts.speak()
                        }
                )

            Text(label)
                .font(.custom("CherryBombOne-Regular", size: 24))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    FoodView()
}

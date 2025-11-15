import SwiftUI

struct FoodView: View {
    @State private var droppedItems: [DroppedFood] = []
    @State private var draggingItem: DraggingItem?
    
    // Estados para el pop up
    @State private var showPopup: Bool = false
    @State private var popupMessage: String = ""
    @State private var starCount: Int = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                
                // Espacio para el botón flotante
                Color.clear
                    .frame(height: 60)
                
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
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
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)
                }
                .frame(height: 180)
                .frame(maxWidth: .infinity)
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
                        
                        ForEach(droppedItems) { item in
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .position(item.position)
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
                        .fontWeight(.bold)
                        .frame(minWidth: 120, minHeight: 44)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 80/255, green: 151/255, blue: 29/255))
                .padding(.bottom)
            }
            .ignoresSafeArea(edges: .top)
            
            // Botón flotante sobre todo
            Button(action: {
                // acción de regresar
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
            }
            .padding(.top, 50)
            
            // Item siendo arrastrado
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
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack(spacing: 8) {
                                ForEach(0..<starCount, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.title)
                                        .foregroundColor(.yellow)
                                }
                            }
                        } else {
                            Text("¡Espera!")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Text(popupMessage)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .font(.body)
                        
                        Button("Cerrar") {
                            showPopup = false
                        }
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color(red: 80/255, green: 151/255, blue: 29/255))
                        .foregroundColor(.white)
                        .cornerRadius(12)
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
    
    /// Evalúa cuántas carpetas diferentes hay en el plato y actualiza el pop up
    private func evaluatePlate() {
        if droppedItems.isEmpty {
            // Caso: ningún alimento arrastrado
            starCount = 0
            popupMessage = "Primero tienes que escoger alimentos y arrastrarlos al plato."
            showPopup = true
            return
        }
        
        // Obtener categorías distintas a partir del imageName
        let categories: Set<String> = Set(
            droppedItems.compactMap { item in
                item.category
            }
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
            message = "¡Muy bien! Tienes variedad de alimentos. Intenta agregar de las categorías que faltan para un plato perfecto."
        case 1...2:
            stars = 1
            message = "Buen inicio, pero aún puedes mejorar. Intenta incluir alimentos de más grupos para balancear tu plato."
        default:
            stars = 1
            message = "Buen intento. Sigue practicando para lograr un plato más balanceado."
        }
        
        starCount = stars
        popupMessage = message
        showPopup = true
    }
}

struct DroppedFood: Identifiable {
    let id = UUID()
    let imageName: String
    let position: CGPoint
    
    // Carpeta del alimento (por ejemplo: "origen_animal", "leguminosas", etc.)
    var category: String {
        imageName.split(separator: "/").first.map(String.init) ?? ""
    }
}

struct DraggingItem {
    let imageName: String
    let position: CGPoint
}

struct FoodDraggableItem: View {
    let imageName: String
    let label: String
    @Binding var droppedItems: [DroppedFood]
    @Binding var draggingItem: DraggingItem?

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .frame(width: 80, height: 80)
                .opacity(draggingItem?.imageName == imageName ? 0.3 : 1.0)
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged { value in
                            draggingItem = DraggingItem(
                                imageName: imageName,
                                position: value.location
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

            Text(label)
                .font(.custom("cherry_regular", size: 14))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    FoodView()
}

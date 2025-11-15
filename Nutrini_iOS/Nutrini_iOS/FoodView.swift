import SwiftUI

struct FoodView: View {
    @State private var droppedItems: [DroppedFood] = []
    @State private var draggingItem: DraggingItem?
    
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
                            FoodDraggableItem(imageName: "grasas_saludables/mani", label: "Mani", droppedItems: $droppedItems, draggingItem: $draggingItem)
                            FoodDraggableItem(imageName: "frutas_verduras/brocoli", label: "Brocoli", droppedItems: $droppedItems, draggingItem: $draggingItem)
                            FoodDraggableItem(imageName: "frutas_verduras/pera", label: "Pera", droppedItems: $droppedItems, draggingItem: $draggingItem)
                            FoodDraggableItem(imageName: "frutas_verduras/pina", label: "Pina", droppedItems: $droppedItems, draggingItem: $draggingItem)
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
        }
    }
}

struct DroppedFood: Identifiable {
    let id = UUID()
    let imageName: String
    let position: CGPoint
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
                            
                            if dropLocation.y > 240 && dropLocation.y < screenHeight - 100 {
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

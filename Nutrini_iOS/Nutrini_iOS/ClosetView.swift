//
//  ClosetView.swift
//  Nutrini_iOS
//
//  Created by Administrador on 2025-09-21.
//

import SwiftUI

struct ClosetView: View {
    let monedas = 700

    let items = [
        ("lampara_icon", "Lampara", "1000"),
        ("sillon_icon", "Sillon", "900"),
        ("planta_icon", "Plantas", "2000"),
        ("ventana_icon", "Ventana", "5000"),
        ("libros_icon", "Libros", "1500")
    ]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
            VStack(spacing: 10) {
                
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    HStack(spacing: 5) {
                        Image("moneda_icon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("\(monedas)")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)

                
                Text("Closet")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 10)

                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items, id: \.0) { item in
                        
                        Image(item.0)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)

                        
                        VStack(spacing: 4) {
                            Text(item.1)
                                .font(.headline)
                                .foregroundColor(.white)

                            HStack(spacing: 4) {
                                Image("moneda_icon")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                Text(item.2)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }

                        
                        Button("Comprar") {
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(red: 80/255, green: 151/255, blue: 29/255))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 45/255, green: 114/255, blue: 218/255))
            .ignoresSafeArea()
        }
}

#Preview {
    ClosetView()
}

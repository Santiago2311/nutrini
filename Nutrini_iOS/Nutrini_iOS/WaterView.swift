//
//  WaterView.swift
//  Nutrini_iOS
//
//  Created by Administrador on 2025-09-21.
//

import SwiftUI

struct WaterView: View {
        var body: some View {
            ZStack {
                
                Image("fondoWater")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                
                ZStack {
                    
                    Image("vaso_icon")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .offset(x: -100, y: -200)

                    Image("vaso_icon")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .offset(x: 90, y: -120)

                    Image("lata_icon")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .offset(x: -20, y: -300)

                    VStack {
                            Image("mascota_icon")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .offset(y: -70)
                        }
                    }
                }
            }
        }
    



#Preview {
    WaterView()
}

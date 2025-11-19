//
//  TTSOri.swift
//  Nutrini_iOS
//
//  Created by Alumno on 19/11/25.
//

import SwiftUI

struct TTSOri: View {
    @StateObject var tts = TTSManager()
    
    let languages = [
        "Espanol": "es-MX",
        "Ingles": "en-US",
        "Italiano": "it-IT",
        "Francés": "fr-FR"
    ]
    
    var body: some View {
        VStack (spacing: 20) {
            TextField("Texto a leer.",
                      text: $tts.textToSpeech)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
            
            Picker("Language", selection:
                    $tts.selectedLanguage) {
                ForEach(languages.sorted(by: { $0.key <
                    $1.key}), id: \.key) { name, code in
                        Text(name).tag(code)
                    }
            }
            Button("Speak") {
                tts.speak()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
        }
    }
}

#Preview {
    TTSOri()
}

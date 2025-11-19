      //
//  TTSManager.swift
//  Nutrini_iOS
//
//  Created by Alumno on 19/11/25.
//

import Foundation
import AVFoundation
import Combine

class TTSManager: ObservableObject {

    private let synthesizer = AVSpeechSynthesizer()
    
    @Published var selectedLanguage: String = "es-ES"
    @Published var textToSpeech: String = "Hola soy Nutrini"
    
    func speak () {
        let utterance = AVSpeechUtterance(string: textToSpeech)
        utterance.voice = AVSpeechSynthesisVoice(language: selectedLanguage)
        synthesizer.speak(utterance)
    }
}

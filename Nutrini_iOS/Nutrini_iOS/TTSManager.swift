
//  TTSManager.swift

import Foundation
import AVFoundation
import Combine

class TTSManager: ObservableObject {

    private let synthesizer = AVSpeechSynthesizer()
    
    @Published var selectedLanguage: String = "es-MX"  // español de México
    @Published var textToSpeech: String = "Hola soy Nutrini"
    
    func speak () {
        let utterance = AVSpeechUtterance(string: textToSpeech)
        utterance.voice = AVSpeechSynthesisVoice(language: selectedLanguage)
        
        utterance.pitchMultiplier = 1.4   // eleva el tono
        utterance.rate = 0.50             // velocidad más lenta, para que se entienda bien
        utterance.postUtteranceDelay = 0.2  // pequeña pausa después de hablar
        
        do {
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error activando audio:", error.localizedDescription)
        }
        
        synthesizer.speak(utterance)
    }
}

//
//  WaterModel.swift
//  Nutrini_iOS
//
//  Created by Oriana I. Cañizales Hdz. on 17/11/25.
//

import SwiftUI
import Combine

struct Object: Identifiable {
    let id = UUID() //iD UNICO GENERADO POR SWIFT
    var refresco = false //iD UNICO GENERADO POR SWIFT
    var xPos: CGFloat //Poricion horizontal en el mundo
    var yPos: CGFloat //Poricion vertical en el mundo
    let width: CGFloat = 75
    let height: CGFloat = 75
    var velocity: CGFloat
    var visible = true
}

class WaterModel: ObservableObject {
    // === POSICIÓN DEL PERSONAJE ===
    @Published var nutriniX: CGFloat = 190      // Posición en
    @Published var nutriniY: CGFloat = 620      // Posición vertical
    
    // === FÍSICA ===
    @Published var gameSpeed: CGFloat = 3.0     // Velocidad de movimiento horizontal
    
    // === ESTADO DEL JUEGO ===
    @Published var objects: [Object] = []   // Array de todos los objetos
    @Published var lives: CGFloat = 3.0
    @Published var isGameOver: Bool = false     // ¿Perdió el jugador?
    @Published var gameStarted: Bool = false    // Variable que define que el juego inicio
    
    // === CONSTANTES DEL JUEGO ===
    let nutriniWidth: CGFloat = 150       // Ancho del personaje
    let nutriniHeight: CGFloat = 250      // Alto del personaje
    let floorY: CGFloat = 430             // Medida del suelo
    let gravity: CGFloat = 0.4           // Fuerza de gravedad (+ = cae más rápido)
    let speedIncreaseRate: CGFloat = 0.001  // Cuánto acelera por frame
    let maxSpeed: CGFloat = 8.0             // Velocidad máxima
    
    //Otras variables?
    var maxNumObjects = 1 //Numero de objetos que pueden exister la vez
    var vasosTomados: CGFloat = 0
    var gameTimer: Timer?                   // Timer que actualiza el juego 60 veces/seg
    
    init() {
        
    }
    
    func startGame() {
        gameStarted = true
        
        //Crear un timer quue se ejecute a 60 FPS
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
            self.updateGame() //Llama a update cada frame
        }
        
    }
    
    func stopGame() {
        //Detiene y desturye el timer
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    //funcionamiento real del juego
    func updateGame() {
        
        //Si el juego se acaba, no hacer nada
        guard !isGameOver else { return }
        
        //Detectar si nutrini cae en una plataforma
        checkCollisions()
        
        //Se generan nuevas plataformas
        generateObjects()
        
        //Eliminar plataformas que esten fuera de la pantalla para optimizar
        removeObjects()
        
        //Los vasos se acelera
        increaseSpeed()
        
        //Verifica si se cayo al vacio
        checkGameOver()
        
        //Mover los vasos
        
    }
    
    
    //Revision de colisiones (con plataformas)
    func checkCollisions() {
        print("Este es un mensaje de prueba")
        
        for index in objects.indices {
            let object = objects[index]
            if abs(object.yPos - nutriniY) < 60 {
                //Crear rectangulo de Nutrini
                let nutriniRect = CGRect(
                    x: nutriniX,
                    y: nutriniY,
                    width: nutriniWidth,
                    height: nutriniHeight
                )
                
                let objectRect = CGRect(
                    x: object.xPos,
                    y: object.yPos,
                    width: object.width,
                    height: object.height
                )
                
                //Si los rectangulos se tocan
                if nutriniRect.intersects(objectRect) {
                    if object.refresco == true {
                        lives -= 1
                    } else {
                        vasosTomados += 1
                    }
                    objects[index].visible = false
                }
            }
        }
    }
    
    func generateObjects() {
        let currVasos = objects.count
        while currVasos < maxNumObjects {
            //Generar espacio en x
            let xPos = CGFloat.random(in: 0...200)
            
            //Decidir si va a ser vaso o refresco
            let objectTypeProb = CGFloat.random(in: 0...10)
            var objectType = true
            if (objectTypeProb > 70) {
                objectType = false
            } else {
                objectType = true
            }
            
            //Generar las plataformas
            for i in 0..<maxNumObjects {
                let object = Object(
                    refresco: objectType,
                    xPos: xPos,
                    yPos: 100,
                    velocity: gameSpeed
                    
                    
                )
                objects.append(object)
            }
            
        }
    }
    
    func removeObjects() {
        objects.removeAll { object in
            object.yPos < 0
            
        }
    }
    
    func increaseSpeed() {
        //Solo aumentar si no ha llegado al maximo
        if gameSpeed < maxSpeed {
            gameSpeed += speedIncreaseRate //+0.001 por frame
        }
    }
    
    func checkGameOver() {
        //Si nutrini cae debajo de la pantalla
        if lives < 1 {
            gameOver()
        }
    }
    
    func gameOver() {
        isGameOver = true //Activar la pantalla de Game Over
        stopGame() //Detener timer
    }
    
    func restartGame() {
        // === RESETEAR TODAS LAS VARIABLES ===
            
        // Velocidad
        gameSpeed = 3.0
            
        // Plataformas
        objects.removeAll()
            
        // Estado
        isGameOver = false
        gameStarted = false
    }
    
}

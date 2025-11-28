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
    @Published var gameSpeed: CGFloat = 2.0     // Velocidad de movimiento horizontal
    
    // === ESTADO DEL JUEGO ===
    @Published var objects: [Object] = []   // Array de todos los objetos
    @Published var lives = 3
    @Published var isGameOver: Bool = false     // ¿Perdió el jugador?
    @Published var gameStarted: Bool = false    // Variable que define que el juego inicio
    
    // === CONSTANTES DEL JUEGO ===
    let nutriniWidth: CGFloat = 150       // Ancho del personaje
    let nutriniHeight: CGFloat = 250      // Alto del personaje
    let floorY: CGFloat = 430             // Medida del suelo
    let gravity: CGFloat = 0.4           // Fuerza de gravedad (+ = cae más rápido)
    let speedIncreaseRate: CGFloat = 0.001  // Cuánto acelera por frame
    let maxSpeed: CGFloat = 12.0             // Velocidad máxima
    
    //Otras variables?
    var maxNumObjects = 1 //Numero de objetos que pueden exister la vez
    var vasosTomados = 0
    var gameTimer: Timer?                   // Timer que actualiza el juego 60 veces/seg
    var frameCount = 0 //Para contar los segunos
    var framesSinceLastObject = 0 // NUEVO: Contador de frames desde el último objeto generado
    let minFramesBetweenObjects = 5 // NUEVO: Mínimo de frames entre objetos
    var lastObjectX:CGFloat = 0
    
    init() {
        
    }
    
    func startGame() {
        gameStarted = true
        
        generateObjects()
        
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
        
        framesSinceLastObject += 1
        frameCount += 1
        
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
        moveObjects()
        
    }
    func moveObjects(){
        for index in objects.indices{
            self.objects[index].yPos += self.gameSpeed
        }
    }
    
    //Revision de colisiones (con plataformas)
    func checkCollisions() {
        for index in objects.indices {
            let object = objects[index]
            if abs(object.yPos - nutriniY) < 60 {
                //Crear rectangulo de Nutrini
                let nutriniRect = CGRect(
                    x: nutriniX,
                    y: nutriniY,
                    width: nutriniWidth - 40,
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
        var currVasos = objects.count
        if currVasos < maxNumObjects && framesSinceLastObject > 30{
            //Generar espacio en x
            var xPos = CGFloat.random(in: 30...360)
            while abs(lastObjectX - xPos) < 10 {
                xPos = CGFloat.random(in: 30...360)
            }
            
            
            //Decidir si va a ser vaso o refresco
            let objectTypeProb = CGFloat.random(in: 0...10)
            let objectType = objectTypeProb >= 7 // 30% refrescos, 70% vasos
            
            //Generar las plataformas
            let object = Object(
                refresco: objectType,
                xPos: xPos,
                yPos: -50, // Comenzar arriba de la pantalla
                velocity: gameSpeed
            )
            objects.append(object)
            currVasos += 1
            framesSinceLastObject = 0
            lastObjectX = xPos
        }
    }
    
    func removeObjects() {
        objects.removeAll { object in
            object.yPos > 900 || !object.visible
            
        }
    }
    
    func increaseSpeed() {
        //Solo aumentar si no ha llegado al maximo
        if gameSpeed < maxSpeed {
            gameSpeed += speedIncreaseRate //+0.001 por frame
        }
        if frameCount >= 220 {
            if maxNumObjects < 7 {
                maxNumObjects += 1
            }
            frameCount = 0
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
        stopGame()
    
        // === RESETEAR TODAS LAS VARIABLES ===
        vasosTomados = 0
        lives = 3
        maxNumObjects = 1
        frameCount = 0
        
        // Velocidad
        gameSpeed = 3.0
            
        // Plataformas
        objects.removeAll()
            
        // Estado
        isGameOver = false
        gameStarted = false
        
        startGame()
    }
    
}

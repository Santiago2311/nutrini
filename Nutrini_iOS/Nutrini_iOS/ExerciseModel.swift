//
//  ExerciseModel.swift
//  Nutrini_iOS
//
//  Created by Alumno on 14/11/25.
//

import SwiftUI
import Combine

//Estrucutra de una plataforma
struct Platform: Identifiable {
    let id = UUID() //iD UNICO GENERADO POR SWIFT
    var xPos: CGFloat //Poricion horizontal en el mundo
    var yPos: CGFloat //Poricion vertical en el mundo
    let width: CGFloat = 70
    let height: CGFloat = 70
}

class ExerciseModel: ObservableObject {
    // === POSICIÓN DEL PERSONAJE ===
    @Published var nutriniX: CGFloat = 150      // Posición en PANTALLA (fija)
    @Published var nutriniY: CGFloat = 180      // Posición vertical
    @Published var nutriniWorldX: CGFloat = 150 // Posición en el MUNDO (se mueve)
        
    // === FÍSICA ===
    @Published var velocityY: CGFloat = 0       // Velocidad vertical (+ = cae, - = sube)
    @Published var isGrounded: Bool = true     // ¿Está tocando el suelo?
    @Published var gameSpeed: CGFloat = 3.0     // Velocidad de movimiento horizontal
    @Published var jumpSpeed: CGFloat = 6.0          //Aumento de velocidad en el juego
    @Published var nutriSpeed: CGFloat = 3.0          //Aumento de velocidad en el juego
    
    // === ESTADO DEL JUEGO ===
    @Published var platforms: [Platform] = []   // Array de todas las plataformas
    @Published var isGameOver: Bool = false     // ¿Perdió el jugador?
    @Published var cameraOffsetX: CGFloat = 0   // Desplazamiento de la cámara
    @Published var gameStarted: Bool = false    // Variable que define que el juego inicio
    
    // === CONSTANTES DEL JUEGO ===
    let gravity: CGFloat = 0.4           // Fuerza de gravedad (+ = cae más rápido)
    let jumpForce: CGFloat = -12         // Fuerza de salto (- = hacia arriba)
    let maxFallSpeed: CGFloat = 20       // Velocidad máxima de caída
    let nutriniWidth: CGFloat = 150       // Ancho del personaje
    let nutriniHeight: CGFloat = 250      // Alto del personaje
    let floorY: CGFloat = 430             // Medida del suelo
    
    let speedIncreaseRate: CGFloat = 0.001  // Cuánto acelera por frame
    let maxSpeed: CGFloat = 8.0             // Velocidad máxima
    
    let minPlatformY: CGFloat = 100         // Altura mínima (más arriba)
    let maxPlatformY: CGFloat = 360         // Altura máxima (más abajo)
    let minPlatformsPerGroup = 3            // Mínimo de plataformas por grupo
    let maxPlatformsPerGroup = 7           // Máximo de plataformas por grupo
    let minGroupGap: CGFloat = 100          // Espacio mínimo entre grupos
    let maxGroupGap: CGFloat = 230          // Espacio máximo entre grupos
    let maxYGap: CGFloat = 500          // Espacio máximo entre grupos
    let platformSpacing: CGFloat = 70       // Separación dentro de un grupo
    
    var gameTimer: Timer?                   // Timer que actualiza el juego 60 veces/seg
    var lastPlatformX: CGFloat = 0          // Última posición X donde generamos plataforma
    var lastPlatformY: CGFloat = 0          // Última posición y donde generamos plataforma
    
    init() {
        
    }
    
    func startGame() {
        gameStarted = true
        
        //Crear un timer quue se ejecute a 60 FPS
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
            self.updateGame() //Llama a update cada frame
        }
        
    }
    
    func generateInitialPlatforms() {
        //Genera una plataforma inicial justo debajo de Nutrini
        //let initialY = nutriniY + nutriniHeight
        let initialY = floorY - 70 //360
        
        for i in 0..<5 {  // ← Crear 5 plataformas
            let platform = Platform(
                xPos: 50 + (CGFloat(i) * 70),  // 50 es el ancho de cada plataforma
                yPos: initialY
            )
            platforms.append(platform)
        }
        
        //nutriniY = initialY - 60 - (nutriniHeight/2)
        nutriniY = initialY - (nutriniHeight/2) + 4
        
        // Actualizar última posición (5 plataformas * 50 de ancho = 250)
        lastPlatformX = 50 + (5 * 70)  // = 300
        lastPlatformY = initialY          // Última posición X donde generamos plataforma
        
        generatePlatforms()
        
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
        
        
        //Hacer que Nutrini caiga
        applyGravity()
        
        //Nutrini se mueve a la velocidad establecida
        //nutriSpeed = gameSpeed
        nutriniWorldX += nutriSpeed
        
        //Actualizar la camara para que siga a Nutrini
        updateCamera()
        
        //Detectar si nutrini cae en una plataforma
        checkCollisions()
        
        //Se generan nuevas plataformas
        generatePlatforms()
        
        //Eliminar plataformas que esten fuera de la pantalla para optimizar
        removePlatforms()
        
        //Nutrini acelera
        increaseSpeed()
        
        //Verifica si se cayo al vacio
        checkGameOver()
        
    }
    
    func applyGravity() {
        //si no esta en el suelo, aplica la gravedad
        if !isGrounded {
            velocityY += gravity //Aumenta la velocidad de caida
            
            if velocityY > maxFallSpeed {
                velocityY = maxFallSpeed
            }
        }
        
        nutriniY += velocityY
    }
    
    func jump() {
        //Solo puede saltar si esta en el suelo y el juego no ha terminado
        if isGrounded && !isGameOver {
            velocityY = jumpForce //Aplicar fuerza hacia arriba
            isGrounded = false //Ya no esta en el suelo
            nutriSpeed = jumpSpeed
        }
    }
    
    func updateCamera() {
        // La cámara sigue a Nutrini
            // cameraOffsetX = cuánto se ha movido Nutrini desde el inicio
            
            // Nutrini en pantalla está fijo en X = 150
            // Pero en el mundo se mueve (nutriniWorldX aumenta constantemente)
            // El offset es la diferencia
        cameraOffsetX = nutriniWorldX - nutriniX
    }
    
    //Revision de colisiones (con plataformas)
    func checkCollisions() {
        //isGrounded = false
        print("Este es un mensaje de prueba")
        
        var platformUnder = false
        for platform in platforms {
            //Convertir la posicion de la plataforma en el mundo a posicion en pantalla
            let platformScreenX = platform.xPos - cameraOffsetX
            
            // OPTIMIZACIÓN: Solo verificar plataformas cercanas
            // Si la plataforma está muy lejos, ignorarla
            if abs(platformScreenX - nutriniX) < 60{
                platformUnder = true
                //Crear rectangulo de Nutrini
                let nutriniRect = CGRect(
                    x: nutriniX,
                    y: nutriniY,
                    width: nutriniWidth,
                    height: nutriniHeight
                )
                
                let platformRect = CGRect(
                    x: platformScreenX,
                    y: platform.yPos,
                    width: platform.width,
                    height: platform.height
                )
                /*if ((nutriniX - platformScreenX) < platform.width) && (platform.yPos - nutriniY) < 121  {
                    isGrounded = true
                    break
                }*/
                
                //Si los rectangulos se tocan
                if nutriniRect.intersects(platformRect) {
                    let nutriniFeet = nutriniY + (nutriniHeight / 2)
                    //let nutriniFeet = nutriniY + nutriniHeight
                    let nutriniBottomLastFrame = nutriniFeet - velocityY
                    
                    //La velocidad es positiva (viene de arriba) y los pies de nutrini estaban arriba de la plataforma antes de la caida
                    if velocityY > 0 && nutriniBottomLastFrame <= platform.yPos {
                        if platform.yPos - (nutriniHeight/2) + 4 - nutriniFeet < 5 {
                            nutriniY = platform.yPos - (nutriniHeight/2) + 4
                            //Detener mov en y
                            velocityY = 0
                            nutriSpeed = gameSpeed
                                
                            //Marcarlo en el suelo
                            isGrounded = true
                                
                            //Salir del loop (ya aterrizo)
                            break
                        }
                        //Colocar a Nutrini exactamente arriba de la plataforma
                        //nutriniY = platform.yPos - nutriniHeight
                        //nutriniY = platform.yPos - (nutriniHeight/2) + 4
                    }
                }
            }
        }
        if !platformUnder {
            isGrounded = false
            applyGravity()
        }
    }
    
    func generatePlatforms() {
        // Generar plataformas hasta 1000 píxeles adelante de Nutrini
        let generateUntil = nutriniWorldX + 1000
        
        while lastPlatformX < generateUntil {
            //Decidir cuántas plataformas tendrá este grupo (entre 3 y 10)
            let groupSize = Int.random(in: minPlatformsPerGroup...maxPlatformsPerGroup)
            
            //Decidir altura del grupo
            var groupY = CGFloat.random(in: minPlatformY...maxPlatformY)
            
            //Decidir espacio con el grupo anteripr
            let gap = CGFloat.random(in: minGroupGap...maxGroupGap)
            lastPlatformX += gap
            
            var yDistance = lastPlatformY - groupY
            while yDistance > 150 {
                groupY = CGFloat.random(in: minPlatformY...maxPlatformY)
                yDistance = lastPlatformY - groupY
            }
            
            //Generar las plataformas
            for i in 0..<groupSize {
                let platform = Platform(
                    xPos: lastPlatformX + (CGFloat(i) * platformSpacing),
                    yPos: groupY
                )
                platforms.append(platform)
            }
            
            //Actualizar la ultima pos en X
            lastPlatformX += (CGFloat(groupSize) * platformSpacing)
        }
    }
    
    func removePlatforms() {
        platforms.removeAll { platform in
            platform.xPos < nutriniWorldX - 500
            
        }
    }
    
    func increaseSpeed() {
        //Solo aumentar si no ha llegado al maximo
        if gameSpeed < maxSpeed {
            gameSpeed += speedIncreaseRate //+0.001 por frame
            nutriSpeed += speedIncreaseRate //+0.001 por frame
        }
    }
    
    func checkGameOver() {
        //Si nutrini cae debajo de la pantalla
        if nutriniY > 500 {
            gameOver()
        }
    }
    
    func gameOver() {
        isGameOver = true //Activar la pantalla de Game Over
        stopGame() //Detener timer
    }
    
    func restartGame() {
        // === RESETEAR TODAS LAS VARIABLES ===
        
        // Posición
        nutriniY = 250
        nutriniWorldX = 150
            
        // Física
        velocityY = 0
        isGrounded = true
            
        // Velocidad
        gameSpeed = 3.0
        jumpSpeed = 6.0
            
        // Cámara
        cameraOffsetX = 0
            
        // Plataformas
        platforms.removeAll()
        lastPlatformX = 0
            
        // Estado
        isGameOver = false
        gameStarted = false
            
        // === REINICIAR EL JUEGO ===
        generateInitialPlatforms()
    }
    
}


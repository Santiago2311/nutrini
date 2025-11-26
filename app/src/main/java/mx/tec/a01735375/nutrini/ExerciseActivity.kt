package mx.tec.a01735375.nutrini

import android.annotation.SuppressLint
import android.content.pm.ActivityInfo
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.animation.core.*
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.zIndex
import androidx.navigation.NavController
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlin.random.Random

data class Platform(
    var x: Float,
    val y: Float,
    val width: Float,
    val id: Int = Random.nextInt(),
    var counted: Boolean = false
)

enum class GameState {
    PLAYING, GAME_OVER
}

@SuppressLint("UnusedBoxWithConstraintsScope")
@Composable
fun ExerciseView(navController: NavController) {
    LockScreenOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE)

    var gameState by remember { mutableStateOf(GameState.PLAYING) }
    var score by remember { mutableStateOf(0) }
    var scrollSpeed by remember { mutableStateOf(5f) }
    var showDialog by remember { mutableStateOf(false) }
    var countdown by remember { mutableStateOf(3) }
    var gameStarted by remember { mutableStateOf(false) }

    var platforms by remember {
        mutableStateOf(
            listOf(
                Platform(0f, 320f, 400f, counted = true), // Plataforma inicial
                Platform(500f, 280f, 200f),
                Platform(800f, 220f, 180f),
                Platform(1100f, 290f, 220f)
            )
        )
    }

    val petFixedX = 150f
    var petY by remember { mutableStateOf(200f) } // Spawn más arriba
    var petVelocityY by remember { mutableStateOf(0f) }
    var isOnGround by remember { mutableStateOf(false) }
    var isJumping by remember { mutableStateOf(false) }
    var lastPlatformId by remember { mutableStateOf(-1) }

    val runAnimation = remember { Animatable(0f) }
    val bounceAnimation = remember { Animatable(0f) }
    val coroutineScope = rememberCoroutineScope()

    // Countdown de 3 segundos al inicio
    LaunchedEffect(countdown) {
        if (countdown > 0 && !gameStarted) {
            while (countdown > 0) {
                delay(1000L)
                countdown--
            }
            gameStarted = true
        }
    }

    // Animación mientras está en el suelo (caminar)
    LaunchedEffect(isOnGround, gameState) {
        if (isOnGround && gameState == GameState.PLAYING) {
            // Balanceo de izquierda a derecha
            launch {
                runAnimation.animateTo(
                    targetValue = 1f,
                    animationSpec = infiniteRepeatable(
                        animation = tween(150, easing = LinearEasing),
                        repeatMode = RepeatMode.Reverse
                    )
                )
            }
            // Rebote arriba-abajo
            launch {
                bounceAnimation.animateTo(
                    targetValue = 1f,
                    animationSpec = infiniteRepeatable(
                        animation = tween(150, easing = FastOutSlowInEasing),
                        repeatMode = RepeatMode.Reverse
                    )
                )
            }
        } else {
            runAnimation.stop()
            bounceAnimation.stop()
            runAnimation.snapTo(0f)
            bounceAnimation.snapTo(0f)
        }
    }

    // ---------------- LOOP DEL JUEGO ----------------
    LaunchedEffect(gameState, gameStarted) {
        if (gameState == GameState.PLAYING && gameStarted) {
            var lastFrameTime = 0L

            while (gameState == GameState.PLAYING) {
                withFrameNanos { frameTimeNanos ->
                    if (lastFrameTime != 0L) {
                        val deltaTime = (frameTimeNanos - lastFrameTime) / 1_000_000L
                        if (deltaTime < 16L) {
                            return@withFrameNanos
                        }
                    }
                    lastFrameTime = frameTimeNanos

                    // Mover plataformas
                    platforms = platforms.map { p ->
                        p.copy(x = p.x - scrollSpeed)
                    }

                    // Limpiar plataformas fuera de pantalla
                    platforms = platforms.filter { it.x + it.width > -50f }

                    // Generar nuevas plataformas
                    val lastPlatform = platforms.maxByOrNull { it.x }
                    if (lastPlatform != null && lastPlatform.x < 500f) {
                        val newX = lastPlatform.x + Random.nextInt(280, 350).toFloat()
                        val newY = Random.nextInt(150, 300).toFloat() // Rango más alto
                        val newW = Random.nextInt(160, 260).toFloat()
                        platforms = platforms + Platform(newX, newY,newW)
                    }

                    // Aplicar gravedad
                    if (!isOnGround) {
                        petVelocityY += 0.8f
                        petY += petVelocityY
                    }

                    // Detección de colisiones con plataformas
                    var foundGround = false
                    for (platform in platforms) {
                        val petBottom = petY + 120f
                        val petLeft = petFixedX + 20f
                        val petRight = petFixedX + 100f

                        // Verificar si está sobre la plataforma
                        if (
                            petRight > platform.x &&
                            petLeft < platform.x + platform.width &&
                            petBottom >= platform.y &&
                            petBottom <= platform.y + 30 &&
                            petVelocityY >= 0
                        ) {
                            petY = platform.y - 120f
                            petVelocityY = 0f
                            isOnGround = true
                            isJumping = false
                            foundGround = true

                            // Contar puntos solo si es una plataforma nueva
                            if (!platform.counted && platform.id != lastPlatformId) {
                                platform.counted = true
                                lastPlatformId = platform.id
                                score++
                            }
                            break
                        }
                    }

                    if (!foundGround) {
                        isOnGround = false
                    }

                    // Game Over
                    if (petY > 500f) {
                        gameState = GameState.GAME_OVER
                        showDialog = true
                    }

                    // Aumentar dificultad progresivamente
                    if (score > 0 && score % 10 == 0) {
                        scrollSpeed = (4f + score * 0.1f).coerceAtMost(8f)
                    }
                }
            }
        }
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF2D72DA))
            .clickable(
                enabled = gameState == GameState.PLAYING && gameStarted,
                indication = null,
                interactionSource = remember { MutableInteractionSource() }
            ) {
                if (isOnGround && !isJumping) {
                    isJumping = true
                    isOnGround = false
                    petVelocityY = -17f
                }
            }
    ) {

        Canvas(modifier = Modifier.fillMaxSize()) { clouds() }

        // Botón de retroceso
        IconButton(
            onClick = { navController.navigate("MainView") },
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(16.dp)
                .zIndex(10f)
        ) {
            Icon(
                imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                contentDescription = "Back",
                tint = Color.White,
                modifier = Modifier.size(40.dp)
            )
        }

        // Marcador de puntos
        Text(
            text = "Puntuación: $score",
            color = Color.Black,
            fontSize = 28.sp,
            fontWeight = FontWeight.Bold,
            fontFamily = cherryFamily,
            modifier = Modifier
                .align(Alignment.TopEnd)
                .padding(16.dp)
        )

        // Countdown al inicio
        if (!gameStarted && countdown > 0) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color.Black.copy(alpha = 0.5f)),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = countdown.toString(),
                    color = Color.White,
                    fontSize = 120.sp,
                    fontWeight = FontWeight.Bold,
                    fontFamily = cherryFamily
                )
            }
        }

        BoxWithConstraints(modifier = Modifier.fillMaxSize()) {

            // Dibujar plataformas
            platforms.forEach { platform ->
                Image(
                    painter = painterResource(id = R.drawable.plataforma_grande),
                    contentDescription = "Platform",
                    modifier = Modifier
                        .offset(platform.x.dp, platform.y.dp)
                        .size(platform.width.dp, 60.dp)
                )
            }

            // Dibujar mascota
            Image(
                painter = painterResource(id = R.drawable.mascota),
                contentDescription = "Pet",
                modifier = Modifier
                    .offset(petFixedX.dp, petY.dp)
                    .size(120.dp)
                    .graphicsLayer {
                        if (isOnGround) {
                            rotationZ = runAnimation.value * 5f
                            // Rebote vertical continuo
                            translationY = -bounceAnimation.value * 12f
                            scaleX = 1f + (bounceAnimation.value * 0.05f)
                            scaleY = 1f - (bounceAnimation.value * 0.05f)
                        } else {
                            rotationZ = (petVelocityY * 1.5f).coerceIn(-25f, 25f)
                            scaleX = 1f
                            scaleY = 1f
                        }
                    }
                    .zIndex(5f)
            )
        }

        // Diálogo de Game Over
        if (showDialog) {
            AlertDialog(
                onDismissRequest = {},
                title = {
                    Text("¡Juego Terminado!", fontFamily = cherryFamily, fontSize = 28.sp)
                },
                text = {
                    Text(
                        "Plataformas saltadas: $score\n\n¡Intenta superar tu récord!",
                        fontSize = 18.sp
                    )
                },
                confirmButton = {
                    // Boton de reinicio
                    Button(
                        onClick = {
                            gameState = GameState.PLAYING
                            score = 0
                            scrollSpeed = 5f
                            lastPlatformId = -1
                            countdown = 3
                            gameStarted = false
                            platforms = listOf(
                                Platform(0f, 320f, 400f, counted = true),
                                Platform(500f, 280f, 200f),
                                Platform(800f, 220f, 180f),
                                Platform(1100f, 290f, 220f)
                            )
                            petY = 200f
                            petVelocityY = 0f
                            isOnGround = false
                            isJumping = false
                            showDialog = false
                            coroutineScope.launch {
                                runAnimation.snapTo(0f)
                                bounceAnimation.snapTo(0f)
                            }
                        }
                    ) {
                        Text("Reintentar")
                    }
                },
                dismissButton = {
                    Button(
                        onClick = { navController.navigate("MainView") }
                    ) { Text("Salir") }
                }
            )
        }
    }
}

fun DrawScope.clouds() {
    val w = size.width
    val h = size.height
    val col = Color(0xFFE8F4F8).copy(alpha = 0.9f)

    drawCloudAt(Offset(w * 0.15f, h * 0.20f), 150f, col)
    drawCloudAt(Offset(w * 0.45f, h * 0.10f), 180f, col)
    drawCloudAt(Offset(w * 0.70f, h * 0.25f), 160f, col)
    drawCloudAt(Offset(w * 0.90f, h * 0.12f), 140f, col)
}

fun DrawScope.drawCloudAt(center: Offset, size: Float, col: Color) {
    drawCircle(col, size * 0.4f, center)
    drawCircle(col, size * 0.35f, Offset(center.x - size * 0.3f, center.y))
    drawCircle(col, size * 0.35f, Offset(center.x + size * 0.3f, center.y))
    drawCircle(col, size * 0.3f, Offset(center.x - size * 0.15f, center.y - size * 0.25f))
    drawCircle(col, size * 0.3f, Offset(center.x + size * 0.15f, center.y - size * 0.25f))
}
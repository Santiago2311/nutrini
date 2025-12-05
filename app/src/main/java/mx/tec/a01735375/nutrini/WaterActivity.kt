// imports (add the ones you need)
package mx.tec.a01735375.nutrini

import android.content.pm.ActivityInfo
import android.speech.tts.TextToSpeech
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlin.math.abs
import kotlin.math.roundToInt
import kotlin.random.Random
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.toSize
import androidx.compose.foundation.Canvas
import androidx.compose.material.icons.Icons
import androidx.compose.ui.draw.drawBehind
import androidx.compose.material3.IconButton
import androidx.compose.material3.Icon
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.Help
import androidx.compose.material.icons.filled.Help
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
import androidx.compose.ui.layout.ContentScale
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.layout.positionInRoot
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.intl.Locale
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.zIndex
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController

// keep your data class (mutable coordinates in game loop are done by replacing objects)
data class FallingItem(
    val id: Int,
    val isWater: Boolean,
    val x: Float,
    val y: Float,
    val speed: Float
)

// ViewModel that owns all game state and the game loop
class WaterGameViewModel : ViewModel() {

    // Visible state
    var petXOffset by mutableStateOf(0f)
        private set

    var petYPosition by mutableStateOf(0f)
        private set

    var score by mutableStateOf(0)
        private set

    var lives by mutableStateOf(3)
        private set

    var gameOver by mutableStateOf(false)
        private set

    // screen size (px)
    var screenWidth = 0f
    var screenHeight = 0f

    // mutable list of falling items
    val fallingItems = mutableStateListOf<FallingItem>()

    // internal
    private var nextItemId = 0

    // Sizes (px) — NO CUSTOM SETTERS!
    var petSizePx = 150f
    var petHitboxWidthPx = 100f
    var petHitboxHeightPx = 80f
    var itemSizePx = 80f

    fun setScreenSize(w: Float, h: Float) {
        screenWidth = w
        screenHeight = h
    }

    fun setPetY(y: Float) {
        petYPosition = y
    }

    fun movePetTo(x: Float) {
        petXOffset = x.coerceIn(0f, (screenWidth - petSizePx).coerceAtLeast(0f))
    }

    private fun spawnItem() {
        if (screenWidth <= 0f) return
        val spawnX = Random.nextFloat() * (screenWidth - itemSizePx)
        val isWater = Random.nextFloat() > 0.3f

        fallingItems += FallingItem(
            id = nextItemId++,
            isWater = isWater,
            x = spawnX,
            y = -itemSizePx,
            speed = Random.nextFloat() * 2f + 3f
        )
    }

    private fun updateItems() {
        if (screenHeight <= 0f) return

        val platformY = screenHeight * 0.9f
        val newList = mutableListOf<FallingItem>()

        for (item in fallingItems) {
            val newY = item.y + item.speed

            if (newY + itemSizePx >= platformY) continue

            var collided = false

            val petTopY = petYPosition
            val petBottomY = petYPosition + petHitboxHeightPx

            if (newY + itemSizePx > petTopY && newY < petBottomY) {
                val petCenterX = petXOffset + petSizePx / 2f
                val itemCenterX = item.x + itemSizePx / 2f
                val dist = abs(itemCenterX - petCenterX)

                if (dist < petHitboxWidthPx / 2f) {
                    collided = true
                    if (item.isWater) score += 1
                    else {
                        lives--
                        if (lives <= 0) gameOver = true
                    }
                }
            }

            if (!collided)
                newList += item.copy(y = newY)
        }

        fallingItems.clear()
        fallingItems.addAll(newList)
    }

    init {
        viewModelScope.launch {
            while (true) {
                delay(16L)

                if (!gameOver && Random.nextFloat() < 0.005f && screenWidth > 0)
                    spawnItem()

                if (!gameOver)
                    updateItems()
            }
        }
    }

    fun resetGame() {
        fallingItems.clear()
        score = 0
        lives = 3
        gameOver = false
        petXOffset = 0f
        nextItemId = 0
    }
}

@Composable
fun WaterView(
    navController: NavController,
    vm: WaterGameViewModel = viewModel(),
    viewModel: ScoresViewModel = viewModel()
) {
    LockScreenOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)
    val context = LocalContext.current

    var tts by remember { mutableStateOf<TextToSpeech?>(null) }
    var ttsInitialized by remember { mutableStateOf(false) }
    var showInstructions by remember { mutableStateOf(false) }

    DisposableEffect(Unit) {
        tts = TextToSpeech(context) { status ->
            if (status == TextToSpeech.SUCCESS) {
                tts?.language = java.util.Locale("es", "MX")
                ttsInitialized = true
            }
        }
        onDispose {
            tts?.stop()
            tts?.shutdown()
        }
    }

    val petSizeDp = 150.dp
    val itemSizeDp = 80.dp
    val hitboxWdp = 100.dp
    val hitboxHdp = 80.dp

    val density = LocalDensity.current

    // Convert needed dp sizes to px in the VM
    LaunchedEffect(Unit) {
        vm.petSizePx = with(density) { petSizeDp.toPx() }
        vm.itemSizePx = with(density) { itemSizeDp.toPx() }
        vm.petHitboxWidthPx = with(density) { hitboxWdp.toPx() }
        vm.petHitboxHeightPx = with(density) { hitboxHdp.toPx() }
    }

    // Root container that gives us screen size
    BoxWithConstraints(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF2D72DA))
            .onGloballyPositioned { coords ->
                vm.setScreenSize(
                    coords.size.width.toFloat(),
                    coords.size.height.toFloat()
                )
            }
    ) {
        val screenHeightPx = with(density) { maxHeight.toPx() }
        val petHeightPx = with(density) { petSizeDp.toPx() }

        // PLATFORM starts at 90% of the screen height
        val platformTopPx = screenHeightPx * 0.90f
        val platformHeightPx = screenHeightPx - platformTopPx
        val platformHeightDp = with(density) { platformHeightPx.toDp() }

        // PET sits ON TOP of the platform
        val petYOffsetPx = platformTopPx - petHeightPx

        // ---------------------------------------------
        // TOP UI (score and lives)
        // ---------------------------------------------
        TopSectionGame(
            modifier = Modifier
                .fillMaxWidth()
                .height(maxHeight * 0.65f),
            navController = navController,
            score = vm.score,
            lives = vm.lives,
            onHelpClick = {
                showInstructions = true
                // Reproducir instrucciones con TTS
                if (ttsInitialized) {
                    val instructions =
                        "Instrucciones del juego: Arrastra a la mascota de izquierda a derecha " +
                                "para atrapar los vasos de agua que caen. " +
                                "Evita las latas de refresco, ya que te quitan vidas. " +
                                "El objetivo es atrapar 8 vasos de agua sin perder todas tus vidas. " +
                                "Tienes 3 vidas para completar el juego. " +
                                "Consigue 2 puntos para una estrella, 5 puntos para dos estrellas, y 8 puntos para tres estrellas."
                    tts?.speak(
                        instructions,
                        TextToSpeech.QUEUE_FLUSH,
                        null,
                        "instructions"
                    )
                }
            }
        )

        // ---------------------------------------------
        // FALLING ITEMS
        // ---------------------------------------------
        vm.fallingItems.forEach { item ->
            Image(
                painter = painterResource(
                    id = if (item.isWater)
                        R.drawable.vaso_agua
                    else
                        R.drawable.lata_refresco
                ),
                contentDescription = null,
                modifier = Modifier
                    .offset { IntOffset(item.x.roundToInt(), item.y.roundToInt()) }
                    .size(itemSizeDp),
                contentScale = ContentScale.Fit
            )
        }
            // ---------------------------------------------
            // PLATFORM — FULL HEIGHT FROM 90% TO BOTTOM
            // ---------------------------------------------
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(platformHeightDp)
                    .offset { IntOffset(0, platformTopPx.roundToInt()) }
            ) {
                Image(
                    painter = painterResource(id = R.drawable.plataforma_grande),
                    contentDescription = "Plataforma",
                    modifier = Modifier.fillMaxSize(),
                    contentScale = ContentScale.FillBounds
                )
            }

            // ---------------------------------------------
            // PET (SITS ON PLATFORM + DRAGGABLE)
            // ---------------------------------------------
            Box(
                modifier = Modifier.fillMaxSize()
            ) {
                val scoreData = viewModel.state.collectAsState().value
                var petImageVal: Painter
                if (scoreData.score3 <= 0.5) {
                    petImageVal = painterResource(id = R.drawable.mascota_ejercicio)
                } else if (scoreData.score2 <= 0.5) {
                    petImageVal = painterResource(id = R.drawable.mascota_agua)
                } else if (scoreData.score1 <= 0.5) {
                    petImageVal = painterResource(id = R.drawable.mascota_comida)
                } else {
                    petImageVal = painterResource(id = R.drawable.mascota)
                }
                Image(
                    painter = petImageVal,
                    contentDescription = "Pet",
                    modifier = Modifier
                        .offset { IntOffset(vm.petXOffset.roundToInt(), petYOffsetPx.roundToInt()) }
                        .size(petSizeDp)
                        .pointerInput(Unit) {
                            detectDragGestures { change, dragAmount ->
                                change.consume()
                                vm.movePetTo(vm.petXOffset + dragAmount.x) // clamps inside VM
                            }
                        }
                        .onGloballyPositioned { coords ->
                            vm.setPetY(coords.positionInRoot().y)
                        },
                    contentScale = ContentScale.Fit
                )
            }

        Box(
            modifier = Modifier.fillMaxSize()
        ) {
            val scoreData = viewModel.state.collectAsState().value
            var petImageVal: Painter
            if (scoreData.score3 <= 0.5) {
                petImageVal = painterResource(id = R.drawable.mascota_ejercicio)
            } else if (scoreData.score2 <= 0.5) {
                petImageVal = painterResource(id = R.drawable.mascota_agua)
            } else if (scoreData.score1 <= 0.5) {
                petImageVal = painterResource(id = R.drawable.mascota_comida)
            } else {
                petImageVal = painterResource(id = R.drawable.mascota)
            }
            Image(
                painter = petImageVal,
                contentDescription = "Pet",
                modifier = Modifier
                    .offset { IntOffset(vm.petXOffset.roundToInt(), petYOffsetPx.roundToInt()) }
                    .size(petSizeDp)
                    .pointerInput(Unit) {
                        detectDragGestures { change, dragAmount ->
                            change.consume()
                            vm.movePetTo(vm.petXOffset + dragAmount.x) // clamps inside VM
                        }
                    }
                    .onGloballyPositioned { coords ->
                        vm.setPetY(coords.positionInRoot().y)
                    },
                contentScale = ContentScale.Fit
            )
        }

        // ---------------------------------------------
        // INSTRUCTIONS DIALOG
        // ---------------------------------------------
        if (showInstructions) {
            AlertDialog(
                onDismissRequest = {
                    showInstructions = false
                    tts?.stop()
                },
                title = {
                    Text(
                        text = "📖 Instrucciones",
                        fontFamily = cherryFamily,
                        fontSize = 24.sp,
                        textAlign = TextAlign.Center,
                        modifier = Modifier.fillMaxWidth()
                    )
                },
                text = {
                    Column(
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text(
                            text = "• Arrastra a la mascota de izquierda a derecha\n\n" +
                                    "• Atrapa los vasos de agua que caen\n\n" +
                                    "• Evita las latas de refresco (te quitan vidas)\n\n" +
                                    "• Objetivo: Atrapar 8 vasos de agua\n\n" +
                                    "• Tienes 3 vidas\n\n" +
                                    "• Sistema de estrellas:\n" +
                                    "  - 1 estrella: 2 puntos\n" +
                                    "  - 2 estrellas: 5 puntos\n" +
                                    "  - 3 estrellas: 8 puntos\n\n" +
                                    "• ¡Consigue el mejor puntaje!",
                            fontSize = 16.sp,
                            lineHeight = 20.sp
                        )
                    }
                },
                confirmButton = {
                    Button(
                        onClick = {
                            showInstructions = false
                            tts?.stop()
                        }
                    ) {
                        Text("Entendido")
                    }
                }
            )
        }

            // ---------------------------------------------
            // GAME OVER OVERLAY
            // ---------------------------------------------
        if (vm.gameOver) {
            val stars = when {
                vm.score >= 8 -> 3
                vm.score >= 5 -> 2
                vm.score >= 2 -> 1
                else -> 0
            }
            if (stars == 3) {
                viewModel.saveScore(2, 1f)
            } else if (stars == 2){
                viewModel.saveScore(2, 0.75f)
            } else if (stars == 1) {
                viewModel.saveScore(2, 0.5f)
            } else {
                viewModel.saveScore(2, 0.25f)
            }

            AlertDialog(
                onDismissRequest = {},
                title = {
                    Text(
                        text = "¡Juego Terminado!",
                        fontFamily = cherryFamily,
                        fontSize = 28.sp
                    )
                },
                text = {
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            text = "Vasos atrapados: ${vm.score}",
                            fontSize = 20.sp
                        )
                        Row(
                            horizontalArrangement = Arrangement.spacedBy(6.dp),
                            modifier = Modifier.padding(vertical = 12.dp)
                        ) {
                            repeat(3) { index ->
                                Text(
                                    text = if (index < stars) "⭐" else "☆",
                                    fontSize = 40.sp
                                )
                            }
                        }
                        Text(
                            text = "¡Intenta superar tu récord!",
                            fontSize = 20.sp
                        )
                    }
                },
                confirmButton = {
                    Button(
                        onClick = {
                            vm.resetGame()
                        }
                    ) {
                        Text("Reintentar")
                    }
                },
                dismissButton = {
                    Button(
                        onClick = {
                            navController.navigate("MainView")
                        }
                    ) {
                        Text("Salir")
                    }
                }
            )
        }
    }
}


@Composable fun TopSectionGame(
    modifier: Modifier = Modifier,
    navController: NavController,
    score: Int,
    lives: Int,
    onHelpClick: () -> Unit = {},
    viewModel: ScoresViewModel = viewModel()
) {
    var textColor = Color.White
    if (score >= 8){
        textColor = Color.Green
    }
    Box(modifier = modifier) {
    // Back arrow
        IconButton(
            onClick = {
                navController.navigate("MainView")
                val stars = when {
                    score >= 8 -> 3
                    score >= 5 -> 2
                    score >= 2 -> 1
                    else -> 0
                }
                if (stars == 3) {
                    viewModel.saveScore(2, 1f)
                } else if (stars == 2){
                    viewModel.saveScore(2, 0.75f)
                } else if (stars == 1) {
                    viewModel.saveScore(2, 0.5f)
                } else {
                    viewModel.saveScore(2, 0.25f)
                }
                      },
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(top = 32.dp, start = 16.dp) ) {
            Icon(
                imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                contentDescription = "Back",
                tint = Color.White,
                modifier = Modifier.size(40.dp)
            )
        }

        IconButton(
            onClick = onHelpClick,
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(start = 70.dp, top = 32.dp)
                .zIndex(10f)
        ) {
            Icon(
                imageVector = Icons.Filled.Help,
                contentDescription = "Ayuda",
                tint = Color.White,
                modifier = Modifier.size(40.dp)
            )
        }
        // Score and Lives display
        Column(
            modifier = Modifier
                .align(Alignment.TopEnd)
                .padding(top = 32.dp, end = 16.dp)
        ) {
            Text(
                text = "Vasos: $score/8",
                color = textColor,
                fontSize = 32.sp,
                fontWeight = FontWeight.Bold,
                fontFamily = cherryFamily
            )
            Text( text = "Vidas: $lives",
                color = Color.White,
                fontSize = 32.sp,
                fontWeight = FontWeight.Bold,
                fontFamily = cherryFamily )
        }
        // Clouds drawn with Canvas
        Canvas(
            modifier = Modifier.fillMaxSize()
        ) {
            drawClouds(this)
        }
    }
}

fun drawClouds(drawScope: DrawScope) {
    with(drawScope) {
        val width = size.width
        val height = size.height
        // Cloud 1 (top left)
        drawCloud(
            center = Offset(width * 0.2f, height * 0.20f),
            size = 100.dp.toPx()
        )
        // Cloud 2 (middle right)
        drawCloud(
            center = Offset(width * 0.85f, height * 0.45f),
            size = 100.dp.toPx()
        )
        // Cloud 3 (bottom left)
        drawCloud(
            center = Offset(width * 0.15f, height * 0.75f),
            size = 100.dp.toPx()
        )
    }
}

fun DrawScope.drawCloud(center: Offset, size: Float) {
    val cloudColor = Color(0xFFE8F4FD).copy(alpha = 0.8f)
    val radius = size / 4
    // Main cloud circles
    drawCircle(
        color = cloudColor,
        radius = radius,
        center = Offset(center.x - radius * 0.5f, center.y)
    )
    drawCircle(
        color = cloudColor,
        radius = radius * 1.2f,
        center = center
    )
    drawCircle(
        color = cloudColor,
        radius = radius * 0.8f,
        center = Offset(center.x + radius * 0.8f, center.y)
    )
    drawCircle(
        color = cloudColor,
        radius = radius * 0.6f,
        center = Offset(center.x - radius * 1.2f, center.y + radius * 0.3f)
    )
    drawCircle(
        color = cloudColor,
        radius = radius * 0.7f,
        center = Offset(center.x + radius * 1.1f, center.y + radius * 0.2f)
    )
}

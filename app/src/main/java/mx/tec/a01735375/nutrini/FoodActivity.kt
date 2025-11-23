package mx.tec.a01735375.nutrini

import android.content.pm.ActivityInfo
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.awaitFirstDown
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.gestures.waitForUpOrCancellation
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.zIndex
import androidx.navigation.NavController
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlin.math.pow
import kotlin.math.sqrt

enum class FoodCategory {
    fruits_vegetables, cereals, healthy_fats, legumes, animal_origin
}

data class Food(
    val id: String,
    val iconResource: Int,
    val label: String,
    val category: FoodCategory
)

data class PlacedFood(
    val food: Food,
    val position: Offset,
    val id: Int = System.currentTimeMillis().toInt()
)

@Composable
fun FoodView(navController: NavController) {
    LockScreenOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)

    var foodsOnPlate by remember { mutableStateOf<List<PlacedFood>>(emptyList()) }
    var plateBounds by remember { mutableStateOf<Rect?>(null) }
    var showDialog by remember { mutableStateOf(false) }
    var dialogMessage by remember { mutableStateOf("") }
    var isWinner by remember { mutableStateOf(false) }

    // Estado para la imagen arrastrada
    var draggingFood by remember { mutableStateOf<Food?>(null) }
    var draggingPosition by remember { mutableStateOf<Offset?>(null) }

    Box(modifier = Modifier.fillMaxSize()) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .background(Color(0xFF4A90E2))
        ) {
            // Sección de alimentos
            TopFoodSection(
                navController = navController,
                onFoodDragStart = { food, position ->
                    draggingFood = food
                    draggingPosition = position
                },
                onFoodDragUpdate = { position ->
                    draggingPosition = position
                },
                onFoodDragEnd = { food, finalPosition ->
                    // Verificar si está dentro del plato
                    plateBounds?.let { bounds ->
                        if (isInsidePlate(finalPosition, bounds)) {
                            // Agregar alimento al plato exactamente donde se soltó
                            foodsOnPlate = foodsOnPlate + PlacedFood(food, finalPosition)
                        }
                    }
                    draggingFood = null
                    draggingPosition = null
                }
            )

            // Fondo blanco
            Column(
                modifier = Modifier
                    .weight(1f)
                    .fillMaxWidth()
                    .background(Color.White)
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(top = 20.dp, end = 20.dp),
                    horizontalArrangement = Arrangement.End
                ) {
                    Image(
                        painter = painterResource(id = R.drawable.eliminar),
                        contentDescription = "Trash",
                        modifier = Modifier.size(60.dp)
                    )
                }

                // Área del plato
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .fillMaxWidth()
                        .padding(horizontal = 32.dp),
                    contentAlignment = Alignment.Center
                ) {
                    // Plato
                    Image(
                        painter = painterResource(id = R.drawable.plato_juego),
                        contentDescription = "Plate",
                        modifier = Modifier
                            .size(400.dp)
                            .onGloballyPositioned { coordinates ->
                                plateBounds = coordinates.boundsInWindow()
                            },
                        contentScale = ContentScale.Fit
                    )

                    // Contenedor para alimentos en el plato
                    Box(
                        modifier = Modifier
                            .size(400.dp)
                    ) {
                        foodsOnPlate.forEach { placedFood ->
                            key(placedFood.id) {
                                var currentPosition by remember(placedFood.id) { mutableStateOf(placedFood.position) }

                                Image(
                                    painter = painterResource(id = placedFood.food.iconResource),
                                    contentDescription = placedFood.food.label,
                                    modifier = Modifier
                                        .offset {
                                            // Calcular offset relativo al contenedor del plato
                                            plateBounds?.let { bounds ->
                                                val offsetX = (currentPosition.x - bounds.left - 30.dp.toPx()).toInt()
                                                val offsetY = (currentPosition.y - bounds.top - 30.dp.toPx()).toInt()
                                                androidx.compose.ui.unit.IntOffset(offsetX, offsetY)
                                            } ?: androidx.compose.ui.unit.IntOffset.Zero
                                        }
                                        .size(60.dp)
                                        .pointerInput(placedFood.id) {
                                            detectDragGestures(
                                                onDrag = { change, dragAmount ->
                                                    change.consume()
                                                    currentPosition = Offset(
                                                        currentPosition.x + dragAmount.x,
                                                        currentPosition.y + dragAmount.y
                                                    )
                                                },
                                                onDragEnd = {
                                                    // Verificar si sigue dentro del plato
                                                    plateBounds?.let { bounds ->
                                                        if (!isInsidePlate(currentPosition, bounds)) {
                                                            // Eliminar del plato si está fuera
                                                            foodsOnPlate = foodsOnPlate.filter {
                                                                it.id != placedFood.id
                                                            }
                                                        }
                                                    }
                                                }
                                            )
                                        },
                                    contentScale = ContentScale.Fit
                                )
                            }
                        }
                    }
                }
            }

            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(Color.White)
                    .padding(16.dp),
                contentAlignment = Alignment.Center
            ) {
                Button(
                    onClick = {
                        val result = checkBalancedPlate(foodsOnPlate)
                        isWinner = result.first
                        dialogMessage = result.second
                        showDialog = true
                    },
                    modifier = Modifier
                        .width(140.dp)
                        .height(80.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFFFFB74D)
                    ),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Text(
                        text = "¡Listo!",
                        color = Color.White,
                        fontSize = 28.sp,
                        fontWeight = FontWeight.Normal,
                        fontFamily = cherryFamily
                    )
                }
            }
        }

        // Overlay global para la imagen siendo arrastrada
        if (draggingFood != null && draggingPosition != null) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .zIndex(9999f)
            ) {
                Image(
                    painter = painterResource(id = draggingFood!!.iconResource),
                    contentDescription = "${draggingFood!!.label} dragging",
                    modifier = Modifier
                        .offset {
                            androidx.compose.ui.unit.IntOffset(
                                (draggingPosition!!.x - 40.dp.toPx()).toInt(),
                                (draggingPosition!!.y - 40.dp.toPx()).toInt()
                            )
                        }
                        .size(80.dp),
                    contentScale = ContentScale.Fit,
                    alpha = 0.9f
                )
            }
        }

        // Mensaje de resultado
        if (showDialog) {
            AlertDialog(
                onDismissRequest = { showDialog = false },
                title = {
                    Text(
                        text = if (isWinner) "¡Felicidades! 🎉" else "¡Intenta de nuevo!",
                        fontFamily = cherryFamily,
                        fontSize = 24.sp
                    )
                },
                text = {
                    Text(
                        text = dialogMessage,
                        fontSize = 18.sp
                    )
                },
                confirmButton = {
                    Button(
                        onClick = {
                            showDialog = false
                            if (!isWinner) {
                                foodsOnPlate = emptyList()
                            }
                        }
                    ) {
                        Text(if (isWinner) "¡Genial!" else "Reintentar")
                    }
                }
            )
        }
    }
}

@Composable
fun TopFoodSection(
    navController: NavController,
    onFoodDragStart: (Food, Offset) -> Unit,
    onFoodDragUpdate: (Offset) -> Unit,
    onFoodDragEnd: (Food, Offset) -> Unit
) {
    Column(
        modifier = Modifier.padding(bottom = 30.dp)
    ) {
        // Flecha hacia atras
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 32.dp, start = 16.dp),
            horizontalArrangement = Arrangement.Start,
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(onClick = { navController.navigate("MainView") }) {
                Icon(
                    imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                    contentDescription = "Back",
                    tint = Color.White,
                    modifier = Modifier.size(40.dp)
                )
            }
        }

        LazyRow(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 10.dp),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            val foodItems = getFoodList()

            items(foodItems.size) { index ->
                val food = foodItems[index]
                DraggableFoodOption(
                    food = food,
                    onDragStart = { offset -> onFoodDragStart(food, offset) },
                    onDragUpdate = { offset -> onFoodDragUpdate(offset) },
                    onDragEnd = { offset -> onFoodDragEnd(food, offset) }
                )
            }
        }
    }
}

@Composable
fun DraggableFoodOption(
    food: Food,
    onDragStart: (Offset) -> Unit,
    onDragUpdate: (Offset) -> Unit,
    onDragEnd: (Offset) -> Unit
) {
    var itemBounds by remember { mutableStateOf<Rect?>(null) }
    var isDragging by remember { mutableStateOf(false) }
    var isLongPressActive by remember { mutableStateOf(false) }
    var currentDragPosition by remember { mutableStateOf<Offset?>(null) }
    val coroutineScope = rememberCoroutineScope()
    var longPressJob by remember { mutableStateOf<kotlinx.coroutines.Job?>(null) }

    Box(
        modifier = Modifier.width(100.dp)
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier
                .fillMaxWidth()
                .onGloballyPositioned { coordinates ->
                    itemBounds = coordinates.boundsInWindow()
                }
                .pointerInput(food.id) {
                    awaitPointerEventScope {
                        while (true) {
                            val down = awaitFirstDown()

                            longPressJob = coroutineScope.launch {
                                delay(1000L)
                                isLongPressActive = true
                            }

                            // Esperar a que se mueva o se suelte
                            val change = withTimeoutOrNull(1000L) {
                                waitForUpOrCancellation()
                            }

                            if (change == null && isLongPressActive) {
                                // Se cumplió 1 segundo y no se soltó -> activar drag
                                var currentChange = down

                                // Calcular posición inicial absoluta
                                itemBounds?.let { bounds ->
                                    val absolutePos = Offset(
                                        bounds.left + currentChange.position.x,
                                        bounds.top + currentChange.position.y
                                    )
                                    currentDragPosition = absolutePos
                                    isDragging = true
                                    onDragStart(absolutePos)
                                }

                                // Loop de drag
                                do {
                                    val event = awaitPointerEvent()
                                    event.changes.forEach { it.consume() }

                                    val dragChange = event.changes.firstOrNull()
                                    if (dragChange != null && isDragging) {
                                        itemBounds?.let { bounds ->
                                            val absolutePos = Offset(
                                                bounds.left + dragChange.position.x,
                                                bounds.top + dragChange.position.y
                                            )
                                            currentDragPosition = absolutePos
                                            onDragUpdate(absolutePos)
                                        }
                                    }
                                } while (event.changes.any { it.pressed })

                                // Drag terminado
                                currentDragPosition?.let { finalPos ->
                                    onDragEnd(finalPos)
                                }
                            } else {
                                // Se soltó antes de 1 segundo o se canceló
                                longPressJob?.cancel()
                            }

                            // Reset de estados
                            isDragging = false
                            isLongPressActive = false
                            currentDragPosition = null
                            longPressJob = null
                        }
                    }
                }
        ) {
            Box(
                modifier = Modifier.size(90.dp),
                contentAlignment = Alignment.Center
            ) {
                Image(
                    painter = painterResource(id = food.iconResource),
                    contentDescription = food.label,
                    modifier = Modifier
                        .size(80.dp)
                        .padding(4.dp),
                    contentScale = ContentScale.Fit,
                    alpha = if (isDragging) 0.3f else if (isLongPressActive) 0.7f else 1f
                )
            }

            Spacer(modifier = Modifier.height(4.dp))

            Text(
                text = food.label,
                color = Color.White,
                fontSize = 14.sp,
                fontWeight = FontWeight.Normal,
                fontFamily = cherryFamily,
                textAlign = TextAlign.Center,
                maxLines = 2,
                modifier = Modifier.alpha(if (isDragging) 0.5f else 1f)
            )
        }
    }
}

fun getFoodList(): List<Food> {
    return listOf(
        Food("aguacate", R.drawable.aguacate, "Aguacate", FoodCategory.healthy_fats),
        Food("almendra", R.drawable.almendra, "Almendra", FoodCategory.healthy_fats),
        Food("bolillo", R.drawable.bolillo, "Bolillo", FoodCategory.cereals),
        Food("brocoli", R.drawable.brocoli, "Brócoli", FoodCategory.fruits_vegetables),
        Food("cuerno", R.drawable.cuerno, "Cuerno", FoodCategory.cereals),
        Food("frijoles_negros", R.drawable.frijoles_negros, "Frijoles", FoodCategory.legumes),
        Food("garbanzos", R.drawable.garbanzos, "Garbanzos", FoodCategory.legumes),
        Food("habas", R.drawable.habas, "Habas", FoodCategory.legumes),
        Food("huevo", R.drawable.huevo, "Huevo", FoodCategory.animal_origin),
        Food("lentejas", R.drawable.lentejas, "Lentejas", FoodCategory.legumes),
        Food("mani", R.drawable.mani, "Maní", FoodCategory.healthy_fats),
        Food("pan", R.drawable.pan, "Pan", FoodCategory.cereals),
        Food("papa", R.drawable.papa, "Papa", FoodCategory.cereals),
        Food("pera", R.drawable.pera, "Pera", FoodCategory.fruits_vegetables),
        Food("pescado", R.drawable.pescado, "Pescado", FoodCategory.animal_origin),
        Food("pina", R.drawable.pina, "Piña", FoodCategory.fruits_vegetables),
        Food("pollo", R.drawable.pollo, "Pollo", FoodCategory.animal_origin),
        Food("queso", R.drawable.queso, "Queso", FoodCategory.animal_origin),
        Food("res", R.drawable.res, "Res", FoodCategory.animal_origin),
        Food("tomate", R.drawable.tomate, "Tomate", FoodCategory.fruits_vegetables),
        Food("tortilla", R.drawable.tortilla, "Tortilla", FoodCategory.cereals),
        Food("uva", R.drawable.uva, "Uvas", FoodCategory.fruits_vegetables)
    )
}

fun isInsidePlate(position: Offset, plateBounds: Rect): Boolean {
    val centerX = plateBounds.center.x
    val centerY = plateBounds.center.y
    val radius = plateBounds.width / 2 * 0.75f

    val distance = sqrt(
        (position.x - centerX).pow(2) + (position.y - centerY).pow(2)
    )

    return distance <= radius
}

fun checkBalancedPlate(foodsOnPlate: List<PlacedFood>): Pair<Boolean, String> {
    val categories = foodsOnPlate.map { it.food.category }.toSet()

    val hasProtein = categories.contains(FoodCategory.animal_origin)
    val hasCereals = categories.contains(FoodCategory.cereals)
    val hasFruits = categories.contains(FoodCategory.fruits_vegetables)
    val hasLegumes = categories.contains(FoodCategory.legumes)
    val hasFats = categories.contains(FoodCategory.healthy_fats)

    val allCategories = hasProtein && hasCereals && hasFruits && hasLegumes && hasFats

    return if (allCategories) {
        Pair(true, "¡Excelente! Tu plato tiene todos los grupos de alimentos: origen animal, cereales, frutas y vegetales, leguminosas y grasas saludables. ¡Está perfectamente balanceado!")
    } else {
        val missing = mutableListOf<String>()
        if (!hasProtein) missing.add("Origen animal")
        if (!hasCereals) missing.add("Cereales")
        if (!hasFruits) missing.add("Frutas y Vegetales")
        if (!hasLegumes) missing.add("Leguminosas")
        if (!hasFats) missing.add("Grasas saludables")

        Pair(false, "Tu plato no está balanceado. ¡Intenta agregar otros alimentos!")
    }
}
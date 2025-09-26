package mx.tec.a01735375.nutrini

import android.content.pm.ActivityInfo
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import mx.tec.a01735375.nutrini.ui.theme.NutriniTheme

class FoodActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            NutriniTheme {
                //FoodView
            }
        }
    }
}

@Composable
fun FoodView(navController: NavController) {
    LockScreenOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)
    var selectedFood by remember { mutableStateOf<String?>(null) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF4A90E2))
    ) {
        // Top section with back arrow and food options
        TopFoodSection(
            selectedFood = selectedFood,
            onFoodSelected = { selectedFood = it },
            navController
        )

        // White background area with trash icon and plate
        Column(
            modifier = Modifier
                .weight(1f)
                .fillMaxWidth()
                .background(Color.White)
        ) {
            // Trash icon at the top right of white area
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 20.dp, end = 20.dp),
                horizontalArrangement = Arrangement.End
            ) {
                Image(
                    painter = painterResource(id = R.drawable.eliminar),
                    contentDescription = "Trash",
                    modifier = Modifier.size(60.dp),

                    )
            }

            // Plate area
            Box(
                modifier = Modifier
                    .weight(1f)
                    .fillMaxWidth()
                    .padding(horizontal = 32.dp),
                contentAlignment = Alignment.Center
            ) {
                Image(
                    painter = painterResource(id = R.drawable.plato_juego),
                    contentDescription = "Plate",
                    modifier = Modifier.size(400.dp),
                    contentScale = ContentScale.Fit
                )
            }
        }

        // Bottom button
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .background(Color.White)
                .padding(16.dp),
            contentAlignment = Alignment.Center
        ) {
            Button(
                onClick = { /* TODO: Listo functionality */ },
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
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Normal,
                    fontFamily = cherryFamily
                )
            }
        }
    }
}

@Composable
fun TopFoodSection(
    selectedFood: String?,
    onFoodSelected: (String) -> Unit,
    navController: NavController
) {
    Column(
        modifier = Modifier
            .padding(bottom = 30.dp)
    ) {
        // Back arrow only
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

        // Food options
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 10.dp),
            horizontalArrangement = Arrangement.SpaceEvenly
        ) {
            FoodOption(
                iconResource = R.drawable.huevo_frito,
                label = "Huevo",
                isSelected = selectedFood == "huevo",
                onClick = { onFoodSelected("huevo") }
            )

            FoodOption(
                iconResource = R.drawable.uva,
                label = "Uvas",
                isSelected = selectedFood == "uva",
                onClick = { onFoodSelected("uva") }
            )

            FoodOption(
                iconResource = R.drawable.queso,
                label = "Queso",
                isSelected = selectedFood == "queso",
                onClick = { onFoodSelected("queso") }
            )

        }
    }
}

@Composable
fun FoodOption(
    iconResource: Int,
    label: String,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier.clickable { onClick() }
    ) {
        // Food icon with selection indicator
        Box {
            Image(
                painter = painterResource(id = iconResource),
                contentDescription = label,
                modifier = Modifier
                    .size(80.dp)
                    .padding(4.dp),
                contentScale = ContentScale.Fit
            )

            // Selection indicator
            if (isSelected) {
                Box(
                    modifier = Modifier
                        .size(60.dp)
                        .background(
                            Color.White.copy(alpha = 0.3f),
                            RoundedCornerShape(8.dp)
                        )
                )
            }
        }

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = label,
            color = Color.White,
            fontSize = 22.sp,
            fontWeight = FontWeight.Normal,
            fontFamily = cherryFamily,
            textAlign = TextAlign.Center
        )
    }
}

@Preview(showBackground = true)
@Composable
fun FoodSelectionScreenPreview() {
    //FoodView()
}
package mx.tec.a01735375.nutrini

import android.annotation.SuppressLint
import android.content.pm.ActivityInfo
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.layout.ModifierLocalBeyondBoundsLayout
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import mx.tec.a01735375.nutrini.ui.theme.NutriniTheme

class WaterActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            NutriniTheme {
                //WaterView()
            }
        }
    }
}

@Composable
fun WaterView(navController: NavController) {
    LockScreenOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF2D72DA))
    ) {
        Column(
            modifier = Modifier.fillMaxSize()
        ) {
            // Top section with back arrow and floating elements
            TopSection(
                modifier = Modifier
                    .weight(1f)
                    .fillMaxWidth(),
                navController
            )

            // Pet area
            PetArea(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(200.dp)
            )

            // Bottom colored strips
            BottomColorStrips()
        }
    }
}

@Composable
fun TopSection(modifier: Modifier = Modifier, navController: NavController) {
    Box(modifier = modifier) {
        // Back arrow
        IconButton(
            onClick = { navController.navigate("MainView") },
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(top = 32.dp, start = 16.dp)
        ) {
            Icon(
                imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                contentDescription = "Back",
                tint = Color.White,
                modifier = Modifier.size(40.dp)
            )
        }

        // Clouds drawn with Canvas
        Canvas(
            modifier = Modifier.fillMaxSize()
        ) {
            drawClouds(this)
        }

        // Floating icon elements
        FloatingIcons()
    }
}

@SuppressLint("UnusedBoxWithConstraintsScope")
@Composable
fun FloatingIcons() {
    BoxWithConstraints {
        val screenWidth = maxWidth
        val screenHeight = maxHeight

        // Water glass icon 1 (top right)
        Image(
            painter = painterResource(id = R.drawable.vaso_agua),
            contentDescription = "Water Glass",
            modifier = Modifier
                .offset(
                    x = screenWidth * 0.7f,
                    y = screenHeight * 0.08f
                )
                .size(80.dp)
        )

        // Soda can icon (middle left)
        Image(
            painter = painterResource(id = R.drawable.lata_refresco),
            contentDescription = "Soda Can",
            modifier = Modifier
                .offset(
                    x = screenWidth * 0.15f,
                    y = screenHeight * 0.4f
                )
                .size(80.dp)
        )

        // Water glass icon 2 (bottom right)
        Image(
            painter = painterResource(id = R.drawable.vaso_agua),
            contentDescription = "Water Glass",
            modifier = Modifier
                .offset(
                    x = screenWidth * 0.75f,
                    y = screenHeight * 0.65f
                )
                .size(80.dp)
        )
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

// Function to draw clouds
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

@Composable
fun PetArea(modifier: Modifier = Modifier) {
    Box(
        modifier = modifier
            .background(Color(0xFF2D72DA))
            .padding(16.dp),
        contentAlignment = Alignment.Center
    ) {
        Image(
            painter = painterResource(id = R.drawable.mascota),
            contentDescription = "Pet Image",
            modifier = Modifier
                .fillMaxHeight()
                .aspectRatio(1f),
            contentScale = ContentScale.Fit
        )
    }
}

@Composable
fun BottomColorStrips() {
    Column {
        /*// Green strip
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(60.dp)
                .background(Color(0xFF4CAF50))
        )*/

        // Orange strip
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(60.dp)
        ){
            Image(
                painter = painterResource(id = R.drawable.plataforma_grande),
                contentDescription = "Plataforma",
                modifier = Modifier.fillMaxWidth().aspectRatio(1f).offset(y = 28.dp)
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun PetWaterGameScreenPreview() {
    //WaterView()
}
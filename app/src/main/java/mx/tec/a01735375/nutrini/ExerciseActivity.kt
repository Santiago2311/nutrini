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
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import mx.tec.a01735375.nutrini.ui.theme.NutriniTheme

class ExerciseActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            NutriniTheme {
                //ExerciseView
            }
        }
    }
}

@Composable
fun ExerciseView(navController: NavController) {
    LockScreenOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE)
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF2D72DA))
    ) {
        Column (
            modifier = Modifier.fillMaxSize()
        ){
            TopPart(
                modifier = Modifier
                    //.weight(1f)
                    .fillMaxWidth(),
                navController
            )
        }
        Pet(
            modifier = Modifier
                .fillMaxWidth()
        )
        Platforms(
            modifier = Modifier
                .fillMaxWidth()
        )
    }
}

@Composable
fun TopPart(modifier: Modifier = Modifier, navController: NavController) {
    Box(modifier = modifier) {
        // Back arrow
        IconButton(
            onClick = { navController.navigate("MainView") },
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(16.dp)
        ) {
            Icon(
                imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                contentDescription = "Back",
                tint = Color.White,
                modifier = Modifier.size(40.dp)
            )
        }

        Canvas(
            modifier = Modifier.fillMaxSize()
        ) {
            clouds(this)
        }
    }
}

@SuppressLint("UnusedBoxWithConstraintsScope")
@Composable
fun Pet(modifier: Modifier = Modifier) {
    BoxWithConstraints {
        val screenWidth = maxWidth
        val screenHeigth = maxHeight
        Image(
            painter = painterResource(id = R.drawable.mascota),
            contentDescription = "Pet Image",
            modifier = Modifier
                .offset(
                    x = maxWidth * 0.01f,
                    y = maxHeight * 0.5f
                )
                .size(170.dp)
        )
    }
}

@SuppressLint("UnusedBoxWithConstraintsScope")
@Composable
fun Platforms(modifier: Modifier = Modifier) {
    BoxWithConstraints {
        val screenWidth = maxWidth
        val screenHeight = maxHeight

        Image(
            painter = painterResource(id = R.drawable.plataforma_grande),
            contentDescription = "Platform",
            modifier = Modifier
                .offset(
                    x = screenWidth * -0.01f,
                    y = screenHeight * 0.65f
                )
                .size(300.dp)
        )
        Image(
            painter = painterResource(id = R.drawable.plataforma_grande),
            contentDescription = "Platform",
            modifier = Modifier
                .offset(
                    x = screenWidth * 0.7f,
                    y = screenHeight * 0.65f
                )
                .size(300.dp)
        )
        Image(
            painter = painterResource(id = R.drawable.plataforma_grande),
            contentDescription = "Platform",
            modifier = Modifier
                .offset(
                    x = screenWidth * 0.45f,
                    y = screenHeight * 0.65f
                )
                .size(300.dp)
        )
        Image(
            painter = painterResource(id = R.drawable.plataforma_grande),
            contentDescription = "Platform",
            modifier = Modifier
                .offset(
                    x = screenWidth * 0.65f,
                    y = screenHeight * 0.45f
                )
                .size(175.dp)
        )
        Image(
            painter = painterResource(id = R.drawable.plataforma_grande),
            contentDescription = "Platform",
            modifier = Modifier
                .offset(
                    x = screenWidth * 0.30f,
                    y = screenHeight * 0.25f
                )
                .size(175.dp)
        )
    }
}

fun clouds(drawScope: DrawScope) {
    with(drawScope) {
        val width = size.width
        val height = size.height

        drawCloud(
            center = Offset(width * 0.05f, height * 0.30f),
            size = 200.dp.toPx()
        )

        drawCloud(
            center = Offset(width * 0.35f, height * 0.05f),
            size = 200.dp.toPx()
        )

        drawCloud(
            center = Offset(width * 0.6f, height * 0.4f),
            size = 200.dp.toPx()
        )

        drawCloud(
            center = Offset(width * 0.9f, height * 0.2f),
            size = 200.dp.toPx()
        )
    }
}

@Preview(
    showBackground = true,
    widthDp = 1200,
    heightDp = 540
)
@Composable
fun ExerciseGameScreenPreview() {
    //ExerciseView()
}
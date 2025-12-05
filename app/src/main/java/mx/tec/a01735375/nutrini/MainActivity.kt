package mx.tec.a01735375.nutrini

import android.app.Activity
import android.content.pm.ActivityInfo
import android.graphics.Point
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.LocalActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import mx.tec.a01735375.nutrini.ui.theme.NutriniTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val display = windowManager.defaultDisplay
        val size = Point()
        display.getSize(size)
        enableEdgeToEdge()
        setContent {
            NutriniTheme {
                MainScreen()
            }
        }
    }
}

val cherryFamily = FontFamily(
    Font(R.font.cherry_regular, FontWeight.Normal)
)

@Composable
fun MainScreen (){
    val navController = rememberNavController()

    NavHost(navController, startDestination = "MainView") {
        composable("MainView") { PetCareScreen(navController) }
        composable("WaterView") { WaterView(navController) }
        composable ("FoodView"){ FoodView(navController) }
        composable ("ExerciseView") {ExerciseView(navController)}
        composable ("StoreView") { StoreView(navController) }
    }
}

@Composable
fun PetCareScreen(navController: NavController, viewModel: ScoresViewModel = viewModel()) {
    LockScreenOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)
    val configuration = LocalConfiguration.current
    configuration.screenHeightDp.dp
    configuration.screenWidthDp.dp
    val scoreData = viewModel.state.collectAsState().value

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF2D72DA))
    ) {
        Column(
            modifier = Modifier.fillMaxSize()
        ) {
            // Health Bar
            //HealthBar(modifier = Modifier.padding(horizontal = 16.dp))

            Spacer(modifier = Modifier.height(24.dp))

            // Pet Image Area
            PetImageArea(
                modifier = Modifier
                    .weight(1f),
                scoreData
            )

            // Bottom Navigation
            BottomNavigation(
                modifier = Modifier.padding(16.dp),
                navController,
                scoreData
            )
        }
    }
}

@Composable
fun HealthBar(modifier: Modifier = Modifier, percentage: Float) {
    val green = 100 * percentage
    var colorBars: Long
    if (percentage == 1f) {
        colorBars = 0xFF4CAF50
    } else if (percentage == 0.75f) {
        colorBars = 0xFFFFC107
    } else if (percentage == 0.5f) {
        colorBars = 0xFFFF9800
    } else {
        colorBars = 0xFFE74C3C
    }
    Row(
        modifier = modifier
            .width(100.dp)
            .height(20.dp)
            .border(width = 2.dp, color = Color.Black),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Green health bar
        Box(
            modifier = Modifier
                .width(green.dp)
        ){
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(20.dp)
                    .background(
                        Color(colorBars),
                    )
            )
        }
    }
}

@Composable
fun PetImageArea(modifier: Modifier = Modifier, scoreData: ScoresState) {
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
    Box(
        modifier = modifier
            .aspectRatio(1f)
            .background(Color(0xFF2D72DA))
            .padding(4.dp),
        contentAlignment = Alignment.Center
    ) {
        Image(
            painter = petImageVal,
            contentDescription = "Pet Image",
            modifier = Modifier.fillMaxSize(),
            contentScale = ContentScale.Fit
        )
    }
}

@Composable
fun BottomNavigation(modifier: Modifier = Modifier, navController: NavController, scoreData: ScoresState) {
    Row(
        modifier = modifier.fillMaxWidth()
            .padding(bottom = 12.dp),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        NavigationButton(
            iconResource = R.drawable.plato,
            label = "Comida",
            onClick = { navController.navigate("FoodView") },
            percentagef = scoreData.score1
        )
        NavigationButton(
            iconResource = R.drawable.botella_agua,
            label = "Agua",
            onClick = { navController.navigate("WaterView") },
            percentagef = scoreData.score2
        )
        NavigationButton(
            iconResource = R.drawable.ejercicio,
            label = "Ejercicio",
            onClick = { navController.navigate("ExerciseView") },
            percentagef = scoreData.score3
        )
    }
}

@Composable
fun NavigationButton(
    iconResource: Int,
    label: String,
    backgroundColor: Color = Color(0xFF2D72DA),
    onClick: () -> Unit,
    percentagef: Float
) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Button(
            onClick = onClick,
            modifier = Modifier.size(80.dp),
            colors = ButtonDefaults.buttonColors(containerColor = backgroundColor),
            shape = RoundedCornerShape(16.dp),
            contentPadding = PaddingValues(4.dp)
        ) {
            Image(
                painter = painterResource(id = iconResource),
                contentDescription = label,
                modifier = Modifier.fillMaxSize(),
                contentScale = ContentScale.Fit
            )
        }

        Spacer(modifier = Modifier.height(4.dp))

        Text(
            text = label,
            color = Color.White,
            fontSize = 26.sp,
            fontWeight = FontWeight.Normal,
            fontFamily = cherryFamily
        )

        Spacer(modifier = Modifier.height(8.dp))

        HealthBar(percentage = percentagef)
    }
}

@Preview(showBackground = true)
@Composable
fun PetCareScreenPreview() {
    MainScreen()
}

@Composable
fun LockScreenOrientation(orientation: Int) {
    val activity = LocalActivity.current as? Activity
    DisposableEffect(orientation) {
        val previous = activity?.requestedOrientation
        activity?.requestedOrientation = orientation
        onDispose { activity?.requestedOrientation = previous ?: ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED }
    }
}
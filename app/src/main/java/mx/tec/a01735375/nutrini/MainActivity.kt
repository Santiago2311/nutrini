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
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.Typography
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import mx.tec.a01735375.nutrini.ui.theme.NutriniTheme
import mx.tec.a01735375.nutrini.ui.theme.Typography

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
fun PetCareScreen(navController: NavController) {
    LockScreenOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)
    val configuration = LocalConfiguration.current
    configuration.screenHeightDp.dp
    configuration.screenWidthDp.dp

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF2D72DA))
    ) {
        Column(
            modifier = Modifier.fillMaxSize()
        ) {
            // Health Bar
            HealthBar(modifier = Modifier.padding(horizontal = 16.dp))

            Spacer(modifier = Modifier.height(24.dp))

            // Pet Image Area
            PetImageArea(
                modifier = Modifier
                    .weight(1f)
            )

            // Bottom Navigation
            BottomNavigation(
                modifier = Modifier.padding(16.dp),
                navController
            )
        }
    }
}

@Composable
fun HealthBar(modifier: Modifier = Modifier) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .padding(top = 50.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Green health bar
        Box(
            modifier = Modifier
                .weight(1.0f)
                .height(30.dp)
                .background(
                    Color(0xFF4CAF50),
                    RoundedCornerShape(6.dp)
                )
        )

        // Gray/empty part
        Box(
            modifier = Modifier
                .weight(0.3f)
                .height(30.dp)
                .background(
                    Color(0xFFE0E0E0),
                    RoundedCornerShape(6.dp)
                )
        )
    }
}

@Composable
fun PetImageArea(modifier: Modifier = Modifier) {
    Box(
        modifier = modifier
            .aspectRatio(1f)
            .background(Color(0xFF2D72DA))
            .padding(4.dp),
        contentAlignment = Alignment.Center
    ) {
        Image(
            painter = painterResource(id = R.drawable.mascota),
            contentDescription = "Pet Image",
            modifier = Modifier.fillMaxSize(),
            contentScale = ContentScale.Fit
        )
    }
}

@Composable
fun BottomNavigation(modifier: Modifier = Modifier, navController: NavController) {
    Row(
        modifier = modifier.fillMaxWidth()
            .padding(bottom = 12.dp),
        horizontalArrangement = Arrangement.SpaceEvenly
    ) {
        NavigationButton(
            iconResource = R.drawable.plato,
            label = "Comida",
            onClick = { navController.navigate("FoodView") }
        )
        NavigationButton(
            iconResource = R.drawable.botella_agua,
            label = "Agua",
            onClick = { navController.navigate("WaterView") }
        )
        NavigationButton(
            iconResource = R.drawable.ejercicio,
            label = "Ejercicio",
            onClick = { navController.navigate("ExerciseView") }
        )
        NavigationButton(
            iconResource = R.drawable.tienda,
            label = "Tienda",
            onClick = { navController.navigate("StoreView") }
        )
    }
}

@Composable
fun NavigationButton(
    iconResource: Int,
    label: String,
    backgroundColor: Color = Color(0xFF2D72DA),
    onClick: () -> Unit
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
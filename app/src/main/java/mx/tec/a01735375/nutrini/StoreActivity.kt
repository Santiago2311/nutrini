package mx.tec.a01735375.nutrini

import android.content.pm.ActivityInfo
import android.graphics.Paint
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.systemBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import mx.tec.a01735375.nutrini.ui.theme.NutriniTheme

class StoreActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            NutriniTheme {
                //StoreView()
            }
        }
    }
}

@Composable
fun StoreView(navController: NavController) {
    LockScreenOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT)

    val items = listOf(
        ShopItem("Sillon", 1000, "comprar", Color(0xFF55AA2A), R.drawable.sillon),
        ShopItem("Poster", 900, "usar", Color(0xFF7B68EE), R.drawable.poster),
        ShopItem("Ventana", 2000, "comprar", Color(0xFF55AA2A), R.drawable.ventana),
        ShopItem("Planta", 3000, "comprar", Color(0xFF55AA2A), R.drawable.planta),
        ShopItem("Libros", 1500, "quitar", Color(0xFFE74C3C), R.drawable.estante_de_libros),
        ShopItem("Mesa", 2000, "comprar", Color(0xFF55AA2A), R.drawable.mesa_redonda),
        ShopItem("Lampara", 1000, "comprar", Color(0xFF55AA2A), R.drawable.lampara),
        ShopItem("Comedor", 1500, "comprar", Color(0xFF55AA2A), R.drawable.comedor)
    )

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF2D72DA))
            .systemBarsPadding()
    ) {
        // Top Bar
        TopBar(navController)

        // Items List
        LazyColumn(
            modifier = Modifier.fillMaxSize(),
            contentPadding = PaddingValues(horizontal = 20.dp, vertical = 16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            items(items) { item ->
                ShopItemRow(item = item)
            }
        }
    }
}

@Composable
fun TopBar(navController: NavController) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 10.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        IconButton(
            onClick = { navController.navigate("MainView") },
            //modifier = Modifier
                //.align(Alignment.TopStart)
                //.padding(top = 32.dp, start = 16.dp)
        ) {
            Icon(
            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
            contentDescription = "Back",
            tint = Color.White,
            modifier = Modifier.size(40.dp)
            )
        }

        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                text = "200",
                color = Color.White,
                fontSize = 24.sp,
                fontWeight = FontWeight.Normal,
                fontFamily = cherryFamily
            )
            // Add your coin icon here
            Box(
                modifier = Modifier.size(24.dp),
                contentAlignment = Alignment.Center
            ) {
                Image(
                    painterResource(id = R.drawable.dinero),
                    contentDescription = "Dinero",
                    modifier = Modifier.size(60.dp),
                    contentScale = ContentScale.Fit
                )
            }
        }
    }
}

@Composable
fun ShopItemRow(item: ShopItem) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp)
    ) {
        // Item Icon - positioned on the left
        Box(
            modifier = Modifier
                .size(80.dp)
                .align(Alignment.CenterStart),
            contentAlignment = Alignment.Center
        ) {
            Image(
                painterResource(id = item.image),
                contentDescription = item.name,
                modifier = Modifier.size(80.dp),
                contentScale = ContentScale.Fit
            )
        }

        // Item Name - centered in the screen
        Text(
            text = item.name,
            color = Color.White,
            fontSize = 26.sp,
            fontWeight = FontWeight.Normal,
            fontFamily = cherryFamily,
            modifier = Modifier.align(Alignment.Center)
        )

        // Price and Button - positioned on the right
        Column(
            modifier = Modifier.align(Alignment.CenterEnd),
            horizontalAlignment = Alignment.End
        ) {
            Row(
                //modifier = ,
                verticalAlignment = Alignment.CenterVertically
            ){
                Text(
                    text = "${item.price} ",
                    color = Color.White,
                    fontSize = 22.sp,
                    fontWeight = FontWeight.Normal,
                    fontFamily = cherryFamily
                )
                Image(
                    painterResource(id = R.drawable.dinero),
                    contentDescription = "Dinero",
                    modifier = Modifier.size(20.dp),
                    contentScale = ContentScale.Fit
                )
            }
            Button(
                onClick = { },
                colors = ButtonDefaults.buttonColors(
                    containerColor = item.buttonColor
                ),
                shape = RoundedCornerShape(8.dp),
                modifier = Modifier
                    .height(44.dp)
                    .width(100.dp),
                contentPadding = PaddingValues(horizontal = 16.dp)
            ) {
                Text(
                    text = item.actionText,
                    color = Color.White,
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Normal,
                    fontFamily = cherryFamily
                )
            }
        }
    }
}

data class ShopItem(
    val name: String,
    val price: Int,
    val actionText: String,
    val buttonColor: Color,
    val image: Int
)

@Preview
@Composable
fun PetShopScreenPreview(){
    //StoreView()
}
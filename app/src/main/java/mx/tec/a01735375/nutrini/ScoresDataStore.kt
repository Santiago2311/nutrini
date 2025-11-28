package mx.tec.a01735375.nutrini

import android.app.Application
import android.content.Context
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.floatPreferencesKey
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.longPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

val Context.dataStore by preferencesDataStore("scores_prefs")

object ScoreKeys {
    val SCORE1 = floatPreferencesKey("score1")
    val SCORE1_TS = longPreferencesKey("score1_ts")

    val SCORE2 = floatPreferencesKey("score2")
    val SCORE2_TS = longPreferencesKey("score2_ts")

    val SCORE3 = floatPreferencesKey("score3")
    val SCORE3_TS = longPreferencesKey("score3_ts")
}

class ScoreRepository(private val context: Context) {

    val scoresFlow = context.dataStore.data.map { prefs ->
        ScoresState(
            score1 = prefs[ScoreKeys.SCORE1] ?: 0.25f,
            score1Ts = prefs[ScoreKeys.SCORE1_TS] ?: 0L,

            score2 = prefs[ScoreKeys.SCORE2] ?: 0.25f,
            score2Ts = prefs[ScoreKeys.SCORE2_TS] ?: 0L,

            score3 = prefs[ScoreKeys.SCORE3] ?: 0.25f,
            score3Ts = prefs[ScoreKeys.SCORE3_TS] ?: 0L
        )
    }

    suspend fun updateScore(slot: Int, value: Float, timestamp: Long) {
        context.dataStore.edit { prefs ->
            when (slot) {
                1 -> {
                    prefs[ScoreKeys.SCORE1] = value
                    prefs[ScoreKeys.SCORE1_TS] = timestamp
                }
                2 -> {
                    prefs[ScoreKeys.SCORE2] = value
                    prefs[ScoreKeys.SCORE2_TS] = timestamp
                }
                3 -> {
                    prefs[ScoreKeys.SCORE3] = value
                    prefs[ScoreKeys.SCORE3_TS] = timestamp
                }
            }
        }
    }
}

data class ScoresState(
    val score1: Float,
    val score1Ts: Long,
    val score2: Float,
    val score2Ts: Long,
    val score3: Float,
    val score3Ts: Long
)

class ScoresViewModel(app: Application) : AndroidViewModel(app) {

    private val repo = ScoreRepository(app)

    val state = repo.scoresFlow.stateIn(
        viewModelScope,
        SharingStarted.WhileSubscribed(5000),
        ScoresState(0f,0,0f,0,0f,0)
    )

    fun saveScore(slot: Int, score: Float) {
        viewModelScope.launch {
            repo.updateScore(slot, score, System.currentTimeMillis())
        }
    }
}

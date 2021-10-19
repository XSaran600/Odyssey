using UnityEngine;
using System.IO;

public class SaveLoad : MonoBehaviour {

    [Header("Audio")]
    [SerializeField] private AudioSource saveLoadSound;

    // Save player HP, MP, EXP, Level
    [Header("Save Load")]
    //[SerializeField] public PlayerStats playerStats;

    public Player player;

    // Close UI bar after save/load complete
    // [SerializeField] private GameMenu UIBar;

    public string   playerName;
    public float    hp;
    public float    mp;
    public float    maxHP;
    public float    maxMP;
    public int      power;
    public int      level;
    public float    exp;
    public Vector3  position;
    public int      hpPotCount;
    public int      mpPotCount;
    
    private string  savePath;

    private void Start() {
        savePath = Application.persistentDataPath + "/player.json";
        Debug.Log("Game data will be saved to: " + savePath);
    }

    [ContextMenu("Save")]
    public void Save() {
        playerName  = player.stats.playerName;
        hp          = player.stats.hp;
        mp          = player.stats.mp;
        maxHP       = player.stats.maxHP;
        maxMP       = player.stats.maxMP;
        exp         = player.stats.exp;
        level       = player.stats.level;
        position    = player.stats.position;
        hpPotCount  = player.stats.hpPotCount;
        mpPotCount  = player.stats.mpPotCount;

        PlayerStats stats = new PlayerStats(this);
        string json = JsonUtility.ToJson(stats);
        File.WriteAllText(savePath, json);

        //UIBar.ToggleSaveLoadQuit(); // Close Menu

        // saveLoadSound.Play(); // Play Audio
    }

    [ContextMenu("Load")]
    public void Load() {
        if (File.Exists(savePath)) {
            string json = File.ReadAllText(savePath);
            PlayerStats stats = JsonUtility.FromJson<PlayerStats>(json);

            playerName  = stats.playerName;
            hp          = stats.hp;
            mp          = stats.mp;
            maxHP       = stats.maxHP;
            maxMP       = stats.maxMP;
            exp         = stats.exp;
            level       = stats.level;
            position    = stats.position;
            hpPotCount  = stats.hpPotCount;
            mpPotCount  = stats.mpPotCount;

            // Load and set HP, MP, MaxHP, MaxMP, EXP, Level, Name, Potion Count, and Position
            //player.healthBar.SetMaxHP(maxHP);
            //player.manaBar.SetMaxMP(maxMP);
            //player.healthBar.SetHP(hp);
            //player.manaBar.SetMP(mp);
            //player.experienceBar.SetEXP(exp);
            //player.SetLevel(level);
            //player.SetName(playerName);
            //player.SetPotionCount(potionCount);
            //player.SetPosition(position);

            //player.experienceBar.UpdateLevel(); // Update player Level
            //player.UpdatePotionCount(); // Update potion count

            //if (toggle)
            //    UIBar.ToggleSaveLoadQuit(); // Close menu if toggle on

            // saveLoadSound.Play(); // Play Audio         

        } else {
            Debug.Log("Unable to load file: " + savePath);
        }
    }

    public void Quit() {
        Application.Quit();
    }
}
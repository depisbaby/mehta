using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class LootManager : MonoBehaviour
{
    public static LootManager Instance;
    private void Awake()
    {
        Instance = this;
    }

    [Serializable]
    public class LootTable
    {
        public string lootTableName;
        public List<PossibleLoot> commonLoot;
        public List<PossibleLoot> uncommonLoot;
        public List<PossibleLoot> rareLoot;
        public List<PossibleLoot> mythicalRareLoot;
    }

    [Serializable]
    public class PossibleLoot
    {
        public string itemName;
        public int minAmount;
        public int maxAmount;

    }

    [SerializeField] List<LootTable> lootTables;

    public void SpawnLoot(string lootTableName, Vector2 position)
    {
        LootTable table = null;
        foreach (var item in lootTables)
        {
            if(lootTableName == item.lootTableName)
            {
                table = item;
            }
        }
        if (table == null) return;

        int rng = UnityEngine.Random.Range(0, 100);
        string itemName;
        int amount;

        if(rng < 66)//Common
        {
            PossibleLoot loot = table.commonLoot[UnityEngine.Random.Range(0, table.commonLoot.Count)];
            itemName = loot.itemName;
            amount = UnityEngine.Random.Range(loot.maxAmount, loot.maxAmount +1);
        }
        else if(rng < 88)//Uncommon
        {
            PossibleLoot loot = table.uncommonLoot[UnityEngine.Random.Range(0, table.commonLoot.Count)];
            itemName = loot.itemName;
            amount = UnityEngine.Random.Range(loot.maxAmount, loot.maxAmount + 1);
        }
        else if(rng < 99)//Rare
        {
            PossibleLoot loot = table.rareLoot[UnityEngine.Random.Range(0, table.commonLoot.Count)];
            itemName = loot.itemName;
            amount = UnityEngine.Random.Range(loot.maxAmount, loot.maxAmount + 1);
        }
        else//Mythical rare
        {
            PossibleLoot loot = table.mythicalRareLoot[UnityEngine.Random.Range(0, table.commonLoot.Count)];
            itemName = loot.itemName;
            amount = UnityEngine.Random.Range(loot.maxAmount, loot.maxAmount + 1);
        }

        ItemManager.Instance.SpawnNetworkItem(ItemManager.Instance.NameToItemId(itemName), (ushort)amount, "", position);

    }


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

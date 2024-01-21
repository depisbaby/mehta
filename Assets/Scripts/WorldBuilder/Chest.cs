using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chest : Block
{
    [Header("Chest")]
    [SerializeField]string lootTableName;
    public override void OnPlayerDestroy()
    {
        LootManager.Instance.SpawnLoot(lootTableName, gameObject.transform.position);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Collections;

public class Item : MonoBehaviour
{
    [Header("Item")]
    //Network
    [HideInInspector]public int itemId;
    public ushort amount;
    public FixedString128Bytes data;

    //Local
    public string itemName;
    public ItemType itemType;
    public Sprite itemSprite;
    public bool stackable;


    public enum ItemType
    {
        Generic = 0,
        Placeable = 1,
        Hatchet = 2,
        SpellCaster = 3,
        Weapon = 4,

    }

    public virtual void UseLeftClick()
    {

    }

    public virtual void UseRightClick()
    {

    }

    public virtual void CustomMessage(string message)
    {

    }
}

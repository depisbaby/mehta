using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ItemSlot : MonoBehaviour
{
    public IItemSlot _interface;

    public Item placedItem;
    public Image icon;
    public TMPro.TMP_Text amountTmp;

    public void OnHover()
    {
        _interface.OnHover(this);
    }
}

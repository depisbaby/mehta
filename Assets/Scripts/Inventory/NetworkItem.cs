using System.Collections;
using System.Collections.Generic;
using Unity.Collections;
using UnityEngine;
using Unity.Netcode;

public class NetworkItem : NetworkBehaviour
{
    public NetworkVariable<int> itemId = new NetworkVariable<int>();
    public NetworkVariable<ushort> amount = new NetworkVariable<ushort>();
    public NetworkVariable<FixedString128Bytes> data = new NetworkVariable<FixedString128Bytes>();

    [Header("PII")]
    public SpriteRenderer sr;
    public NetworkObject no;

    [ClientRpc]public void UpdateItemClientRpc(int itemId)
    {
        sr.sprite = ItemManager.Instance.items[itemId].itemSprite;
    }

    
    
}

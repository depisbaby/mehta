using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Netcode;
using Unity.Collections;

public class ItemManager : NetworkBehaviour
{
    public static ItemManager Instance;
    private void Awake()
    {
        Instance = this;
    }

    public List<Item> items;

    [Header("NetworkItems")]
    public GameObject networkItemPrefab;

    private void Start()
    {
        //Set item ids
        for (int i = 1; i < items.Count; i++)
        {
            items[i].itemId = i;
            MiscLibrary.Instance.AddToSpriteLibrary(items[i].itemSprite);
        }
    }

    public void SpawnNetworkItem(int itemId, ushort amount, FixedString128Bytes data, Vector2 position)
    {
        //if (!IsServer) return;

        if (itemId == 0) return;
        if (amount == 0) return;

        GameObject go = Instantiate(networkItemPrefab);
        go.transform.position = position;
        NetworkItem networkItem = go.GetComponent<NetworkItem>();
        networkItem.no.Spawn();

        networkItem.itemId.Value = itemId;
        networkItem.amount.Value = amount;
        networkItem.data.Value = data;

        networkItem.UpdateItemClientRpc(itemId);

    }

    [ServerRpc(RequireOwnership = false)]public void AttemptPickingUpServerRpc(ulong _networkId, ulong clientId, ushort wantedAmount)
    {
       
        NetworkObject no;
        if(!NetworkManager.Singleton.SpawnManager.SpawnedObjects.TryGetValue(_networkId, out no))
        {
            Console.Instance.ShowMessageInConsole(gameObject, "The item you tried to pick up no longer exists!");
            return;
        }

        NetworkItem networkItem = no.gameObject.GetComponent<NetworkItem>();

        int finalAmount = Mathf.Clamp(wantedAmount, 0, networkItem.amount.Value);
        networkItem.amount.Value -= (ushort)finalAmount;

        ClientRpcParams clientRpcParams = new ClientRpcParams
        {
            Send = new ClientRpcSendParams
            {
                TargetClientIds = new ulong[] { clientId }
            }
        };

        GiveItemToClientClientRpc(networkItem.itemId.Value, (ushort)finalAmount, networkItem.data.Value, clientRpcParams);

        if(networkItem.amount.Value <= 0)
        {
            no.Despawn();
            Destroy(no.gameObject);
        }

        
    }

    [ServerRpc(RequireOwnership = false)] public void DropItemServerRpc(int itemId, ushort amount, FixedString128Bytes data, Vector2 position)
    {
        SpawnNetworkItem(itemId, amount, data, position);
        
    }

    [ClientRpc]public void GiveItemToClientClientRpc(int itemId, ushort amount, FixedString128Bytes data, ClientRpcParams clientRpcParams = default)
    {
        Console.Instance.ShowMessageInConsole(gameObject, "Received "+amount + " items");
        Item item = CreateLocalItem(itemId, amount, data);
        InventoryMenu.Instance.PutItemToPlayerInventory(item);
        
    }

    public Item CreateLocalItem(int itemId, ushort amount, FixedString128Bytes data)
    {
        GameObject go = Instantiate(items[itemId].gameObject);
        Item item = go.GetComponent<Item>();
        //item.transform.parent = transform;
        item.amount = amount;

        item.data = data;

        return item;
    }

    public void CreateAndGiveLocalItem(int itemId, ushort amount, FixedString128Bytes data)
    {
        Item item = CreateLocalItem(itemId, amount, data);
        InventoryMenu.Instance.PutItemToPlayerInventory(item);
    }

    #region Utility
    
    public FixedString128Bytes SpellCasterDefaultData()
    {
        FixedString128Bytes fstring = new FixedString128Bytes();

        for (int i = 0; i <18; i++)
        {
            fstring = fstring + "-----";
        }


        return fstring;
    }

    public int NameToItemId(string name)
    {
        foreach (var item in items)
        {
            if (item == null) continue;

            if (item.itemName == name) return item.itemId;
        }

        Console.Instance.ShowMessageInConsole(gameObject, "Invalid item name given!");
        return 0;
    } 

    #endregion
}

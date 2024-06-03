using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Netcode;

public class PlayerCollider : NetworkBehaviour, IHittable
{
    public Player player;


    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (!IsOwner) return;

        if (collision.gameObject.tag == "NetworkItem")
        {
            NetworkItem networkItem = collision.gameObject.GetComponent<NetworkItem>();
            ulong networkId = networkItem.no.NetworkObjectId;
            
            ItemManager.Instance.AttemptPickingUpServerRpc(networkId, OwnerClientId, InventoryMenu.Instance.CheckSpaceFor(networkItem.itemId.Value));
        }
    }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hatchet : Item
{
    [Header("Hatchet")]
    [SerializeField] int efficiency;
    public override void UseLeftClick()
    {
        RaycastHit2D hit = Physics2D.Raycast(LocalPlayerManager.Instance.player.transform.position, LocalPlayerManager.Instance.lookingAtDirection, LocalPlayerManager.Instance.chopRange, LocalPlayerManager.Instance.chopLayerMask);
        if (hit)
        {
            Block block = hit.collider.gameObject.GetComponent<Block>();
            if (block == null || block.chopsLeft <= 0) return;

            block.chopsLeft -= efficiency;

            if (block.chopsLeft <= 0)
            {
                WorldBuilder.Instance.RemoveBlockServerRpc(block.parentWorld.worldName, (int)block.transform.position.x, (int)block.transform.position.y);
            }
        }
    }
}

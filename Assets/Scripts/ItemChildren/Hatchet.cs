using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Hatchet : Item
{
    [Header("Hatchet")]
    [SerializeField] int efficiency;
    public override void UseLeftClick()
    {
        if (LocalPlayerManager.Instance.player.characterGestures.gestureActive) return;

        float speed = 2;
        int direction = 1;
        if(LocalPlayerManager.Instance.lookingAtDirection.x > 0)
        {
            direction = -1;
        }
        LocalPlayerManager.Instance.player.characterGestures.Swing(direction, speed);

        RaycastHit2D hit = Physics2D.Raycast(LocalPlayerManager.Instance.player.transform.position, LocalPlayerManager.Instance.lookingAtDirection, LocalPlayerManager.Instance.chopRange, LocalPlayerManager.Instance.chopLayerMask);
        if (hit)
        {
            Block block = hit.collider.gameObject.GetComponent<Block>();
            if (block == null || block.chopsLeft <= 0) return;

            block.chopsLeft -= efficiency;

            if (block.chopsLeft <= 0)
            {
                WorldBuilder.Instance.RemoveBlockServerRpc(block.parentWorld.worldName, (int)block.transform.position.x, (int)block.transform.position.y);
                return;
            }

            WorldBuilder.Instance.PokeBlockServerRPC(block.parentWorld.worldName, (int)block.transform.position.x, (int)block.transform.position.y, LocalPlayerManager.Instance.lookingAtDirection);
        }
    }

    public override void CustomMessage(string message)
    {
        switch (message)
        {
            case "equip":
                LocalPlayerManager.Instance.player.characterGestures.ChangeSpriteOwner(itemSprite, 0.8f, new Vector2(0f, 0.5f), 0f);
                break;

            default:
                break;
        }
    }
}

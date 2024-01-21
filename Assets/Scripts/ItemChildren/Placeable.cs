using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Placeable : Item
{
    public ushort blockId;
    public override void UseRightClick()
    {
        PlaceBlock();
    }

    void PlaceBlock()
    {
        if (LocalPlayerManager.Instance.blockBeingPlaced != null) return;

        Vector2 position = (Vector2)LocalPlayerManager.Instance.player.transform.position + LocalPlayerManager.Instance.lookingAtDirection;
        int[] gridPosition = WorldBuilder.Instance.WorldPositionToWorldGrid(LocalPlayerManager.Instance.currentWorld, position);

        if (LocalPlayerManager.Instance.currentWorld.blockGrid[gridPosition[0], gridPosition[1]] != null) return;

        LocalPlayerManager.Instance.blockBeingPlaced = this;
        WorldBuilder.Instance.PlaceBlockServerRpc(LocalPlayerManager.Instance.currentWorld.worldName, gridPosition[0], gridPosition[1], blockId, LocalPlayerManager.Instance.player.OwnerClientId);
        
    }
}

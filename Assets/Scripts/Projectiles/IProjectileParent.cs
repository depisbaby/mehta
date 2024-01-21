using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IProjectileParent 
{

    public void EndProjectile();
    public void HitBlock(Block block);
    public Vector2 GetMoveDirection(Vector2 forward);
    public Projectile.ProjectileMods GetProjectileMods();
    
}

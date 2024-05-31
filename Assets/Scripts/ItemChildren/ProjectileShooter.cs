using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UIElements;

public class ProjectileShooter : Item , IProjectileParent
{
    [Header("ProjectileShooter")]
    public int projectileId;
    public Projectile.ProjectileMods projectileMod = new Projectile.ProjectileMods();

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }


    public override void UseLeftClick()
    {
        Vector2 casterPosition = LocalPlayerManager.Instance.player.transform.position;
        Vector2 casterDirection = LocalPlayerManager.Instance.lookingAtDirection;
        Projectile projectile = ProjectileManager.Instance.ShootClientProjectile(projectileId, this, casterPosition, casterDirection);
    }

    public override void UseRightClick()
    {

    }

    public override void CustomMessage(string message)
    {

    }

    public void EndProjectile()
    {
        //throw new System.NotImplementedException();
    }

    public void HitBlock(Block block)
    {
        //throw new System.NotImplementedException();
    }

    public Vector2 GetMoveDirection(Vector2 forward)
    {
        return forward;
    }

    public Projectile.ProjectileMods GetProjectileMods()
    {
        return projectileMod;
        //throw new System.NotImplementedException();
    }
}

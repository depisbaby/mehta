using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static Projectile;

public class ProjectileCopyData : MonoBehaviour 
{
    [HideInInspector] public int projectileId; 

    //Network synced
    public Sprite sprite;
    public string animName;

    //Behaviour
    public float speed;
    public float lifeTime;

    public void CopyValues(ProjectileCopyData original)
    {
        projectileId = original.projectileId;

        sprite = original.sprite;
        animName = original.animName;

        speed = original.speed;
        lifeTime = original.lifeTime;
    }
}

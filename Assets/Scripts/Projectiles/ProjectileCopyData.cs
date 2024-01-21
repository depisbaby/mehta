using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static Projectile;

public class ProjectileCopyData : MonoBehaviour 
{
    //Network synced
    public Sprite sprite;

    //Behaviour
    public float speed;
    public float lifeTime;

    public void CopyValues(ProjectileCopyData original)
    {
        sprite = original.sprite;
        speed = original.speed;
        lifeTime = original.lifeTime;
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Netcode;
using Unity.Multiplayer.Samples.Utilities.ClientAuthority;
using Unity.Netcode.Components;
using UnityEngine.Rendering.Universal;

public class Projectile : NetworkBehaviour
{

    //CopiedData
    [HideInInspector] public ProjectileCopyData copiedData;

    //Projectile parent
    public IProjectileParent projectileParent;

    //Is client projectile
    [HideInInspector] public bool isClientProjectile;

    //State
    bool active;
    Vector2 lastPosition;

    [Header("PII")]
    public LayerMask hittingLayers;
    public NetworkObject networkObject;
    public SpriteRenderer spriteRenderer;
    public Animator animator;

    private void Awake()
    {
        copiedData = new ProjectileCopyData();
    }

    public class ProjectileMods
    {
        public float speedMod;
        public float lifeTimeMod;
    }

    /// <summary>
    /// Before calling this: Set projectileParent, set isClientProjectile, call copiedData.CopyValues(), call UpdateProjectile()
    /// </summary>
    /// <param name="position"></param>
    /// <param name="direction"></param>
    public void Shoot(Vector2 position, Vector2 direction)
    {
        if (projectileParent == null) return;

        transform.position = position;
        transform.rotation = Quaternion.LookRotation(direction);
        lastPosition = transform.position;

        gameObject.SetActive(true);
        NetworkAppearServerRpc(true, copiedData.projectileId);

        active = true;
    }

    public void UpdateProjectile()
    {
        ApplyProjectileMods();
        animator.Play(copiedData.animName);
        spriteRenderer.sprite = copiedData.sprite;
    }

    private void ApplyProjectileMods()
    {
        ProjectileMods mods = projectileParent.GetProjectileMods();

        copiedData.speed += mods.speedMod;
        copiedData.lifeTime += mods.lifeTimeMod;
    }

    void EndProjectile()
    {
        active = false;

        projectileParent.EndProjectile();
        

        if (isClientProjectile)
        {
            ProjectileManager.Instance.clientProjectiles.Enqueue(this);
        }

        gameObject.SetActive(false);
        NetworkAppearServerRpc(false, 0);
    }

    private void Update()
    {
        if (!active) return;

        if (!IsOwner) return;
        Move();
        RayCastHitDetect();

        if(copiedData.lifeTime > 0f)
        {
            copiedData.lifeTime -= Time.deltaTime;
        }
        else
        {
            EndProjectile();
        }
    }

    private void Move()
    {
        transform.position = (Vector2)transform.position + projectileParent.GetMoveDirection(transform.forward) * copiedData.speed * Time.deltaTime;
        
    }

    private void RayCastHitDetect()
    {
        RaycastHit2D hit = Physics2D.Linecast(lastPosition, transform.position, hittingLayers);
        if (hit == false) {
            lastPosition = transform.position;
            return;
        }

        if (hit.collider.gameObject.layer == 6) //Hitted block
        {
            Debug.Log(hit.collider.gameObject.name);
            //Todo bounce

            EndProjectile();
        }
        
        lastPosition = transform.position;
    }

    #region SetActive
    [ServerRpc] public void NetworkAppearServerRpc(bool appears, int projectilePrefabId)
    {
        NetworkAppearClientRpc(appears, projectilePrefabId);
    }

    [ClientRpc] public void NetworkAppearClientRpc(bool appears, int projectilePrefabId)
    {
        if (appears)
        {
            animator.Play(ProjectileManager.Instance.projectilePrefabs[projectilePrefabId].animName);
        }

        gameObject.SetActive(appears);
    }
    #endregion




}

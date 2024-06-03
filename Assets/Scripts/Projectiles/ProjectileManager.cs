using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Netcode;
using System.Threading.Tasks;

public class ProjectileManager : NetworkBehaviour
{
    public static ProjectileManager Instance;
    private void Awake()
    {
        Instance = this;
    }

    public List<ProjectileCopyData> projectilePrefabs;

    [SerializeField] Projectile clientProjectilePrefab;
    [SerializeField] GameObject clientProjectileBase;
    [SerializeField] int clientProjectilePoolSize;

    public Queue<Projectile> clientProjectiles = new Queue<Projectile>();

    public bool waitingForProjectiles;

    // Start is called before the first frame update
    void Start()
    {
        for (int j = 1; j < projectilePrefabs.Count; j++)
        {
            projectilePrefabs[j].projectileId = j;
            
        }
    
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void EnterInGame()
    {
        if (!IsClient) return;

        waitingForProjectiles = true;
        RequestClientProjectilesServerRpc(NetworkManager.Singleton.LocalClientId);

    }

    public Projectile ShootClientProjectile(int projectilePrefabId, IProjectileParent parent, Vector2 position, Vector2 direction)
    {
        if (!IsClient) return null;

        if (clientProjectiles.Count == 0)
        {
            Console.Instance.ShowMessageInConsole(gameObject, "Client projectile pool is empty. Increase the client projectile pool size or decrease projectile lifetimes");
            return null;
        }

        Projectile projectile = clientProjectiles.Dequeue();
        //Debug.Log(projectile);
        //Debug.Log(projectile.copiedData);
        //Debug.Log(projectilePrefabs[projectilePrefabId]);
        projectile.copiedData.CopyValues(projectilePrefabs[projectilePrefabId]);
        projectile.projectileParent = parent;
        projectile.isClientProjectile = true;
        projectile.UpdateProjectile();
        projectile.Shoot(position, direction);

        return projectile;
    } 

    #region 
    [ServerRpc(RequireOwnership = false)] public void RequestClientProjectilesServerRpc(ulong clientId)
    {
        GameObject go = Instantiate(clientProjectileBase);
        NetworkObject no = go.GetComponent<NetworkObject>();
        no.SpawnWithOwnership(clientId);

        for (int i = 0; i < clientProjectilePoolSize; i++)
        {
            Projectile projectile = Instantiate(clientProjectilePrefab);
            NetworkObject no1 = projectile.gameObject.GetComponent<NetworkObject>();
            no1.SpawnWithOwnership(clientId);
            projectile.gameObject.transform.parent = go.transform;
            projectile.NetworkAppearClientRpc(false, 0);
        }

        ClientRpcParams clientRpcParams = new ClientRpcParams
        {
            Send = new ClientRpcSendParams
            {
                TargetClientIds = new ulong[] { clientId}
            }
        };

        ResponseClientProjectilesClientRpc(no.NetworkObjectId, clientRpcParams);
    }

    [ClientRpc] void ResponseClientProjectilesClientRpc(ulong netobjectId, ClientRpcParams clientRpcParams = default)
    {
        GameObject go = NetworkManager.Singleton.SpawnManager.SpawnedObjects[netobjectId].gameObject;

        for (int i = 0; i < go.transform.childCount; i++)
        {
            clientProjectiles.Enqueue(go.transform.GetChild(i).gameObject.GetComponent<Projectile>());
        }

        Console.Instance.ShowMessageInConsole("ProjectileManager", "Client projectiles initialized!");

        waitingForProjectiles = false;
    }

    #endregion

}

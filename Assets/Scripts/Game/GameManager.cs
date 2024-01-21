using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Collections;
using Unity.Netcode;
using System.Threading.Tasks;

public class GameManager : NetworkBehaviour
{
    public static GameManager Instance;

    private void Awake()
    {
        Instance = this;
        
        if (IsServer)
        {
            seed.Value = "";
        }

    }

    public NetworkVariable<FixedString128Bytes> seed = new NetworkVariable<FixedString128Bytes>();

    [SerializeField] private List<GameObject> networkPrefabs;

    public List<Player> players;

    // Start is called before the first frame update
    void Start()
    {
        Physics.IgnoreLayerCollision(6, 6);
        //Physics.IgnoreLayerCollision(6, 8);
        //Physics.IgnoreLayerCollision(8, 8);

        SetNetworkPrefabs();

        if (IsServer)
        {
            ServerLoadGame();
        }
        else
        {
            ClientLoadGame();
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }


    /// <summary>
    /// Call this to start the game
    /// </summary>
    /// <param name="_seed"></param>
    public void StartGame(string _seed)
    {
        if(_seed == "")
        {
            return;
        }

        seed.Value = _seed;
    }

    async void ClientLoadGame()
    {
        //Wait for seed
        while (seed.Value == "")
        {
            await Task.Yield();
        }


    }

    async void ServerLoadGame()
    {
        //Wait for seed
        while (seed.Value == "")
        {
            await Task.Yield();
        }

        //Create world according to seed



        //Check that all things have been initialized


    }

    #region Players

    public void AddPlayer(Player player)
    {
        players.Add(player);
    }

    public void RemovePlayer(Player player)
    {
        players.Remove(player);
    }

    #endregion

    #region Prepare network manager

    void SetNetworkPrefabs()
    {
        foreach(var item in networkPrefabs)
        {
            if(item != null) NetworkManager.Singleton.AddNetworkPrefab(item);
        }
    }

    #endregion
}

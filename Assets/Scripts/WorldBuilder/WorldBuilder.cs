using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Threading.Tasks;
using Unity.Netcode;
using Unity.Collections;
using System.Text;
using System;

public class WorldBuilder : NetworkBehaviour
{
    public static WorldBuilder Instance;
    private void Awake()
    {
        Instance = this;
    }

    [HideInInspector] public NetworkVariable<FixedString128Bytes> seed = new NetworkVariable<FixedString128Bytes>();
    [HideInInspector] public List<World> worlds = new List<World>();
    [HideInInspector] public List<WorldChange> worldChanges = new List<WorldChange>();

    public List<Block> blocks; 

    [Header("Tile collections")]
    public List<TileCollection> tileCollections;

    [Serializable]
    public class TileCollection
    {
        public string tileCollectionName;

        //Alpha
        public GameObject alphaGroundTile;

        public Block[] treeBlocks;
        public Block[] rockBlocks;
    }

    public class WorldChange
    {
        public WorldChange(string _worldName, ushort _xPosition, ushort _yPosition, ushort _changeId)
        {
            worldName = _worldName;
            xPosition = _xPosition;
            yPosition = _yPosition;
            changeId = _changeId;
        }

        public string worldName;
        public ushort xPosition;
        public ushort yPosition;
        public ushort changeId; // 0 = block removed, 1> = block of that id placed
    }


    // Start is called before the first frame update
    void Start()
    {
        int i = 0;
        foreach (var item in blocks)
        {
            if (i == 0)
            {
                i++;
                continue;
            }

            item.blockId = (ushort)i;
            i++;
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public async void EnterInGame()
    {
        while (!NetworkManager.Singleton.IsListening)
        {
            await Task.Yield();
        }

        if (IsServer)
        {
            seed.Value = GenerateRandomString(10);
        }
        else
        {
            while(seed.Value == "")
            {
                await Task.Yield();
            }
        }

        World world = await GenerateHomeWorld(seed.Value.ToString(), 100, "home");

        LocalPlayerManager.Instance.currentWorld = world;

        if(IsClient)RequestWorldChangesServerRpc(NetworkManager.Singleton.LocalClientId);

    }


    #region World Generators
    async Task<World> GenerateHomeWorld(string seed, int size, string name)
    {
        System.Random random = new System.Random(seed.GetHashCode());
        //Debug.Log("seed: " + seed.GetHashCode());

        foreach (var item in worlds)
        {
            if (item.worldName == name)
            {
                Console.Instance.ShowMessageInConsole(gameObject, name + " is already taken world name.");
                return null;
            }
        }

        GameObject go = Instantiate(new GameObject());
        go.name = "WorldGameObject_"+name;
        World world = go.AddComponent<World>();
        world.Initialize(name, size);
        worlds.Add(world);

        //Get tile collection
        TileCollection tileCollection = null;
        foreach (var item in tileCollections)
        {
            if (item.tileCollectionName == name)
            {
                tileCollection = item;
            }
        }

        if(tileCollection == null)
        {
            tileCollection = tileCollections[0];
        }

        float noiseSize = 0.1f;

        //ALPHA generate ground
        for (int y = 0; y < size; y++)
        {
            for (int x = 0; x < size; x++)
            {
                GameObject go1 = Instantiate(tileCollection.alphaGroundTile);
                go1.transform.parent = world.transform;
                go1.transform.position = new Vector3(x, y, 0); //ADD WORLD OFFSET!!!!

            }
        }

        //ALPHA generate chests
        for (int y = 0; y < size; y++)
        {
            for (int x = 0; x < size; x++)
            {
                if (UnityEngine.Random.Range(0, 300) != 0) continue;

                PlaceBlock(world, blocks[2], x, y);
                

            }
        }


        float noiseX = random.Next(0, 1000) * 0.01f;
        float noiseY = random.Next(0, 1000) * 0.01f;
//        Debug.Log(noiseX + " " + noiseY);

        //ALPHA generate rocks
        for (int y = 0; y < size; y++)
        {
            for (int x = 0; x < size; x++)
            {
                if (((Vector2)world.gameObject.transform.position + new Vector2(x, y) - world.worldCenterWorldSpace).magnitude < 6) continue;

                float afterNoise = Mathf.PerlinNoise(noiseX + x * noiseSize, noiseY + y * noiseSize);

                if (afterNoise > 0.62f)
                {
                    PlaceBlock(world, tileCollection.rockBlocks[UnityEngine.Random.Range(0,tileCollection.rockBlocks.Length)], x,y);
                }
                else if (afterNoise > 0.57f && random.Next(0,2) == 1)
                {
                    PlaceBlock(world, tileCollection.rockBlocks[UnityEngine.Random.Range(0, tileCollection.rockBlocks.Length)], x,y);
                }

            }
        }

        noiseX = random.Next(0, 1000) * 0.01f;
        noiseY = random.Next(0, 1000) * 0.01f;


        //ALPHA generate trees
        for (int y = 0; y < size; y++)
        {
            for (int x = 0; x < size; x++)
            {
                if(((Vector2)world.gameObject.transform.position + new Vector2(x,y) - world.worldCenterWorldSpace).magnitude < 6) continue;

                float afterNoise = Mathf.PerlinNoise(noiseX + x * noiseSize, noiseY + y * noiseSize);

                if (afterNoise > 0.6f)
                {
                    PlaceBlock(world, tileCollection.treeBlocks[UnityEngine.Random.Range(0, tileCollection.treeBlocks.Length)], x, y);
                }
                else if (afterNoise > 0.45f && random.Next(0,2) == 1)
                {
                    PlaceBlock(world, tileCollection.treeBlocks[UnityEngine.Random.Range(0, tileCollection.treeBlocks.Length)], x, y);
                }

            }
        }

        return world;
    }

    #endregion

    #region Place Block

    [ServerRpc(RequireOwnership = false)]
    public void PlaceBlockServerRpc(FixedString128Bytes worldName, int xPosition, int yPosition, ushort blockId, ulong placerClientId)
    {
        World world = GetWorldByName(worldName.ToString());
        bool placementSuccessful = false;
        if (world != null && world.blockGrid[xPosition,yPosition] == null)
        {
            worldChanges.Add(new WorldChange(worldName.ToString(), (ushort)xPosition, (ushort)yPosition, blockId));

            PlaceBlockClientRpc(worldName, xPosition, yPosition, blockId);

            placementSuccessful = true;

        }
        
        ClientRpcParams clientRpcParams = new ClientRpcParams
        {
            Send = new ClientRpcSendParams
            {
                TargetClientIds = new ulong[] { placerClientId }
            }
        };

        PlacerClientResponseClientRpc(placementSuccessful, clientRpcParams);

    }

    [ClientRpc]void PlaceBlockClientRpc(FixedString128Bytes worldName, int xPosition, int yPosition, ushort blockId)
    {
        World world = GetWorldByName(worldName.ToString());
        Block block = blocks[blockId];
        if (world != null)
        {
            PlaceBlock(world, block, xPosition, yPosition);

        }
    }

    [ClientRpc]void PlacerClientResponseClientRpc(bool placementSuccessful,ClientRpcParams clientRpcParams = default)
    {
        if (!placementSuccessful)
        {
            LocalPlayerManager.Instance.blockBeingPlaced = null;
            return;
        }

        LocalPlayerManager.Instance.blockBeingPlaced.amount -= 1;

        if(LocalPlayerManager.Instance.blockBeingPlaced.amount == 0)
        {
            DestroyImmediate(LocalPlayerManager.Instance.blockBeingPlaced.gameObject);
            
        }
        InventoryMenu.Instance.UpdateInventory();
        HUD.Instance.UpdateHotbarSlots();

        LocalPlayerManager.Instance.blockBeingPlaced = null;
    }

    void PlaceBlock(World world, Block block, int xPosition, int yPosition)
    {
        if (world.blockGrid[xPosition, yPosition] != null)
        {
            Console.Instance.ShowMessageInConsole(gameObject, "PlaceBlock(): Overlapping block!");
            return;
        }

        GameObject go = Instantiate(block.gameObject);
        block = go.GetComponent<Block>();
        go.transform.position = new Vector3(xPosition, yPosition,0); //ADD WORLD OFFSET!!!!!
        go.transform.parent = world.transform;
        world.blockGrid[xPosition, yPosition] = block;
        block.parentWorld = world;


    }

    #endregion

    #region Remove Block

    [ServerRpc(RequireOwnership = false)]
    public void RemoveBlockServerRpc(FixedString128Bytes worldName, int xPosition, int yPosition)
    {
        World world = GetWorldByName(worldName.ToString());

        if (world == null) return;

        Block block = world.blockGrid[xPosition, yPosition];

        //save change
        worldChanges.Add(new WorldChange(worldName.ToString(), (ushort)xPosition, (ushort)yPosition, 0));

        ItemManager.Instance.SpawnNetworkItem(block.GetDropItemId()[0], (ushort)block.GetDropItemId()[1], "", block.transform.position);
        
        block.OnPlayerDestroy();

        RemoveBlockClientRpc(worldName, xPosition, yPosition);
    }

    [ClientRpc]
    void RemoveBlockClientRpc(FixedString128Bytes worldName, int xPosition, int yPosition)
    {
        World world = GetWorldByName(worldName.ToString());

        if (world == null) return;

        Block block = world.blockGrid[xPosition, yPosition];

        RemoveBlock(block);
    }

    void RemoveBlock(Block block)
    {
        block.parentWorld.blockGrid[(int)block.transform.position.x, (int)block.transform.position.y] = null;

        Destroy(block.gameObject);
    }

    #endregion

    #region Poke Block

    [ServerRpc(RequireOwnership = false)]
    public void PokeBlockServerRPC(FixedString128Bytes worldName, int xPosition, int yPosition, Vector2 direction)
    {
        PokeBlockClientRPC(worldName, xPosition, yPosition, direction);
    }
    [ClientRpc]
    void PokeBlockClientRPC(FixedString128Bytes worldName, int xPosition, int yPosition, Vector2 direction)
    {
        World world = GetWorldByName(worldName.ToString());

        if (world == null) return;

        Block block = world.blockGrid[xPosition, yPosition];
        if (block == null) return;

        block.Poke(direction);

    }

    #endregion

    #region WorldChanges

    [ServerRpc(RequireOwnership = false)]
    void RequestWorldChangesServerRpc(ulong clientId)
    {
        if (!IsServer) return;

        Console.Instance.ShowMessageInConsole(gameObject, "World changes requested by a client (Id:" + clientId + ")");

        WorldChangesHandler.WorldChangesPayload wcpl = new WorldChangesHandler.WorldChangesPayload();

        //Add created world names to payload
        foreach (var item in worlds)
        {
            wcpl.worldNames.Add(item.worldName);
        }

        //Add world builder changes to payload
        wcpl.worldBuilderChanges = new List<WorldChange>(worldChanges);

        WorldChangesHandler.Instance.SendChanges(wcpl, clientId);

    }

    public void ApplyChanges(WorldChangesHandler.WorldChangesPayload wcpl)
    {
        //generate missing worlds

        //place/remove blocks
        foreach (var item in wcpl.worldBuilderChanges)
        {
            if(item.changeId == 0)//block removed
            {
                RemoveBlock(GetWorldByName(item.worldName).blockGrid[item.xPosition, item.yPosition]);
            }
            else
            {
                World world = GetWorldByName(item.worldName);
                PlaceBlock(world, blocks[item.changeId], item.xPosition, item.yPosition);
            }
        }
    }

    #endregion

    #region Utility
    static string GenerateRandomString(int length)
    {
        const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        System.Random random = new System.Random();
        StringBuilder stringBuilder = new StringBuilder(length);

        for (int i = 0; i < length; i++)
        {
            int index = random.Next(chars.Length);
            stringBuilder.Append(chars[index]);
        }

        return stringBuilder.ToString();
    }

    World GetWorldByName(string name)
    {
        World world = null;
        foreach (var item in worlds)
        {
            if (name == item.worldName)
            {
                world = item;
            }

        }
        return world;
    }

    public int[] WorldPositionToWorldGrid(World world, Vector2 position)
    {
        int[] gridPosition = new int[2];

        gridPosition[0] = Mathf.RoundToInt(position.x - world.gameObject.transform.position.x);
        gridPosition[1] = Mathf.RoundToInt(position.y - world.gameObject.transform.position.y);

        return gridPosition;
    }

    public Vector2 GridToWorldPosition(World world, int x, int y)
    {
        Vector2 res = new Vector2();
        res.x = world.gameObject.transform.position.x + x;
        res.y = world.gameObject.transform.position.y + y;

        return res;
    }
    #endregion

}

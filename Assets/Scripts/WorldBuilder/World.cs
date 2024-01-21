using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class World : MonoBehaviour
{
    public string worldName;
    public Block[,] blockGrid;
    public Vector2 worldCenterWorldSpace;

    NavigationNode[,] navigationNodes;

    //Current pathfinding. REMEMBER TO CLEAR THIS AFTER
    int[] currentDestination;
    int[] currentStart;
    [HideInInspector] public List<NavigationNode> openNodes = new List<NavigationNode>();
    public List<NavigationNode> usedNodes = new List<NavigationNode>();
    [HideInInspector] public NavigationNode destinationNode;

    public class NavigationNode
    {
        public NavigationNode(int _x, int _y)
        {
            gridPos = new int[2];
            gridPos[0] = _x;
            gridPos[1] = _y;
        }

        public NavigationNode parent;
        public float heuretic;
        public bool open;

        public int[] gridPos;
    }

    public void Initialize(string _worldName, int size)
    {
        blockGrid = new Block[size, size];
        worldName = _worldName;
        worldCenterWorldSpace = gameObject.transform.position + new Vector3(size / 2, size / 2, 0);

        navigationNodes = new NavigationNode[size, size];

        for (int y = 0; y < size; y++)
        {
            for (int x = 0; x < size; x++)
            {
                navigationNodes[x, y] = new NavigationNode(x,y);
            }
        }

    }


    public List<Vector2> GetPath(Vector2 start, Vector2 destination)
    {

        int stepsRemaining = 30; //Set max steps

        currentDestination = WorldBuilder.Instance.WorldPositionToWorldGrid(this, destination);
        currentStart = WorldBuilder.Instance.WorldPositionToWorldGrid(this, start);
        Console.Instance.ShowMessageInConsole(gameObject, "Start: " + currentStart[0] + ", " + currentStart[1] + " //Destination: " + currentDestination[0] + ", " + currentDestination[1]);

        //Pathfinding....
        Open(currentStart[0], currentStart[1], null);//Add start to open

        while (stepsRemaining > 0)
        {
            NavigationNode node = FindNext(); // find next
            if (node == null) return null;

            if(node.gridPos[0] == currentDestination[0] && node.gridPos[1] == currentDestination[1]) // destination reached
            {
                destinationNode = node;
                break;
            }

            OpenSurrounding(node);
            usedNodes.Add(node);
            openNodes.Remove(node);
            stepsRemaining--;

        }

        if (destinationNode == null)
        {
            Console.Instance.ShowMessageInConsole(gameObject, "Couldn't find destination.");
            return null;
        }

        //Form the path
        Vector2 worldOrigin = WorldBuilder.Instance.GridToWorldPosition(this, 0,0);
        List<Vector2> res = new List<Vector2>(); // result
        res.Add(new Vector2(worldOrigin.x + destinationNode.gridPos[0], worldOrigin.y + destinationNode.gridPos[1]));

        NavigationNode header = destinationNode;
        int looping = 0;
        while (true && looping < 100)
        {
            if(header.parent == null) break; // is starting node

            header = header.parent;
            res.Add(new Vector2(worldOrigin.x + header.gridPos[0], worldOrigin.y + header.gridPos[1]));
            looping++;
        }

        if (looping >= 100) Console.Instance.ShowMessageInConsole(gameObject, "Forming path loop is looping"); //TEMP!!!!!!!

        //Reverse the list
        res.Reverse();

        //Reset pathfinding
        foreach (var item in usedNodes)
        {
            item.open = false;
            item.parent = null;
        }
        foreach (var item in openNodes)
        {
            item.open = false;
            item.parent = null;
        }
        openNodes.Clear();
        usedNodes.Clear();

        res = SimplifyPath(res);

        return res;
    }

    void OpenSurrounding(NavigationNode node)
    {
        int x = node.gridPos[0];
        int y = node.gridPos[1];

        Open(x, y+1, node);
        Open(x+1, y, node);
        Open(x, y-1, node);
        Open(x-1, y, node);
    }

    void Open(int x, int y, NavigationNode parent)
    {
        
        NavigationNode node = navigationNodes[x, y]; //Error if out of bounds
        if (node.open) return; // already opened
        if (blockGrid[x, y] != null) return; // is occupied by a block

        node.parent = parent; //set parent
        node.heuretic = GetDistance(x,y,currentDestination[0],currentDestination[1]); //set
        node.open = true;
        openNodes.Add(node);

        Console.Instance.ShowMessageInConsole(gameObject, "Opening "+ x  +"," + y);
        Debug.DrawRay(new Vector3(x, y), Vector3.up * 0.1f, Color.red, 10f);



    }

    float GetDistance(float x1, float y1, float x2, float y2)
    {
        float res = Mathf.Sqrt(Mathf.Pow(x2 - x1, 2f) + Mathf.Pow(y2 - y1, 2f));

        return res;

    }

    NavigationNode FindNext()
    {
        NavigationNode res = openNodes[0];
        foreach (var item in openNodes)
        {
            if(item.heuretic < res.heuretic)
            {
                res = item;
            }
        }

        return res;
    }

    List<Vector2> SimplifyPath(List<Vector2> path)
    {
        List<Vector2> redundant = new List<Vector2>();
        int looping = 0;
        int i = 0;
        while (i < path.Count && looping < 100)
        {
            int a = 1;
            while (true && looping < 100)
            {   
                if((i + a + 1) >= path.Count)
                {
                    i++;
                    break;
                }

                if(Physics2D.Linecast(path[i], path[i + a + 1])) // is not redundant
                {

                    Debug.LogError("blocked");
                    i = i + a;
                    break;
                    
                }
                else // is redundant
                {
                    redundant.Add(path[i + a]);
                    a++;
                }

                looping++;
            }

            looping++;
        }

        if (looping >= 100) Debug.LogWarning("looping");

        foreach (var item in redundant)
        {
            path.Remove(item);
        }

        return path;
    }
}

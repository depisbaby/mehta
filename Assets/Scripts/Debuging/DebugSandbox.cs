using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Netcode;

public class DebugSandbox : NetworkBehaviour
{
    public static DebugSandbox Instance;
    private void Awake()
    {
        Instance = this;
    }

    public void DebugPathfinding(int x, int y)
    {
        World world = LocalPlayerManager.Instance.currentWorld;
        List<Vector2> path = world.GetPath(LocalPlayerManager.Instance.player.transform.position, (Vector2)LocalPlayerManager.Instance.player.transform.position + new Vector2(x,y));

        if (path == null)
        {
            Console.Instance.ShowMessageInConsole(gameObject, "Path is null!");
            return; 
        }

        for (int i = 0; i < path.Count - 1; i++)
        {
            Debug.DrawLine(path[i], path[i + 1], Color.blue, 10f);
        }

    }

}

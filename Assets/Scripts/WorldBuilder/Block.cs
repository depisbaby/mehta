using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Block : MonoBehaviour
{
    [Header("Block")]
    [HideInInspector]public ushort blockId;
    [HideInInspector]public World parentWorld;
    public int chopsLeft;
    public int dropItemId;
    public int dropAmount;

    virtual public int[] GetDropItemId()
    {
        int[] res = { dropItemId, dropAmount };
        return res;
    }

    virtual public void OnPlayerDestroy()
    {

    }

}

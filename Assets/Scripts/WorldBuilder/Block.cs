using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;

public class Block : MonoBehaviour
{
    [Header("Block")]
    [HideInInspector]public ushort blockId;
    [HideInInspector]public World parentWorld;
    public GameObject visuals;
    public int chopsLeft;
    public int dropItemId;
    public int dropAmount;

    private bool poked;

    virtual public int[] GetDropItemId()
    {
        int[] res = { dropItemId, dropAmount };
        return res;
    }

    virtual public void OnPlayerDestroy()
    {

    }

    async public void Poke(Vector2 direction)
    {
        if (poked) return;
        poked = true;

        Vector3 originalPos = visuals.transform.position;
        visuals.transform.position = visuals.transform.position + (Vector3)direction * 0.3f;
        while(Mathf.Abs((visuals.transform.position - originalPos).magnitude) > 0.01f)
        {
            visuals.transform.position = Vector3.Lerp(visuals.transform.position, originalPos, Time.deltaTime * 10);
            await Task.Yield();
        }
        visuals.transform.position = originalPos;
        poked = false;
    }
}

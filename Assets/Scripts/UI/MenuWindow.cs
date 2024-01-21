using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MenuWindow : MonoBehaviour
{
    [Header("MenuWindow")]
    public bool actionBlocking;
    public virtual void Open()
    {

    }

    public virtual void Close()
    {

    }

    public virtual bool GetWindowActive()
    {
        return false;
    }
}

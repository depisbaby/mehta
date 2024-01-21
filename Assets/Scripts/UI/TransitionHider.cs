using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransitionHider : MenuWindow
{
    public static TransitionHider Instance;
    private void Awake()
    {
        Instance = this;
    }

    [SerializeField] GameObject window;

    #region Overrides
    public override void Open()
    {
        base.Open();
        window.SetActive(true);
    }
    public override void Close()
    {
        base.Close();
        window.SetActive(false);
    }
    #endregion
    


}

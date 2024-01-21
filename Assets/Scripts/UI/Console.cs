using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Console : MenuWindow
{
    public static Console Instance;
    private void Awake()
    {
        Instance = this;
    }

    [SerializeField]TMPro.TMP_InputField inputField;
    [SerializeField]TMPro.TMP_Text prompt;
    [SerializeField]GameObject window;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("Console") && !inputField.isFocused)
        {
            if (window.activeSelf)
            {
                MenuManager.Instance.CloseWindow("Console");
            }
            else
            {
                MenuManager.Instance.OpenWindow("Console", false);
            }
        }

        if (window.activeSelf && Input.GetKeyDown(KeyCode.Return))
        {
            EnterCommand();
        }
    }

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

    public override bool GetWindowActive()
    {
        return window.activeSelf;
    }
    #endregion

    public void ShowMessageInConsole(GameObject sender, string message)
    {
        message = "[" + sender.name + "]: " + message + "\n";
        prompt.text += message;
    }

    public void ShowMessageInConsole(string senderName, string message)
    {
        message = "[" + senderName + "]: " + message + "\n";
        prompt.text += message;
    }

    void EnterCommand()
    {
        string current = inputField.text;
        inputField.text = "";

        if (current == "")
        {
            return;
        }

        string indentifier = current.Split(" ")[0];

        switch(indentifier)
        {
            case "host":
                SessionManager.Instance.AttemptHosting();
                return;

            case "join":
                try
                {
                    SessionManager.Instance.AttemptJoining(current.Split(" ")[1]);
                }
                catch (System.Exception e)
                {
                    Debug.LogWarning(e);
                    ShowMessageInConsole(gameObject, "You're missing the joining code! Join command should be done like so: 'join <Joining code>'");
                }
                return;

            case "getJoiningCode":
                RelayScript.Instance.GetJoiningCode();
                return;

            case "debugPf":
                DebugSandbox.Instance.DebugPathfinding(int.Parse(current.Split(" ")[1]), int.Parse(current.Split(" ")[2]));
                return;

            case "updateSpells":
                InventoryMenu.Instance.equippedSlot.placedItem.CustomMessage("debugUpdateSpells");
                return;

            default:
                ShowMessageInConsole(gameObject,"'"+ indentifier + "' is not a command!");
                return;
        }
    }

}

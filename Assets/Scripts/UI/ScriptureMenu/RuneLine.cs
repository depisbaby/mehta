using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Windows;

public class RuneLine : MonoBehaviour
{
    [SerializeField] Image[] sprites;
    public string unpaddedName;
    public string paddedName;
    public Vector2 lastRunePosition;

    public void SetRuneLineColor(Color color)
    {
        foreach (var sprite in sprites)
        {
            sprite.color = color;
        }
    }

    /// <summary>
    /// Input string.Empty if you wish to remove character from line
    /// </summary>
    /// <param name="correspondingCharacter"></param>
    public void AddToRuneLine(string correspondingCharacter)
    {
        if(correspondingCharacter == string.Empty) // remove character
        {
            if (unpaddedName == string.Empty) return;

            unpaddedName = unpaddedName.Substring(0, unpaddedName.Length - 1);
        }
        else
        {
            if(unpaddedName.Length >= 5) return;

            unpaddedName = unpaddedName + correspondingCharacter;
        }

        UpdateRuneLine();
    }

    public void SetRuneLine(string _fullName)
    {
        string parsed = "";
        for (int i = 0; i < _fullName.Length; i++)
        {
            if (_fullName[i] == '-') break;
            parsed += _fullName[i];
        }

        unpaddedName = parsed;
        UpdateRuneLine();
    }

    void UpdateRuneLine()
    {
        lastRunePosition = (Vector2)transform.position + new Vector2(-100,0);

        foreach(var sprite in sprites)
        {
            sprite.enabled = false;
        }

        for (int i = 0; i < unpaddedName.Length; i++) 
        {
            if(i == unpaddedName.Length - 1)
            {
                lastRunePosition = sprites[i].transform.position;
            }

            sprites[i].sprite = ScriptureMenu.Instance.GetRune(unpaddedName[i].ToString()).sprite;
            sprites[i].enabled = true;  
        }

        if (unpaddedName.Length == 5)
        {
            paddedName = unpaddedName;
            return;
        }

        paddedName = unpaddedName;
        for (int i = paddedName.Length; i < 5; i++)
        {
            paddedName = paddedName + "-";
        }
    }
}

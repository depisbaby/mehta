using System;
using System.Collections;
using System.Collections.Generic;
using Unity.Collections;
using UnityEditor.PackageManager.UI;
using UnityEngine;

public class ScriptureMenu : MenuWindow
{
    public static ScriptureMenu Instance;
    private void Awake()
    {
        Instance = this;
    }

    [SerializeField]GameObject window;

    [System.Serializable]
    public struct Rune
    {
        public Sprite sprite;
        public string correspondingChar;
    }

    [SerializeField] RuneLine[] runeLines;
    [SerializeField] RuneLine selectedLine;
    [SerializeField] GameObject[] pages;
    [SerializeField] GameObject selectorObject;
    [SerializeField] TMPro.TMP_Text pageNumber;
    [SerializeField]List<Rune> runes = new List<Rune>();
    Dictionary<string, Rune> runesDict = new Dictionary<string, Rune>();
    [SerializeField] Color scrollTextColor;

    int currentPage;
    int currentLine;
    SpellCaster spellCaster;

    private void Start()
    {
        for (int i = 0; i < runes.Count; i++) {
            runesDict.Add(runes[i].correspondingChar, runes[i]);
        }

        selectedLine = runeLines[0];

        foreach (var line in runeLines)
        {
            line.SetRuneLine("");
        }

        UpdateMenu();

        MenuManager.Instance.CloseWindow("ScriptureMenu");
    }

    void Update()
    {
        if (window.activeSelf == false) return;

        if (Input.GetKeyDown(KeyCode.Backspace))
        {
            selectedLine.AddToRuneLine(string.Empty);
            UpdateMenu();
        }

        if(Input.GetKeyDown(KeyCode.W)) 
        {
            PageDown(false);
            UpdateMenu();
        }

        if (Input.GetKeyDown(KeyCode.S))
        {
            PageDown(true);
            UpdateMenu();
        }
    }

    public void OpenMenu(SpellCaster spellCaster)
    {

        LoadScriptures(spellCaster);

        MenuManager.Instance.OpenWindow("ScriptureMenu", true);
    }

    void LoadScriptures(SpellCaster _spellCaster)
    {
        spellCaster = _spellCaster;
        string[] words = FixedStringToWords(_spellCaster.data);

        for (int i = 0;i < 18;i++) {
            runeLines[i].SetRuneLineColor(scrollTextColor);
            runeLines[i].SetRuneLine(words[i]);
        }

        //Update spell caster spells
        List<Spell> spellList = new List<Spell>();
        foreach (string item in words)
        {
            Spell spell = SpellManager.Instance.GetSpellByName(item);
            if (spell == null) continue;
            spellList.Add(spell);
        }
        if (spellList.Count == 0) return;
        spellCaster.UpdateSpells(spellList);
    }

    void SaveScriptures()
    {
        if(spellCaster == null) return;

        string[] words = new string[18];

        for (int i = 0; i < 18; i++)
        {
            words[i] = runeLines[i].paddedName;
        }

        spellCaster.data = WordsToFixedString(words);

        //Update spell caster spells
        List<Spell> spellList = new List<Spell>();
        foreach (string item in words)
        {
            Spell spell = SpellManager.Instance.GetSpellByName(item);
            if (spell == null) continue;
            spellList.Add(spell);
        }

        if (spellList.Count == 0) return;

        spellCaster.UpdateSpells(spellList);
    }

    private void UpdateMenu()
    {
        pageNumber.text = (currentPage + 1) + "/3";
        selectorObject.transform.position = selectedLine.lastRunePosition + new Vector2(100, 0);
    }

    #region Inputs

    public void PageForward(bool forward)
    {
        if (forward)
        {
            currentPage += 1;
        }
        else
        {
            currentPage -= 1;
        }

        if(currentPage == -1) 
        {
            currentPage = 2;
        }
        else if(currentPage == 3)
        {
            currentPage = 0;
        }

        foreach (var item in pages) {
            item.SetActive(false);
        }

        pages[currentPage].SetActive(true);

        selectedLine = runeLines[currentPage*6];

        UpdateMenu();
    }

    public void RuneBoardInput(string input) { 
        selectedLine.AddToRuneLine(input);
        UpdateMenu();
    }

    public void PageDown(bool down)
    {
        if(down)
        {
            currentLine += 1;
        }
        else
        { 
            currentLine -= 1; 
        }

        if (currentLine == -1)
        {
            currentLine = 5;
        }
        else if (currentLine == 6)
        {
            currentLine = 0;
        }

        selectedLine = runeLines[currentPage * 6 + currentLine];
        
    }

    #endregion

    #region Utility
    public Rune GetRune(string correspondingChar)
    {
        return runesDict[correspondingChar];
    }

    public string[] FixedStringToWords(FixedString128Bytes input)
    {
        string[] words = new string[18];
        string newInput = input.ToString();
        //Debug.Log(input);
        for (int i = 0; i < 18; i++)
        {
            words[i] = newInput.Substring(i * 5, 5);
            //Debug.Log(words[i]);
        }

        return words;
    }

    public FixedString128Bytes WordsToFixedString(string[] input)
    {
        FixedString128Bytes fString = new FixedString128Bytes();

        foreach (var word in input)
        {
            fString = fString + word;
        }

        return fString;
    }

    
    #endregion

    #region Overrides
    public override void Open()
    {
        base.Open();
        window.SetActive(true);
    }
    public override void Close()
    {
        base.Close();
        SaveScriptures();
        window.SetActive(false);
    }

    public override bool GetWindowActive()
    {
        return window.activeSelf;
    }
    #endregion
}

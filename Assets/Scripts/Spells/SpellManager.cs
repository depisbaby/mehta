using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Netcode;

public class SpellManager : NetworkBehaviour
{
    public static SpellManager Instance;
    private void Awake()
    {
        Instance = this;
    }

    public string[] existingCharacters;
    public List<Spell> spells;
    Dictionary<string, Spell> spellsDict = new Dictionary<string, Spell>();

    // Start is called before the first frame update
    void Start()
    {
        GenerateSpells("");
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void GenerateSpells(string seed)
    {
        foreach (Spell spell in spells)
        {
            spell.runicName = GetUniqueRunicName();
            spellsDict.Add(spell.runicName, spell);
        }
    }

    public Spell GetSpellByName(string name)
    {
        if (!spellsDict.ContainsKey(name)) return null;

        return spellsDict[name];
    }

    string GetUniqueRunicName()
    {
        while (true)
        {
            string name = string.Empty;
            int length = UnityEngine.Random.Range(1, 6);
            string lastCharacter = string.Empty;

            for (int i = 0; i < length; i++) 
            {
                string nextCharacter = existingCharacters[UnityEngine.Random.Range(0, existingCharacters.Length)];
                if (nextCharacter == lastCharacter) continue;
                lastCharacter = nextCharacter;  
                name = name + nextCharacter;
            }

            if(name.Length != 5)
            {
                for (int i = name.Length; i < 5; i++)
                {
                    name = name + "-";
                }
            }

            //Debug.Log(name);

            if (!spellsDict.ContainsKey(name)) 
            {
                return name;
            }
            
        }
    }

}

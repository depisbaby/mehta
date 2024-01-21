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
    Dictionary<string, Spell> spellsDict;

    // Start is called before the first frame update
    void Start()
    {
        
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

    string GetUniqueRunicName()
    {
        while (true)
        {
            string name = string.Empty;
            int lenght = UnityEngine.Random.Range(1, 8);
            string lastCharacter = string.Empty;

            for (int i = 0; i < lenght; i++) 
            {
                string nextCharacter = existingCharacters[UnityEngine.Random.Range(0, existingCharacters.Length)];
                if (nextCharacter == lastCharacter) continue;
                lastCharacter = nextCharacter;  
                name = name + nextCharacter;
            }

            if(!spellsDict.ContainsKey(name)) 
            {
                return name;
            }
            
        }
    }

}

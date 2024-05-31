using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;

public class Spell : MonoBehaviour
{
    [System.Serializable]
    public class SpellMods
    {
        public SpellMods()
        {
            
        }

        public SpellMods(SpellMods original)
        {
            cascading = original.cascading;
            damageBonus = original.damageBonus;
        }

        public bool cascading;
        public int damageBonus;
    }

    public class EndData
    {
        public Vector2 position;
        public Vector2 direction;
    }

    public string runicName;
    public int manaCost;
    

    //Hidden
    protected SpellCaster spellCaster;
    protected List<Spell> nextSpells = new List<Spell>();
    [SerializeField]protected SpellMods mods;
    protected bool isLastSpell;

    public virtual void InitializeSpell(Queue<Spell> spells, SpellMods _mods, SpellCaster _spellCaster)
    {
        spellCaster = _spellCaster;
        mods = _mods;

        if(spells.Count == 0)
        {
            isLastSpell = true;
        }
    }

    public virtual void Cast(Vector2 position, Vector2 direction)
    {
        //Drain mana

        if(isLastSpell)
        {
            spellCaster.EndCoolDown();
        }
    }

    public virtual void EndCast(Vector2 position, Vector2 direction)
    {

    }

    public virtual void EndCast(List<EndData> endData)
    {

    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

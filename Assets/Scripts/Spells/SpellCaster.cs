using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpellCaster : Item
{
    public int currentSpellManaCost;

    [HideInInspector]public GameObject spellTreeBase;
    Spell baseSpell;
    [HideInInspector]public Vector2 casterPosition;
    [HideInInspector] public Vector2 casterDirection;

    [SerializeField]List<Spell> debugSpellQueue;

    private void Update()
    {
        
    }

    public override void UseLeftClick()
    {
        PlayerCastSpell();
    }

    public override void UseRightClick() 
    { 
    
    }

    public override void CustomMessage(string message)
    {
        if (message == "debugUpdateSpells") UpdateSpells(debugSpellQueue);
    }

    /// <summary>
    /// (Spells in the list should point to Prefabs)
    /// </summary>
    /// <param name="spells"></param>
    public void UpdateSpells(List<Spell> spells)
    {
        Queue<Spell> queue = new Queue<Spell>();
        foreach (var item in spells)
        {
            queue.Enqueue(item);
        }

        if(spellTreeBase != null)
        {
            Destroy(spellTreeBase);
        }

        spellTreeBase = new GameObject();
        spellTreeBase.gameObject.name = "SpellTreeBase";
        spellTreeBase.transform.parent = transform;

        Spell spell = Instantiate(queue.Dequeue());
        spell.gameObject.transform.parent = spellTreeBase.transform;
        baseSpell = spell;
        Spell.SpellMods spellMods = new Spell.SpellMods();
        spell.InitializeSpell(queue, spellMods, this);
    }

    void PlayerCastSpell()
    {
        casterPosition = LocalPlayerManager.Instance.player.transform.position;
        casterDirection = LocalPlayerManager.Instance.lookingAtDirection;

        baseSpell.Cast(casterPosition, casterDirection);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static Spell;

public class TemplateSpell : Spell
{
    public override void InitializeSpell(Queue<Spell> spells, SpellMods _mods, SpellCaster _spellCaster)
    {
        base.InitializeSpell(spells, _mods, _spellCaster); //Execute parent logic

        if (spells.Count <= 0) return; //No more spells in queue

        //Edit mods here... (using "mods.<property> = <value>")

        Spell spell = Instantiate(spells.Dequeue()); //Create new instance of a spell from the queue
        nextSpells.Add(spell); //Add as next

        SpellMods newMods = new SpellMods(mods); //Remove cascading
        if (mods.cascading) 
        {
            spell.transform.parent = this.transform;
            newMods.cascading = false;
        }
        else
        {
            spell.transform.parent = spellCaster.spellTreeBase.transform;
        }

        spell.InitializeSpell(spells, newMods, spellCaster); //Initialize the next spell
    }

    public override void Cast(Vector2 position, Vector2 direction)
    {
        base.Cast(position, direction);

        //Spawn projectile, aura, effect, etc. here...

        //(!!!) You have to call EndCast(Vector2, Vector2) of this instance after the lifetime of said projectile, aura, effect.

        if (!mods.cascading) //We will cast the next spell immediatelly as this spell doesnt cascade
        {
            if (nextSpells.Count == 0) return;

            nextSpells[0].Cast(position, direction); //Cast next spell...
        }
    }

    public override void EndCast(Vector2 position, Vector2 direction)
    {
        base.EndCast(position, direction);

        if (nextSpells.Count == 0) return;

        //(!!!) If this spell has cascade, consider to cast the next spell at the end point of the projectile, aura, effect. (End point as the "position" and "direction")
        //If your spell has multible ending points you can implement "public override void EndCast(List<Spell.EndData()> endData)"
        
        if (mods.cascading)
        {
            nextSpells[0].Cast(position, direction); //Cast next spell...
        }
    }
}

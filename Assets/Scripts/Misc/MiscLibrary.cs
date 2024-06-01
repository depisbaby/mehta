using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.U2D;

public class MiscLibrary : MonoBehaviour
{
    public static MiscLibrary Instance;
    private void Awake()
    {
        Instance = this;
    }

    List<Sprite> spriteLibrary = new List<Sprite> ();

    // Start is called before the first frame update
    void Start()
    {
        //
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void AddToSpriteLibrary(Sprite sprite)
    {
        spriteLibrary.Add(sprite);
    }

    public Sprite GetFromSpriteLibrary(int id)
    {
        return spriteLibrary[id];
    }

    public int GetSpriteId(Sprite target)
    {

        for (int i = 0; i < spriteLibrary.Count; i++)
        {
            if (spriteLibrary[i] == target) return i;
        }

        Console.Instance.ShowMessageInConsole(gameObject, "Local sprite library doesn't contain that sprite!");

        return -1;
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CursorManager : MonoBehaviour
{
    public static CursorManager Instance;
    private void Awake()
    {
        Instance = this;
    }

    public Sprite defaultCursor;
    [SerializeField] Image canvasCursorImage;
    [SerializeField] Transform canvasCursorTransform;
    [SerializeField] Image canvasCursorHelperImage;

    // Start is called before the first frame update
    void Start()
    {
        SetCursorSprite(defaultCursor, 0.5f);
    }

    // Update is called once per frame
    void Update()
    {
        canvasCursorTransform.position = Input.mousePosition;
    }

    public void SetCursorSpriteWithHelper(Sprite sprite)
    {
        SetCursorSprite(sprite, 1f);
        canvasCursorHelperImage.color = Color.white;
    }

    public void SetCursorSprite(Sprite sprite, float size)
    {
        canvasCursorHelperImage.color = Color.clear;

        if (sprite == null)
        {
            canvasCursorImage.sprite = defaultCursor;
            canvasCursorTransform.localScale = new Vector3(0.5f, 0.5f, 1f);
            return;
        }

        canvasCursorTransform.localScale = new Vector3(size, size, 1f);
        canvasCursorImage.sprite = sprite;
    }

}

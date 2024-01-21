using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LocalPlayerManager : MonoBehaviour
{
    public static LocalPlayerManager Instance;
    private void Awake()
    {
        Instance = this;
    }

    [Header("Social")]
    public string username;

    [Header("Ingame modifiers")]
    public float moveSpeed;
    public AnimationCurve movingCurve;
    public float chopRange;

    [Header("Other")]
    public LayerMask chopLayerMask;

    [HideInInspector] public World currentWorld;
    [HideInInspector] public Vector2 lookingAtDirection;
    [HideInInspector] public Player player;
    [HideInInspector] public Placeable blockBeingPlaced;
    




    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Inputs();
        
    }

    void Inputs()
    {
        if (player == null) return;
        if (MenuManager.Instance.actionBlockingWindowOpen) return;

        LeftClick();
        RightClick();
        MovePlayer();

        lookingAtDirection = Camera.main.ScreenToWorldPoint(Input.mousePosition) - player.transform.position;
        lookingAtDirection.Normalize();

    }

    void LeftClick()
    {
        if (Input.GetButtonDown("Mouse0"))
        {
            if (InventoryMenu.Instance.equippedSlot.placedItem != null)
            {
                InventoryMenu.Instance.equippedSlot.placedItem.UseLeftClick();
            }
        }
    }
    void RightClick()
    {
        if (Input.GetButtonDown("Mouse1"))
        {
            if(InventoryMenu.Instance.equippedSlot.placedItem != null)
            {
                InventoryMenu.Instance.equippedSlot.placedItem.UseRightClick();
            }
        }
    }


    void MovePlayer()
    {
        Vector2 delta = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical")).normalized;

        //player.rb.AddForce(delta * Time.deltaTime * moveSpeed * 1000f * movingCurve.Evaluate(player.rb.velocity.magnitude));
        player.rb.AddForce(delta * Time.deltaTime * moveSpeed * 1000f * movingCurve.Evaluate(player.rb.velocity.magnitude));
    }

    public void TeleportPlayer(Vector2 position)
    {
        if (player == null) return;

        player.transform.position = position;
    }
      
}

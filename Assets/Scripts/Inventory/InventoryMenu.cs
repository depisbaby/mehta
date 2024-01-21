using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InventoryMenu : MenuWindow, IItemSlot
{
    public static InventoryMenu Instance;
    private void Awake()
    {
        Instance = this;
    }

    enum InventoryAction
    {
        None = 0,
        GrabbedAll = 1,
        GrabbedHalf = 2,
    }

    [SerializeField] GameObject window;

    [Header("Inventory menu")]

    [SerializeField] float spacing;

    public List<ItemSlot> hotbarItemSlots = new List<ItemSlot>();
    List<ItemSlot> inventoryItemSlots = new List<ItemSlot>();
    public ItemSlot equippedSlot;

    [SerializeField]
    public ItemSlot hoveredSlot;
    public ItemSlot activeSlot;

    InventoryAction currentAction;



    [Header("PII")]
    [SerializeField] Transform hotbarTransform;
    [SerializeField] Transform inventoryTransform;
    [SerializeField] GameObject itemSlotPrefab;

    int selectedHotbarSlotIndex;

    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i < 9; i++)
        {
            GameObject go = Instantiate(itemSlotPrefab);
            go.name = "hotbarSlot" + i;
            go.transform.parent = hotbarTransform;
            go.transform.localPosition = new Vector3(i*spacing, 0, 0);

            ItemSlot iS = go.GetComponent<ItemSlot>();
            iS._interface = this;
            hotbarItemSlots.Add(iS);
        }

        int a = 0;
        for (int y = 0; y < 6; y++)
        {
            for (int x = 0; x < 15; x++)
            {
                GameObject go = Instantiate(itemSlotPrefab);
                go.name = "inventorySlot" + a;
                go.transform.parent = inventoryTransform;
                go.transform.localPosition = new Vector3(x * spacing, -y * spacing, 0);

                ItemSlot iS = go.GetComponent<ItemSlot>();
                iS._interface = this;
                inventoryItemSlots.Add(iS);

                a++;
            }
        }

        MenuManager.Instance.CloseWindow("InventoryMenu");
        equippedSlot = hotbarItemSlots[0];
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("Inventory"))
        {
            if (window.activeSelf)
            {
                MenuManager.Instance.CloseWindow("InventoryMenu");
            }
            else
            {
                MenuManager.Instance.OpenWindow("InventoryMenu", true);
            }
        }

        if (!window.activeSelf)
        {
            HotbarInputs();

            return;
        }

        if (Input.GetButtonDown("Mouse0") && Input.GetKey(KeyCode.LeftShift))
        {
            if (hoveredSlot == null) return;

            DropItem(hoveredSlot);

        }
        else if (Input.GetButtonUp("Mouse0")) 
        {
            if(activeSlot == null && hoveredSlot != null) //Grab all item
            {
                if (hoveredSlot.placedItem == null) return;

                activeSlot = hoveredSlot;
                currentAction = InventoryAction.GrabbedAll;
                CursorManager.Instance.SetCursorSpriteWithHelper(activeSlot.placedItem.itemSprite);
            }
            else if(activeSlot != null && hoveredSlot != null) //Place item
            {
                if(currentAction == InventoryAction.GrabbedAll)
                {
                    MoveItemToSlot(activeSlot, hoveredSlot);
                }
                else if (currentAction == InventoryAction.GrabbedHalf)
                {
                    MoveHalfToSlot(activeSlot, hoveredSlot);
                }

                CursorManager.Instance.SetCursorSprite(null, 0.5f);
                activeSlot = null;
                currentAction = InventoryAction.None;
            }
            else
            {
                CursorManager.Instance.SetCursorSprite(null, 0.5f);
                activeSlot = null;
                currentAction = InventoryAction.None;

            }

            
        }
        else if (Input.GetButtonUp("Mouse1"))
        {
            if (activeSlot == null && hoveredSlot != null) //Grab half item
            {
                if (hoveredSlot.placedItem == null) return;

                activeSlot = hoveredSlot;
                currentAction = InventoryAction.GrabbedHalf;
                CursorManager.Instance.SetCursorSpriteWithHelper(activeSlot.placedItem.itemSprite);
            }
            else if (activeSlot != null && hoveredSlot != null && currentAction == InventoryAction.GrabbedAll)
            {

            }
            else
            {

            }
        }
    }

    #region Overrides
    public override void Open()
    {
        base.Open();
        UpdateInventory();
        window.SetActive(true);
    }
    public override void Close()
    {
        base.Close();
        activeSlot = null;
        CursorManager.Instance.SetCursorSprite(null, 0.5f);
        window.SetActive(false);
    }

    public override bool GetWindowActive()
    {
        return window.activeSelf;
    }

    #endregion

    #region Public
    public void PutItemToPlayerInventory(Item item)
    {
        Debug.Log("afgasdgasdg");
        item.gameObject.transform.parent = ItemManager.Instance.transform;

        foreach (var slot in inventoryItemSlots)
        {
            if (slot.placedItem == null)//Find a empty slot
            {
                slot.placedItem = item;
                return;
            }

            if (item.stackable && slot.placedItem.itemId == item.itemId)//Find a slot with same item and excess space
            {
                ushort _free = 100;
                _free -= slot.placedItem.amount;

                if (item.amount <= _free)
                {
                    slot.placedItem.amount += item.amount;
                    item.amount = 0;
                }
                else
                {
                    slot.placedItem.amount += _free;
                    item.amount -= _free;
                }

                if (item.amount == 0)
                {
                    Destroy(item.gameObject);
                    return;
                }

            }

        }

        //If no room, destroy item/amount to prevent duplication exploits
        Console.Instance.ShowMessageInConsole(gameObject, "Excess local items detected!");

    }

    public ushort CheckFit(int itemId)
    {
        Item item = ItemManager.Instance.items[itemId];

        ushort res = 0;
        foreach (var slot in inventoryItemSlots)
        {
            if (slot.placedItem == null)//Find a empty slot
            {
                return 100;
            }

            if (item.stackable && slot.placedItem.itemId == item.itemId)//Find a slot with same item and excess space
            {
                ushort free = 100;
                free -= slot.placedItem.amount;
                res += free;
            }

            if (res >= 100)
            {
                return 100;
            }

        }

        return res;

    }

    public void UpdateInventory()
    {
        foreach (var item in hotbarItemSlots)
        {
            if(item.placedItem != null)
            {
                item.icon.color = Color.white;
                item.icon.sprite = item.placedItem.itemSprite;

                if (item.placedItem.stackable)
                {
                    item.amountTmp.text = item.placedItem.amount.ToString();

                }
                else
                {
                    item.amountTmp.text = "";
                }

            }
            else
            {
                item.icon.color = Color.clear;
                item.amountTmp.text = "";
            }
        }

        foreach (var item in inventoryItemSlots)
        {
            if (item.placedItem != null)
            {
                item.icon.color = Color.white;
                item.icon.sprite = item.placedItem.itemSprite;
                
                if (item.placedItem.stackable)
                {
                    item.amountTmp.text = item.placedItem.amount.ToString();

                }
                else
                {
                    item.amountTmp.text = "";
                }
            }
            else
            {
                item.icon.color = Color.clear;
                item.amountTmp.text = "";
            }
        }
    }

    #endregion

    #region Actions
    void MoveSelectedHotbar(int moveDirection)
    {
        selectedHotbarSlotIndex += moveDirection;

        if(selectedHotbarSlotIndex >= 9)
        {
            selectedHotbarSlotIndex = 0;
        }
        else if(selectedHotbarSlotIndex <= -1)
        {
            selectedHotbarSlotIndex = 8;
        }

        equippedSlot = hotbarItemSlots[selectedHotbarSlotIndex];
        HUD.Instance.HotbarSelect(selectedHotbarSlotIndex);


    }

    #endregion

    #region Inventory manipulation
    void MoveItemToSlot(ItemSlot startingSlot, ItemSlot destinationSlot)
    {
        if (startingSlot.placedItem == null) return;

        if (startingSlot == destinationSlot) return;

        if(startingSlot.placedItem != null && destinationSlot.placedItem != null) //switch positions
        {
            if(startingSlot.placedItem.itemId == destinationSlot.placedItem.itemId && startingSlot.placedItem.stackable)
            {
                StackItems(startingSlot, destinationSlot);
                return;
            }

            Item switcher = destinationSlot.placedItem;
            destinationSlot.placedItem = startingSlot.placedItem;
            startingSlot.placedItem = switcher;

            
        }
        else
        {

            destinationSlot.placedItem = startingSlot.placedItem;
            startingSlot.placedItem = null;

        }

        UpdateInventory();
        HUD.Instance.UpdateHotbarSlots();

    }

    void StackItems(ItemSlot start, ItemSlot destination)
    {
        int startAmount = start.placedItem.amount;
        int destinationAmount = destination.placedItem.amount;

        if(startAmount + destinationAmount <= 100)
        {
            int x = startAmount + destinationAmount;
            destination.placedItem.amount = (ushort)x;
            Destroy(start.placedItem.gameObject);
            start.placedItem = null;
        }
        else
        {
            destination.placedItem.amount = 100;

            int x = startAmount + destinationAmount - 100;
            start.placedItem.amount = (ushort)x;
        }

        UpdateInventory();
        HUD.Instance.UpdateHotbarSlots();
    }

    void MoveHalfToSlot(ItemSlot startingSlot, ItemSlot destinationSlot)
    {
        if (startingSlot.placedItem == null) return;

        if (startingSlot == destinationSlot) return;

        if (destinationSlot.placedItem != null) return;

        if (startingSlot.placedItem.amount <= 1) return;

        int amount = startingSlot.placedItem.amount / 2;
        Item item = ItemManager.Instance.CreateLocalItem(startingSlot.placedItem.itemId, (ushort)amount, "");
        item.gameObject.transform.parent = ItemManager.Instance.transform;

        destinationSlot.placedItem = item;
        startingSlot.placedItem.amount -= (ushort)amount;

        UpdateInventory();
        HUD.Instance.UpdateHotbarSlots();
    }

    void DropItem(ItemSlot targetSlot)
    {
        if (targetSlot.placedItem == null) return;

        ItemManager.Instance.DropItemServerRpc(targetSlot.placedItem.itemId, targetSlot.placedItem.amount, targetSlot.placedItem.data, (Vector2)LocalPlayerManager.Instance.player.transform.position + LocalPlayerManager.Instance.lookingAtDirection);
        Destroy(targetSlot.placedItem.gameObject);
        targetSlot.placedItem = null;

        UpdateInventory();
        HUD.Instance.UpdateHotbarSlots();
    }

    #endregion

    #region Update
    
    void HotbarInputs()
    {
        if (Input.mouseScrollDelta.y != 0)
        {
            MoveSelectedHotbar((int)Input.mouseScrollDelta.y);
        }


    }

    #endregion

    #region other
    public void OnHover(ItemSlot itemSlot)
    {
        hoveredSlot = itemSlot;
    }
    #endregion
}

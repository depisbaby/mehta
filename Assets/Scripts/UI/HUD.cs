using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Threading.Tasks;

public class HUD : MonoBehaviour
{
    public static HUD Instance;
    private void Awake()
    {
        Instance = this;
    }

    [Header("Damage screen")]
    [SerializeField] Image damageScreen;
    [SerializeField] Gradient damageScreenGardient;

    [Header("Hotbar")]
    [SerializeField] ItemSlot[] itemSlots;
    [SerializeField] Transform hotbarBaseTransform;
    [SerializeField] Transform hotbarSelectBoxTransform;
    
    float damage;

    //Hotbar
    float hotbarShow;
    Vector2 hotbarShowPosition;
    Vector2 hotbarHidePosition;
    Vector2 selectTarget;

    // Start is called before the first frame update
    void Start()
    {
        UpdateHotbarSlots();
        hotbarShowPosition = hotbarBaseTransform.transform.position;
        hotbarHidePosition = hotbarShowPosition + new Vector2(0,-300);
    }

    // Update is called once per frame
    void Update()
    {
        damage = Mathf.MoveTowards(damage, 0f, Time.deltaTime * 0.1f);
        damageScreen.color = damageScreenGardient.Evaluate(damage);

        HotbarUpdate();
    }

    #region Public


    public void DamageTaken(int _damage)
    {
        damage += (_damage / 100f);
        Mathf.Clamp(damage, 0f, 1f);
    }
    public void HotbarSelect(int slotIndex)
    {
        hotbarShow = 3f;
        selectTarget = itemSlots[slotIndex].transform.localPosition;
    }
    public void UpdateHotbarSlots()
    {
        int i = 0;
        foreach (var item in InventoryMenu.Instance.hotbarItemSlots)
        {
            if (item.placedItem == null)
            {
                //Debug.Log("sgsdgsdg");
                itemSlots[i].icon.enabled = false;
                itemSlots[i].amountTmp.text = "";
               
            }
            else
            {
                itemSlots[i].icon.enabled = true;
                itemSlots[i].icon.sprite = item.icon.sprite;
                itemSlots[i].amountTmp.text = item.amountTmp.text; 

            }
            i++;
        }
    }


    #endregion

   

    #region Update

    void HotbarUpdate()
    {
        hotbarSelectBoxTransform.localPosition = selectTarget;

        if(hotbarShow <= 0f)
        {
            hotbarBaseTransform.position = Vector2.Lerp(hotbarBaseTransform.position, hotbarHidePosition, Time.deltaTime * 4f);
        }
        else
        {
            hotbarBaseTransform.position = Vector2.Lerp(hotbarBaseTransform.position, hotbarShowPosition, Time.deltaTime * 4f);
        }

        if (hotbarShow > 0f)
        {
            hotbarShow -= Time.deltaTime;
        }
    }

    #endregion
}

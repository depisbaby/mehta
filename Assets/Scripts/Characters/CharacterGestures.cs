using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Netcode;
using System.Drawing;
using System.Threading.Tasks;

public class CharacterGestures : NetworkBehaviour
{
    [SerializeField] private GameObject gestureObject;
    [SerializeField] private AnimationCurve swingCurve;
    [SerializeField] private AnimationCurve sizeCurve;
    private SpriteRenderer sr;

    public bool gestureActive { get; private set; }

    // Start is called before the first frame update
    void Start()
    {
        sr = gestureObject.GetComponentInChildren<SpriteRenderer>();
        sr.sprite = null;
        sr.enabled = false;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    #region Change sprite
    public void ChangeSpriteOwner(Sprite sprite, float size, Vector2 posOffset, float rotationOffset)
    {
        if (!IsOwner) return;
        int spriteId = MiscLibrary.Instance.GetSpriteId(sprite);
        ChangeSpriteServerRPC(spriteId, size, posOffset, rotationOffset);
    }

    [ServerRpc]
    public void ChangeSpriteServerRPC(int spriteId, float size, Vector2 posOffset, float rotationOffset)
    {
        ChangeSpriteClientRPC(spriteId, size, posOffset, rotationOffset);//send to others
    }
    [ClientRpc]
    void ChangeSpriteClientRPC(int spriteId, float size, Vector2 posOffset, float rotationOffset)
    {
        if (IsOwner) return;
        ChangeSprite(spriteId, size, posOffset, rotationOffset);
    }
    void ChangeSprite(int spriteId, float size, Vector2 posOffset, float rotationOffset)
    {
        sr.gameObject.transform.localRotation = Quaternion.Euler(0, 0, rotationOffset);
        sr.gameObject.transform.localPosition = posOffset;
        sr.gameObject.transform.localScale = new Vector3(size, size, 1);
        sr.sprite = MiscLibrary.Instance.GetFromSpriteLibrary(spriteId);
    }
    #endregion

    #region Swinging
    public void Swing(int direction, float speed)
    {
        if (!IsOwner) return;
        if (gestureActive) return;
        gestureActive = true;
        ClientSwing(direction, speed);
        SwingServerRPC(direction, speed);
    }
    [ServerRpc]
    void SwingServerRPC(int direction, float speed)
    {
        
        SwingClientRPC(direction, speed);//send to others
    }
    [ClientRpc]
    void SwingClientRPC(int direction, float speed)
    {
        if (IsOwner) return;
        ClientSwing(direction, speed);
    }
    async void ClientSwing(int direction, float speed)
    {
        gestureObject.transform.localScale = new Vector3(direction, 1, 1);
        sr.enabled = true;

        float time = 0f;
        while(time < 1f)
        {
            float size = sizeCurve.Evaluate(time);
            gestureObject.transform.localScale = new Vector3(size * direction, size,1);
            gestureObject.transform.rotation = Quaternion.Euler(0, 0, direction * swingCurve.Evaluate(time));
            time += Time.deltaTime * speed;
            await Task.Yield();
        }

        gestureObject.transform.localScale = new Vector3(0, 0, 1);
        if (!IsOwner) return;
        gestureActive = false;

    }

    #endregion


}

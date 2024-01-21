using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Netcode;
using Unity.Collections;

public class Player : NetworkBehaviour
{
    public NetworkVariable<FixedString128Bytes> username = new NetworkVariable<FixedString128Bytes>();
    public NetworkVariable<int> health = new NetworkVariable<int>();

    public Rigidbody2D rb;


    // Start is called before the first frame update
    void Start()
    {
        if (IsOwner)
        {
         
            LocalPlayerManager.Instance.player = this;

            CameraController.Instance.FollowObject(gameObject);
        }
    }

    private void OnDestroy()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

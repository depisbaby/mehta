using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public static CameraController Instance;
    private void Awake()
    {
        Instance = this;
    }

    GameObject objectToFollow;

    public void FollowObject(GameObject go)
    {
        objectToFollow = go;
    }

    // Update is called once per frame
    void Update()
    {
        if(objectToFollow != null)
        {
            transform.position = objectToFollow.transform.position + new Vector3(0, 0, -10);
        }
    }
}

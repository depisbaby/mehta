using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Collections;
using Unity.Netcode;
using Newtonsoft.Json;
using System.Threading.Tasks;
public class WorldChangesHandler : MonoBehaviour
{
    public static WorldChangesHandler Instance;
    private void Awake()
    {
        Instance = this;
    }

    public class WorldChangesPayload
    {
        public WorldChangesPayload()
        {
            worldNames = new List<string>();
        }

        public List<string> worldNames;
        public List<WorldBuilder.WorldChange> worldBuilderChanges;
    }


    private void Start()
    {
        
    }

    public void _Start()
    {
        Console.Instance.ShowMessageInConsole(gameObject, "Registering named messages...");
        NetworkManager.Singleton.CustomMessagingManager.RegisterNamedMessageHandler("ReceiveMessage", ReceiveMessage);

    }

    private void OnDestroy()
    {
        NetworkManager.Singleton.CustomMessagingManager.UnregisterNamedMessageHandler("ReceiveMessage");
    }


    private void ReceiveMessage(ulong senderId, FastBufferReader messagePayload)
    {
        string payload;
        messagePayload.ReadValueSafe(out payload);

        WorldChangesPayload wcpl = JsonToWorldChangesPayload(payload);

        Console.Instance.ShowMessageInConsole(gameObject, "Received world changes from the server. (Payload length: " + payload.Length + ")");

        WorldBuilder.Instance.ApplyChanges(wcpl);

    }

    public void SendChanges(WorldChangesPayload wcpl, ulong clientId)
    {

        string payload = WorldChangesPayloadToJson(wcpl);
        int size = FastBufferWriter.GetWriteSize(payload);

        Console.Instance.ShowMessageInConsole(gameObject, "Sending world changes to a client... (Id:" + clientId + ", " + size +" bytes)");

        var man = NetworkManager.Singleton.CustomMessagingManager;
        var writer = new FastBufferWriter(size, Allocator.Temp);

        using (writer)
        {
            writer.WriteValueSafe(payload);
            
            man.SendNamedMessage("ReceiveMessage", clientId, writer, NetworkDelivery.ReliableFragmentedSequenced);
            
            
        }

        Console.Instance.ShowMessageInConsole(gameObject, "World changes sent to client. (Id:" + clientId + ")");
    }

    static string WorldChangesPayloadToJson(WorldChangesPayload obj)
    {
        string res = JsonConvert.SerializeObject(obj);

        return res;
    }

    static WorldChangesPayload JsonToWorldChangesPayload(string json)
    {
        WorldChangesPayload res = JsonConvert.DeserializeObject<WorldChangesPayload>(json);

        return res;
    }

}
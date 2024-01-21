using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System.Threading.Tasks;
using Unity.Netcode;
using Unity.Networking.Transport;
using Unity.Networking.Transport.Relay;
using Unity.Networking.Transport.Utilities;

public class SessionManager : MonoBehaviour
{

    #region Singleton
        public static SessionManager Instance { get; private set; }
        
        private void Awake() 
        { 
            // If there is an instance, and it's not me, delete myself.
            
            if (Instance != null && Instance != this) 
            { 
                Destroy(this); 
            } 
            else 
            { 
                Instance = this; 
            } 
        }
    #endregion

    public bool offlineMode;
    
    public async void AttemptJoining(string joinCode)
    {
        if(joinCode == "")
        {
            return;
        }
        
        while(RelayScript.Instance == null){
            await Task.Yield();
        }

        if(!await RelayScript.Instance.JoinRelay(joinCode))
        {
            Console.Instance.ShowMessageInConsole(this.gameObject, "Failed to join the session with given code!");
            return;
        }

        while (NetworkManager.Singleton.IsListening == false)
        {
            await Task.Yield();
        }

        EnterGame();
        

    }

    public async void AttemptHosting()
    {
        
        while(RelayScript.Instance == null){
            await Task.Yield();
        }

        if (offlineMode)
        {
            
            if (!NetworkManager.Singleton.StartHost())
            {
                Console.Instance.ShowMessageInConsole("NetworkManager", "Couldn't start host!");
                return;
            }
        }
        else if (!await RelayScript.Instance.CreateRelay())
        {
            Console.Instance.ShowMessageInConsole(this.gameObject, "Failed to create a relay the session!");
            return;
        }

        while (NetworkManager.Singleton.IsListening == false)
        {
            await Task.Yield();
        }

        EnterGame();

    }

    async void EnterGame()
    {
        WorldChangesHandler.Instance._Start();

        WorldBuilder.Instance.EnterInGame();

        while (LocalPlayerManager.Instance.player == null)
        {
            await Task.Yield();
        }

        ProjectileManager.Instance.EnterInGame();
        while(ProjectileManager.Instance.waitingForProjectiles) await Task.Yield();


        LocalPlayerManager.Instance.TeleportPlayer(LocalPlayerManager.Instance.currentWorld.worldCenterWorldSpace);

        ItemManager.Instance.CreateAndGiveLocalItem(ItemManager.Instance.NameToItemId("basichatchet"), 1, "");
        ItemManager.Instance.CreateAndGiveLocalItem(ItemManager.Instance.NameToItemId("scroll"), 1, "");
    }



    public void ExitGame()
    {
        NetworkManager.Singleton.Shutdown();

        RelayScript.Instance.RelaySignOut();


    }


}

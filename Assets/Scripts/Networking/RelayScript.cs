using System.Collections;
using System.Collections.Generic;
using Unity.Services.Core;
using Unity.Services.Authentication;
using Unity.Services.Relay;
using Unity.Services.Relay.Models;
using UnityEngine;
using Unity.Netcode;
using Unity.Netcode.Transports.UTP;
using System.Threading.Tasks;

public class RelayScript : MonoBehaviour
{
    #region Singleton
        public static RelayScript Instance { get; private set; }
        
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

    public string currentJoinCode;

    public async Task<bool> CreateRelay(){

        Console.Instance.ShowMessageInConsole("RelayScript.cs", "Creating relay...");

        await UnityServices.InitializeAsync();

        await AuthenticationService.Instance.SignInAnonymouslyAsync();

        try{
            Allocation allocation = await RelayService.Instance.CreateAllocationAsync(3);

            string joinCode = await RelayService.Instance.GetJoinCodeAsync(allocation.AllocationId);
            currentJoinCode = joinCode;

            Console.Instance.ShowMessageInConsole("RelayScript.cs", "The joining code for the created relay is: " + joinCode);

            NetworkManager.Singleton.GetComponent<UnityTransport>().SetHostRelayData(
                allocation.RelayServer.IpV4,
                (ushort)allocation.RelayServer.Port,
                allocation.AllocationIdBytes,
                allocation.Key,
                allocation.ConnectionData
            );

            if (!NetworkManager.Singleton.StartHost())
            {
                Console.Instance.ShowMessageInConsole("NetworkManager","Couldn't start host!");
            }
            
            return true;
        }
        catch(RelayServiceException e){
            Debug.Log(e);
            Console.Instance.ShowMessageInConsole("RelayScript.cs", e.Message);
            return true;
        }
        
    }

    public async Task<bool> JoinRelay(string joinCode){

        Console.Instance.ShowMessageInConsole("RelayScript.cs", "Joining relay with the joining code: " + joinCode);

        await UnityServices.InitializeAsync();

        await AuthenticationService.Instance.SignInAnonymouslyAsync();

        try{
            JoinAllocation joinAllocation = await RelayService.Instance.JoinAllocationAsync(joinCode);

            NetworkManager.Singleton.GetComponent<UnityTransport>().SetClientRelayData(
                joinAllocation.RelayServer.IpV4,
                (ushort)joinAllocation.RelayServer.Port,
                joinAllocation.AllocationIdBytes,
                joinAllocation.Key,
                joinAllocation.ConnectionData,
                joinAllocation.HostConnectionData

            );

            if (!NetworkManager.Singleton.StartClient())
            {
                Console.Instance.ShowMessageInConsole("NetworkManager", "Couldn't start client!");
                return false;
            }
            return true;
        }
        catch(RelayServiceException e){
            Debug.Log(e);
            Console.Instance.ShowMessageInConsole("RelayScript.cs", e.Message);
            return false;
        }

    }

    public void RelaySignOut()
    {
        currentJoinCode = "";
        Console.Instance.ShowMessageInConsole("RelayScript.cs", "Signing out from relay service...");
        AuthenticationService.Instance.SignOut();
    }

    public void GetJoiningCode()
    {
        if(currentJoinCode == "")
        {

            Console.Instance.ShowMessageInConsole("RelayScript.cs", "You are not currently hosting a game.");
            return;
        }

        Console.Instance.ShowMessageInConsole("RelayScript.cs", "The current joining code is: " + currentJoinCode);
    }
}

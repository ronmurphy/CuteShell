pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

pragma ComponentBehavior: Bound

Singleton {
    id: root
    readonly property list<var> networkTypes: ["wifi","ethernet"]
    readonly property list<var> statusIcons: [" "," "]
    readonly property list<string> wifiStrength: ["󰤟 ","󰤢 ","󰤥 ","󰤨 "]
    property bool isConnecting: connectProc.running
    property bool isSearching: getNetworks.running
    property bool wifiEnabled: true
    Component.onCompleted: {}
    property string statusConn:""

    property list<var> wifinetworks: []

    onWifiEnabledChanged: {
        root.wifinetworks = []
        const cmd = wifiEnabled ? "on" : "off";
        connectProc.exec(["nmcli", "radio", "wifi", cmd]);
    }

    function connectToNetwork(ssid: string, password: string,profExist: bool): void {
        if (!profExist) {
            connectProc.exec(["nmcli", "device", "wifi", "connect", ssid, "password", password]);
            return
        }
        connectProc.exec(["nmcli", "conn", "up", ssid]);
    }

    function deleteNetwork(ssid: string) {
        connectProc.exec(["nmcli", "connection", "delete", ssid]);
    }

    function disconnectFromNetwork(ssid: string): void {
        connectProc.exec(["nmcli", "connection", "down", ssid]);
    }

    Process {
        id: checkWifiEnabled
        command: [ "nmcli", "radio", "wifi"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                console.log(text)
                root.wifiEnabled = text.trim() === "enabled" ? true : false
            }
        }
    }
    Process {
        id: connectProc
        onExited: (exitCode,exitStatus) => {
            getNetworks.running = root.wifiEnabled ? true : false
        }
    }
    Process {
        property list<string> cmnd: ["nmcli","-t","-f","TYPE,STATE,CONNECTION","device"]
        id: checkConnections
        running: false
        command: cmnd
        stdout: StdioCollector {
            onStreamFinished: {
                root.statusConn = "󰈂 "
                let activeconn = {}
                let wifiSSID = null
                let wifiInUse = false
                
                text.split('\n').map(line => {
                    const net = line.split(':');
                    const cn = {
                        networkTypeIndex: root.networkTypes.indexOf(net[0]), //wifi
                        isConnected: net[1] === "connected",
                        connName: net[2]
                    };
                    if (cn.networkTypeIndex >= 0 && cn.isConnected) {
                        root.statusConn = root.statusIcons[cn.networkTypeIndex]
                        if (cn.networkTypeIndex === 0) wifiSSID = cn.connName
                        console.log(JSON.stringify(cn),"ADDED!!!")
                    }
                })

                for (const [i,network] of root.wifinetworks.entries()) {
                    if (network.ssid === wifiSSID) {
                        network.active = true
                        activeconn = network
                        wifiInUse = true
                        root.wifinetworks.splice(i,1)
                    }
                }
                if (wifiInUse) root.wifinetworks.unshift(activeconn)
            }
        }
    }
    Process {
        id: dbusNM
        running: true
        command: [ "dbus-monitor" , "--system", "type='signal',interface='org.freedesktop.NetworkManager',member='StateChanged'"]
        stdout: SplitParser {
            onRead: data => {
                checkConnections.exec(checkConnections.cmnd)
            }
        }
    }

    function getNetworks() {
        getNetworks.running = true
    }

    Process {
        id: getNetworks
        running: true
        command: ["sh","-c",`
            nmcli -t -f SSID,IN-USE,SIGNAL,SECURITY device wifi list \
            --rescan yes | while IFS=: read -r ssid inuse signal sec; do
                if nmcli -t -f NAME connection show | grep -Fxq "$ssid"; then
                    echo "$ssid:$inuse:$signal:$sec:true"
                else
                    echo "$ssid:$inuse:$signal:$sec:false"
                fi
            done
        `]
        environment: ({
            LANG: "C.UTF-8",
            LC_ALL: "C.UTF-8"
        })
        stdout: StdioCollector {
            onStreamFinished: {
                console.log(text.trim(),"NM IS GARBAGE")
                if (text.trim() === "" && root.wifiEnabled) {
                    getNetworks.running = true
                    return
                }
                root.wifinetworks = []
                let activeconn = {}
                let inUseExist = false
                text.split('\n').map(line => {
                    const net = line.split(':');
                    if (net[0] === "") {
                        return
                    }
                    const cn = {
                        ssid: net[0],
                        active: net[1] === "*",
                        signal: root.wifiStrength[Math.ceil((net[2]/100)*4)-1],
                        security: net[3],
                        profileExist: net[4] === "true",
                    };

                    if (net[1] === "*") {
                        console.log(net[1],"NM IS LITERALLY HOT GARBAGE")
                        activeconn = cn
                        inUseExist = true
                        return
                    }
                    root.wifinetworks.push(cn)
                })
                console.log(JSON.stringify(root.wifinetworks),"NM IS GARBAGE2")
                if (inUseExist) root.wifinetworks.unshift(activeconn)
            }
        }
    }
}

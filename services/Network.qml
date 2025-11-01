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
    property string wifiSSIDInUse: ""
    property bool wifiEnabled: true
    property string statusConn:""

    onWifiSSIDInUseChanged:{
        for (const [i,network] of root.wifinetworks.entries()) {
            root.wifinetworks[i].active = false
            if (network.ssid === wifiSSIDInUse) root.wifinetworks[i].active = true
        }
        wifinetworks.sort((a,b) => { 
            const active = b.active - a.active;
            const saved = b.profileExist - a.profileExist;
            const signal = b.signal - a.signal;
            return active || saved || signal;
        });
    }

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
                root.wifiSSIDInUse = ""
                text.split('\n').map(line => {
                    const net = line.split(':');
                    const cn = {
                        networkTypeIndex: root.networkTypes.indexOf(net[0]),
                        isConnected: net[1] === "connected",
                        connName: net[2]
                    };
                    if (cn.networkTypeIndex >= 0 && cn.isConnected) {
                        root.statusConn = root.statusIcons[cn.networkTypeIndex]
                        if (cn.networkTypeIndex === 0) { // if network is wifi
                            root.wifiSSIDInUse = cn.connName
                            root.wifiSSIDInUseChanged()
                        }
                    }
                })
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
                root.wifinetworks = []
                if (text.trim() === "" && root.wifiEnabled) {
                    getNetworks.running = true
                    return
                }
                text.split('\n').map(line => {
                    const net = line.split(':');
                    if (net[0] === "") return
                    const cn = {
                        ssid: net[0],
                        active: net[1] === "*",
                        signal: Number(net[2]),
                        security: net[3],
                        profileExist: net[4] === "true",
                    };
                    console.log(JSON.stringify(cn))
                    if (net[1] === "*") root.wifiSSIDInUse = net[0]
                    root.wifinetworks.push(cn)
                })
                root.wifiSSIDInUseChanged()
            }
        }
    }
}

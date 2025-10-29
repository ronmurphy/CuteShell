pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    readonly property list<var> networkTypes: [["wifi"," "], ["ethernet"," "]]
    readonly property list<string> wifiStrength: ["󰤟 ","󰤢 ","󰤥 ","󰤨 "]
    property bool isConnecting: connectProc.running
    property bool isSearching: getNetworks.running
    property list<string> statusConn: []

    property int activeWifiConn: -1 //index in wifinetworks 
    property bool wifiEnabled: true
    property list<var> wifinetworks: []

    function toggleWifi(): void {
        const cmd = wifiEnabled ? "off" : "on";
        enableWifiProc.exec(["nmcli", "radio", "wifi", cmd]);
    }

    function connectToNetwork(ssid: string, password: string,profExist: bool): void {
        console.log(ssid,password,profExist)
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
        id: connectProc
        onExited: (exitCode,exitStatus) => {
            getNetworks.running = true
        }
    }
    Process {
        property list<string> cmnd: ["nmcli","-t","-f","TYPE,STATE,CONNECTION","device"]
        id: checkConnections
        running: false
        command: cmnd
        stdout: StdioCollector {
            onStreamFinished: {
                const data = root.splitterse(text)
                root.statusConn = ["󰈂 ","No conn."]
                outer: for (const col of data) {
                    for (const type of root.networkTypes) {
                        if (col[0] === type[0] && col[1] === "connected") {
                            root.statusConn = [type[1],col[2]]
                            break outer
                        }
                    }
                }
                for (const [i,network] of root.wifinetworks.entries()) {
                    if (network.ssid === root.statusConn[1] && " " === root.statusConn[0]) {
                        root.activeWifiConn = i
                    }
                }
            }
        }
    }
    Process {
        id: dbusNM
        running: true
        command: [ "dbus-monitor" , "--system", "type='signal',interface='org.freedesktop.NetworkManager',member='StateChanged'"]
        stdout: SplitParser {
            onRead: data => {
                root.activeWifiConn = -1
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
            nmcli -t -f SSID,ACTIVE,SIGNAL,SECURITY device wifi list \
            --rescan yes | while IFS=: read -r ssid active signal sec; do
                if nmcli -t -f NAME connection show | grep -Fxq "$ssid"; then
                    echo "$ssid:$active:$signal:$sec:true"
                else
                    echo "$ssid:$active:$signal:$sec:false"
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
                const data = root.splitterse(text)
                var activeconn = {}
                data.forEach((net,i) => {
                    if (net[0].length > 0) {
                        const cn = {
                            ssid: net[0],
                            active: net[1] === "yes",
                            signal: root.wifiStrength[Math.ceil((net[2]/100)*4)-1],
                            security: net[3] ,
                            profileExist: net[4] === "true",
                        }
                        if (net[1] === "yes") {
                            activeconn = cn
                            root.activeWifiConn = 0
                            return
                        }
                        root.wifinetworks.push(cn)
                    }
                })
                root.wifinetworks.unshift(activeconn)
            }
        }
    }
    function splitterse(text) {
        const res = text.trim().split("\n").map(t => {
            return t.replace(new RegExp("\\\\:", "g"), "").split(":")
        })
        return res
    }
}

import Foundation
import SystemConfiguration.CaptiveNetwork

@objc(WifiInfo) public class WifiInfo : CDVPlugin  {

    override public func pluginInitialize() {
    }

    override public func onAppTerminate() {
    }

    @objc(getHostname:) public func getHostname(_ command: CDVInvokedUrlCommand) {

        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        
        // let hostname = Hostname.get() as String
        let hostname = ssid

        #if DEBUG
            print("WifiInfo: hostname \(hostname)")
        #endif

        let pluginResult = CDVPluginResult(status:CDVCommandStatus_OK, messageAs: hostname)
        self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(getInfo:) public func getInfo(_ command: CDVInvokedUrlCommand) {

        #if DEBUG
            print("WifiInfo: getInfo")
        #endif

        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        
        // let hostname = Hostname.get() as String
        let hostname = ssid
        let message: NSDictionary = NSDictionary(
            objects: [hostname, false, false, false],
            forKeys: ["hostname" as NSCopying, "connection" as NSCopying, "interfaces" as NSCopying, "dhcp" as NSCopying]
        )

        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: message as! [AnyHashable: Any])
        self.commandDelegate?.send(pluginResult, callbackId: command.callbackId)
    }

}

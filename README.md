# swift-json-based-net
Swift version of JSON-based Net

1. Pod install the Podfile included in the project
2. Open Info.plist as Source Code and append this at the end:

<key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <key>NSExceptionDomains</key>
    <dict>
    <key>yourdomain.com</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
    </dict>
</dict>
</dict>
</plist>
' *************************************************************
' ** Stremio Roku App - Main Entry Point
' ** This file initializes the Stremio app and launches the web interface
' *************************************************************

sub Main()
    ' Initialize the app
    print "Starting Stremio Roku App..."
    
    ' Create the main scene
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    
    ' Create the Scene Graph scene
    scene = screen.CreateScene("MainScene")
    screen.show()
    
    ' Store references for app lifecycle
    m.screen = screen
    m.scene = scene
    
    ' Handle app events
    HandleAppEvents()
end sub

' *************************************************************
' ** Handle application events and lifecycle
' *************************************************************
sub HandleAppEvents()
    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed()
                print "Screen closed, exiting app"
                return
            end if
        end if
    end while
end sub

' *************************************************************
' ** Scene Graph Main Scene Component
' *************************************************************
sub init()
    print "Initializing MainScene"
    
    ' Set up the scene
    m.top.backgroundcolor = "0x000000"
    
    ' Create and configure the web browser
    CreateWebBrowser()
    
    ' Set focus to enable key handling
    m.top.setFocus(true)
end sub

' *************************************************************
' ** Create and configure the web browser component
' *************************************************************
sub CreateWebBrowser()
    ' Create a Group to hold our web content
    m.webGroup = CreateObject("roSGNode", "Group")
    m.top.appendChild(m.webGroup)
    
    ' For Roku devices that support web browsing, we'll use roUrlTransfer
    ' to attempt to launch the web interface
    LaunchStremioWeb()
    
    ' Create a fallback UI with instructions
    CreateFallbackUI()
end sub

' *************************************************************
' ** Launch Stremio web interface
' *************************************************************
sub LaunchStremioWeb()
    print "Attempting to launch Stremio web interface..."
    
    ' Create URL transfer object
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl("https://web.stremio.com")
    urlTransfer.SetRequest("GET")
    
    ' Set up port for async operations
    port = CreateObject("roMessagePort")
    urlTransfer.SetPort(port)
    
    ' Attempt to connect to Stremio web
    if urlTransfer.AsyncGetToString()
        print "Successfully initiated connection to Stremio web"
        
        ' Monitor the connection
        msg = wait(5000, port) ' Wait up to 5 seconds
        if msg <> invalid
            msgType = type(msg)
            if msgType = "roUrlEvent"
                responseCode = msg.GetResponseCode()
                if responseCode = 200
                    print "Stremio web is accessible"
                    ShowWebInterface()
                else
                    print "Stremio web returned response code: "; responseCode
                    ShowConnectionError()
                end if
            end if
        else
            print "Timeout connecting to Stremio web"
            ShowConnectionError()
        end if
    else
        print "Failed to initiate connection to Stremio web"
        ShowConnectionError()
    end if
end sub

' *************************************************************
' ** Show web interface (for devices that support it)
' *************************************************************
sub ShowWebInterface()
    print "Displaying Stremio web interface"
    
    ' Create a label to show that we're launching the web interface
    webLabel = CreateObject("roSGNode", "Label")
    webLabel.text = "Loading Stremio Web Interface..."
    webLabel.font.size = 48
    webLabel.color = "0xFFFFFF"
    webLabel.translation = [100, 100]
    m.webGroup.appendChild(webLabel)
    
    ' In a real implementation, you would use a WebView component
    ' or similar web browsing capability if available on the device
    ' For now, we'll show instructions to access via another device
    
    timer = CreateObject("roSGNode", "Timer")
    timer.duration = 3
    timer.repeat = false
    timer.observeField("fire", "ShowWebInstructions")
    timer.control = "start"
    m.timer = timer
end sub

' *************************************************************
' ** Show web instructions after timer
' *************************************************************
sub ShowWebInstructions()
    ' Remove loading message
    m.webGroup.removeChildIndex(0)
    
    ' Show instructions
    CreateInstructionUI()
end sub

' *************************************************************
' ** Create fallback UI when web browser is not available
' *************************************************************
sub CreateFallbackUI()
    ' This will be shown if web access fails
end sub

' *************************************************************
' ** Show connection error
' *************************************************************
sub ShowConnectionError()
    print "Showing connection error UI"
    
    ' Clear any existing content
    m.webGroup.removeChildren(m.webGroup.getChildren(-1, 0))
    
    ' Create error message
    errorLabel = CreateObject("roSGNode", "Label")
    errorLabel.text = "Unable to connect to Stremio Web"
    errorLabel.font.size = 48
    errorLabel.color = "0xFF0000"
    errorLabel.translation = [100, 100]
    m.webGroup.appendChild(errorLabel)
    
    ' Show alternative instructions
    CreateInstructionUI()
end sub

' *************************************************************
' ** Create instruction UI for accessing Stremio
' *************************************************************
sub CreateInstructionUI()
    ' Title
    titleLabel = CreateObject("roSGNode", "Label")
    titleLabel.text = "Stremio for Roku"
    titleLabel.font.size = 72
    titleLabel.color = "0xFFFFFF"
    titleLabel.translation = [100, 200]
    m.webGroup.appendChild(titleLabel)
    
    ' Instructions
    instructionLines = [
        "To use Stremio on your Roku:",
        "",
        "1. Open your mobile device or computer",
        "2. Go to https://web.stremio.com",
        "3. Sign in to your Stremio account",
        "4. Use your mobile device to cast to this Roku",
        "",
        "Or use the Stremio mobile app and cast to this device"
    ]
    
    y = 350
    for each line in instructionLines
        if line <> ""
            lineLabel = CreateObject("roSGNode", "Label")
            lineLabel.text = line
            lineLabel.font.size = 36
            lineLabel.color = "0xCCCCCC"
            lineLabel.translation = [120, y]
            m.webGroup.appendChild(lineLabel)
        end if
        y = y + 50
    end for
    
    ' URL display
    urlLabel = CreateObject("roSGNode", "Label")
    urlLabel.text = "https://web.stremio.com"
    urlLabel.font.size = 42
    urlLabel.color = "0x00FF00"
    urlLabel.translation = [120, y + 50]
    m.webGroup.appendChild(urlLabel)
end sub

' *************************************************************
' ** Handle key events
' *************************************************************
function onKeyEvent(key as string, press as boolean) as boolean
    if press
        print "Key pressed: "; key
        
        if key = "back"
            ' Handle back button - could exit app or go back in web interface
            return true
        else if key = "OK"
            ' Handle OK button - could refresh or perform action
            return true
        end if
    end if
    
    return false
end function
# Stremio Roku App

A Roku channel that opens the Stremio web interface (https://web.stremio.com) directly on your Roku device.

## Prerequisites

- Roku device (Roku OS 7.0 or later)
- Computer with network access to your Roku
- Roku device and computer on the same network

## Setup Instructions

### Step 1: Enable Developer Mode on Roku

1. **Access the Secret Menu:**
   - On your Roku remote, press: **Home 3x, Up 2x, Right, Left, Right, Left, Right**
   - This opens the Developer Settings menu

2. **Enable Developer Mode:**
   - Select "Enable installer and restart"
   - Your Roku will reboot

3. **Set Developer Password:**
   - After reboot, go back to Developer Settings (same button sequence)
   - Select "Set a password for developer installer"
   - Enter a password (remember this!)

### Step 2: Find Your Roku's IP Address

**Method 1: Through Roku Settings**
1. Go to Settings → Network → About
2. Note the IP address

**Method 2: Through Router**
1. Check your router's admin panel for connected devices
2. Look for your Roku device

### Step 3: Prepare the App for Deployment

1. **Create a ZIP file** of the entire `stremio-roku` directory:
   ```bash
   cd stremio-roku
   zip -r ../stremio-roku.zip *
   ```

2. **Verify ZIP contents** should include:
   ```
   manifest
   source/main.brs
   components/WebBrowser.xml
   images/ (empty directory for now)
   ```

### Step 4: Sideload the App

1. **Access Developer Interface:**
   - Open a web browser on your computer
   - Navigate to: `http://[ROKU_IP_ADDRESS]`
   - Enter the developer password you set earlier

2. **Upload the App:**
   - Click "Browse" and select your `stremio-roku.zip` file
   - Click "Install"
   - Wait for installation to complete

3. **Launch the App:**
   - The app should appear on your Roku home screen as "Stremio Web"
   - Select it to launch

## Usage

Once installed and launched, the app will:
1. Display a loading screen
2. Attempt to connect to https://web.stremio.com
3. Show the Stremio web interface for browsing and streaming content

## Troubleshooting

### App Won't Install
- Verify ZIP file contains all required files
- Check that Roku developer mode is still enabled
- Ensure computer and Roku are on same network

### App Crashes or Won't Load
- Check Roku's system logs in the developer interface
- Verify network connectivity
- Try reinstalling the app

### Web Interface Doesn't Load
- Ensure Roku has internet connectivity
- Check if https://web.stremio.com is accessible from your network
- Some older Roku models may have limited web browsing capabilities

### Developer Mode Disabled
- Developer mode disables automatically after periods of inactivity
- Re-enable using the same button sequence: Home 3x, Up 2x, Right, Left, Right, Left, Right

## App Structure

```
stremio-roku/
├── manifest                    # App metadata and configuration
├── source/
│   └── main.brs               # Main BrightScript application logic
├── components/
│   └── WebBrowser.xml         # Scene Graph web browser component
└── images/                    # App icons (add your own icons here)
```

## Adding Custom Icons (Optional)

To customize the app appearance, add these image files to the `images/` directory:
- `icon_focus_hd.png` (336x210) - Focused menu icon
- `icon_side_hd.png` (108x69) - Side menu icon  
- `splash_hd.png` (1280x720) - Splash screen

Then recreate the ZIP file and reinstall.

## Development Notes

- This app uses Roku's Scene Graph framework
- Web browsing capabilities vary by Roku model
- For production deployment, consider Roku's official channel store process

## Legal Notice

This is an unofficial Roku app. Stremio is a trademark of Smart Code Ltd. This app simply provides access to the publicly available Stremio web interface.
#!/usr/bin/env bash
# KDE Plasma 6.4+ GIF Viewer Plasmoid Builder
# Corrected and improved version
# Version: 6.4.3

set -e

PLASMOID_ID="org.example.gifviewer"
BUILD_DIR="/tmp/plasmoid-build-$$"
PKG_DIR="$BUILD_DIR/$PLASMOID_ID"

echo "🔧 Creating plasmoid structure in temporary directory..."
mkdir -p "$PKG_DIR/contents/ui" "$PKG_DIR/contents/config"

########################################
# metadata.json (Plasma 6.4+ compatible)
########################################
cat > "$PKG_DIR/metadata.json" <<'EOF'
{
    "KPlugin": {
        "Authors": [
            {
                "Email": "none@example.org",
                "Name": "Example Developer"
            }
        ],
        "Category": "Graphics",
        "Description": "Displays an animated GIF with transparency and auto-resizing",
        "Icon": "image-x-generic",
        "Id": "org.example.gifviewer",
        "License": "GPL-3.0-or-later",
        "Name": "GIF Viewer",
        "Version": "1.0",
        "Website": "https://example.org"
    },
    "KPackage": {
        "Type": "Plasma/Applet"
    },
    "X-Plasma-API-Minimum-Version": "6.0"
}
EOF

########################################
# contents/config/main.xml
########################################
cat > "$PKG_DIR/contents/config/main.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<kcfg xmlns="http://www.kde.org/standards/kcfg/1.0"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.kde.org/standards/kcfg/1.0
      http://www.kde.org/standards/kcfg/1.0/kcfg.xsd">
  <kcfgfile name=""/>
  <group name="General">
    <entry name="gifPath" type="String">
      <default></default>
    </entry>
    <entry name="transparentBackground" type="Bool">
      <default>true</default>
    </entry>
    <entry name="autoResize" type="Bool">
      <default>true</default>
    </entry>
  </group>
</kcfg>
EOF

########################################
# contents/config/config.qml
########################################
cat > "$PKG_DIR/contents/config/config.qml" <<'EOF'
import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "preferences-desktop-theme"
        source: "configGeneral.qml"
    }
}
EOF

########################################
# contents/ui/configGeneral.qml
########################################
cat > "$PKG_DIR/contents/ui/configGeneral.qml" <<'EOF'
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
    property alias cfg_gifPath: gifPath.text
    property alias cfg_transparentBackground: transparentCheckBox.checked
    property alias cfg_autoResize: autoResizeCheckBox.checked

    Kirigami.FormLayout {
        RowLayout {
            Kirigami.FormData.label: i18n("GIF file:")

            TextField {
                id: gifPath
                Layout.fillWidth: true
                placeholderText: i18n("Select a GIF file...")
                readOnly: false
            }

            Button {
                icon.name: "document-open"
                text: i18n("Browse...")
                onClicked: fileDialog.open()
            }
        }

        CheckBox {
            id: transparentCheckBox
            text: i18n("Transparent background")
            Kirigami.FormData.label: i18n("Appearance:")
        }

        CheckBox {
            id: autoResizeCheckBox
            text: i18n("Auto-resize to fit widget")
        }

        Label {
            text: i18n("Tip: You can also drag and drop a GIF file directly onto the widget")
            opacity: 0.7
            font.italic: true
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }

    FileDialog {
        id: fileDialog
        title: i18n("Select GIF File")
        currentFolder: "file://" + (gifPath.text ? gifPath.text.substring(0, gifPath.text.lastIndexOf('/')) : "")
        nameFilters: [i18n("GIF Images (*.gif)"), i18n("All Files (*)")]
        fileMode: FileDialog.OpenFile

        onAccepted: {
            let path = selectedFile.toString()
            // Remove file:// prefix
            if (path.startsWith("file://")) {
                path = path.substring(7)
            }
            gifPath.text = path
        }
    }
}
EOF

########################################
# contents/ui/main.qml
########################################
cat > "$PKG_DIR/contents/ui/main.qml" <<'EOF'
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    property string gifPath: plasmoid.configuration.gifPath
    property bool transparentBackground: plasmoid.configuration.transparentBackground
    property bool autoResize: plasmoid.configuration.autoResize

    Plasmoid.backgroundHints: transparentBackground ?
        "NoBackground" :
        "DefaultBackground"

    compactRepresentation: Item {
        id: compact

        AnimatedImage {
            id: compactGif
            anchors.fill: parent
            anchors.margins: Kirigami.Units.smallSpacing
            source: root.gifPath
            fillMode: Image.PreserveAspectFit
            playing: true
            visible: root.gifPath !== ""
            cache: false
            smooth: true
            asynchronous: true

            MouseArea {
                anchors.fill: parent
                onClicked: root.expanded = !root.expanded
            }
        }

        Kirigami.Icon {
            anchors.centerIn: parent
            source: "image-x-generic"
            visible: root.gifPath === ""
            width: Math.min(parent.width, parent.height) * 0.7
            height: width

            MouseArea {
                anchors.fill: parent
                onClicked: root.expanded = !root.expanded
            }
        }
    }

    fullRepresentation: Item {
        id: fullRep
        Layout.minimumWidth: Kirigami.Units.gridUnit * 15
        Layout.minimumHeight: Kirigami.Units.gridUnit * 15
        Layout.preferredWidth: Kirigami.Units.gridUnit * 25
        Layout.preferredHeight: Kirigami.Units.gridUnit * 25

        AnimatedImage {
            id: fullGif
            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing
            source: root.gifPath
            fillMode: root.autoResize ? Image.PreserveAspectFit : Image.Pad
            playing: true
            visible: root.gifPath !== ""
            cache: false
            smooth: true
            asynchronous: true

            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
        }

        Kirigami.PlaceholderMessage {
            anchors.centerIn: parent
            width: parent.width - (Kirigami.Units.largeSpacing * 4)
            visible: root.gifPath === ""
            text: i18n("No GIF selected")
            explanation: i18n("Right-click the widget and select 'Configure...' to set a GIF file path, or drag and drop a GIF file here")
            icon.name: "image-x-generic"
        }

        DropArea {
            anchors.fill: parent
            onDropped: function(drop) {
                if (drop.hasUrls && drop.urls.length > 0) {
                    let url = drop.urls[0].toString()
                    // Remove file:// prefix if present
                    if (url.startsWith("file://")) {
                        url = url.substring(7)
                    }
                    plasmoid.configuration.gifPath = url
                    drop.accept()
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: Kirigami.Theme.highlightColor
                border.width: 3
                radius: Kirigami.Units.cornerRadius
                visible: parent.containsDrag
                opacity: 0.5
            }
        }
    }
}
EOF

########################################
# Package + Install (Plasma 6.4 syntax)
########################################
echo "📦 Packaging plasmoid..."
cd "$BUILD_DIR"
ZIP_FILE="$BUILD_DIR/${PLASMOID_ID}.plasmoid"

# Remove old package if exists
rm -f "$ZIP_FILE"

# Create package
zip -qr "$ZIP_FILE" "$PLASMOID_ID"

echo "📦 Built: $ZIP_FILE"
echo "🚀 Installing..."

# Remove old version if exists (suppress error if not installed)
echo "🗑️  Removing old version if it exists..."
kpackagetool6 -t Plasma/Applet -r "$PLASMOID_ID" 2>/dev/null || echo "   (No previous version found)"

# Also remove any manually created directories
rm -rf "$HOME/.local/share/plasma/plasmoids/$PLASMOID_ID"

# Install new version
if kpackagetool6 -t Plasma/Applet -i "$ZIP_FILE"; then
    echo "✅ GIF Viewer plasmoid installed successfully!"
    echo ""
    echo "🔄 Restarting Plasma shell..."
    killall plasmashell 2>/dev/null || true
    sleep 2
    kstart plasmashell &>/dev/null &
    echo ""
    echo "✅ Complete! Add the widget via:"
    echo "   Right-click desktop → Add Widgets → GIF Viewer"
    echo ""
    echo "🧹 Cleaning up temporary files..."
    rm -rf "$BUILD_DIR"
else
    echo "❌ Installation failed!"
    echo "Package location: $ZIP_FILE"
    echo "Leaving temporary files for debugging."
    exit 1
fi

# 🖼️ GIF Viewer (Advanced) Plasmoid for KDE Plasma 6.4+

This script builds, packages, and installs a feature-rich KDE Plasma Applet (Plasmoid) designed for displaying animated GIFs on your desktop or panel.

It uses modern QtQuick/Kirigami components and is optimized for **KDE Plasma 6.4 and newer** versions.

https://www.youtube.com/watch?v=wJyodwWJND4
![GIF Viewer](https://github.com/alduccino/Gif-Viewer_Plasmoid_KDE6/blob/main/GIF.png)
![GIF Viewer Settings](https://github.com/alduccino/Gif-Viewer_Plasmoid_KDE6/blob/main/GIF-Settings.png)
---

## ✨ Advanced Features

* **Complete Customization:** Full-featured configuration dialog with a **native file picker** for setting the GIF path.
* **Drag & Drop Support:** Instantly update the displayed GIF by **dragging and dropping** a file onto the widget. Includes visual feedback during the drag operation.
* **Smart Background:** Automatically sets `Plasmoid.backgroundHints` based on the transparency setting for seamless desktop integration.
* **Dual Representation:** Implements both a **compactRepresentation** (for panels) and a **fullRepresentation** (for desktop) with distinct UI logic.
* **No GIF Placeholder:** Displays a helpful `Kirigami.PlaceholderMessage` in the expanded view when no GIF is loaded.
* **Robust Building:** Utilizes a secure, temporary build directory (`/tmp`) and includes checks for clean installation and successful Plasma shell restart.

---

## 🛠️ Installation

### Prerequisites

You need the following tools available on your system: **`bash`**, **`kpackagetool6`**, and **`zip`**.

### Installation Steps

1.  **Save the Script:** Save the provided code into a file (e.g., `create-gifviewer-plasmoid.sh`).
2.  **Make it Executable:**
    ```bash
    chmod +x create-gifviewer-plasmoid.sh
    ```
3.  **Execute the Script:**
    ```bash
    sh create-gifviewer-plasmoid.sh
    ```

> The script will automatically handle cleanup of previous versions, build the package, install it to `~/.local/share/plasma/plasmoids/`, and attempt to restart `plasmashell`.

---

## 💻 Usage

1.  **Add the Widget:** Right-click your desktop (or open the Widgets panel) and select **"Add Widgets..."**.
2.  Search for **"GIF Viewer"** and drag the widget onto your desktop or panel.

### Configuring the GIF

* **File Picker:** Right-click the widget, choose **"Configure GIF Viewer..."**, and use the **"Browse..."** button to select your GIF.
* **Drag & Drop:** Drag any GIF file from your file manager and drop it directly onto the widget area.

---

## 🗑️ Uninstalling

To manually remove the plasmoid:

```bash
kpackagetool6 -t Plasma/Applet -r org.example.gifviewer

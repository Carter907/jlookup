
# jlookup - Java SE Documentation Browser

`jlookup` is a command-line tool that uses `fzf` (a command-line fuzzy finder) to quickly browse Java SE standard library documentation directly from your terminal. It simplifies the process of finding and opening Oracle's official Java documentation for modules and packages.

## Features

* **Fuzzy Search:** Quickly find Java modules and packages using `fzf`.
* **Automatic Version Detection:** Detects your installed Java major version (9+) to link to the correct documentation.
* **Module & Package Views:** Choose to view either the module summary or drill down into exported packages.
* **Cross-Platform:** Works on Linux and macOS (requires standard command-line utilities).
* **Interactive Loop:** Optionally search for multiple modules/packages without restarting the script.
* **Browser Integration:** Opens the selected documentation page directly in your default web browser.

## Dependencies

* **Bash:** The script is written in Bash.
* **Java Development Kit (JDK):** Version 9 or later is required, as the script relies on the Java Module System (`java --list-modules`, `java --describe-module`). Ensure the `java` command is in your system's PATH.
* **fzf:** The command-line fuzzy finder.
    * Installation (Debian/Ubuntu): `sudo apt update && sudo apt install fzf`
    * Installation (macOS/Homebrew): `brew install fzf`
    * Installation (Other): See [fzf repository](https://github.com/junegunn/fzf#installation)
* **URL Opener:** A command to open URLs in your default browser. The script automatically tries `xdg-open` (common on Linux) or `open` (macOS). Ensure one of these is available and configured. (`xdg-utils` package on Linux often provides `xdg-open`).

## Installation

1.  **Download:** Make sure you have the `jlookup.sh` script saved locally.
2.  **Run Installer (Recommended):**
    * Download the `install.sh` script provided in this repository into the same directory as `jlookup.sh`.
    * Make the installer executable: `chmod +x install.sh`
    * Run the installer with sudo (needed for `/usr/local/bin`): `sudo ./install.sh`
    This will copy `jlookup.sh` to `/usr/local/bin/jlookup` and make it executable.
3.  **Manual Installation:**
    * Choose a directory in your `$PATH` (e.g., `~/.local/bin` or `/usr/local/bin`).
    * Copy the script: `cp jlookup.sh /usr/local/bin/jlookup` (use sudo if necessary for the target directory).
    * Make it executable: `chmod +x /usr/local/bin/jlookup`

## Usage

Once installed, simply run the command:

```bash
jlookup


You will be prompted by fzf to select a Java module. Type to filter the list and press Enter to select.
Next, you'll be asked whether to view [P]ackages or the [M]odule summary. Press 'P', 'M', or Enter (defaults to M).
If you chose 'P', you'll get another fzf prompt to select a package within that module.
The corresponding Oracle documentation page will be opened in your default web browser.
You will then be asked if you want to search again. Press Enter or 'y' to continue, or 'n' to exit.
You can cancel fzf prompts or the script itself using Ctrl+C.
Contributing
Contributions are welcome! If you have suggestions for improvements or find a bug, please feel free to:
Fork the repository.
Create a new branch for your feature or bug fix (git checkout -b feature/your-feature-name or git checkout -b fix/your-bug-fix).
Make your changes.
Commit your changes (git commit -am 'Add some feature').
Push to the branch (git push origin feature/your-feature-name).
Create a new Pull Request.
Please ensure your code adheres to basic shell scripting best practices and that any changes maintain the core functionality.
License
This project is licensed under the MIT License - see the LICENSE file for details (or specify license directly).
*(Note: You would typically include a LICENSE file in your repository containing the full text of the chosen license, like the MIT License.)

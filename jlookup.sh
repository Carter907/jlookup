#!/bin/bash

# Script to select a Java standard library module using fzf,
# view module/package documentation, and optionally repeat the process.

# --- Configuration ---
DOCS_BASE_URL="https://docs.oracle.com/en/java/javase/"

# --- Dependency Checks & URL Opener ---
# Check for required commands: java, fzf, and a URL opener (xdg-open or open)
command -v java >/dev/null || {
    printf "Error: 'java' command not found. Please ensure a JDK is installed and in your PATH.\n" >&2
    exit 1
}
command -v fzf >/dev/null || {
    printf "Error: 'fzf' command not found. Please install fzf (e.g., 'sudo apt install fzf' or 'brew install fzf').\n" >&2
    exit 1
}
OPEN_CMD=$(command -v xdg-open || command -v open)
[[ -z "$OPEN_CMD" ]] && {
    printf "Error: Could not find a command to open URLs (tried xdg-open, open).\n" >&2
    exit 1
}

# --- Get Java Version ---
# Extract major version (handles versions like 1.8, 9, 11, 17 etc.)
JAVA_MAJOR_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | awk -F. '{if ($1 == "1") print $2; else print $1}')

# Validate Java version (must be >= 9 for modules)
if ! [[ "$JAVA_MAJOR_VERSION" =~ ^[0-9]+$ ]] || [[ "$JAVA_MAJOR_VERSION" -lt 9 ]]; then
    printf "Error: Java version %s detected. This script requires Java 9 or later.\n" "$JAVA_MAJOR_VERSION" >&2
    exit 1
fi
echo "Detected Java major version: $JAVA_MAJOR_VERSION"

# --- Main Loop ---
while true; do
    # --- Get & Select Module ---
    echo "Fetching standard library modules..."
    # Get modules, remove version info (@...), sort, and let user select with fzf
    SELECTED_MODULE=$(java --list-modules 2>&1 | sed 's/@.*//' | sort | fzf --prompt="Select Java Module (Ctrl+C to exit)> " --height=40% --layout=reverse --header="Select Java Module")

    # Check if fzf was cancelled (empty selection or non-zero exit code)
    if [[ -z "$SELECTED_MODULE" ]]; then
        echo "No module selected or selection cancelled. Exiting."
        break # Exit the loop
    fi
    echo "Selected module: $SELECTED_MODULE"

    # --- Ask User Action ---
    read -p "View [P]ackages or [M]odule summary for '$SELECTED_MODULE'? [P/M] (Default: M): " -n 1 -r ACTION_CHOICE
    echo                              # New line
    ACTION_CHOICE=${ACTION_CHOICE^^}  # Uppercase
    ACTION_CHOICE=${ACTION_CHOICE:-M} # Default to M

    # --- Determine Documentation URL ---
    DOCS_URL=""
    if [[ "$ACTION_CHOICE" == "M" ]]; then
        echo "Action: View Module Summary"
        DOCS_URL="${DOCS_BASE_URL}${JAVA_MAJOR_VERSION}/docs/api/${SELECTED_MODULE}/module-summary.html"

    elif [[ "$ACTION_CHOICE" == "P" ]]; then
        echo "Action: Select Package"
        echo "Fetching exported packages for module '$SELECTED_MODULE'..."
        # Get exported packages, extract name, sort
        PACKAGE_LIST=$(java --describe-module "$SELECTED_MODULE" 2>/dev/null | awk '/^exports / {print $2}' | sort)

        if [[ -z "$PACKAGE_LIST" ]]; then
            echo "No exported packages found for module '$SELECTED_MODULE'. Opening module summary instead."
            DOCS_URL="${DOCS_BASE_URL}${JAVA_MAJOR_VERSION}/docs/api/${SELECTED_MODULE}/module-summary.html"
        else
            # Let user select package with fzf
            SELECTED_PACKAGE=$(echo "$PACKAGE_LIST" | fzf --prompt="Select Package in $SELECTED_MODULE (Ctrl+C to exit)> " --height=40% --layout=reverse --header="Select Package in $SELECTED_MODULE")

            if [[ -z "$SELECTED_PACKAGE" ]]; then
                echo "No package selected or selection cancelled. Exiting."
                break # Exit the loop
            fi
            echo "Selected package: $SELECTED_PACKAGE"
            # Construct package URL (replace . with /)
            PACKAGE_PATH=${SELECTED_PACKAGE//\./\/} # Use bash string replacement
            DOCS_URL="${DOCS_BASE_URL}${JAVA_MAJOR_VERSION}/docs/api/${SELECTED_MODULE}/${PACKAGE_PATH}/package-summary.html"
        fi
    else
        printf "Invalid choice '%s'. Please enter 'P' or 'M'.\n" "$ACTION_CHOICE" >&2
        # Ask to continue or exit after invalid choice
        read -p "Continue searching? [Y/n]: " -n 1 -r CONTINUE_CHOICE
        echo
        if [[ ${CONTINUE_CHOICE,,} == "n" ]]; then # Convert to lowercase for comparison
            break                                  # Exit the loop
        fi
        continue # Skip URL opening and restart loop
    fi

    # --- Open the Determined URL ---
    if [[ -n "$DOCS_URL" ]]; then
        echo "Opening documentation at: $DOCS_URL"
        "$OPEN_CMD" "$DOCS_URL" || {
            printf "Error: Failed to open URL '%s' with '%s'.\n" "$DOCS_URL" "$OPEN_CMD" >&2
            # Ask to continue or exit even if opening failed
        }
    else
        # Should not happen with current logic, but safeguard
        echo "Error: Could not determine URL to open." >&2
    fi

    # --- Ask to Continue ---
    read -p "Search again? [Y/n]: " -n 1 -r CONTINUE_CHOICE
    echo                                       # New line
    if [[ ${CONTINUE_CHOICE,,} == "n" ]]; then # Convert to lowercase for comparison
        break                                  # Exit the while loop
    fi
    echo # Add an extra newline for better separation before the next iteration

done # End of while loop

echo "Done."
exit 0

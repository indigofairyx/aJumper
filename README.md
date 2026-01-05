# aJumper
Another AHK v1 spinoff of TillaGoTo with a handful of usability enhancements.

<img width="1426" height="648" alt="image" src="https://github.com/user-attachments/assets/6fe56cce-5ae7-4b79-a64a-d491873973b2" />

>[!NOTE]
> This GoTo Spin off is in early Development and was largely written to work with [Notepad++](https://notepad-plus-plus.org). There *are some bugs*, nothing major, most of the time I'm loving it! Reporting bugs via issues could be helpful and appreciated. 

# Usage
Download and Extract the zip from [Releases](https://github.com/indigofairyx/aJumper/releases). There's an `aJump.exe` for ease and `aJump.ahk` for AHK users whom want to tinker with the source script.


>[!IMPORTANT]
> When first launching be sure to edit the `aJump.ini`. Set you default **TextEditor=** and the paths of other other AHK editors you're using under the `[Programs]` section.
> There are also more comments and notes inside the INI itself.

### Supported Editors (so far)
- Notepad++ ( default )
- SciTE 4 AutoHotkey
- Notepad4
- Sublime Text
- Geany
- AHK-Studio (limited buggy, not fully tested)
  

and LIMITED Support with..

- VS Code
- VS Codium
  

these two can open to a line. but cannot follow the active Document from the editor.

# More of a README coming soon, for now a bullet list of quick features

- Hotkeys when an TE (Text Editor) is active
-   `F7`, Reads the Current Doc in A_single file view mode
-   `F10`, Activates A_Jumper in A_Full file list mode, reading the content of a user supplied list of `.ahk` files
- Save a list of `.ahk` as a project and search only inside of the list in A_full mode
- drag n drop an `.ahk` file onto the gui to search it.
- The Context Menu is Dynamic to the view mode and active path you've clicked on. You can...
-   Copy individual elements from the list view
-   Open the file folder
-   Switch Modes, in full you switch\read from single file
-   Toggle viewing inline comments from returned items
-   Toggle fuzzy\non-fuzzy filter in the search box
-   and MORE !

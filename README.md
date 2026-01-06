# aJumper
An AHK v1 spinoff of TillaGoTo with a handful of customizable usability enhancements. Search your `.ahk` script files for Labels, Functions, Hotkeys, Hotstrings, and Includes then, Double-Click or {Enter} to jump\open to that line in your assigned Text Editor.

<img width="1426" height="648" alt="image" src="https://github.com/user-attachments/assets/6fe56cce-5ae7-4b79-a64a-d491873973b2" />


>[!NOTE]
> This GoTo Spin off is in early Development and was largely written to work with [Notepad++](https://notepad-plus-plus.org). There *are some bugs*, nothing major, most of the time I'm loving it! Reporting bugs via issues could be helpful and appreciated. 

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

These two can open to a line. but cannot follow the active Document from the editor.

***

# Usage

## Filter by Type with search prefixes...
```
>	Labels
()	Functions
::	Hotkeys
$ 	Hotstrings
# 	Includes
```
## Hotkeys
| HOTKEY                  | ACTION                                                       |
| :----------------------------------: | ------------------------------ |
|                      | **Hotkeys in A_Jumper**                                    |
| `$F10`               | Set view mode to A_full, (HOLD) for 1 Sec to Re-Build the FullListView, (Double-Tap) to edit `aJumpScriptList.txt` |
| `F7`                 | Sent view move to single. if single mode is active > refresh active file |
| `F8`                 | Toggle View Mode A_single<>A_full                            |
| `Ctrl` + `G`         | Go To \ Open to the line of selected list view item in your TE |
| `Enter`              | Go To \ Open to the line of selected list view item in your TE |
| `Ctrl` + `C`         | Copy Details of the selected list view item                  |
| `Ctrl` + `D`         | Open the directory of the selected list view script.  |
| `Ctrl` + `Shift` + ` D` | Open A_Jumper's directory |
| `Alt` + `U`          | Toggle Debug info showing on GUI                            |
| `Alt` + `F4`         | Exit\Quit A_Jumper                                       |
| `Ctrl` + `F`         | Focus search box                                   |
| `Alt` +  `C` | Clear the search box |
| `Ctrl` + `F5`        | Reload A_Jumper                                              |
| `F5`                 | Refresh current active file                                  |
| `F11`                | Edit Settings. Run, `.\aJump.ini`                            |
| `Ctrl` + `F11`       | Edit INI file alt                                            |
|                      |                                                              |
|                      | **Semi-Global Hotkeys to Activate A_Jumper when a text editor is active** |
| `F7`                 | (G) Activate A_Jumper, Set view mode to Single, Refresh TE Active File |
| `F10`                | (G) Activate A_Jumper, set view mode to full                 |
| `Ctrl` + `Alt` + `J` | (G) send selected text from TE to A_Jumper                   |

## Slash Commands
Type a `/` >> `/tip` WithNoSpace! in the search and hit enter too...
```
/edit     		 Edit Source Script
/editlist      Edit Script List
/exit     		 Exit app
/full     		 Set ViewMode to Full List.
/hide     		 Hide GUI
/load     		 {Space} C:\Paste\a\FilePath.ahk
/menu     		 Show Context Menu
/quit     		 Exit app
/refresh  		 Rebuild list
/reload   		 Reload App
/settings 		 Edit INI Options
/single   		 Set View Mode to Single File
/switch   		 Run\Switch Between .ahk <> .exe
/tip      		 Show This Tip Again
/tray      		 Show Tray Menu
/compile   	   Re-Compile Source Script
/bug     		   Debug on GUI
/ini     		   Edit INI in a Text Editor
```



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

;NSIS Modern Style UI
;Example Script version 1.11
;Written by Joost Verburg

!define NAME "Doris Data ALPHA" ;Define your own software name here
!define VERSION "1.2" ;Define your own software version here

!verbose 3
!include "${NSISDIR}\Examples\WinMessages.nsh"
!include "ModernUI.nsh"
!verbose 4

!define CURRENTPAGE $9

!define TEMP1 $R0
!define TEMP2 $R1

;--------------------------------

  ;General
  Name "${NAME} ${VERSION}"
  OutFile "Doris-Setup.exe"
  SetOverwrite on

  ;User interface
  !insertmacro MUI_INTERFACE "modern.exe" "adni18-installer-C-no48xp.ico" "adni18-uninstall-C-no48xp.ico" "modern.bmp" "smooth"

  ;License dialog
  LicenseText "Scroll down to see the rest of the agreement."
  LicenseData "../License.txt"

  ;Component-select dialog
  ComponentText "Check the components you want to install and uncheck the components you don't want to install. Click Next to continue."

  ;Folder-select dialog
  InstallDir "$PROGRAMFILES\${NAME}"
  DirText "Setup will install ${NAME} in the following folder.$\r$\n$\r$\nTo install in this folder, click Install. To install in a different folder, click Browse and select another folder." " "

  ;Uninstaller
  UninstallText "This will uninstall ${NAME} from your system."

;--------------------------------
;Installer Sections

Section "Doris Data Software" SecCopyUI

  ;Add your stuff here

  SetOutPath "$INSTDIR"
  File "..\doris.exe"
  File "..\doris-rsync.exe"
  File "..\doris-ssh.exe"
  File "..\cygwin1.dll"
  File "..\cygz.dll"
  File "..\cygcrypto.dll"
  File "..\license.txt"

SectionEnd

; optional section
Section "Start Menu Shortcuts" SecStartMenu
  CreateDirectory "$SMPROGRAMS\${NAME}"
  CreateShortCut "$SMPROGRAMS\${NAME}\${NAME} Client.lnk" "$INSTDIR\Doris.exe" "" "$INSTDIR\Doris.exe" 0
  CreateShortCut "$SMPROGRAMS\${NAME}\Software License.lnk" "$INSTDIR\license.txt" "" "$INSTDIR\license.txt" 0
  CreateShortCut "$SMPROGRAMS\${NAME}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
SectionEnd

Section "Create uninstaller" SecCreateUninst

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "DisplayName" "${NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'

  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

Section ""

  ;Invisible section to display the Finish header
  !insertmacro MUI_FINISHHEADER SetHeader
  
SectionEnd

;--------------------------------
;Installer Functions

Function .onInitDialog

  !insertmacro MUI_INNERDIALOG_INIT

    !insertmacro MUI_INNERDIALOG_START 1
      !insertmacro MUI_INNERDIALOG_TEXT 1033 1040 "If you accept all the terms of the agreement, choose I Agree to continue. If you choose Cancel, Setup will close. You must accept the agreement to install ${NAME}."
    !insertmacro MUI_INNERDIALOG_STOP 1

    !insertmacro MUI_INNERDIALOG_START 2
      !insertmacro MUI_INNERDIALOG_TEXT 1033 1042 "Description"
      !insertmacro MUI_INNERDIALOG_TEXT 1033 1043 "Hover your mouse over a component to see it's description."
    !insertmacro MUI_INNERDIALOG_STOP 2

    !insertmacro MUI_INNERDIALOG_START 3
      !insertmacro MUI_INNERDIALOG_TEXT 1033 1041 "Destination Folder"
      !insertmacro MUI_INNERDIALOG_STOP 3

  !insertmacro MUI_INNERDIALOG_END

FunctionEnd

Function .onNextPage

  !insertmacro MUI_NEXTPAGE_OUTER
  !insertmacro MUI_NEXTPAGE SetHeader
  
FunctionEnd

Function .onPrevPage

  !insertmacro MUI_PREVPAGE

FunctionEnd

Function SetHeader

  !insertmacro MUI_HEADER_INIT

    !insertmacro MUI_HEADER_START 1
       !insertmacro MUI_HEADER_TEXT 1033 "License Agreement" "Please review the license terms before installing ${NAME}."
    !insertmacro MUI_HEADER_STOP 1

    !insertmacro MUI_HEADER_START 2
      !insertmacro MUI_HEADER_TEXT 1033 "Choose Components" "Choose the components you want to install."
    !insertmacro MUI_HEADER_STOP 2

    !insertmacro MUI_HEADER_START 3
      !insertmacro MUI_HEADER_TEXT 1033 "Choose Install Location" "Choose the folder in which to install ${NAME} in."
    !insertmacro MUI_HEADER_STOP 3

    !insertmacro MUI_HEADER_START 4
      !insertmacro MUI_HEADER_TEXT 1033 "Installing" "Please wait while ${NAME} is being installed."
    !insertmacro MUI_HEADER_STOP 4

    !insertmacro MUI_HEADER_START 5
      !insertmacro MUI_HEADER_TEXT 1033 "Finished" "Setup was completed successfully."
    !insertmacro MUI_HEADER_STOP 5

  !insertmacro MUI_HEADER_END

FunctionEnd

Function .onMouseOverSection

  !insertmacro MUI_DESCRIPTION_INIT

    !insertmacro MUI_DESCRIPTION_TEXT 1033 ${SecCopyUI} "Install ${NAME}..."
    !insertmacro MUI_DESCRIPTION_TEXT 1033 ${SecStartMenu} "Create Start Menu shortcuts for ${NAME}..."
    !insertmacro MUI_DESCRIPTION_TEXT 1033 ${SecCreateUninst} "Create a uninstaller which can automatically delete ${NAME}."
 
 !insertmacro MUI_DESCRIPTION_END

FunctionEnd

Function .onUserAbort

  !insertmacro MUI_ABORTWARNING 1033 "Are you sure you want to quit ${NAME} Setup?"
  !insertmacro MUI_ABORTWARNING_END
  
FunctionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ; remove registry keys
  DeleteRegKey HKCU "Software\Doris"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}"
  DeleteRegValue HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "DorisData"

	; Remove shortcuts
  Delete "$SMPROGRAMS\${NAME}\*.*"
  RMDir "$SMPROGRAMS\${NAME}"

	; Remove Program files
  Delete "$INSTDIR\*.*"
  RMDir "$INSTDIR"

  !insertmacro MUI_FINISHHEADER un.SetHeader
 
SectionEnd

;--------------------------------
;Uninstaller Functions

Function un.onNextPage

  !insertmacro MUI_NEXTPAGE_OUTER
  !insertmacro MUI_NEXTPAGE un.SetHeader
  
FunctionEnd

Function un.SetHeader

  !insertmacro MUI_HEADER_INIT

    !insertmacro MUI_HEADER_START 1
      !insertmacro MUI_HEADER_TEXT 1033 "Uninstall ${NAME}" "Remove ${NAME} from your system."
    !insertmacro MUI_HEADER_STOP 1

    !insertmacro MUI_HEADER_START 2
      !insertmacro MUI_HEADER_TEXT 1033 "Uninstalling" "Please wait while ${NAME} is being uninstalled."
    !insertmacro MUI_HEADER_STOP 2

    !insertmacro MUI_HEADER_START 3
      !insertmacro MUI_HEADER_TEXT 1033 "Finished" "${NAME} has been removed from your system."
    !insertmacro MUI_HEADER_STOP 3

  !insertmacro MUI_HEADER_END

FunctionEnd

;eof
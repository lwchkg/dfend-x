!macro VersionData
!define VER_MAYOR 1
!define VER_MINOR1 4
!define VER_MINOR2 4
!macroend

!macro BetaWarning

!define BETA_NUMBER 1
!define RC_NUMBER 1

;MessageBox MB_OK "This is beta version ${BETA_NUMBER} of D-Fend Reloaded ${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}! The final version of D-Fend Reloaded ${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2} has not yet been released. This version is for testing only."
;MessageBox MB_OK "This is not D-Fend Reloaded ${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}! This is the release candiate ${RC_NUMBER} of version ${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2}! This means this version is very close to the final release ${VER_MAYOR}.${VER_MINOR1}.${VER_MINOR2} but there might be some unfixed bugs etc. Please do not use this version unless you want to do beta testing. The final release will be released very soon."
!macroend
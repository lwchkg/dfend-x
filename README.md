# dfend-x

**This maintenance build is still WIP. Do not download until this notice is removed.**

Dfend-X is a maintenance build of
[D-Fend Reloaded](http://dfendreloaded.sourceforge.net/) that can run
[DOSBox-X](https://github.com/joncampbell123/dosbox-x).

I have started this build because there was no updated since the last version
of D-Fend Reloaded (i.e. Jul 30, 2015), and some problems with D-Fend Reloaded
settings makes it almost impossible to run DOSBox-X.

## To-Dos

* Make it compile with Delphi 10.2 (or Lazarus, if it is possible)
* Add "no setting" and "windows" to the list of video drivers.
* Unicode text handling (if possible - I'm not sure yet).
* Bug fixes and simple changes to the code
* Fix vulnerabilities (e.g. usage of ZLib 1.1.4).

## Non-goals

* 64-bit build (I have access to Delphi Starter Edition only. So only 32-bit
  Windows builds.)
* Cross platform build (same reason)
* Add CI (there's no free online solutions available)
* Add new features (without CI, there's no good way to test for breakage)

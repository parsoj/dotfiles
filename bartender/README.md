# Bartender settings

Snapshot of the `com.surteesstudios.Bartender` defaults domain (Bartender 6).
No license info — that lives in the keychain / RevenueCat plist.

Export (refresh this snapshot):

```sh
defaults export com.surteesstudios.Bartender - | plutil -convert xml1 - -o ~/.config/bartender/com.surteesstudios.Bartender.plist
```

Restore on a new machine (quit Bartender first):

```sh
defaults import com.surteesstudios.Bartender ~/.config/bartender/com.surteesstudios.Bartender.plist
open -a "Bartender 6"
```

Caveat: menu bar item positions reference app bundle IDs and screen layout;
most settings port cleanly but item ordering may need a touch-up on a
machine with different apps/displays.

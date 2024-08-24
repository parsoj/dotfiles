

install-requirements: 
	brew install cormacrelf/tap/dark-notify

build: 
	go build switch-theme.go

launchctl: 
	rm  /Users/jeff/Library/LaunchAgents/com.jeff.darknotify.plist
	ln -s /Users/jeff/.config/dark-mode-switcher/com.jeff.darknotify.plist /Users/jeff/Library/LaunchAgents/com.jeff.darknotify.plist
	launchctl unload ~/Library/LaunchAgents/com.jeff.darknotify.plist
	launchctl load ~/Library/LaunchAgents/com.jeff.darknotify.plist



all: install-requirements build launchctl

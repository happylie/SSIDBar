package main

import (
	"log"
	"os/exec"
	"strings"

	"github.com/getlantern/systray"
)

func main() {
	systray.Run(onReady, onExit)
}

func onReady() {
	go func() {
		var result string
		for {
			result = GetSSIDName()
			systray.SetTitle(result)
		}
	}()
	systray.AddSeparator()
	mQuit := systray.AddMenuItem("Quit", "")
	go func() {
		for range mQuit.ClickedCh {
			systray.Quit()
			return
		}
	}()
}

func onExit() {

}

func GetSSIDName() string {
	cmd := "/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | egrep 'SSID' | egrep -v 'BSSID' | awk -F ':' '{print $2}'"
	out, err := exec.Command("bash", "-c", cmd).Output()
	if err != nil {
		log.Fatal(err)
	}
	ssid := strings.TrimSpace(string(out))
	return ssid
}

package main

import (
	"fmt"
	"log"

	"github.com/sideshow/apns2"
	"github.com/sideshow/apns2/token"
)

func main() {

	authKey, err := token.AuthKeyFromFile("./AuthKey_YYS33CP3HU.p8")
	if err != nil {
		log.Fatal("token error:", err)
	}

	token := &token.Token{
		AuthKey: authKey,
		KeyID:   "YYS33CP3HU",
		TeamID:  "25K6PDW2HY",
	}

	notification := &apns2.Notification{}
	notification.DeviceToken = "f6c10036b6203ebf40a246ce5a741c3b17778063c78aa1016c6474d3dfef46e2"
	notification.Topic = "ru.4gophers.Notifications"
	notification.Payload = []byte(`{"aps":{"alert":"Hello!"}}`)

	client := apns2.NewTokenClient(token)
	res, err := client.Push(notification)

	if err != nil {
		log.Fatal("Error:", err)
	}

	fmt.Printf("%v %v %v\n", res.StatusCode, res.ApnsID, res.Reason)
}

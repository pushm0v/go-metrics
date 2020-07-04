package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

const (
	API_URL = "http://numbersapi.com"
)

func main() {

	reqUrl := fmt.Sprintf("%s/random/year", API_URL)
	body, err := requestHttp(reqUrl)

	if err != nil {
		log.Fatalln(err)
	}
	fmt.Println(string(body))
}

func requestHttp(url string) (body []byte, err error) {
	resp, err := http.Get(url)
	if err != nil {
		return
	}

	defer resp.Body.Close()

	body, err = ioutil.ReadAll(resp.Body)
	if err != nil {
		return
	}

	return
}

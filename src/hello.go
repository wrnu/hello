package main

import (
    "fmt"
    "io"
    "io/ioutil"
    "net/http"
)

func hello(w http.ResponseWriter, r *http.Request) {
    if r.Method == "POST" {
        body, err := ioutil.ReadAll(r.Body)
        if err != nil {
            http.Error(w, "Error reading request body",
                http.StatusInternalServerError)
        }
        response := fmt.Sprintf("Hello %s world!", string(body))
        io.WriteString(w, response)
    } else {
        io.WriteString(w, "Hello world!")
    }
}

func main() {
    http.HandleFunc("/", hello)
    http.ListenAndServe(":80", nil)
}


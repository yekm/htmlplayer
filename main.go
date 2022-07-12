package main

import (
    "encoding/json"
    "fmt"
    "strings"
    "os"
    "bufio"
)


type Leaf struct {
    Name    string   `json:"text"`
    Href    string   `json:"href"`
    CCount  int      `json:"-"`
    Leafs   []*Leaf  `json:"nodes,omitempty"`
}

func (l *Leaf) String() string {
    j, _ := json.Marshal(l)
    return string(j)
}

func (l *Leaf) AppendPath(p string) {
    sp := strings.Split(p, string(os.PathSeparator))
    ll := l
    for _, v := range sp {
        found := 0
        for _, lv := range ll.Leafs {
            if lv.Name == v {
                found = 1
                ll = lv
                break
            }
        }
        if found == 0 {
            newl := &Leaf{v, "#"+p, 0, []*Leaf{}}
            ll.Leafs = append(ll.Leafs, newl)
            ll = newl
        }
    }
}


func main() {
    ltree := &Leaf{"", "", 0, []*Leaf{}}
    scanner := bufio.NewScanner(os.Stdin)
    for scanner.Scan() {
        ltree.AppendPath(scanner.Text())
    }
    m, _ := json.Marshal(ltree.Leafs)
    fmt.Println(string(m))
}


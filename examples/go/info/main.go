package main

import (
	"fmt"
	"net"
	"os"
	"reflect"
	"sort"
	"strings"
)

type nameValuePair struct {
	Name  string
	Value string
}

type nameValuePairs []nameValuePair

func (a nameValuePairs) Len() int           { return len(a) }
func (a nameValuePairs) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }
func (a nameValuePairs) Less(i, j int) bool { return a[i].Name < a[j].Name }

func main() {
	dumpProgramArguments()
	dumpEnvironment()
	dumpNetworkInterfaces()
}

func dumpProgramArguments() {
	writeTitle("Program Arguments")
	for i, v := range os.Args {
		fmt.Printf("%d=%s\n", i, v)
	}
}

func dumpEnvironment() {
	environment := make([]nameValuePair, 0)
	for _, v := range os.Environ() {
		parts := strings.SplitN(v, "=", 2)
		name := parts[0]
		value := parts[1]
		environment = append(environment, nameValuePair{name, value})
	}
	sort.Sort(nameValuePairs(environment))

	writeTitle("Environment Variables")
	for _, v := range environment {
		fmt.Printf("%s=%s\n", v.Name, v.Value)
	}
}

func dumpNetworkInterfaces() {
	writeTitle("Network Interfaces")

	interfaces, err := net.Interfaces()
	if err != nil {
		fmt.Printf("ERROR getting network interfaces %s\n", err)
		return
	}

	for _, ifi := range interfaces {
		addresses, err := ifi.Addrs()
		if err != nil {
			fmt.Printf("%s %s (ERROR failed to retrieve addresses with error %s)\n", ifi.Name, ifi.Flags, err)
		} else {
			fmt.Printf("%s %s %s\n", ifi.Name, ifi.HardwareAddr, ifi.Flags)

			for _, address := range addresses {
				var ip net.IP

				// for some reason, the address type is different on Linux (IPNet) and on Windows (IPAddr).
				// The fix is scheduled for Go 1.2. See https://code.google.com/p/go/issues/detail?id=5395
				switch v := address.(type) {
				case *net.IPNet:
					ip = v.IP
				case *net.IPAddr:
					ip = v.IP
				default:
					fmt.Printf("  %s (%s)\n", address, reflect.TypeOf(address))
					continue
				}

				ip4 := ip.To4()

				if ip4 == nil {
					fmt.Printf("  %s (%s)\n", address, reflect.TypeOf(address))
					continue
				}

				fmt.Printf("  %s (IPv4)\n", ip4)
			}
		}
	}
}

func writeTitle(title string) {
	fmt.Printf("#\n# %s\n#\n", title)
}

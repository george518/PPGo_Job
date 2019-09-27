/************************************************************
** @Description: ip
** @Author: george hao
** @Date:   2019-06-27 09:20
** @Last Modified by:  george hao
** @Last Modified time: 2019-06-27 09:20
*************************************************************/
package libs

import (
	"io/ioutil"
	"net"
	"net/http"
)

func GetHostIp(IpType int) string {
	if IpType == 0 {
		return LocalIp()
	} else {
		return PublicIp()
	}
}

func LocalIp() string {

	addrs, err := net.InterfaceAddrs()
	if err != nil {
		return ""
	}
	for _, address := range addrs {
		// 检查ip地址判断是否回环地址
		if ipnet, ok := address.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				return ipnet.IP.String()
			}
		}
	}
	return ""
}

func PublicIp() string {
	resp, err := http.Get("http://myexternalip.com/raw")
	if err != nil {
		return ""
	}
	defer resp.Body.Close()
	content, _ := ioutil.ReadAll(resp.Body)
	//buf := new(bytes.Buffer)
	//buf.ReadFrom(resp.Body)
	//s := buf.String()
	return string(content)
}

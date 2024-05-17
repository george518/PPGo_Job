/************************************************************
** @Description: libs
** @Author: george hao
** @Date:   2018-08-09 13:29
** @Last Modified by:  Bee
** @Last Modified time: 2019-02-15 13:50
*************************************************************/
package libs

import (
	"github.com/pkg/errors"
	"io"
	"net/http"
	"strings"
)

func HttpGet(url string, param map[string]string) (string, error) {

	if url == "" {
		return "", errors.Errorf("url %s is not exists", url)
	}
	paramStr := ""
	for k, v := range param {
		paramStr += k + "=" + v + "&"
	}
	paramStr = strings.TrimRight(paramStr, "&")

	if paramStr != "" {
		if strings.Contains(url, "?") {
			url += "&" + paramStr
		} else {
			url += "?" + paramStr
		}
	}

	resp, err := http.Get(url)

	if err != nil {
		return "", err
	}

	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)

	if err != nil {
		return "", err
	}

	return string(body), nil
}

func HttpPost(url string, contentType string, body io.Reader) (string, error) {

	resp, err := http.Post(url, contentType, body)

	if err != nil {
		return "", err
	}

	defer resp.Body.Close()

	resBody, err := io.ReadAll(resp.Body)

	if err != nil {
		return "", err
	}

	return string(resBody), nil
}

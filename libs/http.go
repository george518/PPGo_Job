/************************************************************
** @Description: libs
** @Author: george hao
** @Date:   2018-08-09 13:29
** @Last Modified by:  george hao
** @Last Modified time: 2018-08-09 13:29
*************************************************************/
package libs

import (
	"github.com/pkg/errors"
	"io/ioutil"
	"strings"
	"net/http"
	"io"
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
		url += "?" + paramStr
	}

	resp, err := http.Get(url)

	if err != nil {
		return "", err
	}

	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)

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

	resBody, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		return "", err
	}

	return string(resBody), nil
}

/************************************************************
** @Description: libs
** @Author: george hao
** @Date:   2018-08-09 13:29
** @Last Modified by:  george hao
** @Last Modified time: 2018-08-09 13:29
*************************************************************/
package libs

import (
	"encoding/json"
	"github.com/pkg/errors"
	"io/ioutil"
	"net/http"
	"strings"
	"io"
)

type AjaxReturn struct {
	Status  int         `json:"status"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
}

func HttpGet(url string, param map[string]string) error {

	if url == "" {
		return errors.Errorf("url %s is not exists", url)
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
		return err
	}

	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		return err
	}
	ajaxData := AjaxReturn{}
	json.Unmarshal(body, &ajaxData)
	if ajaxData.Status != 200 {
		return errors.Errorf("msg %s", ajaxData.Message)
	}
	return nil
}

func HttpPost(url string, contentType string, body io.Reader) error {

	resp, err := http.Post(url, contentType, body)

	if err != nil {
		return err
	}

	defer resp.Body.Close()

	_, resErr := ioutil.ReadAll(resp.Body)

	if resErr != nil {
		return resErr
	}

	return nil
}

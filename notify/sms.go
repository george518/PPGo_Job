/************************************************************
** @Description: notify
** @Author: george hao
** @Date:   2018-08-09 13:05
** @Last Modified by:  Bee
** @Last Modified time: 2019-02-15 13:50
*************************************************************/
package notify

import (
	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job/libs"
	"log"
	"time"
	"encoding/json"
	"github.com/pkg/errors"
)

type SmsAjaxReturn struct {
	Status  int         `json:"status"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
}

type Sms struct {
	Mobiles map[string]string
	Param   map[string]string
}

var SmsChan chan *Sms
var SmsUrl string

func init() {
	SmsUrl = beego.AppConfig.String("msg.url")
	poolSize, _ := beego.AppConfig.Int("msg.pool")

	//创建通道
	SmsChan = make(chan *Sms, poolSize)

	go func() {
		for {
			select {
			case m, ok := <-SmsChan:
				if !ok {
					return
				}
				if err := m.SendSms(); err != nil {
					beego.Error("SendSms:", err.Error())
				}
			}
		}
	}()

}

func SendSmsToChan(mobiles map[string]string, param map[string]string) bool {
	sms := &Sms{
		Mobiles: mobiles,
		Param:   param,
	}

	select {
	case SmsChan <- sms:
		return true
	case <-time.After(time.Second * 3):
		return false
	}
}

func (s *Sms) SendSms() error {

	for _, v := range s.Mobiles {
		s.Param["mobile"] = v
		res, err := libs.HttpGet(SmsUrl, s.Param)

		if err != nil {
			log.Println(err)
			return err
		}

		ajaxData := SmsAjaxReturn{}
		jsonErr := json.Unmarshal([]byte(res), &ajaxData)

		if jsonErr != nil {
			return jsonErr
		}

		if ajaxData.Status != 200 {
			return errors.Errorf("msg %s", ajaxData.Message)
		}

		return nil

	}
	return nil
}

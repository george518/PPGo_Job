/************************************************************
** @Description: notify
** @Author: Bee
** @Date:   2018-02-15 11:02
** @Last Modified by:  Bee
** @Last Modified time: 2018-02-15 11:02
*************************************************************/
package notify

import (
	"github.com/astaxie/beego"
	"github.com/george518/PPGo_Job/libs"
	"log"
	"time"
	"fmt"
	"encoding/json"
	"bytes"
)

type Dingtalk struct {
	Dingtalks map[string]string
	Content   map[string]interface{}
}

var DingtalkChan chan *Dingtalk
var DingtalkUrl string

func init() {
	DingtalkUrl = beego.AppConfig.String("dingtalk.url")
	poolSize, _ := beego.AppConfig.Int("dingtalk.pool")

	//创建通道
	DingtalkChan = make(chan *Dingtalk, poolSize)

	go func() {
		for {
			select {
			case m, ok := <-DingtalkChan:
				if !ok {
					return
				}
				if err := m.SendDingtalk(); err != nil {
					beego.Error("SendDingtalk:", err.Error())
				}
			}
		}
	}()

}

func SendDingtalkToChan(dingtalks map[string]string, content map[string]interface{}) bool {
	dingTalk := &Dingtalk{
		Dingtalks: dingtalks,
		Content:   content,
	}

	select {
	case DingtalkChan <- dingTalk:
		return true
	case <-time.After(time.Second * 3):
		return false
	}
}

func (s *Dingtalk) SendDingtalk() error {

	for _, v := range s.Dingtalks {
		body, err := json.Marshal(s.Content)
		if err != nil {
			log.Println(err)
			return err
		}

		url := fmt.Sprintf(DingtalkUrl, v)
		_, resErr := libs.HttpPost(url, "application/json;charset=utf-8", bytes.NewBuffer(body))
		if resErr != nil {
			log.Println(resErr)
			return resErr
		}
		return nil
	}
	return nil
}

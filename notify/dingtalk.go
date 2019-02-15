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

type Msg struct {
	MsgType string `json:"msgtype"`
	Text    *Text  `json:"text"`
}

type Text struct {
	Content string `json:"content"`
}

type Dingtalk struct {
	Dingtalks []string
	Content   string
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
				if _, err := m.SendDingtalk(); err != nil {
					beego.Error("SendDingtalk:", err.Error())
				}
			}
		}
	}()

}

func SendDingtalkToChan(dingtalks []string, content string) bool {
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

func (s *Dingtalk) SendDingtalk() (string, error) {

	for _, v := range s.Dingtalks {

		msg := Msg{MsgType: "text"}
		text := new(Text)
		text.Content = s.Content
		msg.Text = text

		msgJson, err := json.Marshal(msg)
		if err != nil {
			log.Println(err)
			return "", err
		}

		url := fmt.Sprintf(DingtalkUrl, v)
		res, err := libs.HttpPost(url, "application/json;charset=utf-8", bytes.NewBuffer(msgJson))
		if err != nil {
			log.Println(err)
			return "", err
		}
		return res, err
	}
	return "", nil
}

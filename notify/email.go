/************************************************************
** @Description: notify
** @Author: george hao
** @Date:   2018-08-08 12:59
** @Last Modified by:  george hao
** @Last Modified time: 2018-08-08 12:59
*************************************************************/
package notify

import (
	"github.com/astaxie/beego"
	"net/smtp"
	"strings"
	"time"
)

type PEmailConfig struct {
	Host string
	Port string
	User string
	Pwd  string
	From string
}

type PEmail struct {
	Config  *PEmailConfig
	Subject string
	Body    string
	To      string
	Format  string
}

var (
	mailChan chan *PEmail
	config   *PEmailConfig
)

func init() {

	poolSize, _ := beego.AppConfig.Int("email.pool")
	host := beego.AppConfig.String("email.host")
	port := beego.AppConfig.String("email.port")
	user := beego.AppConfig.String("email.user")
	pwd := beego.AppConfig.String("email.password")
	from := beego.AppConfig.String("email.from")

	config = &PEmailConfig{
		Host: host,
		From: from,
		Port: port,
		User: user,
		Pwd:  pwd,
	}

	//创建通道
	mailChan = make(chan *PEmail, poolSize)

	go func() {
		for {
			select {
			case m, ok := <-mailChan:
				if !ok {
					return
				}
				if err := m.SendToEmail(); err != nil {
					beego.Error("SendMail:", err.Error())
				}
			}
		}
	}()
}

func SendToChan(to, subject, body, mailtype string) bool {
	email := &PEmail{
		Config:  config,
		Body:    body,
		Subject: subject,
		Format:  mailtype,
		To:      to,
	}
	select {
	case mailChan <- email:
		return true
	case <-time.After(time.Second * 3):
		return false
	}

}

func (pe *PEmail) SendToEmail() error {
	auth := smtp.PlainAuth("", pe.Config.User, pe.Config.Pwd, pe.Config.Host)
	var contentType string
	if pe.Format == "html" {
		contentType = "Content-Type: text/" + pe.Format + "; charset=UTF-8"
	} else {
		contentType = "Content-Type: text/plain" + "; charset=UTF-8"
	}

	msg := []byte("To: " + pe.To + "\r\nFrom: " + pe.Config.User +
		"\r\nSubject: " + pe.Subject + "\r\n" + contentType + "\r\n\r\n" + pe.Body)
	sendTo := strings.Split(pe.To, ";")
	err := smtp.SendMail(pe.Config.Host+":"+pe.Config.Port, auth, pe.Config.User, sendTo, msg)
	return err
}

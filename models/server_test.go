package models

import (
	"errors"
	"fmt"
	"testing"
)

func TestDetection(t *testing.T) {
	T := &TaskServer{
		Type:          0,
		ServerName:    "ServerName",
		ServerAccount: "ServerAccount",
		ServerIp:      "ServerIp",
	}
	err := T.Update()
	fmt.Print(err)
}

func (t *TaskServer) update() error {
	err := Detection(t)
	if err != nil {
		return fmt.Errorf(err.Error())
	}
	if t.Password == "" || t.PrivateKeySrc == "" {
		switch t.Type {
		case 0:
			return errors.New("服务器密码不能为空")
		case 1:
			return errors.New("私钥不能为空")
		default:
			return errors.New("类型不在规范之内")
		}
	}
	return nil
}

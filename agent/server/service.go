/************************************************************
** @Description: service
** @Author: george hao
** @Date:   2019-06-26 15:27
** @Last Modified by:  george hao
** @Last Modified time: 2019-06-26 15:27
*************************************************************/
package server

import (
	"net"
	"net/rpc"
	"net/rpc/jsonrpc"
	"strconv"
)

//初始化路由
func init() {
	rpc.RegisterName("RpcTask", new(RpcTask))
	rpc.RegisterName("HeartBeat", new(RpcTask))
}

func RpcRun() error {

	listener, err := net.Listen("tcp", ":"+strconv.Itoa(C.TcpPort))
	if err != nil {
		return err
	}
	for {
		conn, err := listener.Accept()
		if err != nil {
			return err
		}
		//注意ServerCodec是个方法，不是接口
		go rpc.ServeCodec(jsonrpc.NewServerCodec(conn))
		//go rpc.ServeConn(conn)
	}
}

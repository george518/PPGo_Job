/*
* @Author: haodaquan
* @Date:   2017-06-21 10:29:55
* @Last Modified by:   haodaquan
* @Last Modified time: 2017-06-21 10:30:07
 */

package controllers

type HelpController struct {
	BaseController
}

func (this *HelpController) Index() {

	this.Data["pageTitle"] = "使用帮助"
	this.display()
}

/************************************************************
** @Description: convert
** @Author: george hao
** @Date:   2019-06-28 09:34
** @Last Modified by:  george hao
** @Last Modified time: 2019-06-28 09:34
*************************************************************/
package libs

import "fmt"

//查看数据类型
func DataType(i interface{}) string {
	return fmt.Sprintf("%T", i)
}

/*
 * Date: 2016-12-13
 */
function tipsPanel (tips, btn1, btn2) {
	var timer = null;
	var ele = '<div id="tips_panel" class="tips_panel"><div>';
		ele += '<div class="tips_txt"><h3>' + tips + '</h3></div>';
	if (btn2) {
		ele += '<div class="tips_button tips_button2 clearfix">';
		ele += '<div class="tips_close"><button type="button" id="tips_close" class="box_sizing">' + btn1 + '</button></div>';
		ele += '<div class="tips_sure"><button type="button" id="tips_sure" class="box_sizing">' + btn2 + '</button></div>';
		ele += '</div></div></div>';
		$('body').append(ele);
	} else {
		ele += '<div class="tips_button clearfix">';
		ele += '<div class="tips_close"><button type="button" id="tips_close" class="box_sizing">' + btn1 + '</button></div>';
		ele += '</div></div></div>';
		$('body').append(ele);	
	}
}
$('body').on('click', '#tips_panel *', function (event) {
	event.stopPropagation();
});
$('body').on('click', '#tips_panel, #tips_close', function (event) {
	event.stopPropagation();
	$(this).closest('#tips_panel').remove();
});
'use strict';

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

/**
 * name: formSelects
 * 基于Layui Select多选
 * version: 3.0.9.0607
 * https://faysunshine.com/layui/template/formSelects-v3/formSelects-v3.js
 */
(function (layui, window, factory) {
	if ((typeof exports === 'undefined' ? 'undefined' : _typeof(exports)) === 'object') {
		// 支持 CommonJS
		module.exports = factory();
	} else if (typeof define === 'function' && define.amd) {
		// 支持 AMD
		define(factory);
	} else if (window.layui && layui.define) {
		//layui加载
		layui.define(['jquery', 'form'], function (exports) {
			exports('formSelects', factory());
		});
	} else {
		window.formSelects = factory();
	}
})(layui, window, function () {
	//针对IE的一些处理
	if (window.Map == undefined) {
		var _Map = function _Map() {
			this.value = {};
		};

		_Map.prototype.set = function (key, val) {
			this.value[key] = val;
		};

		_Map.prototype.get = function (key) {
			return this.value[key];
		};

		_Map.prototype.has = function (key) {
			return this.value.hasOwnProperty(key);
		};

		_Map.prototype.delete = function (key) {
			delete this.value[key];
		};

		window.Map = _Map;
	}

	var $ = layui.jquery || $,
	    form = layui.form,
	    select3 = {
		value: function value(name) {
			var type = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 'all';
			var vals = arguments[2];

			if (Array.isArray(type)) {
				vals = type;
				type = 'all';
			}
			if (name && vals && Array.isArray(vals)) {
				var options = commons.data.confs.get(name);
				if (options) {
					var dl = commons.methods.getDiv(options).find('dl');
					if (!options.repeat) {
						vals = new Set(vals);
					}
					var on = options.on;
					options.on = null;
					commons.methods.removeAll(options);
					options.delete = false;
					vals.forEach(function (val) {
						dl.find('dd:not(.layui-disabled)[lay-value=\'' + val + '\']').click();
					});
					options.on = on;
				}
				return;
			}
			var arr = commons.data.values.get(name);
			if (!arr) {
				return vals;
			}
			if (type == 'val') {
				return arr.map(function (val) {
					return val.val;
				});
			}
			if (type == 'valStr') {
				return arr.map(function (val) {
					return val.val;
				}).join(',');
			}
			if (type == 'name') {
				return arr.map(function (val) {
					return val.name;
				});
			}
			if (type == 'nameStr') {
				return arr.map(function (val) {
					return val.name;
				}).join(',');
			}
			return arr;
		},
		render: function render(options) {
			if (options) {
				if (commons.data.confs.get(options.name)) {
					options = commons.methods.cloneOptions(options, commons.data.confs.get(options.name));
					commons.methods.init(options);
				} else {
					var dom = commons.methods.getDom(options, true);
					if (dom.length) {
						var hisOptions = commons.methods.cloneOptions(commons.methods.getOptions(dom), commons.data.DEFAULT_OPTIONS);
						options = commons.methods.cloneOptions(options, hisOptions);
						commons.methods.init(options);
					}
				}
			} else {
				commons.methods.autoInit();
			}
		},
		delete: function _delete(name, abs) {
			if (name && commons.data.confs.get(name)) {
				var dom = commons.methods.getDom({
					name: name
				});
				if (dom.parent().hasClass(commons.data.pclass)) {
					if (abs) {
						dom.removeAttr(commons.data.name);
					}
					dom.removeAttr('style');
					dom.parent()[0].outerHTML = dom[0].outerHTML;
				}
				commons.data.confs.delete(name);
				for (var item in commons.data.temps) {
					commons.data.temps[item].delete(name);
				}
				commons.data.values.delete(name);
			}
		},
		style: function style(name, colors) {
			if (name) {
				if (!colors) {
					commons.methods.loadCss(name, null);
				} else if (Array.isArray(colors)) {
					commons.methods.loadCss(name, colors);
				} else {
					var arr = [colors.labelBgColor, colors.labelColor, colors.labelIconBgColor, colors.labelIconColor, colors.labelLabelBorderColor, colors.thisBgColor, colors.thisColor];
					commons.methods.loadCss(name, arr);
				}
			}
		}
	},
	    commons = {
		data: {
			name: 'xm-select',
			pclass: 'xm-select-parent',
			vclass: 'xm-select-validate',
			DEFAULT_OPTIONS: {
				name: null, //xm-select="xxx"
				type: 1, //显示模式, 1:layui-this, 2:checkbox, 3:icon
				icon: {
					class: 'layui-icon-ok',
					text: '&#xe618;'
				},
				max: null,
				maxTips: null,
				init: null, //初始化的选择值,
				on: null, //select值发生变化
				data: null
			},
			DEFAULT_RENDER: {
				arr: null,
				name: 'name',
				val: 'val',
				selected: 'selected',
				disabled: 'disabled'
			},
			confs: new Map(),
			temps: {
				dom: new Map(),
				div: new Map()
			},
			resize: new Map(),
			values: new Map(),
			times: new Map()
		},
		methods: {
			init: function init(options, clone) {
				if (!clone) {
					options = commons.methods.cloneOptions(options);
				}
				//原始dom添加一个filter
				var _ref = ['xm-' + options.name, commons.methods.getDom(options, true)],
				    filter = _ref[0],
				    dom = _ref[1];

				if (dom.next().hasClass('layui-form-select')) {
					dom.next().remove();
				}
				if (options.data && options.data.arr) {
					var os = $.extend({}, commons.data.DEFAULT_RENDER, options.data);
					var html = '<option value=""></option>';
					for (var i in os.arr) {
						var db = os.arr[i];
						if (db.arr && Array.isArray(db.arr)) {
							html += '<optgroup label="' + db.name + '">';
							for (var j in db.arr) {
								var gdb = db.arr[j];
								html += '<option value="' + gdb[os.val] + '" ' + (gdb[os.selected] ? 'selected="selected"' : '') + ' ' + (gdb[os.disabled] ? 'disabled="disabled"' : '') + '>' + gdb[os.name] + '</option>';
							}
							html += '</optgroup>';
						} else {
							html += '<option value="' + db[os.val] + '" ' + (db[os.selected] ? 'selected="selected"' : '') + ' ' + (db[os.disabled] ? 'disabled="disabled"' : '') + '>' + db[os.name] + '</option>';
						}
					}
					dom.html(html);
				}
				//判断dom中是否包含了空的option, 如果不包含, 添加
				if (!dom.find('option[value=""]').length) {
					$('<option value=""></option>').insertBefore(dom.find('option:first'));
				}
				if (dom.parent().hasClass(commons.data.pclass)) {
					dom.parent().attr('lay-filter', filter).addClass('layui-form');
				} else {
					dom.wrap('<div class="layui-form ' + commons.data.pclass + '" lay-filter="' + filter + '"></div>');
				}
				dom.attr('lay-filter', filter);
				options.type ? dom.attr('xm-select-type', options.type) : dom.removeAttr('xm-select-type');
				options.max ? dom.attr('xm-select-max', options.max) : dom.removeAttr('xm-select-max');
				commons.methods.formRender('select', filter, true);
				//1.去掉layui的原始渲染
				commons.methods.getDom(options).next().addClass(commons.data.vclass);
				//2.
				commons.data.confs.set(options.name, options);
				for (var item in commons.data.temps) {
					commons.data.temps[item].delete(options.name);
				}
				commons.data.values.delete(options.name);
				//3.渲染input
				commons.methods.overrideInput(options);
				commons.methods.typeInit(options, filter);
				//4.初始化init
				var vals = commons.methods.getInitVal(options);
				vals.forEach(function (val) {
					commons.methods.valHandler(options, val, true);
				});
				commons.methods.showPlaceholder(options);
				commons.methods.retop(options);
				commons.methods.removeDefaultClass(options);
				commons.methods.on(options, filter);
			},
			addLabel: function addLabel(options, vals) {
				var ipt = commons.methods.getIpt(options);
				ipt.find('.xm-select-empty').remove();
				vals.forEach(function (val) {
					var tips = 'fsw="' + options.name + '"';
					var _ref2 = [$('<span ' + tips + ' value=\'' + val.val + '\'><font ' + tips + '>' + val.name + '</font></span>'), $('<i ' + tips + ' class="layui-icon">&#x1006;</i>')],
					    $label = _ref2[0],
					    $close = _ref2[1];

					$label.append($close);
					ipt.append($label);
				});
			},
			delLabel: function delLabel(options, vals) {
				var ipt = commons.methods.getIpt(options);
				vals.forEach(function (val) {
					ipt.find('span[value=\'' + val.val + '\']:first').remove();
				});
			},
			showPlaceholder: function showPlaceholder(options) {
				var vals = commons.methods.getValues(options);
				if (!vals.length) {
					var _ref3 = ['fsw="' + options.name + '"', commons.methods.getIpt(options)],
					    tips = _ref3[0],
					    ipt = _ref3[1];

					if (!ipt.find('.xm-select-empty').length) {
						var _tips = options.tips ? options.tips : ipt.prev().attr('placeholder');
						var cls = 'fsw="' + options.name + '"';
						var span = $('<span ' + cls + ' class="xm-select-empty">' + _tips + '</span>');
						ipt.append(span);
					}
				}
			},
			valHandler: function valHandler(options, val, isAdd, isShow) {
				var vals = commons.methods.getValues(options);
				var dd = commons.methods.getDiv(options).find('dl dd[lay-value=\'' + val.val + '\']');
				if (isAdd) {
					if (!options.max || options.max && vals.length < options.max) {
						vals.push(val);
						commons.methods.addLabel(options, [val]);
						commons.methods.typeHandler(options, dd, isAdd);
					} else {
						commons.methods.maxTips(options, val);
						commons.methods.typeHandler(options, dd, false);
					}
				} else {
					if (!dd.hasClass('layui-disabled')) {
						commons.methods.remove(vals, val);
						commons.methods.delLabel(options, [val]);
						if (commons.methods.indexOf(vals, val) == -1) {
							commons.methods.typeHandler(options, dd, isAdd);
						}
					}
				}
				commons.methods.retop(options);
			},
			typeInit: function typeInit(options, filter) {
				var div = commons.methods.getDiv(options);
				if (options.type == 2) {
					//checkbox
					div.find('dl dd:not(.layui-select-tips)').each(function (index, target) {
						var $target = $(target);
						var text = $target.text();
						var dis = $target.hasClass('layui-disabled') ? 'disabled' : '';
						$target.text('');
						$target.append('\n\t\t\t\t\t\t\t\t<span lay-filter="' + filter + '">\n\t\t\t\t\t\t\t\t\t<input type="checkbox" title="' + text + '" lay-skin="primary" ' + dis + '> \t\n\t\t\t\t\t\t\t\t</span>\n\t\t\t\t\t\t\t');
					});
					form.render('checkbox', filter);
					div.find('dl dd .layui-form-checkbox').css('margin-top', '1px');
				} else {
					div.find('dl dd:not(.layui-select-tips)').each(function (index, target) {
						$(target).css({
							margin: '1px 0'
						});
					});
				}
			},
			typeHandler: function typeHandler(options, dd, isAdd) {
				if (options.type == 3) {
					//对勾
					if (isAdd) {
						var span = $('\n\t\t\t\t\t\t\t\t<span><i class="layui-icon ' + options.icon.class + '">' + options.icon.text + '</i></span>\t\n\t\t\t\t\t\t\t');
						dd.append(span);
					} else {
						dd.find('span').remove();
					}
				} else if (options.type == 2) {
					//checkbox
					if (isAdd) {
						dd.find('.layui-form-checkbox').addClass('layui-form-checked');
					} else {
						dd.find('.layui-form-checkbox').removeClass('layui-form-checked');
					}
				}
				isAdd ? dd.addClass(commons.data.name + '-this') : dd.removeClass(commons.data.name + '-this');
				dd.removeClass('layui-this');
				commons.methods.showPlaceholder(options);
			},
			on: function on(options, filter) {
				form.on('select(' + filter + ')', function (data) {
					if (options.radio) {
						commons.methods.getDiv(options).find('dl').removeClass('xm-select-show').addClass('xm-select-hidn').css('display', 'none');
						var selected = void 0,
						    val = void 0;
						if (data.value) {
							val = {
								name: commons.methods.getDom(options).find('option[value=\'' + data.value + '\']').text(),
								val: data.value
							};
							selected = commons.methods.indexOf(commons.methods.getValues(options), val) == -1;
							if (selected) {
								var hisVal = select3.value(options.name)[0];
								if (hisVal) {
									commons.methods.valHandler(options, hisVal, false, false);
									commons.methods.setValues(options, []);
								}
							}
							commons.methods.valHandler(options, val, selected, false);
						} else {
							selected = false;
							val = select3.value(options.name)[0];
							if (val) {
								commons.methods.valHandler(options, val, selected, false);
								commons.methods.setValues(options, []);
							}
						}
						if (val && options.on && options.on instanceof Function) {
							options.on(data, select3.value(options.name), val, selected);
						}
						return;
					}
					if (commons.methods.getDiv(options).hasClass('layui-form-selectup') || commons.methods.getDiv(options).find('dl').css('top').indexOf('-') == 0) {
						setTimeout(function () {
							commons.methods.getDiv(options).addClass('layui-form-selectup');
						}, 50);
					}

					if (options.repeat) {
						if (data.value) {
							var ipt = commons.methods.getIpt(options);
							if (options.delete) {
								var arr = select3.value(options.name);
								var _val = arr[commons.methods.indexOf(arr, data.value)];
								if (_val) {
									commons.methods.valHandler(options, _val, false);
									ipt.parent().next().find('dd[lay-value=\'' + data.value + '\'] .layui-form-checkbox > i').html('&#xe605;');
									if (options.on && options.on instanceof Function) {
										options.on(data, select3.value(options.name), _val, false);
									}
								}
								options.delete = false;
								return;
							} else {
								var vals = commons.methods.getValues(options);
								var _val2 = {
									name: commons.methods.getDom(options).find('option[value=\'' + data.value + '\']').text(),
									val: data.value
								};
								commons.methods.valHandler(options, _val2, true);
								if (options.on && options.on instanceof Function) {
									options.on(data, select3.value(options.name), _val2, true);
								}
							}
							setTimeout(function () {
								commons.methods.getDiv(options).addClass('layui-form-selected').find('dl dd.layui-this').removeClass('layui-this');
							}, 3);
							return;
						}
					}
					if (data.value) {
						var _val3 = {
							name: commons.methods.getDom(options).find('option[value=\'' + data.value + '\']').text(),
							val: data.value
						};
						var _selected = commons.methods.indexOf(commons.methods.getValues(options), _val3) == -1;
						commons.methods.valHandler(options, _val3, _selected, true);

						if (options.on && options.on instanceof Function) {
							options.on(data, select3.value(options.name), _val3, _selected);
						}

						setTimeout(function () {
							commons.methods.getDiv(options).addClass('layui-form-selected').find('dl dd.layui-this').removeClass('layui-this');
						}, 3);
					} else {
						if (commons.methods.getDom(options).attr('xm-select-search') == undefined) {
							commons.methods.removeAll(options);
							setTimeout(function () {
								commons.methods.getDiv(options).addClass('layui-form-selected');
							}, 3);
						}
					}
				});
			},
			maxTips: function maxTips(options, val) {
				if (options.maxTips && options.maxTips instanceof Function) {
					options.maxTips(select3.value(options.name), val, options.max);
					return;
				}
				var ipt = commons.methods.getIpt(options);
				if (ipt.parents('.layui-form-item[pane]').length) {
					ipt = ipt.parents('.layui-form-item[pane]');
				}
				ipt.css('border-color', 'red');
				setTimeout(function () {
					ipt.css('border-color', '#e6e6e6');
				}, 300);
			},
			indexOf: function indexOf(arr, val) {
				for (var i = 0; i < arr.length; i++) {
					if (arr[i].val == val || arr[i].val == (val ? val.val : val) || arr[i] == val || JSON.stringify(arr[i]) == JSON.stringify(val)) {
						return i;
					}
				}
				return -1;
			},
			remove: function remove(arr, val) {
				var index = commons.methods.indexOf(arr, val ? val.val : val);
				if (index > -1) {
					arr.splice(index, 1);
					return true;
				}
				return false;
			},
			removeAll: function removeAll(options) {
				var div = commons.methods.getDiv(options);
				var vals = div.find('.xm-select > span');
				vals.each(function (index, item) {
					options.delete = true;
					div.find('dl dd.xm-select-this:not(.layui-disabled)[lay-value=\'' + item.getAttribute('value') + '\']').click();
				});
				return vals.length;
			},
			removeDefaultClass: function removeDefaultClass(options) {
				var _ref4 = [commons.methods.getDom(options), commons.methods.getDiv(options)],
				    dom = _ref4[0],
				    div = _ref4[1];

				div.find('dl').addClass('xm-select-hidn');
				div.find('dl dd.layui-this').removeClass('layui-this');
				div.find('dl').append('<dt style="display:none;">x<dt/>');
				var text = options.radio ? '请选择' : '清空已选择' + (options.max ? '. \u5F53\u524D\u914D\u7F6E: \u6700\u591A\u9009\u62E9 ' + options.max + ' \u4E2A' : '');
				var html = '<span>' + text + '</span>';
				var that = div.find('dl dd.layui-select-tips');
				if (dom.attr('xm-select-search') != undefined) {
					var icon = '&#xe640;';
					html = '<input class="layui-input xm-select-input-search" placeholder="\u5173\u952E\u5B57\u641C\u7D22"><span><i title="' + text + '" xm-select-clear="' + options.name + '" class="layui-icon">' + icon + '</i></span>';
					that.addClass('xm-select-dd-search');
					that.off('click');
				}
				commons.methods.handlerDataTable(dom, '38px');
				that.html(html);
			},
			handlerDataTable: function handlerDataTable(dom, height) {
				if (dom.length == undefined) {
					dom = $(dom);
				}
				if (dom.parents('div.layui-table-cell').length) {
					var index = dom.parents('tr').attr('data-index');
					dom.parents('.layui-table-box').find('tbody tr[data-index=\'' + index + '\'] div.layui-table-cell').css({
						height: height,
						lineHeight: height,
						overflow: 'unset'
					});
				}
			},
			overrideInput: function overrideInput(options) {
				var _ref5 = [commons.methods.getDiv(options), commons.methods.getDom(options)],
				    _div = _ref5[0],
				    _dom = _ref5[1];
				var _ref6 = [_div.find('.layui-select-title input:first'), $('<div class="layui-input ' + commons.data.name + '"></div>')],
				    $input = _ref6[0],
				    $orinput = _ref6[1];

				$orinput.insertAfter($input);
				if ($input.parents('.layui-form-pane').length && $input.parents('.layui-form-item[pane]').length) {
					$orinput.css('border', 'none');
				}
				if (options.height) {
					$orinput.addClass('.xm-select-height').css('height', options.height);
				}
				if (_dom.attr('disabled') != undefined) {
					$orinput.append($('<div style="\n\t\t\t\t\t\t\t    width: 100%;\n\t\t\t\t\t\t\t    height: 100%;\n\t\t\t\t\t\t\t    display: block;\n\t\t\t\t\t\t\t    position: absolute;\n\t\t\t\t\t\t\t    left: 0;\n\t\t\t\t\t\t\t    top: 0;\n\t\t\t\t\t\t\t"></div>').addClass('layui-disabled'));
				}
			},
			retop: function retop(options) {
				var div = commons.methods.getIpt(options);
				if (div.length) {
					var dl = div.parent('.layui-select-title').next();
					var up = dl.parent().hasClass('layui-form-selectup') || dl.css('top').indexOf('-') == 0;
					var time = commons.data.times.get(options.name);
					if (time) {
						if (Date.now() - time.time < 100 || options.delete) {
							up = time.up;
							options.delete = false;
						} else {
							time.up = up;
						}
						time.time = Date.now();
					} else {
						commons.data.times.set(options.name, {
							time: Date.now(),
							up: up
						});
					}
					if (up) {
						div.parent('.layui-select-title').next().css({
							top: 'auto',
							bottom: div[0].offsetTop + div.height() + 14 + 'px'
						});
					} else {
						div.parent('.layui-select-title').next().css({
							top: div[0].offsetTop + div.height() + 14 + 'px',
							bottom: 'auto'
						});
					}
				}
			},
			getElementTop: function getElementTop(element) {
				var actualTop = element.offsetTop;
				var current = element.offsetParent;
				while (current !== null) {
					actualTop += current.offsetTop;
					current = current.offsetParent;
				}
				return actualTop;
			},
			getDom: function getDom(options, isNew) {
				var _ref7 = [commons.data.temps.dom, options.name],
				    _dom = _ref7[0],
				    _name = _ref7[1];

				if (isNew) {
					_dom.set(_name, $('select[' + commons.data.name + '=\'' + _name + '\']'));
				}
				if (!_dom.has(_name)) {
					_dom.set(_name, $('select[' + commons.data.name + '=\'' + _name + '\']'));
				}
				return _dom.get(_name);
			},
			getDiv: function getDiv(options) {
				var _ref8 = [commons.data.temps.div, options.name],
				    _div = _ref8[0],
				    _name = _ref8[1];

				if (!_div.has(_name)) {
					_div.set(_name, $('select[' + commons.data.name + '=\'' + _name + '\']').next());
				}
				return _div.get(_name);
			},
			getIpt: function getIpt(options) {
				return commons.methods.getDiv(options).find('div .' + commons.data.name);
			},
			getInitVal: function getInitVal(options) {
				var _dom = commons.methods.getDom(options);
				var vals = options.init ? options.init : _dom.find('option[selected]').map(function (index, target) {
					return $(target).attr('value');
				}).toArray();
				var result = void 0;
				if (options.radio) {
					var one = vals.map(function (val) {
						var opt = _dom.find('option[value=\'' + val + '\']');
						return {
							name: opt.attr('disabled') != undefined ? null : opt.text(),
							val: val + ""
						};
					}).filter(function (val) {
						return val.name && val.val;
					})[0];
					result = one ? [one] : [];
				} else {
					result = vals.map(function (val) {
						return {
							name: _dom.find('option[value=\'' + val + '\']').text(),
							val: val + ""
						};
					}).filter(function (val) {
						return val.name && val.val;
					});
				}
				return result;
			},
			getValues: function getValues(options) {
				var _ref9 = [commons.data.values, options.name],
				    _arr = _ref9[0],
				    _name = _ref9[1];

				if (!_arr.has(_name)) {
					_arr.set(_name, []);
				}
				return _arr.get(_name);
			},
			setValues: function setValues(options, vals) {
				var _ref10 = [commons.data.values, options.name],
				    _arr = _ref10[0],
				    _name = _ref10[1];

				_arr.set(_name, vals);
			},
			getOptions: function getOptions(sel) {
				return {
					name: sel.attr('' + commons.data.name),
					type: sel.attr(commons.data.name + '-type'),
					max: sel.attr(commons.data.name + '-max'),
					icon: sel.attr(commons.data.name + '-icon'),
					tips: sel.attr(commons.data.name + '-placeholder'),
					height: sel.attr(commons.data.name + '-height'),
					radio: sel.attr(commons.data.name + '-radio') != undefined,
					repeat: sel.attr(commons.data.name + '-repeat') != undefined
				};
			},
			cloneOptions: function cloneOptions(options, hisOptions) {
				if (!hisOptions) {
					hisOptions = commons.data.DEFAULT_OPTIONS;
				}
				if (options.icon && typeof options.icon == 'string') {
					var icon = options.icon;
					if (icon.indexOf('layui') == 0) {
						options.icon = {
							class: icon,
							text: ''
						};
					} else {
						options.icon = {
							class: '',
							text: icon
						};
					}
				} else {
					var v = layui.v.split('.');
					if (v[0] < 2 || v[1] <= 2) {
						options.icon = {
							class: '',
							text: hisOptions.icon.text
						};
					} else {
						options.icon = {
							class: hisOptions.icon.class,
							text: ''
						};
					}
				}
				return $.extend({}, hisOptions, options);
			},
			autoInit: function autoInit(repeat) {
				$('select[' + commons.data.name + ']').each(function (index, target) {
					var sel = $(target);
					sel.css('display', 'none');
					var options = commons.methods.getOptions(sel);
					if (!repeat) {
						var hisOptions = commons.data.confs.get(options.name);
						options.init = select3.value(options.name, 'val');
						commons.methods.init(commons.methods.cloneOptions(options, hisOptions), true);
					} else {
						commons.methods.init(options);
					}
				});
			},
			listenCloseHandler: function listenCloseHandler(e, that, block) {
				if (block.length) {
					var _ref11 = [block.find('.layui-form-select'), block.find('dl')],
					    div = _ref11[0],
					    dl = _ref11[1];

					var name = block.find('select').attr('xm-select');

					if (that.hasClass('layui-disabled')) {
						return;
					}

					if (that.attr('xm-select-clear') != undefined) {
						if (that.is('i')) {
							var options = commons.data.confs.get($(e.target).attr('xm-select-clear'));
							if (options) {
								var length = commons.methods.removeAll(options);
								if (options.radio && length) {
									return;
								}
							}
							div.addClass('layui-form-selected');
							dl.find('.xm-select-input-search').focus();
							return;
						}
					}

					if (that.hasClass('xm-select-dd-search') || that.hasClass('xm-select-input-search')) {
						div.addClass('layui-form-selected');
						dl.find('.xm-select-input-search').focus();
						return;
					}

					$('.xm-select-parent > select:not([xm-select=\'' + name + '\']) + div > dl').removeClass('xm-select-show').addClass('xm-select-hidn').css('display', 'none');

					if (that.attr('fsw') != undefined) {
						if (that.is('i')) {
							var _ref12 = [$(e.target).parents('.layui-form-select').prev(), $(e.target).parent()],
							    sel = _ref12[0],
							    span = _ref12[1];

							var val = {
								name: span.find('font').text(),
								val: span.attr('value')
							};
							var _options = commons.methods.getOptions(sel);
							_options = commons.data.confs.get(_options.name);
							_options.delete = true;
							commons.methods.getDiv(_options).find('dl dd[lay-value=\'' + val.val + '\']').click();
							setTimeout(function () {
								if (dl.hasClass('xm-select-show')) {
									div.addClass('layui-form-selected');
									dl.find('.xm-select-input-search').focus();
								} else {
									div.removeClass('layui-form-selected');
								}
							}, 3);
							return;
						}
					}

					if (block.find('select').attr('xm-select-radio') != undefined) {
						setTimeout(function () {
							if (dl.hasClass('xm-select-show')) {
								div.removeClass('layui-form-selected');
								dl.removeClass('xm-select-show').addClass('xm-select-hidn').css('display', 'none');
							} else {
								div.addClass('layui-form-selected');
								dl.removeClass('xm-select-hidn').addClass('xm-select-show').css('display', 'block');
								dl.find('.xm-select-input-search').focus();
							}
						}, 3);
						return;
					}

					if (dl.hasClass('xm-select-show')) {
						if (that.hasClass('xm-select') || that.hasClass('xm-select-empty')) {
							dl.removeClass('xm-select-show').addClass('xm-select-hidn').css('display', 'none');
							div.removeClass('layui-form-selected');
						} else {
							div.addClass('layui-form-selected');
							dl.find('.xm-select-input-search').focus();
						}
						return;
					}
					dl.removeClass('xm-select-hidn').addClass('xm-select-show').css('display', 'block');
					div.addClass('layui-form-selected');
					dl.find('.xm-select-input-search').focus();
				} else {
					$('.xm-select-parent > .layui-form-select > dl.xm-select-show').removeClass('xm-select-show').addClass('xm-select-hidn').css('display', 'none');
				}
			},
			listenClose: function listenClose() {
				$(document).on('click', function (e) {
					var that = $(e.target);
					var block = that.parents('.xm-select-parent');
					setTimeout(function () {
						commons.methods.listenCloseHandler(e, that, block);
						commons.methods.retop({ name: block.find('select[xm-select]').attr('xm-select') });
						$('.xm-select-parent input.xm-select-input-search').each(function (index, item) {
							var that = $(item);
							if (that.parents('dl').hasClass('xm-select-hidn')) {
								that.val('');
								that.parents('dl').find('.layui-hide').removeClass('layui-hide');
								that.parents('dl').find('p').remove();
							}
						});
					}, 10);
				});
				$(document).on({
					'input propertychange': function inputPropertychange(e) {
						var that = $(e.target);
						var dl = that.parents('dl');
						that.parents('dl').find('p').remove();
						dl.find('.layui-hide').removeClass('layui-hide');
						dl.find('dd:not(.layui-select-tips):not(:contains(\'' + that.val() + '\'))').addClass('layui-hide');
						if (!dl.find('dd:not(.layui-select-tips):not(.layui-hide)').length) {
							dl.append('<p class="xm-select-search-empty">\u65E0\u5339\u914D\u9879</p>');
						}
						dl.find('dt').each(function (index, item) {
							if (!$(item).nextUntil('dt', ':not(.layui-hide)').length) {
								$(item).addClass('layui-hide');
							}
						});
					}
				}, '.xm-select-parent input.xm-select-input-search');
			},
			formRender: null,
			rewriteRender: function rewriteRender() {
				commons.methods.formRender = form.render;
				form.render = function (type, filter, repeat) {
					commons.methods.formRender(type, filter);
					if (filter) {
						var sel = $('[lay-filter=' + filter + ']').find('select[' + commons.data.name + ']');
						if (sel.length) {
							if (repeat) {
								commons.methods.init(commons.methods.getOptions(sel));
							}
						}
						return;
					}
					commons.methods.autoInit(repeat);
				};
			},
			loadCss: function loadCss(skin, cs) {
				if (skin) {
					if (skin == 'default') {
						return;
					}
					var sn = void 0;
					if ($('style[skin]').length) {
						sn = $('style[skin]');
					} else {
						sn = $('<style ' + skin + ' type="text/css"></style>');
					}
					var df = styles.colors[skin] ? styles.colors[skin] : styles.colors.default;
					var colors = $.extend([], df, cs);
					sn.html(styles.cssColor(skin, colors[0], colors[1], colors[2], colors[3], colors[4], colors[5], colors[6]));
					sn.insertAfter($('head style:last'));
				} else {
					$('<style ' + commons.data.name + ' type="text/css">' + styles.css() + '</style>').insertBefore($('head *:first'));

					var html = '';
					for (var name in styles.colors) {
						var _colors = styles.colors[name];
						if (_colors) {
							_colors = $.extend([], styles.colors.default, _colors);
							html += '<style ' + name + ' type="text/css">' + styles.cssColor(name, _colors[0], _colors[1], _colors[2], _colors[3], _colors[4], _colors[5], _colors[6]) + '</style>';
						}
					}
					if (html) {
						$(html).insertAfter($('head style[' + commons.data.name + ']'));
					}
				}
			},
			loadLastStyle: function loadLastStyle() {
				$('head').append('<style>' + styles.renderCss() + '</style>');
			},
			resize: function resize(selector, fun) {
				var id = commons.data.resize.get(selector);
				if (id != undefined) {
					clearInterval(id);
				}
				if (fun && fun instanceof Function) {
					var hisize = new Map();
					id = setInterval(function (e) {
						$(selector).each(function (index, item) {
							var thisize = [item.clientHeight, item.clientWidth];
							if (hisize.get(item)) {
								var his = hisize.get(item);
								if (his[0] != thisize[0] || his[1] != thisize[1]) {
									fun(item);
								}
							}
							hisize.set(item, thisize);
						});
					}, 250);
					commons.data.resize.set(selector, id);
				}
			},
			run: function run() {
				commons.methods.rewriteRender();
				commons.methods.listenClose();
				commons.methods.loadCss();
				commons.methods.loadLastStyle();
				commons.methods.autoInit();
				commons.methods.resize('.xm-select:not(.xm-select-height)', function (dom) {
					commons.methods.handlerDataTable(dom, dom.clientHeight + 'px');
				});
			}
		}
	},
	    styles = {
		colors: { //name, spanBgColor, spanColor, iBgColor, iColor, borderColor, tBgColor, tColor
			default: ['#F0F2F5', '#909399', '#C0C4CC', '#FFFFFF', '#F0F2F5', '#5FB878', '#FFFFFF'],
			primary: ['#009688', '#FFFFFF', '#009688', '#FFFFFF', '#009688', '#009688', '#FFFFFF'],
			normal: ['#1E9FFF', '#FFFFFF', '#1E9FFF', '#FFFFFF', '#1E9FFF', '#1E9FFF', '#FFFFFF'],
			warm: ['#FFB800', '#FFFFFF', '#FFB800', '#FFFFFF', '#FFB800', '#FFB800', '#FFFFFF'],
			danger: ['#FF5722', '#FFFFFF', '#FF5722', '#FFFFFF', '#FF5722', '#FF5722', '#FFFFFF']
		},
		css: function css() {
			return '\n\t\t\t\t\tselect[xm-select] + div .layui-select-title > input{display: none!important;}\n\t\t\t\t\tselect[xm-select] + div .layui-select-title > div.xm-select{\n\t\t\t\t\t\tline-height: normal;\n\t\t\t\t\t\theight: auto;\n\t\t\t\t\t\tpadding: 4px 10px;\n\t\t\t\t\t\toverflow: hidden;\n\t\t\t\t\t\tmin-height: 38px;\n\t\t\t\t\t\tleft: 0px;\n\t\t\t\t\t\tz-index: 99;\n\t\t\t\t\t\tposition: relative;\n\t\t\t\t\t\tbackground: none;\n\t\t\t\t\t\tpadding-right: 20px;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select] + div .layui-select-title > div.xm-select > span:not(.xm-select-empty){\n\t\t\t\t\t\tpadding: 2px 5px;\n\t\t\t\t\t\tbackground: #f0f2f5;\n\t\t\t\t\t\tborder-radius: 2px;\n\t\t\t\t\t\tcolor: #909399;\n\t\t\t\t\t\tdisplay: block;\n\t\t\t\t\t\tline-height: 18px;\n\t\t\t\t\t\theight: 18px;\n\t\t\t\t\t\tmargin: 2px 5px 2px 0px;\n\t\t\t\t\t\tfloat: left;\n\t\t\t\t\t\tcursor: initial;\n\t\t\t\t\t\tuser-select: none;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select] + div .layui-select-title > div.xm-select > span:not(.xm-select-empty) i{\n\t\t\t\t\t\tbackground-color: #c0c4cc;\n\t\t\t\t\t\tcolor: #ffffff;\n\t\t\t\t\t\tmargin-left: 8px;\n\t\t\t\t\t\tborder-radius: 20px;\n\t\t\t\t\t\tfont-size: 12px;\n\t\t\t\t\t\tcursor: initial;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select] + div .layui-select-title > div.xm-select > span:not(.xm-select-empty) i:hover{\n\t\t\t\t\t\tbackground-color: #909399;\n\t\t\t\t\t\tcursor: pointer;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select] + div .layui-select-title > div.xm-select > span.xm-select-empty{\n\t\t\t\t\t\tdisplay: inline-block;\n\t\t\t\t\t\theight: 28px;\n\t\t\t\t\t\tline-height: 28px;\n\t\t\t\t\t\tcolor: #999999\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select] + div dl dd.xm-select-dd-search{\n\t\t\t\t\t\tbackground-color: #FFFFFF;\n\t\t\t\t\t\tpadding-bottom: 5px;\n\t\t\t\t\t\tmargin-right: 30px;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select] + div dl dd.xm-select-dd-search > input{\n\t\t\t\t\t\tcursor: text;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select] + div dl dd.xm-select-dd-search > span{\n\t\t\t\t\t\tposition: absolute;\n\t\t\t\t\t    right: 8px;\n\t\t\t\t\t    top: 5px;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select] + div dl dd.xm-select-dd-search > span > i{\n\t\t\t\t\t\tfont-size: 22px;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select] + div dl dd.xm-select-dd-search > span > i:hover{\n\t\t\t\t\t\tcolor: red;\n\t\t\t\t\t\topacity:.8;\n\t\t\t\t\t\tfilter:alpha(opacity=80);\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select] + div dl p.xm-select-search-empty{\n\t\t\t\t\t\tmargin: 10px 0;\n\t\t\t\t\t    text-align: center;\n\t\t\t\t\t    color: #999;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select][xm-select-type=\'1\'] + div dl dd.xm-select-this,select[xm-select]:not([xm-select-type]) + div dl dd.xm-select-this{\n\t\t\t\t\t\tbackground-color: #5FB878;\n\t\t\t\t\t\tcolor: #FFF;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select][xm-select-type=\'1\'] + div dl dd.layui-disabled,select[xm-select]:not([xm-select-type]) + div dl dd.layui-disabled{\n\t\t\t\t\t\tbackground-color: #FFFFFF;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select][xm-select-type=\'2\'] + div dl dd.layui-disabled i{\n\t\t\t\t\t\tborder-color: #C2C2C2;\n\t\t\t\t\t\tcolor: #FFFFFF;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select][xm-select-type=\'2\'] + div dl dd.xm-select-this.layui-disabled i{\n\t\t\t\t\t\tbackground-color: #D2D2D2;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select][xm-select-type=\'2\'] + div dl dd.xm-select-this:not(.layui-disabled) i{\n\t\t\t\t\t\tbackground-color: #5FB878;\n\t\t\t\t\t\tborder-color: #5FB878;\n\t\t\t\t\t\tcolor: #FFF;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select][xm-select-type=\'3\'] + div dl dd.xm-select-this:not(.layui-disabled){\n\t\t\t\t\t\tcolor: #5FB878;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select][xm-select-type=\'3\'] + div dl dd.xm-select-this i{\n\t\t\t\t\t\tposition: absolute;\n\t\t\t\t\t\tright: 10px;\n\t\t\t\t\t}\n\t\t\t\t\t\n\t\t\t\t';
		},
		cssColor: function cssColor(name, spanBgColor, spanColor, iBgColor, iColor, borderColor, tBgColor, tColor) {
			return '\n\t\t\t\t\tselect[xm-select][xm-select-skin=\'' + name + '\'] + div .layui-select-title > div.xm-select > span:not(.xm-select-empty){\n\t\t\t\t\t\tbackground: ' + spanBgColor + ';\n\t\t\t\t\t\tcolor: ' + spanColor + ';\n\t\t\t\t\t\tborder: 1px solid ' + borderColor + '\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select][xm-select-skin=\'' + name + '\'] + div .layui-select-title > div.xm-select > span:not(.xm-select-empty) i{\n\t\t\t\t\t\tbackground: ' + iBgColor + ';\n\t\t\t\t\t\tcolor: ' + iColor + ';\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select][xm-select-skin=\'' + name + '\'] + div .layui-select-title > div.xm-select > span:not(.xm-select-empty) i:hover{\n\t\t\t\t\t\topacity:.8;\n\t\t\t\t\t\tfilter:alpha(opacity=80);\n\t\t\t\t\t\tcursor: pointer;\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select][xm-select-skin=\'' + name + '\'][xm-select-type=\'1\'] + div dl dd.xm-select-this:not(.layui-disabled),select[xm-select][xm-select-skin=\'' + name + '\']:not([xm-select-type]) + div dl dd.xm-select-this:not(.layui-disabled){\n\t\t\t\t\t\tbackground-color: ' + tBgColor + ';\n\t\t\t\t\t\tcolor: ' + tColor + ';\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select][xm-select-skin=\'' + name + '\'][xm-select-type=\'2\'] + div dl dd.xm-select-this:not(.layui-disabled) i{\n\t\t\t\t\t\tbackground-color: ' + tBgColor + ';\n\t\t\t\t\t\tborder-color: ' + tBgColor + ';\n\t\t\t\t\t\tcolor: ' + tColor + ';\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select][xm-select-skin=\'' + name + '\'][xm-select-type=\'3\'] + div dl dd.xm-select-this:not(.layui-disabled){\n\t\t\t\t\t\tcolor: ' + tBgColor + ';\n\t\t\t\t\t}\n\t\t\t\t\tselect[xm-select][xm-select-type=\'3\'] + div dl dd.xm-select-this i{\n\t\t\t\t\t\tposition: absolute;\n\t\t\t\t\t\tright: 10px;\n\t\t\t\t\t}\n\t\t\t\t';
		},
		renderCss: function renderCss() {
			return '\n\t\t\t\t\tselect[xm-select] + div .layui-select-title > div.xm-select > span:not(.xm-select-empty){\n\t\t\t\t\t\tbox-sizing: content-box;\n\t\t\t\t\t}\n\t\t\t\t\t.xm-select-parent .layui-form-select dl dd.layui-this{\n\t\t\t\t\t    background-color: inherit;\n\t\t\t\t\t    color: inherit;\n\t\t\t\t\t}\n\t\t\t\t\t.xm-select-parent .layui-form-select dl dd.layui-this.layui-select-tips {\n\t\t\t\t\t\tbackground-color: #FFFFFF;\n\t\t\t\t\t    color: #999999;\n\t\t\t\t\t}\n\t\t\t\t\t.xm-select-parent .layui-form-selected dl {\n\t\t\t\t\t    display: none;\n\t\t\t\t\t}\n\t\t\t\t\t.xm-select-show:{\n\t\t\t\t\t\tdisplay: block;\n\t\t\t\t\t}\n\t\t\t\t\t.xm-select-hidn:{\n\t\t\t\t\t\tdisplay: none;\n\t\t\t\t\t}\n\t\t\t\t';
		}
	};
	commons.methods.run();
	return select3;
});
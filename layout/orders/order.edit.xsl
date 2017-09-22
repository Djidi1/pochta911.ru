<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="container[@module = 'order']">
        <xsl:variable name="no_edit">
            <xsl:if test="(order/id > 0) and (/page/body/module[@name='CurentUser']/container/group_id = 2
                                        and /page/body/module[@name='orders']/container/routes/item/status_id != 1)">1</xsl:if>
        </xsl:variable>
        <div class="row">
            <input class="today-date" type="hidden" value="{@today}"/>
            <form id="order_edit" class="order_edit" action="/orders/orderUpdate-{order/id}/without_menu-1/" method="post" name="main_form">
                <div class="col-sm-8">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-5">
                                    <xsl:if test="not(order/id)">
                                        <strong>Новый заказ</strong>
                                    </xsl:if>
                                    <xsl:if test="order/id > 0">
                                        <strong>Заказ № <xsl:value-of select="order/id"/></strong>
                                    </xsl:if>
                                </div>
                                <div class="col-xs-7" style="text-align:right;">
                                    <span class="his_time_now"/>
                                    <input type="hidden" id="time_now" value="{@time_now}"/>
                                </div>
                            </div>
                        </div>
                        <div class="panel-body">
                            <input id="order_id" type="hidden" name="order_id" value="{order/id}"/>
                            <input id="id_user" type="hidden" name="id_user" value="{order/id_user}"/>

                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="input-group">
                                        <xsl:if test="(/page/body/module[@name='CurentUser']/container/group_id = 2)">
                                            <div class="input-group-addon">Отправитель:</div>
                                        </xsl:if>
                                        <xsl:if test="(/page/body/module[@name='CurentUser']/container/group_id != 2)">
                                            <div class="input-group-addon">Выберите заказчика:</div>
                                        </xsl:if>
                                        <select class="form-control select2" name="new_user_id" onchange="set_sender();">
                                            <xsl:for-each select="users/item">
                                                <xsl:if test="(/page/body/module[@name='CurentUser']/container/group_id != 2) or ../../@user_id = id">
                                                    <option value="{id}" phone="{phone}" sender="{name}" pay_type="{pay_type}" from="{from}" from_region="{from_region}" from_AOGUID="{from_AOGUID}" from_house="{from_house}" from_appart="{from_appart}" from_comment="{from_comment}">
                                                        <xsl:if test="../../order/id_user = id or (not(../../order/id_user) and ../../@user_id = id)">
                                                            <xsl:attribute name="selected">selected</xsl:attribute>
                                                        </xsl:if>

                                                        <xsl:value-of select="title"/> [<xsl:value-of select="phone"/>]
                                                    </option>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-3 col-xs-6">
                                    <strong>Дата доставки</strong>
                                </div>
                                <div class="col-sm-3 col-xs-6">
                                    <input class="form-control date-picker" type="text" name="date" onkeyup="check_user(this)" value="{order/date}" size="30" required="">
                                        <!--<xsl:if test="not(order/date)">-->
                                            <!--<xsl:attribute name="value">-->
                                                <!--<xsl:value-of select="@today"/>-->
                                            <!--</xsl:attribute>-->
                                        <!--</xsl:if>-->
                                    </input>
                                </div>
                                <xsl:if test="order/id > 0">
                                    <div class="col-sm-2 col-xs-4">
                                        <label>Курьер</label>
                                    </div>
                                    <div class="col-sm-4 col-xs-8">
                                        <select class="form-control" name="car_courier" title="Курьер">
                                            <xsl:if test="/page/body/module[@name='CurentUser']/container/group_id = 2">
                                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                                            </xsl:if>
                                            <option value="0">Не назначен</option>
                                            <xsl:variable name="courier_id" select="order/id_car"/>
                                            <xsl:for-each select="couriers/item">
                                                <option value="{id}">
                                                    <xsl:if test="id = $courier_id">
                                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:value-of select="fio"/> (<xsl:value-of select="car_number"/>)
                                                </option>
                                            </xsl:for-each>
                                        </select>
                                    </div>
                                </xsl:if>
                            </div>

                            <label>Откуда</label>
                            <xsl:call-template name="from_address"/>

                            <label>Куда</label>
                            <xsl:call-template name="addresses">
                                <xsl:with-param name="no_edit" select="$no_edit"/>
                            </xsl:call-template>
                        </div>
                        <div class="panel-footer">
                            <div class="row">
                                <div class="col-sm-4" style="text-align: center">
                                    <a href="/" class="btn btn-warning"><span class="glyphicon glyphicon-circle-arrow-left"/> Выйти без сохранения</a>
                                </div>
                                <xsl:if test="$no_edit != 1">
                                    <div class="col-sm-4" style="text-align: center">
                                        <span class="btn btn-info calc_route" onclick="calc_route(1)">Рассчитать маршрут</span>
                                    </div>
                                    <div class="col-sm-4" style="text-align: center">
                                        <input class="btn btn-success btn-submit" type="button" value="Сохранить заказ" onclick="return test_time_all_routes()"/>
                                    </div>
                                </xsl:if>
                            </div>
                            <br/>
                            <xsl:if test="$no_edit = 1">
                                <div class="alert alert-warning" style="margin: 0 15px">
                                    Если вы хотетите отредактировать или отменить заказ свяжитесь, пожалуйста, с оператором по телефону: <b>407-24-52</b>
                                </div>
                            </xsl:if>
                            <xsl:if test="order/dk">
                                <div style="text-align:right" class="small text-muted">Изменен: <xsl:value-of select="order/dk"/></div>
                            </xsl:if>
                        </div>
                    </div>
                </div>
                <div class="col-sm-4 map-form">
                    <div class="map-container">
                        <div class="map-info">
                            <span id="ShortInfo"/>
                            <div class="map-full-info" id="viewContainer"/>
                        </div>
                        <div id="map" style="width: 100%; min-height: 500px"/>
                    </div>
                    <div class="alert alert-info">
                        <span class="delivery_sum"/>
                    </div>
                </div>
            </form>
            <div style="display:none">
                <xsl:for-each select="g_price/item">
                    <input id="g_price_{id}" class="g_prices" type="hidden" value="{value}" goods_id="{goods_id}" condition="{condition}" price="{price}" fixed="{fixed}" mult="{mult}" rel="{goods_name}"/>
                </xsl:for-each>
                <xsl:for-each select="prices/item">
                    <input id="km_{id}" class="km_cost" type="hidden" value="{km_cost}" km_from="{km_from}" km_to="{km_to}"/>
                </xsl:for-each>
                <xsl:for-each select="add_prices/item">
                    <input id="km_{type}" type="hidden" value="{cost_route}"/>
                </xsl:for-each>
                <xsl:for-each select="times/node()">
                    <input id="{name()}_from" type="hidden" value="{from}"/>
                    <input id="{name()}_to" type="hidden" value="{to}"/>
                    <input id="{name()}_period" type="hidden" value="{period}"/>
                </xsl:for-each>
                <input id="user_fix_price" type="hidden" value="{//@user_fix_price}"/>
            </div>
        </div>
        <input id="order_edited" type="hidden" value="0"/>
        <input id="time_edited" type="hidden" value="0"/>
        <input id="order_id" type="hidden" value="{order/id}"/>
        <script>
            $('FORM').on('keyup keypress', function(e) {
                var keyCode = e.keyCode || e.which;
                if (keyCode === 13) { e.preventDefault(); return false; }
            });
            $('input, select').on('change', function() {
                $('#order_edited').val(1);
            });
            $('select.time_ready_from, select.time_ready_end, select.to_time, select.to_time_end, select.to_time_target, input[name=date]').on('change', function() {
                $('#time_edited').val(1);
            });
            if ($('#order_id').val() == ''){
                set_sender();
            }
        </script>
    </xsl:template>
    <xsl:template name="from_address">
        <div class="row">
            <div class="col-sm-12">
                <div class="input-group from-block" rel="{position()}">
                    <div class="form-control" style="width: 60%;">
                        <span class="order-add-title text-info">Адрес</span>
                        <input type="search" class="order-route-data spb-streets js-street_upper" name="from[]" title="Улица, проспект и т.д." value="{order/from}" onchange="" autocomplete="off" required="" region="{order/from_region}"/>
                        <input type="hidden" class="region" name="from_region[]" value="{order/from_region}"/>
                        <input type="hidden" class="AOGUID" name="from_AOGUID[]" value="{order/from_AOGUID}"/>
                    </div>
                    <div class="form-control" style="width: 20%;">
                        <span class="order-add-title text-info">дом/корп/строение</span>
                        <select type="text" class="order-route-data house number" name="from_house[]" title="Дом" value="{order/from_house}" onchange="calc_route(1)" autocomplete="off" required="" AOGUID="{order/from_AOGUID}">
                            <option value="{order/from_house}"><xsl:value-of select="order/from_house"/></option>
                        </select>
                    </div>
                    <div class="form-control" style="width: 20%;">
                        <span class="order-add-title text-info">кв/офис/помещ</span>
                        <input type="text" class="order-route-data number" name="from_appart[]" title="Квартира" value="{order/from_appart}" required=""/>
                    </div>

                    <div class="form-control" style="width: 30%;">
                        <span class="order-add-title text-warning">Отправитель ФИО</span>
                        <input type="text" class="order-route-data" name="from_fio[]" title="Отправитель" value="{order/from_fio}" required=""/>
                    </div>
                    <div class="form-control" style="width: 30%;">
                        <span class="order-add-title text-warning">
                            Телефон отправителя
                        </span>
                        <input type="text" class="order-route-data phone-number" name="from_phone[]" title="Телефон отправителя" value="{order/from_phone}" required=""/>
                    </div>
                    <div class="form-control" style="width: 20%;">
                        <span class="order-add-title text-danger">
                            Забрать с
                        </span>
                        <xsl:call-template name="time_selector">
                            <xsl:with-param name="select_class">order-route-data number time_ready_from</xsl:with-param>
                            <xsl:with-param name="select_name">time_ready_from[]</xsl:with-param>
                            <xsl:with-param name="select_title">Время забора с</xsl:with-param>
                            <xsl:with-param name="select_value" select="order/time_ready_from"/>
                            <xsl:with-param name="select_onchange">update_time_ready_from(this)</xsl:with-param>
                        </xsl:call-template>
                    </div>
                    <div class="form-control" style="width: 20%;">
                        <span class="order-add-title text-danger">
                            Забрать по
                        </span>
                        <xsl:call-template name="time_selector">
                            <xsl:with-param name="select_class">order-route-data number time_ready_end</xsl:with-param>
                            <xsl:with-param name="select_name">time_ready_end[]</xsl:with-param>
                            <xsl:with-param name="select_title">Время забора по</xsl:with-param>
                            <xsl:with-param name="select_value" select="order/time_ready_end"/>
                            <xsl:with-param name="select_onchange">update_time_ready_end(this)</xsl:with-param>
                        </xsl:call-template>
                    </div>
                    <textarea name="from_comment[]" class="form-control" title="Комментарий" placeholder="Примечания к адресу"  style="width: 100%;">
                        <xsl:value-of select="order/from_comment"/>
                    </textarea>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template name="addresses">
        <xsl:param name="no_edit"/>
        <xsl:for-each select="routes/item">
            <xsl:call-template name="routes">
                <xsl:with-param name="no_edit" select="$no_edit"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="routes">
        <xsl:param name="no_edit"/>
        <div class="input-group routes-block" rel="{position()}">
            <div class="form-control" style="width: 60%;">
                <span class="order-add-title text-info">Адрес доставки</span>
                <input type="search" class="order-route-data spb-streets js-street_upper" name="to[]" title="Улица, проспект и т.д." value="{to}" onchange="" autocomplete="off" required="" region="{to_region}"/>
                <input type="hidden" class="region" name="to_region[]" value="{to_region}"/>
                <input type="hidden" class="AOGUID" name="to_AOGUID[]" value="{to_AOGUID}"/>
            </div>
            <div class="form-control" style="width: 20%;">
                <span class="order-add-title text-info">дом/корп/строение</span>
                <select type="text" class="order-route-data house number" name="to_house[]" title="Дом" value="{to_house}" onchange="calc_route(1)" autocomplete="off" required="" AOGUID="{to_AOGUID}">
                    <option value="{to_house}"><xsl:value-of select="to_house"/></option>
                </select>
            </div>
            <div class="form-control" style="width: 20%;">
                <span class="order-add-title text-info">кв/офис/помещ</span>
                <input type="text" class="order-route-data number" name="to_appart[]" title="Квартира" value="{to_appart}" required=""/>
            </div>


            <div class="form-control" style="width: 50%;">
                <span class="order-add-title text-warning">Получатель ФИО</span>
                <input type="text" class="order-route-data" name="to_fio[]" title="Получатель" value="{to_fio}" required=""/>
            </div>
            <div class="form-control" style="width: 50%;">
                <span class="order-add-title text-warning">
                    Телефон получателя
                </span>
                <input type="text" class="order-route-data phone-number" name="to_phone[]" title="Телефон получателя" value="{to_phone}" required=""/>
            </div>

<!-- Строка времени -->

            <div class="form-control target_select" style="width: 50%;">
                <xsl:if test="target != 1 or not(target)">
                    <xsl:attribute name="style">width: 50%; display:none;</xsl:attribute>
                </xsl:if>
                <span class="order-add-title text-primary">
                    Доставить К
                </span>
                <xsl:call-template name="time_selector">
                    <xsl:with-param name="select_class">order-route-data number to_time_target</xsl:with-param>
                    <xsl:with-param name="select_name">target_time[]</xsl:with-param>
                    <xsl:with-param name="select_title">Время доставки</xsl:with-param>
                    <xsl:with-param name="select_value" select="to_time"/>
                    <xsl:with-param name="select_onchange">test_time_routes_add(); time_routes_set(this); $('.to_time').val($(this).val());$('.to_time_end').val($(this).val());</xsl:with-param>
                </xsl:call-template>
            </div>
            <div class="form-control period_select" style="width: 25%;">
                <xsl:if test="target = 1">
                    <xsl:attribute name="style">width: 25%; display:none;</xsl:attribute>
                </xsl:if>
                <span class="order-add-title text-primary">
                    Доставить С
                </span>
                <xsl:call-template name="time_selector">
                    <xsl:with-param name="select_class">order-route-data number to_time</xsl:with-param>
                    <xsl:with-param name="select_name">to_time[]</xsl:with-param>
                    <xsl:with-param name="select_title">Время доставки с</xsl:with-param>
                    <xsl:with-param name="select_value" select="to_time"/>
                    <xsl:with-param name="select_onchange">test_time_routes_add(); $('.to_time_target').val($(this).val());</xsl:with-param>
                </xsl:call-template>
            </div>
            <div class="form-control period_select" style="width: 25%;">
                <xsl:if test="target = 1">
                    <xsl:attribute name="style">width: 25%; display:none;</xsl:attribute>
                </xsl:if>
                <span class="order-add-title text-primary">
                    Доставить По
                </span>
                <xsl:call-template name="time_selector">
                    <xsl:with-param name="select_class">order-route-data number to_time_end</xsl:with-param>
                    <xsl:with-param name="select_name">to_time_end[]</xsl:with-param>
                    <xsl:with-param name="select_title">Время доставки по</xsl:with-param>
                    <xsl:with-param name="select_value" select="to_time_end"/>
                    <xsl:with-param name="select_onchange">test_time_routes_add()</xsl:with-param>
                </xsl:call-template>
            </div>

            <div class="form-control" style="width: 50%;">
                <span class="order-add-title text-warning">
                </span>
                <div class="funkyradio">
                    <div class="funkyradio-success">
                        <input type="checkbox" id="checkbox_{position()}" class="target" name="target" value="1" onchange="calc_route(1); target_time_show()" >
                            <xsl:if test="target = 1">
                                <xsl:attribute name="checked"/>
                            </xsl:if>
                        </input>
                        <label for="checkbox_{position()}"><span>К точному времени</span></label>
                    </div>
                </div>
            </div>

<!-- Строка оплаты -->
            <div class="form-control" style="width: 20%;">
                <span class="order-add-title text-success">
                    Что доставляем?
                </span>
                <select class="order-route-data goods_type" name="goods_type[]" title="Тип товара" onchange="calc_route(1);" required="">
                    <xsl:variable name="goods_type" select="goods_type"/>
                    <option value=""> </option>
                    <xsl:for-each select="../../goods/item | goods/item">
                        <option value="{goods_id}">
                            <xsl:if test="goods_id = $goods_type">
                                <xsl:attribute name="selected">selected</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="goods_name"/>
                        </option>
                    </xsl:for-each>
                </select>
            </div>
            <div class="form-control" style="width: 10%;">
                <span class="order-add-title text-success">
                    Кол-во
                </span>
                <input type="number" class="order-route-data number goods_val" name="goods_val[]" title="Количество товара" value="{goods_val}" onchange="calc_route(1);" required=""/>
            </div>
            <div class="form-control" style="width: 20%;" title="Общая сумма наличных, которую необходимо забрать у получателя, включая  цену доставки если ее оплачивает получатель.">
                <span class="order-add-title text-success">
                    Инкассация
                </span>
                <input type="text" class="order-route-data number cost_tovar" name="cost_tovar[]" value="{cost_tovar}" onkeyup="re_calc(this)" required=""/>
            </div>
            <div class="form-control" style="width: 20%;">
                <span class="order-add-title text-success">
                    Цена доставки
                </span>
                <input type="text" class="order-route-data number cost_route" name="cost_route[]" title="Стоимость доставки" value="{cost_route}" onkeyup="re_calc(this)">
                    <xsl:if test="/page/body/module[@name='CurentUser']/container/group_id = 2 or /page/body/module[@name='CurentUser']/container/group_id = ''">
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="/page/body/module[@name='CurentUser']/container/group_id != 2 and /page/body/module[@name='CurentUser']/container/group_id != ''">
                        <xsl:attribute name="required">required</xsl:attribute>
                    </xsl:if>
                </input>
            </div>
            <div class="form-control" style="width: 30%;" title="Выберете способ оплаты наших услуг.">
                <span class="order-add-title text-success">
                    Оплата доставки
                </span>
                <xsl:if test="//@user_pay_type > 0">
                    <input type="hidden" name="pay_type[]" value="{//@user_pay_type}" />
                </xsl:if>
                <select class="order-route-data pay_type" name="pay_type[]" onchange="re_calc(this)" required="">
                    <xsl:if test="//@user_pay_type > 0">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                    <xsl:variable name="pay_type" select="pay_type"/>
                    <xsl:variable name="user_pay_type" select="//@user_pay_type"/>
                    <option value=""> </option>
                    <xsl:for-each select="../../pay_types/item | pay_types/item">
                        <option value="{id}">
                            <xsl:if test="id = $pay_type or (not($pay_type) and $user_pay_type = id)">
                                <xsl:attribute name="selected">selected</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="pay_type"/>
                        </option>
                    </xsl:for-each>
                </select>
            </div>
            <div class="form-control" style="width: 20%; display:none;">
                <span class="order-add-title text-success">
                    Общая сумма
                </span>
                <input type="text" class="order-route-data number cost_all" title="Инкассация" disabled="">
                <xsl:if test="string(number(cost_route)+number(cost_tovar)) != 'NaN'">
                    <xsl:attribute name="value">
                        <xsl:value-of select="(number(cost_route)+number(cost_tovar))"/>
                    </xsl:attribute>
                </xsl:if>
                </input>
            </div>
            <textarea name="to_comment[]" class="form-control" title="Комментарий" placeholder="Примечания к адресу"  style="width: 80%;">
                <xsl:if test="not(../../order/id)">
                    <xsl:attribute name="style">width:100%</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="to_comment"/>
            </textarea>

            <xsl:if test="../../order/id > 0">
                <div class="form-control" style="width: 20%;">
                    <span class="order-add-title text-success">
                        Статус
                    </span>

                        <select class="order-route-data" name="status[]" title="Статус заказа">
                            <xsl:if test="/page/body/module[@name='CurentUser']/container/group_id = 2 and status_id != 1">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                            <xsl:variable name="status_id" select="status_id"/>
                            <xsl:choose>
                                <xsl:when test="/page/body/module[@name='CurentUser']/container/group_id = 2 and status_id = 1">
                                    <xsl:for-each select="../../statuses/item">
                                        <!-- Либо Новый либо отмена -->
                                        <xsl:if test="id = 1 or id = 5">
                                            <option value="{id}">
                                                <xsl:if test="id = $status_id">
                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="status"/>
                                            </option>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="../../statuses/item">
                                        <option value="{id}">
                                            <xsl:if test="id = $status_id">
                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="status"/>
                                        </option>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </select>
                </div>
            </xsl:if>

            <xsl:if test="../../@is_single != 1 and $no_edit != 1">
                <div class="add_buttons" style="vertical-align: top; display:none">
                    <button type="button" class="btn-delete btn btn-sm btn-danger" title="Удалить" onclick="delete_div_row(this)">
                        <xsl:if test="position() = 1">
                            <xsl:attribute name="disabled"/>
                        </xsl:if>
                        <span class="glyphicon glyphicon-ban-circle" aria-hidden="true"/>
                    </button>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template name="time_selector">
        <xsl:param name="select_class"/>
        <xsl:param name="select_name"/>
        <xsl:param name="select_title"/>
        <xsl:param name="select_value"/>
        <xsl:param name="select_onchange"/>
        <select name="{$select_name}" class="{$select_class}" title="{$select_title}" required="">
            <xsl:if test="$select_onchange != ''">
                <xsl:attribute name="onchange">
                    <xsl:value-of select="$select_onchange"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="$select_name = 'time_ready_end[]'">
                <option value="-">∞</option>
            </xsl:if>
            <xsl:for-each select="../../timer/element | timer/element">
                <option value="{.}">
                    <xsl:if test=". = $select_value">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="not(../../order/id) and . = ../../@time_now_five and $select_name != 'to_time_ready_end[]'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                </option>
            </xsl:for-each>
        </select>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:include href="../orders/order.edit.xsl"/>
    <xsl:template match="container[@module = 'index']">
        <xsl:if test="//page/@isAjax != 1">
            <div class="row">
                <div class="camera_wrap">
                    <div data-src="images/image_1.jpg">
                        <div class="camera_caption fadeIn camera_effected">
                            <h1><i>СКОРАЯ <b>ПОЧТА</b></i></h1>
                            <h3>Мы спасаем ваше время</h3>
                        </div>
                    </div>
                    <div data-src="images/image_2.jpg">
                        <div class="camera_caption  fadeIn camera_effected">
                            <h1><i>СКОРАЯ <b>ПОЧТА</b></i></h1>
                            <h3>Мы спасаем ваше время</h3>
                        </div>
                    </div>
                    <div data-src="images/image_3.jpg">
                        <div class="camera_caption fadeIn camera_effected">
                            <h1><i>СКОРАЯ <b>ПОЧТА</b></i></h1>
                            <h3>Мы спасаем ваше время</h3>
                        </div>
                    </div>
                    <div data-src="images/image_4.jpg">
                        <div class="camera_caption fadeIn camera_effected">
                            <h1><i>СКОРАЯ <b>ПОЧТА</b></i></h1>
                            <h3>Мы спасаем ваше время</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <!--<div class="col-md-4">-->
                    <!--<div class="panel panel-info">-->
                        <!--<div class="panel-heading">-->
                            <!--<h3 class="panel-title">Добро пожаловать в Цветочное Такси!</h3>-->
                        <!--</div>-->
                        <!--<div id="viewListlang" class="panel-body">-->
                            <!--<p>Очень надеемся, что этот сайт сделает более легким и удобным наше общение.-->
                                <!--<br/>-->
                                <!--<br/>-->
                                <!--<strong>После регистрации вам будут доступны:</strong>-->
                            <!--</p>-->

                            <!--<ul>-->
                                <!--<li>форма заказа доставки цветов</li>-->
                                <!--<li>расчет стоимости доставки в режиме онлайн</li>-->
                                <!--<li>отслеживание состояние ваших заказов</li>-->
                                <!--<li>получение уведомлений об изменении статусов ваших заказов</li>-->
                                <!--<li>неограниченный доступ к истории своих заказов</li>-->
                                <!--&lt;!&ndash;&lt;!&ndash; <li>оплатить тур не выходя из дома и распечатать договор, ваучер и путевку (<span style="color:#FF8C00"><strong>после 10.10.2014</strong></span>)</li> &ndash;&gt;&ndash;&gt;-->
                                <!--&lt;!&ndash;<li>увидеть сколько мест осталось в продаже</li>&ndash;&gt;-->
                                <!--&lt;!&ndash;<li>получить информацию по выезду просто наведя курсор на нужный тур</li>&ndash;&gt;-->
                                <!--&lt;!&ndash;<li>по номеру заказа внести изменения и дополнения в свою заявку</li>&ndash;&gt;-->
                                <!--&lt;!&ndash;<li>посмотреть на карте места остановок автобуса</li>&ndash;&gt;-->
                                <!--&lt;!&ndash;<li>получить информацию важную и просто интересную</li>&ndash;&gt;-->
                                <!--&lt;!&ndash;<li>купить "горящую путевку" с хорошей скидкой</li>&ndash;&gt;-->
                                <!--&lt;!&ndash;<li>подобрать экскурсионную поездку или игру-квест для школьной группы</li>&ndash;&gt;-->
                                <!--&lt;!&ndash;<li>подписаться на рассылку, заказать обратный звонок и многое другое</li>&ndash;&gt;-->
                            <!--</ul>-->
                        <!--</div>-->
                    <!--</div>-->
                <!--</div>-->
                <div class="col-md-12">
                    <div class="panel panel-info">
                        <div class="panel-heading">

                            <!--<a href="#" title="" class="btn btn-warning btn-xs"-->
                               <!--style="color: #fff;width: 100px;float: right;">Перейти-->
                            <!--</a>-->
                            <h3 class="panel-title">Калькулятор доставки</h3>
                        </div>
                        <div class="panel-body">
                            <xsl:call-template name="calcOnMain"/>
                            <div style="display:none">
                                <xsl:for-each select="prices/item">
                                    <input id="km_{id}" class="km_cost" type="hidden" value="{km_cost}" km_from="{km_from}" km_to="{km_to}"/>
                                </xsl:for-each>
                                <xsl:for-each select="add_prices/item">
                                    <input id="km_{type}" type="hidden" value="{cost_route}"/>
                                </xsl:for-each>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--<div class="col-md-6">-->
                <!--&lt;!&ndash; НОВОСТИ &ndash;&gt;-->
                <!--<div class="comment-list">-->
                    <!--<xsl:call-template name="newsListIndex"/>-->
                <!--</div>-->
                <!--&lt;!&ndash; КОНЕЦ НОВОСТЕЙ &ndash;&gt;-->
            <!--</div>-->
            <br/>
            <br/>
        </xsl:if>
        <xsl:if test="//page/@isAjax = 1">
            Ajax!
        </xsl:if>
    </xsl:template>
    <xsl:template name="calcOnMain">
        <div class="col-sm-4">
            <div class="pre_order">
                <div class="alert alert-warning">
                    <span class="glyphicon glyphicon-info-sign"/>
                    <i> Введите адреса для моментального расчёта стоимости доставки:</i>
                </div>
                <hr/>
                <div class="row">
                    <div class="col-xs-12">
                        <div class="input-group" rel="{position()}" style="width: 100%;">
                            <div class="form-control" style="width: 70%;">
                                <span class="order-add-title text-info">Адрес отправления</span>
                                <input type="search" class="order-route-data spb-streets js-street_upper" name="from[]" title="Улица, проспект и т.д." onchange="" autocomplete="off" required=""/>
                            </div>
                            <div class="form-control" style="width: 30%;">
                                <span class="order-add-title text-info">дом/корп.</span>
                                <select type="text" class="order-route-data house number" name="from_house[]" title="Дом/Корпус" onchange="calc_route(1)" autocomplete="off" required="" AOGUID=""/>
                            </div>
                        </div>
                    </div>
                </div>
                <br/>
                <div class="row">
                    <div class="col-xs-12">
                        <div class="input-group" rel="{position()}" style="width: 100%;">
                            <div class="form-control" style="width: 70%;">
                                <span class="order-add-title text-info">Адрес доставки</span>
                                <input type="search" class="order-route-data spb-streets js-street_upper" name="to[]" title="Улица, проспект и т.д." onchange="" autocomplete="off" required=""/>
                            </div>
                            <div class="form-control" style="width: 30%;">
                                <span class="order-add-title text-info">дом/корп.</span>
                                <select type="text" class="order-route-data house number" name="to_house[]" title="Дом/Корпус" onchange="calc_route(1)" autocomplete="off" required="" AOGUID=""/>
                            </div>
                        </div>
                    </div>
                </div>
                <hr/>
                <span class="btn btn-info calc_route" onclick="calc_route(1)">Рассчитать доставку</span>
                <div class="delivery_sum_title">---</div>
                <hr/>
                <div class="alert alert-success add_order_main">
                    <span class="glyphicon glyphicon-ok-sign"/>
                    <xsl:text> </xsl:text>
                    <i>Вы можете прямо сейчас заказать доставку: </i>
                    <span class="btn btn-success btn-sm" onclick="add_order()">Оформить заказ</span>
                </div>
            </div>

            <div class="additional_block">

                <div class="alert alert-success add_order" style="display:none">
                    <span class="glyphicon glyphicon-ok-sign"/>
                    <xsl:text> </xsl:text>
                    <i>Остался один маленький шаг для оформления заказа.</i>
                    <span class="btn btn-success btn-sm" onclick="add_order()">Оформить заказ</span>
                </div>
                <!--<hr/>-->
                <!--<xsl:if test="/page/body/module[@name='CurentUser']/container/user_id = ''">-->
                    <!--<div class="alert alert-info">-->
                        <!--<span class="glyphicon glyphicon-ok-sign"/>-->
                        <!--<xsl:text> </xsl:text>-->
                        <!--<i><a href="#" class="text-danger" onclick="showThem('register_pop'); return false;"><b>Зарегистрируйтесь</b></a>, пожалуйста, чтобы мы могли осуществлять для вас доставки.</i>-->
                    <!--</div>-->
                <!--</xsl:if>-->
            </div>
            <div class="order_form" style="display:none">
                <div class="alert alert-success">
                    <span class="glyphicon glyphicon-info-sign"/>
                    <i> Для оформления заказа дополните заказ необходимой информацией:</i>
                </div>
                <form id="order_edit" class="order_edit" action="/orders/orderUpdate-0/without_menu-1/" method="post" name="main_form">
                    <input type="hidden" name="from_main_page" value="1"/>
                    <input type="hidden" name="id_user" value="0" class="id_user" />
                    <input type="hidden" name="order_id" value="0" id="order_id" />
                    <div class="row">
                        <div class="col-xs-6">
                            <strong>Дата доставки</strong>
                        </div>
                        <div class="col-xs-6">
                            <input class="form-control date-picker" type="text" name="date" onkeyup="check_user(this)" value="" size="30" required=""/>
                        </div>
                    </div>
                    <label>Откуда</label>
                    <xsl:call-template name="from_address"/>
                    <label>Куда</label>
                    <xsl:call-template name="routes">
                        <xsl:with-param name="no_edit" select="0"/>
                    </xsl:call-template>
                    <div class="col-sm-4" style="text-align: center">
                    </div>
                    <div class="col-sm-4" style="text-align: center">
                        <input class="btn btn-success btn-submit" type="button" value="Заказать доставку" onclick="test_time_all_routes(1)"/>
                    </div>
                </form>
                <xsl:for-each select="times/node()">
                    <input id="{name()}_from" type="hidden" value="{from}"/>
                    <input id="{name()}_to" type="hidden" value="{to}"/>
                    <input id="{name()}_period" type="hidden" value="{period}"/>
                </xsl:for-each>
                <xsl:for-each select="g_price/item">
                    <input id="g_price_{id}" class="g_prices" type="hidden" value="{value}" goods_id="{goods_id}" condition="{condition}" price="{price}" fixed="{fixed}" mult="{mult}" rel="{goods_name}"/>
                </xsl:for-each>
                <span class="his_time_now small text-muted" style="float: right;"/>
                <input type="hidden" id="time_now" value="{@time_now}"/>
            </div>
        </div>
        <div class="col-sm-8">
            <div class="row">
                <div class="col-sm-12 map-form">
                    <div class="map-container">
                        <div class="map-info">
                            <span id="ShortInfo"/>
                            <div class="map-full-info" id="viewContainer"/>
                        </div>
                        <div id="map" style="width: 100%; min-height: 420px"/>
                    </div>
                </div>
            </div>
        </div>


    </xsl:template>
    <!-- НОВОСТИ НА ГЛАВНОЙ -->
    <xsl:template name="newsListIndex">
            <div class="panel panel-info arrow left">
                <div class="panel-heading">
                    <h3 class="panel-title">Новости</h3>
                </div>
                <div class="panel-body">
                  <xsl:for-each select="news/item">
                    <header class="text-left">
                        <span class="label label-info" style="float: right;">
                            <time class="comment-date" datetime="{time}">
                                <i class="fa fa-clock-o"/>
                                <xsl:text> </xsl:text><xsl:value-of select="time"/>
                            </time>
                        </span>
                        <div class="comment-user">
                            <i class="fa fa-user"/>
                            <xsl:text> </xsl:text><xsl:value-of select="title"/>
                        </div>
                    </header>
                    <div class="comment-post">
                        <xsl:value-of select="content" disable-output-escaping="yes"/>
                    </div>
                    <xsl:if test="subject != ''">
                        <p class="text-right" style="margin: 0;"><a href="/news/view-{id}/" class="btn btn-warning btn-xs"><i class="fa fa-reply"/><xsl:text> </xsl:text>Подробнее</a></p>
                    </xsl:if>
                      <hr/>
                 </xsl:for-each>
                </div>
            </div>
    </xsl:template>
</xsl:stylesheet>
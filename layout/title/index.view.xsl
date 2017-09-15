<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="container[@module = 'index']">
        <xsl:if test="//page/@isAjax != 1">
            <div class="row">
                <div class="camera_wrap">
                    <div data-src="images/image_1.jpg">
                        <div class="camera_caption fadeIn camera_effected">
                            <h1>Цветочное Такси</h1>
                            <h3>Логистика для цветочных магазинов</h3>
                        </div>
                    </div>
                    <div data-src="images/image_2.jpg">
                        <div class="camera_caption  fadeIn camera_effected">
                            <h1>Цветочное Такси</h1>
                            <h3>Логистика для цветочных магазинов</h3>
                        </div>
                    </div>
                    <div data-src="images/image_3.jpg">
                        <div class="camera_caption fadeIn camera_effected">
                            <h1>Цветочное Такси</h1>
                            <h3>Логистика для цветочных магазинов</h3>
                        </div>
                    </div>
                    <div data-src="images/image_4.jpg">
                        <div class="camera_caption fadeIn camera_effected">
                            <h1>Цветочное Такси</h1>
                            <h3>Логистика для цветочных магазинов</h3>
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
                        <div id="viewListlang" class="panel-body">
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
            <div class="alert alert-warning">
                <span class="glyphicon glyphicon-info-sign"/>
                <i> Введите адреса для моментального расчёта стоимости доставки:</i>
            </div>
            <hr/>
            <div class="row">
                <div class="col-xs-12">
                    <div class="input-group routes-block" rel="{position()}" style="width: 100%;">
                        <div class="form-control" style="width: 70%;">
                            <span class="order-add-title text-info">Адрес отправления</span>
                            <input type="search" class="order-route-data spb-streets js-street_upper" name="to[]" title="Улица, проспект и т.д." onchange="" autocomplete="off" required=""/>
                        </div>
                        <div class="form-control" style="width: 30%;">
                            <span class="order-add-title text-info">дом/корп.</span>
                            <select type="text" class="order-route-data to_house number" name="to_house[]" title="Дом/Корпус" onchange="calc_route(1)" autocomplete="off" required="" AOGUID=""/>
                        </div>
                    </div>
                </div>
            </div>
            <br/>
            <div class="row">
                <div class="col-xs-12">
                    <div class="input-group routes-block" rel="{position()}" style="width: 100%;">
                        <div class="form-control" style="width: 70%;">
                            <span class="order-add-title text-info">Адрес доставки</span>
                            <input type="search" class="order-route-data spb-streets js-street_upper" name="to[]" title="Улица, проспект и т.д." onchange="" autocomplete="off" required=""/>
                        </div>
                        <div class="form-control" style="width: 30%;">
                            <span class="order-add-title text-info">дом/корп.</span>
                            <select type="text" class="order-route-data to_house number" name="to_house[]" title="Дом/Корпус" onchange="calc_route(1)" autocomplete="off" required="" AOGUID=""/>
                        </div>
                    </div>
                </div>
            </div>
            <hr/>
            <span class="btn btn-info calc_route" onclick="calc_route(1)">Рассчитать доставку</span>
            <div class="delivery_sum_title">---</div>
            <hr/>
            <div class="alert alert-info">
                <span class="glyphicon glyphicon-ok-sign"/>
                <xsl:text> </xsl:text>
                <i><a class="callme_viewform" href="#">Зарегистрируйтесь</a>, пожалуйста, чтобы мы могли осуществлять для вас доставки.</i>
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
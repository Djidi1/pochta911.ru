<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!--<xsl:include href="CSSnJS.header.xsl"/>-->
    <xsl:import href="CSSnJS.header.xsl"/>
    <xsl:template name="main_head">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:if test="//@fullscreen != 1">
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
            </xsl:if>
            <base href="."/>
            <title>Скорая Почта - мы экономим ваше время</title>
            <xsl:call-template name="css_js_header"/>
        </head>
    </xsl:template>
    <xsl:template name="main_headWrap">
        <div id="header">
            <nav class="navbar navbar-inverse">
                <div class="container-fluid">
                    <!-- Brand and toggle get grouped for better mobile display -->
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                                data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"/>
                            <span class="icon-bar"/>
                            <span class="icon-bar"/>
                        </button>
                        <a class="navbar-brand" href="/title/" title="Скорая Почта">
                            <img src="./images/logo.png?v3" alt="Logo"/>
                            <span class="header1" style="display:none;"/>
                        </a>
                    </div>

                    <!-- Collect the nav links, forms, and other content for toggling -->
                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <ul class="nav navbar-nav">
                            <xsl:if test="/page/body/module[@name='CurentUser']/container/group_id = 2">
                                <li class="dropdown">
                                    <a href="/orders/"><i class="fa fa-flag" aria-hidden="true"> </i> Заказы</a>
                                </li>
                                <li class="dropdown">
                                    <a href="/admin/userEdit-{/page/body/module[@name='CurentUser']/container/user_id}/"><i class="fa fa-user" aria-hidden="true"> </i> Карточка клиента</a>
                                </li>
                                <li>
                                    <a href="/pages/view-49/"><i class="fa fa-info" aria-hidden="true"> </i> Условия сотрудничества</a>
                                </li>
                            </xsl:if>
                            <xsl:if test="/page/body/module[@name='CurentUser']/container/group_id = 1 or /page/body/module[@name='CurentUser']/container/group_id = 3 or /page/body/module[@name='CurentUser']/container/group_id = 4">
                                <li>
                                    <a href="/orders/LogistList-1/"><i class="fa fa-bus" aria-hidden="true"> </i> Логистика</a>
                                </li>
                            </xsl:if>
                            <xsl:if test="/page/body/module[@name='CurentUser']/container/group_id = 1 or /page/body/module[@name='CurentUser']/container/group_id = 3 or /page/body/module[@name='CurentUser']/container/group_id = 4">
                                <li>
                                    <a href="/admin/carsList-1/"><i class="fa fa-car" aria-hidden="true"> </i> Автоштат</a>
                                </li>
                            </xsl:if>
                            <xsl:if test="/page/body/module[@name='CurentUser']/container/group_id = 1 or /page/body/module[@name='CurentUser']/container/group_id = 4">
                                <li>
                                    <a href="/admin/userList-1/idg-2/"><span class="glyphicon glyphicon-user"> </span> Клиенты</a>
                                </li>
                            </xsl:if>
                            <xsl:if test="/page/body/module[@name='CurentUser']/container/group_id = 1">
                                <li>
                                    <a href="/admin/userList-1/idg-0/"><span class="glyphicon glyphicon-user"> </span> Сотрудники</a>
                                </li>
                                <!--<li>-->
                                    <!--<a href="/admin/userList-1/idg-3/"><span class="glyphicon glyphicon-user"> </span> Логисты</a>-->
                                <!--</li>-->
                                <!--<li>-->
                                    <!--<a href="/admin/userList-1/idg-4/"><span class="glyphicon glyphicon-user"> </span> Операторы</a>-->
                                <!--</li>-->
                            </xsl:if>
                        </ul>
                        <script>
                            var now_path = window.location.pathname;
                            $('ul li a[href="'+now_path+'"]').parent().addClass('active');
                        </script>

                        <!--<form class="navbar-form navbar-left">-->
                            <!--<div class="form-group">-->
                                <!--<input type="text" class="form-control" placeholder="Search"/>-->
                            <!--</div>-->
                            <!--<button type="submit" class="btn btn-default">Submit</button>-->
                        <!--</form>-->

                        <div class="moduletable_LoginForm navbar-right">
                            <xsl:apply-templates
                                    select="//page/body/module[@name = 'CurentUser']/container[@module = 'login' and position() = 1]"/>
                            <!--				<div xmlns="" class="form"><div class="poping_links"><a href="/admin/" style="padding-right: 0px;">Менеджерам</a></div></div>-->
                        </div>
                        <div class="phone-in-header phone">
                            <span class="city-code">(812)</span> 242-80-81
                        </div>
                    </div><!-- /.navbar-collapse -->
                </div><!-- /.container-fluid -->
            </nav>
            <div class="mobile-sub-menu">
                <div class="slogan"/>
                <div class="moduletable_LoginForm login-mobile">
                    <xsl:apply-templates select="//page/body/module[@name = 'CurentUser']/container[@module = 'login']"/>
                </div>
                <div class="phone-in-header phone-mobile">
                    <span class="city-code">(812)</span> 242-80-81
                </div>
            </div>
        </div>
        <div id="loading2" style="display:none;">
            <div class="loading-block">
                <p class="title" style="text-align:center;">Пожалуйста, подождите...
                    <br/>
                    <img src="/images/anim_load.gif"/>
                </p>
            </div>
        </div>
    </xsl:template>
    <xsl:template name="bottom_block">
        <div id="foot">
            <p id="back-top" style="display: none;">
                <a href="#top">
                    <span/>
                </a>
            </p>
            <xsl:if test="/page/body/module[@name='CurentUser']/container/group_id = 1">
                <div class="moduletable">
                    <ul class="bottom-menu navbar-nav">
                        <li>
                            <a class="btn btn-default btn-xs" href="/pages/">
                                <span class="glyphicon glyphicon-file"> </span> Страницы
                            </a>
                        </li>
                        <li>
                            <a class="btn btn-default btn-xs" href="/news/newsadmin-1/">
                                <span class="glyphicon glyphicon-bullhorn"> </span> Новости
                            </a>
                        </li>
                        <li>
                            <a class="btn btn-default btn-xs" href="/admin/groupList-1/">
                                <i class="fa fa-users" aria-hidden="true"> </i> Группы
                            </a>
                        </li>
                        <li>
                            <a class="btn btn-default btn-xs" href="/admin/getTelegramUpdates-1/">
                                <i class="fa fa-telegram" aria-hidden="true"> </i> Телеграмм
                            </a>
                        </li>
                        <li>
                            <a class="btn btn-default btn-xs" href="/admin/price_routes-1/">
                                <i class="fa fa-money" aria-hidden="true"> </i> Стоимость
                            </a>
                        </li>
                        <li>
                            <a class="btn btn-default btn-xs" href="/admin/time_check_list-1/">
                                <i class="fa fa-clock-o" aria-hidden="true"> </i> Времена
                            </a>
                        </li>
                        <li>
                            <a class="btn btn-default btn-xs" href="/admin/goods_price_list-1/">
                                <i class="fa fa-archive" aria-hidden="true"> </i> Товары
                            </a>
                        </li>
                    </ul>
                </div>
            </xsl:if>
            <div class="well wrapper">
                <div class="footerText">
                    <div class="footer1">Copyright © <xsl:value-of select="//@year"/> Скорая почта
                    </div>
                    <div style="float: right;">
                        <!-- Yandex.Metrika counter --> <script type="text/javascript" > (function (d, w, c) { (w[c] = w[c] || []).push(function() { try { w.yaCounter28267031 = new Ya.Metrika({ id:28267031, clickmap:true, trackLinks:true, accurateTrackBounce:true, webvisor:true }); } catch(e) { } }); var n = d.getElementsByTagName("script")[0], s = d.createElement("script"), f = function () { n.parentNode.insertBefore(s, n); }; s.type = "text/javascript"; s.async = true; s.src = "https://mc.yandex.ru/metrika/watch.js"; if (w.opera == "[object Opera]") { d.addEventListener("DOMContentLoaded", f, false); } else { f(); } })(document, window, "yandex_metrika_callbacks"); </script> <noscript><div><img src="https://mc.yandex.ru/watch/28267031" style="position:absolute; left:-9999px;" alt="" /></div></noscript> <!-- /Yandex.Metrika counter -->
                    </div>
                </div>
            </div>
            <div style="text-align:center">
                <xsl:if test="//@fullscreen != 1">
                    <a href="?fullscreen=1">Полная версия</a>
                </xsl:if>
                <xsl:if test="//@fullscreen = 1">
                    <a href="?fullscreen=0">Адаптивная версия</a>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>

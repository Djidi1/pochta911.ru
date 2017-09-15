<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="container[@module = 'login']">
        <div class="form">
            <xsl:if test="login != 1">
                <xsl:call-template name="loginform"/>
            </xsl:if>
            <xsl:if test="login = 1">
                <xsl:call-template name="statusbar"/>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template name="loginform">
        <div class="poping_links">
            <ul class="nav navbar-nav">
                <li class="dropdown" style="float:left;">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#" onclick="showThem('login_pop');" id="openLogin">
                        <i class="glyphicon glyphicon-user"/> Войти
                    </a>
                </li>
            </ul>
        </div>
        <div id="login_pop" style="display: none;">
            <form id="login-form" action="/?login" method="post" name="form">
                <div class="module_login">
                    <div class="boxIndent">
                        <div class="wrapper">
                            <form action="#" method="post" id="login-form">
                                <strong class="msg-login">
                                    <xsl:value-of select="title"/>
                                </strong>
                                <xsl:if test="error != ''">
                                    <p class="alert alert-info">
                                        <xsl:value-of select="error"/>
                                    </p>
                                </xsl:if>
                                <p id="form-login-username">
                                    <label for="modlgn-username">Логин <span class="text-muted">(номер телефона)</span></label>
                                    <input id="modlgn-username" type="text" name="username" class="form-control" size="18" value=""/>
                                </p>
                                <p id="form-login-password">
                                    <label for="modlgn-passwd">Пароль</label>
                                    <input id="modlgn-passwd" type="password" name="userpass" class="form-control" size="18" value=""/>
                                </p>
                                <p id="form-login-password">
                                    <span class="btn btn-link" onclick="recover_password()">Забыли пароль?</span>
                                </p>
                                <div class="wrapper">
                                    <div class="create" style="text-align: right">
                                        <input type="submit" name="submit" value="Войти" class="btn btn-success"/>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </xsl:template>
    <xsl:template name="statusbar">
        <ul class="nav navbar-nav">
            <li class="dropdown" style="float:left;">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <i class="glyphicon glyphicon-user"/> <xsl:value-of select="error"/>
                    <i class="caret"/>
                </a>
                <ul class="dropdown-menu dropdown-user">
                    <!--<li>-->
                        <!--<xsl:value-of select="error"/>-->
                    <!--</li>-->
                    <li class="divider"/>
                    <li>
                        <a href="/?logout">
                            <i class="glyphicon glyphicon-log-out" title="Выход из системы"/>
                            Выход
                        </a>
                    </li>
                </ul>
            </li>
        </ul>
    </xsl:template>
</xsl:stylesheet>

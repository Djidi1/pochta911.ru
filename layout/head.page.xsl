<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Это гостевой заголовок - ТИТУЛЬНАЯ СТРАНИЦА -->
	<xsl:include href="CSSnJS.header.xsl"/>
	<xsl:template name="head">
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
			<xsl:if test="//@fullscreen != 1">
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
			</xsl:if>
			<base href="."/>
			<title>Доставка цветов</title>
			<xsl:call-template name="css_js_header"/>
			<script type="text/javascript" src="/callme/js/callme.js"/>
		</head>
	</xsl:template>
	<xsl:template name="headWrap">
		<xsl:variable name="content">
			<xsl:value-of select="//page/body/@contentContainer"/>
		</xsl:variable>
		<div id="header">
			<nav class="navbar navbar-default">
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
						<a class="navbar-brand" href="/" title="Доставка цветов">
							<img src="./images/logo.png?v3" alt="Logo"/>
							<span class="header1" style="display:none;">Доставка цветов</span>
						</a>
					</div>

					<!-- Collect the nav links, forms, and other content for toggling -->
					<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
						<ul class="nav navbar-nav">
							<li>
								<!--<a class="callme_viewform" href="#">Зарегистрироваться</a>-->
								<a href="#" onclick="showThem('register_pop'); return false;"><b class="text-danger">Зарегистрироваться</b></a>
							</li>
							<li>
								<a href="/pages/view-49/">Условия сотрудничества</a>
							</li>
						</ul>
						<script>
							var now_path = window.location.pathname;
							$('ul li a[href="'+now_path+'"]').parent().addClass('active');
						</script>


						<div class="moduletable_LoginForm navbar-right">
							<xsl:apply-templates select="//page/body/module[@name = 'CurentUser']/container[@module = 'login']"/>
						</div>
						<div class="phone-in-header phone">
							<span class="city-code">(812)</span> 407-24-52
						</div>
					</div><!-- /.navbar-collapse -->
				</div><!-- /.container-fluid -->
			</nav>
			<div id="register_pop" style="display: none;">
				<form id="register-form" action="/?register" method="post" name="form">
					<div class="module_login">
						<div class="boxIndent">
							<div class="wrapper">
								<p class="alert alert-info">Для регистрации на сайте заполните, пожалуйста, представленную форму и мы вышлем СМС с кодом подтверждения для доступа ко всем функциям сайта.</p>
								<p id="form-login-name">
									<label for="modlgn-name">Ваше имя</label>
									<input id="modlgn-name" type="text" name="name" class="form-control" size="18" value="" onblur="" onfocus=""/>
								</p>
								<p id="form-login-phone">
									<label for="modlgn-phone">Номер мобильного телефона</label>
									<input id="modlgn-phone" type="text" name="phone" class="form-control phone-number" maxlength="11"  placeholder="8XXXXXXXXXX"/>
								</p>
								<p id="form-login-desc">
									<label for="modlgn-desc">Цель регистрации</label>
									<input id="modlgn-desc" type="text" name="desc" class="form-control" maxlength="11"  placeholder="Доставка почты, цветов, подарков, документов..."/>
								</p>
								<div class="wrapper">
									<div class="create" style="text-align: right">
										<span class="btn btn-success" onclick="reg_form_submit(this)">Зарегистрироваться</span>
										<!--<span class="btn btn-success" onclick="reg_form_submit()">Зарегистрироваться</span>-->
									</div>
								</div>
							</div>
						</div>
					</div>
				</form>
				<script>
					function reg_form_submit(obj) {
						bootbox.hideAll()
						var $form = $(obj).closest('form');
						var formData = $form.serialize();
						$.post($form.attr("action"), formData, function(data) {
							bootbox.alert(data);
						});
						return false;
					};
				</script>
			</div>
			<div class="mobile-sub-menu">
				<div class="slogan">Логистика для цветочных магазинов</div>
				<div class="moduletable_LoginForm login-mobile">
					<xsl:apply-templates select="//page/body/module[@name = 'CurentUser']/container[@module = 'login']"/>
				</div>
				<div class="phone-in-header phone-mobile">
					<span class="city-code">(812)</span> 407-24-52
				</div>
			</div>
		</div>
		<div id="loading2" style="display:none;"><div class="loading-block"><p class="title" style="text-align:center;">Пожалуйста, подождите...<br/><img src="/images/anim_load.gif" /></p></div></div>
	</xsl:template>
</xsl:stylesheet>

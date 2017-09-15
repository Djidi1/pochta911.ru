<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/xhtml1/strict">
	<xsl:output method="html" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" indent="yes"/>
	<!-- <xsl:include href="head.page.xsl"/> -->
		<xsl:include href="head.page.xsl"/>

	<xsl:template match="/">
		<xsl:variable name="content">
			<xsl:value-of select="//page/body/@contentContainer"/>
		</xsl:variable>
		<html xmlns="http://www.w3.org/1999/xhtml">
					<xsl:call-template name="headPrint"/>

			<body>
			
			<xsl:apply-templates select="//page/body/module[@name = $content]"/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>

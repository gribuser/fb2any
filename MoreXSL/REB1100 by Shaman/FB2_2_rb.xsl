<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0"
xmlns="http://www.gribuser.ru/xml/fictionbook/2.0">
	<xsl:param name="saveimages" select="2"/>
	<xsl:param name="tocdepth" select="3"/>
	<xsl:param name="pagebreaks" select="3"/>
	<xsl:param name="toccut" select="1"/>
	<xsl:param name="skipannotation" select="1"/>
	<xsl:param name="NotesTitle" select="'Notes'"/>
	<xsl:include href="FB2_2_html_basics.xsl"/>
	<xsl:output method="html" encoding="windows-1251" omit-xml-declaration="yes" indent="no" version="4.0"/>
	<xsl:key name="note-link" match="fb:section" use="@id"/>
	<xsl:template match="/*">
		<html>
			<head>
				<title>
					<xsl:value-of select="fb:description/fb:title-info/fb:book-title"/>
				</title>
			</head>
			<body>
				<h1><xsl:apply-templates select="fb:description/fb:title-info/fb:book-title"/></h1>
					<h2>
					<small>
						<xsl:for-each select="fb:description/fb:title-info/fb:author">
								<b>
									<xsl:call-template name="author"/>
								</b>
						</xsl:for-each>
					</small>
				</h2>
				<xsl:if test="fb:description/fb:title-info/fb:sequence">
					<p>
						<xsl:for-each select="fb:description/fb:title-info/fb:sequence">
							<xsl:call-template name="sequence"/><xsl:text disable-output-escaping="yes">&lt;br&gt;</xsl:text>
						</xsl:for-each>
					</p>
				</xsl:if>
				<xsl:if test="$skipannotation = 0">
					<xsl:for-each select="fb:description/fb:title-info/fb:annotation">
						<div>
							<xsl:call-template name="annotation"/>
						</div>
						<hr/>
					</xsl:for-each>
				</xsl:if>
				<!-- BUILD TOC -->
				<xsl:if test="$tocdepth &gt; 0 and count(//fb:body[not(@name) or @name != 'notes']//fb:title) &gt; 1">
					<hr/>
					<ul>
						<xsl:apply-templates select="fb:body" mode="toc"/>
					</ul>
					<xsl:text disable-output-escaping="yes">&lt;hr size="0"&gt;</xsl:text>
				</xsl:if>
				<!-- BUILD BOOK -->
				<xsl:call-template name="DocGen"/>
			</body>
		</html>
	</xsl:template>


	<xsl:template match="fb:section">
		<xsl:call-template name="preexisting_id"/>
		<xsl:apply-templates select="fb:title"/>
		<div align="justify"><xsl:apply-templates select="fb:*[name()!='title']"/></div>
		<xsl:if test="(ancestor::fb:body/@name = 'notes' or count(ancestor::fb:section) &lt; $pagebreaks+1 or $pagebreaks=4) and not(fb:section)">
			<xsl:text disable-output-escaping="yes">&lt;hr size="0"&gt;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<!-- p -->
	<xsl:template match="fb:p"><xsl:if test="@id"><a name="{@id}"/></xsl:if><xsl:text disable-output-escaping="yes">&amp;thinsp;&amp;thinsp;&amp;thinsp;&amp;thinsp;&amp;thinsp;&amp;thinsp;</xsl:text><xsl:apply-templates/><xsl:text disable-output-escaping="yes">&lt;br&gt;</xsl:text></xsl:template>

	<!-- style -->
	<xsl:template match="fb:style">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- link -->
	<xsl:template match="fb:a">
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:value-of select="@xlink:href"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="(@type) = 'note'">
					<sup>
						<xsl:apply-templates/>
					</sup>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>

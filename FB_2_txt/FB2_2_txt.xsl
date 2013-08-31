<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0">
	<xsl:strip-space elements="*"/>
	<xsl:param name="skipannotation" select="1"/>
	<xsl:param name="brstr" select="'&#010;'"/>
	<xsl:param name="dblbr" select="1"/>
	<xsl:param name="indent-str"/>
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:key name="note-link" match="fb:section|fb:p" use="@id"/>

	<xsl:template match="*">
<xsl:value-of select="fb:description/fb:title-info/fb:book-title"/>
<xsl:value-of select="$brstr"/>
<xsl:for-each select="fb:description/fb:title-info/fb:author">	<xsl:call-template name="author"/>
<xsl:value-of select="$brstr"/>
</xsl:for-each>
<xsl:value-of select="$brstr"/>

<xsl:if test="fb:description/fb:title-info/fb:sequence">
<xsl:for-each select="fb:description/fb:title-info/fb:sequence"><xsl:call-template name="sequence"/></xsl:for-each>
<xsl:value-of select="$brstr"/>
</xsl:if>
<xsl:if test="$skipannotation &lt; 1"><xsl:for-each select="fb:description/fb:title-info/fb:annotation">
<xsl:call-template name="annotation"/>
<xsl:value-of select="$brstr"/>
</xsl:for-each></xsl:if>
				<!-- BUILD BOOK -->
<xsl:for-each select="fb:body">
<xsl:if test="position()!=1">
<xsl:value-of select="$brstr"/><xsl:value-of select="$brstr"/>
</xsl:if>

<xsl:if test="@name">
<xsl:value-of select="@name"/>
<xsl:value-of select="$brstr"/>
</xsl:if>
<!-- <xsl:apply-templates /> -->
<xsl:apply-templates/>
</xsl:for-each>
<xsl:value-of select="$brstr"/>
	</xsl:template>
	<!-- author template -->
<xsl:template name="author">
	<xsl:value-of select="fb:first-name"/>
	<xsl:text>&#032;</xsl:text>
	<xsl:if test="fb:middle-name and fb:middle-name!=''">
		<xsl:value-of select="fb:middle-name" />
		<xsl:text>&#032;</xsl:text>
	</xsl:if> 
	<xsl:value-of select="fb:last-name"/>
	<xsl:value-of select="$brstr"/>
</xsl:template>
	<!-- secuence template -->
<xsl:template name="sequence">
<xsl:value-of select="@name"/><xsl:if test="@number"><xsl:text>&#032;#</xsl:text><xsl:value-of select="@number"/></xsl:if>
<xsl:if test="fb:sequence">
	<xsl:for-each select="fb:sequence">
<xsl:call-template name="sequence"/>
</xsl:for-each>
</xsl:if></xsl:template>

<!-- description -->
<xsl:template match="fb:description">
<xsl:apply-templates/>
<xsl:value-of select="$brstr"/>
</xsl:template>
<!-- body -->
<xsl:template match="fb:body">
<xsl:value-of select="$brstr"/>
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="fb:section">
<xsl:value-of select="$brstr"/>
<xsl:apply-templates select="./*"/>
</xsl:template>
	
	
<!-- section/title -->
<xsl:template match="fb:title">
<xsl:value-of select="$brstr"/><xsl:value-of select="$brstr"/>
<xsl:apply-templates/>
<xsl:value-of select="$brstr"/>
</xsl:template>

	<!-- subtitle -->
<xsl:template match="fb:subtitle">
<xsl:value-of select="$brstr"/>
<xsl:apply-templates/>
<xsl:value-of select="$brstr"/><xsl:value-of select="$brstr"/>
</xsl:template>

<xsl:template match="fb:table">
<xsl:apply-templates/></xsl:template>
<xsl:template match="fb:tr"><xsl:value-of select="$brstr"/>+===================================<xsl:value-of select="$brstr"/><xsl:apply-templates/></xsl:template>
<xsl:template match="fb:td">
<xsl:if test="position()=1"><xsl:text>| </xsl:text></xsl:if>
<xsl:apply-templates/><xsl:text> | </xsl:text></xsl:template>
<!-- p -->
<xsl:template match="fb:p">
<xsl:value-of select="$indent-str"/>
<xsl:apply-templates/>
<xsl:value-of select="$brstr"/><xsl:if test="$dblbr &gt; 0"><xsl:value-of select="$brstr"/></xsl:if>
</xsl:template>

<xsl:template match="fb:p" mode="note">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="fb:title" mode="note">
<xsl:apply-templates mode="note"/><xsl:text disable-output-escaping="yes"> - </xsl:text>
</xsl:template>


<!--<xsl:template match="fb:strong">*<xsl:apply-templates/>*</xsl:template>
<xsl:template match="fb:emphasis">/<xsl:apply-templates/>/</xsl:template>-->
<xsl:template match="fb:sup|fb:sub">^<xsl:apply-templates/>^</xsl:template>
<xsl:template match="fb:strikethrough">-<xsl:apply-templates/>-</xsl:template>
<xsl:template match="fb:emphasis|fb:strong"><xsl:apply-templates/></xsl:template>
<xsl:template match="fb:style"><xsl:apply-templates/></xsl:template>

<xsl:template match="fb:a">
<xsl:choose>
<xsl:when test="(@type) = 'note'">
<xsl:choose>
<xsl:when test="starts-with(@xlink:href,'#')"><xsl:for-each select="key('note-link',substring-after(@xlink:href,'#'))">[<xsl:apply-templates mode="note"/>]</xsl:for-each></xsl:when>
<xsl:otherwise><xsl:for-each select="key('note-link',@xlink:href)">[<xsl:apply-templates mode="note"/>]</xsl:for-each></xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates/>
<xsl:if test="not(starts-with(@xlink:href,'#'))">
<xsl:apply-templates/>(<xsl:value-of select="@xlink:href"/>)
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="fb:empty-line">
<xsl:value-of select="$brstr"/><xsl:value-of select="$brstr"/>
</xsl:template>

<!-- annotation -->
<xsl:template name="annotation">
<xsl:apply-templates/>
<xsl:value-of select="$brstr"/>
</xsl:template>

<!-- epigraph -->
<xsl:template match="fb:epigraph">
<xsl:apply-templates/>
<xsl:value-of select="$brstr"/>
</xsl:template>

<!-- cite -->
<xsl:template match="fb:cite">
	<xsl:value-of select="$brstr"/><xsl:value-of select="$brstr"/>
	<xsl:apply-templates/>
	<xsl:value-of select="$brstr"/>
</xsl:template>


	<!-- cite/text-author -->
<xsl:template match="fb:text-author">
	<xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
	<xsl:apply-templates/>
	<xsl:value-of select="$brstr"/>
</xsl:template>
	<!-- date -->
<xsl:template match="fb:date">
	<xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
	<xsl:apply-templates/>
	<xsl:value-of select="$brstr"/>
</xsl:template>

<xsl:template match="fb:poem">
<xsl:apply-templates/>
</xsl:template>

	<!-- stanza -->
<xsl:template match="fb:stanza">
<xsl:apply-templates/>
<xsl:value-of select="$brstr"/>
</xsl:template>
	<!-- v -->
<xsl:template match="fb:v">
<xsl:text>		</xsl:text>
<xsl:apply-templates/>
<xsl:value-of select="$brstr"/>
</xsl:template>

</xsl:stylesheet>

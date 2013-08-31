<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0">	<xsl:output method="text" encoding="UTF-8"/>	<xsl:param name="encoding" select="1251"/>	<xsl:param name="saveimages" select="2"/>	<xsl:param name="skipannotation" select="1"/>	<xsl:key name="note-link" match="fb:section" use="@id"/>	<xsl:variable name="RTF_plain">\s0 \qj\snext0\f1\fs24\b0\i0\fi567\li0\ri0 </xsl:variable>	<xsl:variable name="RTF_style_H1">\s1 \qc\snext0\b\f0\fs32\fi0\li0\ri0 </xsl:variable>	<xsl:variable name="RTF_style_H2">\s2 \qc\snext0\b\f0\fs28\fi0\li0\ri0 </xsl:variable>	<xsl:variable name="RTF_style_H3">\s3 \qc\snext0\i0\fs26\f0\b\fi0\li0\ri0 </xsl:variable>	<xsl:variable name="RTF_style_H4">\s4 \qc\snext0\lang1049\f1\fs26\b\fi0\li0\ri0 </xsl:variable>	<xsl:variable name="RTF_style_H5">\s5 \qc\snext0\i\fs24\f1\b\fi0\li0\ri0 </xsl:variable>	<xsl:variable name="RTF_style_H6">\s6 \qc\snext0\s6\f1\b\fs24\fi0 </xsl:variable>	<xsl:variable name="RTF_style_Epi">\s10 \qj\snext\f1\fs22\b0\i1\li3000\fi400\ri0 </xsl:variable>	<xsl:variable name="RTF_style_EpiA">\s11 \qj\snext0\f1\fs22\b1\i0\li3000\fi400\ri0 </xsl:variable>	<xsl:variable name="RTF_style_Ann">\s12 \qj\snext0\f1\fs24\b0\i1\fi567\li0\ri0 </xsl:variable>			<xsl:variable name="RTF_style_Cite">\s13 \qj\snext0\f1\fs22\b0\i0\li1134\ri600 </xsl:variable>		<xsl:variable name="RTF_style_CiteA">\s14 \qj\snext0\f1\fs22\b1\i1\li1701\ri600 </xsl:variable>		<xsl:variable name="RTF_style_PoemTtl">\s15 \ql\snext0\f1\fs24\b1\i0\li2000\ri600\sb12 </xsl:variable>				<xsl:variable name="RTF_style_Stanz">\s16 \ql\snext0\f1\fs24\b0\i0\li2000\ri600 </xsl:variable>	<xsl:variable name="RTF_style_FootNote">\s17 \qj\snext0\f1\fs20\b0\i0\fi200\li0\ri0 </xsl:variable>	<xsl:variable name="RTF_style_FootNoteEpi">\s18 \qj\snext\f1\fs18\b0\i1\li1500\fi400\ri0 </xsl:variable>	<xsl:variable name="RTF_style_FootNoteEpiA">\s18 \qj\snext0\f1\fs18\b1\i0\li1500\fi400\ri0 </xsl:variable>	<xsl:variable name="RTF_style_FootNoteStanz">\s19 \ql\snext0\f1\fs18\b0\i0\li500\ri600 </xsl:variable>	<xsl:variable name="RTF_style_FootNoteCite">\s20 \qj\snext0\f1\fs18\b0\i0\li300\ri600 </xsl:variable>	<xsl:variable name="RTF_style_FootNoteCiteA">\s21 \qj\snext0\f1\fs18\b1\i1\li350\ri600 </xsl:variable>	<xsl:variable name="RTF_style_FootNotePoemTtl">\s22 \ql\snext0\f1\fs20\b1\i0\li2000\ri600\sb12 </xsl:variable>				<xsl:variable name="RTF_head_spacer">\s0 \ql\snext0\f1\fs24\b0\i0\fi567\sb0\sa0\li0\ri0 </xsl:variable>				           <xsl:template match="/*">{\rtf1\ansi\ansicpg<xsl:value-of select="$encoding"/>\deff0\deflang1049\deflangfe1049\deftab708{\fonttbl{\f0\fswiss\fprq2\fcharset204{\*\fname Arial CYR;}Arial;}{\f1\froman\fprq2\fcharset204{\*\fname Times New Roman CYR;}Times New Roman;}{\f2\fmodern\fprq1\fcharset204{\*\fname Courier New CYR;}Courier New;}}{\info{\title <xsl:value-of select="fb:description/fb:title-info/fb:book-title"/>}{\author <xsl:for-each select="fb:description/fb:title-info/fb:author"><xsl:call-template name="author"/></xsl:for-each>}}{\fet0 \ftnbj \ftnrstpg \ftnnar}{\stylesheet{<xsl:value-of select="$RTF_plain"/> Normal;}{<xsl:value-of select="$RTF_style_H1"/> heading 1;}{<xsl:value-of select="$RTF_style_H2"/> heading 2;}{<xsl:value-of select="$RTF_style_H3"/> heading 3;}{<xsl:value-of select="$RTF_style_H4"/> heading 4;}{<xsl:value-of select="$RTF_style_H5"/> heading 5;}{<xsl:value-of select="$RTF_style_H6"/> heading 6;}{<xsl:value-of select="$RTF_style_Epi"/> Epigraph;}{<xsl:value-of select="$RTF_style_EpiA"/> Epigraph Author;}{<xsl:value-of select="$RTF_style_Ann"/> Annotation;}{<xsl:value-of select="$RTF_style_Cite"/> Cite;}{<xsl:value-of select="$RTF_style_CiteA"/> Cite Author;}{<xsl:value-of select="$RTF_style_PoemTtl"/> Poem Title;}{<xsl:value-of select="$RTF_style_Stanz"/> Stanza;}{<xsl:value-of select="$RTF_style_FootNote"/> FootNote;}{<xsl:value-of select="$RTF_style_FootNoteEpi"/> FootNote Epigraph;}{<xsl:value-of select="$RTF_style_FootNoteEpiA"/> FootNote Epigraph Author;}{<xsl:value-of select="$RTF_style_FootNoteStanz"/> FootNote Stanza;}{<xsl:value-of select="$RTF_style_FootNoteCite"/> FootNote Cite;}{<xsl:value-of select="$RTF_style_FootNoteCiteA"/> FootNote Cite Author;}{<xsl:value-of select="$RTF_style_FootNotePoemTtl"/> FootNote Poem Title;}}\paperw11906\paperh16838\margl1417\margr850\margt1134\margb1134<!-- автор/название --><xsl:value-of select="$RTF_style_H1"/><xsl:for-each select="fb:description/fb:title-info/fb:author"><xsl:call-template name="author"/></xsl:for-each>\par<xsl:value-of select="$RTF_style_H1"/><xsl:value-of select="fb:description/fb:title-info/fb:book-title"/>\par<xsl:value-of select="$RTF_head_spacer"/>\par<!-- серия --><xsl:if test="fb:description/fb:title-info/fb:sequence"><xsl:for-each select="fb:description/fb:title-info/fb:sequence">\i1 <xsl:call-template name="sequence"/>\par<xsl:value-of select="$RTF_head_spacer"/>\par</xsl:for-each></xsl:if><!-- обложка --><xsl:if test="fb:description/fb:title-info/fb:coverpage and $saveimages &gt; 1">\fi0<xsl:apply-templates select="fb:description/fb:title-info/fb:coverpage/fb:image"/><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:if><xsl:if test="$skipannotation = 0"><!-- тех.инфа --><xsl:if test="fb:description/fb:document-info/fb:src-ocr"><xsl:value-of select="fb:description/fb:document-info/fb:src-ocr"/></xsl:if><xsl:if test="fb:description/fb:document-info/fb:src-url"><xsl:text disable-output-escaping="yes"> </xsl:text><xsl:value-of select="fb:description/fb:document-info/fb:src-url"/></xsl:if><xsl:if test="fb:description/fb:publish-info/fb:book-name">\par\'ab<xsl:value-of select="fb:description/fb:publish-info/fb:book-name"/>\'bb: </xsl:if><xsl:if test="fb:description/fb:publish-info/fb:publisher"><xsl:value-of select="fb:description/fb:publish-info/fb:publisher"/>; </xsl:if><xsl:if test="fb:description/fb:publish-info/fb:city"><xsl:value-of select="fb:description/fb:publish-info/fb:city"/>; </xsl:if><xsl:if test="fb:description/fb:publish-info/fb:year"><xsl:value-of select="fb:description/fb:publish-info/fb:year"/></xsl:if><xsl:if test="fb:description/fb:publish-info/fb:isbn">\parISBN <xsl:value-of select="fb:description/fb:publish-info/fb:isbn"/></xsl:if><xsl:if test="fb:description/fb:custom-info[@info-type='src-book-title']">\par Оригинал:<xsl:text disable-output-escaping="yes"> </xsl:text><xsl:if test="fb:description/fb:custom-info[@info-type='src-author-first-name']"><xsl:value-of select="fb:description/fb:custom-info[@info-type='src-author-first-name']"/><xsl:text disable-output-escaping="yes"> </xsl:text><xsl:value-of select="fb:description/fb:custom-info[@info-type='src-author-last-name']"/>, </xsl:if>“<xsl:value-of select="fb:description/fb:custom-info[@info-type='src-book-title']"/>”<xsl:if test="fb:description/fb:custom-info[@info-type='src-year']">, <xsl:value-of select="fb:description/fb:custom-info[@info-type='src-year']"/></xsl:if>\par<xsl:if test="fb:description/fb:title-info/fb:translator">Перевод:<xsl:text disable-output-escaping="yes"> </xsl:text><xsl:for-each select="fb:description/fb:title-info/fb:translator"><xsl:call-template name="author"/></xsl:for-each>\par</xsl:if></xsl:if><xsl:value-of select="$RTF_head_spacer"/>\par<!-- аннотация --><xsl:for-each select="fb:description/fb:title-info/fb:annotation"><xsl:value-of select="$RTF_style_H2"/>\'c0\'ed\'ed\'ee\'f2\'e0\'f6\'e8\'ff\par<xsl:value-of select="$RTF_head_spacer"/>\par<xsl:apply-templates select="."/><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:for-each></xsl:if><!-- Тело текста --><xsl:for-each select="fb:body"><xsl:if test="position()!=1"></xsl:if><xsl:if test="not(@name) or @name != 'notes'"><xsl:apply-templates/></xsl:if></xsl:for-each>}</xsl:template><!-- author template --><xsl:template name="author"><xsl:value-of select="normalize-space(fb:first-name)"/><xsl:if test="fb:middle-name"><xsl:text disable-output-escaping="no">&#032;</xsl:text><xsl:value-of select="normalize-space(fb:middle-name)"/></xsl:if><xsl:if test="fb:last-name"><xsl:text disable-output-escaping="no">&#032;</xsl:text><xsl:value-of select="normalize-space(fb:last-name)"/></xsl:if><xsl:text disable-output-escaping="no">&#032;</xsl:text></xsl:template><!-- secuence template --><xsl:template name="sequence"><xsl:value-of select="$RTF_style_H2"/><xsl:value-of select="@name"/> \endash  <xsl:if test="@number"><xsl:value-of select="@number"/></xsl:if></xsl:template><!-- description --><xsl:template match="fb:description"><xsl:apply-templates/></xsl:template><!-- body --><xsl:template match="fb:body"><xsl:apply-templates/></xsl:template><xsl:template match="fb:section"><xsl:apply-templates/>\par</xsl:template>		<!-- section/title --><xsl:template match="fb:section/fb:title"><xsl:choose><xsl:when test="count(ancestor::node()) &lt;= 4"><xsl:value-of select="$RTF_style_H2"/><xsl:apply-templates/><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:when><xsl:when test="count(ancestor::node()) = 5"><xsl:value-of select="$RTF_style_H3"/><xsl:apply-templates/><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:when><xsl:when test="count(ancestor::node()) = 6"><xsl:value-of select="$RTF_style_H4"/><xsl:apply-templates/><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:when><xsl:when test="count(ancestor::node()) = 7"><xsl:value-of select="$RTF_style_H5"/><xsl:apply-templates/><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:when><xsl:otherwise><xsl:value-of select="$RTF_style_H6"/><xsl:apply-templates/><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:otherwise></xsl:choose></xsl:template><!-- footnotes --><xsl:template match="fb:section/fb:title" mode="footnote"><xsl:value-of select="$RTF_style_FootNote"/>{<xsl:value-of select="$RTF_style_FootNote"/>\up6 <xsl:apply-templates mode="footnote"/>} </xsl:template><xsl:template match="fb:p" mode="footnote"><xsl:if test="not (@prev-element-is-p-too)"><xsl:value-of select="$RTF_style_FootNote"/></xsl:if><xsl:apply-templates/>\par</xsl:template><xsl:template match="fb:epigraph/fb:p" mode="footnote"><xsl:value-of select="$RTF_style_FootNoteEpi"/><xsl:apply-templates/>\par</xsl:template><xsl:template match="fb:cite/fb:p" mode="footnote"><xsl:if test="not (@prev-element-is-p-too)"><xsl:value-of select="$RTF_style_FootNoteCite"/></xsl:if><xsl:apply-templates/>\par</xsl:template><xsl:template match="fb:epigraph" mode="footnote"><xsl:value-of select="$RTF_style_FootNoteEpi"/><xsl:apply-templates mode="footnote"/><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:template><xsl:template match="fb:epigraph/fb:text-author|fb:poem/fb:text-author" mode="footnote"><xsl:value-of select="$RTF_style_FootNoteEpiA"/><xsl:apply-templates/>\par</xsl:template><xsl:template match="fb:cite" mode="footnote"><xsl:value-of select="$RTF_head_spacer"/>\par<xsl:apply-templates mode="footnote"/><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:template><xsl:template match="fb:cite/fb:text-author" mode="footnote"><xsl:value-of select="$RTF_style_FootNoteCiteA"/><xsl:apply-templates/>\par</xsl:template><xsl:template match="fb:poem" mode="footnote"><xsl:value-of select="$RTF_head_spacer"/>\par<xsl:apply-templates mode="footnote"/></xsl:template><xsl:template match="fb:poem/fb:title/fb:p" mode="footnote"><xsl:if test="not (@prev-element-is-p-too)"><xsl:value-of select="$RTF_style_FootNotePoemTtl"/></xsl:if><xsl:apply-templates/>\par</xsl:template><xsl:template match="fb:stanza" mode="footnote"><xsl:apply-templates mode="footnote"/>\par</xsl:template><xsl:template match="fb:v" mode="footnote"><xsl:if test="not (@prev-element-is-p-too)"><xsl:value-of select="$RTF_style_FootNoteStanz"/></xsl:if><xsl:apply-templates/>\par</xsl:template><xsl:template match="fb:image" mode="footnote"><xsl:if test="$saveimages &gt; 0">\qc<xsl:apply-templates/>\par</xsl:if></xsl:template><xsl:template match="*" mode="footnote">	<xsl:apply-templates/></xsl:template><!-- body/title --><xsl:template match="fb:body/fb:title"><xsl:value-of select="$RTF_style_H1"/><xsl:apply-templates/><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:template><xsl:template match="fb:title/fb:p"><xsl:apply-templates/>\par</xsl:template><xsl:template match="fb:epigraph/fb:p"><xsl:if test="not (@prev-element-is-p-too)"><xsl:value-of select="$RTF_style_Epi"/></xsl:if><xsl:apply-templates/>\par</xsl:template><xsl:template match="fb:cite/fb:p"><xsl:if test="not (@prev-element-is-p-too)"><xsl:value-of select="$RTF_style_Cite"/></xsl:if><xsl:apply-templates/>\par</xsl:template><xsl:template match="fb:annotation/fb:p"><xsl:if test="not (@prev-element-is-p-too)"><xsl:value-of select="$RTF_style_Ann"/></xsl:if><xsl:apply-templates/>\par</xsl:template><!-- subtitle --><xsl:template match="fb:subtitle"><xsl:if test="not(name(preceding-sibling::*[1])='subtitle')"><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:if> <xsl:value-of select="$RTF_style_H6"/><xsl:apply-templates/>\par</xsl:template><!-- p --><xsl:template match="fb:p"><xsl:if test="name(preceding-sibling::*[1])='subtitle'"><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:if><xsl:if test="not (@prev-element-is-p-too)"><xsl:value-of select="$RTF_plain"/></xsl:if><xsl:apply-templates/>\par</xsl:template><!-- strong --><xsl:template match="fb:strong">\b<xsl:text disable-output-escaping="no">&#032;</xsl:text><xsl:apply-templates/>\b0 <xsl:text disable-output-escaping="no">&#032;</xsl:text></xsl:template><!-- emphasis --><xsl:template match="fb:emphasis">\i<xsl:text disable-output-escaping="no">&#032;</xsl:text><xsl:apply-templates/>\i0 <xsl:text disable-output-escaping="no">&#032;</xsl:text></xsl:template><!-- style --><xsl:template match="fb:style"><xsl:apply-templates/></xsl:template><!-- empty-line --><xsl:template match="fb:empty-line">\par</xsl:template>	<!-- link --><xsl:template match="fb:a"><xsl:choose><xsl:when test="(@type) = 'note'"><xsl:variable name="IsNumbered" select="translate(.,'123456789[]{}()_-%#^*&gt;&lt;','00000000000000000000000')+1"/><xsl:choose>	<xsl:when test="$IsNumbered">{\up6 \chftn}{\footnote <xsl:value-of select="$RTF_style_FootNote"/>{<xsl:value-of select="$RTF_style_FootNote"/>\up6 \chftn } </xsl:when>	<xsl:otherwise>\ul\i1 <xsl:apply-templates/>\ul0\i0{\footnote <xsl:value-of select="$RTF_style_FootNote"/> 	<xsl:if test="not(key('note-link',substring-after(@xlink:href,'#'))/fb:title)">{<xsl:value-of select="$RTF_style_FootNote"/>\up6 <xsl:apply-templates/> }</xsl:if></xsl:otherwise></xsl:choose><xsl:choose>	<xsl:when test="$IsNumbered"><xsl:for-each select="key('note-link',substring-after(@xlink:href,'#'))"><xsl:apply-templates mode="footnote" select="*[name() != 'title']"/></xsl:for-each></xsl:when>	<xsl:otherwise><xsl:for-each select="key('note-link',substring-after(@xlink:href,'#'))"><xsl:apply-templates mode="footnote"/></xsl:for-each></xsl:otherwise></xsl:choose>}</xsl:when><xsl:otherwise><xsl:apply-templates/></xsl:otherwise></xsl:choose></xsl:template><!-- epigraph --><xsl:template match="fb:epigraph"><xsl:value-of select="$RTF_style_Epi"/><xsl:apply-templates/><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:template><!-- epigraph/text-author --><xsl:template match="fb:epigraph/fb:text-author|fb:poem/fb:text-author"><xsl:value-of select="$RTF_style_EpiA"/><xsl:apply-templates/>\par</xsl:template><!-- cite --><xsl:template match="fb:cite"><xsl:value-of select="$RTF_head_spacer"/>\par<xsl:apply-templates/><xsl:value-of select="$RTF_head_spacer"/>\par</xsl:template><!-- cite/text-author --><xsl:template match="fb:cite/fb:text-author"><xsl:value-of select="$RTF_style_CiteA"/><xsl:apply-templates/>\par</xsl:template><!-- date --><xsl:template match="fb:date"><xsl:choose><xsl:when test="not(@value)">&#160;&#160;&#160;<xsl:apply-templates/>\line</xsl:when><xsl:otherwise>&#160;&#160;&#160;<xsl:value-of select="@value"/>\line</xsl:otherwise></xsl:choose></xsl:template>	<!-- poem --><xsl:template match="fb:poem"><xsl:value-of select="$RTF_head_spacer"/>\par<xsl:apply-templates/></xsl:template><!-- poem/title --><xsl:template match="fb:poem/fb:title/fb:p"><xsl:if test="not (@prev-element-is-p-too)"><xsl:value-of select="$RTF_style_PoemTtl"/></xsl:if><xsl:apply-templates/>\par</xsl:template><!-- stanza --><xsl:template match="fb:stanza"><xsl:apply-templates/>\par</xsl:template><!-- v --><xsl:template match="fb:v"><xsl:if test="not (@prev-element-is-p-too)"><xsl:value-of select="$RTF_style_Stanz"/></xsl:if><xsl:apply-templates/>\par</xsl:template><!-- картинка --><xsl:template match="fb:image"><xsl:if test="$saveimages &gt; 0">\qc<xsl:apply-templates/>\par</xsl:if></xsl:template></xsl:stylesheet>
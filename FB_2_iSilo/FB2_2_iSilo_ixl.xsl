<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:fb="http://www.gribuser.ru/xml/fictionbook/2.0">
	<xsl:output method="xml" encoding="windows-1251"/>
	<xsl:param name="src-name" select="temp.html"/>
	<xsl:param name="output-path" select="'./'"/>
	<xsl:param name="book-title"/>
	<xsl:template match="/*">
		<iSiloXDocumentList>
			<xsl:text>&#10; </xsl:text>
			<iSiloXDocument>
				<xsl:text>&#10;  </xsl:text>
				<Source>
					<xsl:text>&#10;   </xsl:text>
					<Sources>
						<xsl:text>&#10;    </xsl:text>
						<Path>
							<xsl:value-of select="$src-name"/>
						</Path>
						<xsl:text>&#10;   </xsl:text>
					</Sources>
					<xsl:text>&#10;  </xsl:text>
				</Source>
				<xsl:text>&#10;  </xsl:text>
				<Destination>
					<xsl:text>&#10;   </xsl:text>
					<Title>
						<xsl:call-template name="book-title"/>
					</Title>
					<xsl:text>&#10;   </xsl:text>
					<Files>
						<xsl:text>&#10;    </xsl:text>
						<Path>
							<xsl:value-of select="$output-path"/>
						</Path>
						<xsl:text>&#10;   </xsl:text>
					</Files>
					<xsl:text>&#10;  </xsl:text>
				</Destination>
				<xsl:text>&#10;  </xsl:text>
				<LinkOptions>
					<xsl:text>&#10;   </xsl:text>
					<MaximumDepth value="1"/>
					<xsl:text>&#10;   </xsl:text>
					<FollowOffsite value="yes"/>
					<xsl:text>&#10;   </xsl:text>
					<UnresolvedDetail value="include"/>
					<xsl:text>&#10;  </xsl:text>
				</LinkOptions>
				<xsl:text>&#10;  </xsl:text>
				<ImageOptions>
					<xsl:text>&#10;   </xsl:text>
					<AltText value="exclude"/>
					<xsl:text>&#10;   </xsl:text>
					<Images value="include"/>
					<xsl:text>&#10;   </xsl:text>
					<ResizeLargeImages value="no"/>
					<xsl:text>&#10;   </xsl:text>
					<ImproveContrast value="yes"/>
					<xsl:text>&#10;   </xsl:text>
					<Dither value="yes"/>
					<xsl:text>&#10;   </xsl:text>
					<MaximumWidth value="224"/>
					<xsl:text>&#10;   </xsl:text>
					<MaximumHeight value="198"/>
					<xsl:text>&#10;   </xsl:text>
					<Compress value="yes"/>
					<xsl:text>&#10;   </xsl:text>
					<BitDepth1 value="exclude"/>
					<xsl:text>&#10;   </xsl:text>
					<BitDepth2 value="exclude"/>
					<xsl:text>&#10;   </xsl:text>
					<BitDepth4 value="include"/>
					<xsl:text>&#10;   </xsl:text>
					<BitDepth8 value="exclude"/>
					<xsl:text>&#10;   </xsl:text>
					<BitDepth16 value="include"/>
					<xsl:text>&#10;  </xsl:text>
				</ImageOptions>
				<xsl:text>&#10;  </xsl:text>
				<TableOptions>
					<xsl:text>&#10;   </xsl:text>
					<IgnoreTables value="no"/>
					<xsl:text>&#10;   </xsl:text>
					<UseMinimumDepth value="no"/>
					<xsl:text>&#10;   </xsl:text>
					<MinimumDepth value="1"/>
					<xsl:text>&#10;   </xsl:text>
					<UseMaximumBottomReach value="no"/>
					<xsl:text>&#10;   </xsl:text>
					<MaximumBottomReach value="1"/>
					<xsl:text>&#10;   </xsl:text>
					<UnfoldFullPageTables value="no"/>
					<xsl:text>&#10;   </xsl:text>
					<IgnorePixelWidths value="no"/>
					<xsl:text>&#10;  </xsl:text>
				</TableOptions>
				<xsl:text>&#10;  </xsl:text>
				<ColorOptions>
					<xsl:text>&#10;   </xsl:text>
					<BackgroundColors value="keep"/>
					<xsl:text>&#10;   </xsl:text>
					<TextColors value="keep"/>
					<xsl:text>&#10;  </xsl:text>
				</ColorOptions>
				<xsl:text>&#10;  </xsl:text>
				<MarginOptions>
					<xsl:text>&#10;   </xsl:text>
					<LeftRightMargins value="keep"/>
					<xsl:text>&#10;  </xsl:text>
				</MarginOptions>
				<xsl:text>&#10;  </xsl:text>
				<SecurityOptions>
					<xsl:text>&#10;   </xsl:text>
					<Convert value="allow"/>
					<xsl:text>&#10;   </xsl:text>
					<CopyBeam value="allow"/>
					<xsl:text>&#10;   </xsl:text>
					<CopyAndPaste value="allow"/>
					<xsl:text>&#10;   </xsl:text>
					<Modify value="allow"/>
					<xsl:text>&#10;  </xsl:text>
				</SecurityOptions>
				<xsl:text>&#10;  </xsl:text>
				<TextOptions>
					<xsl:text>&#10;   </xsl:text>
					<ProcessLineBreaks value="yes"/>
					<xsl:text>&#10;   </xsl:text>
					<ConvertSingleLineBreaks value="no"/>
					<xsl:text>&#10;   </xsl:text>
					<Preformatted value="no"/>
					<xsl:text>&#10;   </xsl:text>
					<UseMonospaceFont value="no"/>
					<xsl:text>&#10;   </xsl:text>
					<MonospaceFontSize value="10"/>
					<xsl:text>&#10;   </xsl:text>
					<TabStopWidth value="8"/>
					<xsl:text>&#10;  </xsl:text>
				</TextOptions>
				<xsl:call-template name="ixlDocumentOptions"/>
				<xsl:text>&#10; </xsl:text>
			</iSiloXDocument>
			<xsl:text>&#10;</xsl:text>
		</iSiloXDocumentList>
	</xsl:template>
	<!-- book-title template -->
	<xsl:template name="book-title">
		<xsl:choose>
			<xsl:when test="$book-title">
				<xsl:value-of select="$book-title"/>
			</xsl:when>
			<xsl:when test="fb:description/fb:custom-info[@info-type='iSilo-title']">
				<xsl:value-of select="fb:description/fb:custom-info[@info-type='iSilo-title']"/>
			</xsl:when>
			<xsl:when test="fb:description/fb:custom-info[@info-type='palm-title']">
				<xsl:value-of select="fb:description/fb:custom-info[@info-type='palm-title']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="fb:description/fb:title-info/fb:book-title"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- book-title template -->
	<xsl:template name="ixlDocumentOptions">
		<xsl:text>&#10;  </xsl:text>
		<DocumentOptions>
			<xsl:text>&#10;   </xsl:text>
			<PageBounds value="hard"/>
			<xsl:text>&#10;   </xsl:text>
			<UseDefaultCategory value="no"/>
			<xsl:text>&#10;  </xsl:text>
		</DocumentOptions>
	</xsl:template>
</xsl:stylesheet>

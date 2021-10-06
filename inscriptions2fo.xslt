<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://www.tei-c.org/ns/1.0" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="t" version="2.0">
    <xsl:output method="xml" encoding="UTF-8"/>
    
    <xsl:include href="../Stylesheets/global-varsandparams.xsl"/>
    
    <!-- html related stylesheets, these may import tei{element} stylesheets if relevant eg. htm-teigap and teigap -->
    <xsl:include href="../Stylesheets/fo-teiab.xsl"/>
    <xsl:include href="../Stylesheets/fo-teiaddanddel.xsl"/>
    <xsl:include href="../Stylesheets/fo-teiapp.xsl"/>
    <xsl:include href="../Stylesheets/fo-teidiv.xsl"/>
    <xsl:include href="../Stylesheets/fo-teidivedition.xsl"/>
    <xsl:include href="../Stylesheets/fo-teidivapparatus.xsl"/>
    <xsl:include href="../Stylesheets/fo-teiforeign.xsl"/>
    <xsl:include href="../Stylesheets/fo-teifigure.xsl"/>
    <xsl:include href="../Stylesheets/fo-teig.xsl"/>
    <xsl:include href="../Stylesheets/fo-teigap.xsl"/>
    <xsl:include href="../Stylesheets/fo-teihead.xsl"/>
    <xsl:include href="../Stylesheets/fo-teihi.xsl"/>
    <xsl:include href="../Stylesheets/fo-teilb.xsl"/>
    <xsl:include href="../Stylesheets/fo-teilgandl.xsl"/>
    <xsl:include href="../Stylesheets/fo-teilistanditem.xsl"/>
    <xsl:include href="../Stylesheets/fo-teilistbiblandbibl.xsl"/>
    <xsl:include href="../Stylesheets/fo-teimilestone.xsl"/>
    <xsl:include href="../Stylesheets/fo-teibibl.xsl"/>
    <xsl:include href="../Stylesheets/fo-teinote.xsl"/>
    <xsl:include href="../Stylesheets/fo-teinum.xsl"/>
    <xsl:include href="../Stylesheets/fo-teip.xsl"/>
    <xsl:include href="../Stylesheets/fo-teiseg.xsl"/>
    <xsl:include href="../Stylesheets/fo-teispace.xsl"/>
    <xsl:include href="../Stylesheets/fo-teisupplied.xsl"/>
    <xsl:include href="../Stylesheets/fo-teiterm.xsl"/>
    <xsl:include href="../Stylesheets/fo-teiref.xsl"/>
    
    <!-- html related stylesheets for named templates -->
    <xsl:include href="../Stylesheets/fo-tpl-sqbrackets.xsl"/>
    <xsl:include href="../Stylesheets/fo-tpl-apparatus.xsl"/>
    <xsl:include href="../Stylesheets/fo-tpl-lang.xsl"/>
    
    <!-- html related stylesheets for named templates -->
    <xsl:include href="../Stylesheets/fo-tpl-struct-creta.xsl"/>
    
    <!-- tei stylesheets that are also used by start-txt -->
    <xsl:include href="../Stylesheets/teiabbrandexpan.xsl"/>
    <xsl:include href="../Stylesheets/teicertainty.xsl"/>
    <xsl:include href="../Stylesheets/teichoice.xsl"/>
    <xsl:include href="../Stylesheets/teihandshift.xsl"/>
    <xsl:include href="../Stylesheets/teiheader.xsl"/>
    <xsl:include href="../Stylesheets/teimilestone.xsl"/>
    <xsl:include href="../Stylesheets/teiorig.xsl"/>
    <xsl:include href="../Stylesheets/teiorigandreg.xsl"/>
    <xsl:include href="../Stylesheets/teiq.xsl"/>
    <xsl:include href="../Stylesheets/teisicandcorr.xsl"/>
    <xsl:include href="../Stylesheets/teispace.xsl"/>
    <xsl:include href="../Stylesheets/teisupplied.xsl"/>
    <xsl:include href="../Stylesheets/teisurplus.xsl"/>
    <xsl:include href="../Stylesheets/teiunclear.xsl"/>
    
    
    <!-- global named templates with no html, also used by start-txt  -->
    <xsl:include href="../Stylesheets/tpl-certlow.xsl"/>
    <xsl:include href="../Stylesheets/functions.xsl"/>
    
    
    <xsl:template match="t:TEI[not(@type)]">
        <xsl:variable name="ins" select="."/>
            <xsl:variable name="filename" select="translate(.//t:idno[@type = 'filename']/text(), ' .', '__')"/>
            <xsl:message>filename:<xsl:value-of select="$filename"/></xsl:message>
            <xsl:result-document method="xml" href="inscriptions/{$filename}.xml">
                <fo:block-container>
                    <xsl:call-template name="generic-fo-structure">
                        <xsl:with-param name="file" select="$ins"/>
                        <xsl:with-param name="filename" select="$filename"/>
                        <xsl:with-param name="parm-internal-app-style" select="$internal-app-style" tunnel="yes"/>
                        <xsl:with-param name="parm-external-app-style" select="$external-app-style" tunnel="yes"/>
                        <xsl:with-param name="parm-edn-structure" select="$edn-structure" tunnel="yes"/>
                        <xsl:with-param name="parm-edition-type" select="$edition-type" tunnel="yes"/>
                        <xsl:with-param name="parm-hgv-gloss" select="$hgv-gloss" tunnel="yes"/>
                        <xsl:with-param name="parm-leiden-style" select="$leiden-style" tunnel="yes"/>
                        <xsl:with-param name="parm-line-inc" select="$line-inc" tunnel="yes" as="xs:double"/>
                        <xsl:with-param name="parm-verse-lines" select="$verse-lines" tunnel="yes"/>
                        <xsl:with-param name="parm-css-loc" select="$css-loc" tunnel="yes"/>
                    </xsl:call-template>
                </fo:block-container>
            </xsl:result-document>
    </xsl:template>
    <xsl:template name="generic-fo-structure">
        <xsl:param name="file"></xsl:param>
        <xsl:param name="filename"></xsl:param>
        <fo:block  id="bibliography{$filename}">
            <xsl:apply-templates mode="creta" select="$file//t:div[@type='bibliography']/t:p"/>
        </fo:block>
        <fo:block id="edition{$filename}" >
            <xsl:variable name="edtxt">
                <xsl:apply-templates select="$file//t:div[@type='edition']">
                    <xsl:with-param name="parm-edition-type" tunnel="yes"><xsl:text>interpretive</xsl:text></xsl:with-param>
                    <xsl:with-param name="parm-verse-lines" tunnel="yes"><xsl:text>off</xsl:text></xsl:with-param>
                    <xsl:with-param name="parm-line-inc" tunnel="yes"><xsl:text>5</xsl:text></xsl:with-param>
                </xsl:apply-templates>
            </xsl:variable>
            <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
            <xsl:apply-templates select="$edtxt" mode="sqbrackets"/>
        </fo:block>
        
        <xsl:if test="$file//t:div[@type='apparatus']">
            <fo:block id="apparatus{$filename}">
                <xsl:variable name="apptxt">
                    <xsl:apply-templates select="$file//t:div[@type='apparatus']//t:p"/>
                </xsl:variable>
                <xsl:apply-templates select="$apptxt" mode="sqbrackets"/>
            </fo:block>
        </xsl:if>
        
        <xsl:if test="$file//t:div[@type='translation']">
            <fo:block id="translation{$filename}" >
                <xsl:variable name="transtxt">
                    <xsl:apply-templates select="$file//t:div[@type='translation']//t:p"/>
                </xsl:variable>
                <xsl:apply-templates select="$transtxt" mode="sqbrackets"/>
            </fo:block>
        </xsl:if>
        
        <fo:block id="commentary{$filename}" >
            <xsl:variable name="commtxt">
                <xsl:apply-templates mode="creta" select="$file//t:div[@type='commentary']//t:p"/>
            </xsl:variable>
            <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
            <xsl:apply-templates select="$commtxt" mode="sqbrackets"/>
        </fo:block>
    </xsl:template>

</xsl:stylesheet>

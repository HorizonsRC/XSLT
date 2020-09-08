<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns="http://www.w3.org/1999/xhtml" version="1.0" exclude-result-prefixes="msxsl">
  <xsl:param name="InstanceUri" />
  <xsl:param name="WebsiteURI" />
  <xsl:variable name="backColor" select="'#E6E6E6'" />
  <xsl:output method="html" encoding="utf-8" indent="yes" media-type="text/html" doctype-system="about:legacy-compat" />
  <xsl:template match="/">
    <div>
      <table bgcolor="#ffffff">
        <tr height="208px">
          <td width="680px" style="background-size: 680px 208px; background-repeat: no-repeat; background-position: left; background-image:url('http://www.horizons.govt.nz/HRC/media/Media/Mobile Form graphics/horizons_banner_blank.png');">
            <div style="position: absolute; top:70px; left: 20px">
              <p style="margin: 0; padding: 2px; color: #ffffff; font-family: 'Calibri', sans-serif; font-weight: bold; font-size: 20pt; text-indent: 20px;">
                <xsl:value-of select="//JobData/ActivityName" />
              </p>
              <p style="margin: 0; padding: 1px; color: #ffffff; font-family: 'Calibri', sans-serif; font-weight: normal; font-size: 8pt; text-indent: 20px;">REFERENCE: <xsl:value-of select="//@ReferenceNumber" /></p>
              <p style="margin: 0; padding: 1px; color: #ffffff; font-family: 'Calibri', sans-serif; font-weight: normal; font-size: 8pt; text-indent: 20px;">OFFICER: <xsl:value-of select="//ResourceActivity/Name" /></p>
              <p style="margin: 0; padding: 1px; color: #ffffff; font-family: 'Calibri', sans-serif; font-weight: normal; font-size: 8pt; text-indent: 20px;">FOR: <xsl:value-of select="//FormData/LinkedContactName" /></p>
              <p style="margin: 0; padding: 1px; color: #ffffff; font-family: 'Calibri', sans-serif; font-weight: normal; font-size: 8pt; text-indent: 20px;">ADDRESS: <xsl:value-of select="//FormData/AuthorisationServiceAddress" /></p>
              <!--<p>
                <xsl:value-of select="$InstanceUri" />
              </p>
              <p>
                <xsl:value-of select="$WebsiteURI" />
              </p>-->
            </div>
          </td>
        </tr>
      </table>
      <p style="font-family: 'Calibri', sans-serif; font-size: 5pt;" />
      <div style="background-color: {$backColor}; width: 600px; margin-left: 20px; padding: 20px; color: #000000; font-family: 'Calibri', sans-serif; font-weight: normal;line-height: normal;">
        <p style="margin: 0; padding: 0; font-weight: bold; font-size: 10pt;">MONITORING SUBJECT</p>
        <p style="margin: 0; padding: 1px; font-weight: normal; font-size: 6pt;" />
        <p style="margin: 0; padding: 1px; font-weight: normal; font-size: 9pt;">
          <xsl:value-of select="//FormData/AuthorisationIRISID" />
           | <xsl:value-of select="//FormData/AuthorisationName" /></p>
        <p style="margin: 0; padding: 1px; font-weight: normal; font-size: 6pt;" />
        <p style="margin: 0; padding: 2px; font-weight: normal; font-size: 9pt;">
          <xsl:value-of select="//FormData/AuthorisationDescription" />
        </p>
      </div>
      <table style="table-layout:fixed; margin-left:20px; width:640px; font-family:'Calibri'; border-collapse: collapse;">
        <col style="width:220px;" />
        <col style="width:420px;" />
        <xsl:for-each select="//Interaction/*">
          <xsl:call-template name="symbols" />
        </xsl:for-each>
      </table>
      <table style="table-layout:fixed; margin-left:20px; width:640px; font-family:'Calibri'; border-collapse: collapse;">
        <tr bgcolor="white" height="10px">
          <td colspan="2" style="border-left:1px solid {$backColor}; border-right:1px solid {$backColor}; border-bottom:solid 1px {$backColor};" />
        </tr>
      </table>
      <p />
      <table bgcolor="#ffffff">
        <tr height="63px">
          <td width="680px" style="background-size: 680px 63px; background-repeat: no-repeat; background-position: left; background-image:url('http://www.horizons.govt.nz/HRC/media/Media/Mobile Form graphics/horizons_footer_blank.png');" />
        </tr>
      </table>
    </div>
  </xsl:template>
  <xsl:template name="symbols">
    <xsl:for-each select="*">
      <xsl:choose>
        <!-- ================================================================================================================================ -->
        <!-- These ones are to be ignored, so identify and do nothing -->
        <!-- ================================================================================================================================ -->
        <xsl:when test="contains('InspectionType,ObjectTypeREF,RegimeIRISID,RegimeActivityName,AuthorisationIRISID,AuthorisationName,LinkedContactName',name())" />
        <xsl:when test="@Type='gmap' and @Description='Location'" />
        <xsl:when test="name()='Location_Annotations'" />
        <xsl:when test="name()='ObservationType'" />
        <xsl:when test="name()='MeasuringDevice'" />
        <!-- ================================================================================================================================ -->
        <xsl:when test="@IsList='true' and not(@Type)">
          <tr>
            <xsl:call-template name="repeater-list" />
          </tr>
        </xsl:when>
        <xsl:when test="@Type='fileupload'">
          <xsl:call-template name="fileupload" />
        </xsl:when>
        <xsl:when test="name() = 'Location_Annotation_Image'">
          <xsl:call-template name="fileupload" />
        </xsl:when>
        <!-- ================================================================================================================================ -->
        <!-- Main section header -->
        <!-- ================================================================================================================================ -->
        <xsl:when test="@Type='displaytext' and @Style='Panel' and not(.='') and not(name()='InspectionType')">
          <xsl:if test="not(name()='InstallationDetails')">
            <tr bgcolor="white" height="10px">
              <td colspan="2" style="border-left:1px solid {$backColor}; border-right:1px solid {$backColor}; border-bottom:solid 1px {$backColor};" />
            </tr>
          </xsl:if>
          <tr bgcolor="white" height="20px">
            <td colspan="2" />
          </tr>
          <tr bgcolor="{$backColor}" height="40px" style="border: thin solid {$backColor};">
            <td colspan="2" style="text-indent:20px; vertical-align:middle; font-weight:bold; font-size:11pt; border-left:1px solid {$backColor}; border-right:1px solid {$backColor};">
              <xsl:call-template name="value" />
            </td>
          </tr>
          <tr bgcolor="white" height="10px">
            <td colspan="2" style="border-left:1px solid {$backColor}; border-right:1px solid {$backColor};" />
          </tr>
        </xsl:when>
        <!-- ================================================================================================================================ -->
        <xsl:when test="@Type='displaytext' and not(.='') and not(@SubType='Header') and not(@SubType='HeaderNoSpacer')">
          <tr>
            <td colspan="2">
              <xsl:call-template name="value" />
            </td>
          </tr>
        </xsl:when>
        <xsl:when test="@Type='displaytext' and not(.='') and not(@Description='Stuff')">
          <tr>
            <td colspan="2">
              <br />
              <h3>
                <xsl:call-template name="value" />
              </h3>
            </td>
          </tr>
        </xsl:when>
        <xsl:otherwise>
          <tr height="24px" style="vertical-align:center; border-left:solid 1px {$backColor}; border-right:solid 1px {$backColor};">
            <td style="text-indent: 20px; font-size: 10pt;">
              <xsl:call-template name="label" />
            </td>
            <td style="font-size: 10pt;">
              <xsl:call-template name="value" />
            </td>
          </tr>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="fileupload">
    <xsl:for-each select="Files/Item">
      <tr>
        <td colspan="2" style="text-indent:20px; border-left:1px solid {$backColor}; border-right:1px solid {$backColor}; padding-top:10px;">
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="concat($InstanceUri, '/', UriSuffix)" />
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="concat('Download ', Name)" />
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="contains(Name, '.jpg')">
                <xsl:element name="img">
                  <xsl:attribute name="src">
                    <xsl:value-of select="concat($InstanceUri, '/', UriSuffix, '?rendition=thumbnail')" />
                  </xsl:attribute>
                  <xsl:attribute name="width">240px</xsl:attribute>
                  <xsl:attribute name="scalefit">1</xsl:attribute>
                </xsl:element>
              </xsl:when>
              <xsl:when test="contains(Name, '.png')">
                <xsl:element name="img">
                  <xsl:attribute name="src">
                    <xsl:value-of select="concat($InstanceUri, '/', UriSuffix, '?rendition=thumbnail')" />
                  </xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="contains(Name, 'Map')">
                      <xsl:attribute name="width">350px</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="width">240px</xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:attribute name="scalefit">1</xsl:attribute>
                </xsl:element>
              </xsl:when>
              <xsl:when test="contains(Name, '.amr')">
                Download audio.amr
            </xsl:when>
              <xsl:when test="contains(Name, '.wav')">
                Download audio.wav
            </xsl:when>
              <xsl:when test="contains(Name, '.m4a')">
                Download audio.m4a
            </xsl:when>
              <xsl:otherwise>
                Download file
            </xsl:otherwise>
            </xsl:choose>
          </a>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="repeater-list">
    <xsl:for-each select="Item">
      <h4>
        <xsl:value-of select="@Name" disable-output-escaping="yes" />
      </h4>
      <xsl:call-template name="symbols" />
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="label">
    <xsl:choose>
      <xsl:when test="@Type='option' and not(@IsList)">
        <xsl:value-of select="@Description" disable-output-escaping="yes" />
      </xsl:when>
      <xsl:when test="contains(name(),'NotesFinal')">
        <xsl:value-of select="@Description" disable-output-escaping="yes" />
      </xsl:when>
      <xsl:when test="name()='PropertyGISURI'">
        Location
      </xsl:when>
      <xsl:when test="contains(name(), '_Annotation_Map')">
        Device GPS Location
      </xsl:when>
      <xsl:when test="contains(name(), '_Annotation_Note')">
        Notes
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@Description" disable-output-escaping="yes" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="value">
    <xsl:choose>
      <xsl:when test="@IsList='true' and @Type='option'">
        <xsl:call-template name="option-list" />
      </xsl:when>
      <xsl:when test="@Type='option'">
        <xsl:call-template name="option" />
      </xsl:when>
      <xsl:when test=".=''">
        <!--<span class="no-answer">Not answered</span>-->
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="name()='PropertyGISURI'">
            <a target="_blank">
              <xsl:attribute name="href">
                <xsl:value-of select="text()" />
              </xsl:attribute>Map
            </a>
          </xsl:when>
          <xsl:when test="contains(name(), '_Annotation_Map')">
            <xsl:if test="text()!=''">
              <xsl:variable name="adesc" select="text()" />
              <xsl:variable name="asub" select="substring-after(text(),'lat: ')" />
              <xsl:variable name="alat" select="substring-before($asub,',')" />
              <xsl:variable name="asub2" select="substring-after(text(),'long: ')" />
              <xsl:variable name="along" select="substring-before($asub2,',')" />
              <xsl:variable name="alatlong" select="concat($alat,',',$along)" />
              <xsl:call-template name="google-map">
                <xsl:with-param name="ll" select="$alatlong" />
                <xsl:with-param name="desc" select="$adesc" />
              </xsl:call-template>
            </xsl:if>
          </xsl:when>
          <xsl:when test="@Type='boolean'">
            <xsl:call-template name="boolean" />
          </xsl:when>
          <xsl:when test="@Type='date'">
            <xsl:value-of select="@DisplayValue" />
          </xsl:when>
          <xsl:when test="@Type='option' and not(@IsList)">
            <xsl:value-of select="text()" />
          </xsl:when>
          <xsl:when test="contains(name(),'NotesFinal')">
            <xsl:value-of select="text()" />
          </xsl:when>
          <xsl:when test="@Type='gmap'">
            <!--<xsl:call-template name="gmap" />-->
          </xsl:when>
          <xsl:when test="@Type='addressfinderaddress'">
            <xsl:value-of select="PhysicalAddress/text()" />
          </xsl:when>
          <xsl:when test="@Type='telephone'">
            <xsl:value-of select="Number/text()" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="text()" disable-output-escaping="yes" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="boolean">
    <xsl:choose>
      <xsl:when test="text() = 'True'">
        <xsl:choose>
          <xsl:when test="not(@TrueText)">
            <xsl:text disable-output-escaping="yes">Yes</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@TrueText" disable-output-escaping="yes" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="text() = 'False'">
        <xsl:choose>
          <xsl:when test="not(@FalseText)">
            <xsl:text disable-output-escaping="yes">No</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@FalseText" disable-output-escaping="yes" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise />
    </xsl:choose>
  </xsl:template>
  <xsl:template name="option-list">
    <xsl:choose>
      <xsl:when test="count(Item) = 0">
        <!--<span class="no-answer">Not answered</span>-->
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="Item">
          <ul>
            <li>
              <xsl:call-template name="option" />
            </li>
          </ul>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="option">
    <xsl:choose>
      <xsl:when test="@Type='option' and not(@IsList)">
        <xsl:value-of select="@OptionText" disable-output-escaping="yes" />
      </xsl:when>
      <xsl:when test="contains(name(),'NotesFinal')">
        <xsl:value-of select="@OptionText" disable-output-escaping="yes" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@OptionText" disable-output-escaping="yes" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="addressfinderaddress">
    <table>
      <tr>
        <td>
          <xsl:value-of select="@Description" disable-output-escaping="yes" />
        </td>
        <td>
          <xsl:choose>
            <xsl:when test="PhysicalAddress">
              <xsl:value-of select="PhysicalAddress/text()" />
            </xsl:when>
            <xsl:when test="FullAddress">
              <xsl:value-of select="FullAddress/text()" />
            </xsl:when>
          </xsl:choose>
        </td>
      </tr>
    </table>
    <xsl:if test="Location/Latitude and Location/Longitude">
      <xsl:variable name="lat" select="Location/Latitude/text()" />
      <xsl:variable name="long" select="Location/Longitude/text()" />
      <xsl:variable name="desc" select="@Description" />
      <xsl:call-template name="google-map">
        <xsl:with-param name="ll">
          <xsl:value-of select="$lat" />,<xsl:value-of select="$long" /></xsl:with-param>
        <xsl:with-param name="desc" select="$desc" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template name="gmap">
    <xsl:if test="text()!=''">
      <xsl:variable name="ll" select="text()" />
      <xsl:variable name="desc" select="@Description" />
      <xsl:call-template name="google-map">
        <xsl:with-param name="ll" select="$ll" />
        <xsl:with-param name="desc" select="$desc" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template name="google-map">
    <xsl:param name="ll" />
    <xsl:param name="desc" />
    <xsl:value-of select="$desc" disable-output-escaping="yes" />
    <br />
    <br />
    <!-- commented out 2018-09-26 Google map is unsupported -->
    <!--
	<xsl:call-template name="embed-google-map">
      <xsl:with-param name="ll" select="$ll" />
    </xsl:call-template>-->
    <br />
    <xsl:call-template name="show-google-map-link">
      <xsl:with-param name="ll" select="$ll" />
    </xsl:call-template>
    <br />
    <br />
    <xsl:value-of select="$ll" disable-output-escaping="yes" />
  </xsl:template>
  <xsl:template name="embed-google-map">
    <xsl:param name="ll" />
    <xsl:element name="img">
      <xsl:attribute name="src">
        <xsl:value-of select="concat('http://mapsfsignature.googleapis.com/maps/api/staticmap?center=', $ll, '&amp;zoom=20&amp;sensor=false&amp;size=600x600%20&amp;maptype=satellite&amp;markers=color:red%7C', $ll)" />
      </xsl:attribute>
      <xsl:attribute name="width">240px</xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template name="show-google-map-link">
    <xsl:param name="ll" />
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="concat('http://maps.google.com/maps?ll=', $ll, '&amp;z=17&amp;q=Property Location@', $ll)" />
      </xsl:attribute>
      <xsl:attribute name="target">
        <xsl:value-of select="_blank" />
      </xsl:attribute>
			Open Google Maps
		  </xsl:element>
  </xsl:template>
</xsl:stylesheet>
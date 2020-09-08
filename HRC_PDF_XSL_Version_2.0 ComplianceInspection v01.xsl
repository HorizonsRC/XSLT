<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:param name="InstanceUri"/>
  <xsl:param name="WebsiteURI" />
  <!-- ================================================================================================================================ -->
  <!-- Note: Calculations need to have operators separated by a space from the operand                                                  -->
  <!--	     This template uses 'for-each-group' which requires xsl version 2.0 or higher                                                -->
  <!-- ================================================================================================================================ -->
  <xsl:param name="backColor" select="'#E6E6E6'" />
  <xsl:param name="headerWidth">680</xsl:param>
  <xsl:param name="headerHeight">208</xsl:param>
  <xsl:param name="footerHeight">63</xsl:param>
  <xsl:param name="headerTextTop">50</xsl:param>
  <xsl:param name="tableIndent">20</xsl:param>
  <xsl:param name="tableWidth"><xsl:value-of select="$headerWidth - 2 * $tableIndent" /></xsl:param>
  <xsl:param name="colWidth1">320</xsl:param>
  <xsl:param name="colWidth2"><xsl:value-of select="$tableWidth - $colWidth1" /></xsl:param>
  <!-- ================================================================================================================================ -->
  <xsl:output method="html" encoding="utf-8" indent="yes" media-type="text/html" doctype-system="about:legacy-compat" />
  <xsl:template match="/">
    <div>
      <table bgcolor="#ffffff">
        <tr height="{$headerHeight}px">
          <td width="{$headerWidth}px">
	        <img src="http://www.horizons.govt.nz/HRC/media/Media/Mobile%20Form%20graphics/horizons_banner_blank.png" style="background-size: {$headerWidth}px 208px; background-repeat: no-repeat; background-position: left;"/>
            <div style="position: absolute; top:{$headerTextTop}px; left: 20px"><p style="margin: 0; padding: 2px; color: #ffffff; font-family: 'Calibri', sans-serif; font-weight: bold; font-size: 20pt; text-indent: 20px;"><xsl:value-of select="//JobData/ActivityName" /></p>
	           <p style="margin: 0; padding: 1px; color: #ffffff; font-family: 'Calibri', sans-serif; font-weight: normal; font-size: 8pt; text-indent: 20px;">REFERENCE: <xsl:value-of select="//@ReferenceNumber" /></p>
	           <p style="margin: 0; padding: 1px; color: #ffffff; font-family: 'Calibri', sans-serif; font-weight: normal; font-size: 8pt; text-indent: 20px;">IDENTIFIER: <xsl:value-of select="//FormData/RegimeActivityIRISID" /></p>
               <p style="margin: 0; padding: 1px; color: #ffffff; font-family: 'Calibri', sans-serif; font-weight: normal; font-size: 8pt; text-indent: 20px;">OFFICER: <xsl:value-of select="//ResourceActivity/Name" /></p>
               <p style="margin: 0; padding: 1px; color: #ffffff; font-family: 'Calibri', sans-serif; font-weight: normal; font-size: 8pt; text-indent: 20px;">FOR: <xsl:value-of select="//FormData/LinkedContactName" /></p>
               <p style="margin: 0; padding: 1px; color: #ffffff; font-family: 'Calibri', sans-serif; font-weight: normal; font-size: 8pt; text-indent: 20px;">ADDRESS: <xsl:value-of select="//FormData/AuthorisationServiceAddress" /></p>
            </div>			
          </td>
        </tr>
      </table>
      <p style="font-family: 'Calibri', sans-serif; font-size: 5pt;"></p>
	  <table style="table-layout:fixed; margin-left:{$tableIndent}px; width:{$tableWidth}px; background-color:{$backColor};">
	    <tr>
		  <td>
	        <div style="padding: 20px; color: #000000; font-family: 'Calibri', sans-serif;">
	          <p style="margin: 0; padding: 0; font-weight: bold; font-size: 10pt;">MONITORING SUBJECT</p>
			  <p style="margin: 0; padding: 1px; font-weight: normal; font-size: 6pt;"/>
		      <p style="margin: 0; padding: 1px; font-weight: normal; font-size: 9pt;"><xsl:value-of select="//FormData/AuthorisationIRISID" /><nbsp/>|<nbsp/><xsl:value-of select="//FormData/AuthorisationName" /></p>
			  <p style="margin: 0; padding: 1px; font-weight: normal; font-size: 6pt;"/>
		      <p style="margin: 0; padding: 2px; font-weight: normal; font-size: 9pt;"><xsl:value-of select="//FormData/AuthorisationDescription" /></p>
	        </div>
	      </td>
	    </tr>
	  </table>
	  <!-- ================================================================================================================================ -->
      <!-- Because there is no inherent structure to the elements in the Sphere xml, we have to use the header element which is identified  -->
	  <!-- by @Type='displaytext' and @Style='Panel'. This marks the start of a group of nodes. We pass the complete group of nodes to the  -->
      <!-- 'buildTable' template with 'headerOnly' set to 1. The template recurses the list to generate the complete table                  -->
      <!-- ================================================================================================================================ -->
      <xsl:for-each-group select="//Interaction/Checklist/*" group-starting-with="*[@Type='displaytext' and @Style='Panel']">
        <xsl:call-template name="buildTable">
	      <xsl:with-param name="listRows" select="current-group()" />
		  <xsl:with-param name="headerOnly" select="1"/>
	    </xsl:call-template>
      </xsl:for-each-group>
      <!-- ================================================================================================================================ -->
      <!-- Footer - a blank row followed by a table which holds the HRC branding footer image                                               -->
      <!-- ================================================================================================================================ -->
	  <p />
      <table bgcolor="#ffffff">
        <tr height="{$footerHeight}px">
          <td width="{$headerWidth}px">
	          <img src="http://www.horizons.govt.nz/HRC/media/Media/Mobile%20Form%20graphics/horizons_footer_blank.png" style="background-size: {$headerWidth}px 63px; background-repeat: no-repeat; background-position: left;"/>
          </td>
        </tr>
      </table>
    </div>
  </xsl:template>
  <!-- ================================================================================================================================ -->
  <!-- This template recurses a passed-in collection of nodes, creating a table with a header row based on the first item (tagged with  -->
  <!-- 'headerOnly' = 1) followed by the remainder ('headerOnly' = 0) with layout determined by other templates                         -->
  <!-- ================================================================================================================================ -->
  <xsl:template name="buildTable">
    <xsl:param name="listRows" />
    <xsl:param name="headerOnly" />
    <!-- ================================================================================================================================ -->
    <!-- inspectionDescription will be either 'Water Measuring Device', 'Telemetry Installation' or 'Telemetry Data Inspection'           -->
	<!-- used below for determining installed meter details when 'AS ABOVE' is selected in the form                                       -->
    <!-- ================================================================================================================================ -->
    <xsl:param name="timeValue"><xsl:value-of select="//Interaction/Checklist/ServiceTimeRecordHours"/></xsl:param>
	<xsl:param name="timeTotal">
	  <xsl:choose>
	  <xsl:when test="count(//Interaction/Checklist/ServiceDetailsTimeRecord/Item[ServiceTimeRecordHours != '']/ServiceTimeRecordHours) &gt; 0">
	    <xsl:value-of select="sum(//Interaction/Checklist/ServiceDetailsTimeRecord/Item[ServiceTimeRecordHours != '']/ServiceTimeRecordHours)"/>
	  </xsl:when>
	  <xsl:otherwise>
	  <xsl:value-of select="0"/>
	  </xsl:otherwise>
	  </xsl:choose>
	</xsl:param>
    <xsl:param name="inspectionDescription"><xsl:value-of select="//Inspection/@DisplayName" /></xsl:param>
    <xsl:param name="imageCount"><xsl:value-of select="count(//Map/Files/Item) + count(//Photo/Files/Item) + count(//Sketch/Files/Item)" /></xsl:param>
    <xsl:param name="authorisationComplianceFurtherActionsCount"><xsl:value-of select="count(//Interaction/Checklist/AuthorisationFurtherActions/Item)" /></xsl:param>
    <xsl:if test="count($listRows) > 0">
      <xsl:for-each select="$listRows">
        <xsl:choose>
		  <!-- ===================================================================================================================================================== -->
		  <!-- The $headerOnly = 1 row is set to ignore InspectionType, and also ignore ServiceDetails if there's no time value, and Documents if there's no images  -->
		  <!-- ===================================================================================================================================================== -->
          <xsl:when test="$headerOnly = 1 and @Type = 'displaytext' and @Style = 'Panel' and not(name() = 'InspectionType' or (name() = 'ServiceDetails' and $timeTotal = 0) or (name() = 'Documents' and $imageCount = 0))">
			<xsl:choose>
			<xsl:when test="not(contains('WeatherAssessment,ConditionAssessment,FurtherActions',name()))">
			  <p></p>
			</xsl:when>
			</xsl:choose>
            <table style="page-break-inside:avoid; table-layout:fixed; margin-left:{$tableIndent}px; width:{$tableWidth}px; font-family:'Calibri'; border-collapse: collapse;">
			  <xsl:choose>
			  <xsl:when test="text() = 'PHOTOS'">
                <xsl:variable name="colWidth" select="($colWidth1+$colWidth2) div 2"/>
			    <col style="width:{$colWidth}px;" />
                <col style="width:{$colWidth}px;" />
			  </xsl:when>
			  <xsl:otherwise>
			    <col style="width:{$colWidth1}px;" />
                <col style="width:{$colWidth2}px;" />
		      </xsl:otherwise>
			  </xsl:choose>
              <!-- ================================================================================================================================ -->
              <!-- Section header choice - a main group header or just a section header                                                             -->
              <!-- ================================================================================================================================ -->
			  <xsl:choose>
			  <xsl:when test="contains('ErosionSedimentControlGrading,MobileInspection',name())">
                <tr bgcolor="white" height="45px" style="page-break-inside:avoid; border: none">
                  <td colspan="2" style="page-break-inside:avoid; text-indent:5px; vertical-align:middle; font-weight:bold; font-size:18pt; color: #243746;">
                    <xsl:call-template name="value" />
                  </td>
                </tr>
                <tr bgcolor="#243746" height="40px" style="page-break-inside:avoid; border: thin solid #243746;">
                  <td colspan="2" style="page-break-inside:avoid; text-indent:20px; vertical-align:middle; font-weight:bold; font-size:11pt; color: white; border-left:1px solid #243746; border-right:1px solid #243746;">
                    <xsl:text>INSPECTION ASSESSMENT</xsl:text>
                  </td>
                </tr>
			  </xsl:when>
			  <xsl:when test="name() = 'FurtherActions'">
			  </xsl:when>
			  <xsl:otherwise>
                <!-- ================================================================================================================================ -->
                <!-- Section header - a taller row with background, followed by a narrow blank row                                                    -->
                <!-- ================================================================================================================================ -->
                <tr bgcolor="{$backColor}" height="40px" style="page-break-inside:avoid; border: thin solid {$backColor};">
                  <td colspan="2" style="page-break-inside:avoid; text-indent:20px; vertical-align:middle; font-weight:bold; font-size:11pt; border-left:1px solid {$backColor}; border-right:1px solid {$backColor};">
			        <xsl:choose>
				    <xsl:when test="name() = 'WeatherAssessment'">
					  <xsl:text>WEATHER ASSESSMENT</xsl:text>
				    </xsl:when>
		            <xsl:otherwise>
                      <xsl:call-template name="value" />
				    </xsl:otherwise>
				    </xsl:choose>
                  </td>
                </tr>
                <tr bgcolor="white" height="10px" style="page-break-inside:avoid;">
                  <td colspan="2" style="page-break-inside:avoid; border-left:1px solid {$backColor}; border-right:1px solid {$backColor};"></td>
                </tr>
			  </xsl:otherwise>
			  </xsl:choose>
              <!-- ================================================================================================================================ -->
              <!-- Body - single level recursion using all the subsequent rows                                                                      -->
              <!-- ================================================================================================================================ -->
              <xsl:variable name="pos" select="position()"/>
              <xsl:call-template name="buildTable">
                <xsl:with-param name="listRows" select="$listRows[position() > $pos]"/>
                <xsl:with-param name="headerOnly" select="0" />
              </xsl:call-template>
              <!-- ================================================================================================================================ -->
              <!-- Footer - final blank row with bottom border  (not displayed if a main group header)                                                               -->
              <!-- ================================================================================================================================ -->
			  <xsl:choose>
			  <xsl:when test="not(contains('ErosionSedimentControlGrading,MobileInspection',name()) or ((name() = 'AuthorisationAssessment') and ($authorisationComplianceFurtherActionsCount &gt; 0)))">
                <tr bgcolor="white" height="10px" style="page-break-inside:avoid;">
                  <td colspan="2" style="page-break-inside:avoid; border-left:1px solid {$backColor}; border-right:1px solid {$backColor}; border-bottom:solid 1px {$backColor};"></td>
                </tr>
			  </xsl:when>
			  <xsl:when test="name() = 'AuthorisationAssessment'">
                <tr bgcolor="white" height="10px" style="page-break-inside:avoid;">
                  <td colspan="2" style="page-break-inside:avoid; border-left:1px solid {$backColor}; border-right:1px solid {$backColor};"></td>
                </tr>
			  </xsl:when>
			  </xsl:choose>
            </table>
          </xsl:when>
          <!-- ================================================================================================================================ -->
          <!-- These ones are to be ignored, so identify and do nothing                                                                         -->
          <!-- ================================================================================================================================ -->
          <xsl:when test="$headerOnly = 0 and contains('InspectionType,ObjectTypeREF,RegimeIRISID,RegimeActivityName,AuthorisationIRISID,AuthorisationName,LinkedContactName',name())"></xsl:when>
          <xsl:when test="$headerOnly = 0 and contains('ObservationType,ReadOnlyAuthorisationLabel,Location_Annotations,Map_Annotations,CaptureWeatherConditions',name())"></xsl:when>
          <!-- ================================================================================================================================ -->
          <xsl:when test="$headerOnly = 0 and @Type='fileupload'">
            <xsl:call-template name="fileupload" />
          </xsl:when>
          <!-- ================================================================================================================================ -->
          <xsl:when test="$headerOnly = 0 and name() = 'Location_Annotation_Image'">
            <xsl:call-template name="fileupload" />
          </xsl:when>
          <!-- ================================================================================================================================ -->
          <xsl:when test="$headerOnly = 0 and name() = 'Map_Annotation_Image'">
            <xsl:call-template name="fileupload" />
          </xsl:when>
          <!-- ================================================================================================================================ -->
          <xsl:when test="$headerOnly = 0 and @Type='displaytext' and not(.='') and not(@SubType='Header') and not(@SubType='HeaderNoSpacer')">
            <tr style="page-break-inside:avoid;">
              <td colspan="2" style="page-break-inside:avoid;">
                <xsl:call-template name="value" />
              </td>
            </tr>
          </xsl:when>
          <!-- ================================================================================================================================ -->
          <xsl:when test="$headerOnly = 0 and name() = 'ConditionRptr'">
		    <xsl:choose>
			<xsl:when test="descendant::CdtnComplianceStatus/@OptionText">
              <tr style="page-break-inside:avoid;">
                <td colspan="2" style="page-break-inside:avoid; padding-left: 20px; padding-right: 20px; font-size: 10pt; text-align: justify; text-justify: inter-word; border-left:solid 1px {$backColor}; border-right:solid 1px {$backColor};">
                  <xsl:call-template name="value" />
                </td>
              </tr>
			</xsl:when>
			<xsl:otherwise>
              <tr style="page-break-inside:avoid;">
                <td colspan="2" style="page-break-inside:avoid; padding-left: 20px; padding-right: 20px; font-size: 10pt; text-align: justify; text-justify: inter-word; border-left:solid 1px {$backColor}; border-right:solid 1px {$backColor};">
                  <xsl:text>No condition compliances completed</xsl:text>
                </td>
              </tr>
			</xsl:otherwise>
			</xsl:choose>
          </xsl:when>
          <!-- ================================================================================================================================ -->
          <xsl:when test="$headerOnly = 0 and contains(name(),'Comments')">
            <tr style="page-break-inside:avoid;">
              <td colspan="2" style="page-break-inside:avoid; padding-left: 20px; padding-right: 20px; font-size: 10pt; border-left:solid 1px {$backColor}; border-right:solid 1px {$backColor};">
                <xsl:text>COMMENTS</xsl:text>
              </td>
            </tr>
            <tr style="page-break-inside:avoid;">
              <td colspan="2" style="page-break-inside:avoid; padding-left: 20px; padding-right: 20px; font-size: 10pt; text-align: justify; text-justify: inter-word; border-left:solid 1px {$backColor}; border-right:solid 1px {$backColor};">
                <xsl:call-template name="value" />
              </td>
            </tr>
          </xsl:when>
          <!-- ================================================================================================================================ -->
          <xsl:when test="$headerOnly = 0 and contains(name(),'FurtherActions')">
              <tr height="15px" style="page-break-inside:avoid;">
                <td colspan="2" style="page-break-inside:avoid; border-left:solid 1px {$backColor}; border-right:solid 1px {$backColor};"></td>
              </tr>
            <tr style="page-break-inside:avoid;">
              <td colspan="2" style="page-break-inside:avoid; border-left:solid 1px {$backColor}; border-right:solid 1px {$backColor};">
                <div style="display:flex; align-items:center; height:40px; background-color: {$backColor}; padding-left:20px; margin-left:10px; margin-right: 10px; font-size: 11pt; font-weight: bold;"><xsl:text>FURTHER ACTIONS</xsl:text></div>
              </td>
            </tr>
            <tr style="page-break-inside:avoid;">
              <td colspan="2" style="page-break-inside:avoid; border-left:solid 1px {$backColor}; border-right:solid 1px {$backColor};">
                <div style="display:grid; align-items:center; background-color: {$backColor}; padding-left:20px; padding-top:10px; padding-bottom:10px; margin-left:10px; margin-right: 10px; font-size:10pt;"><xsl:call-template name="value" /></div>
              </td>
            </tr>
          </xsl:when>
          <!-- ================================================================================================================================ -->
          <xsl:otherwise>
            <xsl:if test="$headerOnly = 0">
              <tr height="25px" style="page-break-inside:avoid; vertical-align:center; border-left:solid 1px {$backColor}; border-right:solid 1px {$backColor};">
                <td style="page-break-inside:avoid; text-indent: 20px; font-size: 10pt;">
                  <xsl:call-template name="label" />
                </td>
                <td style="page-break-inside:avoid; font-size: 10pt;">
                  <xsl:call-template name="value" />
                </td>
              </tr>
            </xsl:if>
          </xsl:otherwise>
          <!-- ================================================================================================================================ -->
        </xsl:choose>
      </xsl:for-each>
	  </xsl:if>
  </xsl:template>
  <!-- ================================================================================================================================ -->
  <!-- Go get the image using the InstanceUri address and render it to the size specified below                                         -->
  <!-- ================================================================================================================================ -->
  <xsl:template name="fileupload">
	<xsl:variable name="mod" select="number(2)"/> <!-- the number of columns -->
    <xsl:for-each select="Files/Item">
	  <xsl:if test="position() mod $mod = 1">
	    <xsl:text disable-output-escaping="yes"><![CDATA[<tr style="page-break-inside:avoid; border-left:1px solid #E6E6E6; border-right:1px solid #E6E6E6;">]]></xsl:text>
	  </xsl:if>
      <td style="page-break-inside:avoid; text-indent:20px;  padding-top:10px;">
		<xsl:choose>
		  <xsl:when test="contains(Name,'.jpg') or contains(Name,'.png')">
		    <!-- we're leaving out the description field for now
            <div style="page-break-inside:avoid; text-indent:20px;  padding-top:10px;">
	          <xsl:value-of select="Description"/>
	        </div>-->
			<img src="{concat($InstanceUri, '/', UriSuffix, '?rendition=thumbnail')}">
			  <xsl:attribute name="Width">
			    <xsl:choose>
				  <xsl:when test="contains(Name,'Map')">400px</xsl:when>
				  <xsl:otherwise>200px</xsl:otherwise>
				</xsl:choose>
			  </xsl:attribute>
			  <xsl:attribute name="scalefit">1</xsl:attribute>
			</img>
		  </xsl:when>
		</xsl:choose>
      </td>
      <!-- ================================================================================================================================ -->
      <!-- We're rendering the images in two equal columns and using modular arithmetic to work out the column-breaks plus if an extra      -->
	  <!-- <td/> is needed in the case where there's an odd number of images                                                                -->
      <!-- ================================================================================================================================ -->
	  <xsl:if test="position() mod $mod = 1 and position() = last()">
		<td style="page-break-inside:avoid;" />
	  </xsl:if>
	  <xsl:if test="position() mod $mod = 0 or position() = last()">
	    <xsl:text disable-output-escaping="yes"><![CDATA[</tr>]]></xsl:text>
	  </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <!-- ================================================================================================================================ -->
  <!-- Get the label applicable to the item                                                                                             -->
  <!-- ================================================================================================================================ -->
  <xsl:template name="label">
    <xsl:choose>
      <xsl:when test="@Type='option' and not(@IsList)">
        <xsl:value-of select="@Description" disable-output-escaping="yes" />
      </xsl:when>
      <xsl:when test="contains(name(),'Comments')">
        <xsl:text>COMMENTS</xsl:text>
      </xsl:when>
      <xsl:when test="contains(name(),'TimeRecord')">
        <xsl:text>TIME HOURS</xsl:text>
      </xsl:when>
      <xsl:when test="name()='PropertyGISURI'">
        Location
      </xsl:when>
      <xsl:when test="contains(name(), '_Annotation_Map')">
        Device GPS Location
      </xsl:when>
      <xsl:when test="contains(name(), '_Annotation_Note')">
        NOTES
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@Description" disable-output-escaping="yes" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ================================================================================================================================ -->
  <!-- Get the value applicable to the item                                                                                             -->
  <!-- ================================================================================================================================ -->
  <xsl:template name="value">
    <xsl:choose>
      <xsl:when test="@IsList='true' and @Type='option'">
        <xsl:call-template name="option-list" />
      </xsl:when>
      <xsl:when test="@IsList='true'">
        <xsl:call-template name="option-list" />
      </xsl:when>
      <xsl:when test="@Type='option'">
        <xsl:call-template name="option" />
      </xsl:when>
      <xsl:when test=".=''">
        <!-- do nothing for empty nodes -->
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
		  <xsl:when test="@IsList='true' and not (@Type)">
            <xsl:call-template name="repeater-list" />
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
            <!-- google maps not supported - do nothing -->
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
  <!-- ================================================================================================================================ -->
  <!-- Called from above to handle repeater lists                                                                                     -->
  <!-- ================================================================================================================================ -->
  <xsl:template name="repeater-list">
    <xsl:for-each select="Item">
	  <tr>
		<td>
          <xsl:value-of select="@Name" disable-output-escaping="yes"/>
        </td>
	  </tr>
    </xsl:for-each>
  </xsl:template>
  <!-- ================================================================================================================================ -->
  <!-- Called from above to handle boolean values                                                                                       -->
  <!-- ================================================================================================================================ -->
  <xsl:template name="boolean">
    <xsl:choose>
      <xsl:when test="text() = 'True'">
        <xsl:choose>
          <xsl:when test="not(@TrueText)">
            <xsl:text disable-output-escaping="yes">Yes</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@TrueText" disable-output-escaping="yes"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="text() = 'False'">
        <xsl:choose>
          <xsl:when test="not(@FalseText)">
            <xsl:text disable-output-escaping="yes">No</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@FalseText" disable-output-escaping="yes"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  <!-- ================================================================================================================================ -->
  <!-- Called from above to handle option list values                                                                                   -->
  <!-- ================================================================================================================================ -->
  <xsl:template name="option-list">
    <xsl:choose>
      <xsl:when test="count(Item) = 0">
        <!--<span class="no-answer">Not answered</span>-->
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="Item">
	      <xsl:if test="not(@Index = 0)"><p style="font-size: 6pt;"></p></xsl:if>
          <xsl:call-template name="option" />
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ================================================================================================================================ -->
  <!-- Called from above to handle sub-items in an option list (./* is a child node)                                                    -->
  <!-- ================================================================================================================================ -->
  <xsl:template name="option">
    <xsl:choose>
	  <!-- ============================================================================================================================ -->
      <!-- In the case of consent conditions we have to lookup the consent number from within the FromData section                      -->
	  <!-- ============================================================================================================================ -->
	  <xsl:when test="@Name = 'CONDITION'">
	    <xsl:choose>
		<xsl:when test="descendant::CdtnComplianceStatus/@OptionText or not(descendant::CdtnComplianceStatus/@OptionText='')">
		  <xsl:variable name="index" select="@Index"/>
		  <xsl:value-of select="substring-before(//FormData/ConditionRptr/Item[@Index=[$index]]/Heading,'|')"/>
		  <xsl:text>| </xsl:text>
		  <xsl:value-of select="descendant::CdtnComplianceStatus/@OptionText"/><xsl:text>&#xd;</xsl:text>
		  <xsl:value-of select="descendant::ConditionText[1]/text()"/>
		</xsl:when>
		</xsl:choose>
	  </xsl:when>
	  <xsl:when test="@Name = 'OBSERVATION NOTE'">
	    <xsl:for-each select="./*">
		  <xsl:choose>
		    <xsl:when test="@Type='option' and not(@OptionValue='CustomComment')">
			  <xsl:value-of select="@OptionText"/>
			</xsl:when>			
		    <xsl:when test="@Type='string' and @Description='COMMENTS'">
			  <xsl:value-of select="text()"/>
			</xsl:when>
		  </xsl:choose>
		</xsl:for-each>
	  </xsl:when>
	  <xsl:when test="@Name = 'ACTION'">
		<xsl:value-of select="descendant::*[@Description='TO BE UNDERTAKEN BY']/@OptionText"/>
		<xsl:text> by </xsl:text>
		<xsl:value-of select="descendant::*[@Description='TARGET DATE']/@DisplayValue"/>
		<xsl:text> | </xsl:text>
		<xsl:value-of select="descendant::*[@Description='ACTION DESCRIPTION']/text()"/>
	  </xsl:when>
	  <xsl:when test="@Name = 'TIME RECORD'">
	    <xsl:choose>
		<xsl:when test="not(descendant::ServiceTimeRecordHours/text())">
		  <xsl:text>Time not entered</xsl:text>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="format-number(descendant::ServiceTimeRecordHours/text(),'#0.00')"/>
		  <xsl:text> | </xsl:text>
		  <xsl:value-of select="descendant::ServiceType/@OptionText"/>
		</xsl:otherwise>
		</xsl:choose>
	  </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@OptionText" disable-output-escaping="yes" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ================================================================================================================================ -->
  <!-- Called from above to handle address-finder values                                                                                -->
  <!-- ================================================================================================================================ -->
  <xsl:template name="addressfinderaddress">
    <table>
      <tr style="page-break-inside:avoid;">
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
  <!-- ================================================================================================================================ -->
  <!-- Called from above to handle gmap values                                                                                          -->
  <!-- ================================================================================================================================ -->
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
  <!-- ================================================================================================================================ -->
  <!-- Called from above to handle google maps                                                                                          -->
  <!-- ================================================================================================================================ -->
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
  <!-- ================================================================================================================================ -->
  <!-- Called from above to handle embedded google map (no longer used)                                                                 -->
  <!-- ================================================================================================================================ -->
  <xsl:template name="embed-google-map">
    <xsl:param name="ll" />
    <xsl:element name="img">
      <xsl:attribute name="src">
        <xsl:value-of select="concat('http://mapsfsignature.googleapis.com/maps/api/staticmap?center=', $ll, '&amp;zoom=20&amp;sensor=false&amp;size=600x600%20&amp;maptype=satellite&amp;markers=color:red%7C', $ll)" />
      </xsl:attribute>
      <xsl:attribute name="width">240px</xsl:attribute>
    </xsl:element>
  </xsl:template>
  <!-- ================================================================================================================================ -->
  <!-- Called from above to handle google map hyperlink                                                                                 -->
  <!-- ================================================================================================================================ -->
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
  <!-- ================================================================================================================================ -->
</xsl:stylesheet>
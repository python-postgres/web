<?xml version="1.0" encoding="utf-8"?>
<!--
 ! ticker.xsl - generate the HTML for community ticker
 !-->
<xsl:stylesheet version="1.0"
 xmlns="http://www.w3.org/1999/xhtml"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:exsl="http://exslt.org/common"
 xmlns:atom="http://www.w3.org/2005/Atom"
 xmlns:mail="mail:threads"
 xmlns:date="http://exslt.org/dates-and-times"
 xmlns:int="this:local"
 extension-element-prefixes="exsl date">
<xsl:output method="html" encoding="utf-8"/>
 <xsl:param name="prefix" select="'http://python.projects.postgresql.org/'"/>
 <xsl:param name="commits_ri" select="concat($prefix, 'commitlog.atom')"/>
 <xsl:param name="mail_ri" select="concat($prefix, 'mail.xml')"/>

 <xsl:variable name="commits" select="document($commits_ri)"/>
 <xsl:variable name="mail" select="document($mail_ri)"/>

 <!--
  ! Convert the sources into a common internal format.
  !-->
 <xsl:template match="atom:entry">
  <int:item type="commit">
   <int:timestamp><xsl:value-of
    select="substring(atom:updated, 0, string-length(atom:updated) - string-length('07:00'))"/></int:timestamp>
   <!-- without the trailing '.' -->
   <int:title>
    <xsl:value-of select="substring(normalize-space(atom:title), 0, string-length(atom:title))"/>
    <xsl:if test="substring(normalize-space(atom:title), string-length(atom:title)) != '.'">
     <xsl:value-of select="substring(normalize-space(atom:title), string-length(atom:title))"/>
    </xsl:if>
   </int:title>
   <int:source><xsl:value-of select="atom:author/atom:name"/></int:source>
   <int:link><xsl:value-of select="atom:link/@href"/></int:link>
  </int:item>
 </xsl:template>

 <xsl:template match="mail:thread">
  <int:item type="thread">
   <int:timestamp><xsl:value-of select="@timestamp"/></int:timestamp>
   <int:title><xsl:value-of select="normalize-space(@subject)"/></int:title>
   <int:source><xsl:value-of select="@from"/></int:source>
   <int:link><xsl:value-of select="@href"/></int:link>
  </int:item>
 </xsl:template>

 <xsl:variable name="items">
  <xsl:apply-templates select="$mail/mail:threads/mail:thread"/>
  <xsl:apply-templates select="$commits/atom:feed/atom:entry"/>
 </xsl:variable>

 <xsl:template name="filter">
  <xsl:param name="sorted_items"/>
  <xsl:for-each select="exsl:node-set($sorted_items)/int:items/*">
   <xsl:variable name="prev" select="position()-1"/>
   <xsl:if test="$prev = 0 or @type != 'thread' or ../int:item[$prev+1]/int:title != ../int:item[$prev]/int:title">
    <a href="{int:link}">
    <div class="item">
     <img class="icon">
      <xsl:attribute name="src">
       <xsl:choose>
        <xsl:when test="@type = 'commit'">
         <xsl:text>gears.png</xsl:text>
        </xsl:when>
        <xsl:when test="@type = 'thread'">
         <xsl:text>star.png</xsl:text>
        </xsl:when>
       </xsl:choose>
      </xsl:attribute>
     </img>
     <div class="title"><xsl:value-of select="int:title/text()"/></div>
     <div class="timestamp"><xsl:value-of select="translate(int:timestamp/text(), 'T', ' ')"/></div>
    </div>
    </a>
   </xsl:if>
  </xsl:for-each>
 </xsl:template>

 <xsl:template match="/">
  <html>
   <head>
    <title>pgfoundry.org/python ticker</title>
    <style type="text/css">
     html { font-family: sans-serif; font-size: small; background: rgba(0,0,0,0); scroll: hidden; }
     a { text-decoration: none; color: inherit; }
     div.item { vertical-align: middle; position: relative; }
     div.timestamp { margin-left: 3em; color: gray; }
     div.title { overflow: hidden; text-wrap: none; }
     body { max-width: 5in; }
     img.icon { border-width: 0px; width:20px; height:20px; float: left; margin-right: 5px }
    </style>
   </head>
   <body>
    <xsl:variable name="contents">
     <xsl:call-template name="filter">
      <xsl:with-param name="sorted_items">
       <int:items>
        <xsl:for-each select="exsl:node-set($items)/*">
         <xsl:sort select="int:title"/>
         <xsl:sort select="int:timestamp" order="descending"/>
         <xsl:copy-of select="."/>
        </xsl:for-each>
       </int:items>
      </xsl:with-param>
     </xsl:call-template>
    </xsl:variable>
    <xsl:for-each select="exsl:node-set($contents)/*">
     <xsl:sort select="current()/*/*[local-name()='div' and @class='timestamp']" order="descending"/>
     <xsl:copy-of select="current()"/>
    </xsl:for-each>
   </body>
  </html>
 </xsl:template>
</xsl:stylesheet>
<!--
 ! vim: sw=1:et:ts=1:
 !-->

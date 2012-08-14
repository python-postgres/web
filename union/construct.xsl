<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:exsl="http://exslt.org/common"
 extension-element-prefixes="exsl">

<xsl:output method="html"
 doctype-public="-//W3C//DTD HTML 4.01//EN"
 doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

 <xsl:variable name="keywords">programming,extension,database,driver,interface,pgsql,pg,py,SQL,Python,python3,py-postgresql,pg-python,Postgres,postgres,PostgreSQL,postgresql,postgre,Postgre,procedural language,plpython,plpythonu,PL/Python,PL/PythonU,PL/Python3,psycopg,pygresql,psyco,bsd,mit</xsl:variable>

 <xsl:variable name="project" select="'Python &amp; Postgres'"/>

 <xsl:variable name="frontend" select="exsl:node-set(document('frontend.xml'))"/>
 <xsl:variable name="fe" select="$frontend/published/@name"/>
 <!-- latest release *must* be the last element -->
 <xsl:variable name="fe-default_main_version"
  select="$frontend/published/branch[position()=1]/@version"/>
 <xsl:variable name="fe-default_version"
  select="$frontend/published/branch[position()=1]/release[position()=1]/@version"/>
 <xsl:variable name="fe-default_date"
  select="$frontend/published/branch[position()=1]/release[position()=1]/@date"/>
 <xsl:variable name="fe-branch_version"
  select="$frontend/published/branch[position()=1]/@version"/>

 <xsl:variable name="backend" select="exsl:node-set(document('backend.xml'))"/>
 <xsl:variable name="be" select="$backend/published/@name"/>
 <!-- latest release *must* be the last element -->
 <xsl:variable name="be-default_main_version"
  select="$backend/published/branch[position()=1]/@version"/>
 <xsl:variable name="be-default_version"
  select="$backend/published/branch[position()=1]/release[position()=1]/@version"/>
 <xsl:variable name="be-default_date"
  select="$backend/published/branch[position()=1]/release[position()=1]/@date"/>
 <xsl:variable name="be-branch_version"
  select="$backend/published/branch[position()=1]/@version"/>

 <xsl:template name="release-tree">
  <xsl:for-each select="/published/branch/release[position()=1]">
   <tr>
    <td style="padding-right: 4px;"><a href="docs/{../@version}">v<xsl:value-of select="@version"/></a></td>
    <td>[<xsl:value-of select="@date"/>]</td>
   </tr>
  </xsl:for-each>
 </xsl:template>

 <xsl:template match="file">
  <a title="{@id}" href="files/{@id}"><xsl:value-of select="@type"/>,</a>
 </xsl:template>

 <xsl:template match="platform">
  <table>
   <tr>
    <td>
     <xsl:choose>
      <xsl:when test="platform">
       <xsl:attribute name="class"><xsl:value-of select="'Rident'"/></xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
       <xsl:attribute name="class"><xsl:value-of select="'Fident'"/></xsl:attribute>
      </xsl:otherwise>
     </xsl:choose>
     <xsl:if test="not(@id)"><xsl:value-of select="'source'"/></xsl:if>
     <xsl:value-of select="@id"/>:
    </td>
    <td>
     <xsl:apply-templates/>
    </td>
   </tr>
  </table>
 </xsl:template>

 <xsl:template name="release">
  <xsl:param name="doc"/>
  <div class="releases">
   <xsl:for-each select="/published/branch[not(@hidden)]">
    <table>
     <tr>
      <td class="Rident">
       <xsl:if test="@state = 'unsupported'">
        <img title="unsupported" src="warning.png"/>
        <div/>
       </xsl:if>
       <xsl:value-of select="@id"/>
      </td>
      <td>
       <div>
        <xsl:for-each select="release[not(@hidden)]">
         <table id="R{@id}" class="release_files">
          <tr>
           <td class="Rident">
            <xsl:if test="errata">
             <img title="{errata/text()}" src="warning.png"/><div/>
            </xsl:if>
            <xsl:value-of select="@id"/>
           </td>
           <td class="Rfiles">
            <div><xsl:apply-templates select="*[local-name()!='errata']"/></div>
           </td>
          </tr>
         </table>
        </xsl:for-each>
       </div>
      </td>
     </tr>
    </table>
   </xsl:for-each>
  </div>
 </xsl:template>

 <xsl:template match="/">
  <html>
   <head>
    <title><xsl:value-of select="$project"/></title>
    <meta http-equiv="Content-Style-Type" content="text/css"/>
    <meta name="keywords" content="string($keywords)"/>
    <meta name="description" content="Access Python 3 or PostgreSQL from Either Technology"/>
    <link rel="icon" type="image/png" href="python.svg"/>
    <link rel="stylesheet" type="text/css" href="main.css"/>
    <script type="text/javascript" src="lib/jquery.js"></script>
    <script type="text/javascript" src="lib/jquery.color.js"></script>
    <xsl:copy-of select="document('ga.js.xml')/x/*"/>
   </head>
   <body>
    <div id="offscreen"></div>
    <div id="body">
     <div id="content">
      <table id="layout">
       <tr>
        <td>
         <div class="pane" id="python">
          <a title="Python Programming Language" href="http://python.org"
           ><img class="logo" src="python.svg"/></a>
         </div>
         <div class="pointer">↓</div>
         <div>
          <a title="PostgreSQL DBMS" href="http://postgresql.org"
           ><img class="logo" src="postgres.svg"/></a>
         </div>
         <div>
         </div>
        </td>
        <td>
         <div class="pane" id="postgres">
          <a title="PostgreSQL DBMS" href="http://postgresql.org"
           ><img class="logo" src="postgres.svg"/></a>
         </div>
         <div class="pointer">↓</div>
         <div>
          <a title="Python Programming Language" href="http://python.org"
           ><img class="logo" src="python.svg"/></a>
         </div>
         <div>
         </div>
        </td>
       </tr>
      </table>
     </div>
     <div id="footer">
      <table style="width: 100%">
       <tr>
        <td><a href="license.txt">License: BSD, PostgreSQL, Python, MIT.</a></td>
        <td><a href="http://lists.pgfoundry.org/mailman/listinfo/python-general">Mailing List</a></td>
        <td><a href="https://github.com/jwp/py-postgresql">Source Control</a></td>
        <td><a href="http://github.com/jwp/py-postgresql/issues">Bug Tracker</a></td>
        <td><a href="http://pypi.python.org/pypi/py-postgresql">PyPI</a></td>
        <td><a href="old">Old Site</a></td>
       </tr>
      </table>
     </div>
    </div>
   </body>
  </html>
 </xsl:template>
</xsl:stylesheet>

<!--
 ! vim: sw=1:et:ts=1:
 !-->

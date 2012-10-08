<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:exsl="http://exslt.org/common"
 extension-element-prefixes="exsl">
<xsl:output method="html"
 doctype-public="-//W3C//DTD HTML 4.01//EN"
 doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

 <xsl:template match="/">

  <xsl:variable name="zipball" select="'http://github.com/python-postgres/fe/zipball'"/>

  <xsl:variable name="project" select="/published/@name"/>
  <!-- latest release *must* be the last element -->
  <xsl:variable name="default_main_version"
   select="/published/branch[position()=1]/@version"/>
  <xsl:variable name="default_version"
   select="/published/branch[position()=1]/release[position()=1]/@version"/>
  <xsl:variable name="default_date"
   select="/published/branch[position()=1]/release[position()=1]/@date"/>
  <xsl:variable name="branch_version"
   select="/published/branch[position()=1]/@version"/>

  <html>
   <head>
    <title><xsl:value-of select="$project"/></title>
    <meta http-equiv="Content-Style-Type" content="text/css"/>
    <meta name="keywords"
     content="programming,database,driver,interface,pgsql,pg,py,SQL,Python,python3,py-postgresql,Postgres,postgres,PostgreSQL,postgresql,postgre,Postgre"/>
    <meta name="description" content="Python 3 interface (driver) for PostgreSQL"/>
    <link rel="icon" type="image/png" href="py.png"/>
    <link rel="stylesheet" type="text/css" href="main.css"/>
    <script type="text/javascript" src="lib/jquery.js"></script>
    <script type="text/javascript" src="lib/jquery.color.js"></script>
    <script type="text/javascript">
     /* sloppy sloppy sloppy */

     document.current_reveal = null;
     $(document).ready(function() {

      /* build the tabs on the left side of the screen. */
      e_tabs = $("#retabs")
      $("#undertabs").animate({left:-4}, 'slow')
      if (!$.browser.msie)
       $("#undertabs").animate({color:"#555555"}, 2000)

      $("#reveals div div.rtitle").each(function (){
       e = $('<div>' + $(this).text() + '</div>').hide().appendTo(e_tabs)
       icon = $(this).siblings()[0]
       e.prepend(icon)
       E = e[0]
       x = E.rbody = $(this).siblings()
       E.rbody.rtab = E
       x.css('top', -(x.height()))
      })

      /* create onclick function showing the associated div */
      $("#retabs div").click(function (){
       t = $(this)
       rbodydiv = $(this)[0].rbody
       rbody = $(rbodydiv)
       tab = $(rbodydiv.rtab)
       cr = document.current_reveal

       if (rbodydiv == cr) {
        /* displayed reveal was clicked, so just hide it. */
        crt = $(cr.rtab)
        crt.animate({marginLeft: crt.width(), marginTop: 4, marginBottom: 4}, 'fast');
        rbody.animate({top: -rbody.height() - 10}, 'fast', function(){rbody.hide()})
        document.current_reveal = null;
       }
       else {
        /* diff reveal, so hide it and show the other. */
        if (cr != null) {
         crt = $(cr.rtab)
         crt.animate({marginLeft: crt.width(), marginTop: 4, marginBottom: 4}, 'fast')
         tab.animate({marginLeft: 152, marginTop: 10, marginBottom: 10}, 'fast')
         document.current_reveal = rbodydiv
         $(cr).animate({top: -$(cr).height() - 10}, 'fast', function(){
          $(cr).hide()
          rbody.show()
          rbody.animate({top: 0}, 'fast')
         })
        }
        else {
         /* no reveal shown; show it and slide out  */
         tab.animate({marginLeft: 152, marginTop: 10, marginBottom: 10}, 'fast')
         document.current_reveal = rbodydiv
         rbody.show()
         rbody.animate({top: 0}, 'fast')
        }
       }
      })

      prev = null
      $("#retabs div").each(function (){
       t = $(this)
       /* the last div should do nothing (end of chain) */
       t[0].next_tab = null;
       /* if prev is null, it's the first div */
       if (prev != null)
        prev.next_tab = t[0]
       else
        first = t[0]
       t.show()
       prev = t[0]
      })
      delete prev
      function movein (ele)
      {
       e = $(ele)
       next = e[0].next_tab
       if (next != null){
        nextmove = function () {movein(next)}
       }
       else
        nextmove = function () {;}
       e.animate({marginLeft: e.width()}, 150, nextmove)
      }
      movein($('#retabs div')[0])
      delete movein
     });
    </script>
    <xsl:copy-of select="document('ga.js.xml')/x/*"/>
   </head>
   <body>
    <div id="undertabs"><pre>↑ P(119): b'P\x00\x00\x00v\x00DECLARE "py:0x1191c10" INSENSITIVE SCROLL CURSOR WITH HOLD FOR select i from generate_series(0,100000) as g(i)\x00\x00\x00'
↑ B(13): b'B\x00\x00\x00\x0c\x00\x00\x00\x00\x00\x00\x00\x00'
↑ E(10): b'E\x00\x00\x00\t\x00\x00\x00\x00\x01'
↑ S(5): b'S\x00\x00\x00\x04'
↓ b'1'(0): b''
↓ b'2'(0): b''
↓ b'C'(15): b'DECLARE CURSOR\x00'
↓ b'Z'(1): b'I'
↑ P(43): b'P\x00\x00\x00*\x00FETCH FORWARD 10 IN "py:0x1191c10"\x00\x00\x00'
↑ B(15): b'B\x00\x00\x00\x0e\x00\x00\x00\x00\x00\x00\x00\x01\x00\x01'
↑ E(10): b'E\x00\x00\x00\t\x00\xff\xff\xff\xff'
↑ S(5): b'S\x00\x00\x00\x04'
↓ b'1'(0): b''
↓ b'2'(0): b''
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x00\x00\x00'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x00\x00\x01'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x00\x00\x02'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x00\x00\x03'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x00\x00\x04'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x00\x00\x05'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x00\x00\x06'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x00\x00\x07'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x00\x00\x08'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x00\x00\t'
↓ b'C'(9): b'FETCH 10\x00'
↓ b'Z'(1): b'I'
↑ P(37): b'P\x00\x00\x00$\x00MOVE LAST  IN "py:0x1191c10"\x00\x00\x00'
↑ B(13): b'B\x00\x00\x00\x0c\x00\x00\x00\x00\x00\x00\x00\x00'
↑ E(10): b'E\x00\x00\x00\t\x00\x00\x00\x00\x01'
↑ P(37): b'P\x00\x00\x00$\x00MOVE NEXT  IN "py:0x1191c10"\x00\x00\x00'
↑ B(13): b'B\x00\x00\x00\x0c\x00\x00\x00\x00\x00\x00\x00\x00'
↑ E(10): b'E\x00\x00\x00\t\x00\x00\x00\x00\x01'
↑ P(42): b'P\x00\x00\x00)\x00MOVE BACKWARD 0 IN "py:0x1191c10"\x00\x00\x00'
↑ B(13): b'B\x00\x00\x00\x0c\x00\x00\x00\x00\x00\x00\x00\x00'
↑ E(10): b'E\x00\x00\x00\t\x00\x00\x00\x00\x01'
↑ S(5): b'S\x00\x00\x00\x04'
↓ b'1'(0): b''
↓ b'2'(0): b''
↓ b'C'(7): b'MOVE 1\x00'
↓ b'1'(0): b''
↓ b'2'(0): b''
↓ b'C'(7): b'MOVE 0\x00'
↓ b'1'(0): b''
↓ b'2'(0): b''
↓ b'C'(7): b'MOVE 0\x00'
↓ b'Z'(1): b'I'
↑ P(44): b'P\x00\x00\x00+\x00FETCH BACKWARD 10 IN "py:0x1191c10"\x00\x00\x00'
↑ B(15): b'B\x00\x00\x00\x0e\x00\x00\x00\x00\x00\x00\x00\x01\x00\x01'
↑ E(10): b'E\x00\x00\x00\t\x00\xff\xff\xff\xff'
↑ S(5): b'S\x00\x00\x00\x04'
↓ b'1'(0): b''
↓ b'2'(0): b''
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x01\x86\xa0'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x01\x86\x9f'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x01\x86\x9e'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x01\x86\x9d'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x01\x86\x9c'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x01\x86\x9b'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x01\x86\x9a'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x01\x86\x99'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x01\x86\x98'
↓ b'D'(10): b'\x00\x01\x00\x00\x00\x04\x00\x01\x86\x97'
↓ b'C'(9): b'FETCH 10\x00'
↓ b'Z'(1): b'I'
↑ C(19): b'C\x00\x00\x00\x12Ppy:0x1191c10\x00'
↑ S(5): b'S\x00\x00\x00\x04'
↓ b'3'(0): b''
↓ b'Z'(1): b'I'
↑ X(5): b'X\x00\x00\x00\x04'</pre></div>
    <div id="retabs"></div>
    <div id="backend_link"><a href="backend/">Backend / Procedural Language</a></div>
    <div id="ticker"><iframe src="ticker.html"/></div>
    <div id="reveals">

     <div>
      <img class="ricon" src="downarrow.png" />
      <div class="rtitle">Releases</div>
      <div class="rbody">
       <div style="left:8px;" class="vbar"></div>
       <div style="left:12px;" class="vbar"></div>
       <div style="left:16px;" class="vbar"></div>
       <div class="border">
        <div id="rereleases" class="inner">
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
                  <xsl:if test="@errata">
                   <img title="{@errata}" src="warning.png"/>
                   <div/>
                  </xsl:if>
                  <xsl:value-of select="@id"/>
                 </td>
                 <td class="Rfiles">
                  <a href="{$zipball}/{@id}"><div class="zip">Zip File</div></a>
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
       </div>
      </div>
     </div>

     <div>
      <img class="ricon" src="docicon.png" />
      <div class="rtitle">Documentation</div>
      <div class="rbody">
       <div style="left:8px;" class="vbar"></div>
       <div style="left:12px;" class="vbar"></div>
       <div style="left:16px;" class="vbar"></div>
       <div class="border">
        <div class="inner">
         <table>
          <xsl:for-each select="/published/branch/release[position()=1]">
           <tr>
            <td style="padding-right: 4px;"><a href="docs/{../@version}">v<xsl:value-of select="@version"/></a></td>
            <td>[<xsl:value-of select="@date"/>]</td>
           </tr>
          </xsl:for-each>
         </table>
        </div>
       </div>
      </div>
     </div>
     <!--
      ! Establish example.
      !-->
     <div>
      <img class="ricon" src="gears.png" />
      <div class="rtitle">Connect</div>
      <div class="rbody">
       <div style="left:8px;" class="vbar"></div>
       <div style="left:12px;" class="vbar"></div>
       <div style="left:16px;" class="vbar"></div>
       <div class="border">
        <div class="inner">
PG-API:
<pre>
>>> import postgresql
>>> db = postgresql.open(user = 'usename', database = 'datname', port = 5432)
</pre>
Or, if DB-API 2.0 is the target:
<pre>
>>> import postgresql.driver.dbapi20 as dbapi
>>> db = dbapi.connect(user = 'usename', database = 'datname', port = 5432, password = 'secret')
</pre>
The Driver documentation has more information on acceptable keyword arguments.
        </div>
       </div>
      </div>
     </div>
     <!--
      ! COPY example.
      !-->
     <div>
      <img class="ricon" src="gears.png" />
      <div class="rtitle">COPY</div>
      <div class="rbody">
       <div style="left:8px;" class="vbar"></div>
       <div style="left:12px;" class="vbar"></div>
       <div style="left:16px;" class="vbar"></div>
       <div class="border">
        <div class="inner">
         COPY "FROM STDIN" and "TO STDOUT" is directly supported using the chunking
         interfaces. This is allows for connection-to-connection copies:
         <pre>
>>> send = src.prepare("COPY a_table TO STDOUT")
>>> recv = dst.prepare("COPY a_table FROM STDIN")
>>> recv.load_chunks(send.chunks())
         </pre>
        </div>
       </div>
      </div>
     </div>

     <!--
      ! Sample Syntax Error
      !-->
     <div>
      <img class="ricon" src="gears.png" />
      <div class="rtitle">Syntax Errors</div>
      <div class="rbody">
       <div style="left:8px;" class="vbar"></div>
       <div style="left:12px;" class="vbar"></div>
       <div style="left:16px;" class="vbar"></div>
       <div class="border">
        <div class="inner">
py-postgresql's driver provides additional "element tracebacks" along with
the printed exception. This gives significant contextual information that
may help reduce debugging time:
<pre><![CDATA[
>>> prepare('select 1\nfrom 1d')
Traceback (most recent call last):
  File "<console>", line 1, in <module>
  File "postgresql/driver/pq3.py", line 1718, in prepare
    ps._fini()
  File "postgresql/driver/pq3.py", line 857, in _fini
    self.database._pq_complete()
  File "postgresql/driver/pq3.py", line 1973, in _pq_complete
    self._raise_pq_error(x)
  File "postgresql/driver/pq3.py", line 1999, in _raise_pq_error
    raise err
postgresql.exceptions.SyntaxError: syntax error at or near "1"
  CODE: 42601
  LOCATION: File 'scan.l', line 807, in base_yyerror from SERVER
  POSITION: 15
STATEMENT: [parsing]
  LINE:
    from 1d
         ^ [line 2, character 6]
  statement_id: py:0x10fbc08
  string:
    select 1
    from 1d
CONNECTION: [idle]
  client_address: ::1
  client_port: 52915
  version:
    PostgreSQL 8.3.6 on i386-apple-darwin, compiled by GCC i686-apple-darwin8-gcc-4.0.1 (GCC) 4.0.1 (Apple Computer, Inc. build 5370)
CONNECTOR: [Host] pq://jwp:***@localhost:5432
  category: None
DRIVER: postgresql.driver.pq3.Driver
]]></pre>
        </div>
       </div>
      </div>
     </div>

     <!--
      ! Composites
      !-->
     <div>
      <img class="ricon" src="gears.png" />
      <div class="rtitle">Composites</div>
      <div class="rbody">
       <div style="left:8px;" class="vbar"></div>
       <div style="left:12px;" class="vbar"></div>
       <div style="left:16px;" class="vbar"></div>
       <div class="border">
        <div class="inner">
Composites are supported:
<pre>
>>> db.execute('CREATE TYPE ctyp AS (i int, t text, ts timestamp);')
>>> r = db.prepare("select (901, 'string', now())::ctyp").first()
>>> str(r)
"(901, 'string', datetime.datetime(2009, 5, 12, 20, 23, 30, 351411))"
>>> r[0]
901
>>> r['i']
901
>>> r['ts']
datetime.datetime(2009, 5, 12, 20, 23, 30, 351411)
</pre>
        </div>
       </div>
      </div>
     </div>

     <!--
      ! Credits
      !-->
     <div>
      <img class="ricon" src="star.png" />
      <div class="rtitle">Credits</div>
      <div class="rbody">
       <div style="left:8px;" class="vbar"></div>
       <div style="left:12px;" class="vbar"></div>
       <div style="left:16px;" class="vbar"></div>
       <div class="border">
        <div class="inner">
        Copy of the latest authors file:
<pre>
<![CDATA[
Contributors:
 James William Pye [faults are mostly mine] <x@jwp.io>
 Elvis Pranskevichus
 William Grzybowski [subjective paramstyle]
 Barry Grussling [inet/cidr support]
 Matthew Grant [inet/cidr support]

Support by Donation:
 AppCove Network

Further Credits
===============

When licenses match, people win. Code is occasionally imported from other
projects to enhance py-postgresql and to allow users to enjoy dependency free
installation.


DB-API 2.0 Test Case
--------------------

postgresql/test/test_dbapi20.py:
 Stuart Bishop <zen@shangri-la.dropbear.id.au>


fcrypt
------

postgresql/resolved/crypt.py:
 Carey Evans <careye@spamcop.net>
]]>
</pre>
        </div>
       </div>
      </div>
     </div>

    </div>
    <div id="body">
     <div id="header">
      current version <xsl:value-of select="$default_version"/>
      <xsl:if test="$default_date">
       released on <xsl:value-of select="$default_date"/>
      </xsl:if>
     </div>
     <div id="content">
      <table style="height: 1in; width: 100%; border-width: 0px; padding: 0; margin: 0">
       <tr>
        <td>
         <a href="http://python.org" title="Python Programming Language"><img id="python" src="python-logo.png"/></a>
        </td>
        <td style="width:100%;">
         <div style="margin-left:auto;margin-right:auto; text-align:center; font-weight: bold;">py-postgresql</div>
         <div style="border-style: ridge; border-color: black; border-width: 1px; height: 0.25em; background-color: #4a7aAa;"></div>
         <div style="margin-left:auto;margin-right:auto; text-align:center; font-variant: small-caps;">connect to PostgreSQL with Python 3</div>
        </td>
        <td><a href="http://postgresql.org"><img id="postgresql" title="PostgreSQL DBMS" src="postgresql-logo.png"/></a></td>
       </tr>
      </table>

      <div id="project_description">
       <b>py-postgresql</b> provides a <b>driver</b>, cluster management tools, and client development tools.
      </div>

      <table style="border-spacing: 0px">
       <tr>
        <td style="width: 100%; height: 100%; vertical-align: top">
         <div style="font-size: small; text-align: center; background-color:
                     #F0F0F0; border-style: solid; border-width: 1px; border-color: gray; padding: 2px">
          <i>sample features</i>
         </div>
         <div id="features_frame">
          <table id="features">
           <tr>
            <td>Pure Python</td>
            <td>
             All code, at first, is written in pure Python so that py-postgresql
             will work anywhere that you can install Python 3. Optimizations in C are
             made where needed, but are always optional.
            </td>
           </tr>
           <tr>
            <td>Prepared Statements</td>
            <td>
             Using the PG-API interface, protocol-level prepared statements may be
             created and used multiple times. <tt>db.prepare(sql)(*args)</tt>
            </td>
           </tr>
           <tr>
            <td>COPY Support</td>
            <td>Use the convenient COPY interface to directly copy data from one
            connection to another. No intermediate files or tricks are necessary.</td>
           </tr>
           <tr>
            <td>Arrays and Composite Types</td>
            <td>Arrays and composites are fully supported. Queries requesting
            them will returns objects that provide access to the elements within.</td>
           </tr>
           <tr>
            <td>"pg_python" Quick Console</td>
            <td>Get a Python console with a connection to PostgreSQL for quick tests
            and simple scripts.</td>
           </tr>
          </table>
         </div>
        </td>
       <td style="padding-left: 1em; vertical-align: top;">
        <a title="See the 'Releases' tab for past releases."
         id="download" alt="Download" href="{$zipball}/v{$default_version}">
         <div style="position: relative" class="actions">
          <img class="actions" src="download.png"/>
         </div>
        </a>
        <div class="actions_sep"></div>
        <div class="actions_sep"></div>
        <div class="actions_sep"></div>
        <div class="actions">
         <a id="read" alt="Read" href="docs/{$default_main_version}/"><img class="actions" src="read.png"/></a>
        </div>
        <div class="actions_sep"></div>
        <div class="actions_sep"></div>
        <div class="actions_sep"></div>
        <div class="actions">
         <a id="chat" alt="Chat" href="http://lists.pgfoundry.org/mailman/listinfo/python-general">
          <img class="actions" src="chat.png"/>
         </a>
        </div>
       </td>
      </tr>
     </table>
     </div>
     <div id="footer">
      <table style="width: 100%">
       <tr>
        <td><a href="license.txt">License: BSD</a></td>
        <td><a href="http://github.com/python-postgres/fe/issues">Bug Tracker</a></td>
        <td><a href="http://pgfoundry.org/projects/python">Project Page</a></td>
        <td><a href="http://pypi.python.org/pypi/py-postgresql">PyPI</a></td>
        <td><a href="http://wiki.github.com/python-postgres/fe">Wiki</a></td>
        <td><a href="http://lists.pgfoundry.org/mailman/listinfo/python-general">Mailing List</a></td>
        <td><a href="https://github.com/python-postgres/fe/tree">SCM</a></td>
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

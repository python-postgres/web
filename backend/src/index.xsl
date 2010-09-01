<xsl:stylesheet version="1.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:exsl="http://exslt.org/common"
 extension-element-prefixes="exsl">

<xsl:output method="html"
 doctype-public="-//W3C//DTD HTML 4.01//EN"
 doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

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

 <xsl:template match="/">
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
     content="programming,database,procedural language,extension,plpython,plpythonu,pgsql,pg,py,SQL,Python,python3,PL/Python,PL/PythonU,PL/Python3,Postgres,PostgreSQL"/>
    <meta name="description" content="Python 3 procedural language extension for PostgreSQL" />
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
    <div id="retabs"></div>
    <div id="frontend_link"><a href="/">Frontend</a></div>
    <div id="reveals">
     <div>
      <img class="ricon" src="downarrow.png" />
      <div class="rtitle">Releases</div>
      <div class="rbody">
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
                  <xsl:if test="errata">
                   <img title="{errata/text()}" src="warning.png"/>
                   <div/>
                  </xsl:if>
                  <xsl:value-of select="@id"/>
                 </td>
                 <td class="Rfiles">
                  <div>
                   <xsl:apply-templates select="*[local-name()!='errata']"/>
                  </div>
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
       <div class="border">
        <div class="inner">
         <table>
          <xsl:for-each select="/published/branch/release[position()=1]">
           <tr>
            <td style="padding-right: 4px;"><a href="docs/{../@version}/">v<xsl:value-of select="@version"/></a></td>
            <td><xsl:value-of select="@date"/></td>
           </tr>
          </xsl:for-each>
         </table>
        </div>
       </div>
      </div>
     </div>
     <!--
      ! CREATE example.
      !-->
     <div>
      <img class="ricon" src="gears.png" />
      <div class="rtitle">Normal Functions</div>
      <div class="rbody">
       <div class="border">
        <div class="inner">
Functions are Modules, so just define main and you're off:
<pre><![CDATA[
CREATE OR REPLACE FUNCTION
hello(world text) RETURNS text LANGUAGE python AS
$$
import Postgres

template = "Hello, {0}!"

@pytypes
def main(*args):
    tail = args[0]
    if tail is None:
        tail = 'World'
    return template.format(tail)
$$;

SELECT hello(NULL);
--     hello     
-----------------
-- Hello, World!
--(1 row)

SELECT hello('Bunnies');
--      hello      
-------------------
-- Hello, Bunnies!
--(1 row)

]]></pre>
        </div>
       </div>
      </div>
     </div>
     <!--
      ! SRF
      !-->
     <div>
      <img class="ricon" src="gears.png" />
      <div class="rtitle">Returning Sets</div>
      <div class="rbody">
       <div class="border">
        <div class="inner">
Set Returning Functions are supported via iterators:
<pre><![CDATA[
CREATE OR REPLACE FUNCTION
my_favorite_things() RETURNS SETOF text LANGUAGE python AS
$$
import Postgres

only_a_few_of = [
    'raindrops on roses',
    'whiskers on kittens',
    'bright copper kettles',
    'warm woolen mittens',
    'brown paper packages tied up with strings',
]

def main(*args):
    # no args, actually..
    # And, we could just return the list, but
    # for the purpose of illustration, we'll use
    # a generator.
    #
    for x in only_a_few_of:
        yield x
$$;

SELECT * FROM my_favorite_things();
--            my_favorite_things             
---------------------------------------------
-- raindrops on roses
-- whiskers on kittens
-- bright copper kettles
-- warm woolen mittens
-- brown paper packages tied up with strings
--(5 rows)
]]></pre>
        </div>
       </div>
      </div>
     </div>
     <!--
      ! TRIGGER example.
      !-->
     <div>
      <img class="ricon" src="gears.png" />
      <div class="rtitle">Triggers</div>
      <div class="rbody">
       <div class="border">
        <div class="inner">
Trigger Returning Functions have multiple entry points:
<pre><![CDATA[
CREATE OR REPLACE FUNCTION
tell_me() RETURNS TRIGGER LANGUAGE python AS
$$
from Postgres import NOTICE

def before_insert(td, new):
    NOTICE('inserted: ' + str(new))

def before_update(td, old, new):
    NOTICE('updated ' + str(old) + ' to ' + str(new))

def before_delete(td, old):
    NOTICE('deleted: ' + str(old))
$$;

CREATE TABLE paranoia (i int, t text);
CREATE TRIGGER watching_it BEFORE INSERT OR UPDATE OR DELETE
 ON paranoia FOR EACH ROW
 EXECUTE PROCEDURE tell_me();

INSERT INTO paranoia VALUES (0, 'ucme');
--NOTICE:  inserted: (0,ucme)
--INSERT 0 1

UPDATE paranoia SET i = 15;
--NOTICE:  updated (0,ucme) to (15,ucme)
--UPDATE 1

DELETE FROM paranoia;
--NOTICE:  deleted: (15,ucme)
--DELETE 1
]]></pre>
        </div>
       </div>
      </div>
     </div>

     <!--
      ! Traceback
      !-->
     <div>
      <img class="ricon" src="gears.png" />
      <div class="rtitle">Full Tracebacks</div>
      <div class="rbody">
       <div class="border">
        <div class="inner">
By managing code with modules, tracebacks are easy:
<pre><![CDATA[
CREATE OR REPLACE FUNCTION
it_blows_up() RETURNS VOID LANGUAGE python AS
$$

def one():
    raise OverflowError("there's water everywhere")

def two():
    return one()

def three():
    return two()

# enters here:
def main():
    three()
$$;

SELECT it_blows_up();
-- ERROR:  function's "main" raised a Python exception
-- CONTEXT:  [exception from Python]
-- Traceback (most recent call last):
--    File "public.it_blows_up()", line 13, in main
--     three()
--    File "public.it_blows_up()", line 10, in three
--     return two()
--    File "public.it_blows_up()", line 7, in two
--     return one()
--    File "public.it_blows_up()", line 4, in one
--     raise OverflowError("there's water everywhere")
--  OverflowError: there's water everywhere
--
-- [public.it_blows_up()]
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
       <div class="border">
        <div class="inner">
Composites are supported as a sequence and a mapping:
<pre><![CDATA[
BEGIN;
CREATE TYPE foo AS (i int, t text);

CREATE OR REPLACE FUNCTION
fields_as_string(x foo) RETURNS TEXT LANGUAGE python AS
$$
template = """
i = {0!s}
t = {1!s}
0 = {2!s}
1 = {3!s}
"""

def main(x):
    return template.format(
        x['i'], x['t'], x[0], x[1],
    )
$$;

SELECT fields_as_string(ROW(-1,'kittens with mittens!')::foo);
--     fields_as_string      
-----------------------------
--                          +
-- i = -1                   +
-- t = kittens with mittens!+
-- 0 = -1                   +
-- 1 = kittens with mittens!+
-- 
--(1 row)

SELECT fields_as_string(ROW(57,NULL)::foo);
-- fields_as_string 
--------------------
--                 +
-- i = 57          +
-- t = None        +
-- 0 = 57          +
-- 1 = None        +
-- 
--(1 row)
ABORT;
]]></pre>
        </div>
       </div>
      </div>
     </div>

     <!--
      ! Interrupts
      !-->
     <div>
      <img class="ricon" src="gears.png" />
      <div class="rtitle">Interrupts</div>
      <div class="rbody">
       <div class="border">
        <div class="inner">
Python FUNCTIONs can be interrupted:
<pre><![CDATA[
postgres=# CREATE OR REPLACE FUNCTION infinite_loop() RETURNS text LANGUAGE python AS
postgres-# $$
postgres$# def main():
postgres$#  while 1:
postgres$#   pass
postgres$#  return 'never happens'
postgres$# $$;
CREATE FUNCTION
postgres=# SELECT infinite_loop();
^CCancel request sent
ERROR:  canceling statement due to user request
CONTEXT:  [exception from Python]
Traceback (most recent call last):
   File "__python__.infinite_loop()", line 4, in main
    pass
 Postgres.Exception

[__python__.infinite_loop()]
]]></pre>
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
       <div class="border">
        <div class="inner">
        Copy of the latest authors file:
<pre>
<![CDATA[
Primary Developers:
 James William Pye <x@jwp.name>
]]>
</pre>
        </div>
       </div>
      </div>
     </div>

    </div>
    <div id="boundary">
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
         <td><a href="http://postgresql.org"><img id="postgresql" title="PostgreSQL DBMS" src="postgresql-logo.png"/></a></td>
         <td style="width:100%;">
          <div style="margin-left:auto;margin-right:auto; text-align:center;">pg-python</div>
          <div id="display_title_partition"></div>
          <div style="margin-left:auto;margin-right:auto; text-align:center; font-variant: small-caps;">execute Python code with PostgreSQL</div>
         </td>
         <td>
          <a href="http://python.org" title="Python Programming Language"><img id="python" src="python-logo.png"/></a>
         </td>
        </tr>
       </table>

       <div id="project_description">
        pg-python is a Python 3 <b>procedural language extension</b> for PostgreSQL.
       </div>

       <table style="border-spacing: 0px">
        <tr>
         <td style="width: 100%; height: 100%; vertical-align: top">
          <div style="font-size: small; text-align: center; color: #cccc11; border-width: 0px; padding: 2px">
           <i>sample features</i>
          </div>
          <div id="features_frame">
           <table id="features">
            <tr>
             <td>Functions are Modules</td>
             <td>
              Function code is managed using modules.
              Take advantage of an initialization section.
             </td>
            </tr>
            <tr>
             <td>Native Typing</td>
             <td>
              Parameters given to functions are "Postgres data objects" with
              interfaces that suite the actual data type.
             </td>
            </tr>
            <tr>
             <td>Full Tracebacks</td>
             <td>Never wonder where the exception came from again.</td>
            </tr>
            <tr>
             <td>Set Returning Functions</td>
             <td>
              Supports both VPC and Materialization.
              Optimized Postgres.Cursor returns can help keep Python interpreter
              overhead out of the equation.
             </td>
            </tr>
            <tr>
             <td>Direct Function Calls</td>
             <td>
              Avoid any SPI/parser/planner/executor overhead when calling simple functions.
             </td>
            </tr>
            <tr>
             <td>Subtransactions</td>
             <td>
              Recover from database errors using the "xact()" context manager.
             </td>
            </tr>
           </table>
          </div>
         </td>
        <td style="padding-left: 1em; vertical-align: top;
        border-width: 0px; border-left-width: 1px; border-style: solid;
        border-color: yellow; padding-top: 6px;">
         <a title="See the 'Releases' tab for more targets."
          id="download" alt="Download" href="files/{$project}-{$default_version}.tar.bz2">
          <div style="" class="actions">download<img src="downarrow.png"/></div>
         </a>
         <a title="Documentation of Latest Version" id="read" alt="Read" href="docs/{$default_main_version}/">
          <div class="actions">read docs<img class="actions" src="read.png"/></div>
         </a>
         <a title="Mailman Mailing List" id="chat" alt="Chat" href="http://lists.pgfoundry.org/mailman/listinfo/python-general">
          <div class="actions">discuss<img class="actions" style="margin-top: -16px;" src="chat.png"/></div>
         </a>
        </td>
       </tr>
      </table>
      </div>
     </div>
     <div id="footer">
      <table style="width: 100%">
       <tr>
        <td><a href="license.txt">License: BSD</a></td>
        <td><a href="http://github.com/jwp/pg-python/issues">Bug Tracker</a></td>
        <td><a href="http://pgfoundry.org/projects/python">Project Page</a></td>
        <td><a href="http://wiki.github.com/jwp/pg-python">Wiki</a></td>
        <td><a href="http://lists.pgfoundry.org/mailman/listinfo/python-general">Mailing List</a></td>
        <td><a href="https://github.com/jwp/pg-python/tree">SCM</a></td>
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

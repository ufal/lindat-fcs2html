<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:ufal="http://lindat.mff.cuni.cz/services/static/fcs-utils" 
  xmlns:sru="http://www.loc.gov/zing/srw/" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:fcs="http://clarin.eu/fcs/1.0" 
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
  version="2.0" 
  extension-element-prefixes="sru fcs ufal xs xd"
  >

	<xsl:output method="html" 
    doctype-public="-//W3C//DTD HTML 4.01//EN" 
    doctype-system="http://www.w3.org/TR/html4/strict.dtd" 
  />

    <xsl:variable name="title">LINDAT/CLARIN FCS</xsl:variable>

	<xsl:template match="/">
<html>
  <head>
        <title><xsl:copy-of select="$title" /></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <script src="//code.jquery.com/jquery.min.js"
            type="text/javascript"></script>
        <script type="text/javascript">
          jQuery(document).ready(function() { 
            prot = window.location.protocol;
            host = window.location.host;
            jQuery('a').each(function(){
              href =  jQuery(this).attr('href');
              if ( href.indexOf(host) !== -1 ) {
                arr = href.split('/');
                if ( arr.length > 0)
                  if (arr[0] != prot ) {
                    href = href.replace(arr[0], prot);
                    jQuery(this).attr('href', href);
                  }
              }
            });
          });
        </script>
        <link rel="stylesheet" href="//lindat.mff.cuni.cz/static/bootstrap-3.0.3/bootstrap.min.css" />
        <script src="//lindat.mff.cuni.cz/static/bootstrap-3.0.3/bootstrap.min.js"></script>

        <script type="text/javascript">
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
          m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
         })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

        // main LINDAT/CLARIN tracker
        ga('create', 'UA-27008245-2', 'cuni.cz');
        ga('send', 'pageview');
        </script>

  </head>
  <body>

  <div style="min-height:70px">
  <nav class="navbar navbar-default navbar-fixed-top" role="navigation">
    <div class="navbar-header">
      <a class="navbar-brand" href="http://lindat.mff.cuni.cz"><xsl:copy-of select="$title" /></a>
    </div>

   <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
       <ul class="nav navbar-nav">
          <li class=""><a href="?version=1.2&amp;operation=explain">Explain</a></li>
          <li class=""><a href="?version=1.2&amp;operation=scan&amp;scanClause=fcs.resource=root">Scan/List</a></li>

          <li id="fat-menu" class="dropdown">
             <a id="drop3" href="#" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" role="button" aria-expanded="false"> Test Queries <span class="caret"></span> </a>
              <ul class="dropdown-menu" role="menu" aria-labelledby="drop3">
                 <li role="presentation">
                     <a role="menuitem" href="?operation=searchRetrieve&amp;version=1.2&amp;query=%22test%22&amp;startRecord=1&amp;maximumRecords=10&amp;recordSchema=http%3A%2F%2Fclarin.eu%2Ffcs%2F1.0">Search for "test"</a></li>
                 <li role="presentation">
                     <a role="menuitem" href="?operation=searchRetrieve&amp;version=1.2&amp;query=%22test%22&amp;startRecord=1&amp;maximumRecords=10&amp;recordSchema=http%3A%2F%2Fclarin.eu%2Ffcs%2F1.0&amp;x-cmd-context=bushbank">Search for "test" as Aggregator</a></li>
              </ul>
           </li>

       </ul>

      <ul class="nav navbar-nav navbar-right">
        <li><a href="http://weblicht.sfs.uni-tuebingen.de/Aggregator/">Aggregator</a></li>
        <li><a href="https://trac.clarin.eu/wiki/FCS-specification">FCS docs</a></li>
        <li><a href="http://clarin.ids-mannheim.de/srutest/app/">FCS validator</a></li>
        <li><a href="https://lindat.mff.cuni.cz/services/kontext">Web GUI</a></li>
        <li style="width:100px">SRU <span class="badge">v<xsl:value-of select="/*/sru:version"/></span></li>
      </ul>

   </div>
  </nav>
  </div>


  <div id="response">
    <pre>
      <xsl:apply-templates mode="escape"/>
    </pre>
  </div>
  </body>
</html>
	</xsl:template>


    <xsl:template match="*" mode="escape">
        <!-- Begin opening tag -->
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="name()"/>

        <!-- Attributes -->
        <xsl:for-each select="@*">
            <xsl:text> </xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>='</xsl:text>
            <xsl:call-template name="escape-xml">
                <xsl:with-param name="text" select="."/>
            </xsl:call-template>
            <xsl:text>'</xsl:text>
        </xsl:for-each>

        <!-- End opening tag -->
        <xsl:text>&gt;</xsl:text>

        <!-- Content (child elements, text nodes, and PIs) -->
        <xsl:apply-templates select="node()" mode="escape" />

        <!-- Closing tag -->
        <xsl:text>&lt;/</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text>&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="text()" mode="escape">
        <xsl:call-template name="escape-xml">
            <xsl:with-param name="text" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="processing-instruction()" mode="escape">
        <xsl:text>&lt;?</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="escape-xml">
            <xsl:with-param name="text" select="."/>
        </xsl:call-template>
        <xsl:text>?&gt;</xsl:text>
    </xsl:template>

    <xsl:template name="escape-xml">
        <xsl:param name="text"/>
        <xsl:if test="$text != ''">
            <xsl:variable name="head" select="substring($text, 1, 1)"/>
            <xsl:variable name="tail" select="substring($text, 2)"/>
            <xsl:choose>
                <xsl:when test="$head = '&amp;'">&amp;amp;</xsl:when>
                <xsl:when test="$head = '&lt;'">&amp;lt;</xsl:when>
                <xsl:when test="$head = '&gt;'">&amp;gt;</xsl:when>
                <xsl:when test="$head = '&quot;'">&amp;quot;</xsl:when>
                <xsl:when test="$head = &quot;&apos;&quot;">&amp;apos;</xsl:when>
                <xsl:otherwise><xsl:value-of select="$head"/></xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="escape-xml">
                <xsl:with-param name="text" select="$tail"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>

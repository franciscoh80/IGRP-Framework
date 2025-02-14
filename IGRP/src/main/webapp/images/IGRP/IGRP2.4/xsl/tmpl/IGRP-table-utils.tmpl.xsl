<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- TABLE TYPES -->
  <!-- TD COLOR -->
  <xsl:template mode="table.buttonlist" name="table.buttonlist" match="*">
    <div class="tb-btn-list-holder">
      <xsl:for-each select="value/row">
        <xsl:value-of select="nome"/>
        <br/>
      </xsl:for-each>
    </div>
  </xsl:template>
  <!-- TD COLOR -->
  <xsl:template name="tdcolor">

    <xsl:param name="color" select="''"/>

    <xsl:param name="table-colors" select="../../legend_color/item"/>

    <xsl:attribute name="class">tdcolor</xsl:attribute>

    <span class="tdcolor-item" style="background:{$table-colors[value=$color]/color}"></span>

  </xsl:template>
  <!--TEMPLATE FOR TABLE EXPORT OPTIONS-->
  <xsl:template name="table-export-options">

    <xsl:param name="pdf" select="false()"/>
    <xsl:param name="excel" select="false()"/>

    <div class="table-export-options clearfix">
      <div class="btn-group pull-right">

        <xsl:if test="$pdf">
          <a class="btn btn-danger btn-xs" href="#" rel="pdf">
            <i class="fa fa-file-pdf-o"></i>
            <span>PDF</span>
          </a>
        </xsl:if>

        <xsl:if test="$excel">
          <a class="btn btn-success btn-xs" href="#" rel="excel">
            <i class="fa fa-file-excel-o"></i>
            <span>Excel</span>
          </a>
        </xsl:if>

        <!-- <button type="button" class="btn btn-sm btn-warning" data-toggle="dropdown"><i class="fa fa-cloud-download"></i></button>
       
        <ul class="dropdown-menu" role="menu">
          <li>
            <xsl:if test="$pdf">
              <a href="#"><i class="fa fa-file-pdf-o"/><span>PDF</span></a>
            </xsl:if>
          </li>
          <li>
            <xsl:if test="$excel">
              <a href="#"><i class="fa fa-file-excel-o"/><span>EXCEL</span></a>
            </xsl:if>
          </li>
        </ul>  -->
      </div>
    </div>
  </xsl:template>
  <!--TEMPLATE FOR TABLE LEGEND-->
  <xsl:template mode="table-legend" name="table-legend" match="legend_color">
    <div class="box-table-legend">
      <xsl:for-each select="item">
        <div class="legend-holder">
          <p class="legend-lbl">
            <xsl:if test="string-length(label) &gt; 17">
              <xsl:attribute name="title">
                <xsl:value-of select="label"/>
              </xsl:attribute>
              <xsl:attribute name="alt">
                <xsl:value-of select="label"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="label"/>
          </p>

          <div class="legend-item" style="background:{color}"></div>

        </div>
      </xsl:for-each>
    </div>
  </xsl:template>
  <!-- CONTEXT MENU -->
  <xsl:template name="table-context-menu" mode="table-context-menu" match="context-menu">

    <xsl:param name="use-fa" select="'true'"/>
    <xsl:param name="view"/>

    <xsl:variable name="vclass">
      <xsl:choose>
        <xsl:when test="$view = 'lavel-menu'">btn</xsl:when>
        <xsl:otherwise>list-group-item</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="list-group {$view} table-context-menu clearfix table-ctx-holder" use-fa="{$use-fa}">
      <xsl:for-each select="item">
        <li id="CTX_ID_{position()}" class="operationTable " ctx-type="{@type}" trel="{@rel}">
          <xsl:call-template name="table-ctx-item">
            <xsl:with-param name="use-fa" select="$use-fa"/>
            <xsl:with-param name="class" select="$vclass"/>
            <xsl:with-param name="view" select="$view"/>
          </xsl:call-template>
        </li>
      </xsl:for-each>
    </div>
  </xsl:template>
  <!-- CONTEXT MENU INLINE -->
  <xsl:template name="table-context-inline" mode="table-context-inline" match="context-menu">

    <xsl:param name="row-params" select="../value/row/context-menu"/>
    <xsl:param name="type"/>
    <xsl:param name="use-fa" select="'true'"/>

    <xsl:variable name="ctx_hidden" select="$row-params/param[contains(text(), 'ctx_hidden')]"/>

    <xsl:variable name="ctx_param">
      <xsl:for-each select="$row-params/param[not(contains(., 'ctx_hidden'))]">
        <xsl:text>&amp;</xsl:text>
        <xsl:value-of select="."/>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="ctx_param_report">
      <xsl:for-each select="$row-params/param[not(contains(., 'ctx_hidden'))]">
        <xsl:text>&amp;name_array=</xsl:text>
        <xsl:value-of select="substring-before(.,'=')"/>
        <xsl:text>&amp;value_array=</xsl:text>
        <xsl:value-of select="substring-after(.,'=')"/>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="ctxHiddenContent" select="substring-after($ctx_hidden,'=')"/>

    <xsl:variable name="ctxHiddenTotal">
      <xsl:call-template name="countCtxHidden">
        <xsl:with-param name="text" select="$ctx_hidden"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$type = 'dropdown'">

        <div class="dropdown pull-right igrp-table-dd-ctx">
          <button class="btn btn-xs btn-default dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
            <span class="caret"></span>
          </button>
          <ul class="dropdown-menu table-ctx-holder">
            <xsl:for-each select="item">
              <xsl:variable name="rowCtxHiddenTitle">
                <xsl:call-template name="ctxHiddenTitle">
                  <xsl:with-param name="vText" select="$ctxHiddenContent"/>
                  <xsl:with-param name="ctx" select="@rel"/>
                  <xsl:with-param name="item" select="string-length($ctxHiddenTotal)"/>
                </xsl:call-template>
              </xsl:variable>

              <xsl:variable name="ctx_holder">
                <xsl:choose>
                  <xsl:when test="@type = 'report'">
                    <xsl:value-of select="$ctx_param_report"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$ctx_param"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>

              <li id="CTX_ID_{position()}" class="operationTable " trel="{@rel}">
                <xsl:choose>
                  <xsl:when test="$rowCtxHiddenTitle != @rel">
                    <xsl:attribute name="title">
                      <xsl:value-of select="title"/>
                    </xsl:attribute>
                    <xsl:call-template name="table-ctx-item">
                      <xsl:with-param name="use-fa" select="$use-fa"/>
                      <xsl:with-param name="size" select="'xs'"/>
                      <xsl:with-param name="ctx-params" select="$ctx_holder"/>
                      <xsl:with-param name="class" select="''"></xsl:with-param>
                      <xsl:with-param name="text-class" select="@class"></xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="invisible">true</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </li>

            </xsl:for-each>
          </ul>
        </div>

      </xsl:when>

      <xsl:otherwise>
        <div class="clearfix table-ctx-holder d-flex">
          <xsl:for-each select="item">
            <xsl:variable name="rowCtxHiddenTitle">
              <xsl:call-template name="ctxHiddenTitle">
                <xsl:with-param name="vText" select="$ctxHiddenContent"/>
                <xsl:with-param name="ctx" select="@rel"/>
                <xsl:with-param name="item" select="string-length($ctxHiddenTotal)"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="ctx_holder">
              <xsl:choose>
                <xsl:when test="@type = 'report'">
                  <xsl:value-of select="$ctx_param_report"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$ctx_param"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <div id="CTX_ID_{position()}" class="operationTable d-flex align-items-center ms-1" trel="{@rel}">
              <xsl:choose>
                <xsl:when test="$rowCtxHiddenTitle != @rel">
                  <xsl:attribute name="title">
                    <xsl:value-of select="title"/>
                  </xsl:attribute>
                  <xsl:call-template name="table-ctx-item">
                    <xsl:with-param name="use-fa" select="$use-fa"/>
                    <xsl:with-param name="size" select="'sm'"/>
                    <xsl:with-param name="ctx-params" select="$ctx_holder"/>

                    <xsl:with-param name="class" select="'btn-ctx-inline-item btn-sm'"/>
                
                    <xsl:with-param name="text-class" select="' '"></xsl:with-param>


                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="invisible">true</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </div>

          </xsl:for-each>
        </div>

      </xsl:otherwise>
    </xsl:choose>



  </xsl:template>
  <!-- TABLE CTX ITEMS -->
  <xsl:template name="table-ctx-item">

    <xsl:param name="use-fa" select="'true'"/>
    <xsl:param name="size" select="'normal'"/>
    <xsl:param name="class" select="'btn'"/>
    <xsl:param name="text-class" select="''"/>
    <xsl:param name="ctx-params" select="''"/>
    <xsl:param name="view"/>

    <a id="{@id}" class="{$class}" target="{target}" icon-position="{img/@position}">
      <xsl:choose>
        <xsl:when test="contains(target, '|')">
          <xsl:call-template name="get-target-params">
            <xsl:with-param name="list" select="target"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="target">
            <xsl:value-of select="target"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="@labelConfirm">
        <xsl:attribute name="label-confirm">
          <xsl:value-of select="@labelConfirm"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="$view = 'lavel-menu'">
        <xsl:attribute name="title">
          <xsl:value-of select="title"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:call-template name="page-nav">
        <xsl:with-param name="action" select="link"/>
        <xsl:with-param name="page" select="page"/>
        <xsl:with-param name="app" select="app"/>
        <xsl:with-param name="linkextra" select="concat(parameter,$ctx-params)"/>
      </xsl:call-template>

      <xsl:if test="img">
        <xsl:call-template name="igrp-get-icon-item-with-color">
          <xsl:with-param name="list" select="img"/>
          <xsl:with-param name="use-fa" select="$use-fa"/>
          <xsl:with-param name="img-folder" select="'tools-bar'"/>
          <xsl:with-param name="size" select="$size"/>
          <xsl:with-param name="btnClass" select="$class"/>
          <xsl:with-param name="text-class" select="$text-class"/>
        </xsl:call-template>
      </xsl:if>

      <xsl:if test="$view != 'lavel-menu' and title!=''">
        <span class="ctx-title text-{$text-class}">
          <xsl:value-of select="title"/>
        </span>
      </xsl:if>

    </a>
  </xsl:template>
  <!-- CONTEXT MENU PARAM -->
  <xsl:template name="context-param" mode="context-param" match="context-menu">
    <xsl:attribute name="CTX_PARAM_COUNT">
      <xsl:value-of select="count(param)" />
    </xsl:attribute>
    <xsl:attribute name="CTX_FORM">
      <xsl:value-of select="ctx_form" />
    </xsl:attribute>
    <xsl:attribute name="CTX_FORM_IDX">
      <xsl:value-of select="ctx_form_idx" />
    </xsl:attribute>
    <xsl:for-each select="param">
      <xsl:attribute name="CTX_P{position()}">
        <xsl:value-of select="." />
      </xsl:attribute>
    </xsl:for-each>
  </xsl:template>
  <!--HIDDEN CTX COUNT-->
  <xsl:template name="countCtxHidden">
    <xsl:param name="text"/>
    <xsl:param name="separator" select="','"/>
    <xsl:param name="cont" select="0"/>
    <xsl:choose>
      <xsl:when test="not(contains($text, $separator))">
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="countCtxHidden">
          <xsl:with-param name="cont" select="$cont + 1"/>
          <xsl:with-param name="text" select="substring-after($text, $separator)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$cont"/>
  </xsl:template>
  <!-- CTX HIDDEN TITLE -->
  <xsl:template name="ctxHiddenTitle">
    <xsl:param name="vText"/>
    <xsl:param name="ctx"/>
    <xsl:param name="item"/>
    <xsl:param name="pos" select="0"/>
    <xsl:param name="separator" select="','"/>
    <xsl:if test="$vText != ''">
      <xsl:choose>
        <xsl:when test="contains($vText, $separator)">
          <xsl:variable name="ctxAfter" select="substring-after($vText, $separator)"/>
          <xsl:variable name="ctxBefore" select="substring-before($vText, $separator)"/>
          <xsl:if test="$pos &lt; $item">
            <xsl:choose>
              <xsl:when test="$ctx = $ctxBefore">
                <xsl:value-of select="$ctx"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="ctxHiddenTitle">
                  <xsl:with-param name="vText" select="$ctxAfter"/>
                  <xsl:with-param name="ctx" select="$ctx"/>
                  <xsl:with-param name="item" select="$item"/>
                  <xsl:with-param name="pos" select="$pos + 1"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$vText"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- TABLE FILTER -->
  <xsl:template name="table-filter">
    <xsl:param name="name"/>
    <xsl:param name="value"/>
    <xsl:param name="type"/>
    <xsl:param name="filter_pagination"/>

    <xsl:if test="$type">
      <xsl:variable name="filter-items">
        <xsl:choose>
          <xsl:when test="$type = 'filter_num'">
            <xsl:choose>
              <xsl:when test="$filter_pagination">
                <xsl:value-of select="$filter_pagination"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>0|1|2|3|4|5|6|7|8|9</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$type = 'filter_aznum'">
            <xsl:text>A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|0|1|2|3|4|5|6|7|8|9</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <div class="igrp-table-filter">
        <ul class="pagination">
          <xsl:call-template name="table-filter-loop">
            <xsl:with-param name="name" select="$name" />
            <xsl:with-param name="value" select="$value" />
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="filter-items" select="$filter-items"/>
          </xsl:call-template>
        </ul>
      </div>
    </xsl:if>

  </xsl:template>

  <xsl:template name="table-filter-loop">
    <xsl:param name="name" select="''" />
    <xsl:param name="value" select="''" />
    <xsl:param name="type" select="''"/>
    <xsl:param name="delimiter" select="'|'"/>
    <xsl:param name="filter-items" select="''"/>

    <xsl:variable name="containsDelimiter" select="contains($filter-items, $delimiter)"/>

    <xsl:variable name="filter-item">
      <xsl:choose>
        <xsl:when test="$containsDelimiter">
          <xsl:value-of select="substring-before($filter-items,$delimiter)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$filter-items"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <li filter-item="{$filter-item}" style-listener="true">
      <xsl:if test="$filter-item = $value">
        <xsl:attribute name="class">active</xsl:attribute>
      </xsl:if>
      <a href="{$name}={$filter-item}" class="IGRP_filter" target="filter" active-bg-color="primary">
        <xsl:value-of select="$filter-item"/>
      </a>
    </li>

    <xsl:if test="$containsDelimiter">
      <xsl:call-template name="table-filter-loop">
        <xsl:with-param name="name" select="$name" />
        <xsl:with-param name="value" select="$value" />
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="delimiter" select="'|'"/>
        <xsl:with-param name="filter-items" select="substring-after($filter-items,$delimiter)"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <xsl:template name="table-filter-loop1">
    <xsl:param name="name" select="''" />
    <xsl:param name="value" select="''" />
    <xsl:param name="type" select="''"/>
    <xsl:param name="filter-items" select="''"/>

    <xsl:param name="i" select="1" />

    <xsl:if test="$i &lt;= string-length($filter-items)">

      <xsl:variable name="filter-item" select="substring($filter-items,$i,1)" />

      <li>
        <xsl:if test="$filter-item = $value">
          <xsl:attribute name="class">active</xsl:attribute>
        </xsl:if>
        <a href="{$name}={$filter-item}" class="IGRP_filter" target="filter">
          <xsl:value-of select="$filter-item"/>
        </a>
      </li>

      <xsl:call-template name="table-filter-loop">
        <xsl:with-param name="name" select="$name" />
        <xsl:with-param name="value" select="$value" />
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="filter-items" select="$filter-items"/>
        <xsl:with-param name="i" select="$i+1"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
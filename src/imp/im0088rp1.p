/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0088RP1 2.00.00.002 } /*** 010002 ***/ 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0088rp1 MIM}
&ENDIF

{include/i_fnctrad.i}
/******************************************************************************
**
**       PROGRAMA:  IM0088RP1.P
**
**       DATA....:  JANEIRO DE 2016
**
**       OBJETIVO:  Material em Transito de Importa‡Æo - RELATàRIO EXCEL
**
**
******************************************************************************/
{imp/im0088.i}       /* Defini‡Æo de Temp-tables */
{imp/im0088.i1}       /* Labels */
{utp/ut-glob.i}    
{office/office-defs.i}

DEFINE INPUT PARAMETER TABLE FOR tt-param.
DEFINE INPUT PARAMETER TABLE FOR tt-embarque-contab.

FIND FIRST tt-param NO-ERROR.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.

/* Local Variables */
DEFINE VARIABLE iLineCount AS INTEGER     NO-UNDO.
DEFINE VARIABLE iColCount  AS INTEGER     NO-UNDO.

RUN piProcessaRelat IN THIS-PROCEDURE.
    
PROCEDURE piProcessaRelat:
    ASSIGN tt-param.arquivo = REPLACE(tt-param.arquivo,".tmp",".xml").
    OUTPUT TO VALUE(tt-param.arquivo) APPEND CONVERT TARGET "utf-8":U.
    RUN OpenWorkBook.
    RUN OpenExcelWorkBook.
    RUN CloseExcelWorkBook .
    RUN OpenStyles.
    RUN CloseStyles.

    /* Embarques contabilizados */
    IF CAN-FIND(FIRST tt-embarque-contab 
                WHERE tt-embarque-contab.contabilizado 
                  AND tt-embarque-contab.parcela <> "") THEN
        RUN piImprimeEmbContabilizado IN THIS-PROCEDURE.

    IF CAN-FIND(FIRST tt-embarque-contab 
                WHERE tt-embarque-contab.contabilizado 
                  AND tt-embarque-contab.parcela = "") THEN
        RUN piImprimeEmbContabilizadoSemTit IN THIS-PROCEDURE.

    IF CAN-FIND(FIRST tt-embarque-contab 
                WHERE NOT tt-embarque-contab.contabilizado) THEN
        RUN piImprimeEmbContabilizadoNaoCont IN THIS-PROCEDURE.

    RUN CloseWorkBook.
    OUTPUT CLOSE.

    RUN piConvertXMLToExcel IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/*====
== Embarques contabilizados 
============================*/
PROCEDURE piImprimeEmbContabilizado:

    RUN piOpenCloseWorkSheet (INPUT YES, INPUT c-titulo-contab, INPUT 50).
    RUN piImprimeCabecalhoEmb IN THIS-PROCEDURE (INPUT YES).

    IF tt-param.classifica = 1 THEN DO: /* Estab/Embarq/Fornec */
        FOR EACH tt-embarque-contab
           WHERE tt-embarque-contab.contabilizado 
             AND tt-embarque-contab.parcela <> ""
        BREAK BY tt-embarque-contab.cod-estabel
              BY tt-embarque-contab.embarque
              BY tt-embarque-contab.cod-fornec:
            RUN piImprimeCamposEmb IN THIS-PROCEDURE (INPUT YES).
        END.
    END.
    ELSE DO: /* Fornec/Estab/Embarq */
        FOR EACH tt-embarque-contab
           WHERE tt-embarque-contab.contabilizado 
             AND tt-embarque-contab.parcela <> ""
        BREAK BY tt-embarque-contab.cod-fornec
              BY tt-embarque-contab.cod-estabel
              BY tt-embarque-contab.embarque:
            IF FIRST-OF(tt-embarque-contab.embarque) THEN DO:
                RUN piImprimeCamposEmb IN THIS-PROCEDURE (INPUT YES).
            END.
            ELSE DO:
                RUN piImprimeCamposEmb IN THIS-PROCEDURE (INPUT YES).
            END.
        END.
    END.
    RUN piOpenCloseWorkSheet (INPUT NO, INPUT ?, INPUT ?).

    RETURN "OK":U.
END PROCEDURE.

/*====
== Embarques contabilizados sem t¡tulos no AP
============================*/
PROCEDURE piImprimeEmbContabilizadoSemTit:

    RUN piOpenCloseWorkSheet (INPUT YES, INPUT c-titulo-erro, INPUT 50).
    RUN piImprimeCabecalhoEmb IN THIS-PROCEDURE (INPUT NO).

    IF tt-param.classifica = 1 THEN DO: /* Estab/Embarq/Fornec */
        FOR EACH tt-embarque-contab
           WHERE tt-embarque-contab.contabilizado 
             AND tt-embarque-contab.parcela = ""
        BREAK BY tt-embarque-contab.cod-estabel
              BY tt-embarque-contab.embarque
              BY tt-embarque-contab.cod-fornec:
            RUN piImprimeCamposEmb IN THIS-PROCEDURE (INPUT NO).
        END.
    END.
    ELSE DO: /* Fornec/Estab/Embarq */
        FOR EACH tt-embarque-contab
           WHERE tt-embarque-contab.contabilizado 
             AND tt-embarque-contab.parcela = ""
        BREAK BY tt-embarque-contab.cod-fornec
              BY tt-embarque-contab.cod-estabel
              BY tt-embarque-contab.embarque:
            RUN piImprimeCamposEmb IN THIS-PROCEDURE (INPUT NO).
        END.
    END.
    RUN piOpenCloseWorkSheet (INPUT NO, INPUT ?, INPUT ?).

    RETURN "OK":U.
END PROCEDURE.

/*====
== Embarques nÆo contabilizados 
============================*/
PROCEDURE piImprimeEmbContabilizadoNaoCont:

    RUN piOpenCloseWorkSheet (INPUT YES, INPUT c-titulo-n-contab, INPUT 50).
    RUN piImprimeCabecalhoEmb IN THIS-PROCEDURE (INPUT NO).

    IF tt-param.classifica = 1 THEN DO: /* Estab/Embarq/Fornec */
        FOR EACH tt-embarque-contab
           WHERE NOT tt-embarque-contab.contabilizado 
        BREAK BY tt-embarque-contab.cod-estabel
              BY tt-embarque-contab.embarque
              BY tt-embarque-contab.cod-fornec:
            RUN piImprimeCamposEmb IN THIS-PROCEDURE (INPUT NO).
        END.
    END.
    ELSE DO: /* Fornec/Estab/Embarq */
        FOR EACH tt-embarque-contab
           WHERE NOT tt-embarque-contab.contabilizado 
        BREAK BY tt-embarque-contab.cod-fornec
              BY tt-embarque-contab.cod-estabel
              BY tt-embarque-contab.embarque:
            RUN piImprimeCamposEmb IN THIS-PROCEDURE (INPUT NO).
        END.
    END.
    RUN piOpenCloseWorkSheet (INPUT NO, INPUT ?, INPUT ?).

    RETURN "OK":U.
END PROCEDURE.

/***********
***  IMPRESSÇO DO CABE€ALHO E CAMPOS
*********************************************/
PROCEDURE piImprimeCabecalhoEmb:
    DEFINE INPUT PARAMETER  l-imprime-detalhe AS LOGICAL     NO-UNDO.

    run setColumnWidth(input "24.00":U).
    run setColumnWidth(input "64.00":U).
    run setColumnWidth(input "124.00":U).
    run setColumnWidth(input "64.00":U).
    run setColumnWidth(input "150.00":U).
    run setColumnWidth(input "54.00":U).
    run setColumnWidth(input "64.00":U).
    run setColumnWidth(input "64.00":U).
    run setColumnWidth(input "84.00":U).
    run setColumnWidth(input "64.00":U).

    IF l-imprime-detalhe THEN DO:
        run setColumnWidth(input "64.00":U).
        run setColumnWidth(input "64.00":U).
        run setColumnWidth(input "64.00":U).
        run setColumnWidth(input "84.00":U).
        run setColumnWidth(input "64.00":U).
        run setColumnWidth(input "64.00":U).
        run setColumnWidth(input "64.00":U).
        run setColumnWidth(input "124.00":U).
        run setColumnWidth(input "150.00":U).
        run setColumnWidth(input "150.00":U).
    END.

    ASSIGN iColCount = 1 iLineCount = 1.
    
    RUN OpenLine.
    RUN PrintDataString(INPUT TRIM(c-lb-estab), "subtitulo":U).
    RUN PrintDataString(INPUT TRIM(c-lb-emb), "subtitulo":U).
    RUN PrintDataString(INPUT TRIM(c-lb-fornec), "subtitulo":U).
    RUN PrintDataString(INPUT TRIM(c-lb-nome), "subtitulo":U).
    RUN PrintDataString(INPUT TRIM(c-lb-contab), "subtitulo":U).
    RUN PrintDataString(INPUT TRIM(c-lb-pto-inc), "subtitulo":U).
    RUN PrintDataString(INPUT TRIM(c-lb-dt-inc), "subtitulo":U).
    RUN PrintDataString(INPUT TRIM(c-lb-pto-emb), "subtitulo":U).
    RUN PrintDataString(INPUT TRIM(c-lb-dt-emb), "subtitulo":U).

    IF l-imprime-detalhe THEN DO:
        RUN PrintDataString(INPUT TRIM(c-lb-emp), "subtitulo":U).
        RUN PrintDataString(INPUT TRIM(c-lb-esp), "subtitulo":U).
        RUN PrintDataString(INPUT TRIM(c-lb-ser), "subtitulo":U).
        RUN PrintDataString(INPUT TRIM(c-lb-tit), "subtitulo":U).
        RUN PrintDataString(INPUT TRIM(c-lb-par), "subtitulo":U).
        RUN PrintDataString(INPUT TRIM(c-lb-dt-emis), "subtitulo":U).
        RUN PrintDataString(INPUT TRIM(c-lb-dt-prev), "subtitulo":U).
        RUN PrintDataString(INPUT TRIM(c-lb-moeda), "subtitulo":U).
        RUN PrintDataString(INPUT TRIM(c-lb-vl-ori), "subtitulo":U).
        RUN PrintDataString(INPUT TRIM(c-lb-vl-sal), "subtitulo":U).
    END.

    RUN CloseLine.
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piImprimeCamposEmb:
    DEFINE INPUT PARAMETER  l-imprime-detalhe   AS LOGICAL     NO-UNDO.

    ASSIGN iColCount = 1.
    RUN OpenLine.

    RUN PrintDataString(INPUT TRIM(tt-embarque-contab.cod-estabel), "padrao":U).  
    RUN PrintDataString(INPUT TRIM(tt-embarque-contab.embarque), "padrao":U).     
    RUN PrintDataString(INPUT tt-embarque-contab.cod-fornec, "padrao":U).   
    RUN PrintDataString(INPUT TRIM(tt-embarque-contab.desc-emit), "padrao":U).  
    RUN PrintDataLog(INPUT tt-embarque-contab.contabilizado, "padrao":U).
    RUN PrintDataString(INPUT tt-embarque-contab.pto-incoterm, "padrao":U). 
    RUN PrintDataString(INPUT IF tt-embarque-contab.data-incoterm <> ? THEN STRING(tt-embarque-contab.data-incoterm, "99/99/9999") ELSE "":U, "padrao":U).
    RUN PrintDataString(INPUT tt-embarque-contab.pto-embarque, "padrao":U).
    RUN PrintDataString(INPUT IF tt-embarque-contab.data-embarque <> ? THEN STRING(tt-embarque-contab.data-embarque, "99/99/9999") ELSE "":U, "padrao":U).
   
    IF l-imprime-detalhe THEN DO:
        RUN PrintDataString(INPUT TRIM(tt-embarque-contab.ep-codigo), "padrao":U).    
        RUN PrintDataString(INPUT TRIM(tt-embarque-contab.cod-esp), "padrao":U).      
        RUN PrintDataString(INPUT TRIM(tt-embarque-contab.serie), "padrao":U).        
        RUN PrintDataString(INPUT TRIM(tt-embarque-contab.nr-docto), "padrao":U).     
        RUN PrintDataString(INPUT TRIM(tt-embarque-contab.parcela), "padrao":U).      
        RUN PrintDataString(INPUT IF tt-embarque-contab.data-emissao <> ? THEN STRING(tt-embarque-contab.data-emissao, "99/99/9999") ELSE "":U, "padrao":U). 
        RUN PrintDataString(INPUT IF tt-embarque-contab.data-prev-pag <> ? THEN STRING(tt-embarque-contab.data-prev-pag, "99/99/9999") ELSE "":U, "padrao":U).
        RUN PrintDataString(INPUT TRIM(tt-embarque-contab.desc-moeda), "padrao":U).   
        RUN PrintDataString(INPUT STRING(tt-embarque-contab.de-vl-orig, "->>>,>>>,>>9.99":U), "padrao":U).   
        RUN PrintDataString(INPUT STRING(tt-embarque-contab.de-vl-saldo, "->>>,>>>,>>9.99":U), "padrao":U).  
    END.

    RUN CloseLine.
    RETURN "OK":U.
END PROCEDURE.


/*==============
  XML Procedures
  ==============*/
/*---------------------------------------------------------------------------------
Purpose:    Abre um workbook para que seja poss¡vel adicionar as planilhas e imprimir os resultados.
Parameters: 
Notes:      Procedure executada no in¡cio da gera‡Æo do arquivo XML.
---------------------------------------------------------------------------------*/
procedure OpenWorkBook:

    put unformatted
        '<?xml version="1.0"?>'                                                       skip
        '<?mso-application progid="Excel.Sheet"?>'                                    skip
        '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'              skip
        '          xmlns:o="urn:schemas-microsoft-com:office:office"'                 skip
        '          xmlns:x="urn:schemas-microsoft-com:office:excel"'                  skip
        '          xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'           skip
        '          xmlns:html="http://www.w3.org/TR/REC-html40">'                     skip
        '   <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'     skip
        '       <Author>' c-seg-usuario '</Author>'                                   skip
            '       <LastAuthor>' c-seg-usuario '</LastAuthor>'                           skip
        '       <LastPrinted>' '2005-10-18T09:43:42Z' '</LastPrinted>'                skip
        '       <Created>' '2005-10-18T09:41:43Z' '</Created>'                        skip
        '       <Company>' 'TOTVS' '</Company>'                                       skip
        '       <Version>12.1.10</Version>'                                           skip
        '   </DocumentProperties>'                                                    skip
        '   <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">' skip
        '      <DownloadComponents/>'                                                 skip
        '      <LocationOfComponents HRef="file:///~\~\"/>'                           skip
        '   </OfficeDocumentSettings>'                                                skip.

end procedure. /* procedure OpenWorkBook: */

/*---------------------------------------------------------------------------------
Purpose:    Fecha um workbook.
Parameters: 
Notes:      Procedure executada para finalizar o arquivo XML gerado.
---------------------------------------------------------------------------------*/
procedure CloseWorkBook:

    put unformatted
        '</Workbook>'.

end procedure. /* procedure CloseWorkBook: */

/*---------------------------------------------------------------------------------
Purpose:    Imprimir as configura‡äes do arquivo XML.
Parameters: 
Notes:      
---------------------------------------------------------------------------------*/
procedure OpenExcelWorkBook:

    put unformatted
        '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' skip
        '   <WindowHeight>2970</WindowHeight>'                           skip
        '   <WindowWidth>11340</WindowWidth>'                            skip
        '   <WindowTopX>360</WindowTopX>'                                skip
        '   <WindowTopY>105</WindowTopY>'                                skip
        '   <ProtectStructure>False</ProtectStructure>'                  skip
        '   <ProtectWindows>False</ProtectWindows>'                      skip.

end procedure. /* procedure OpenExcelWorkBook: */

/*---------------------------------------------------------------------------------
Purpose:    Fecha o OpenExcelWorkBook.
Parameters: 
Notes:      
---------------------------------------------------------------------------------*/
procedure CloseExcelWorkBook:

    put unformatted
        '</ExcelWorkbook>' skip.
end procedure. /* procedure CloseExcelWorkBook: */

/*---------------------------------------------------------------------------------
Purpose:    Imprimir os estilos customizados de palavras/c‚lulas do arquivo XML.
Parameters: 
Notes:      
---------------------------------------------------------------------------------*/
procedure OpenStyles:

    put unformatted
        '<Styles>'                                    skip
        '   <Style ss:ID="Default" ss:Name="Normal">' skip
        '      <Alignment ss:Vertical="Bottom"/>'     skip
        '      <Borders/>'                            skip
        '      <Font/>'                               skip
        '      <Interior/>'                           skip
        '      <NumberFormat/>'                       skip
        '      <Protection/>'                         SKIP
        '   </Style>'                                 skip.

    put unformatted
        '   <Style ss:ID="padrao">'                                                       skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss"/>'                                                  SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="filho">'                                                        skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" ss:Bold="1" />'                                     SKIP
        '      <Interior ss:Color="#CCCCCC" ss:Pattern="Solid"/>'                         SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="titulo">'                                                       skip
        '      <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'                  SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" ss:Bold="1" ss:Italic="1"/>'                        SKIP
        '      <Interior ss:Color="#CCCCCC" ss:Pattern="Solid"/>'                         SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="subtitulo">'                                                    skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" ss:Bold="1" />'                                     SKIP
        '      <Interior ss:Color="#CCCCCC" ss:Pattern="Solid"/>'                         SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="tituloSemFundo">'                                               skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" ss:Bold="1" />'                                     SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="DefaultComErro">'                                               skip
        '      <Alignment ss:Vertical="Bottom"/>'                                         skip
        '      <Borders/>'                                                                skip
        '      <Font ss:Color="#ff0000" />'                                               skip
        '      <Interior/>'                                                               skip
        '      <NumberFormat/>'                                                           skip
        '      <Protection/>'                                                             SKIP
        '   </Style>'                                                                     skip.

    put unformatted
        '   <Style ss:ID="padraoComErro">'                                                skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left"   ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Top"    ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '      </Borders>'                                                                SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" ss:Color="#ff0000" />'                              SKIP
        '   </Style>'                                                                     SKIP.

    put unformatted
        '   <Style ss:ID="tituloSemFundoComErro">'                                        skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Protection/>'                                                             SKIP
        '      <Font x:Family="Swiss" ss:Color="#ff0000" ss:Bold="1" />'                  SKIP
        '   </Style>'                                                                     SKIP.


end procedure. /* procedure OpenStyles: */

/*---------------------------------------------------------------------------------
Purpose:    Fechar a impressÆo dos estilos customizados do arquivo XML.
Parameters: 
Notes:      
---------------------------------------------------------------------------------*/
procedure CloseStyles:

    put unformatted
        '</Styles>' skip.
end procedure. /* procedure CloseStyles: */

/*---------------------------------------------------------------------------------
Purpose:    Cria uma nova planilha para que possam ser impressos os resultados.
Parameters: c-program-name: Nome da nova planilha.
Notes:      
---------------------------------------------------------------------------------*/
procedure OpenWorkSheet:
    
    def input param c-program-name as char no-undo.

    put unformatted /*readonly*/
        '<Worksheet ss:Name="' c-program-name '" ss:Protected="0">' skip. 

end procedure. /* procedure OpenWorkSheet: */

/*---------------------------------------------------------------------------------
Purpose:    Fecha uma planilha.
Parameters: 
Notes:      
---------------------------------------------------------------------------------*/
procedure CloseWorkSheet:

    put unformatted
        '</Worksheet>' skip.

end procedure. /* procedure CloseWorkSheet: */

/*---------------------------------------------------------------------------------
Purpose:    Cont‚m as configura‡äes da planilha criada.
Parameters: 
Notes:      
---------------------------------------------------------------------------------*/
procedure OpenWorksheetOptions:
    put unformatted
        '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel" ss:Protected="0">'   SKIP  
        '   <PageSetup>'                                                                       SKIP  
        '      <Header x:Margin="0.4" x:Data="&amp;LCabecalho"/>'                              SKIP  
        '      <Footer x:Margin="0.4"/>'                                                       SKIP  
        '      <PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996"'               SKIP  
        '                   x:Right="0.78740157499999996" x:Top="0.984251969"/>'               SKIP   
        '   </PageSetup>'                                                                      SKIP
        '   <Print>     '                                                                      SKIP     
        '      <Scale>75</Scale>'                                                              SKIP
        '   </Print>'                                                                          SKIP
        ' <PageBreakZoom>100</PageBreakZoom>'                                                  SKIP
        ' <ProtectObjects>True</ProtectObjects>'                                               SKIP
        ' <ProtectScenarios>True</ProtectScenarios>'                                           SKIP
        ' <EnableSelection>UnlockedCells</EnableSelection>'                                    SKIP
        ' <Selected/>'                                                                         SKIP
        ' <FreezePanes/>'                                                                      SKIP
        ' <FrozenNoSplit/>'                                                                    SKIP
        ' <ActivePane>2</ActivePane>'                                                          SKIP
        ' <ActivePane>2</ActivePane>'                                                          SKIP
        ' <Panes>'                                                                             SKIP
        '  <Pane>'                                                                             SKIP
        '   <Number>3</Number>'                                                                SKIP
        '  </Pane>'                                                                            SKIP
        '  <Pane>'                                                                             SKIP
        '   <Number>2</Number>'                                                                SKIP
        '  </Pane>'                                                                            SKIP
        ' </Panes>'                                                                            SKIP.

end procedure. /* procedure OpenWorksheetOptions: */

/*---------------------------------------------------------------------------------
Purpose:    Fecha as configura‡äes da planilha.
Parameters:
Notes:      
---------------------------------------------------------------------------------*/
procedure CloseWorksheetOptions:

    put unformatted
        '</WorksheetOptions>' skip.

end procedure. /* procedure CloseWorksheetOptions: */

/*---------------------------------------------------------------------------------
Purpose:    Abre uma nova tabela, para serem impressos os resultados.
Parameters: pColumns: N£mero de colunas que a nova planilha ir  ter.
Notes:      
---------------------------------------------------------------------------------*/
procedure OpenTable:

    def input param pColumns as int no-undo.

    put unformatted
        '   <Table ss:ExpandedColumnCount="' pColumns '" ss:ExpandedRowCount="65500" x:FullColumns="1" x:FullRows="1" ss:DefaultRowHeight="15">' skip.

end procedure. /* procedure OpenTable: */

/*---------------------------------------------------------------------------------
Purpose:    Fecha uma tabela.
Parameters: 
Notes:      
---------------------------------------------------------------------------------*/
procedure CloseTable:

    put unformatted
        '   </Table>' skip.

end procedure. /* procedure CloseTable: */

/*---------------------------------------------------------------------------------
Purpose:    Setar a largura de uma c‚lula no arquivo gerado.
Parameters: cWidth: Largura em pixels da c‚lula.
Notes:      
---------------------------------------------------------------------------------*/
procedure setColumnWidth:

    def input param cWidth as char no-undo.

    put unformatted
        '       <Column ss:AutoFitWidth="0" ss:Width="' trim(cWidth) '"/>' skip.

end procedure. /* procedure setColumnWidth: */

/*---------------------------------------------------------------------------------
Purpose:    Adicionar uma nova linha no arquivo.
Parameters: 
Notes:      
---------------------------------------------------------------------------------*/
procedure OpenLine:

    assign iLineCount = iLineCount + 1.

    put unformatted
        '      <Row ss:Index="' iLineCount '">' skip.

end procedure. /* procedure OpenLine: */

/*---------------------------------------------------------------------------------
Purpose:    Fechar uma linha.
Parameters: 
Notes:      
---------------------------------------------------------------------------------*/
procedure CloseLine:
    
    put unformatted
        '      </Row>' skip.

end procedure. /* procedure CloseLine: */

/*---------------------------------------------------------------------------------
Purpose:    Imprimir campos do tipo String.
Parameters: pData  = Valor do campo.
            pStyle = Estilo da c‚lula.
Notes:      
---------------------------------------------------------------------------------*/
procedure PrintDataString:

    def input param pData  as char no-undo.
    def input param pStyle as char no-undo.

    assign iColCount = iColCount + 1.

    if pData = ? then
        assign pStyle = pStyle + "ComErro".

    if  pStyle <> "" then
        put unformatted
            '         <Cell ss:Index="' iColCount '" ss:StyleID="' pStyle '"><Data ss:Type="String">' pData '</Data></Cell>' skip.
    else
        put unformatted
            '         <Cell ss:Index="' iColCount '"><Data ss:Type="String">' pData '</Data></Cell>' skip.

end procedure. /* procedure PrintDataString: */

/*---------------------------------------------------------------------------------
Purpose:    Imprimir campos do tipo Log.
Parameters: pData  = Valor do campo.
            pStyle = Estilo da c‚lula.
Notes:      
---------------------------------------------------------------------------------*/
procedure PrintDataLog:

    def input param pData  as log no-undo.
    def input param pStyle as char no-undo.

    assign iColCount = iColCount + 1.

    if pData = ? then
        assign pStyle = pStyle + "ComErro".

    if  pStyle <> "" then
        put unformatted
            '         <Cell ss:Index="' iColCount '" ss:StyleID="' pStyle '"><Data ss:Type="String">'IF pData = ? THEN ? ELSE IF pData THEN c-lbl-sim ELSE c-lbl-nao '</Data></Cell>' skip.
    else
        put unformatted
            '         <Cell ss:Index="' iColCount '"><Data ss:Type="String">' IF pData = ? THEN ? ELSE IF pData THEN c-lbl-sim ELSE c-lbl-nao '</Data></Cell>' skip.

    return "ok":U.
end procedure. /* procedure PrintDataLog: */

/*---------------------------------------------------------------------------------
Purpose:    Imprimir campos do tipo Int.
Parameters: pData  = Valor do campo.
            pStyle = Estilo da c‚lula.
Notes:      
---------------------------------------------------------------------------------*/
procedure PrintDataNumber:

    def input param pData  as char no-undo.
    def input param pStyle as char no-undo.

    assign iColCount = iColCount + 1.

    if pData = ? then
        assign pStyle = pStyle + "ComErro".

    if  pStyle <> "" then
        put unformatted
            '         <Cell ss:Index="' iColCount '" ss:StyleID="' pStyle '"><Data ss:Type="Number">' pData '</Data></Cell>' skip.
    else
        put unformatted
            '         <Cell ss:Index="' iColCount '"><Data ss:Type="Number">' pData '</Data></Cell>' skip.

end procedure. /* procedure PrintDataNumber: */

/*---------------------------------------------------------------------------------
Purpose:    Imprimir campos do tipo Dec.
Parameters: pData  = Valor do campo.
            pStyle = Estilo da c‚lula.
Notes:      
---------------------------------------------------------------------------------*/
procedure PrintDataDecValue: /* ->>,>>>,>>9.99 */

    def input param pData  as char no-undo.
    def input param pStyle as char no-undo.

    assign iColCount = iColCount + 1.

    if pData = ? then
        assign pStyle = pStyle + "ComErro".

    if  pStyle <> "" then
        put unformatted
            '         <Cell ss:Index="' iColCount '" ss:StyleID="' pStyle '"><Data ss:Type="Number">' pData '</Data></Cell>' skip.
    else
        put unformatted
            '         <Cell ss:Index="' iColCount '"><Data ss:Type="Number">' pData '</Data></Cell>' skip.

end procedure. /* procedure PrintDataNumber: */

/*---------------------------------------------------------------------------------
Purpose:    Imprimir campos do tipo Date.
Parameters: pData  = Valor do campo.
            pStyle = Estilo da c‚lula.
Notes:      
---------------------------------------------------------------------------------*/
procedure PrintDataDate:

    def input param pData  as date no-undo.
    def input param pStyle as char no-undo.


    def var cYear          as char no-undo.
    def var cMonth         as char no-undo.
    def var cDay           as char no-undo.

    /* conversÆo das datas para padrÆo XML */
    assign cYear  = string(year(pData))
           cMonth = string(month(pData),"99")
           cDay   = string(day(pData),"99").

    assign iColCount = iColCount + 1.

    if pData = ? then
        assign pStyle = pStyle + "ComErro".

    if  pStyle <> "" then
        put unformatted
            '         <Cell ss:Index="' iColCount '" ss:StyleID="' pStyle '"><Data ss:Type="DateTime">' cYear '-' cMonth '-' cDay 'T00:00:00.000</Data></Cell>' skip.
    else
        put unformatted
            '         <Cell ss:Index="' iColCount '"><Data ss:Type="DateTime">' cYear '-' cMonth '-' cDay 'T00:00:00.000</Data></Cell>' skip.

end procedure. /* procedure PrintDataDate: */

/*---------------------------------------------------------------------------------
Purpose:    Mesclar c‚lulas
Parameters: iNumberCols = N£mero de c‚lulas da coluna a serem mescladas a partir da c‚lula corrente.
            cData       = Valor a ser impresso nas c‚lulas mescladas.
            cStyle      = Estilo da c‚lula.

Notes:      
---------------------------------------------------------------------------------*/
procedure MergeColumns:

    def input param iNumberCols as int  no-undo. 
    def input param cData       as char no-undo.
    def input param cStyle      as char no-undo.

    assign iColCount = iColCount + 1. /* pr¢xima c‚lula da coluna */

    put unformatted
        '         <Cell ss:Index="' iColCount '" ss:MergeAcross="' iNumberCols '" ss:StyleID="' cStyle '"><Data ss:Type="String">' cData '</Data></Cell>' skip.

    /* ap¢s mesclar as c‚lulas atualiza a coluna corrente, retirando a c‚lula (coluna) acrescenta acima */
    assign iColCount = iColCount + iNumberCols - 1.

end procedure. /* procedure MergeColumns: */

/*---------------------------------------------------------------------------------
Purpose:    Abrir ou fechar uma worksheet
Parameters: l-open    = Se ‚ abertura de uma worksheet
            c-title   = T¡tulo da worksheet
            i-columns = N£mero de colunas da worksheet.
Notes:      
---------------------------------------------------------------------------------*/
PROCEDURE piOpenCloseWorkSheet:
    DEFINE INPUT PARAMETER l-open    AS LOGICAL     NO-UNDO.
    DEFINE INPUT PARAMETER c-title   AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER i-columns AS INTEGER     NO-UNDO.

    IF l-open THEN DO:
        RUN OpenWorkSheet(INPUT c-title).
        RUN OpenTable(INPUT i-columns).
    END.
    ELSE DO:
        RUN CloseTable.
        RUN OpenWorksheetOptions.
        RUN CloseWorksheetOptions.
        RUN CloseWorkSheet.
    END.

    RETURN "OK":U.
END PROCEDURE. /* procedure piOpenCloseWorkSheet: */

PROCEDURE piConvertXMLToExcel:
/*----------------------------------------------------------------------------------
Purpose:    Verifica se o usu rio possui Excel instalado, se sim, converte o arquivo
            XML gerado para xls.
Parameters: 
Notes:      
----------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-path-excel    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE ch-Excel        AS office.iface.excel.ExcelWrapper  NO-UNDO.
    DEFINE VARIABLE chWSheet        AS office.iface.excel.WorkSheet     NO-UNDO.
    DEFINE VARIABLE chWorkbook      AS office.iface.excel.Workbook      NO-UNDO.
    DEFINE VARIABLE v-arquivo       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-arquivo-excel AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE h-utapi013      AS HANDLE      NO-UNDO.

    IF NOT VALID-HANDLE(h-utapi013) THEN
        RUN utp/utapi013.p PERSISTENT SET h-utapi013.

    /* LIBRE OFFICE  */
    {office/office.i Excel ch-Excel}.
    ASSIGN c-path-excel = ch-Excel:Path NO-ERROR.
    
    /* Elimina arquivo XLS se j  existir*/
    ASSIGN v-arquivo = REPLACE(tt-param.arquivo, ".xml", ".xls").
    OS-DELETE VALUE(v-arquivo) NO-ERROR.

    ASSIGN FILE-INFO:FILE-NAME = tt-param.arquivo.
    ch-Excel:WorkBooks:OPEN(FILE-INFO:FILE-NAME,TRUE) NO-ERROR. 
    ch-Excel:Sheets:ITEM(1) NO-ERROR.

    chWSheet = ch-Excel:Sheets:ITEM(1) NO-ERROR.
    chWSheet:PageSetup:ORIENTATION = 2 NO-ERROR.
    ch-Excel:ActiveWindow:DisplayGridlines = FALSE NO-ERROR.
    ch-Excel:APPLICATION:DisplayAlerts = FALSE NO-ERROR.
    ch-Excel:VISIBLE = NO NO-ERROR. 
    ch-Excel:ScreenUpdating = FALSE NO-ERROR.

    ASSIGN FILE-INFO:FILE-NAME = v-arquivo
           c-arquivo-excel     = v-arquivo NO-ERROR.

    /* ConversÆo do arquivo .XML para .XLS */
    /* -4143: constante de conversÆo de arquivo .XML para .XLS */
    IF FILE-INFO:FILE-TYPE = ? THEN
        ch-Excel:ActiveWorkbook:SaveAs(FILE-INFO:FILE-NAME,-4143,"","",NO,NO,NO) NO-ERROR.
    ch-Excel:ActiveWorkbook:CLOSE() NO-ERROR.
    ch-Excel:QUIT() NO-ERROR.

    IF SEARCH(v-arquivo) <> ? THEN DO:
        OS-DELETE VALUE(tt-param.arquivo). /* Elimina arquivo XML */
        RUN openExcelCalc IN h-utapi013 (INPUT c-arquivo-excel).
    END.
    ELSE DO:
        RUN utp/ut-msgs.p (INPUT "show":U, 54548, tt-param.arquivo).
    END.

    IF ch-Excel <> ? THEN
        DELETE OBJECT ch-Excel NO-ERROR.
    IF chWorkbook <> ? THEN
        DELETE OBJECT chWorkbook NO-ERROR. 
    IF chWSheet <> ? THEN
        DELETE OBJECT chWSheet NO-ERROR.

    IF VALID-HANDLE(h-utapi013) THEN DO:
        DELETE PROCEDURE h-utapi013.
        ASSIGN h-utapi013 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

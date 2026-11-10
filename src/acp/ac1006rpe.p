/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC1006RPE 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ac1006rpe MAC}
&ENDIF



/********************************************************************************
***
*** CE0302A - Gerador de Arquivo Excel
***
********************************************************************************/

{utp/ut-glob.i}

define temp-table tt-param
    field destino          as   integer
    field arquivo          as   character
    field arq-destino      as   character
    field arq-entrada      as   character format "x(40)"
    field exporta          as   integer
    field desc-exporta     as   character format "x(40)"
    field usuario          as   character
    field data-exec        as   date
    field hora-exec        as   integer
    field cod-estab-ini    like cotas.cod-estabel
    field cod-estab-fim    like cotas.cod-estabel
    field produto-ini      like cotas.cd-produto
    field produto-fim      like cotas.cd-produto
    field data-ini         like cotas.dt-inicial
    field data-fim         like cotas.dt-inicial.

DEFINE TEMP-TABLE tt-base-cota NO-UNDO LIKE base-cota 
    FIELD r-Rowid AS ROWID
    FIELD des-produto-coml LIKE produto-coml.des-produto-coml
    FIELD descricao        LIKE produto.descricao
    FIELD desc-item        LIKE ITEM.desc-item
    FIELD cd-produtos      LIKE cotas.cd-produto.

DEFINE INPUT PARAMETER TABLE FOR tt-param.



def var h-acomp                  as handle                  no-undo.
/* XML */                                       
def var iLineCount               as int                     no-undo.
def var iColCount                as int                     no-undo.
def var iColumns                 as int                     no-undo.
                                                            
def var cStyle                   as char                    no-undo.
def var cStyleDtTrans            as char                    no-undo.
def var cStyleQuantidade         as char                    no-undo.
def var cStyleMatMobGgf          as char                    no-undo.
                                                            
def var cNumericFormat           as char                    no-undo.

function fnSkipCol  returns char (input pNumberColsToSkip as int)  forward.
function fnSkipLine returns char (input pNumberLinesToSkip as int) forward.
/* XML */


/* Traduá∆o Labels */
def var c-lbl-estabel        AS CHAR NO-UNDO.
DEF VAR c-lbl-produto        AS CHAR NO-UNDO.
DEF VAR c-lbl-desc           AS CHAR NO-UNDO.
DEF VAR c-lbl-dat-ini        AS CHAR NO-UNDO.
DEF VAR c-lbl-dat-fim        AS CHAR NO-UNDO.
def var c-lbl-prevista       AS CHAR NO-UNDO.
DEF VAR c-lbl-realizada      AS CHAR NO-UNDO.
DEF VAR c-lbl-liberada       AS CHAR NO-UNDO.
DEF VAR c-lbl-dat-liberacao  AS CHAR NO-UNDO.
DEF VAR c-lbl-dat-alteracao  AS CHAR NO-UNDO.
def var c-lbl-nr-ptos-orig   AS CHAR NO-UNDO.
DEF VAR c-lbl-dat-bloq       AS CHAR NO-UNDO.

{utp/ut-liter.i Estabelecimento *}
assign c-lbl-estabel = return-value.
{utp/ut-liter.i Produto/ITEM *}
assign c-lbl-produto = return-value.
{utp/ut-liter.i Descriá∆o *}
assign c-lbl-desc = return-value.
{utp/ut-liter.i Data_Inicial *}
assign c-lbl-dat-ini = return-value.
{utp/ut-liter.i Data_Final *}
assign c-lbl-dat-fim = return-value.
{utp/ut-liter.i Prevista *}
assign c-lbl-prevista = return-value.
{utp/ut-liter.i Realizada_Pedida *}
assign c-lbl-realizada = return-value.
{utp/ut-liter.i Liberada *}
assign c-lbl-liberada = return-value.
{utp/ut-liter.i Data_Liberaá∆o *}
assign c-lbl-dat-liberacao = return-value.
{utp/ut-liter.i Data_Alteraá∆o *}
assign c-lbl-dat-alteracao = return-value.
{utp/ut-liter.i N£mero_Pontos_Original *}
assign c-lbl-nr-ptos-orig = return-value.
{utp/ut-liter.i Data_Bloqueio *}
assign c-lbl-dat-bloq = return-value.


/* Fim Traduá∆o Labels */

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
{utp/ut-liter.i Exportando... *}       
RUN pi-inicializar IN h-acomp (INPUT return-value).

FIND FIRST tt-param NO-LOCK NO-ERROR.
IF  NOT AVAIL tt-param THEN DO:
    
    RETURN "NOK":U.
END.

/* alteraá∆o da extens∆o do arquivo */
assign tt-param.arquivo = replace(tt-param.arquivo, ".tmp", ".xml").

/* altera parÉmetro da sess∆o para impress∆o de dados decimais */
assign cNumericFormat = session:numeric-format
       session:numeric-format = "AMERICAN".

/* abertura do arquivo para impress∆o do XML */
output to value(tt-param.arquivo) convert target "utf-8":U.

RUN pi-exporta-excel.

RUN pi-geraRelat. 

output close. 

/*=================================
  Convers∆o do arquivo XML para XLS
  =================================*/

run piConvertXMLToXLS.

/* retorna os parÉmetros da sess∆o */
assign session:numeric-format = cNumericFormat.

RUN pi-finalizar IN h-acomp.

RETURN "OK":U.

procedure pi-exporta-excel:

   /*Dados de Cotas*/
   for each base-cota no-lock
       where base-cota.cod-estabel  >= tt-param.cod-estab-ini
       and   base-cota.cod-estabel  <= tt-param.cod-estab-fim
       and   base-cota.cd-produto   >= tt-param.produto-ini
       and   base-cota.cd-produto   <= tt-param.produto-fim
       and   base-cota.dt-inicial   >= tt-param.data-ini
       and   base-cota.dt-inicial   <= tt-param.data-fim:
       
       create tt-base-cota.


       find par-cota no-lock
            where par-cota.cod-estabel = base-cota.cod-estabel no-error.
         
         &if defined (bf_dis_adm_cotas) &then   /* INICIO PREPROCESSADOR */
           find first produto-coml no-lock where
                      produto-coml.cod-produto-coml = base-cota.cd-produto no-error.
           if avail produto-coml then 
                  assign tt-base-cota.desc-item = produto-coml.des-produto-coml.
           if not avail produto-coml then do:
         &else
           find first produto no-lock where
                      produto.cd-produto = base-cota.cd-produto no-error.
           if avail produto then 
              assign tt-base-cota.desc-item = produto.descricao.
              
           if not avail produto then do:
         &endif
                for first item fields(desc-item) no-lock where
                    item.it-codigo = base-cota.cd-produto :
                    assign tt-base-cota.desc-item = item.desc-item.
                end. 
           END.


                    assign  tt-base-cota.cod-estabel  = base-cota.cod-estabel
                            tt-base-cota.cd-produto   = base-cota.cd-produto                  
                            tt-base-cota.dt-inicial   = base-cota.dt-inicial
                            tt-base-cota.dt-final     = base-cota.dt-final
                            tt-base-cota.qt-prevista  = base-cota.qt-prevista
                            tt-base-cota.qt-pedida    = base-cota.qt-pedida
                            tt-base-cota.qt-liberada  = base-cota.qt-liberada
                            tt-base-cota.data-liber   = base-cota.data-liber
                            tt-base-cota.data-alter   = base-cota.data-alter
                            tt-base-cota.nr-pontos    = base-cota.nr-pontos
                            tt-base-cota.dt-bloqueio  = base-cota.dt-bloqueio.  
                            


END.

end procedure.

PROCEDURE pi-geraRelat:
    /* definiá∆o da largura das colunas */
    DEF VAR ColumnWidth AS CHAR NO-UNDO.

    assign iColumns = 12.
    run OpenWorkBook.
    run OpenExcelWorkBook.
    run CloseExcelWorkBook .
	run OpenStyles.
	run CloseStyles.
	run OpenWorkSheet(input "AC1006").
    run OpenTable(input iColumns).

    /* definiá∆o da largura das colunas */

    ASSIGN ColumnWidth = "70.00". /*largura padr∆o das colunas */

    run setColumnWidth(ColumnWidth).
    run setColumnWidth(ColumnWidth). 
    run setColumnWidth(ColumnWidth).
    run setColumnWidth(ColumnWidth).
    run setColumnWidth(ColumnWidth).
    run setColumnWidth(ColumnWidth).
    run setColumnWidth(ColumnWidth). 
    run setColumnWidth(ColumnWidth).
    run setColumnWidth(ColumnWidth).
    run setColumnWidth(ColumnWidth).
    run setColumnWidth(ColumnWidth).
    run setColumnWidth(ColumnWidth).

    run OpenLine.
        run MergeColumns (input 10, "CURSO 1", "Default").
        assign iColCount = iColCount + 1. /* pr¢xima cÇlula da coluna */
        run MergeColumns (input 0, TODAY, "Default").
    run CloseLine.

    run OpenLine.
        run PrintDataString(input ""                , "Default").
    run CloseLine.

    run OpenLine.
        run MergeColumns   (input 5, " ", "Default").
        assign iColCount = iColCount + 1. /* pr¢xima cÇlula da coluna */    
        run MergeColumns   (input 0," Base de Cotas" , "Default").
    run CloseLine.
   
    run OpenLine.
        run PrintDataString(input c-lbl-estabel          , "s32"). /*s32 estilo do cabeáalho com os campos ta tabela base-cota*/
        run PrintDataString(input c-lbl-produto          , "s32").
        run PrintDataString(input c-lbl-desc             , "s32").
        run PrintDataString(input c-lbl-dat-ini          , "s32").
        run PrintDataString(input c-lbl-dat-fim          , "s32").
        run PrintDataString(input c-lbl-prevista         , "s32").
        run PrintDataString(input c-lbl-realizada        , "s32").
        run PrintDataString(input c-lbl-liberada         , "s32").
        run PrintDataString(input c-lbl-dat-liberacao    , "s32").
        run PrintDataString(input c-lbl-dat-alteracao    , "s32").
        run PrintDataString(input c-lbl-nr-ptos-orig     , "s32").
        run PrintDataString(input c-lbl-dat-bloq         , "s32").        
    run CloseLine.
    

    assign cStyle           = "s50".
           
    
    FOR EACH tt-base-cota NO-LOCK
       BREAK BY tt-base-cota.cod-estabel:
        
      IF NOT FIRST(tt-base-cota.cod-estabel) THEN 
        ASSIGN cStyle = "s23". /*n∆o mudar estilo da primeira linha com borda preta conforme layout antigo*/

            IF  VALID-HANDLE(h-acomp) THEN  
             /* Inicio -- Projeto Internacional */
             DO:
             {utp/ut-liter.i "Gerando" *}
             run pi-acompanhar in h-acomp (input RETURN-VALUE + ": " + tt-base-cota.cd-produto).
             END. 
       
        run OpenLine.
            run PrintDataString(input tt-base-cota.cod-estabel        , cStyle).
            run PrintDataString(input tt-base-cota.cd-produto         , cStyle).
            run PrintDataString(input tt-base-cota.desc-item          , cStyle).
            run PrintDataString(input tt-base-cota.dt-inicial         , cStyle).
            run PrintDataString(input tt-base-cota.dt-final           , cStyle).
            run PrintDataString(input tt-base-cota.qt-prevista        , cStyle).
            run PrintDataString(input tt-base-cota.qt-pedida          , cStyle).
            run PrintDataString(input tt-base-cota.qt-liberada        , cStyle).
            run PrintDataString(input tt-base-cota.data-liber         , cStyle).
            run PrintDataString(input tt-base-cota.data-alter         , cStyle).
            run PrintDataString(input tt-base-cota.nr-pontos          , cStyle).
            run PrintDataString(input tt-base-cota.dt-bloqueio        , cStyle).
        run CloseLine.
        
    END.
    
    run OpenLine.
        run MergeColumns   (input 9, " ", "Default").
        assign iColCount = iColCount + 1. /* pr¢xima cÇlula da coluna */    
        run MergeColumns   (input 0," Base Cota - DATASUL S.A." , "Default").
    run CloseLine.

    /*=======================
      Fim Impress∆o dos Dados
      =======================*/

    run CloseTable.
	run OpenWorksheetOptions.
    RUN DoNotDisplayGridlines.
	run CloseWorksheetOptions.
    run CloseWorkSheet.
	run CloseWorkBook.

END PROCEDURE.

/*===================
  Internal Procedures
  ===================*/

/*==============
  XML Procedures
  ==============*/

procedure OpenWorkBook:

    put unformatted
        '<?xml version="1.0"?>'                                                       skip
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
        '       <Company>' 'Datasul' '</Company>'                                     skip
        '       <Version>10.2625</Version>'                                           skip
        '   </DocumentProperties>'                                                    skip
        '   <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">' skip
        '      <DownloadComponents/>'                                                 skip
        '      <LocationOfComponents HRef="file:///~\~\"/>'                           skip
        '   </OfficeDocumentSettings>'                                                skip.

end procedure.

procedure CloseWorkBook:

    put unformatted
        '</Workbook>'.

end procedure.

procedure OpenExcelWorkBook:

    put unformatted
        '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' skip
        '   <WindowHeight>2970</WindowHeight>'                           skip
        '   <WindowWidth>11340</WindowWidth>'                            skip
        '   <WindowTopX>360</WindowTopX>'                                skip
        '   <WindowTopY>105</WindowTopY>'                                skip
        '   <ProtectStructure>False</ProtectStructure>'                  skip
        '   <ProtectWindows>False</ProtectWindows>'                      skip.

end procedure.

procedure CloseExcelWorkBook:

    put unformatted
        '</ExcelWorkbook>' skip.
end procedure.

procedure OpenStyles:

    put unformatted
        '<Styles>'                                    skip
        '   <Style ss:ID="Default" ss:Name="Normal">' skip
        '      <Alignment ss:Vertical="Bottom"/>'     skip
        '      <Borders/>'                            skip
        '      <Font/>'                               skip
        '      <Interior/>'                           skip
        '      <NumberFormat/>'                       skip
        '      <Protection/>'                         skip
        '   </Style>'                                 skip.
     
    put unformatted
        '   <Style ss:ID="s50">'                                                          skip
        '      <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'                    SKIP
        '      <Borders>'                                                                 skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'   skip
        '         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'  skip
        '         <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="3"/>'    skip
        '      </Borders>'                                                                SKIP
        '      <Font ss:FontName="Times New Roman" x:Family="Roman"/>'                    SKIP
        '      <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>'                         SKIP       
        '   </Style>'                                                                     skip.
    
    put unformatted
        '   <Style ss:ID="s23">'                                                         skip
        '      <Borders>'                                                                skip
        '         <Border ss:Position="Left"  ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' skip
        '         <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'skip
        '         <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'   SKIP  
        '      </Borders>'                                                               skip
        '      <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>'                        skip
        '   </Style>'                                                                    skip.
    
    put unformatted
        '   <Style ss:ID="s32">'                                                         skip
        '   <Alignment ss:Horizontal="Justify" ss:Vertical="Bottom"/>'                   skip   
        '      <Borders>'                                                                skip
        '        <Border ss:Position="Left" ss:LineStyle="Double" ss:Weight="3"/>'       SKIP
        '        <Border ss:Position="Right" ss:LineStyle="Double" ss:Weight="3"/>'      SKIP
        '        <Border ss:Position="Top" ss:LineStyle="Double" ss:Weight="3"/>'        SKIP
        '      </Borders>'                                                               skip
        '      <Font ss:FontName="Times New Roman" x:Family="Roman" ss:Color="#FFFFFF" ss:Bold="1"/>'SKIP
        '      <Interior ss:Color="#993366" ss:Pattern="Solid"/>'                        skip
        '   </Style>'                                                                    skip.

end procedure.
            
procedure CloseStyles:

    put unformatted
        '</Styles>' skip.
end procedure.

procedure OpenWorkSheet:

    def input param c-program-name as char no-undo.

    put unformatted
        '<Worksheet ss:Name="' c-program-name '">' skip.

end procedure.

procedure CloseWorkSheet:

    put unformatted
        '</Worksheet>' skip.

end procedure.

procedure OpenWorksheetOptions:
    put unformatted
        '<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'                    skip
        '   <PageSetup>'                                                                       skip
        '      <Header x:Margin="0.4" x:Data="&amp;LCabecalho"/>'                              skip
        '      <Footer x:Margin="0.4"/>'                                                       skip
        '      <PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996"'               skip
        '                   x:Right="0.78740157499999996" x:Top="0.984251969"/>'               skip
        '   </PageSetup>'                                                                      SKIP            
        '   <Print>     '                                                                      SKIP     
        '      <Scale>75</Scale>'                                                              SKIP
        '   </Print>'                                                                          SKIP
        ' <PageBreakZoom>100</PageBreakZoom>'                                                  skip
        ' <Selected/>'                                                                         skip.

end procedure.

procedure DoNotDisplayGridlines:

    put unformatted
        '<DoNotDisplayGridlines/>' skip.

end procedure.

procedure CloseWorksheetOptions:

    put unformatted
        '</WorksheetOptions>' skip.

end procedure.
	
procedure OpenTable:

    def input param pColumns as int no-undo.

    put unformatted
        '   <Table ss:ExpandedColumnCount="' pColumns '" ss:ExpandedRowCount="65500" x:FullColumns="1" x:FullRows="1">' skip.

end procedure.

procedure CloseTable:

    put unformatted
        '   </Table>' skip.

end procedure.

procedure setColumnWidth:

    def input param cWidth as char no-undo.

    put unformatted
        '       <Column ss:AutoFitWidth="0" ss:Width="' trim(cWidth) '"/>' skip.

end procedure.

procedure OpenLine:

    assign iLineCount = iLineCount + 1.

    put unformatted
        '      <Row ss:Index="' iLineCount '">' skip.

end procedure.
	
procedure CloseLine:

    /* reinicia a contagem das colunas sempre que a TAG da linha Ç fechada */
    assign iColCount = 0.

    put unformatted
        '      </Row>' skip.

end procedure.
	
procedure PrintDataString:

    def input param pData  as char no-undo.
    def input param pStyle as char no-undo.

    assign iColCount = iColCount + 1.

    if  pStyle <> "" then
        put unformatted
            '         <Cell ss:Index="' iColCount '" ss:StyleID="' pStyle '"><Data ss:Type="String">' pData '</Data></Cell>' skip.
    else
        put unformatted
            '         <Cell ss:Index="' iColCount '"><Data ss:Type="String">' pData '</Data></Cell>' skip.

end procedure.
	
procedure PrintDataNumber:

    def input param pData  as char no-undo.
    def input param pStyle as char no-undo.

    assign iColCount = iColCount + 1.

    if  pStyle <> "" then
        put unformatted
            '         <Cell ss:Index="' iColCount '" ss:StyleID="' pStyle '"><Data ss:Type="Number">' pData '</Data></Cell>' skip.
    else
        put unformatted
            '         <Cell ss:Index="' iColCount '"><Data ss:Type="Number">' pData '</Data></Cell>' skip.

end procedure.

procedure PrintDataDate:

    def input param pData  as date no-undo.
    def input param pStyle as char no-undo.


    def var cYear          as char no-undo.
    def var cMonth         as char no-undo.
    def var cDay           as char no-undo.

    /* convers∆o das datas para padr∆o XML */
    assign cYear  = string(year(pData))
           cMonth = string(month(pData),"99")
           cDay   = string(day(pData),"99").

    assign iColCount = iColCount + 1.

    if  pStyle <> "" then
        put unformatted
            '         <Cell ss:Index="' iColCount '" ss:StyleID="' pStyle '"><Data ss:Type="DateTime">' cYear '-' cMonth '-' cDay 'T00:00:00.000</Data></Cell>' skip.
    else
        put unformatted
            '         <Cell ss:Index="' iColCount '"><Data ss:Type="DateTime">' cYear '-' cMonth '-' cDay 'T00:00:00.000</Data></Cell>' skip.

end procedure.


procedure MergeColumns:

    def input param iNumberCols as int  no-undo. /* n£mero de cÇlulas da coluna a serem mescladas a partir da cÇlula corrente */
    def input param cData       as char no-undo.
    def input param cStyle      as char no-undo.

    assign iColCount = iColCount + 1. /* pr¢xima cÇlula da coluna */

    put unformatted
        '         <Cell ss:Index="' iColCount '" ss:MergeAcross="' iNumberCols '" ss:StyleID="' cStyle '"><Data ss:Type="String">' cData '</Data></Cell>' skip.

    /* ap¢s mesclar as cÇlulas atualiza a coluna corrente, retirando a cÇlula (coluna) acrescenta acima */
    assign iColCount = iColCount + iNumberCols - 1.

end procedure.
              
function fnSkipCol returns char (input pNumberColsToSkip as int).
    
    def var iCol as int no-undo.

    do iCol = 1 to pNumberColsToSkip:
        assign iColCount = iColCount + 1.
    end.
    
    return "OK".

end function.

function fnSkipLine returns char (input pNumberLinesToSkip as int).
    
    def var iLine as int no-undo.

    do iLine = 1 to pNumberLinesToSkip:
        assign iLineCount = iLineCount + 1.
    end.

    return "OK".

end function.

procedure piConvertXMLToXLS:

    /*=================================
      Convers∆o do arquivo XML para XLS
      =================================*/

    def var v-arquivo as char           no-undo.
    def var ch-excel  as office.iface.excel.ExcelWrapper     no-undo.   

    if  iLineCount > 65500 then do: /* o Excel Ç limitado a 65536 linhas */
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-o-relatorio-excel-atingiu-o-li AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "O_relat¢rio_Excel_atingiu_o_limite_de_65.500_linhas" *}
        ASSIGN c-lbl-liter-o-relatorio-excel-atingiu-o-li = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-por-limitacoes-do-microsoft-ex AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Por_limitaá‰es_do_Microsoft_Excel_o_relat¢rio_Ç_limitado_a" *}
        ASSIGN c-lbl-liter-por-limitacoes-do-microsoft-ex = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-65500-linhas-deste-modo-devera AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "65.500_linhas._Deste_modo,_dever†_ser_informada" *}
        ASSIGN c-lbl-liter-65500-linhas-deste-modo-devera = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-uma-faixa-de-selecao-que-limit AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "uma_faixa_de_seleá∆o_que_limite_a_impress∆o_dos_dados" *}
        ASSIGN c-lbl-liter-uma-faixa-de-selecao-que-limit = TRIM(RETURN-VALUE).
        run utp/ut-msgs.p(input "show",
                          input 17006,
                          input c-lbl-liter-o-relatorio-excel-atingiu-o-li + "~~" +
                                c-lbl-liter-por-limitacoes-do-microsoft-ex + " " +
                                c-lbl-liter-65500-linhas-deste-modo-devera + " " +
                                c-lbl-liter-uma-faixa-de-selecao-que-limit + ".").

        /* elimina arquivo XML */
        os-delete value(tt-param.arquivo).
    end.
    else do:

        /* elimina arquivo XLS */
        assign v-arquivo = replace(tt-param.arquivo, ".xml", ".xls").
        os-delete value(v-arquivo).


        {office/office.i Excel ch-excel}
        assign file-info:file-name = tt-param.arquivo. 

        ch-excel:WorkBooks:open(file-info:file-name,true). 
        ch-excel:sheets:item(1).

        assign file-info:file-name = v-arquivo.

        /* Convers∆o do arquivo .XML para .XLS */
        /* -4143: constante de convers∆o de arquivo .XML para .XLS */
        ch-excel:ActiveWorkbook:SaveAs(file-info:file-name,-4143,"","",no,no,no). 

        ch-excel:ActiveWorkbook:close().

        ch-excel:Workbooks:open(v-arquivo).
        ch-excel:visible = yes.

        DELETE object ch-excel.

        /* elimina arquivo XML */
        os-delete value(tt-param.arquivo).
    end.
   
end procedure.





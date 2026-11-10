/******************************************************************************** 
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0504RP 2.00.00.004 } /*** "010004" 03/03/2025 09:10:32  ***/
/*****************************************************************************
**       PROGRAMA: AF0502
**       DATA....: Mar‡o de 2004    
**       OBJETIVO: Relat¢rio de Notas
**       VERSAO..: 2.00.00.000 - Vinicio Alexandre Silveira
******************************************************************************/
{utp/ut-glob.i}
{utp/utapi019.i}
{afp/af0504.i} 
{afbo/boaf008.i1}


def temp-table tt-raw-digita
    field raw-digita      as raw.

DEF INPUT PARAMETER raw-param AS raw no-undo.
DEF INPUT PARAMETER table FOR tt-raw-digita.

CREATE tt-param.
raw-transfer raw-param TO tt-param.

{include/i-rpvar.i}

FUNCTION fn_retorna_periodo RETURNS CHAR:
   RETURN string(tt-notas.ano-avaliacao) + " - " + tt-notas.des-periodo-aval + " (" + 
          STRING(month(tt-notas.dt-indice-fim),"99") + "/" + string(year(tt-notas.dt-indice-fim),"9999") + ")".
END FUNCTION.
        

FORM SKIP (2)
    "SELE€ÇO"                 AT  3 SKIP(1)
    tt-param.c-est-ini        COLON 24 "|<  >|" AT 53 tt-param.c-est-fim        NO-LABEL SKIP
    tt-param.i-emi-ini        COLON 24 "|<  >|" AT 53 tt-param.i-emi-fim        NO-LABEL SKIP
    tt-param.c-it-ini         COLON 24 "|<  >|" AT 53 tt-param.c-it-fim         NO-LABEL SKIP
    tt-param.i-nr-ini         COLON 24 "|<  >|" AT 53 tt-param.i-nr-fim         NO-LABEL SKIP
    tt-param.i-ano-ini        COLON 24 LABEL "Per¡odo"
    tt-param.c-des-per-ini    NO-LABEL "|<  >|" AT 53 tt-param.i-ano-fim NO-LABEL
    tt-param.c-des-per-fim    NO-LABEL SKIP
    tt-param.i-cod-gr-forn-ini  COLON 24 "|<  >|" AT 53 tt-param.i-cod-gr-forn-fim NO-LABEL SKIP
    tt-param.c-fm-codigo-ini    COLON 24 "|<  >|" AT 53 tt-param.c-fm-codigo-fim NO-LABEL SKIP
    tt-param.i-ge-codigo-ini    COLON 24 "|<  >|" AT 53 tt-param.i-ge-codigo-fim NO-LABEL SKIP
    tt-param.c-cod-grp-aval-ini COLON 24 "|<  >|" AT 53 tt-param.c-cod-grp-aval-fim NO-LABEL SKIP
    tt-param.c-cod-grp-resp-ini COLON 24 "|<  >|" AT 53 tt-param.c-cod-grp-resp-fim NO-LABEL SKIP
    skip(2)
    "PAR¶METROS"               AT  3  SKIP(1)
    tt-param.c-compara-fornecedores  COLON  48
    tt-param.l-email                 COLON  48
    tt-param.l-informa-email         COLON  48
    tt-param.c-para       FORMAT "x(80)"   COLON  24 SKIP
    tt-param.c-cc         FORMAT "x(80)"   COLON  24 SKIP
    TT-PARAM.c-assunto    FORMAT "x(80)"   COLON  24 SKIP
    tt-param.c-mensagem                    COLON  24
    WITH NO-BOX SIDE-LABEL WIDTH 132 FRAME f-param-sel STREAM-IO.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-sel:HANDLE).



def var h-boaf008               as handle     no-undo.
def var da-dt-ini               as date       no-undo.
def var da-dt-fim               as date       no-undo.
DEF VAR h-acomp                 AS HANDLE     NO-UNDO.
DEFINE STREAM html.

DEFINE TEMP-TABLE tt-ava NO-UNDO
    FIELD ep-codigo             LIKE estabelec.ep-codigo
    FIELD cod-estabel           LIKE estabelec.cod-estabel
    FIELD cod-emitente          LIKE emitente.cod-emitente
    FIELD arquivo               AS CHAR  FORMAT "x(200)".
    

DEFINE TEMP-TABLE tt-html NO-UNDO
    FIELD seq-html              AS INT
    FIELD html-doc              AS CHAR 
    INDEX i-seq-mensagem
          seq-html              ASCENDING.


form  tt-ava.ep-codigo
      tt-ava.cod-emitente
      tt-ava.cod-estabel
      tt-ava.arquivo FORMAT "x(80)"
      with stream-io down width 132 no-box frame f-arq-html.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-arq-html:HANDLE).


DEF VAR i-seq-html              AS INTEGER NO-UNDO.
DEF VAR i-empresa               AS INTEGER NO-UNDO.
DEF VAR c-desc-empresa          AS CHAR NO-UNDO.
DEF VAR c-desc-estab            AS CHAR NO-UNDO.
DEF VAR c-razao-social          AS CHAR NO-UNDO.
DEF VAR c-nome-abrev            AS CHAR NO-UNDO.
DEF VAR c-arquivo               AS CHAR NO-UNDO.
DEF VAR c-class                 AS CHAR NO-UNDO.
DEF VAR i-cont                  AS INTEGER NO-UNDO.
DEF VAR c-dt-indice             AS CHAR FORMAT "99/9999" NO-UNDO.

DEF BUFFER b-tt-notas FOR tt-notas.

RUN afbo/boaf008.p PERSISTENT SET h-boaf008.
RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

FIND FIRST param-global NO-LOCK NO-ERROR.
FIND FIRST param_email  NO-LOCK NO-ERROR.


{include/i-rpout.i}
{include/i-rpcab.i}

ASSIGN c-programa 	  = "AF0504RP":U
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-sistema      = "AFP":U
       c-titulo-relat = "Relat¢rio de Notas do Fornecedore".

FIND empresa WHERE empresa.ep-codigo   = i-ep-codigo-usuario NO-LOCK NO-ERROR.
IF AVAIL empresa THEN ASSIGN c-empresa = empresa.razao-social.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Preparando dados ...").

FOR EACH tt-ava:
    DELETE tt-ava.
END.

FOR EACH tt-notas:
    DELETE tt-notas.
END.

run getNotas in h-boaf008 (input tt-param.c-est-ini,
                           input tt-param.c-est-fim,
                           input tt-param.i-emi-ini, 
                           input tt-param.i-emi-fim,
                           input tt-param.c-it-ini,  
                           input tt-param.c-it-fim,
                           input tt-param.i-nr-ini,
                           input tt-param.i-nr-fim, 
                           input tt-param.i-ano-ini,  
                           input tt-param.c-des-per-ini,  
                           INPUT tt-param.i-ano-fim,
                           INPUT tt-param.c-des-per-fim,
                           INPUT tt-param.c-cod-grp-aval-ini,
                           INPUT tt-param.c-cod-grp-aval-fim,
                           INPUT tt-param.c-cod-grp-resp-ini,
                           INPUT tt-param.c-cod-grp-resp-fim,
                           input tt-param.i-cod-gr-forn-ini, 
                           input tt-param.i-cod-gr-forn-fim,
                           input tt-param.c-fm-codigo-ini,
                           input tt-param.c-fm-codigo-fim,
                           input tt-param.i-ge-codigo-ini, 
                           input tt-param.i-ge-codigo-fim,
                           input 1,
                           input 999999,
                           input 1,
                           output table tt-notas). 

RUN pi-inicializar IN h-acomp (INPUT "Imprimindo ...").

IF tt-param.i-compara-fornecedores = 1 THEN DO:

FOR EACH tt-notas 
    WHERE tt-notas.tipo = "TF" NO-LOCK:
    FIND FIRST tt-ava 
        WHERE tt-ava.cod-emitente = tt-notas.cod-emitente 
        AND   tt-ava.cod-estabel  = tt-notas.cod-estabel NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-ava THEN DO:
        CREATE tt-ava.
        ASSIGN tt-ava.cod-emitente = tt-notas.cod-emitente
               tt-ava.cod-estabel  = tt-notas.cod-estabel.
        FIND FIRST estabelec WHERE
             estabelec.cod-estabel = tt-ava.cod-estabel
             NO-LOCK NO-ERROR.
        RUN cdp/cd9970.p(INPUT  ROWID(estabelec),
                         OUTPUT i-empresa).
        ASSIGN tt-ava.ep-codigo = STRING(i-empresa).
    END.
END.

FOR EACH tt-ava NO-LOCK: 

    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
           tt-html.seq-html = i-seq-html.
    
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '<html>' +
    '<head>' +
    '<style>' +
    '    BODY ~{ ' +
    '      FONT-SIZE: small; FONT-FAMILY: Times; BACKGROUND-COLOR: #cccccc ' +
    '    ~}' +
    '    .campo ~{ ' +
    '        BACKGROUND: black ' +
    '    } ' +
    '    .destaq ~{ ' +
    '        BACKGROUND: #cccccc ' +
    '    } ' +
    '    .linhaBrowse ~{ ' +
    '        FONT-SIZE: 8pt; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif ' +
    '    } ' +
    '    .linhaForm ~{ ' +
    '        FONT-SIZE: 8pt; LINE-HEIGHT: normal;; COLOR:black; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif, ' +
    '    } ' +
    '    .linhaVoltar ~{ ' +
    '        FONT-SIZE: 8pt; LINE-HEIGHT: bold;; COLOR:Blue; FONT-STYLE: normal; text-decoration: none; FONT-FAMILY: Arial, Helvetica, sans-serif, ' +
    '    } ' +
    '    .linhatotal ~{ ' +
    '        FONT-SIZE: 10pt; LINE-HEIGHT: normal;; COLOR:red; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif, ' +
    '    } ' +
    '    .fill-in ~{ ' +
    '     font-family:Tahoma, Arial;font-size:xx-small;font-weight:bold;color:black;background:white; ' +
    '    } ' +
    '    .total ~{ ' +
    '     font-family:Tahoma, Arial;font-size:xx-small;font-weight:bold;color:red;background:#cecece; ' +
    '    } ' +
    '    .tableForm ~{ ' +
    '        BORDER-RIGHT: 1px inset; BORDER-TOP: 1px inset; BORDER-LEFT: 1px inset; BORDER-BOTTOM: 1px inset;width:90%  ' +
    '    } ' +
    '    .tableFormVoltar ~{ ' +
    '        BORDER-RIGHT: 0px inset; BORDER-TOP: 0px inset; BORDER-LEFT: 0px inset; BORDER-BOTTOM: 0px inset;width:90%  ' +
    '    } ' +
    '    .tableForm2 ~{ ' +
    '        BORDER-width: 0px inset;padding:0;  ' +
    '    } ' +
    '    .barraTitulo ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 8pt; COLOR:white; FONT-FAMILY: Arial; BACKGROUND-COLOR: #6699CC; TEXT-ALIGN: center; vertical-alignment: middle ' +
    '    } ' +
    '    .barraTituloBrowse ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 8pt; COLOR: #ffffff; FONT-FAMILY: Arial; BACKGROUND-COLOR: #808080; TEXT-ALIGN: center; vertical-alignment: middle ' +
    '    } ' +
    '    .selectedFolder ~{ ' +
    '        BACKGROUND-COLOR: white ' +
    '    } ' +
    '    .unselectedFolder ~{ ' +
    '        BACKGROUND-COLOR: #dcdcdc ' +
    '    } ' +
    '    .barraTotal ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 10pt; COLOR:white; FONT-FAMILY: Arial; BACKGROUND-COLOR: #6699CC; TEXT-ALIGN: right; vertical-alignment: middle ' +
    '    } ' +
    '    .button ~{ ' +
    '    font-family:Verdana, Arial;font-size:xx-small;font-weight:bold;color:white;background:#e0b050;cursor:hand;width:80 ' +
    '    } ' +
    '    .linhaBrowsepar ~{ ' +
    '        FONT-SIZE: 8pt;color:black; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;BACKGROUND-COLOR:#d2eef4 ' +
    '        } ' +
    '    .linhaBrowseimpar ~{ ' +
    '        FONT-SIZE: 8pt;color:black; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;BACKGROUND-COLOR:#ffffff ' +
    '        } ' +
    '    .columnLabel ~{ ' +
    '        FONT-SIZE: 8pt; LINE-HEIGHT: normal;font-weight:bold; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;color:#FFFFFF;BACKGROUND-COLOR:#107f80 ' +
    '        } ' +
    '    .columnLabelSelected ~{ ' +
    '        FONT-SIZE: 8pt; LINE-HEIGHT: normal;font-weight:bold; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;color:#FFFFFF;BACKGROUND-COLOR:#20b0b0 ' +
    '        } ' +
    '    .linkOrdena ~{ ' +
    '        COLOR:white;text-decoration:none;  ' +
    '        } ' +
    '    .aBrowser ~{ ' +
    '       color:red;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:none;  ' +
    '       }  ' +
    '    .aBrowser:hover ~{ ' +
    '       color:red;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:underline ;  ' +
    '      }  ' +
    '   .aBrowserAcom ~{ ' +
    '      color:blue;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:none;  ' +
    '       }  ' +
    '    .aBrowserAcom:hover ~{ ' +
    '       color:blue;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:underline;  ' +
    '       } ' +
    '</style>'.

    FIND FIRST estabelec WHERE
         estabelec.cod-estabel = tt-ava.cod-estabel
         NO-LOCK NO-ERROR.
    ASSIGN c-desc-estab  = estabelec.nome.

    FOR FIRST mguni.empresa FIELD(ep-codigo nome)
        WHERE empresa.ep-codigo = tt-ava.ep-codigo NO-LOCK: END.
    IF AVAIL empresa THEN
       ASSIGN c-desc-empresa = empresa.nome.
    FOR FIRST emitente FIELD(cod-emitente nome-abrev nome-emit)  
        WHERE emitente.cod-emitente = tt-ava.cod-emitente NO-LOCK: END.
    IF AVAIL emitente THEN
      assign c-nome-abrev   = emitente.nome-abrev
             c-razao-social = emitente.nome-emit.

    /* notas gerais */
    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
           tt-html.seq-html = i-seq-html.
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '   <meta http-equiv="Cache-Control" content="No-Cache"> ' +
    '   <meta http-equiv="Pragma"        content="No-Cache"> ' +
    '   <meta http-equiv="Expires"       content="0"> ' +
    ' </head> ' +
    ' <body topmargin="0" leftmargin="0"> ' +
    ' <a name="notasgerais"> ' +
    ' <div align="center"><center> ' +
    '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
    '     <tr> ' +
    '       <td class="barratitulo">' + "Avaliacao do Fornecedor" + '</td> ' +
    '     </tr> ' +
    '    <tr> ' +
    '     <td class="linhaForm" align="center"><center> ' +
    '      <fieldset> ' +
    '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
    '          <tr><td height="5"></td></tr> ' +
    '        <tr> ' +
    '         <th align="right" class="linhaForm" nowrap>Empresa:</th> ' +
    '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
    '            <input class="fill-in" type="text" size="15" name="w_cod_empresa" value="' + STRING(tt-ava.ep-codigo) + '" readonly> ' +
    '            <input class="fill-in" type="text" size="57" name="w_nom_empresa" value="' + c-desc-empresa + '" readonly> ' +
    '         </td> ' +
    '        </tr> ' +
    '        <tr> ' +
    '         <th align="right" class="linhaForm" nowrap>Estabelecimento:</th> ' +
    '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
    '            <input class="fill-in" type="text" size="5" name="w_cod_estab" value="' + STRING(estabelec.cod-estabel) + '" readonly> ' +
    '            <input class="fill-in" type="text" size="67" name="w_nome_estab" value="' + c-desc-estab + '" readonly> ' +
    '         </td> ' +
    '        </tr> ' +
    '        <tr> ' +
    '         <th align="right" class="linhaForm" nowrap>Fornecedor:</th> ' +
    '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
    '            <input class="fill-in" type="text" size="15" maxlength="20" name="w_cod_emitente" value="' + STRING(emitente.cod-emitente) + '" readonly> ' +
    '            <input class="fill-in" type="text" size="57" maxlength="20" name="w_nome_abrev" value="' + c-nome-abrev + '" readonly> ' +
    '         </td> ' +
    '        </tr> ' +
    '        <tr> ' +
    '         <th align="right" class="linhaForm" nowrap>Razao Social:</th> ' +
    '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
    '            <input class="fill-in" type="text" size="78" name="w_razao_social" value="' + c-razao-social + '" readonly> ' +
    '         </td> ' +
    '        </tr> ' +
    '         <tr><td height="5"></td></tr> ' +
    '        </table> ' +
    '      </fieldset> ' +
    '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%"> ' +
    '          <tr> ' +
    '            <td align="center" class="linhaForm" nowrap>Notas Gerais</th> ' +
    '            <td align="center" class="linhaForm" nowrap><a href="#notasitens" class="aBrowser"> Notas dos Itens</a></th> ' +
    '          </tr> ' +
    '        </table> ' +
    '         </td> ' +
    '        </tr> ' +    
    '        <tr><td height="5"></td></tr> ' +
    '        <tr> ' +
    '         <td colspan=2> ' +
    '         <table class="tableForm" align="center" width="100%"> ' +
    '           <tr> ' +
    '             <td align="center"  class="ColumnLabel" >Periodo</td> ' +
    '             <td align="center"  class="ColumnLabel" >Nota</td> ' +
    '           </tr> '.

    FOR EACH tt-notas
        WHERE tt-notas.tipo = "TF"
        AND   tt-notas.cod-emitente = tt-ava.cod-emitente
        AND   tt-notas.cod-estabel  = tt-ava.cod-estabel NO-LOCK
        BY tt-notas.dt-indice-fim DESCENDING:
        ASSIGN i-cont = i-cont + 1.
        IF (i-cont MOD 2) = 0 THEN
           ASSIGN c-class = ' class="linhaBrowseImpar" '.       
        ELSE 
           ASSIGN c-class = ' class="linhaBrowsepar" ' .
        ASSIGN c-dt-indice = fn_retorna_periodo().
        CREATE tt-html.
        ASSIGN i-seq-html       = i-seq-html + 1
               tt-html.seq-html = i-seq-html.       
        ASSIGN tt-html.html-doc = tt-html.html-doc +
        '    <tr> ' +
        '     <td align=center ' + c-class + '><a href="#' + c-dt-indice + '"> ' +
        '       ' + c-dt-indice +
        '     </td> ' +
        '     <td align=right ' + c-class + '> ' +
        '       ' + trim(STRING(tt-notas.nota,">>9.99")) +
        '     </td> ' +
        '    </tr> '.
        
    END.

    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
            tt-html.seq-html = i-seq-html.
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '      </table>   ' +
    '         </td> ' +
    '        </tr> ' +
    '      </table>   ' +

    '    </center> ' + 
    ' </table>   ' +
    '</div> ' +
    '<br><br><br><br><br><br><br><br><br><br><br> ' +
    '<br><br><br><br><br><br><br><br><br><br><br> '.

    /* notas dos itens */
    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
           tt-html.seq-html = i-seq-html.
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    ' <a name="notasitens"> ' +
    ' <div align="center"><center> ' +
    '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
    '     <tr> ' +
    '       <td class="barratitulo">' + "Avaliacao do Fornecedor" + '</td> ' +
    '     </tr> ' +
    '    <tr> ' +
    '     <td class="linhaForm" align="center"><center> ' +
    '      <fieldset> ' +
    '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
    '          <tr><td height="5"></td></tr> ' +
    '        <tr> ' +
    '         <th align="right" class="linhaForm" nowrap>Empresa:</th> ' +
    '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
    '            <input class="fill-in" type="text" size="15" name="w_cod_empresa" value="' + STRING(tt-ava.ep-codigo) + '" readonly> ' +
    '            <input class="fill-in" type="text" size="57" name="w_nom_empresa" value="' + c-desc-empresa + '" readonly> ' +
    '         </td> ' +
    '        </tr> ' +
    '        <tr> ' +
    '         <th align="right" class="linhaForm" nowrap>Estabelecimento:</th> ' +
    '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
    '            <input class="fill-in" type="text" size="5" name="w_cod_estab" value="' + STRING(estabelec.cod-estabel) + '" readonly> ' +
    '            <input class="fill-in" type="text" size="67" name="w_nome_estab" value="' + c-desc-estab + '" readonly> ' +
    '         </td> ' +
    '        </tr> ' +
    '        <tr> ' +
    '         <th align="right" class="linhaForm" nowrap>Fornecedor:</th> ' +
    '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
    '            <input class="fill-in" type="text" size="15" maxlength="20" name="w_cod_emitente" value="' + STRING(emitente.cod-emitente) + '" readonly> ' +
    '            <input class="fill-in" type="text" size="57" maxlength="20" name="w_nome_abrev" value="' + c-nome-abrev + '" readonly> ' +
    '         </td> ' +
    '        </tr> ' +
    '        <tr> ' +
    '         <th align="right" class="linhaForm" nowrap>Razao Social:</th> ' +
    '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
    '            <input class="fill-in" type="text" size="78" name="w_razao_social" value="' + c-razao-social + '" readonly> ' +
    '         </td> ' +
    '        </tr> ' +
    '         <tr><td height="5"></td></tr> ' +
    '        </table> ' +
    '      </fieldset> ' +
    '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%"> ' +
    '          <tr> ' +
    '            <td align="center" class="linhaForm" nowrap><a href="#notasgerais" class="aBrowser"> Notas Gerais</a></th> ' +    
    '            <td align="center" class="linhaForm" nowrap>Notas dos Itens</th> ' +
    '          </tr> ' +
    '        </table> ' +
    '         </td> ' +
    '        </tr> ' +    
    '        <tr><td height="5"></td></tr> ' +
    '        <tr> ' +
    '         <td colspan=2> ' +
    '         <table class="tableForm" align="center" width="100%"> ' +
    '           <tr> ' +
    '             <td align="center"  class="ColumnLabel" >Periodo</td> ' +
    '             <td align="center"  class="ColumnLabel" >Item</td> ' +
    '             <td align="center"  class="ColumnLabel" >Descricao</td> ' +
    '             <td align="center"  class="ColumnLabel" >Nota</td> ' +
    '           </tr> '.

    FOR EACH tt-notas
        WHERE tt-notas.tipo = "TI"
        AND   tt-notas.cod-emitente = tt-ava.cod-emitente
        AND   tt-notas.cod-estabel  = tt-ava.cod-estabel NO-LOCK
        BY tt-notas.dt-indice-fim DESCENDING
        BY tt-notas.nota:
        ASSIGN i-cont = i-cont + 1.
        IF (i-cont MOD 2) = 0 THEN
           ASSIGN c-class = ' class="linhaBrowseImpar" '.       
        ELSE 
           ASSIGN c-class = ' class="linhaBrowsepar" ' .
        ASSIGN c-dt-indice = fn_retorna_periodo().
        CREATE tt-html.
        ASSIGN i-seq-html       = i-seq-html + 1
               tt-html.seq-html = i-seq-html.       
        ASSIGN tt-html.html-doc = tt-html.html-doc +
        '    <tr> ' +
        '     <td align=center ' + c-class + '><a href="#' + c-dt-indice + tt-notas.it-codigo + '"> ' +
        '       ' + c-dt-indice +
        '     </td> ' +
        '     <td ' + c-class + '> ' +
        '       ' + tt-notas.it-codigo +
        '     </td> ' +
        '     <td ' + c-class + '> ' +
        '       ' + tt-notas.desc-item +
        '     </td> ' +
        '     <td align=right ' + c-class + '> ' +
        '       ' + trim(STRING(tt-notas.nota,">>9.99")) +
        '     </td> ' +
        '    </tr> '.
        
    END.


    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
            tt-html.seq-html = i-seq-html.
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '      </table>   ' +
    '         </td> ' +
    '        </tr> ' +
    '      </table>   ' +

    '    </center> ' + 
    ' </table>   ' +
    '</div> ' +
    '<br><br><br><br><br><br><br><br><br><br><br> ' +
    '<br><br><br><br><br><br><br><br><br><br><br> '.

    /* detalhe das notas gerais */
    FOR EACH tt-notas
        WHERE tt-notas.tipo = "TF"
        AND   tt-notas.cod-emitente = tt-ava.cod-emitente
        AND   tt-notas.cod-estabel  = tt-ava.cod-estabel NO-LOCK
        BREAK BY tt-notas.dt-indice-fim:
        IF FIRST-OF (tt-notas.dt-indice-fim) THEN DO:
            ASSIGN c-dt-indice = fn_retorna_periodo().
            CREATE tt-html.
            ASSIGN i-seq-html       = i-seq-html + 1
                   tt-html.seq-html = i-seq-html.
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            ' <a name="' + c-dt-indice + '"> ' +
            ' <div align="center"><center> ' +
            '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
            '     <tr> ' +
            '       <td class="barratitulo">Detalhe Nota Periodo</td> ' +
            '     </tr> ' +
            '     <td class="linhaForm" align="center"><center> ' +
            '      <fieldset> ' +
            '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
            '          <tr><td height="5"></td></tr> ' +
            '          <tr> ' +
            '         <th align="right" class="linhaForm" nowrap>Fornecedor:</th> ' +
            '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
            '            <input class="fill-in" type="text" size="15" maxlength="20" name="w_cod_emitente" value="' + STRING(tt-notas.cod-emitente) + '" readonly> ' +
            '            <input class="fill-in" type="text" size="57" maxlength="20" name="w_nome_abrev" value="' + tt-notas.nome-emit + '" readonly> ' +
            '            <input class="fill-in" type="text" size="7" maxlength="20" name="w_nota" value="' + string(tt-notas.nota,">>9.99") + '" readonly> ' +
            '         </td> ' +
            '          </tr> ' +
            '         <tr><td height="5"></td></tr> ' +
            '        </table> ' +
            '      </fieldset> ' +
            '   </table> ' +
            '        <tr><td height="5"></td></tr> ' +
            '        <tr> ' +
            '         <td colspan=2> ' +
            '         <table class="tableForm" align="center" width="100%"> ' +
            '           <tr> ' +
            '             <td align="center"  class="ColumnLabel" >Periodo</td> ' +
            '             <td align="center"  class="ColumnLabel" >Nr Controle</td> ' +
            '             <td align="center"  class="ColumnLabel" >Descricao</td> ' +
            '             <td align="center"  class="ColumnLabel" >Indice</td> ' +
            '             <td align="center"  class="ColumnLabel" >Percentual</td> ' +
            '             <td align="center"  class="ColumnLabel" >Nota</td> ' +
            '           </tr> '.

            FOR EACH b-tt-notas
                WHERE b-tt-notas.tipo = "DF"
                AND   b-tt-notas.cod-emitente  = tt-ava.cod-emitente
                AND   b-tt-notas.cod-estabel   = tt-ava.cod-estabel 
                AND   b-tt-notas.dt-indice-fim = tt-notas.dt-indice-fim NO-LOCK
                BY    b-tt-notas.indice
                BY    b-tt-notas.percentual
                BY    b-tt-notas.nota:
                ASSIGN i-cont = i-cont + 1.
                IF (i-cont MOD 2) = 0 THEN
                   ASSIGN c-class = ' class="linhaBrowseImpar" '.       
                ELSE 
                   ASSIGN c-class = ' class="linhaBrowsepar" ' .
                CREATE tt-html.
                ASSIGN i-seq-html       = i-seq-html + 1
                       tt-html.seq-html = i-seq-html.       
                ASSIGN tt-html.html-doc = tt-html.html-doc +
                '    <tr> ' +
                '     <td align=center ' + c-class + '> ' +
                '       ' + c-dt-indice +
                '     </td> ' +
                '     <td align=center ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.nr-controle,"999999")) +
                '     </td> ' +
                '     <td  ' + c-class + '> ' +
                '       ' + b-tt-notas.descricao +
                '     </td> ' +
                '     <td align=right ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.indice,">>9.99")) +
                '     </td> ' +
                '     <td align=right ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.percentual,">>9.99")) +
                '     </td> ' +
                '     <td align=right ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.nota,">>9.99")) +
                '     </td> ' +
                '    </tr> '.

            END.


            CREATE tt-html.
            ASSIGN i-seq-html       = i-seq-html + 1
                   tt-html.seq-html = i-seq-html.
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            '         </table>   ' +
            '   </center> ' +
            '  </td> ' +
            ' </tr> ' .


            CREATE tt-html.
            ASSIGN i-seq-html       = i-seq-html + 1
                    tt-html.seq-html = i-seq-html.
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            ' <tr><td class="linhaForm" align="right"><a href="#notasgerais" class="linhaVoltar">Voltar</a></td></tr> ' +
            ' </table>   ' +
            '</div> ' +
            '<br><br><br><br><br><br><br><br><br><br><br> ' +
            '<br><br><br><br><br><br><br><br><br><br><br> '.
        END.
    END.


    /* detalhe das notas dos itens */
    FOR EACH tt-notas
        WHERE tt-notas.tipo = "TI"
        AND   tt-notas.cod-emitente = tt-ava.cod-emitente
        AND   tt-notas.cod-estabel  = tt-ava.cod-estabel NO-LOCK
        BREAK BY tt-notas.dt-indice-fim
              BY tt-notas.it-codigo:
        IF FIRST-OF (tt-notas.it-codigo) THEN DO:
            ASSIGN c-dt-indice = fn_retorna_periodo().
            CREATE tt-html.
            ASSIGN i-seq-html       = i-seq-html + 1
                   tt-html.seq-html = i-seq-html.
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            ' <a name="' + c-dt-indice + tt-notas.it-codigo + '"> ' +
            ' <div align="center"><center> ' +
            '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
            '     <tr> ' +
            '       <td class="barratitulo">Detalhe Notas do Item</td> ' +
            '     </tr> ' +
            '    <tr> ' +
            '     <td class="linhaForm" align="center"><center> ' +
            '      <fieldset> ' +
            '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
            '          <tr><td height="5"></td></tr> ' +
            '          <tr> ' +
            '         <th align="right" class="linhaForm" nowrap>Item:</th> ' +
            '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
            '            <input class="fill-in" type="text" size="17" maxlength="20" name="w_it_codigo" value="' + tt-notas.it-codigo + '" readonly> ' +
            '            <input class="fill-in" type="text" size="60" maxlength="20" name="w_desc_item" value="' + tt-notas.desc-item + '" readonly> ' +
            '            <input class="fill-in" type="text" size="7" maxlength="20" name="w_nota" value="' + string(tt-notas.nota,">>9.99") + '" readonly> ' +
            '         </td> ' +
            '          </tr> ' +
            '         <tr><td height="5"></td></tr> ' +
            '        </table> ' +
            '      </fieldset> ' +
            '   </table> ' +
            '        <tr><td height="5"></td></tr> ' +
            '        <tr> ' +
            '         <td colspan=2> ' +
            '         <table class="tableForm" align="center" width="100%"> ' +
            '           <tr> ' +
            '             <td align="center"  class="ColumnLabel" >Periodo</td> ' +
            '             <td align="center"  class="ColumnLabel" >Nr Controle</td> ' +
            '             <td align="center"  class="ColumnLabel" >Descricao</td> ' +
            '             <td align="center"  class="ColumnLabel" >Indice</td> ' +
            '             <td align="center"  class="ColumnLabel" >Percentual</td> ' +
            '             <td align="center"  class="ColumnLabel" >Nota</td> ' +
            '           </tr> '.

            FOR EACH b-tt-notas
                WHERE b-tt-notas.tipo = "DE"
                AND   b-tt-notas.cod-emitente  = tt-ava.cod-emitente
                AND   b-tt-notas.cod-estabel   = tt-ava.cod-estabel 
                AND   b-tt-notas.dt-indice-fim = tt-notas.dt-indice-fim
                AND   b-tt-notas.it-codigo     = tt-notas.it-codigo NO-LOCK
                BY    b-tt-notas.indice
                BY    b-tt-notas.percentual
                BY    b-tt-notas.nota:
                ASSIGN i-cont = i-cont + 1.
                IF (i-cont MOD 2) = 0 THEN
                   ASSIGN c-class = ' class="linhaBrowseImpar" '.       
                ELSE 
                   ASSIGN c-class = ' class="linhaBrowsepar" ' .
                CREATE tt-html.
                ASSIGN i-seq-html       = i-seq-html + 1
                       tt-html.seq-html = i-seq-html.       
                ASSIGN tt-html.html-doc = tt-html.html-doc +
                '    <tr> ' +
                '     <td align=center ' + c-class + '> ' +
                '       ' + c-dt-indice +
                '     </td> ' +
                '     <td align=center ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.nr-controle,"999999")) +
                '     </td> ' +
                '     <td  ' + c-class + '> ' +
                '       ' + b-tt-notas.descricao +
                '     </td> ' +
                '     <td align=right ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.indice,">>9.99")) +
                '     </td> ' +
                '     <td align=right ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.percentual,">>9.99")) +
                '     </td> ' +
                '     <td align=right ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.nota,">>9.99")) +
                '     </td> ' +
                '    </tr> '.

            END.


            CREATE tt-html.
            ASSIGN i-seq-html       = i-seq-html + 1
                   tt-html.seq-html = i-seq-html.
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            '         </table>   ' +
            '   </center> ' +
            '  </td> ' +
            ' </tr> ' .


            CREATE tt-html.
            ASSIGN i-seq-html       = i-seq-html + 1
                    tt-html.seq-html = i-seq-html.
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            ' <tr><td class="linhaForm" align="right"><a href="#notasitens" class="linhaVoltar">Voltar</a></td></tr> ' +
            ' </table>   ' +
            '</div> ' +
            '<br><br><br><br><br><br><br><br><br><br><br> ' +
            '<br><br><br><br><br><br><br><br><br><br><br> '.
        END.
    END.

 
    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
           tt-html.seq-html = i-seq-html.
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '  </form> ' +
    ' </body>  ' +
    '</html> ' .    

    FOR FIRST usuar_mestre 
        FIELDS (nom_dir_spool nom_subdir_spool)
        WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-LOCK:
        assign tt-ava.arquivo = if length(usuar_mestre.nom_subdir_spool) <> 0
                        then caps(replace(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" + replace(usuar_mestre.nom_subdir_spool, "~\", "~/") + "~/" + "AVA" + tt-ava.cod-estabel + string(tt-ava.cod-emitente) + ".html")
                        else caps(replace(usuar_mestre.nom_dir_spool, "~\", "~/") + "~/" +  "AVA" + tt-ava.cod-estabel + string(tt-ava.cod-emitente) + ".html").
    END.
    
    OUTPUT STREAM html TO VALUE(tt-ava.arquivo) convert target 'iso8859-1'.
        FOR EACH tt-html:
           PUT STREAM html UNFORMATTED tt-html.html-doc.
        END.
    OUTPUT STREAM html CLOSE.
    FOR EACH tt-mensagem:
        DELETE tt-mensagem.
    END.    
    FOR EACH tt-html:
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = tt-html.seq-html
               tt-mensagem.mensagem     = tt-html.html-doc.
        DELETE tt-html.
    END.
    IF tt-param.l-email  THEN 
       RUN pi-enviar-email.
    IF tt-param.l-informa-email  THEN 
       RUN pi-enviar-email-comp.



END.

END. /* if tt-param.l-detalha-controle-fornecedor */
ELSE IF tt-param.i-compara-fornecedores = 2 THEN DO:

FIND FIRST tt-notas 
    WHERE tt-notas.tipo = "TF" NO-LOCK NO-ERROR.
IF AVAIL tt-notas THEN DO:
   FIND FIRST estabelec WHERE
        estabelec.cod-estabel = tt-notas.cod-estabel
        NO-LOCK NO-ERROR.
   RUN cdp/cd9970.p(INPUT  ROWID(estabelec),
                         OUTPUT i-empresa).
   CREATE tt-ava.       
   ASSIGN tt-ava.ep-codigo = STRING(i-empresa).
END.

FOR EACH tt-ava NO-LOCK:

    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
           tt-html.seq-html = i-seq-html.
    
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '<html>' +
    '<head>' +
    '<style>' +
    '    BODY ~{ ' +
    '      FONT-SIZE: small; FONT-FAMILY: Times; BACKGROUND-COLOR: #cccccc ' +
    '    ~}' +
    '    .campo ~{ ' +
    '        BACKGROUND: black ' +
    '    } ' +
    '    .destaq ~{ ' +
    '        BACKGROUND: #cccccc ' +
    '    } ' +
    '    .linhaBrowse ~{ ' +
    '        FONT-SIZE: 8pt; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif ' +
    '    } ' +
    '    .linhaForm ~{ ' +
    '        FONT-SIZE: 8pt; LINE-HEIGHT: normal;; COLOR:black; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif, ' +
    '    } ' +
    '    .linhaVoltar ~{ ' +
    '        FONT-SIZE: 8pt; LINE-HEIGHT: bold;; COLOR:Blue; FONT-STYLE: normal; text-decoration: none; FONT-FAMILY: Arial, Helvetica, sans-serif, ' +
    '    } ' +
    '    .linhatotal ~{ ' +
    '        FONT-SIZE: 10pt; LINE-HEIGHT: normal;; COLOR:red; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif, ' +
    '    } ' +
    '    .fill-in ~{ ' +
    '     font-family:Tahoma, Arial;font-size:xx-small;font-weight:bold;color:black;background:white; ' +
    '    } ' +
    '    .total ~{ ' +
    '     font-family:Tahoma, Arial;font-size:xx-small;font-weight:bold;color:red;background:#cecece; ' +
    '    } ' +
    '    .tableForm ~{ ' +
    '        BORDER-RIGHT: 1px inset; BORDER-TOP: 1px inset; BORDER-LEFT: 1px inset; BORDER-BOTTOM: 1px inset;width:90%  ' +
    '    } ' +
    '    .tableFormVoltar ~{ ' +
    '        BORDER-RIGHT: 0px inset; BORDER-TOP: 0px inset; BORDER-LEFT: 0px inset; BORDER-BOTTOM: 0px inset;width:90%  ' +
    '    } ' +
    '    .tableForm2 ~{ ' +
    '        BORDER-width: 0px inset;padding:0;  ' +
    '    } ' +
    '    .barraTitulo ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 8pt; COLOR:white; FONT-FAMILY: Arial; BACKGROUND-COLOR: #6699CC; TEXT-ALIGN: center; vertical-alignment: middle ' +
    '    } ' +
    '    .barraTituloBrowse ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 8pt; COLOR: #ffffff; FONT-FAMILY: Arial; BACKGROUND-COLOR: #808080; TEXT-ALIGN: center; vertical-alignment: middle ' +
    '    } ' +
    '    .selectedFolder ~{ ' +
    '        BACKGROUND-COLOR: white ' +
    '    } ' +
    '    .unselectedFolder ~{ ' +
    '        BACKGROUND-COLOR: #dcdcdc ' +
    '    } ' +
    '    .barraTotal ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 10pt; COLOR:white; FONT-FAMILY: Arial; BACKGROUND-COLOR: #6699CC; TEXT-ALIGN: right; vertical-alignment: middle ' +
    '    } ' +
    '    .button ~{ ' +
    '    font-family:Verdana, Arial;font-size:xx-small;font-weight:bold;color:white;background:#e0b050;cursor:hand;width:80 ' +
    '    } ' +
    '    .linhaBrowsepar ~{ ' +
    '        FONT-SIZE: 8pt;color:black; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;BACKGROUND-COLOR:#d2eef4 ' +
    '        } ' +
    '    .linhaBrowseimpar ~{ ' +
    '        FONT-SIZE: 8pt;color:black; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;BACKGROUND-COLOR:#ffffff ' +
    '        } ' +
    '    .columnLabel ~{ ' +
    '        FONT-SIZE: 8pt; LINE-HEIGHT: normal;font-weight:bold; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;color:#FFFFFF;BACKGROUND-COLOR:#107f80 ' +
    '        } ' +
    '    .columnLabelSelected ~{ ' +
    '        FONT-SIZE: 8pt; LINE-HEIGHT: normal;font-weight:bold; FONT-STYLE: normal; FONT-FAMILY: Arial, Helvetica, sans-serif;color:#FFFFFF;BACKGROUND-COLOR:#20b0b0 ' +
    '        } ' +
    '    .linkOrdena ~{ ' +
    '        COLOR:white;text-decoration:none;  ' +
    '        } ' +
    '    .aBrowser ~{ ' +
    '       color:red;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:none;  ' +
    '       }  ' +
    '    .aBrowser:hover ~{ ' +
    '       color:red;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:underline ;  ' +
    '      }  ' +
    '   .aBrowserAcom ~{ ' +
    '      color:blue;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:none;  ' +
    '       }  ' +
    '    .aBrowserAcom:hover ~{ ' +
    '       color:blue;font-family:Arial;font-size:8pt;font-weight:normal;text-decoration:underline;  ' +
    '       } ' +
    '</style>'.


    FOR FIRST mguni.empresa FIELD(ep-codigo nome)
        WHERE empresa.ep-codigo = tt-ava.ep-codigo NO-LOCK: END.
    IF AVAIL empresa THEN
       ASSIGN c-desc-empresa = empresa.nome.

    /* notas estabelecimentos */
    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
           tt-html.seq-html = i-seq-html.
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '   <meta http-equiv="Cache-Control" content="No-Cache"> ' +
    '   <meta http-equiv="Pragma"        content="No-Cache"> ' +
    '   <meta http-equiv="Expires"       content="0"> ' +
    ' </head> ' +
    ' <body topmargin="0" leftmargin="0"> ' +
    ' <a name="estabelecimento"> ' +
    ' <div align="center"><center> ' +
    '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
    '     <tr> ' +
    '       <td class="barratitulo">' + "Compracao das Notas dos Fornecedores" + '</td> ' +
    '     </tr> ' +
    '    <tr> ' +
    '     <td class="linhaForm" align="center"><center> ' +
    '      <fieldset> ' +
    '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
    '          <tr><td height="5"></td></tr> ' +
    '        <tr> ' +
    '         <th align="right" class="linhaForm" nowrap>Empresa:</th> ' +
    '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
    '            <input class="fill-in" type="text" size="15" name="w_cod_empresa" value="' + STRING(tt-ava.ep-codigo) + '" readonly> ' +
    '            <input class="fill-in" type="text" size="57" name="w_nom_empresa" value="' + c-desc-empresa + '" readonly> ' +
    '         </td> ' +
    '        </tr> ' +
    '         <tr><td height="5"></td></tr> ' +
    '        </table> ' +
    '      </fieldset> ' +
    '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%"> ' +
    '          <tr> ' +
    '            <td align="center" class="linhaForm" nowrap>Estabelecimento</th> ' +
    '            <td align="center" class="linhaForm" nowrap><a href="#fornecedor" class="aBrowser"> Fornecedor</a></th> ' +
    '          </tr> ' +
    '        </table> ' +
    '         </td> ' +
    '        </tr> ' +    
    '        <tr><td height="5"></td></tr> ' +
    '        <tr> ' +
    '         <td colspan=2> ' +
    '         <table class="tableForm" align="center" width="100%"> ' +
    '           <tr> ' +
    '             <td align="center"  class="ColumnLabel" >Cod Estabel</td> ' +
    '             <td align="center"  class="ColumnLabel" >Periodo</td> ' +
    '             <td align="center"  class="ColumnLabel" >Fornecedor</td> ' +
    '             <td align="center"  class="ColumnLabel" >Nome Abrev</td> ' +
    '             <td align="center"  class="ColumnLabel" >Nota</td> ' +
    '           </tr> '.

    FOR EACH tt-notas
        WHERE tt-notas.tipo = "TF" NO-LOCK
        BY tt-notas.cod-estabel
        BY tt-notas.dt-indice-fim DESCENDING
        BY tt-notas.cod-emitente:
        ASSIGN i-cont = i-cont + 1.
        IF (i-cont MOD 2) = 0 THEN
           ASSIGN c-class = ' class="linhaBrowseImpar" '.       
        ELSE 
           ASSIGN c-class = ' class="linhaBrowsepar" ' .
        ASSIGN c-dt-indice = fn_retorna_periodo().
        CREATE tt-html.
        ASSIGN i-seq-html       = i-seq-html + 1
               tt-html.seq-html = i-seq-html.       
        ASSIGN tt-html.html-doc = tt-html.html-doc +
        '    <tr> ' +
        '     <td align=center ' + c-class + '> ' +
        '       ' + tt-notas.cod-estabel +
        '     </td> ' +
        '     <td align=center ' + c-class + '><a href="#' + tt-notas.cod-estabel + c-dt-indice + '"> ' +
        '       ' + c-dt-indice +
        '     </td> ' +
        '     <td align=right ' + c-class + '> ' +
        '       ' + trim(STRING(tt-notas.cod-emitente)) +
        '     </td> ' +
        '     <td ' + c-class + '> ' +
        '       ' + trim(STRING(tt-notas.nome-emit)) +
        '     </td> ' +
        '     <td align=center ' + c-class + '> ' +
        '       ' + trim(STRING(tt-notas.nota,">>9.99")) +
        '     </td> ' +
        '    </tr> '.
        
    END.

    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
            tt-html.seq-html = i-seq-html.
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '      </table>   ' +
    '         </td> ' +
    '        </tr> ' +
    '      </table>   ' +

    '    </center> ' + 
    ' </table>   ' +
    '</div> ' +
    '<br><br><br><br><br><br><br><br><br><br><br> ' +
    '<br><br><br><br><br><br><br><br><br><br><br> '.


    /* notas fornecedor */
    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
           tt-html.seq-html = i-seq-html
           i-cont = 0.
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    ' <a name="fornecedor"> ' +
    ' <div align="center"><center> ' +
    '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
    '     <tr> ' +
    '       <td class="barratitulo">' + "Compracao das Notas dos Fornecedores" + '</td> ' +
    '     </tr> ' +
    '    <tr> ' +
    '     <td class="linhaForm" align="center"><center> ' +
    '      <fieldset> ' +
    '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
    '          <tr><td height="5"></td></tr> ' +
    '        <tr> ' +
    '         <th align="right" class="linhaForm" nowrap>Empresa:</th> ' +
    '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
    '            <input class="fill-in" type="text" size="15" name="w_cod_empresa" value="' + STRING(tt-ava.ep-codigo) + '" readonly> ' +
    '            <input class="fill-in" type="text" size="57" name="w_nom_empresa" value="' + c-desc-empresa + '" readonly> ' +
    '         </td> ' +
    '        </tr> ' +
    '         <tr><td height="5"></td></tr> ' +
    '        </table> ' +
    '      </fieldset> ' +
    '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="75%"> ' +
    '          <tr> ' +
    '            <td align="center" class="linhaForm" nowrap><a href="#estabelecimento" class="aBrowser"> Estabelecimento</a></th> ' +
    '            <td align="center" class="linhaForm" nowrap>Fornecedor</th> ' +
    '          </tr> ' +
    '        </table> ' +
    '         </td> ' +
    '        </tr> ' +    
    '        <tr><td height="5"></td></tr> ' +
    '        <tr> ' +
    '         <td colspan=2> ' +
    '         <table class="tableForm" align="center" width="100%"> ' +
    '           <tr> ' +
    '             <td align="center"  class="ColumnLabel" >Fornecedor</td> ' +
    '             <td align="center"  class="ColumnLabel" >Nome Abrev</td> ' +
    '             <td align="center"  class="ColumnLabel" >Cod Estabel</td> ' +
    '             <td align="center"  class="ColumnLabel" >Periodo</td> ' +
    '             <td align="center"  class="ColumnLabel" >Nota</td> ' +
    '           </tr> '.

    FOR EACH tt-notas
        WHERE tt-notas.tipo = "TF" NO-LOCK
        BY tt-notas.cod-emitente
        BY tt-notas.cod-estabel
        BY tt-notas.dt-indice-fim DESCENDING:
        ASSIGN i-cont = i-cont + 1.
        IF (i-cont MOD 2) = 0 THEN
           ASSIGN c-class = ' class="linhaBrowseImpar" '.       
        ELSE 
           ASSIGN c-class = ' class="linhaBrowsepar" ' .
        ASSIGN c-dt-indice = fn_retorna_periodo().
        CREATE tt-html.
        ASSIGN i-seq-html       = i-seq-html + 1
               tt-html.seq-html = i-seq-html.       
        ASSIGN tt-html.html-doc = tt-html.html-doc +
        '     <td align=right ' + c-class + '> ' +
        '       ' + trim(STRING(tt-notas.cod-emitente)) +
        '     </td> ' +
        '     <td ' + c-class + '> ' +
        '       ' + trim(STRING(tt-notas.nome-emit)) +
        '     </td> ' +
        '     <td align=center ' + c-class + '> ' +
        '       ' + tt-notas.cod-estabel +
        '     </td> ' +
        '     <td align=center ' + c-class + '><a href="#' + STRING(tt-notas.cod-emitente) + c-dt-indice + '"> ' +
        '       ' + c-dt-indice +
        '     </td> ' +
        '     <td align=center ' + c-class + '> ' +
        '       ' + trim(STRING(tt-notas.nota,">>9.99")) +
        '     </td> ' +
        '    </tr> '.
        
    END.

    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
            tt-html.seq-html = i-seq-html.
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '      </table>   ' +
    '         </td> ' +
    '        </tr> ' +
    '      </table>   ' +

    '    </center> ' +
    ' </table>   ' +
    '</div> ' +
    '<br><br><br><br><br><br><br><br><br><br><br> ' +
    '<br><br><br><br><br><br><br><br><br><br><br> '.


    /* detalhe comparativo por estelecimento */
    FOR EACH tt-notas
        WHERE tt-notas.tipo = "TF" NO-LOCK
        BREAK BY tt-notas.cod-estabel
              BY tt-notas.dt-indice-fim:
        IF FIRST-OF (tt-notas.dt-indice-fim) THEN DO:
            ASSIGN c-dt-indice = fn_retorna_periodo().
            FIND FIRST estabelec WHERE
                 estabelec.cod-estabel = tt-notas.cod-estabel
                 NO-LOCK NO-ERROR.
            ASSIGN c-desc-estab  = estabelec.nome.
            CREATE tt-html.
            ASSIGN i-seq-html       = i-seq-html + 1
                   tt-html.seq-html = i-seq-html.
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            ' <a name="' + tt-notas.cod-estabel + c-dt-indice + '"> ' +
            ' <div align="center"><center> ' +
            '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
            '     <tr> ' +
            '       <td class="barratitulo">Detalhe das Notas do Estabelecimento por Periodo</td> ' +
            '     </tr> ' +
            '     <td class="linhaForm" align="center"><center> ' +
            '      <fieldset> ' +
            '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
            '          <tr><td height="5"></td></tr> ' +
            '          <tr> ' +
            '         <th align="right" class="linhaForm" nowrap>Estabelecimento:</th> ' +
            '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
            '            <input class="fill-in" type="text" size="4" maxlength="20" name="w_cod_estabel" value="' + tt-notas.cod-estabel + '" readonly> ' +
            '            <input class="fill-in" type="text" size="57" maxlength="20" name="w_nome" value="' + c-desc-estab + '" readonly> ' +
            '            <input class="fill-in" type="text" size="9" maxlength="20" name="w_periodo" value="' + c-dt-indice + '" readonly> ' +
            '         </td> ' +
            '          </tr> ' +
            '         <tr><td height="5"></td></tr> ' +
            '        </table> ' +
            '      </fieldset> ' +
            '   </table> ' +
            '        <tr><td height="5"></td></tr> ' +
            '        <tr> ' +
            '         <td colspan=2> ' +
            '         <table class="tableForm" align="center" width="100%"> ' +
            '           <tr> ' +
            '             <td align="center"  class="ColumnLabel" >Nr Controle</td> ' +
            '             <td align="center"  class="ColumnLabel" >Descricao</td> ' +
            '             <td align="center"  class="ColumnLabel" >Fornecedor</td> ' +
            '             <td align="center"  class="ColumnLabel" >Nome</td> ' +
            '             <td align="center"  class="ColumnLabel" >Indice</td> ' +
            '             <td align="center"  class="ColumnLabel" >Percentual</td> ' +
            '             <td align="center"  class="ColumnLabel" >Nota</td> ' +
            '           </tr> '.

            FOR EACH b-tt-notas
                WHERE b-tt-notas.tipo = "DF"
                AND   b-tt-notas.cod-estabel   = tt-notas.cod-estabel 
                AND   b-tt-notas.dt-indice-fim = tt-notas.dt-indice-fim NO-LOCK
                BY    b-tt-notas.nr-controle
                BY    b-tt-notas.indice DESCENDING
                BY    b-tt-notas.percentual
                BY    b-tt-notas.nota
                BY    b-tt-notas.cod-emitente:
                ASSIGN i-cont = i-cont + 1.
                IF (i-cont MOD 2) = 0 THEN
                   ASSIGN c-class = ' class="linhaBrowseImpar" '.       
                ELSE 
                   ASSIGN c-class = ' class="linhaBrowsepar" ' .
                CREATE tt-html.
                ASSIGN i-seq-html       = i-seq-html + 1
                       tt-html.seq-html = i-seq-html.       
                ASSIGN tt-html.html-doc = tt-html.html-doc +
                '    <tr> ' +
                '     <td align=center ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.nr-controle,"999999")) +
                '     </td> ' +
                '     <td  ' + c-class + '> ' +
                '       ' + b-tt-notas.descricao +
                '     </td> ' +
                '     <td align=right ' + c-class + '> ' +
                '       ' + STRING(b-tt-notas.cod-emitente) +
                '     </td> ' +
                '     <td ' + c-class + '> ' +
                '       ' + b-tt-notas.nome-emit +
                '     </td> ' +
                '     <td align=right ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.indice,">>9.99")) +
                '     </td> ' +
                '     <td align=right ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.percentual,">>9.99")) +
                '     </td> ' +
                '     <td align=right ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.nota,">>9.99")) +
                '     </td> ' +
                '    </tr> '.

            END.


            CREATE tt-html.
            ASSIGN i-seq-html       = i-seq-html + 1
                   tt-html.seq-html = i-seq-html.
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            '         </table>   ' +
            '   </center> ' +
            '  </td> ' +
            ' </tr> ' .


            CREATE tt-html.
            ASSIGN i-seq-html       = i-seq-html + 1
                    tt-html.seq-html = i-seq-html.
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            ' <tr><td class="linhaForm" align="right"><a href="#estabelecimento" class="linhaVoltar">Voltar</a></td></tr> ' +
            ' </table>   ' +
            '</div> ' +
            '<br><br><br><br><br><br><br><br><br><br><br> ' +
            '<br><br><br><br><br><br><br><br><br><br><br> '.
        END.
    END.

    /* detalhe comparativo por fornecedor */
    FOR EACH tt-notas
        WHERE tt-notas.tipo = "TF" NO-LOCK
        BREAK BY tt-notas.cod-emitente
              BY tt-notas.dt-indice-fim:
        IF FIRST-OF (tt-notas.dt-indice-fim) THEN DO:
            ASSIGN c-dt-indice = fn_retorna_periodo().
            CREATE tt-html.
            ASSIGN i-seq-html       = i-seq-html + 1
                   tt-html.seq-html = i-seq-html.
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            ' <a name="' + string(tt-notas.cod-emitente) + c-dt-indice + '"> ' +
            ' <div align="center"><center> ' +
            '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm"> ' +
            '     <tr> ' +
            '       <td class="barratitulo">Detalhe das Notas do Fornecedor por Periodo</td> ' +
            '     </tr> ' +
            '     <td class="linhaForm" align="center"><center> ' +
            '      <fieldset> ' +
            '        <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%"> ' +
            '          <tr><td height="5"></td></tr> ' +
            '          <tr> ' +
            '         <th align="right" class="linhaForm" nowrap>Fornecedor:</th> ' +
            '         <td class="linhaForm" align="left" nowrap colspan=3 > ' +
            '            <input class="fill-in" type="text" size="15" maxlength="20" name="w_cod_emitente" value="' + STRING(tt-notas.cod-emitente) + '" readonly> ' +
            '            <input class="fill-in" type="text" size="57" maxlength="20" name="w_nome_abrev" value="' + tt-notas.nome-emit + '" readonly> ' +
            '            <input class="fill-in" type="text" size="7" maxlength="20" name="w_periodo" value="' + c-dt-indice + '" readonly> ' +
            '         </td> ' +
            '          </tr> ' +
            '         <tr><td height="5"></td></tr> ' +
            '        </table> ' +
            '      </fieldset> ' +
            '   </table> ' +
            '        <tr><td height="5"></td></tr> ' +
            '        <tr> ' +
            '         <td colspan=2> ' +
            '         <table class="tableForm" align="center" width="100%"> ' +
            '           <tr> ' +
            '             <td align="center"  class="ColumnLabel" >Nr Controle</td> ' +
            '             <td align="center"  class="ColumnLabel" >Descricao</td> ' +
            '             <td align="center"  class="ColumnLabel" >Cod Estabel </td> ' +
            '             <td align="center"  class="ColumnLabel" >Indice </td> ' +
            '             <td align="center"  class="ColumnLabel" >Percentual </td> ' +
            '             <td align="center"  class="ColumnLabel" >Nota</td> ' +
            '           </tr> '.

            FOR EACH b-tt-notas
                WHERE b-tt-notas.tipo = "DF"
                AND   b-tt-notas.cod-emitente  = tt-notas.cod-emitente
                AND   b-tt-notas.dt-indice-fim = tt-notas.dt-indice-fim NO-LOCK
                BY    b-tt-notas.nr-controle
                BY    b-tt-notas.indice DESCENDING
                BY    b-tt-notas.percentual
                BY    b-tt-notas.nota:
                ASSIGN i-cont = i-cont + 1.
                IF (i-cont MOD 2) = 0 THEN
                   ASSIGN c-class = ' class="linhaBrowseImpar" '.       
                ELSE 
                   ASSIGN c-class = ' class="linhaBrowsepar" ' .
                CREATE tt-html.
                ASSIGN i-seq-html       = i-seq-html + 1
                       tt-html.seq-html = i-seq-html.       
                ASSIGN tt-html.html-doc = tt-html.html-doc +
                '    <tr> ' +
                '     <td align=center ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.nr-controle,"999999")) +
                '     </td> ' +
                '     <td  ' + c-class + '> ' +
                '       ' + b-tt-notas.descricao +
                '     </td> ' +
                '     <td align=center ' + c-class + '> ' +
                '       ' + b-tt-notas.cod-estabel +
                '     </td> ' +
                '     <td align=right ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.indice,">>9.99")) +
                '     </td> ' +
                '     <td align=right ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.percentual,">>9.99")) +
                '     </td> ' +
                '     <td align=right ' + c-class + '> ' +
                '       ' + trim(STRING(b-tt-notas.nota,">>9.99")) +
                '     </td> ' +
                '    </tr> '.

            END.


            CREATE tt-html.
            ASSIGN i-seq-html       = i-seq-html + 1
                   tt-html.seq-html = i-seq-html.
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            '         </table>   ' +
            '   </center> ' +
            '  </td> ' +
            ' </tr> ' .


            CREATE tt-html.
            ASSIGN i-seq-html       = i-seq-html + 1
                    tt-html.seq-html = i-seq-html.
            ASSIGN tt-html.html-doc = tt-html.html-doc +
            ' <tr><td class="linhaForm" align="right"><a href="#fornecedor" class="linhaVoltar">Voltar</a></td></tr> ' +
            ' </table>   ' +
            '</div> ' +
            '<br><br><br><br><br><br><br><br><br><br><br> ' +
            '<br><br><br><br><br><br><br><br><br><br><br> '.
        END.
    END.





    CREATE tt-html.
    ASSIGN i-seq-html       = i-seq-html + 1
           tt-html.seq-html = i-seq-html.
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '  </form> ' +
    ' </body>  ' +
    '</html> ' .             

    ASSIGN tt-ava.arquivo =  string(session:temp-directory) + "AVA-FOR-" + string(tt-ava.ep-codigo) + ".html".
    
    OUTPUT STREAM html TO VALUE(tt-ava.arquivo) convert target 'iso8859-1' .
        FOR EACH tt-html:
           PUT STREAM html UNFORMATTED tt-html.html-doc.
        END.
    OUTPUT STREAM html CLOSE.
    
    FOR EACH tt-mensagem:
        DELETE tt-mensagem.
    END.
    FOR EACH tt-html:
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.seq-mensagem = tt-html.seq-html
               tt-mensagem.mensagem     = tt-html.html-doc.
        DELETE tt-html.
    END.
    IF tt-param.l-informa-email  THEN 
       RUN pi-enviar-email-comp.


END. /* for each tt-ava no-lock: */

END. /* IF tt-param.l-compara-fornecedor THEN */


PROCEDURE pi-enviar-email:
   FIND usuar_mestre 
       WHERE usuar_mestre.cod_usuario = tt-param.usuario NO-LOCK NO-ERROR.
   IF AVAIL usuar_mestre AND usuar_mestre.cod_e_mail_local <> "" THEN DO:
          FIND emitente WHERE emitente.cod-emitente = tt-ava.cod-emitente NO-LOCK NO-ERROR.
          IF emitente.e-mail <> "" THEN DO:
             FOR EACH tt-envio2:
                 DELETE tt-envio2.
             END.   
             FOR EACH tt-erros:
                 DELETE tt-erros.
             END.
             create tt-envio2.
             assign tt-envio2.versao-integracao = 1
                    tt-envio2.exchange    = param_email.log_servid_exchange
                    tt-envio2.destino     = emitente.e-mail
                    tt-envio2.importancia = 2
                    tt-envio2.log-enviada = YES
                    tt-envio2.log-lida    = YES
                    tt-envio2.acomp       = no
                    tt-envio2.formato     = "HTML"
                    tt-envio2.mensagem    = tt-param.c-mensagem
                    tt-envio2.remetente   = usuar_mestre.cod_e_mail_local
                    tt-envio2.servidor    = param_email.cod_servid_e_mail
                    tt-envio2.porta       = param_email.num_porta.
             ASSIGN tt-envio2.assunto     = "MAF - Avaliacao do Fornecedor: " + string(emitente.cod-emitente) + "-" + emitente.nome-abrev  + " - " + tt-param.c-assunto.
             
             run utp/utapi019.p persistent set h-utapi019.
             IF tt-param.l-anexar THEN DO:
                ASSIGN tt-envio2.arq-anexo   = tt-ava.arquivo.
                run pi-execute  in h-utapi019 (input table tt-envio2,  
                                               output table tt-erros).
             END.
             ELSE
                run pi-execute2 in h-utapi019 (input table tt-envio2,                   
                                               INPUT TABLE tt-mensagem,
                                               output table tt-erros).
             delete procedure h-utapi019.
             find first tt-erros no-error.
             if available tt-erros then do:
                put skip(1).
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Erros_da_utapi019" *}
                put unformatted RETURN-VALUE + "                 : " at 0 skip.            
                for each tt-erros:
                    put unformatted string(tt-erros.cod-erro) + " - " + tt-erros.desc-erro at 0 skip.                
                end.
             end.
          END.
   END.
END. /* if tt-param.l-email */

PROCEDURE pi-enviar-email-comp:
   FIND usuar_mestre 
       WHERE usuar_mestre.cod_usuario = tt-param.usuario NO-LOCK NO-ERROR.
   IF AVAIL usuar_mestre AND usuar_mestre.cod_e_mail_local <> "" THEN DO:
         FOR EACH tt-envio2:
             DELETE tt-envio2.
         END.   
         FOR EACH tt-erros:
             DELETE tt-erros.
         END.
         create tt-envio2.
         assign tt-envio2.versao-integracao = 1
                tt-envio2.exchange    = param_email.log_servid_exchange
                tt-envio2.destino     = tt-param.c-para
                tt-envio2.copia       = tt-param.c-cc
                tt-envio2.importancia = 2
                tt-envio2.log-enviada = YES
                tt-envio2.log-lida    = YES
                tt-envio2.acomp       = no
                tt-envio2.formato     = "HTML"
                tt-envio2.mensagem    = tt-param.c-mensagem
                tt-envio2.remetente   = usuar_mestre.cod_e_mail_local
                tt-envio2.servidor    = param_email.cod_servid_e_mail
                tt-envio2.porta       = param_email.num_porta.
         ASSIGN tt-envio2.assunto     = "MAF - Comparacao dos Fornecedores - " + tt-param.c-assunto.
         

         run utp/utapi019.p persistent set h-utapi019.
         IF tt-param.l-anexar THEN DO:
            ASSIGN tt-envio2.arq-anexo   = tt-ava.arquivo.
            run pi-execute  in h-utapi019 (input table tt-envio2,  
                                           output table tt-erros).
         END.
         ELSE
            run pi-execute2 in h-utapi019 (input table tt-envio2,                   
                                           INPUT TABLE tt-mensagem,
                                           output table tt-erros).
         delete procedure h-utapi019.
         find first tt-erros no-error.
         if available tt-erros then do:
            put skip(1).
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Erros_da_utapi019" *}
            put unformatted RETURN-VALUE + "                 : " at 0 skip.            
            for each tt-erros:
                put unformatted string(tt-erros.cod-erro) + " - " + tt-erros.desc-erro at 0 skip.                
            end.
         end.
   END.
END. /* if tt-param.l-informa-email */
VIEW FRAME f-cabec.
VIEW FRAME f-rodape.

/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "ARQUIVOS_GERADOS" *}
PUT UNFORMATTED SKIP(2)
    RETURN-VALUE SKIP.

FOR EACH tt-ava:
    DISP tt-ava.cod-emitente
         tt-ava.cod-estabel
         tt-ava.arquivo
        WITH FRAME f-arq-html.
    down with frame f-arq-html.

END.



DISPLAY tt-param.c-est-ini    
        tt-param.c-est-fim 
        tt-param.i-emi-ini 
        tt-param.i-emi-fim
        tt-param.c-it-ini    
        tt-param.c-it-fim 
        tt-param.i-nr-ini   
        tt-param.i-nr-fim 
        tt-param.i-ano-ini
        tt-param.i-ano-fim
        tt-param.c-des-per-ini
        tt-param.c-des-per-fim
        tt-param.i-cod-gr-forn-ini 
        tt-param.i-cod-gr-forn-fim
        tt-param.c-fm-codigo-ini
        tt-param.c-fm-codigo-fim
        tt-param.i-ge-codigo-ini 
        tt-param.i-ge-codigo-fim
        tt-param.c-cod-grp-aval-ini
        tt-param.c-cod-grp-aval-fim
        tt-param.c-cod-grp-resp-ini
        tt-param.c-cod-grp-resp-fim
        tt-param.c-compara-fornecedores
        tt-param.l-email 
        tt-param.l-informa-email
        tt-param.c-para   
        tt-param.c-cc
        tt-param.c-assunto
        tt-param.c-mensagem
        WITH  FRAME f-param-sel.

    ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}
           c-arquivo = tt-param.arquivo.
    
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-impressao AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "IMPRESSÇO" *}
    ASSIGN c-lbl-liter-impressao = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-arquivo AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Arquivo" *}
    ASSIGN c-lbl-liter-arquivo = TRIM(RETURN-VALUE).
    DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Usu rio" *}
    ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
    PUT UNFORMATTED SKIP(2)
        c-lbl-liter-impressao  AT 3 skip(1)
        c-lbl-liter-arquivo    AT 17 ": " c-destino " - " c-arquivo
        c-lbl-liter-usuario    AT 17 ": " tt-param.usuario.


{include/i-rpclo.i}
RUN pi-finalizar IN h-acomp.

DELETE PROCEDURE h-boaf008. 

RETURN "OK":U.



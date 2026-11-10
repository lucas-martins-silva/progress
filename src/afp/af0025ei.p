
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i AF0025EI 2.00.00.004 } /*** "010004" 31/01/2025 16:02:47  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i af0025ei MAF}
&ENDIF

{utp/ut-glob.i}


DEF VAR c-cod-estabel     AS CHAR NO-UNDO.
def var i-empresa         like empresa.ep-codigo. 
DEF VAR c-chave           AS CHAR    NO-UNDO.
def var v_log_alternativo as logical INITIAL NO no-undo.
def var v_nom_aprov       as char no-undo.
DEF VAR i-chave           AS INTEGER NO-UNDO.
DEF VAR ep-codigo-local   LIKE empresa.ep-codigo NO-UNDO.
DEF VAR desc-moeda        AS CHAR NO-UNDO.
def var h-boad341         as HANDLE    no-undo.
def var h-boad346         as HANDLE    no-undo.
DEF VAR desc-vendedor     AS CHAR NO-UNDO.
DEF VAR desc-forma-pgto   AS CHAR NO-UNDO.
DEF VAR desc-oper         AS CHAR NO-UNDO.
DEF VAR desc-corretor     AS CHAR NO-UNDO.
DEF VAR dt-liquidac       AS CHAR NO-UNDO.
DEF VAR dt-nova           AS DATE NO-UNDO.
DEF VAR v_seq             AS INT NO-UNDO.
/*** Defini?’o da tt-aed-chave ***/
{afp/af0001.i}

/*** Defini?’o da tt-html ***/
{afp/af0030eh.i}

{include/i-epc200.i "AF0025EI"} /*valido para a include, nÆo retirar*/

DEF INPUT PARAMETER p-cod-tip-doc   as integer no-undo.
DEF INPUT PARAMETER p-cod-aprovador as char    no-undo.
DEF INPUT PARAMETER table for tt-aed-chave.
DEF OUTPUT PARAMETER TABLE FOR tt-html.

assign c-chave = "".
find first tt-aed-chave
    no-lock no-error.

FIND FIRST mla-param-aprov 
     WHERE mla-param-aprov.ep-codigo = &IF "{&mguni_version}" >= "2.071" &THEN STRING(tt-aed-chave.valor[10]) &ELSE int(tt-aed-chave.valor[10]) &ENDIF
     AND mla-param-aprov.cod-estabel = tt-aed-chave.valor[1] NO-LOCK NO-ERROR.

ASSIGN c-cod-estabel = tt-aed-chave.valor[1]
       i-empresa     = tt-aed-chave.valor[10].


/***   Monta chave do documento
**/
ASSIGN v_log_alternativo = NO
       v_nom_aprov       = "".


FOR EACH  mla-chave-doc-aprov 
    WHERE mla-chave-doc-aprov.cod-tip-doc = p-cod-tip-doc 
    NO-LOCK:
    assign i-chave = i-chave + 1
           c-chave = c-chave + tt-aed-chave.valor[i-chave] + substring("                    ",1,  
                                        (((mla-chave-doc-aprov.posicao-fim - mla-chave-doc-aprov.posicao-ini) + 1) - length(tt-aed-chave.valor[i-chave]))). 
end.

find first mla-chave-doc-aprov WHERE mla-chave-doc-aprov.cod-tip-doc = p-cod-tip-doc no-lock no-error.
if avail mla-chave-doc-aprov then
    ASSIGN ep-codigo-local = mla-chave-doc-aprov.ep-codigo.
else
    ASSIGN ep-codigo-local = "1".

IF (tt-aed-chave.valor[10]) = "" THEN DO:
    RUN prgfin/apf/apf735za.py (INPUT  tt-aed-chave.valor[1],   /* Estab ems2*/
                               OUTPUT i-empresa). /* Empresa ems2 traduzida pela matriz de tradu?’oo do EMS5 */
    assign tt-aed-chave.valor[10] = string(i-empresa).
    IF  RETURN-VALUE = "nok" THEN
        RETURN "NOK".
END.

ASSIGN c-cod-estabel = tt-aed-chave.valor[1]
       i-empresa     = tt-aed-chave.valor[10].

FIND FIRST mla-param-aprov 
     WHERE mla-param-aprov.ep-codigo = &IF "{&mguni_version}" >= "2.071" &THEN STRING(tt-aed-chave.valor[10]) &ELSE int(tt-aed-chave.valor[10]) &ENDIF
     AND mla-param-aprov.cod-estabel = tt-aed-chave.valor[1] NO-LOCK NO-ERROR.


FIND FIRST mla-tipo-doc-aprov
     WHERE mla-tipo-doc-aprov.ep-codigo   = &IF "{&mguni_version}" >= "2.071" &THEN STRING(tt-aed-chave.valor[10]) &ELSE integer(tt-aed-chave.valor[10]) &ENDIF
       AND mla-tipo-doc-aprov.cod-estabel = tt-aed-chave.valor[1]
       AND mla-tipo-doc-aprov.cod-tip-doc = p-cod-tip-doc NO-LOCK NO-ERROR.


for each mla-doc-pend-aprov no-lock
    WHERE mla-doc-pend-aprov.ep-codigo  = &IF "{&mguni_version}" >= "2.071" &THEN STRING(tt-aed-chave.valor[10]) &ELSE integer(tt-aed-chave.valor[10]) &ENDIF
    AND mla-doc-pend-aprov.cod-estabel  = tt-aed-chave.valor[1]
    AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc 
    AND mla-doc-pend-aprov.chave-doc    = c-chave:
end.

FIND FIRST mla-doc-pend-aprov 
     WHERE mla-doc-pend-aprov.ep-codigo    = &IF "{&mguni_version}" >= "2.071" &THEN STRING(tt-aed-chave.valor[10]) &ELSE integer(tt-aed-chave.valor[10]) &ENDIF 
       AND mla-doc-pend-aprov.cod-estabel  = tt-aed-chave.valor[1]
       AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc 
       AND mla-doc-pend-aprov.chave-doc    = c-chave  
       AND mla-doc-pend-aprov.ind-situacao = 1
       AND mla-doc-pend-aprov.historico    = NO NO-LOCK NO-ERROR. /* pend?ncia atual */

IF NOT AVAIL mla-doc-pend-aprov THEN
    FIND FIRST mla-doc-pend-aprov 
         WHERE mla-doc-pend-aprov.ep-codigo    = &IF "{&mguni_version}" >= "2.071" &THEN STRING(tt-aed-chave.valor[10]) &ELSE integer(tt-aed-chave.valor[10]) &ENDIF 
           AND mla-doc-pend-aprov.cod-estabel  = tt-aed-chave.valor[1]
           AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc 
           AND mla-doc-pend-aprov.chave-doc    = c-chave  
           AND mla-doc-pend-aprov.ind-situacao = 2
           AND mla-doc-pend-aprov.historico    = NO NO-LOCK NO-ERROR. /* pend?ncia atual */

IF  AVAIL mla-doc-pend-aprov THEN DO:
    if  substring(mla-param-aprov.char-2,2,1) = "Y"
    and mla-doc-pend-aprov.cod-usuar <> p-cod-aprovador then do:
        if can-find(first mla-usuar-aprov-altern no-lock
                    where mla-usuar-aprov-altern.cod-usuar = mla-doc-pend-aprov.cod-usuar
                    and   mla-usuar-aprov-altern.validade-ini <= today
                    and   mla-usuar-aprov-altern.validade-fim >= today
                    and   mla-usuar-aprov-altern.cod-usuar-altern = p-cod-aprovador) then do:
                    assign v_log_alternativo = yes.
                    find first usuar_mestre no-lock 
                        where usuar_mestre.cod_usuario = mla-doc-pend-aprov.cod-usuar no-error.
                    if avail usuar_mestre THEN 
                        assign v_nom_aprov = usuar_mestre.nom_usuario.
        end.            
    end.
END.


FIND FIRST contrato-imp
    WHERE  contrato-imp.referencia    = ENTRY(2,mla-doc-pend-aprov.motivo-doc,';':U)
      AND  contrato-imp.dt-referencia = date(ENTRY(3,mla-doc-pend-aprov.motivo-doc,';':U)) 
      AND  contrato-imp.cod-estabel   = tt-aed-chave.valor[1] NO-LOCK NO-ERROR.
IF AVAIL contrato-imp THEN DO:
    FIND FIRST estabelec WHERE estabelec.cod-estabel = contrato-imp.cod-estabel NO-LOCK NO-ERROR.
    
    RUN adbo/boad341.p PERSISTENT SET h-boad341.

    run GetDescFK in h-boad341 (input "moeda":U,
                                input contrato-imp.moeda,
                                output desc-moeda).
    run GetDescFK in h-boad341 (input "banco":U,
                                input contrato-imp.cod-vendedor,
                                output desc-vendedor).
    run GetDescFK in h-boad341 (input "forma-pgto-mec":U,
                                input contrato-imp.cod-forma-pgto-mec,
                                output desc-forma-pgto).
    run GetDescFK in h-boad341 (input "operac-cambio":U,
                                input contrato-imp.cod-oper-cambio,
                                output desc-oper).
    run GetDescFK in h-boad341 (input "emitente":U,
                                input contrato-imp.cod-corretor,
                                output desc-corretor).

    DELETE PROCEDURE h-boad341.

    assign dt-liquidac = string(contrato-imp.dt-contrato + contrato-imp.nr-dias-liquidacao).

    RUN adbo/boad346.p PERSISTENT SET h-boad346.

    run pi-Dia-Util in h-boad346 (input  dt-liquidac,
                                  output dt-nova,
                                  input  contrato-imp.ep-codigo,
                                  input  contrato-imp.cod-estabel,
                                  input  "+").

    DELETE PROCEDURE h-boad346.
	
	CREATE tt-aed-chave.
	ASSIGN tt-aed-chave.valor[1]  = contrato-imp.cod-estabel
		   tt-aed-chave.valor[10]  = String(contrato-imp.ep-codigo)
		   tt-aed-chave.valor[8]  = v_cod_usuar_corren
           tt-aed-chave.valor[9]  = 'MEC' + ";" + contrato-imp.referencia + ";" + String(contrato-imp.dt-referencia)
		   tt-aed-chave.valor[2] = contrato-imp.referencia
		   tt-aed-chave.valor[3] = contrato-imp.referencia
		   tt-aed-chave.valor[6] = String(contrato-imp.vl-contrato)
		   tt-aed-chave.valor[7] = String(contrato-imp.moeda).
    
    CREATE tt-html.
    ASSIGN tt-html.seq-html = 1.
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '<html>' +
    '<head>' +
    '<meta charset="UTF-8">' +
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
    '    .fill-in ~{ ' +
    '     font-family:Tahoma, Arial;font-size:xx-small;font-weight:bold;color:black;background:white; ' +
    '    } ' +
    '    .tableForm ~{ ' +
    '        BORDER-RIGHT: 1px inset; BORDER-TOP: 1px inset; BORDER-LEFT: 1px inset; BORDER-BOTTOM: 1px inset;width:90%  ' +
    '    } ' +
    '    .tableForm2 ~{ ' +
    '        BORDER-width: 0px inset;padding:0;  ' +
    '    } ' +
    '    .barraTitulo ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 8pt; COLOR:white; FONT-FAMILY: Arial; BACKGROUND-COLOR: #6699CC; TEXT-ALIGN: center; vertical-alignment: middle ' +
    '    } ' +
    '    .barraTituloAlter ~{ ' +
    '        FONT-WEIGHT: bold; FONT-SIZE: 8pt; COLOR:white; FONT-FAMILY: Arial; BACKGROUND-COLOR:green; TEXT-ALIGN: center; vertical-alignment: middle ' +
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
    '        COLOR:red;text-decoration:none;  ' +
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
    
    CREATE tt-html.
    ASSIGN tt-html.seq-html = 2.
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '   <meta http-equiv="Cache-Control" content="No-Cache">' +
    '   <meta http-equiv="Pragma"        content="No-Cache">' +
    '   <meta http-equiv="Expires"       content="0">' +
    ' </head>' +
    ' <body topmargin="0" leftmargin="0">'.
    ASSIGN tt-html.html-doc = tt-html.html-doc + '<form method="get" action="' + trim(mla-param-aprov.servidor-asp) + '">'.
                                                                               
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    ' <input class="fill-in" type="hidden" name="hid_param">' +
    ' <input class="fill-in" type="hidden" name="hid_tp_docum" value="' + string(p-cod-tip-doc) + '">' +
    ' <input class="fill-in" type="hidden" name="hid_chave" value="' + replace(c-chave," ","**") + '">' +
    ' <input class="fill-in" type="hidden" name="hid_cod_usuar"  value="' + string(p-cod-aprovador) + '">' +
    ' <input class="fill-in" type="hidden" name="hid_senha"  value="1">' +
    ' <input class="fill-in" type="hidden" name="hid_estabel" value="' + trim(tt-aed-chave.valor[1]) + '"> ' +
    ' <a name="principal"/>' +
    ' <div align="center">' +
    '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' .
    
    
    IF v_log_alternativo THEN 
        ASSIGN tt-html.html-doc = tt-html.html-doc + '<tr><td class="barraTituloAlter">Contrato de Importa‡Æo - Aprovador Alternativo de ' + string(v_nom_aprov,"x(35)") + '</td>'.
    ELSE 
        ASSIGN tt-html.html-doc = tt-html.html-doc + '<tr><td class="barraTitulo">Contrato de Importa‡Æo - Antecipado ' + '</td>'.
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '     </tr>' +
    '    <tr>' +
    '     <td class="linhaForm" align="center">' +
    '      <fieldset>' +
    '      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%">' +
    '        <tr><td height="5"></td></tr>' +
    '          <th align="right" colspan=1 class="linhaForm" nowrap>Estabelecimento:</th> ' +
    '          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="3" name="estab" value="' + STRING(contrato-imp.cod-estabel) + '" readonly>' + 
    '              <input type="text" class="fill-in" size="40" name="desc_estab" value="' + STRING(estabelec.nome) + '" readonly> ' +
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" colspan=1 class="linhaForm" nowrap>Referˆncia:</th> ' +
    '          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="10" name="referencia" value="' + STRING(contrato-imp.referencia) + '" readonly>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" colspan=1 class="linhaForm" nowrap>Data Transa‡Æo:</th> ' +
    '          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="10" name="data_trans" value="' + STRING(contrato-imp.dt-referencia,"99/99/9999") + '" readonly>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" colspan=1 class="linhaForm" nowrap>Valor Total do Contrato:</th> ' +
    '          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
    '              <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">' +
    '                <tr>' +
    '                 <td align=left class="linhaForm">' +
    '                   <input type="text" class="fill-in" size="16" name="tot_mov" value="' + TRIM(STRING(contrato-imp.vl-contrato-me,"->>>,>>>,>>9.99")) + '" readonly>' +
    '                 </td>' +                                                                       
    '                 <td class="linhaForm">' +
    '                   <a href="#detalhe" class="linkOrdena">Detalha Documento</a>' +
    '                 </td>' +
    '                </tr>' + 
    '              </table>' +
    '          </td> ' +
    '         </tr> ' +
    '        <tr><td height="5"></td></tr>' +
    '      </table> ' +  
    '      </fieldset>' + /* silvia */
    '  </td>' +
    ' </tr>' +
    ' </table>'.
    
    {laphtml/mlahtmlrodape.i}

    ASSIGN v_seq = 3.
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +
            ' </div><br>' + 
            '<br><br><br><br><br><br><br><br><br><br><br>' +
            '<br><br><br><br><br><br><br><br><br><br><br>'.
            
    CREATE tt-html.
    ASSIGN tt-html.seq-html = v_seq.
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    ' <a name="detalhe"/>' +
    ' <div align="center">' +
    '   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
    '     <tr>' +
    '       <td class="barratitulo">Detalhe do Documento(Contrato de Importa‡Æo)</td>' +
    '     </tr>' +
    '    <tr>' +
    '     <td class="linhaForm" align="center"><center>'.
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '      <fieldset>' +
    '      <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
    '        <tr><td height="5"></td></tr>' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="14%">Tipo Contrato:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="10" name="contrato" value="' + "Antecipa‡Æo" + '" readonly/>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="13%">Nr Contrato:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="15" name="nrcontrato" value="' + STRING(contrato-imp.nr-contrato) + '" readonly/>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="13%">Dt Contrato:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="15" name="dtcontrato" value="' + STRING(contrato-imp.dt-contrato,"99/99/9999") + '" readonly/>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="13%">Vendedor:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="15" name="vendedor" value="' + STRING(contrato-imp.cod-vendedor) + '" readonly/>' +
    '              <input type="text" class="fill-in" size="30" name="desc_vendedor" value="' + STRING(desc-vendedor) + '" readonly/>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="13%">Situa‡Æo:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="20" name="situacao" value="' + "Pendente Aprova‡Æo" + '" readonly/>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="13%">Moeda:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="15" name="moeda" value="' + STRING(contrato-imp.moeda) + '" readonly/>' +
    '              <input type="text" class="fill-in" size="30" name="desc_moeda" value="' + STRING(desc-moeda) + '" readonly/>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="13%">Cota‡Æo Dia:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="15" name="cotacao_dia" value="' + STRING(contrato-imp.cotacao-dia) + '" readonly/>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="13%">Valor Contrato:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="15" name="vl_contrato" value="' +  TRIM(STRING(contrato-imp.vl-contrato-me,"->>>,>>>,>>9.99")) + '" readonly/>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="13%">Valor Original:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="15" name="vl_original" value="' +  TRIM(STRING(contrato-imp.vl-contrato,"->>>,>>>,>>9.99")) + '" readonly/>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="13%">Forma Entrega Moeda:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="15" name="forma_entrega" value="' + STRING(contrato-imp.cod-forma-pgto-mec) + '" readonly/>' +
    '              <input type="text" class="fill-in" size="30" name="desc_entrega" value="' + STRING(desc-forma-pgto) + '" readonly/>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="13%">Liquida‡Æo:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="15" name="liquidacao" value="' + STRING(dt-nova,"99/99/9999") + '" readonly/>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="13%">Opera‡Æo Cambio:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="30" name="op_cambio" value="' + STRING(contrato-imp.cod-oper-cambio) + '" readonly/>' +
    '              <input type="text" class="fill-in" size="30" name="desc_combio" value="' + STRING(desc-oper) + '" readonly/>' +  
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="13%">Corretor:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="15" name="corretor" value="' + STRING(contrato-imp.cod-corretor) + '" readonly/>' +
    '              <input type="text" class="fill-in" size="30" name="desc_corretor" value="' + STRING(desc-corretor) + '" readonly/>' + 
    '          </td> ' +
    '         </tr> ' +
    '         <tr> ' +
    '          <th align="right" class="linhaForm" nowrap width="13%">Observa‡Æo:</th> ' +
    '          <td align="left" class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="40" name="observacao" value="' + STRING(contrato-imp.observacao) + '" readonly/>' + 
    '          </td> ' +
    '         </tr> ' +
    '      </table>  ' +
    '     </fieldset>' +
    '   </center>' +
    '  </td>' +
    ' </tr>' +
    ' <tr><td class="linhaForm" align="center"><a href="#principal" class="linkOrdena">Voltar</a></td></tr>' +
    ' </table>'.
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '</div>' +
    '<br><br><br><br><br><br><br><br><br><br><br>' +
    '<br><br><br><br><br><br><br><br><br><br><br>'.
    
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '  </form>' +
    ' </body> ' +
    '</html>'.
    
END.

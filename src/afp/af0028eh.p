/**********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*********************************************************************************/
{include/i-prgvrs.i AF0028EH 2.00.00.031 } /*** "010031" 31/01/2025 16:02:47 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i af0028eh MAF}
&ENDIF

{utp/ut-glob.i}
{btb/btb009za.i}
{cdp/cdcfgfin.i}
{include/i_fncrowid.i}

{include/i-epc200.i "AF0028EH"}

def new global shared var v_cod_dwb_user 
    as character 
    format "x(21)":U 
    no-undo. 
def var v_hdl_prog 
    as Handle 
    format ">>>>>>9":U 
    no-undo. 
def new global shared var v_cod_empres_usuar 
    as character 
    format "x(3)":U 
    no-undo. 
def new global shared var v_cod_idiom_usuar 
    as character 
    format "x(8)":U 
    no-undo. 
def new global shared var v_cod_usuar_corren 
    as character 
    format "x(12)":U 
    no-undo. 
def new global shared var v_cod_usuar_corren_criptog 
    as character 
    format "x(16)":U 
    no-undo. 
def new global shared var v5_cod_usuar_corren 
    as character 
    format 'x(12)' 
    no-undo. 
def new global shared var v5_cod_empres_usuar 
    as character 
    format 'x(3)' 
    no-undo. 
def new global shared var v5_cod_estab_usuar 
    as character 
    format 'x(3)' 
    no-undo. 
def new global shared var v5_cod_idiom_usuar 
    as character 
    format 'x(8)' 
    no-undo. 
def new global shared var v5_cod_pais_empres_usuar 
    as character 
    format 'x(3)' 
    no-undo. 
def new global shared var v5_cod_usuar_corren_criptog 
    as character 
    format 'x(16)' 
    no-undo. 
def new global shared var v5_cod_grp_usuar_lst  
    as character  
    no-undo. 
def new global shared var v_cod_pais_empres_usuar 
    as character 
    format "x(3)":U 
    no-undo. 

DEF VAR ep-codigo-local LIKE empresa.ep-codigo NO-UNDO.
DEF VAR c-error         AS CHAR INITIAL "" NO-UNDO.
DEF VAR c-cod-estabel   AS CHAR FORMAT "x(5)" NO-UNDO.

DEFINE VARIABLE c-usuar-mestre AS CHARACTER NO-UNDO.

def var v-row-tt-aed-chave as rowid no-undo.

/*  Login Integrado */
def var v_hdl_login_integr          as handle  no-undo.
def var v_log_habilita_login_integr as logical no-undo.

/* Para n?o pedir senha novamente quando o programa for chamado pelo EMS2 */ 
assign v5_cod_usuar_corren         = v_cod_usuar_corren 
       v5_cod_empres_usuar         = v_cod_empres_usuar 
       /*v5_cod_estab_usuar          = '999' */
       v5_cod_idiom_usuar          = v_cod_idiom_usuar 
       v5_cod_pais_empres_usuar    = v_cod_pais_empres_usuar 
       v5_cod_usuar_corren_criptog = v_cod_usuar_corren_criptog 
       v5_cod_grp_usuar_lst        = v_cod_grp_usuar_lst. 

/*** Defini?’o da tt-aed-chave ***/
{afp/af0001.i}
/*** Defini?’o da tt-html ***/
{afp/af0030eh.i}
/*** Defini?’o da tt_antecip_pef_pend, tt_item_lote_impl_ap, tt_aprop_ctbl_pend_ap ***/
{afp/af0045eh.i}   

/*** Outras includes necessÿrias ***/
{cdp/cdcfgdis.i}

/* Inicio - Colocar este c½digo em comentÿrio para Teste */

{include/i-getentryfield.i}

DEF INPUT PARAMETER p-cod-tip-doc   as integer no-undo.
DEF INPUT PARAMETER p-cod-aprovador as char    no-undo.
DEF INPUT PARAMETER table for tt-aed-chave.
DEF OUTPUT PARAMETER TABLE FOR tt-html.

/* Fim - Colocar este c½digo em comentÿrio para Teste */

DEF VAR h-btb009za        AS HANDLE  NO-UNDO.
DEF VAR c-class           AS CHAR    NO-UNDO.
DEF VAR i-cont            AS INTEGER NO-UNDO.
DEF VAR c-chave           AS CHAR    NO-UNDO.
DEF VAR i-chave           AS INTEGER NO-UNDO.
def var i-empresa         like empresa.ep-codigo. 
DEF VARIABLE v_rec_aprop AS
    &IF {&ROWID_READY} = YES &THEN
        ROWID
    &ELSE
        RECID
    &ENDIF
    NO-UNDO.
def var v_log_alternativo as logical INITIAL NO no-undo.
def var v_nom_aprov   as char no-undo.
def var v_cod_cta_ctbl     like tt_aprop_ctbl_ap.cod_cta_ctbl     no-undo.
def var v_des_cod_cta_ctbl like tt_aprop_ctbl_ap.des_cod_cta_ctbl no-undo.
def var v_cod_ccusto       like tt_aprop_ctbl_ap.cod_ccusto       no-undo.
def var v_des_cod_ccusto   like tt_aprop_ctbl_ap.des_cod_ccusto   no-undo.

assign c-chave = "".
find first tt-aed-chave
    no-lock no-error.


/**   Monta chave do documento
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
ELSE
    ASSIGN ep-codigo-local = "1".

RUN pi-conectar-bco.

IF (tt-aed-chave.valor[10]) = "" THEN DO:
    RUN prgfin/apf/apf735za.py (INPUT  tt-aed-chave.valor[1],   /* Estab ems2*/
                               OUTPUT i-empresa). /* Empresa ems2 traduzida pela matriz de tradu?’oo do EMS5 */
    assign tt-aed-chave.valor[10] = string(i-empresa).
    IF  RETURN-VALUE = "nok" THEN
        RETURN "NOK".
END.



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
    IF  NUM-ENTRIES(mla-doc-pend-aprov.motivo-doc, CHR(10)) > 1 THEN 
        ASSIGN v_rec_aprop = &IF {&ROWID_READY} = YES &THEN 
                                TO-ROWID
                             &ELSE 
                                INT64
                             &ENDIF
                             (GetEntryField(2,mla-doc-pend-aprov.motivo-doc,CHR(10))).
    ELSE 
        ASSIGN v_rec_aprop = &IF {&ROWID_READY} = YES &THEN 
                                ?
                             &ELSE 
                                0
                             &ENDIF.
                             
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
                    if avail usuar_mestre then
                        assign v_nom_aprov = usuar_mestre.nom_usuario.
        end.                   
    end.
END.

RUN prgfin/apf/apf732za.py (INPUT  p-cod-tip-doc,
                           INPUT  c-chave,                      
                           INPUT  v_rec_aprop,
                           OUTPUT TABLE tt_antecip_pef_pend,
                           OUTPUT TABLE tt_item_lote_impl_ap,
                           OUTPUT TABLE tt_aprop_ctbl_pend_ap,
                           OUTPUT TABLE tt_tit_ap,
                           OUTPUT TABLE tt_aprop_ctbl_ap).

/*
** Desconecta as bases do EMS5
*/
RUN pi-tratar-desconexao-bancos IN THIS-PROCEDURE (INPUT h-btb009za).
ASSIGN v_cod_empres_usuar = v5_cod_empres_usuar.

/*{afp/af0035eh.i}*/

IF  c-nom-prog-dpc-mg97  <> ""
OR  c-nom-prog-appc-mg97 <> ""
OR  c-nom-prog-upc-mg97  <> "" THEN DO:

	ASSIGN v-row-tt-aed-chave = ROWID(tt-aed-chave).

	EMPTY TEMP-TABLE tt-epc.
	
	{include/i-epc200.i2 &CodEvent        = "'DetalheDoc'"
						 &CodParameter    = "'Handle-tt-aed-chave'"
						 &ValueParameter  = "string(TEMP-TABLE tt-aed-chave:default-buffer-handle)"}.

	{include/i-epc200.i2 &CodEvent        = "'DetalheDoc'"
						 &CodParameter    = "'Handle_tt_aprop_ctbl_ap'"
						 &ValueParameter  = "string(TEMP-TABLE tt_aprop_ctbl_ap:default-buffer-handle)"}.

	{include/i-epc201.i DetalheDoc}


	IF RETURN-VALUE = "NOK" THEN RETURN.
	
	FIND FIRST tt-epc no-lock
	     WHERE tt-epc.cod-event     = 'DetalheDoc'             
	       AND tt-epc.cod-parameter = 'return_epc' NO-ERROR.
	IF AVAIL tt-epc THEN
		FIND FIRST tt-aed-chave 
		     WHERE ROWID(tt-aed-chave) = v-row-tt-aed-chave NO-ERROR.
END.

FIND FIRST tt_antecip_pef_pend NO-ERROR.
FIND FIRST tt_item_lote_impl_ap NO-ERROR.
FIND FIRST tt_aprop_ctbl_pend_ap NO-ERROR.
FIND FIRST tt_tit_ap NO-ERROR.
FIND FIRST tt_aprop_ctbl_ap NO-ERROR.

 ASSIGN v_cod_cta_ctbl    = ''
        v_des_cod_cta_ctbl = ''
        v_cod_ccusto       = ''
        v_des_cod_ccusto   = ''.
IF AVAIL tt_aprop_ctbl_ap THEN
    ASSIGN v_cod_cta_ctbl     = tt_aprop_ctbl_ap.cod_cta_ctbl
           v_des_cod_cta_ctbl = tt_aprop_ctbl_ap.des_cod_cta_ctbl
           v_cod_ccusto       = tt_aprop_ctbl_ap.cod_ccusto
           v_des_cod_ccusto   = tt_aprop_ctbl_ap.des_cod_ccusto.




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
' <body topmargin="0" leftmargin="0">' +
'<form method="get" action="' + trim(mla-param-aprov.servidor-asp) + '">' +
' <input class="fill-in" type="hidden" name="hid_param">' +
' <input class="fill-in" type="hidden" name="hid_tp_docum" value="' + string(p-cod-tip-doc) + '">' +
' <input class="fill-in" type="hidden" name="hid_chave" value="' + replace(c-chave," ","**") + '">' +
' <input class="fill-in" type="hidden" name="hid_cod_usuar"  value="' + string(p-cod-aprovador) + '">' +
' <input class="fill-in" type="hidden" name="hid_senha"  value="1">' +
' <input class="fill-in" type="hidden" name="hid_estabel" value="' + trim(tt-aed-chave.valor[1]) + '"> ' +
' <a name="principal"/>' +
' <div align="center">' +
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' /*+
'     <tr>'*/.

IF v_log_alternativo THEN 
    ASSIGN tt-html.html-doc = tt-html.html-doc + '<tr><td class="barraTituloAlter">T¡tulo Pagamento - Aprovador Alternativo de ' + string(v_nom_aprov,"x(35)") + '</td>'.
ELSE 
    ASSIGN tt-html.html-doc = tt-html.html-doc + '<tr><td class="barratitulo">T¡tulo Pagamento' + '</td>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +    
'     </tr>' +
'    <tr>' +
'     <td class="linhaForm" align="center">' +
'      <fieldset>' +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%">' +
'        <tr><td height="5"></td></tr>' +
'          <th align="right" colspan=1 class="linhaForm" nowrap>Estabelecimento:</th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="3" name="estab" value="' + STRING(tt_tit_ap.cod_estab) + '" readonly>' + 
'              <input type="text" class="fill-in" size="40" name="desc_estab" value="' + STRING(tt_tit_ap.des_cod_estab) + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" colspan=1 class="linhaForm" nowrap>ID T¡tulo APB:</th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="10" name="num_id_tit_ap" value="' + STRING(tt_tit_ap.num_id_tit_ap) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" colspan=1 class="linhaForm" nowrap>Sequˆncia:</th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="6" name="sequencia" value="' + TRIM(STRING(tt_tit_ap.num_seq_refer,">>>9")) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" colspan=1 class="linhaForm" nowrap>PrevisÆo Pagamento:</th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="10" name="data_trans" value="' + STRING(tt_tit_ap.dat_base,"99/99/9999") + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" colspan=1 class="linhaForm" nowrap>Valor Pagamento:</th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">' +
'                <tr>' +
'                 <td align=left class="linhaForm">' +
'                   <input type="text" class="fill-in" size="16" name="tot_mov" value="' + TRIM(STRING(tt_tit_ap.val_tot_pagamento,"->>>,>>>,>>9.99")) + '" readonly>' +
'                 </td>' + 
'                 <td class="linhaForm">' +
'                   <a href="#detalhe" class="linkOrdena">Detalha Documento</a>' +
'                 </td>' +
'                </tr>' + 
'              </table>' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" colspan=1 class="linhaForm" nowrap>Antecipa‡äes a Abater:</th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="16" name="data_trans" value="' + trim(STRING(tt_tit_ap.val_abat_antecip,"->>>,>>>,>>9.99")) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'        <tr><td height="5"></td></tr>' +
'      </table> ' +  
'      </fieldset>' +
'      <fieldset>' +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%">' +
'        <tr><td height="5"></td></tr>' +
'         <th align="right" class="linhaForm" nowrap>Conta Cont bil:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="20" name="conta_contabil" value="' + STRING(v_cod_cta_ctbl) + '" readonly>' +
'            <input class="fill-in" type="text" size="40" name="desc_conta_contabil" value="' + STRING(v_des_cod_cta_ctbl) + '" readonly>' +
'         </td>' +
'        </tr>' +
'         <th align="right" class="linhaForm" nowrap>Centro de Custo:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="10" name="centro_custo" value="' + STRING(v_cod_ccusto) + '" readonly>' +
'            <input class="fill-in" type="text" size="40" name="desc_centro_custo" value="' + STRING(v_des_cod_ccusto) + '" readonly>' +
'         </td>' +
'        </tr>' +
'        <tr> ' +
'          <th align="right" class="linhaForm" nowrap>Moeda:</th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'             <input type="text" class="fill-in" size="15" name="moeda" value="' + STRING(tt_tit_ap.cod_indic_econ) + '" readonly>' + 
'          </td> ' +
'        </tr> ' +
'         <th align="right" class="linhaForm" nowrap>Valor a aprovar:</th>' +
'         <td class="linhaForm" align="left" nowrap> ' +
'            <input class="fill-in" type="text" size="20" name="valor_aprop_ctbl" value="' + TRIM(STRING(mla-doc-pend-aprov.valor-doc,"->>>,>>>,>>9.99")) + '" readonly>' +
'         </td>' +
'        </tr>' +
'        <tr><td height="5"></td></tr>' +
'      </table>  ' +
/* Início (IPP - Mostrar Motivo de Alteração na Aprovação Financeira)
Enviar um histórico na solicitação de aprovação de pagamento, ou seja, liberação do valor do AVMA */
&if defined(BF_FIN_MOSTRA_HISTOR_APF) &then
'            <tr> ' +
'            <td align="right" colspan="0" class="linhaForm" nowrap> ' +
'              <fieldset>' +
'                <legend>Hist¢rico Altera‡Æo</legend>' +
'                <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'                 <tr>' +
'                  <td valign="midlle" align=center>' +
'                    <textarea class="fill-in" name="historico_alter" rows="4" cols="110" readonly>' + replace(STRING(tt_tit_ap.des_histor_alter),chr(10), ' ')  + '</textarea>' +
'                  </td>' + 
'                 </tr> ' +
'                 <tr><td height="5"></td></tr>' +
'                </table> ' +  
'              </fieldset>' +
'            </td> ' +
'            </tr> ' +
&endif
/* Fim (IPP - Mostrar Motivo de Alteração na Aprovação Financeira) */
'     </fieldset>' +
'  </td>' +
' </tr>' +
' </table>' +
' <table border=0> <tr><td>'.

ASSIGN c-cod-estabel = tt-aed-chave.valor[1]
       i-empresa     = tt-aed-chave.valor[10].
{laphtml/mlahtmlrodape.i}

ASSIGN tt-html.html-doc = tt-html.html-doc +
        ' </div><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>'.

CREATE tt-html.
ASSIGN tt-html.seq-html = 3.
ASSIGN tt-html.html-doc = tt-html.html-doc +
' <a name="detalhe"/>' +
' <div align="center"><center>' +
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
'     <tr>' +
'       <td class="barratitulo">Detalhe do Documento(T¡tulo)</td>' +
'     </tr>' +
'    <tr>' +
'     <td class="linhaForm" align="center"><center>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'      <fieldset>' +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'        <tr><td height="5"></td></tr>' +
'         <tr> ' +
'          <td align="center" valign="top" class="linhaForm" nowrap colspan=2> ' +
'      <fieldset>' +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'       <tr><td height="5"></td></tr>' +
'       <tr>' +
'         <th align="right" class="linhaForm" nowrap width="15%">Fornecedor:</th> ' +
'         <td align="left" class="linhaForm" nowrap width="30%"> ' +
'             <input type="text" class="fill-in" size="25" name="fornecedor" value="' + STRING(tt_tit_ap.cdn_fornecedor) + '" readonly>' + 
'             <input type="text" class="fill-in" size="50" name="desc_fornecedor" value="' + STRING(tt_tit_ap.des_razao_social) + '" readonly>' + 
'         </td> ' +
'       </tr>' +
'       <tr>' +
'         <th align="right" class="linhaForm" nowrap>Pa¡s:</th> ' +
'         <td align="left" colspan=2 class="linhaForm" nowrap> ' +
'             <input type="text" class="fill-in" size="10" name="pais" value="' + STRING(tt_tit_ap.cod_pais) + '" readonly>' + 
'             <input type="text" class="fill-in" size="30" name="desc_pais" value="' + STRING(tt_tit_ap.des_cod_pais) + '" readonly>' + 
'         </td> ' +
'       </tr> ' +
'       <tr><td height="5"></td></tr>' +
'      </table> ' +  
'      </fieldset>' +
'      </td>' +
'      </tr>' + 
'         <tr> ' +
'          <td align="center" valign="top" class="linhaForm" nowrap> ' +
'           <fieldset>' +
'           <legend>T¡tulo</legend>' +
'           <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'             <tr> ' +
'              <th align="right" class="linhaForm" nowrap>Esp‚cie:</th> ' +
'              <td align="left" class="linhaForm" nowrap> ' +
'                  <input type="text" class="fill-in" size="5" name="especie" value="' + STRING(tt_tit_ap.cod_espec_docto) + '" readonly>' + 
'              </td> ' +
'             </tr> ' +
'             <tr> ' +
'              <th align="right" class="linhaForm" nowrap>S‚rie:</th> ' +
'              <td align="left" class="linhaForm" nowrap> ' +
'                  <input type="text" class="fill-in" size="5" name="serie" value="' + STRING(tt_tit_ap.cod_ser_docto) + '" readonly>' + 
'              </td> ' +
'             </tr> ' +
'             <tr> ' +
'              <th align="right" class="linhaForm" nowrap>T¡tulo:</th> ' +
'              <td align="left" class="linhaForm" nowrap> ' +
'                  <input type="text" class="fill-in" size="20" name="titulo_1" value="' + STRING(tt_tit_ap.cod_tit_ap) + '" readonly>' + 
'                  <input type="text" class="fill-in" size="4" name="parcela" value="' + STRING(tt_tit_ap.cod_parcela) + '" readonly>' + 
'              </td> ' +
'             </tr> ' +
'             <tr> ' +
'              <th align="right" class="linhaForm" nowrap>Saldo:</th> ' +
'              <td align="left" class="linhaForm" nowrap> ' +
'                  <input type="text" class="fill-in" size="25" name="valor" value="' + trim(STRING(tt_tit_ap.val_sdo_tit_ap,"->>>,>>>,>>9.99")) + '" readonly>' + 
'              </td> ' +
'             </tr> ' +
'           </table>' +
'           </fieldset>' +  
'           <fieldset>' +
'           <legend>Pagamento</legend>' +
'           <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'             <tr> ' +
'               <th align="right" class="linhaForm" nowrap>Moeda:</th> ' +
'               <td align="left" class="linhaForm" nowrap> ' +
'                  <input type="text" class="fill-in" size="15" name="moeda" value="' + STRING(tt_tit_ap.cod_indic_econ_tit) + '" readonly>' + 
'               </td> ' +
'             </tr> ' +
'             <tr> ' +
'              <th align="right" class="linhaForm" nowrap>Portador:</th> ' +
'              <td align="left" class="linhaForm" nowrap> ' +
'                  <input type="text" class="fill-in" size="15" name="portador" value="' + STRING(tt_tit_ap.cod_portador) + '" readonly>' + 
'              </td> ' +
'             </tr> ' +
'             <tr><td height="5"></td></tr>' +
'           </table>' +
'           </fieldset>' +  
'          </td>' +
'          <td align="center" valign="top" class="linhaForm" nowrap> ' +
'           <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'            <tr>' +
'             <td align="center" valign="middle" class="linhaForm" nowrap> ' +
'              <fieldset>' +
'              <legend>Datas</legend>' +
'              <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'                <tr> ' +
'                 <th align="right" class="linhaForm" nowrap>EmissÆo:</th> ' +
'                 <td align="left" class="linhaForm" nowrap> '.
IF tt_tit_ap.dat_emis_docto <> ? THEN
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '                     <input type="text" class="fill-in" size="12" name="emissao" value="' + STRING(tt_tit_ap.dat_emis_docto,"99/99/9999") + '" readonly>'.
ELSE
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '                     <input type="text" class="fill-in" size="12" name="emissao" value="' + STRING("") + '" readonly>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'                 </td> ' +
'                 <th align="right" class="linhaForm" nowrap>Prev Pagto:</th> ' +
'                 <td align="left" class="linhaForm" nowrap> '.

IF tt_tit_ap.dat_prev_pagto <> ? THEN
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '                     <input type="text" class="fill-in" size="12" name="prev_pagto" value="' + STRING(tt_tit_ap.dat_prev_pagto,"99/99/9999") + '" readonly>'.
ELSE
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '                     <input type="text" class="fill-in" size="12" name="prev_pagto" value="' + STRING("") + '" readonly>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'                 </td> ' +
'                </tr> ' +
'                <tr><td height="5"></td></tr>' +
'                <tr> ' +
'                 <th align="right" class="linhaForm" nowrap>Vencimento:</th> ' +
'                 <td align="left" class="linhaForm" nowrap> '.
IF tt_tit_ap.dat_vencto_tit_ap <> ? THEN
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '                     <input type="text" class="fill-in" size="12" name="vencimeno" value="' + STRING(tt_tit_ap.dat_vencto_tit_ap,"99/99/9999") + '" readonly>'.
ELSE
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '                     <input type="text" class="fill-in" size="12" name="vencimeno" value="' + STRING("") + '" readonly>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'                 </td> ' +
'                 <th align="right" class="linhaForm" nowrap>Desconto:</th> ' +
'                 <td align="left" class="linhaForm" nowrap> '.

IF tt_tit_ap.dat_desconto <> ? THEN
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '                     <input type="text" class="fill-in" size="12" name="data" value="' + STRING(tt_tit_ap.dat_desconto,"99/99/9999") + '" readonly>'.
ELSE
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '                     <input type="text" class="fill-in" size="12" name="data" value="' + STRING("") + '" readonly>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'                 </td> ' +
'                </tr> ' +
'                <tr><td height="5"></td></tr>' +
'              </table>' +
'              </fieldset>' +  
'             </td>' +
'            </tr>' +
'            <tr>' +
'             <td align="center" valign="middle" colspan="3" class="linhaForm" nowrap> ' +
'              <fieldset>' +
'              <legend>Despesa Financeira</legend>' +
'              <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'                <tr><td height="14"></td></tr>' +
'                <tr> ' +
'                 <td align="center" valign="middle" class="linhaForm" nowrap> ' +
'                  <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'                   <tr> ' +
'                     <th align="right" class="linhaForm" nowrap>Juros:</th> ' +
'                     <td align="left" class="linhaForm" nowrap> ' +
'                        <input type="text" class="fill-in" size="15" name="vl_juros" value="' + TRIM(STRING(tt_tit_ap.val_juros,"->>>,>>>,>>9.99")) + '" readonly>' + 
'                     </td> ' +
'                     <th align="right" class="linhaForm" nowrap>Desconto:</th> ' +
'                     <td align="left" class="linhaForm" nowrap> ' +
'                       <input type="text" class="fill-in" size="15" name="perc" value="' + trim(STRING(tt_tit_ap.val_desconto,"->>>,>>>,>>9.99")) + '" readonly>' + 
'                     </td> ' +
'                   </tr> ' + 
'                   <tr> ' +
'                    <th align="right" class="linhaForm" nowrap>Multa:</th> ' +
'                    <td align="left" class="linhaForm" nowrap> ' +
'                        <input type="text" class="fill-in" size="15" name="multa_atr" value="' + TRIM(STRING(tt_tit_ap.val_multa_tit_ap,"->>>,>>>,>>9.99")) + '" readonly>' + 
'                    </td> ' +
'                    <th align="right" class="linhaForm" nowrap>Abatimento:</th> ' +
'                    <td align="left" class="linhaForm" nowrap> ' +
'                        <input type="text" class="fill-in" size="15" name="multa_atr" value="' + TRIM(STRING(tt_tit_ap.val_abat_tit_ap,"->>>,>>>,>>9.99")) + '" readonly>' + 
'                    </td> ' +
'                   </tr> ' + 
'                  </table>' +
'                 </td> ' +
'                </tr> ' +
'                <tr><td height="15"></td></tr>' +
'              </table>' +
'              </fieldset>' +  
'             </td>' +
'            </tr>' +
'           </table>' +
'          </td>' +
'        </tr>' +
'      </table>  ' +
'     </fieldset>' +
'   </center>' +
'  </td>' +
' </tr>' +
'            <tr> ' +     /*Modifica?’o Walter */
'            <td align="left" colspan="0" class="linhaForm" nowrap> ' +
'              <fieldset>' +
'                <legend>Hist¢rico</legend>' +
'                <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'                 <tr>' +
'                  <td valign="midlle" align=center>' +
'                    <textarea class="fill-in" name="historico" rows="4" cols="110" readonly>' + replace(STRING(tt_tit_ap.des_historico),chr(10), ' ') + '</textarea>' +
'                  </td>' + 
'                 </tr> ' +
'                 <tr><td height="5"></td></tr>' +
'                </table> ' +  
'              </fieldset>' +
'            </td> ' +
'            </tr> ' +
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


/*
OUTPUT TO c:~\tmp~\aedhtml024e.htm.
FOR EACH  tt-html:
    PUT tt-html.html-doc.
END.
OUTPUT CLOSE.
DOS SILENT VALUE("explorer c:~\tmp~\aedhtml024e.htm.").
*/

PROCEDURE pi-conectar-bco:
    /****************************************************************************************************
    BEG - Tecnologia:
    Executa o programa de conex?o de bancos externos somente se o mesmo n?o estiver na mem«ria,
    ou seja, se o mesmo ainda n?o foi executado. E tambým se os bancos do EMS 5 ainda n?o estiverem
    conectado.
    ****************************************************************************************************/
    IF  (       NOT VALID-HANDLE(h-btb009za)
                OR  h-btb009za:TYPE <> "procedure":U
                OR  h-btb009za:FILE-NAME <> "btb/btb009za.p")
    AND (       NOT CONNECTED('emsbas':U)
                OR  NOT CONNECTED('emsuni':U)
                OR  NOT CONNECTED('emsfin':U))  THEN DO:

        RUN btb/btb009za.p PERSISTENT SET h-btb009za.

        RUN pi-conecta-bco IN h-btb009za (  INPUT 1,
                                            INPUT 1, /* Conecta o DB */
                                            INPUT ep-codigo-local,
                                            INPUT "all",
                                            OUTPUT TABLE tt_erros_conexao).

        IF  RETURN-VALUE <> "OK" THEN DO:
            run utp/ut0666.w (input table tt_erros_conexao).
            RUN pi-tratar-desconexao-bancos IN THIS-PROCEDURE (INPUT h-btb009za).
            return 'adm-error'.
        end.
    END.
    /****************************************************************************************************
    END - Tecnologia:
    ****************************************************************************************************/
END.

PROCEDURE pi-desconeta-base:
    DEFINE INPUT PARAMETER h-btb009za  AS HANDLE.

    run pi-conecta-bco in h-btb009za (INPUT 1,
                                      INPUT 2, /* Desconecta o DB */
                                      INPUT ep-codigo-local,
                                      INPUT "all",
                                      OUTPUT Table tt_erros_conexao).

END PROCEDURE.

PROCEDURE pi-tratar-desconexao-bancos:
    DEFINE INPUT PARAMETER h-btb009za  AS HANDLE. 

    IF  VALID-HANDLE(h-btb009za)
    AND h-btb009za:TYPE = "procedure":U
    AND h-btb009za:FILE-NAME = "btb/btb009za.p"
    THEN do:
        RUN pi-desconeta-base IN THIS-PROCEDURE (INPUT h-btb009za).
        DELETE PROCEDURE h-btb009za.
    end.

END PROCEDURE.

/*****************************************************************************
** Procedure.: pi_login_integr_habilitado
** Fun‡Æo....: Retorna se a funcionalidade do login integrado est  habilitada
*****************************************************************************/
procedure pi_login_integr_habilitado:
    
    def output param ploginintegrhabilit as logical initial no.
    
    &if  "{&mginv_version}" = "2.06b" &then
        find first login-integr-so no-lock no-error.
        assign ploginintegrhabilit = (avail login-integr-so 
                                      and login-integr-so.log-habtdo-login-integr).
    &endif
   
end procedure. /* --- pi_login_integr_habilitado - */

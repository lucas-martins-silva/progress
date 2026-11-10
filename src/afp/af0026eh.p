/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i AF0026EH 2.00.00.032 } /*** "010032" 31/01/2025 16:02:47 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i af0026eh MAF}
&ENDIF

{utp/ut-glob.i}
{btb/btb009za.i}
{include/i_fncrowid.i}

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
DEF VAR v_seq           AS INT NO-UNDO.
DEF VAR c-cod-estabel   AS CHAR NO-UNDO.

DEFINE VARIABLE c-usuar-mestre AS CHARACTER NO-UNDO.

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
{include/i_dbvers.i}
/* Inicio - Colocar este c¢digo em comentÿrio para Teste */

{include/i-getentryfield.i}


{include/i-epc200.i "AF0026EH"} /*valido para a include, nÆo retirar*/
DEF INPUT PARAMETER p-cod-tip-doc   as integer no-undo.
DEF INPUT PARAMETER p-cod-aprovador as char    no-undo.
DEF INPUT PARAMETER table for tt-aed-chave.
DEF OUTPUT PARAMETER TABLE FOR tt-html.

/* Fim - Colocar este c¢digo em comentÿrio para Teste */

&IF  "{&mginv_version}" >= "2.06B" &THEN

/********* In­cio - C¢digo para teste  *******
DEF VAR p-cod-tip-doc   as integer no-undo.
DEF VAR p-cod-aprovador as char    no-undo.

/* Defini?’o da tt-html que gera o html */
/*DEF TEMP-TABLE tt-html NO-UNDO
    FIELD html-doc     AS CHAR FORMAT "x(31500)"
    FIELD seq-html     AS INT.*/

CREATE tt-aed-chave.
ASSIGN tt-aed-chave.valor[1] = "1"
       tt-aed-chave.valor[2] = "020812Aqnz".

ASSIGN p-cod-tip-doc   = 26
       p-cod-aprovador = "aed".

********** Fim - C¢digo para teste  **********/

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

find first mla-chave-doc-aprov 
    WHERE mla-chave-doc-aprov.cod-tip-doc = p-cod-tip-doc no-lock no-error.
if avail mla-chave-doc-aprov then
    ASSIGN ep-codigo-local = mla-chave-doc-aprov.ep-codigo.
else
    assign ep-codigo-local = "1".

RUN pi-conectar-bco.

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
                    if avail usuar_mestre THEN 
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

FIND FIRST tt_antecip_pef_pend NO-ERROR.
FIND FIRST tt_item_lote_impl_ap NO-ERROR.

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
    ASSIGN tt-html.html-doc = tt-html.html-doc + '<tr><td class="barraTituloAlter">PEF - Aprovador Alternativo de ' + string(v_nom_aprov,"x(35)") + '</td>'.
ELSE 
    ASSIGN tt-html.html-doc = tt-html.html-doc + '<tr><td class="barraTitulo">PEF' + '</td>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'     </tr>' +
'    <tr>' +
'     <td class="linhaForm" align="center">' +
'      <fieldset>' +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%">' +
'        <tr><td height="5"></td></tr>' +
'          <th align="right" colspan=1 class="linhaForm" nowrap>Estabelecimento:</th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="3" name="estab" value="' + STRING(tt_antecip_pef_pend.cod_estab) + '" readonly>' + 
'              <input type="text" class="fill-in" size="40" name="desc_estab" value="' + STRING(tt_antecip_pef_pend.des_cod_estab) + '" readonly> ' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" colspan="1" class="linhaForm" nowrap>Referˆncia:</th> ' +
'          <td align="left" colspan="3" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="10" name="referencia" value="' + STRING(tt_antecip_pef_pend.cod_refer) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" colspan="1" class="linhaForm" nowrap>Data Transa‡Æo:</th> ' +
'          <td align="left" colspan="3" class="linhaForm" nowrap> '.

IF tt_antecip_pef_pend.dat_emis_docto <> ? THEN
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '              <input type="text" class="fill-in" size="10" name="data_trans" value="' + STRING(tt_antecip_pef_pend.dat_emis_docto,"99/99/9999") + '" readonly>'.
ELSE
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '              <input type="text" class="fill-in" size="10" name="data_trans" value="' + STRING("") + '" readonly>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" colspan=1 class="linhaForm" nowrap>Valor Total do T¡tulo:</th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">' +
'                <tr>' +
'                 <td align=left class="linhaForm">' +
'                   <input type="text" class="fill-in" size="16" name="tot_mov" value="' + TRIM(STRING(tt_antecip_pef_pend.val_tit_ap,"->>>,>>>,>>9.99")) + '" readonly>' +
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
'      </fieldset>' 
.

ASSIGN v_seq = 3.

FOR EACH tt_aprop_ctbl_pend_ap:

    CREATE tt-html.
    ASSIGN tt-html.seq-html = v_seq.
ASSIGN tt-html.html-doc = 
'      <fieldset>' +
    '      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%">' +
    '        <tr><td height="5"></td></tr>' +
    '         <tr> ' +
    '          <th align="right" colspan=1 class="linhaForm" nowrap>Tipo Fluxo:</th> ' +
    '          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
    '              <input type="text" class="fill-in" size="12" name="tipo_fluxo" value="' + STRING(tt_aprop_ctbl_pend_ap.cod_tip_fluxo_financ) + '" readonly>' + 
    '              <input type="text" class="fill-in" size="40" name="desc_tipo_fluxo" value="' + STRING(tt_aprop_ctbl_pend_ap.des_cod_tip_fluxo_financ) + '" readonly> ' +
    '          </td> ' +
    '        </tr> ' +
    '        <tr>' +
    '         <th align="right" class="linhaForm" nowrap width="27%">Plano Contas:</th>' +
    '         <td class="linhaForm" align="left" nowrap>' +
    '            <input class="fill-in" type="text" size="8" name="plano_contas" value="' + STRING(tt_aprop_ctbl_pend_ap.cod_plano_cta_ctbl) + '" readonly>' +
    '            <input class="fill-in" type="text" size="40" name="desc_plano_contas" value="' + STRING(tt_aprop_ctbl_pend_ap.des_cod_plano_cta_ctbl) + '" readonly>' +
    '         </td>' +
    '        </tr> ' +
    '        <tr>' +
    '         <th align="right" class="linhaForm" nowrap>Conta Cont bil:</th>' +
    '         <td class="linhaForm" align="left" nowrap>' +
    '            <input class="fill-in" type="text" size="20" name="conta_contabil" value="' + STRING(tt_aprop_ctbl_pend_ap.cod_cta_ctbl) + '" readonly>' +
    '            <input class="fill-in" type="text" size="40" name="desc_conta_contabil" value="' + STRING(tt_aprop_ctbl_pend_ap.des_cod_cta_ctbl) + '" readonly>' +
    '         </td>' +                                                                                                                         
    '        </tr>' +
    '        <tr>' +
    '         <th align="right" class="linhaForm" nowrap>Unid Neg¢cio:</th>' +
    '         <td class="linhaForm" align="left" nowrap>' +
    '            <input class="fill-in" type="text" size="5" name="unid_negocio" value="' + STRING(tt_aprop_ctbl_pend_ap.cod_unid_negoc) + '" readonly>' +
    '            <input class="fill-in" type="text" size="40" name="desc_unid_negocio" value="' + STRING(tt_aprop_ctbl_pend_ap.des_cod_unid_negoc) + '" readonly>' +
    '         </td>' +
    '        </tr>' +
    '        <tr>' +
    '         <th align="right" class="linhaForm" nowrap>Plano CCentro:</th>' +
    '         <td class="linhaForm" align="left" nowrap>' +
    '            <input class="fill-in" type="text" size="8" name="plano_custo" value="' + STRING(tt_aprop_ctbl_pend_ap.cod_plano_ccusto) + '" readonly>' +
    '            <input class="fill-in" type="text" size="40" name="desc_plano_custo" value="' + STRING(tt_aprop_ctbl_pend_ap.des_cod_plano_ccusto) + '" readonly>' +
    '         </td>' +
    '        </tr>' +
    '        <tr>' +
    '         <th align="right" class="linhaForm" nowrap>Centro Custo:</th>' +
    '         <td class="linhaForm" align="left" nowrap>' +
    '            <input class="fill-in" type="text" size="10" name="centro_custo" value="' + STRING(tt_aprop_ctbl_pend_ap.cod_ccusto) + '" readonly>' +
    '            <input class="fill-in" type="text" size="40" name="desc_centro_custo" value="' + STRING(tt_aprop_ctbl_pend_ap.des_cod_ccusto) + '" readonly>' +
    '         </td>' +
    '        </tr>' +
    '         <th align="right" class="linhaForm" nowrap>Valor a aprovar:</th>' +
    '         <td class="linhaForm" align="left" nowrap> ' +
    '            <input class="fill-in" type="text" size="20" name="valor_aprop_ctbl" value="' + TRIM(STRING(tt_aprop_ctbl_pend_ap.val_aprop_ctbl,"->>>,>>>,>>9.99")) + '" readonly>' +
    '         </td>' +
    '        </tr>' +
    '        <tr><td height="5"></td></tr>' +
    '      </table>  '.
    ASSIGN v_seq = v_seq + 1.
END.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'     </fieldset>' +
'   </center>'.
'  </td>' +
' </tr>' +
' </table>' +
' <table border=0> <tr><td>'.

{laphtml/mlahtmlrodape.i}


ASSIGN tt-html.html-doc = tt-html.html-doc +
        ' </div><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>' +
'<br><br><br><br><br><br><br><br><br><br><br>'.

CREATE tt-html.
ASSIGN tt-html.seq-html = v_seq.
ASSIGN tt-html.html-doc = tt-html.html-doc +
' <a name="detalhe"/>' +
' <div align="center"><center>' +
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
'     <tr>' +
'       <td class="barratitulo">Detalhe do Documento(PEF)</td>' +
'     </tr>' +
'    <tr>' +
'     <td class="linhaForm" align="center"><center>' +
'      <fieldset>' +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'       <tr><td height="5"></td></tr>' +
'       <tr>' +
'         <th align="right" class="linhaForm" nowrap width="15%">Fornecedor:</th> ' +
'         <td align="left" class="linhaForm" nowrap width="30%" colspan=3> ' +
'             <input type="text" class="fill-in" size="25" name="fornecedor" value="' + STRING(tt_antecip_pef_pend.cdn_fornecedor) + '" readonly>' + 
'             <input type="text" class="fill-in" size="10" name="desc_fornecedor" value="' + STRING(tt_antecip_pef_pend.des_cdn_fornecedor) + '" readonly>' + 
'         </td> ' +
'         <th align="right" class="linhaForm" nowrap>Pa¡s:</th> ' +
'         <td align="left" colspan=2 class="linhaForm" nowrap> ' +
'             <input type="text" class="fill-in" size="10" name="pais" value="' + STRING(tt_antecip_pef_pend.cod_pais) + '" readonly>' + 
'             <input type="text" class="fill-in" size="30" name="desc_pais" value="' + STRING(tt_antecip_pef_pend.des_cod_pais) + '" readonly>' + 
'         </td> ' +
'       </tr> ' +
'       <tr>' +
'         <th align="right" class="linhaForm" nowrap>Esp‚cie:</th> ' +
'         <td align="left" class="linhaForm" nowrap width="19%"> ' +
'             <input type="text" class="fill-in" size="5" name="especie" value="' + STRING(tt_antecip_pef_pend.cod_espec_docto) + '" readonly>' + 
'         </td> ' +
'         <th align="right" class="linhaForm" nowrap>S‚rie:</th> ' +
'         <td align="left" class="linhaForm" nowrap> ' +
'             <input type="text" class="fill-in" size="5" name="serie" value="' + STRING(tt_antecip_pef_pend.cod_ser_docto) + '" readonly>' + 
'         </td> ' +
'         <th align="right" class="linhaForm" nowrap>T¡tulo:</th> ' +
'         <td align="left" class="linhaForm" nowrap> ' +
'             <input type="text" class="fill-in" size="16" name="titulo_1" value="' + STRING(tt_antecip_pef_pend.cod_tit_ap) + '" readonly>' + 
'             <input type="text" class="fill-in" size="5" name="parcela" value="' + STRING(tt_antecip_pef_pend.cod_parcela) + '" readonly>' + 
'         </td> ' +
'       </tr> ' +
'       <tr><td height="5"></td></tr>' +
'      </table> ' +  
'      </fieldset>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'      <fieldset>' +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'        <tr><td height="5"></td></tr>' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap>EmissÆo:</th> ' +
'          <td align="left" class="linhaForm" nowrap> '.

IF tt_antecip_pef_pend.dat_emis_docto <> ? THEN
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '              <input type="text" class="fill-in" size="12" name="emissao" value="' + STRING(tt_antecip_pef_pend.dat_emis_docto,"99/99/9999") + '" readonly>'.
ELSE
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '              <input type="text" class="fill-in" size="12" name="emissao" value="' + STRING("") + '" readonly>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'          </td> ' +
'          <th align="right" class="linhaForm" nowrap width="13%">Moeda:</th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="15" name="moeda" value="' + STRING(tt_antecip_pef_pend.cod_indic_econ) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap>Vencimento:</th> ' +
'          <td align="left" class="linhaForm" nowrap> '.

IF tt_antecip_pef_pend.dat_vencto_tit_ap <> ? THEN
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '              <input type="text" class="fill-in" size="12" name="data_vencimento" value="' + STRING(tt_antecip_pef_pend.dat_vencto_tit_ap,"99/99/9999") + '" readonly>'.
ELSE
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '              <input type="text" class="fill-in" size="12" name="data_vencimento" value="' + STRING("") + '" readonly>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'          </td> ' +
'          <th align="right" class="linhaForm" nowrap>Cota‡Æo:</th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="25" name="cotacao" value="' + TRIM(STRING(tt_antecip_pef_pend.val_cotac_indic_econ,">>>>,>>9.9999999999")) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap width="14%">Portador:</th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="10" name="portador" value="' + STRING(tt_antecip_pef_pend.cod_portador) + '" readonly>' + 
'          </td> ' +
'          <th align="right" class="linhaForm" nowrap>Cota‡Æo Inversa:</th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="25" name="cotac_inv" value="' + TRIM(STRING(tt_antecip_pef_pend.val_cotac_indic_invers,">>>>,>>9.9999999999")) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap>&nbsp;</th> ' +
'          <td align="left" class="linhaForm" nowrap>&nbsp;</td> ' +
'          <th align="right" class="linhaForm" nowrap>Valor T¡tulo:</th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="20" name="valor_titulo" value="' + TRIM(STRING(tt_antecip_pef_pend.val_tit_ap,"->>>,>>>,>>9.99")) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap>&nbsp;</th> ' +
'          <td align="left" class="linhaForm" nowrap>&nbsp;</td> ' +
'          <td align="right" class="linhaForm" nowrap>&nbsp;</td> ' +
'          <td align="left" class="linhaForm" nowrap>'.

IF tt_antecip_pef_pend.log_incid_despes_bcia = YES THEN
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '            <input type="checkbox" name="incide" value="" disabled checked>'.
ELSE
    ASSIGN tt-html.html-doc = tt-html.html-doc +
    '            <input type="checkbox" name="incide" value="" disabled>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'              Incide Despesa Banc ria' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap>&nbsp;</th> ' +
'          <td align="left" class="linhaForm" nowrap>&nbsp;</td> ' +
'          <th align="right" class="linhaForm" nowrap>Natureza:</th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'             <input type="text" class="fill-in" size="20" name="natureza" value="' + STRING(tt_antecip_pef_pend.ind_natur_cta_ctbl) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <td align="center" colspan="5" class="linhaForm" nowrap> ' +
'              <fieldset>' +
'              <legend>Pagamento</legend>' +
'              <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'               <tr><td height="5"></td></tr>' +
'               <tr>' +
'                 <th align="right" class="linhaForm" nowrap>Modo Pagto:</th> ' +
'                 <td align="left" class="linhaForm" nowrap width="30%"> ' +
'                     <input type="text" class="fill-in" size="10" name="modo_pagto" value="' + STRING(tt_antecip_pef_pend.ind_modo_pagto) + '" readonly>' + 
'                 </td> ' +
'                 <th align="right" class="linhaForm" nowrap width="10%">Forma Pagto:</th> ' +
'                 <td align="left" class="linhaForm" nowrap> ' +
'                     <input type="text" class="fill-in" size="5" name="forma_pagto" value="' + STRING(tt_antecip_pef_pend.cod_forma_pagto) + '" readonly>' + 
'                 </td> ' +
'               </tr> ' +
'               <tr>' +
'                 <th align="right" class="linhaForm" nowrap>Talon rio:</th> ' +
'                 <td align="left" class="linhaForm" nowrap> ' +
'                     <input type="text" class="fill-in" size="15" name="talonario" value="' + STRING(tt_antecip_pef_pend.num_talon_cheq) + '" readonly>' + 
'                 </td> ' +
'                 <th align="right" class="linhaForm" nowrap>Favorecido:</th> ' +
'                 <td align="left" class="linhaForm" nowrap> ' +
'                     <input type="text" class="fill-in" size="20" name="favorecido" value="' + STRING(tt_antecip_pef_pend.ind_favorec_cheq) + '" readonly>' + 
'                 </td> ' +
'               </tr> ' +
'               <tr>' +
'                 <th align="right" class="linhaForm" nowrap>Num Cheque:</th> ' +
'                 <td align="left" class="linhaForm" nowrap> ' +
'                     <input type="text" class="fill-in" size="15" name="num_cheque" value="' + STRING(tt_antecip_pef_pend.num_cheque) + '" readonly>' + 
'                 </td> ' +
'                 <th align="right" class="linhaForm" nowrap>&nbsp;</th> ' +
'                 <td align="left" class="linhaForm" nowrap>' +
'                     <input type="text" class="fill-in" size="50" name="nomefavorecido" value="' + STRING(tt_antecip_pef_pend.nom_favorec_cheq) + '" readonly>' + 
'                 </td> ' +
'               </tr> ' +
'               <tr><td height="5"></td></tr>' +
'              </table> ' +  
'              </fieldset>' +
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <td align="center" colspan="5" class="linhaForm" nowrap> ' +
'              <fieldset>' +
'              <legend>Hist¢rico</legend>' +
'              <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'               <tr>' +
'                <td valign="midlle" align=center>' +
'                  <textarea class="fill-in" name="historico" rows="4" cols="110" readonly>' + replace(STRING(tt_antecip_pef_pend.des_text_histor),chr(10), ' ') + '</textarea>' +
'                </td>' + 
'               </tr> ' +
'               <tr><td height="5"></td></tr>' +
'              </table> ' +  
'              </fieldset>' +
'          </td> ' +
'         </tr> ' +
'         <tr><td height="5"></td></tr>' +
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


/*
OUTPUT TO c:~\tmp~\aedhtml026e.htm.
FOR EACH  tt-html:
    PUT tt-html.html-doc.
END.
OUTPUT CLOSE.
DOS SILENT VALUE("explorer c:~\tmp~\aedhtml026e.htm.").
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

&endif


FIND FIRST tt_antecip_pef_pend NO-ERROR.
FIND FIRST tt_item_lote_impl_ap NO-ERROR.
FIND FIRST tt_aprop_ctbl_pend_ap NO-ERROR.

IF AVAIL tt_antecip_pef_pend THEN DO:

CREATE tt-html.
ASSIGN tt-html.seq-html = 1.
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
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' 
/*'     <tr>'*/.

IF v_log_alternativo THEN 
    ASSIGN tt-html.html-doc = tt-html.html-doc + '<tr><td class="barraTituloAlter">Antecipa‡Æo - Aprovador Alternativo de ' + string(v_nom_aprov,"x(35)") + '</td>'.
ELSE 
    ASSIGN tt-html.html-doc = tt-html.html-doc + '<tr><td class="barraTitulo">Antecipa‡Æo' + '</td>'.

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
'          <th align="right" colspan=1 class="linhaForm" nowrap>Referˆncia:</th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="10" name="referencia" value="' + STRING(tt_antecip_pef_pend.cod_refer) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" colspan=1 class="linhaForm" nowrap>Data Transa‡Æo:</th> ' +
'          <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="10" name="data_trans" value="' + STRING(tt_antecip_pef_pend.dat_transacao,"99/99/9999") + '" readonly>' + 
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
'      </fieldset>'.

ASSIGN v_seq = 3.
FOR EACH  tt_aprop_ctbl_pend_ap no-lock
    BREAK BY tt_aprop_ctbl_pend_ap.cod_tip_fluxo_financ:

    CREATE tt-html.
    ASSIGN tt-html.seq-html = v_seq.

ASSIGN tt-html.html-doc = 
'      <fieldset>' +
'      <table align="center" border="0" cellpadding="0" cellspacing="1" width="80%">' +
'        <tr><td height="5"></td></tr>' +
'         <tr> ' +
'          <th align="right" colspan="1" class="linhaForm" nowrap>Tipo Fluxo:</th> ' +
'          <td align="left" colspan="3" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="12" name="tipo_fluxo" value="' + STRING(tt_aprop_ctbl_pend_ap.cod_tip_fluxo) + '" readonly>' + 
'              <input type="text" class="fill-in" size="40" name="desc_tipo_fluxo" value="' + STRING(tt_aprop_ctbl_pend_ap.des_cod_tip_fluxo_financ) + '" readonly> ' +
'          </td> ' +
'        </tr> ' +
'        <tr>' +
'         <th align="right" class="linhaForm" nowrap width="27%">Plano Contas:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="8" name="plano_contas" value="' + STRING("") + '" readonly>' +
'            <input class="fill-in" type="text" size="40" name="desc_plano_contas" value="' + STRING("") + '" readonly>' +
'         </td>' +
'        </tr> ' +
'        <tr>' +
'         <th align="right" class="linhaForm" nowrap>Conta Cont bil:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="20" name="conta_contabil" value="' + STRING("") + '" readonly>' +
'            <input class="fill-in" type="text" size="40" name="desc_conta_contabil" value="' + STRING("") + '" readonly>' +
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
'            <input class="fill-in" type="text" size="8" name="plano_custo" value="' + STRING("") + '" readonly>' +
'            <input class="fill-in" type="text" size="40" name="desc_plano_custo" value="' + STRING("") + '" readonly>' +
'         </td>' +
'        </tr>' +
'        <tr>' +
'         <th align="right" class="linhaForm" nowrap>Centro Custo:</th>' +
'         <td class="linhaForm" align="left" nowrap>' +
'            <input class="fill-in" type="text" size="10" name="centro_custo" value="' + STRING("") + '" readonly>' +
'            <input class="fill-in" type="text" size="40" name="desc_centro_custo" value="' + STRING("") + '" readonly>' +
'         </td>' +
'        </tr>' +
'         <th align="right" class="linhaForm" nowrap>Valor a aprovar:</th>' +
'         <td class="linhaForm" align="left" nowrap> ' +
'            <input class="fill-in" type="text" size="20" name="valor_aprop_ctbl" value="' + TRIM(STRING(tt_aprop_ctbl_pend_ap.val_aprop_ctbl,"->>>,>>>,>>9.99")) + '" readonly>' +
'         </td>' +
'        </tr>' +
'        <tr><td height="5"></td></tr>' +
'      </table>  ' +
'     </fieldset>' +
'     </center> ' .
'  </td>' +
' </tr>' +
' </table>'.
    ASSIGN v_seq = v_seq + 1.
END.

{laphtml/mlahtmlrodape.i}

IF AVAIL mla-tipo-doc-aprov AND mla-tipo-doc-aprov.log-1 = YES THEN DO:

    FOR EACH  mla-doc-pend-aprov 
       WHERE mla-doc-pend-aprov.ep-codigo    = &IF "{&mguni_version}" >= "2.071" &THEN STRING(tt-aed-chave.valor[10]) &ELSE integer(tt-aed-chave.valor[10]) &ENDIF 
         AND mla-doc-pend-aprov.cod-estabel  = tt-aed-chave.valor[1]      
         AND mla-doc-pend-aprov.cod-tip-doc  = p-cod-tip-doc
         AND mla-doc-pend-aprov.chave-doc    = c-chave  
         AND mla-doc-pend-aprov.ind-situacao = 2
         AND mla-doc-pend-aprov.historico    = NO NO-LOCK USE-INDEX pend-18 BY mla-doc-pend-aprov.nr-trans: 

        FIND mla-tipo-aprov WHERE mla-tipo-aprov.cod-tip-aprov = mla-doc-pend-aprov.cod-tip-aprov NO-LOCK NO-ERROR. 
       
        ASSIGN i-cont-aprov2 = i-cont-aprov2 + 1.

        IF mla-doc-pend-aprov.cod-usuar-altern = "" THEN 
            FIND usuar_mestre WHERE usuar_mestre.cod_usuar = mla-doc-pend-aprov.cod-usuar NO-LOCK NO-ERROR.
        ELSE
            FIND usuar_mestre WHERE usuar_mestre.cod_usuar = mla-doc-pend-aprov.cod-usuar-altern NO-LOCK NO-ERROR.
       

        ASSIGN tt-html.html-doc = tt-html.html-doc + 
                                  '<tr> ' +
                                  '  <td colspan="2" class="linhaform" align="left">' +
                                  '----------- N¡vel ' + STRING(i-cont-aprov2) + ' (' + mla-tipo-aprov.des-tip-aprov + ') ------------<br>' +
                                  '<b>Aprovado por: </b>' + usuar_mestre.cod_usuar + ' - ' + usuar_mestre.nom_usuario + '<br>' +
                                  '<b>Quando: </b>' + string(mla-doc-pend-aprov.dt-aprova,'99/99/9999') + ' as ' + substring(mla-doc-pend-aprov.char-1,1,8) +
                                  '  </td> ' +
                                  '</tr> ' +
                                  '<tr> ' +
                                  '  <td class="linhaform" align="left" valign="top">' +
                                  '      <b>Coment rio: </b>' + 
                                  '  </td>' +
                                  '  <td class="linhaform" align="left">' + replace(mla-doc-pend-aprov.narrativa-apr,CHR(10),'<br>') +
                                  '  </td>' +
                                  '</tr>'. 
    END.
END.

ASSIGN tt-html.html-doc = tt-html.html-doc +
        '<br>' +
        '<br><br><br><br><br><br><br><br><br><br><br>' +
        '<br><br><br><br><br><br><br><br><br><br><br>'.

CREATE tt-html.
ASSIGN tt-html.seq-html = v_seq.
ASSIGN tt-html.html-doc = tt-html.html-doc +
' <a name="detalhe">' +
' <div align="center"><center>' +
'   <table align="center" border="0" cellpadding="0" cellspacing="3" width="90%" class="tableForm">' +
'     <tr>' +
'       <td class="barratitulo">Detalhe do Documento(Antecipa‡Æo)</td>' +
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
'          <th align="right" class="linhaForm" nowrap width="14%">Portador:</th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="10" name="portador" value="' + STRING(tt_antecip_pef_pend.cod_portador) + '" readonly>' + 
'          </td> ' +
'          <th align="right" class="linhaForm" nowrap width="13%">Moeda:</th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="15" name="moeda" value="' + STRING(tt_antecip_pef_pend.cod_indic_econ) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap>EmissÆo:</th> ' +
'          <td align="left" class="linhaForm" nowrap> '.

IF  tt_antecip_pef_pend.dat_emis_docto <> ? THEN
ASSIGN tt-html.html-doc = tt-html.html-doc +
'              <input type="text" class="fill-in" size="12" name="emissao" value="' + STRING(tt_antecip_pef_pend.dat_emis_docto,"99/99/9999") + '" readonly>'.
ELSE
ASSIGN tt-html.html-doc = tt-html.html-doc +
'              <input type="text" class="fill-in" size="12" name="emissao" value="' + STRING("") + '" readonly>'.

ASSIGN tt-html.html-doc = tt-html.html-doc +
'          </td> ' +
'          <th align="right" class="linhaForm" nowrap>Cota‡Æo:</th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="25" name="cotacao" value="' + TRIM(STRING(tt_antecip_pef_pend.val_cotac_indic_econ,">>>>,>>9.9999999999")) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap>Data Vencimento:</th> ' +
'          <td align="left" class="linhaForm" nowrap> '.

IF tt_antecip_pef_pend.dat_vencto_tit_ap <> ? THEN
ASSIGN tt-html.html-doc = tt-html.html-doc +
'              <input type="text" class="fill-in" size="12" name="data_vencimento" value="' + STRING(tt_antecip_pef_pend.dat_vencto_tit_ap,"99/99/9999") + '" readonly>'.
ELSE
ASSIGN tt-html.html-doc = tt-html.html-doc +
'              <input type="text" class="fill-in" size="12" name="data_vencimento" value="' + STRING("") + '" readonly>'. 

ASSIGN tt-html.html-doc = tt-html.html-doc +
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
'          <th align="right" class="linhaForm" nowrap>Modo Pagto:</th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="15" name="modo_pagto" value="' + STRING(tt_antecip_pef_pend.ind_modo_pagto) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <th align="right" class="linhaForm" nowrap>&nbsp;</th> ' +
'          <td align="left" class="linhaForm" nowrap>&nbsp;</td> ' +
'          <th align="right" class="linhaForm" nowrap>Forma Pagto:</th> ' +
'          <td align="left" class="linhaForm" nowrap> ' +
'              <input type="text" class="fill-in" size="8" name="forma_pagto" value="' + STRING(tt_antecip_pef_pend.cod_forma_pagto) + '" readonly>' + 
'          </td> ' +
'         </tr> ' +
'         <tr> ' +
'          <td align="center" colspan="5" class="linhaForm" nowrap> ' +
'              <fieldset>' +
'              <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'               <tr><td height="5"></td></tr>' +
'               <tr>' +
'                 <th align="right" colspan=1 class="linhaForm" nowrap>Num Cheque:</th> ' +
'                 <td align="left" colspan=3 class="linhaForm" nowrap width="15%"> ' +
'                     <input type="text" class="fill-in" size="25" name="num_cheque" value="' + STRING(tt_antecip_pef_pend.num_cheque) + '" readonly>' + 
'                 </td> ' +
'                 <th align="right" colspan=1 class="linhaForm" nowrap width="20%">Favorecido:</th> ' +
'                 <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'                     <input type="text" class="fill-in" size="30" name="favorecido" value="' + STRING(tt_antecip_pef_pend.ind_favorec_cheq) + '" readonly>' + 
'                 </td> ' +
'               </tr> ' +
'               <tr>' +
'                 <th align="right" colspan=1 class="linhaForm" nowrap>Talon rio:</th> ' +
'                 <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'                     <input type="text" class="fill-in" size="23" name="talonario" value="' + STRING(tt_antecip_pef_pend.num_talon_cheq) + '" readonly>' + 
'                 </td> ' +
'                 <th align="right" colspan=1 class="linhaForm" nowrap>&nbsp;</th> ' +
'                 <td align="left" colspan=3 class="linhaForm" nowrap> ' +
'                     <input type="text" class="fill-in" size="40" name="nomefavorecido" value="' + STRING(tt_antecip_pef_pend.nom_favorec_cheq) + '" readonly>' + 
'                 </td> ' +
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
'            <tr> ' +     /*Modifica?Êo Walter */
'            <td align="left" colspan="0" class="linhaForm" nowrap> ' +
'              <fieldset>' +
'                <legend>Hist¢rico</legend>' +
'                <table align="center" border="0" cellpadding="0" cellspacing="1" width="100%">' +
'                 <tr>' +
'                  <td valign="midlle" align=center>' +
'                    <textarea class="fill-in" name="historico" rows="4" cols="110" readonly>' + replace(STRING(tt_antecip_pef_pend.des_historico) ,chr(10), ' ') + '</textarea>' +
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

END.


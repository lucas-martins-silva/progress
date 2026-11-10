/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9057 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im9057 MIM}
&ENDIF

DEFINE INPUT  PARAMETER  p-cod-estabel   AS CHARACTER  NO-UNDO.                                 
DEFINE INPUT  PARAMETER  p-emitente      AS INTEGER    NO-UNDO.            
DEFINE INPUT  PARAMETER  p-esp-tit-rec   AS CHARACTER  NO-UNDO.                              
DEFINE INPUT  PARAMETER  p-serie-docto   AS CHARACTER  NO-UNDO.                            
DEFINE INPUT  PARAMETER  p-nro-docto     AS CHARACTER  NO-UNDO.                            
DEFINE OUTPUT PARAMETER  p-parcela       AS INTEGER    NO-UNDO.    

{imp/im9057.i}       /* Defini‡Æo de Temp-tables */
{imp/im0088.i2}      /* Defini‡Æo de Forms API Finan‡as */
{method/dbotterr.i}  /* temp-table RowErrors */                      

DEFINE VARIABLE h-acr933zb               AS HANDLE                      NO-UNDO.

IF NOT VALID-HANDLE(h-acr933zb) THEN
    RUN prgfin/acr/acr933zb.py PERSISTENT SET h-acr933zb.
                    
/* T¡tulos do Contas a Pagar - inicio */
EMPTY TEMP-TABLE tt_consult_tit_ap.
EMPTY TEMP-TABLE tt_retorno_tit_ap.

CREATE tt_consult_tit_ap.
ASSIGN tt_consult_tit_ap.ttv_num_tip_leitura      = 6 /* chave sem parcela */
       tt_consult_tit_ap.tta_cod_estab            = p-cod-estabel
       tt_consult_tit_ap.tta_cdn_fornecedor       = p-emitente
       tt_consult_tit_ap.tta_cod_espec_docto      = p-esp-tit-rec
       tt_consult_tit_ap.tta_cod_ser_docto        = p-serie-docto
       tt_consult_tit_ap.tta_cod_tit_ap           = p-nro-docto.

RUN pi_consult_tit_ap IN h-acr933zb (INPUT TABLE  tt_consult_tit_ap,
                                     OUTPUT TABLE tt_retorno_tit_ap,
                                     OUTPUT TABLE tt_retorno_val_tit_ap,
                                     OUTPUT TABLE tt_retorno_movto_tit_ap,
                                     OUTPUT TABLE tt_retorno_val_movto_tit_ap,
                                     OUTPUT TABLE tt_log_erro).           

FOR LAST tt_retorno_tit_ap NO-LOCK:
   ASSIGN p-parcela = INT(tt_retorno_tit_ap.cod_parcela). 
END. 

IF VALID-HANDLE(h-acr933zb) THEN DO:
    DELETE PROCEDURE h-acr933zb.
    ASSIGN h-acr933zb = ?.
END.



   
            

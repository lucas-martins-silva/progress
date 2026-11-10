&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright TOTVS S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0804G 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0804G MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: AB0804G.p
**
**       DATA....: Fevereiro 2018
**
**       AUTOR...: TOTVS S.A.
**
**       OBJETIVO: Verifica a existˆncia de ficha de abastecimento ou materiais
**                 relacionadas … itens da nota para exclusÆo
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    index seq ErrorSequence.

DEFINE TEMP-TABLE tt-item-fro NO-UNDO
    FIELD serie-docto     AS CHARACTER
    FIELD nro-docto       AS CHARACTER
    FIELD cod-emitente    AS INTEGER
    FIELD nat-operacao    AS CHARACTER
    FIELD sequencia       AS INTEGER.

/** Parƒmetros **/
define input  parameter pc-serie        as character no-undo.
define input  parameter pc-nota         as character no-undo.
define input  parameter pi-emitente     as integer   no-undo.
define input  parameter pc-natureza     as character no-undo.
define output parameter table for RowErrors.


for each mab-abastec-lubrific
    where mab-abastec-lubrific.serie        = pc-serie
    and   mab-abastec-lubrific.nr-nota-fis  = pc-nota
    and   mab-abastec-lubrific.cod-emitente = pi-emitente
    and   mab-abastec-lubrific.nat-operacao = pc-natureza no-lock:

    if not can-find(first item-doc-est
                    where item-doc-est.serie-docto  = mab-abastec-lubrific.serie       
                      and item-doc-est.nro-docto    = mab-abastec-lubrific.nr-nota-fis 
                      and item-doc-est.cod-emitente = mab-abastec-lubrific.cod-emitente
                      and item-doc-est.nat-operacao = mab-abastec-lubrific.nat-operacao
                      and item-doc-est.sequencia    = mab-abastec-lubrific.sequencia) then do:    
        create tt-item-fro.
        assign tt-item-fro.serie-docto  = mab-abastec-lubrific.serie       
               tt-item-fro.nro-docto    = mab-abastec-lubrific.nr-nota-fis 
               tt-item-fro.cod-emitente = mab-abastec-lubrific.cod-emitente
               tt-item-fro.nat-operacao = mab-abastec-lubrific.nat-operacao
               tt-item-fro.sequencia    = mab-abastec-lubrific.sequencia.
    end.
end.
        
for each mmv-movto-mater
    where mmv-movto-mater.serie-docto  = pc-serie
    and   mmv-movto-mater.nro-docto    = pc-nota
    and   mmv-movto-mater.cod-emitente = pi-emitente
    and   mmv-movto-mater.nat-operacao = pc-natureza no-lock:

    if not can-find(first item-doc-est
                    where item-doc-est.serie-docto  = mmv-movto-mater.serie-docto 
                      and item-doc-est.nro-docto    = mmv-movto-mater.nro-docto   
                      and item-doc-est.cod-emitente = mmv-movto-mater.cod-emitente
                      and item-doc-est.nat-operacao = mmv-movto-mater.nat-operacao
                      and item-doc-est.sequencia    = mmv-movto-mater.sequencia) then do:

        create tt-item-fro.
        assign tt-item-fro.serie-docto  = mmv-movto-mater.serie-docto 
               tt-item-fro.nro-docto    = mmv-movto-mater.nro-docto   
               tt-item-fro.cod-emitente = mmv-movto-mater.cod-emitente
               tt-item-fro.nat-operacao = mmv-movto-mater.nat-operacao
               tt-item-fro.sequencia    = mmv-movto-mater.sequencia.
    end.            
end.


for each tt-item-fro:
    run abp/ab0804e.p (input  tt-item-fro.serie-docto,
                       input  tt-item-fro.nro-docto,
                       input  tt-item-fro.cod-emitente,
                       input  tt-item-fro.nat-operacao,
                       input  tt-item-fro.sequencia,
                       input  3,
                       output table RowErrors).
                       
    if can-find(first RowErrors 
                where RowErrors.ErrorSubType = "ERROR":U no-lock) then do:
          return "NOK":U.
    end.
end.

return "OK":U.


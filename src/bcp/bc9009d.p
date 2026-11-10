/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9009D 2.00.00.004 } /*** "010004" 09/10/2025 11:26:31 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9009d MBC}
&ENDIF


/***********************************************************************************
** Copyright DATASUL S.A. (2000)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
**********************************************************************************/
/**********************************************************************************
**     Programa...: bc9009d.p  
**
**     Finalidade.: Adapter da transacao de transferencia para Datasul EMS 2.00 
**
**     Criado em..: Setembro 2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Definicao dos campos de comunicacao com o adapter            */
{cep/ce9025.i}   /* Definicao dos campos de comunicacao com o adapter            */
/*********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*********************************************************************************/
Define Variable vRaw                As Raw                  No-undo.

{method/dbotterr.i}
{scbo/bosc032.i1} /* Defini‡Æo dos Temp-Tables do Coletor de Dados */

def var h-wm as handle no-undo.

/*********************************************************************************/

Do:
    Find First ttIntegracao No-lock No-error.

    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg",
                            input 25346,
                            input "bc9009d").
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 25346
                tt-erro.mensagem = trim(return-value).
        Return 'NOK'.
    End.
    
    create tt-leitura.
    assign tt-leitura.id-box-lido        = _RetornaValDeci('id-box-col')
           tt-leitura.num-seq-item       = _retornavalInte('num-seq-item-col')
           tt-leitura.id-docto           = _RetornaValDeci('id-docto-col')
           tt-leitura.cod-item-lido           = _RetornaValChar('cod-item-col')
           tt-leitura.qtd-item-lido      = _RetornaValDeci('qtd-item-col') 
           tt-leitura.cod-embalagem-lido = _RetornaValChar('cod-embalagem-col')
           tt-leitura.qti-embalagem-lido = _RetornaValDeci('qti-embalagem-col').
 
    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return "NOK".
    
    create tt-box-movto.
    assign tt-box-movto.id-box         = _RetornaValDeci('id-box-ped').
    assign tt-box-movto.cod-local      = _retornavalchar('cod-local-ped').
    assign tt-box-movto.cod-estabel    = _retornavalchar('cod-estabel-ped').
    assign tt-box-movto.num-seq-item   = _retornavalInte('num-seq-item-ped').
    assign tt-box-movto.id-docto       = _RetornaValDeci('id-docto-ped').
    assign tt-box-movto.qtd-item       = _RetornaValDeci('qtd-item-ped').
    assign tt-box-movto.cod-embalagem  = _RetornaValChar('cod-embalagem-ped').
    assign tt-box-movto.qti-embalagem  = _RetornaValDeci('qti-embalagem-ped').
    assign tt-box-movto.dt-transacao   = _RetornaValData('dt-transacao-ped').    
    
    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return "NOK".
    
    run scbo/bosc032.p persistent set h-wm.
    
    run ConfirmReadBox in h-wm (input table tt-leitura, input table tt-box-movto, input YES).
    
    run getrowerrors in h-wm (output table rowerrors).
   
    for each rowerrors:
        create tt-erro.
        assign tt-erro.cd-erro  = rowerrors.ErrorNumber
               tt-erro.mensagem = rowerrors.ErrorDescription
               .
    end.
   
    IF VALID-HANDLE(h-wm) THEN RUN destroy IN h-wm.

    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return "NOK".

    

End. /* Do: Main */


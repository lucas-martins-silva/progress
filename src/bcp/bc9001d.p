/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9001D 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9001d MBC}
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
**     Programa...: bc9001d.p  
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
/*********************************************************************************/

Do:
    Find First ttIntegracao No-lock No-error.

    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg",
                            input 25346,
                            input "bc9003d").
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 25346
                tt-erro.mensagem = trim(return-value).
        Return 'NOK'.
    End.

    Create tt-transfere.
    Assign tt-transfere.cod-unico     = _RetornaValChar('cod-unico')
           tt-transfere.nro-docto     = _RetornaValChar('num-documento')
           tt-transfere.cod-estabel   = _RetornaValChar('cod-estabel')
           tt-transfere.cod-depos-o   = _RetornaValChar('cod-depos-origem')
           tt-transfere.cod-depos-d   = _RetornaValChar('cod-depos-destino')
           tt-transfere.cod-localiz-o = _RetornaValChar('cod-local-origem')
           tt-transfere.cod-localiz-d = _RetornaValChar('cod-local-destino')
           tt-transfere.it-codigo     = _RetornaValChar('cod-item')
           tt-transfere.lote-o        = _RetornaValChar('cod-lote-origem')
           tt-transfere.lote-d        = _RetornaValChar('cod-lote-destino')
           tt-transfere.quantidade    = _RetornaValDeci('qtd-movimento')
           tt-transfere.dt-trans      = _RetornaValData('data-transacao')
           tt-transfere.cod-refer-o   = _RetornaValChar('cod-refer-origem')
           tt-transfere.cod-refer-d   = _RetornaValChar('cod-refer-destino')
           tt-transfere.serie-docto   = _RetornaValChar('cod-serie-documento')
           tt-transfere.cod-prog-orig = "bc9001d".


    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return "NOK".

    Raw-Transfer tt-transfere To vRaw.

    Run 'cep/ceapi005.p' (Input        pNumTrans,
                          Input        vRaw,
                          Input-Output Table tt-erro).

End. /* Do: Main */


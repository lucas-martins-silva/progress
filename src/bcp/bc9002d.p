/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9002D 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9002D MBC}
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
**     Programa...: bc9002d.p  
**
**     Finalidade.: Adapter da transacao de inventario para Datasul EMS 2.00 
**
**     Criado em..: Setembro 2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Definicao dos campos de comunicacao com o adapter            */
{cep/ce9020.i}   /* Definicao dos campos de comunicacao com o adapter            */
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

    Create tt-contagem.
    Assign tt-contagem.nr-ficha      = _RetornaValInte('num-ficha-inventario')
           tt-contagem.num-contagem  = _RetornaValInte('num-contagem')
           tt-contagem.cod-estabel   = _RetornaValChar('cod-estabel')
           tt-contagem.cod-depos     = _RetornaValChar('cod-depos')
           tt-contagem.cod-unico     = _RetornaValChar('cod-unico')
           tt-contagem.cod-refer     = _RetornaValChar('cod-refer')
           tt-contagem.cod-localiz   = _RetornaValChar('cod-local')
           tt-contagem.it-codigo     = _RetornaValChar('cod-item')
           tt-contagem.lote          = _RetornaValChar('cod-lote')
           tt-contagem.dt-vali-lote  = _RetornaValData('dat-valid-lote')
           tt-contagem.quantidade    = _RetornaValDeci('qtd-apontada')
           tt-contagem.dt-corte      = _RetornaValData('dat-contagem').

    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return "NOK".

    Raw-Transfer tt-contagem To vRaw.

    Run 'cep/ceapi004.p' (Input        pNumTrans,
                          Input        vRaw,
                          Input-Output Table tt-erro).

End. /* Do: Main */
/*********************************************************************************/

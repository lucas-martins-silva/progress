/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI009 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPI009 MUT}
&ENDIF


/*************************************************************************
**
**   Programa: BCAPI009 - API - Retorna Parametros do Coleta de Dados
**
**   Parametros: tt-param-bc
**
**   Versao de Integracao: 1 - Luciano - Criacao da API (07/98)
**
**************************************************************************/

/* VERSAO DE INTEGRACAO */

&SCOPED-DEFINE Versao-Integracao 1

{bcp/bcapi009.i}    /* Definicao da temp-table tt-param-bc  */

def output param table for tt-param-bc.

/*** Testa de o modulo Coleta de Dados esta Habilitado ***/
find first bc-param-mat no-lock no-error.
if  not avail bc-param-mat then
    return "NOK":U.

find first param-bc no-lock no-error.
if  not avail param-bc then
    return "NOK":U.

find first tt-param-bc no-error.
if  not avail tt-param-bc then
    create tt-param-bc.

assign  tt-param-bc.cod_servid_exec_atualiz = param-bc.cod_servid_exec_atualiz
        tt-param-bc.cod_servid_exec_import  = param-bc.cod_servid_exec_import
        tt-param-bc.nome-dir-etiq           = param-bc.nome-dir-etiq
        tt-param-bc.pto-decimal             = param-bc.pto-decimal
        tt-param-bc.tp-etiq-padrao          = param-bc.tp-etiq-padrao
        tt-param-bc.conta-entrada           = bc-param-mat.conta-entrada 
        tt-param-bc.conta-saida             = bc-param-mat.conta-saida 
        tt-param-bc.dt-transf               = bc-param-mat.dt-transf 
        tt-param-bc.nr-contagem             = bc-param-mat.nr-contagem.

return "OK".

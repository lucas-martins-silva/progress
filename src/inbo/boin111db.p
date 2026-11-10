/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN111DB 2.00.00.003 } /*** "010003" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN111DB MUT}
&ENDIF

/*
**  boin111db.P
**
**  Bo espec¡fica p/ a tabela de Estrutura - Arquivo de Estrutura
**
**  Ultima altera‡Æo : 07/01/2000 - GeraBO
***********************************************************************************************/
&scoped-define BOVERSION 1.1
&scoped-define FIRST-TABLE-IN-QUERY tt-estrutura
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-estrutura
 
{include/boini.i} 
 
{inbo/boin111a.i RowObject}

{inbo/boin111a.i tt-estrutura}

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

/****************** Vari veis utilizadas na open-query (locais) *************************/
define var de-quant-usada       like estrutura.quant-usada   no-undo.
define var de-quant-liq         as decimal                   no-undo.
define var c-refer-es           like ref-item.cod-refer      no-undo.
define var l-refer-incluida     as logical                   no-undo.
define var c-comp               as char format "x(1)"        no-undo.
define var c-fabr               as char format "x(1)"        no-undo.    
define var c-alt                as char format "x(1)"        no-undo.
define var c-refer              like ref-item.cod-refer      no-undo.
define var c-rowid              as char                      no-undo.
define var i-seq                as integer                   no-undo.
define var i-nivel              as integer                   no-undo.
define var c-it-codigo          like item.it-codigo          no-undo.

/********* defini‡äes de vari veis que vem tela de parƒmetro - wen0805a  - ************/
define var de-quantidade     as decimal                      no-undo.
define var i-niveis          as integer                      no-undo.
define var da-data-corte     as date                         no-undo. 
define var c-format          as char                         no-undo.

DEFINE BUFFER  b-item  FOR   item.

/*********************   Fim defini‡Æo wen0805  *********************/

DEFINE VARIABLE l-baixa-drb-internac AS LOGICAL INITIAL NO NO-UNDO.
define var      d-perc-item          as decimal            no-undo.
define var      d-perc-drb           as decimal            no-undo.
define var      d-qtd-baixa-drb      as decimal            no-undo.

{inbo/boin111a.i1} /* procedure setConstraint2 */ 
 
{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}

{inbo/boin111a.i2} /* procedure getTTestrutura / montaEstrutura */

{inbo/boin111a.i3} /* procedure getEstruturaFilho */

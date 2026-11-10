/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0706E 2.00.00.002}  /*** "010002" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0706e MAB}
&ENDIF


/*------------------------------------------------------------------------------
  Purpose:     importa dados das tabelas p g 4 (Outros)
  Parameters:  tt-param (entrada) = temp-table com os parametros do rp
               tt-dados (sa¡da)   = resultados da importa‡Æo para exibi‡Æo no rp.
  Notes:       chamada pelo programa de importa‡Æo de Cadastros Basicos Frotas - 
               ab0706rp.p - .
------------------------------------------------------------------------------*/     
/*variaveis*/
define variable iLinha         as integer    no-undo.
DEFINE VARIABLE c-liter1 AS CHARACTER FORMAT "X(50)":U NO-UNDO.
DEFINE VARIABLE c-liter2 AS CHARACTER FORMAT "X(50)":U NO-UNDO.
DEFINE VARIABLE c-liter3 AS CHARACTER FORMAT "X(50)":U NO-UNDO.
DEFINE VARIABLE c-teste AS CHARACTER  NO-UNDO.

{abp/ab0706.i4}           /* Temp-table tt-param */
{abp/ab9004.i}            /* Temp-Table RowErrors */
{abp/ab0706.i3}

/*temp tables procedures*/
{frbo/bofr029.i tt-mco-compon}
DEF TEMP-TABLE tt-mco-compon-linha NO-UNDO LIKE mco-compon
    FIELD i-linha AS INT.

{frbo/bofr030.i tt-mco-histor-vida}
DEF TEMP-TABLE tt-mco-histor-vida-linha NO-UNDO LIKE mco-histor-vida
    FIELD i-linha AS INT.

{frbo/bofr100.i tt-mco-plano-compon}
DEF TEMP-TABLE tt-mco-plano-compon-linha NO-UNDO LIKE mco-plano-compon
    FIELD i-linha AS INT.

{frbo/bofr102.i tt-mab-tab-restdo}
DEF TEMP-TABLE tt-mab-tab-restdo-linha NO-UNDO LIKE mab-tab-restdo
    FIELD i-linha AS INT.

{frbo/bofr101.i tt-mab-restdo-tab}
DEF TEMP-TABLE tt-mab-restdo-tab-linha NO-UNDO LIKE mab-restdo-tab
    FIELD i-linha AS INT.

{frbo/bofr103.i tt-mao-ensaio}
DEF TEMP-TABLE tt-mao-ensaio-linha NO-UNDO LIKE mao-ensaio
    FIELD i-linha AS INT.

{frbo/bofr104.i tt-mao-ensaio-padr}
DEF TEMP-TABLE tt-mao-ensaio-padr-linha NO-UNDO LIKE mao-ensaio-padr
    FIELD i-linha AS INT.

{frbo/bofr114.i tt-mab-usuar-frota}
DEF TEMP-TABLE tt-mab-usuar-frota-linha NO-UNDO LIKE mab-usuar-frota
    FIELD i-linha AS INT.

{frbo/bofr123.i tt-mab-usuar-estab}
DEF TEMP-TABLE tt-mab-usuar-estab-linha NO-UNDO LIKE mab-usuar-estab
    FIELD i-linha AS INT.

{frbo/bofr109.i tt-mnd-proces-administ}
DEF TEMP-TABLE tt-mnd-proces-administ-linha NO-UNDO LIKE mnd-proces-administ
    FIELD i-linha AS INT.

{frbo/bofr092.i tt-mgf-param}
DEF TEMP-TABLE tt-mgf-param-linha NO-UNDO LIKE mgf-param
    FIELD i-linha AS INT.

{frbo/bofr079.i tt-mgf-event-param}
DEF TEMP-TABLE tt-mgf-event-param-linha NO-UNDO LIKE mgf-event-param
    FIELD i-linha AS INT.

{frbo/bofr080.i tt-mgf-event-grp-eqpto}
DEF TEMP-TABLE tt-mgf-event-grp-eqpto-linha NO-UNDO LIKE mgf-event-grp-eqpto
    FIELD i-linha AS INT.

{frbo/bofr091.i tt-mgf-grp-estoq}
DEF TEMP-TABLE tt-mgf-grp-estoq-linha NO-UNDO LIKE mgf-grp-estoq
    FIELD i-linha AS INT.

/*parametros de entrada e saida*/
DEF INPUT-OUTPUT PARAM i-contador-geral AS INT NO-UNDO.
define input parameter table for tt-param.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-dados.
DEF INPUT PARAM h-acomp AS HANDLE NO-UNDO.

FIND FIRST tt-param NO-LOCK NO-ERROR.


IF tt-param.l-mco-compon  THEN
    RUN importa-mco-compon IN THIS-PROCEDURE.

IF tt-param.l-mco-histor-vida  THEN
    RUN importa-mco-histor-vida IN THIS-PROCEDURE.

IF tt-param.l-mco-plano-compon  THEN
    RUN importa-mco-plano-compon IN THIS-PROCEDURE.

IF tt-param.l-mab-tab-restdo  THEN
    RUN importa-mab-tab-restdo IN THIS-PROCEDURE.

IF tt-param.l-mab-restdo-tab  THEN
    RUN importa-mab-restdo-tab IN THIS-PROCEDURE.

IF tt-param.l-mao-ensaio  THEN
    RUN importa-mao-ensaio IN THIS-PROCEDURE.

IF tt-param.l-mao-ensaio-padr  THEN
    RUN importa-mao-ensaio-padr IN THIS-PROCEDURE.

IF tt-param.l-mab-usuar-frota  THEN
    RUN importa-mab-usuar-frota IN THIS-PROCEDURE.

IF tt-param.l-mab-usuar-estab  THEN
    RUN importa-mab-usuar-estab IN THIS-PROCEDURE.

IF tt-param.l-mnd-proces-administ  THEN
    RUN importa-mnd-proces-administ IN THIS-PROCEDURE.

IF tt-param.l-mgf-param  THEN
    RUN importa-mgf-param IN THIS-PROCEDURE.

IF tt-param.l-mgf-event-param  THEN
    RUN importa-mgf-event-param IN THIS-PROCEDURE.

IF tt-param.l-mgf-event-grp-eqpto  THEN
    RUN importa-mgf-event-grp-eqpto IN THIS-PROCEDURE.

IF tt-param.l-mgf-grp-estoq  THEN
    RUN importa-mgf-grp-estoq IN THIS-PROCEDURE.


RETURN "OK":U.

/*PROCEDURES */
{abp/ab0706.i2 mco-compon fr029 Componentes Componentes input(tt-mco-compon.num-seqcial)}
{abp/ab0706.i2 mco-histor-vida fr030 Hist¢rico_Vida_Componente Componentes input(tt-mco-histor-vida.num-seqcial),input(tt-mco-histor-vida.num-vida)}
{abp/ab0706.i2 mco-plano-compon fr100 Plano_X_Componente Componentes input(tt-mco-plano-compon.num-seqcial),input(tt-mco-plano-compon.cod-plano)}
{abp/ab0706.i2 mab-tab-restdo fr102 Tabela_de_Resultados Abastecimento_e_Lubrifica‡Æo input(tt-mab-tab-restdo.num-tabela)}
{abp/ab0706.i2 mab-restdo-tab fr101 Resultados_da_Tabela Abastecimento_e_Lubrifica‡Æo input(tt-mab-restdo-tab.num-tabela),input(tt-mab-restdo-tab.num-seq)}
{abp/ab0706.i2 mao-ensaio fr103 Ensaios An lise_de_àleos input(tt-mao-ensaio.cod-ensaio)}
{abp/ab0706.i2 mao-ensaio-padr fr104 Padräes_Ensaios An lise_de_àleos input(tt-mao-ensaio-padr.cod-tip-mater),input(tt-mao-ensaio-padr.cod-model),input(tt-mao-ensaio-padr.cod-ensaio)}
{abp/ab0706.i2 mab-usuar-frota fr114 Usu rio_Frota Abastecimento_e_Lubrifica‡Æo input(tt-mab-usuar-frota.cod-usuar)}
{abp/ab0706.i2 mab-usuar-estab fr123 Usu rio_X_Estabelecimento Abastecimento_e_Lubrifica‡Æo input(tt-mab-usuar-estab.cod-usuar),input(tt-mab-usuar-estab.cod-estabel)}
{abp/ab0706.i2 mnd-proces-administ fr109 Processo_Administrativo Manuten‡Æo_de_Documentos input(tt-mnd-proces-administ.cod-proces)}
{abp/ab0706.i2 mgf-param fr092 Parƒmetro_Gerencial_Frotas Gerencial_Frotas input(tt-mgf-param.num-seq)}
{abp/ab0706.i2 mgf-event-param fr079 Parametriza‡Æo_Evento Gerencial_Frotas input(tt-mgf-event-param.ep-codigo),input(tt-mgf-event-param.cod-evento)}
{abp/ab0706.i2 mgf-event-grp-eqpto fr080 Evento_X_Grupo_Equipamento Gerencial_Frotas input(tt-mgf-event-grp-eqpto.ep-codigo),input(tt-mgf-event-grp-eqpto.cod-evento),input(tt-mgf-event-grp-eqpto.cod-grp-eqpto)}
{abp/ab0706.i2 mgf-grp-estoq fr091 Grupo_Estoque_-_Pneus Gerencial_Frotas input(tt-mgf-grp-estoq.ge-codigo)}

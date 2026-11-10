/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0706A 2.00.00.001}  /*** "010001" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0706a MAB}
&ENDIF


/*------------------------------------------------------------------------------
  Purpose:     importa dados das tabelas modulo Abastecimento (1a metade)
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
{frbo/bofr001.i tt-mab-ativid}
DEF TEMP-TABLE tt-mab-ativid-linha NO-UNDO LIKE mab-ativid
    FIELD i-linha AS INT.

{frbo/bofr028.i tt-mab-trajeto}
DEF TEMP-TABLE tt-mab-trajeto-linha NO-UNDO LIKE mab-trajeto
    FIELD i-linha AS INT.
 
{frbo/bofr098.i tt-mab-caract}
DEF TEMP-TABLE tt-mab-caract-linha NO-UNDO LIKE mab-caract
    FIELD i-linha AS INT.

{frbo/bofr003.i tt-mab-comptmento}
DEF TEMP-TABLE tt-mab-comptmento-linha NO-UNDO LIKE mab-comptmento
    FIELD i-linha AS INT.

{frbo/bofr009.i tt-mab-estrut-mec}
DEF TEMP-TABLE tt-mab-estrut-mec-linha NO-UNDO LIKE mab-estrut-mec
    FIELD i-linha AS INT.

{frbo/bofr023.i tt-mab-sist}
DEF TEMP-TABLE tt-mab-sist-linha NO-UNDO LIKE mab-sist
    FIELD i-linha AS INT.

{frbo/bofr025.i tt-mab-sub-sist}
DEF TEMP-TABLE tt-mab-sub-sist-linha NO-UNDO LIKE mab-sub-sist
    FIELD i-linha AS INT.

{frbo/bofr024.i tt-mab-sit-eqpto}
DEF TEMP-TABLE tt-mab-sit-eqpto-linha NO-UNDO LIKE mab-sit-eqpto
    FIELD i-linha AS INT.

{frbo/bofr011.i tt-mab-grp-eqpto}
DEF TEMP-TABLE tt-mab-grp-eqpto-linha NO-UNDO LIKE mab-grp-eqpto
    FIELD i-linha AS INT.

{frbo/bofr008.i tt-mab-eqpto-sub-sist}
DEF TEMP-TABLE tt-mab-eqpto-sub-sist-linha NO-UNDO LIKE mab-eqpto-sub-sist
    FIELD i-linha AS INT.

{frbo/bofr021.i tt-mab-posto}
DEF TEMP-TABLE tt-mab-posto-linha NO-UNDO LIKE mab-posto
    FIELD i-linha AS INT.

{frbo/bofr107.i tt-mab-integr-cargo}
DEF TEMP-TABLE tt-mab-integr-cargo-linha NO-UNDO LIKE mab-integr-cargo
    FIELD i-linha AS INT.

/*parametros de entrada e saida*/
DEF INPUT-OUTPUT PARAM i-contador-geral AS INT NO-UNDO.
define input        param table for tt-param.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-dados.
DEF INPUT PARAM h-acomp AS HANDLE NO-UNDO.

FIND FIRST tt-param NO-LOCK NO-ERROR.

IF tt-param.l-mab-ativid  THEN
    RUN importa-mab-ativid IN THIS-PROCEDURE.

IF tt-param.l-mab-trajeto  THEN
    RUN importa-mab-trajeto IN THIS-PROCEDURE.

IF tt-param.l-mab-caract  THEN
    RUN importa-mab-caract IN THIS-PROCEDURE.

IF tt-param.l-mab-comptmento  THEN
    RUN importa-mab-comptmento IN THIS-PROCEDURE.

IF tt-param.l-mab-estrut-mec  THEN
    RUN importa-mab-estrut-mec IN THIS-PROCEDURE.

IF tt-param.l-mab-sist  THEN
    RUN importa-mab-sist IN THIS-PROCEDURE.

IF tt-param.l-mab-sub-sist  THEN
    RUN importa-mab-sub-sist IN THIS-PROCEDURE.

IF tt-param.l-mab-sit-eqpto  THEN
    RUN importa-mab-sit-eqpto IN THIS-PROCEDURE.

IF tt-param.l-mab-grp-eqpto  THEN
    RUN importa-mab-grp-eqpto IN THIS-PROCEDURE.

IF tt-param.l-mab-eqpto-sub-sist  THEN
    RUN importa-mab-eqpto-sub-sist IN THIS-PROCEDURE.

IF tt-param.l-mab-posto  THEN
    RUN importa-mab-posto IN THIS-PROCEDURE.

IF tt-param.l-mab-integr-cargo THEN
    RUN importa-mab-integr-cargo IN THIS-PROCEDURE.

RETURN "OK":U.

/*PROCEDURES */
{abp/ab0706.i2 mab-ativid fr001 Atividades Abastecimento_e_Lubrifica‡Æo input(tt-mab-ativid.cod-ativid)}
{abp/ab0706.i2 mab-trajeto fr028 Trajeto Abastecimento_e_Lubrifica‡Æo input(tt-mab-trajeto.cod-rota)}
{abp/ab0706.i2 mab-caract fr098 Caracter¡sticas Abastecimento_e_Lubrifica‡Æo input(tt-mab-caract.cod-caract)}
{abp/ab0706.i2 mab-comptmento fr003 Compartimentos_àleo/Filtros Abastecimento_e_Lubrifica‡Æo input(tt-mab-comptmento.cod-comptmento)}
{abp/ab0706.i2 mab-estrut-mec fr009 Estrutura_Mecƒnica Abastecimento_e_Lubrifica‡Æo input(tt-mab-estrut-mec.cod-estrut-mec)}
{abp/ab0706.i2 mab-sist fr023 Sistema_Mecƒnico Abastecimento_e_Lubrifica‡Æo input(tt-mab-sist.cod-sistema)}
{abp/ab0706.i2 mab-sub-sist fr025 Sub-Sistema Abastecimento_e_Lubrifica‡Æo INPUT(tt-mab-sub-sist.cod-sub-sist)}
{abp/ab0706.i2 mab-sit-eqpto fr024 Situa‡Æo Abastecimento_e_Lubrifica‡Æo input(tt-mab-sit-eqpto.cod-sit-eqpto)}
{abp/ab0706.i2 mab-grp-eqpto fr011 Grupo_Equipamento Abastecimento_e_Lubrifica‡Æo input(tt-mab-grp-eqpto.cod-grp-eqpto)}
{abp/ab0706.i2 mab-eqpto-sub-sist fr008 Rela‡Æo_Grupo_Equipamento_X_Sub-Sistema Abastecimento_e_Lubrifica‡Æo input(tt-mab-eqpto-sub-sist.cod-grp-eqpto),INPUT(tt-mab-eqpto-sub-sist.cod-sub-sist)}
{abp/ab0706.i2 mab-posto fr021 Posto_Abastecimento Abastecimento_e_Lubrifica‡Æo input(tt-mab-posto.cod-posto)}
{abp/ab0706.i2 mab-integr-cargo fr107 Integra‡Æo_Cargos Abastecimento_e_Lubrifica‡Æo input(tt-mab-integr-cargo.cod-cargo)}

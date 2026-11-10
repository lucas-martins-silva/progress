/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0706D 2.00.00.001}  /*** "010001" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0706d MAB}
&ENDIF


/*------------------------------------------------------------------------------
  Purpose:     importa dados das tabelas modulo Pneus
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
{frbo/bofr094.i tt-mpn-param}
DEF TEMP-TABLE tt-mpn-param-linha NO-UNDO LIKE mpn-param
    FIELD i-linha AS INT.

{frbo/bofr054.i tt-mpn-tip-borracha}
DEF TEMP-TABLE tt-mpn-tip-borracha-linha NO-UNDO LIKE mpn-tip-borracha
    FIELD i-linha AS INT.

{frbo/bofr049.i tt-mpn-medid}
DEF TEMP-TABLE tt-mpn-medid-linha NO-UNDO LIKE mpn-medid
    FIELD i-linha AS INT.

{frbo/bofr052.i tt-mpn-pos-pneu}
DEF TEMP-TABLE tt-mpn-pos-pneu-linha NO-UNDO LIKE mpn-pos-pneu
    FIELD i-linha AS INT.

{frbo/bofr047.i tt-mpn-layout}
DEF TEMP-TABLE tt-mpn-layout-linha NO-UNDO LIKE mpn-layout
    FIELD i-linha AS INT.

{frbo/bofr048.i tt-mpn-layout-eixo-pos}
DEF TEMP-TABLE tt-mpn-layout-eixo-pos-linha NO-UNDO LIKE mpn-layout-eixo-pos
    FIELD i-linha AS INT.

{frbo/bofr042.i tt-mpn-ambien-trab}
DEF TEMP-TABLE tt-mpn-ambien-trab-linha NO-UNDO LIKE mpn-ambien-trab
    FIELD i-linha AS INT.

{frbo/bofr053.i tt-mpn-serv}
DEF TEMP-TABLE tt-mpn-serv-linha NO-UNDO LIKE mpn-serv
    FIELD i-linha AS INT.

{frbo/bofr124.i tt-mpn-tip-serv}
DEF TEMP-TABLE tt-mpn-tip-serv-linha NO-UNDO LIKE mpn-tip-serv
    FIELD i-linha AS INT.

{frbo/bofr043.i tt-mpn-desen}
DEF TEMP-TABLE tt-mpn-desen-linha NO-UNDO LIKE mpn-desen
    FIELD i-linha AS INT.

{frbo/bofr046.i tt-mpn-km-esperad}
DEF TEMP-TABLE tt-mpn-km-esperad-linha NO-UNDO LIKE mpn-km-esperad
    FIELD i-linha AS INT.

{frbo/bofr050.i tt-mpn-model}
DEF TEMP-TABLE tt-mpn-model-linha NO-UNDO LIKE mpn-model
    FIELD i-linha AS INT.

{frbo/bofr051.i tt-mpn-pneu}
DEF TEMP-TABLE tt-mpn-pneu-linha NO-UNDO LIKE mpn-pneu
    FIELD i-linha AS INT.

{frbo/bofr045.i tt-mpn-histor-vida}
DEF TEMP-TABLE tt-mpn-histor-vida-linha NO-UNDO LIKE mpn-histor-vida
    FIELD i-linha AS INT.



/*parametros de entrada e saida*/
DEF INPUT-OUTPUT PARAM i-contador-geral AS INT NO-UNDO.
define input parameter table for tt-param.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-dados.
DEF INPUT PARAM h-acomp AS HANDLE NO-UNDO.

FIND FIRST tt-param NO-LOCK NO-ERROR.

IF tt-param.l-mpn-param  THEN
    RUN importa-mpn-param IN THIS-PROCEDURE.

IF tt-param.l-mpn-tip-borracha  THEN
    RUN importa-mpn-tip-borracha IN THIS-PROCEDURE.

IF tt-param.l-mpn-medid  THEN
    RUN importa-mpn-medid IN THIS-PROCEDURE.

IF tt-param.l-mpn-pos-pneu  THEN
    RUN importa-mpn-pos-pneu IN THIS-PROCEDURE.

IF tt-param.l-mpn-layout THEN
    RUN importa-mpn-layout IN THIS-PROCEDURE.

IF tt-param.l-mpn-layout-eixo-pos  THEN
    RUN importa-mpn-layout-eixo-pos IN THIS-PROCEDURE.

IF tt-param.l-mpn-ambien-trab  THEN
    RUN importa-mpn-ambien-trab IN THIS-PROCEDURE.

IF tt-param.l-mpn-serv  THEN
    RUN importa-mpn-serv IN THIS-PROCEDURE.

IF tt-param.l-mpn-tip-serv  THEN
    RUN importa-mpn-tip-serv IN THIS-PROCEDURE.

IF tt-param.l-mpn-desen  THEN
    RUN importa-mpn-desen IN THIS-PROCEDURE.

IF tt-param.l-mpn-km-esperad  THEN
    RUN importa-mpn-km-esperad IN THIS-PROCEDURE.

IF tt-param.l-mpn-model  THEN
    RUN importa-mpn-model IN THIS-PROCEDURE.

IF tt-param.l-mpn-pneu  THEN
    RUN importa-mpn-pneu IN THIS-PROCEDURE.

IF tt-param.l-mpn-histor-vida  THEN
    RUN importa-mpn-histor-vida IN THIS-PROCEDURE.

RETURN "OK":U.

/*PROCEDURES */
{abp/ab0706.i2 mpn-param fr094 Parƒmetros_Pneu Pneus INPUT(tt-mpn-param.num-seq)}
{abp/ab0706.i2 mpn-tip-borracha fr054 Tipo_Borracha Pneus input(tt-mpn-tip-borracha.cod-borracha)}
{abp/ab0706.i2 mpn-medid fr049 Medidas Pneus input(tt-mpn-medid.cod-medid)}
{abp/ab0706.i2 mpn-pos-pneu fr052 Posi‡äes Pneus input(tt-mpn-pos-pneu.cod-pos)}
{abp/ab0706.i2 mpn-layout fr047 Layout_dos_Eixos Pneus input(tt-mpn-layout.cod-layout)}
{abp/ab0706.i2 mpn-layout-eixo-pos fr048 Layout_Eixo_Posi‡Æo Pneus input(tt-mpn-layout-eixo-pos.cod-layout),input(tt-mpn-layout-eixo-pos.cod-pos)}
{abp/ab0706.i2 mpn-ambien-trab fr042 Ambiente_Trabalho Pneus input(tt-mpn-ambien-trab.cod-ambien-trab)}
{abp/ab0706.i2 mpn-serv fr053 Servi‡os Pneus input(tt-mpn-serv.cod-servico)}
{abp/ab0706.i2 mpn-tip-serv fr124 Tipo_Servi‡o Pneus input(tt-mpn-tip-serv.cod-tip-serv)}
{abp/ab0706.i2 mpn-desen fr043 Desenho Pneus input(tt-mpn-desen.cod-desen)}
{abp/ab0706.i2 mpn-km-esperad fr046 Durabilidade_Esperada_Pneu Pneus input(tt-mpn-km-esperad.cod-desen),input(tt-mpn-km-esperad.cod-medid),input(tt-mpn-km-esperad.num-vida)}
{abp/ab0706.i2 mpn-model fr050 Modelo_Pneu Pneus input(tt-mpn-model.cod-model-pneu)}
{abp/ab0706.i2 mpn-pneu fr051 Pneus Pneus input(tt-mpn-pneu.cod-pneu)}
{abp/ab0706.i2 mpn-histor-vida fr045 Hist¢rico_Vida_Pneu Pneus INPUT(tt-mpn-histor-vida.cod-pneu),INPUT(tt-mpn-histor-vida.num-vida)}

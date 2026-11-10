/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0706B 2.00.00.001}  /*** "010001" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0706b MAB}
&ENDIF


/*------------------------------------------------------------------------------
  Purpose:     importa dados das tabelas modulo Abastecimento (2a metade)
  Parameters:  tt-param (entrada) = temp-table com os parametros do rp
               tt-dados (sa°da)   = resultados da importaá∆o para exibiá∆o no rp.
  Notes:       chamada pelo programa de importaá∆o de Cadastros Basicos Frotas - 
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
{frbo/bofr002.i tt-mab-bomba}
DEF TEMP-TABLE tt-mab-bomba-linha NO-UNDO LIKE mab-bomba
    FIELD i-linha AS INT.

{frbo/bofr026.i tt-mab-tip-mater}
DEF TEMP-TABLE tt-mab-tip-mater-linha NO-UNDO LIKE mab-tip-mater
    FIELD i-linha AS INT.

{frbo/bofr027.i tt-mab-tip-mater-item}
DEF TEMP-TABLE tt-mab-tip-mater-item-linha NO-UNDO LIKE mab-tip-mater-item
    FIELD i-linha AS INT.

{frbo/bofr012.i tt-mab-grp-event}
DEF TEMP-TABLE tt-mab-grp-event-linha NO-UNDO LIKE mab-grp-event
    FIELD i-linha AS INT.

{frbo/bofr010.i tt-mab-event}
DEF TEMP-TABLE tt-mab-event-linha NO-UNDO LIKE mab-event
    FIELD i-linha AS INT.

{frbo/bofr015.i tt-mab-marca}
DEF TEMP-TABLE tt-mab-marca-linha NO-UNDO LIKE mab-marca
    FIELD i-linha AS INT.

{frbo/bofr016.i tt-mab-model}
DEF TEMP-TABLE tt-mab-model-linha NO-UNDO LIKE mab-model
    FIELD i-linha AS INT.

{frbo/bofr006.i tt-mab-consu-model}
DEF TEMP-TABLE tt-mab-consu-model-linha NO-UNDO LIKE mab-consu-model
    FIELD i-linha AS INT.

{frbo/bofr078.i tt-mmv-tempo-padr}
DEF TEMP-TABLE tt-mmv-tempo-padr-linha NO-UNDO LIKE mmv-tempo-padr
    FIELD i-linha AS INT.

{frbo/bofr017.i tt-mab-motoris}
DEF TEMP-TABLE tt-mab-motoris-linha NO-UNDO LIKE mab-motoris
    FIELD i-linha AS INT.

{frbo/bofr018.i tt-mab-motoris-model}
DEF TEMP-TABLE tt-mab-motoris-model-linha NO-UNDO LIKE mab-motoris-model
    FIELD i-linha AS INT.


/*parametros de entrada e saida*/
DEF INPUT-OUTPUT PARAM i-contador-geral AS INT NO-UNDO.
define input parameter table for tt-param.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-dados.
DEF INPUT PARAM h-acomp AS HANDLE NO-UNDO.

FIND FIRST tt-param NO-LOCK NO-ERROR.

IF tt-param.l-mab-bomba  THEN
    RUN importa-mab-bomba IN THIS-PROCEDURE.

IF tt-param.l-mab-tip-mater  THEN
    RUN importa-mab-tip-mater IN THIS-PROCEDURE.

IF tt-param.l-mab-tip-mater-item  THEN
    RUN importa-mab-tip-mater-item IN THIS-PROCEDURE.

IF tt-param.l-mab-grp-event  THEN
    RUN importa-mab-grp-event IN THIS-PROCEDURE.

IF tt-param.l-mab-event  THEN
    RUN importa-mab-event IN THIS-PROCEDURE.

IF tt-param.l-mab-marca  THEN
    RUN importa-mab-marca IN THIS-PROCEDURE.

IF tt-param.l-mab-model  THEN
    RUN importa-mab-model IN THIS-PROCEDURE.

IF tt-param.l-mab-consu-model  THEN
    RUN importa-mab-consu-model IN THIS-PROCEDURE.

IF tt-param.l-mmv-tempo-padr  THEN
    RUN importa-mmv-tempo-padr IN THIS-PROCEDURE.

IF tt-param.l-mab-motoris  THEN
    RUN importa-mab-motoris IN THIS-PROCEDURE.

IF tt-param.l-mab-motoris-model  THEN
    RUN importa-mab-motoris-model IN THIS-PROCEDURE.

RETURN "OK":U.

/*PROCEDURES */
{abp/ab0706.i2 mab-bomba fr002 Bomba Abastecimento_e_Lubrificaá∆o input(tt-mab-bomba.cod-posto),INPUT(tt-mab-bomba.cod-bomba)}
{abp/ab0706.i2 mab-tip-mater fr026 Tipo_Material Abastecimento_e_Lubrificaá∆o input(tt-mab-tip-mater.cod-tip-mater)}
{abp/ab0706.i2 mab-tip-mater-item fr027 Tipo_Material_X_Item_Estoque Abastecimento_e_Lubrificaá∆o INPUT(tt-mab-tip-mater-item.cod-tip-mater),INPUT(tt-mab-tip-mater-item.it-codigo)}
{abp/ab0706.i2 mab-grp-event fr012 Grupo_Evento Abastecimento_e_Lubrificaá∆o input(tt-mab-grp-event.cod-grp-event)}
{abp/ab0706.i2 mab-event fr010 Evento Abastecimento_e_Lubrificaá∆o input(tt-mab-event.cod-evento)}
{abp/ab0706.i2 mab-marca fr015 Marcas Abastecimento_e_Lubrificaá∆o input(tt-mab-marca.cod-marca)}
{abp/ab0706.i2 mab-model fr016 Modelo_-_Equipamento/Componente Abastecimento_e_Lubrificaá∆o input(tt-mab-model.cod-model)}
{abp/ab0706.i2 mab-consu-model fr006 Consumo_Padr∆o_por_Modelo Abastecimento_e_Lubrificaá∆o input(tt-mab-consu-model.cod-model),input(tt-mab-consu-model.cod-ativid),INPUT(tt-mab-consu-model.cod-tip-mater)}
{abp/ab0706.i2 mmv-tempo-padr fr078 Tempo_Padr∆o_Execuá∆o_Serviáos Manutená∆o_MecÉnica input(tt-mmv-tempo-padr.cod-model),input(tt-mmv-tempo-padr.cod-sub-sist),input(tt-mmv-tempo-padr.cod-evento)}
{abp/ab0706.i2 mab-motoris fr017 Motorista Abastecimento_e_Lubrificaá∆o input(tt-mab-motoris.ep-codigo),input(tt-mab-motoris.cod-estabel),input(tt-mab-motoris.cod-matr)}
{abp/ab0706.i2 mab-motoris-model fr018 Motorista_X_Modelo Abastecimento_e_Lubrificaá∆o input(tt-mab-motoris-model.ep-codigo),input(tt-mab-motoris-model.cod-estabel),input(tt-mab-motoris-model.cod-matr),input(tt-mab-motoris-model.cod-model)}

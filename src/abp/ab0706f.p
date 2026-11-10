/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0706F 2.00.00.002}  /*** "010002" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0706f MAB}
&ENDIF


/*------------------------------------------------------------------------------
  Purpose:     importa dados das tabelas p g 5 (Equipamento)
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
{frbo/bofr007.i tt-mab-eqpto}
DEF TEMP-TABLE tt-mab-eqpto-linha NO-UNDO LIKE mab-eqpto
    FIELD i-linha AS INT.

{frbo/bofr013.i tt-mab-histor-ativid}
DEF TEMP-TABLE tt-mab-histor-ativid-linha NO-UNDO LIKE mab-histor-ativid
    FIELD i-linha AS INT.

{frbo/bofr014.i tt-mab-histor-combust}
DEF TEMP-TABLE tt-mab-histor-combust-linha NO-UNDO LIKE mab-histor-combust
    FIELD i-linha AS INT.

{frbo/bofr097.i tt-mab-eqpto-caract}
DEF TEMP-TABLE tt-mab-eqpto-caract-linha NO-UNDO LIKE mab-eqpto-caract
    FIELD i-linha AS INT.

{frbo/bofr004.i tt-mab-comptmento-eqpto}
DEF TEMP-TABLE tt-mab-comptmento-eqpto-linha NO-UNDO LIKE mab-comptmento-eqpto
    FIELD i-linha AS INT.

{frbo/bofr020.i tt-mab-period-manut}
DEF TEMP-TABLE tt-mab-period-manut-linha NO-UNDO LIKE mab-period-manut
    FIELD i-linha AS INT.

{frbo/bofr005.i tt-mab-configur-eixo}
DEF TEMP-TABLE tt-mab-configur-eixo-linha NO-UNDO LIKE mab-configur-eixo
    FIELD i-linha AS INT.

{frbo/bofr022.i tt-mab-programac-event}
DEF TEMP-TABLE tt-mab-programac-event-linha NO-UNDO LIKE mab-programac-event
    FIELD i-linha AS INT.

{frbo/bofr031.i tt-mmv-eqpto-plano}
DEF TEMP-TABLE tt-mmv-eqpto-plano-linha NO-UNDO LIKE mmv-eqpto-plano
    FIELD i-linha AS INT.

{frbo/bofr093.i tt-mgf-eqpto-implto}
DEF TEMP-TABLE tt-mgf-eqpto-implto-linha NO-UNDO LIKE mgf-eqpto-implto
    FIELD i-linha AS INT.

{frbo/bofr044.i tt-mpn-histor-layout-eixo}
DEF TEMP-TABLE tt-mpn-histor-layout-eixo-linha NO-UNDO LIKE mpn-histor-layout-eixo
    FIELD i-linha AS INT.

{frbo/bofr099.i tt-mpn-eqpto-serv}
DEF TEMP-TABLE tt-mpn-eqpto-serv-linha NO-UNDO LIKE mpn-eqpto-serv
    FIELD i-linha AS INT.

{frbo/bofr125.i tt-mpn-hora-estimad}
DEF TEMP-TABLE tt-mpn-hora-estimad-linha NO-UNDO LIKE mpn-hora-estimad
    FIELD i-linha AS INT.

{frbo/bofr126.i tt-mmv-grp-eqpto}
DEF TEMP-TABLE tt-mmv-grp-eqpto-linha NO-UNDO LIKE mmv-grp-eqpto
    FIELD i-linha AS INT.

{frbo/bofr127.i tt-mmv-eqpto-grp-eqpto}
DEF TEMP-TABLE tt-mmv-eqpto-grp-eqpto-linha NO-UNDO LIKE mmv-eqpto-grp-eqpto
    FIELD i-linha AS INT.

{frbo/bofr128.i tt-mab-relac-eqpto-sub}
DEF TEMP-TABLE tt-mab-relac-eqpto-sub-linha NO-UNDO LIKE mab-relac-eqpto-sub
    FIELD i-linha AS INT.

/*parametros de entrada e saida*/
DEF INPUT-OUTPUT PARAM i-contador-geral AS INT NO-UNDO.
define input parameter table for tt-param.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-dados.
DEF INPUT PARAM h-acomp AS HANDLE NO-UNDO.

FIND FIRST tt-param NO-LOCK NO-ERROR.

IF tt-param.l-mab-eqpto  THEN
    RUN importa-mab-eqpto IN THIS-PROCEDURE.

IF tt-param.l-mab-histor-ativid  THEN
    RUN importa-mab-histor-ativid IN THIS-PROCEDURE.

IF tt-param.l-mab-histor-combust  THEN
    RUN importa-mab-histor-combust IN THIS-PROCEDURE.

IF tt-param.l-mab-eqpto-caract  THEN
    RUN importa-mab-eqpto-caract IN THIS-PROCEDURE.

IF tt-param.l-mab-comptmento-eqpto  THEN
    RUN importa-mab-comptmento-eqpto IN THIS-PROCEDURE.

IF tt-param.l-mab-period-manut  THEN
    RUN importa-mab-period-manut IN THIS-PROCEDURE.

IF tt-param.l-mab-configur-eixo  THEN
    RUN importa-mab-configur-eixo IN THIS-PROCEDURE.

IF tt-param.l-mab-programac-event  THEN
    RUN importa-mab-programac-event IN THIS-PROCEDURE.

IF tt-param.l-mmv-eqpto-plano  THEN
    RUN importa-mmv-eqpto-plano IN THIS-PROCEDURE.

IF tt-param.l-mgf-eqpto-implto  THEN
    RUN importa-mgf-eqpto-implto IN THIS-PROCEDURE.

IF tt-param.l-mpn-histor-layout-eixo  THEN
    RUN importa-mpn-histor-layout-eixo IN THIS-PROCEDURE.

IF tt-param.l-mpn-eqpto-serv  THEN
    RUN importa-mpn-eqpto-serv IN THIS-PROCEDURE.

IF tt-param.l-mpn-hora-estimad  THEN
    RUN importa-mpn-hora-estimad IN THIS-PROCEDURE.

IF tt-param.l-mmv-grp-eqpto  THEN
    RUN importa-mmv-grp-eqpto IN THIS-PROCEDURE.

IF tt-param.l-mmv-eqpto-grp-eqpto  THEN
    RUN importa-mmv-eqpto-grp-eqpto IN THIS-PROCEDURE.

IF tt-param.l-mab-relac-eqpto-sub THEN
    RUN importa-mab-relac-eqpto-sub IN THIS-PROCEDURE.

RETURN "OK":U.

/*PROCEDURES */
{abp/ab0706.i2 mab-eqpto fr007 Equipamentos Abastecimento_e_Lubrifica‡Æo input(tt-mab-eqpto.ep-codigo),input(tt-mab-eqpto.cod-eqpto)}
{abp/ab0706.i2 mab-histor-ativid fr013 Hist¢rico_Setor_Grupo_Atividade_Equipamento Abastecimento_e_Lubrifica‡Æo input(tt-mab-histor-ativid.ep-codigo),input(tt-mab-histor-ativid.cod-eqpto),input(tt-mab-histor-ativid.dat-cadastro)}
{abp/ab0706.i2 mab-histor-combust fr014 Hist¢rico_Combust¡vel_Equipamento Abastecimento_e_Lubrifica‡Æo input(tt-mab-histor-combust.ep-codigo),input(tt-mab-histor-combust.cod-eqpto),input(tt-mab-histor-combust.dat-inicial)}
{abp/ab0706.i2 mab-eqpto-caract fr097 Caracter¡sticas_Equipamentos Abastecimento_e_Lubrifica‡Æo input(tt-mab-eqpto-caract.ep-codigo),input(tt-mab-eqpto-caract.cod-eqpto),input(tt-mab-eqpto-caract.cod-caract)}
{abp/ab0706.i2 mab-comptmento-eqpto fr004 Compartimento_Equipamentos Abastecimento_e_Lubrifica‡Æo input(tt-mab-comptmento-eqpto.ep-codigo),input(tt-mab-comptmento-eqpto.cod-eqpto),input(tt-mab-comptmento-eqpto.cod-comptmento)}
{abp/ab0706.i2 mab-period-manut fr020 Per¡odo_Manuten‡Æo_Compartimento Abastecimento_e_Lubrifica‡Æo input(tt-mab-period-manut.ep-codigo),input(tt-mab-period-manut.cod-eqpto),input(tt-mab-period-manut.cod-comptmento),input(tt-mab-period-manut.cod-evento)}
{abp/ab0706.i2 mab-configur-eixo fr005 Configura‡Æo_Eixo Abastecimento_e_Lubrifica‡Æo input(tt-mab-configur-eixo.ep-codigo),input(tt-mab-configur-eixo.cod-eqpto),input(tt-mab-configur-eixo.num-eixo)}
{abp/ab0706.i2 mab-programac-event fr022 Programa‡Æo_de_Eventos Abastecimento_e_Lubrifica‡Æo input(tt-mab-programac-event.ep-codigo),input(tt-mab-programac-event.cod-eqpto),input(tt-mab-programac-event.cod-evento)}
{abp/ab0706.i2 mmv-eqpto-plano fr031 Equipamento_Plano_Manuten‡Æo Manuten‡Æo_Mecƒnica input(tt-mmv-eqpto-plano.ep-codigo),input(tt-mmv-eqpto-plano.cod-eqpto),input(tt-mmv-eqpto-plano.cod-plano)}
{abp/ab0706.i2 mgf-eqpto-implto fr093 Equipamento_X_Implementos Gerencial_Frotas input(tt-mgf-eqpto-implto.ep-codigo-implto),INPUT(tt-mgf-eqpto-implto.cod-implto),INPUT(tt-mgf-eqpto-implto.dat-inicial)}
{abp/ab0706.i2 mpn-histor-layout-eixo fr044 Hist¢rico_Layout_Eixo_Equipamento Pneus input(tt-mpn-histor-layout-eixo.ep-codigo),input(tt-mpn-histor-layout-eixo.cod-eqpto),input(tt-mpn-histor-layout-eixo.dat-inicial)}
{abp/ab0706.i2 mpn-eqpto-serv fr099 Servi‡os_de_Pneus_em_Equipamentos Pneus input(tt-mpn-eqpto-serv.ep-codigo),input(tt-mpn-eqpto-serv.cod-eqpto),input(tt-mpn-eqpto-serv.cod-servico)}
{abp/ab0706.i2 mpn-hora-estimad fr125 Percurso_Estimado_Mensal Pneus input(tt-mpn-hora-estimad.ep-codigo),input(tt-mpn-hora-estimad.cod-eqpto),input(tt-mpn-hora-estimad.dat-estimad)}
{abp/ab0706.i2 mmv-grp-eqpto fr126 Grupo_Equipamento_Manuten‡Æo Manuten‡Æo_Mecƒnica INPUT(tt-mmv-grp-eqpto.cod-grp-eqpto)}
{abp/ab0706.i2 mmv-eqpto-grp-eqpto fr127 Equipamento_X_Grupo_Equipamento Manuten‡Æo_Mecƒnica input(tt-mmv-eqpto-grp-eqpto.cod-grp-eqpto),input(tt-mmv-eqpto-grp-eqpto.ep-codigo),input(tt-mmv-eqpto-grp-eqpto.cod-eqpto)}
{abp/ab0706.i2 mab-relac-eqpto-sub fr128 Rela‡Æo_Equipamento_Sub-Sistema Equipamento input(tt-mab-relac-eqpto-sub.ep-codigo),input(tt-mab-relac-eqpto-sub.cod-eqpto),input(tt-mab-relac-eqpto-sub.cod-sub-sist)}

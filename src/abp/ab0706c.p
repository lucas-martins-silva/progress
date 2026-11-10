/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0706C 2.00.00.003}  /*** "010003" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0706c MAB}
&ENDIF


/*------------------------------------------------------------------------------
  Purpose:     importa dados das tabelas modulo Manuten‡Æo Mecanica
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

{abp/ab9004.i}            /* Temp-Table RowErrors */
{abp/ab0706.i3}
{abp/ab0706.i4} /* Temp-table tt-param */

/*temp tables procedures*/
{frbo/bofr034.i tt-mmv-param}
DEF TEMP-TABLE tt-mmv-param-linha NO-UNDO LIKE mmv-param
    FIELD i-linha AS INT.

{frbo/bofr033.i tt-mmv-ofici}
DEF TEMP-TABLE tt-mmv-ofici-linha NO-UNDO LIKE mmv-ofici
    FIELD i-linha AS INT.

{frbo/bofr036.i tt-mmv-setor-ofici}
DEF TEMP-TABLE tt-mmv-setor-ofici-linha NO-UNDO LIKE mmv-setor-ofici
    FIELD i-linha AS INT.

{frbo/bofr032.i tt-mmv-func-ofici}
DEF TEMP-TABLE tt-mmv-func-ofici-linha NO-UNDO LIKE mmv-func-ofici
    FIELD i-linha AS INT.

{frbo/bofr077.i tt-mmv-plandor}
DEF TEMP-TABLE tt-mmv-plandor-linha NO-UNDO LIKE mmv-plandor
    FIELD i-linha AS INT.

{frbo/bofr035.i tt-mmv-plano-prevent}
DEF TEMP-TABLE tt-mmv-plano-prevent-linha NO-UNDO LIKE mmv-plano-prevent
    FIELD i-linha AS INT.

{frbo/bofr037.i tt-mmv-tar-plano}
DEF TEMP-TABLE tt-mmv-tar-plano-linha NO-UNDO LIKE mmv-tar-plano
    FIELD i-linha AS INT.

{frbo/bofr041.i tt-mmv-tar-plano-item}
DEF TEMP-TABLE tt-mmv-tar-plano-item-linha NO-UNDO LIKE mmv-tar-plano-item
    FIELD i-linha AS INT.

{frbo/bofr038.i tt-mmv-tar-plano-epi}
DEF TEMP-TABLE tt-mmv-tar-plano-epi-linha NO-UNDO LIKE mmv-tar-plano-epi
    FIELD i-linha AS INT.

{frbo/bofr039.i tt-mmv-tar-plano-ferram}
DEF TEMP-TABLE tt-mmv-tar-plano-ferram-linha NO-UNDO LIKE mmv-tar-plano-ferram
    FIELD i-linha AS INT.

{frbo/bofr040.i tt-mmv-tar-plano-ficha}
DEF TEMP-TABLE tt-mmv-tar-plano-ficha-linha NO-UNDO LIKE mmv-tar-plano-ficha
    FIELD i-linha AS INT.

{frbo/bofr00145.i tt-mmv-tar-plano-esp}
DEF TEMP-TABLE tt-mmv-tar-plano-esp-linha NO-UNDO LIKE mmv-tar-plano-especialid
    FIELD i-linha AS INT.

{frbo/bofr00146.i tt-mmv-tar-plano-esp-curso}
DEF TEMP-TABLE tt-mmv-tar-plano-esp-curso-linha NO-UNDO LIKE mmv-tar-plano-esp-curso
    FIELD i-linha AS INT.

{mnbo/bomn112.i tt-mi-espec}
DEF TEMP-TABLE tt-mi-espec-linha NO-UNDO LIKE mi-espec
    FIELD i-linha AS INT.

{mnbo/bomn267.i tt-mi-curso-trein}
DEF TEMP-TABLE tt-mi-curso-trein-linha NO-UNDO LIKE mi-curso-trein
    FIELD i-linha AS INT.

{mnbo/bomn015.i tt-mi-turno}
DEF TEMP-TABLE tt-mi-turno-linha NO-UNDO LIKE mi-turno
    FIELD i-linha AS INT.

{mnbo/bomn016.i tt-mi-turno-ciclo}
DEF TEMP-TABLE tt-mi-turno-ciclo-linha NO-UNDO LIKE mi-turno-ciclo
    FIELD i-linha AS INT.

{frbo/bofr00142.i tt-mmv-func-turno}
DEF TEMP-TABLE tt-mmv-func-turno-linha NO-UNDO LIKE mmv-func-turno
    FIELD i-linha AS INT.

{frbo/bofr144.i tt-mmv-func-curso-trein}
DEF TEMP-TABLE tt-mmv-func-curso-trein-linha NO-UNDO LIKE mmv-func-curso-trein
    FIELD i-linha AS INT.

{frbo/bofr00143.i tt-mmv-func-especialid}
DEF TEMP-TABLE tt-mmv-func-especialid-linha NO-UNDO LIKE mmv-func-especialid
    FIELD i-linha AS INT.

/*parametros de entrada e saida*/
DEF INPUT-OUTPUT PARAM i-contador-geral AS INT NO-UNDO.
define input parameter table for tt-param.
DEFINE INPUT-OUTPUT PARAM TABLE FOR tt-dados.
DEF INPUT PARAM h-acomp AS HANDLE NO-UNDO.


FIND FIRST tt-param NO-LOCK NO-ERROR.


IF tt-param.l-mmv-param  THEN
    RUN importa-mmv-param IN THIS-PROCEDURE.

IF tt-param.l-mmv-ofici  THEN
    RUN importa-mmv-ofici IN THIS-PROCEDURE.

IF tt-param.l-mmv-setor-ofici  THEN
    RUN importa-mmv-setor-ofici IN THIS-PROCEDURE.

IF tt-param.l-mmv-func-ofici  THEN
    RUN importa-mmv-func-ofici IN THIS-PROCEDURE.

IF tt-param.l-mmv-plandor  THEN
    RUN importa-mmv-plandor IN THIS-PROCEDURE.

IF tt-param.l-mmv-plano-prevent  THEN
    RUN importa-mmv-plano-prevent IN THIS-PROCEDURE.

IF tt-param.l-mmv-tar-plano  THEN DO:
    RUN importa-mmv-tar-plano IN THIS-PROCEDURE.
    FOR EACH mmv-tar-plano EXCLUSIVE-LOCK:
       ASSIGN mmv-tar-plano.des-tarefa = REPLACE(mmv-tar-plano.des-tarefa," ~~~~ ",CHR(10)).
    END.
END.

IF tt-param.l-mmv-tar-plano-item  THEN
    RUN importa-mmv-tar-plano-item IN THIS-PROCEDURE.

IF tt-param.l-mmv-tar-plano-epi  THEN
    RUN importa-mmv-tar-plano-epi IN THIS-PROCEDURE.

IF tt-param.l-mmv-tar-plano-ferram  THEN
    RUN importa-mmv-tar-plano-ferram IN THIS-PROCEDURE.

IF tt-param.l-mmv-tar-plano-ficha  THEN
    RUN importa-mmv-tar-plano-ficha IN THIS-PROCEDURE.

IF tt-param.l-mi-turno THEN
    RUN importa-mi-turno IN THIS-PROCEDURE.

IF tt-param.l-mi-curso-trein THEN
    RUN importa-mi-curso-trein IN THIS-PROCEDURE.

IF tt-param.l-mi-espec THEN
    RUN importa-mi-espec IN THIS-PROCEDURE.

IF tt-param.l-mi-turno-ciclo THEN
    RUN importa-mi-turno-ciclo IN THIS-PROCEDURE.

IF tt-param.l-mmv-func-turno THEN
    RUN importa-mmv-func-turno IN THIS-PROCEDURE.

IF tt-param.l-mmv-func-curso-trein THEN
    RUN importa-mmv-func-curso-trein IN THIS-PROCEDURE.

IF tt-param.l-mmv-func-especialid THEN
    RUN importa-mmv-func-especialid IN THIS-PROCEDURE.

IF tt-param.l-mmv-tar-plano-esp  THEN
    RUN importa-mmv-tar-plano-esp IN THIS-PROCEDURE.

IF tt-param.l-mmv-tar-plano-esp-curso THEN
    RUN importa-mmv-tar-plano-esp-curso IN THIS-PROCEDURE.

RETURN "OK":U.

/*PROCEDURES */
{abp/ab0706.i2 mmv-param fr034 Parƒmetros_Manuten‡Æo_Mecƒnica Manuten‡Æo_Mecƒnica input(tt-mmv-param.ep-codigo)}
{abp/ab0706.i2 mmv-ofici fr033 Oficinas Manuten‡Æo_Mecƒnica input(tt-mmv-ofici.cod-ofici)}
{abp/ab0706.i2 mmv-setor-ofici fr036 Setor_Oficina Manuten‡Æo_Mecƒnica input(tt-mmv-setor-ofici.cod-setor-ofici)}
{abp/ab0706.i2 mmv-func-ofici fr032 Funcion rio_Oficina Manuten‡Æo_Mecƒnica input(tt-mmv-func-ofici.ep-codigo),input(tt-mmv-func-ofici.cod-estabel),input(tt-mmv-func-ofici.cod-matr)}
{abp/ab0706.i2 mmv-plandor fr077 Planejador_das_Ordens_de_Manuten‡Æo Manuten‡Æo_Mecƒnica input(tt-mmv-plandor.cod-plandor)}
{abp/ab0706.i2 mmv-plano-prevent fr035 Plano_Manuten‡Æo Manuten‡Æo_Mecƒnica input(tt-mmv-plano-prevent.cod-model),input(tt-mmv-plano-prevent.cod-plano)}
{abp/ab0706.i2 mmv-tar-plano fr037 Item_Plano_Preventiva Manuten‡Æo_Mecƒnica input(tt-mmv-tar-plano.cod-model),input(tt-mmv-tar-plano.cod-plano),input(tt-mmv-tar-plano.num-seq)}
{abp/ab0706.i2 mmv-tar-plano-item fr041 Materiais_Necess rios_Tarefa Manuten‡Æo_Mecƒnica input(tt-mmv-tar-plano-item.cod-model),input(tt-mmv-tar-plano-item.cod-plano),input(tt-mmv-tar-plano-item.num-seq),input(tt-mmv-tar-plano-item.it-codigo)}
{abp/ab0706.i2 mmv-tar-plano-epi fr038 Equipamentos_Prote‡Æo_Necess rios Manuten‡Æo_Mecƒnica input(tt-mmv-tar-plano-epi.cod-model),input(tt-mmv-tar-plano-epi.cod-plano),input(tt-mmv-tar-plano-epi.num-seq),input(tt-mmv-tar-plano-epi.cd-epi)}
{abp/ab0706.i2 mmv-tar-plano-ferram fr039 Ferramentas_Necess rias Manuten‡Æo_Mecƒnica input(tt-mmv-tar-plano-ferram.cod-model),input(tt-mmv-tar-plano-ferram.cod-plano),input(tt-mmv-tar-plano-ferram.num-seq),input(tt-mmv-tar-plano-ferram.cd-tp-ferr)}
{abp/ab0706.i2 mmv-tar-plano-ficha fr040 Ficha_M‚todo_Associada_Tarefa Manuten‡Æo_Mecƒnica input(tt-mmv-tar-plano-ficha.cod-model),input(tt-mmv-tar-plano-ficha.cod-plano),input(tt-mmv-tar-plano-ficha.num-seq),input(tt-mmv-tar-plano-ficha.fi-codigo)}
{abp/ab0706.i2 mi-turno mn015 Turnos Manuten‡Æo_Mecƒnica input(tt-mi-turno.cd-turno)}
{abp/ab0706.i2 mi-curso-trein mn267 Treinamentos Manuten‡Æo_Mecƒnica input(tt-mi-curso-trein.cdn-curso)}
{abp/ab0706.i2 mi-espec mn112 Especialidade Manuten‡Æo_Mecƒnica input(tt-mi-espec.tp-especial)}
{abp/ab0706.i2 mi-turno-ciclo mn016 Horas_Turno Manuten‡Æo_Mecƒnica input(tt-mi-turno-ciclo.cd-turno),input(tt-mi-turno-ciclo.ciclo),input(tt-mi-turno-ciclo.sequencia)}
{abp/ab0706.i2 mmv-func-turno fr00142 Turnos_Funcion rio Manuten‡Æo_Mecƒnica input(tt-mmv-func-turno.ep-codigo),input(tt-mmv-func-turno.cod-estabel),input(tt-mmv-func-turno.cod-matr),input(tt-mmv-func-turno.cd-turno),input(tt-mmv-func-turno.dt-efetivacao)}
{abp/ab0706.i2 mmv-func-curso-trein fr144 Treinamentos_Funcion rio Manuten‡Æo_Mecƒnica input(tt-mmv-func-curso-trein.ep-codigo),input(tt-mmv-func-curso-trein.cod-estabel),input(tt-mmv-func-curso-trein.cod-matr),input(tt-mmv-func-curso-trein.cdn-curso)}
{abp/ab0706.i2 mmv-func-especialid fr00143 Especialidade_Funcion rio Manuten‡Æo_Mecƒnica input(tt-mmv-func-especialid.ep-codigo),input(tt-mmv-func-especialid.cod-estabel),input(tt-mmv-func-especialid.cod-matr),input(tt-mmv-func-especialid.tp-especial)}
{abp/ab0706.i2 mmv-tar-plano-esp fr00145 Especialidade_Associada_Tarefa Manuten‡Æo_Mecƒnica input(tt-mmv-tar-plano-esp.cod-model),input(tt-mmv-tar-plano-esp.cod-plano),input(tt-mmv-tar-plano-esp.num-seq),input(tt-mmv-tar-plano-esp.tp-especial)}
{abp/ab0706.i2 mmv-tar-plano-esp-curso fr00146 Treinamentos_da_Especialidade_da_Tarefa Manuten‡Æo_Mecƒnica input(tt-mmv-tar-plano-esp-curso.cod-model),input(tt-mmv-tar-plano-esp-curso.cod-plano),input(tt-mmv-tar-plano-esp-curso.num-seq),input(tt-mmv-tar-plano-esp-curso.tp-especial),input(tt-mmv-tar-plano-esp-curso.cdn-curso)}



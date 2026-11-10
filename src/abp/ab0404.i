/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: AB0404.i
**
**       DATA....: Junlho de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Remonta Motor
**
*****************************************************************************/
                                                /** Defini‡Æo de Vari veis **/
DEFINE VARIABLE c-liter-sel  AS CHARACTER FORMAT "x(09)" NO-UNDO.
DEFINE VARIABLE c-liter-imp  AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE c-destino    AS CHARACTER FORMAT "x(09)" NO-UNDO.

/*****************************************************************************/
                                                     /** Form de Parƒmetros **/

form   /*SELE€ÇO*/
       skip(1)
       c-liter-sel              AT 09    no-label
       skip(1)
       tt-param.iEmpIni         COLON 30  "|<  >|" AT 50 
       tt-param.iEmpFim         NO-LABEL 
       tt-param.cEqptoIni       COLON 30  "|<  >|" AT 50 
       tt-param.cEqptoFim       NO-LABEL 
       tt-param.lAvisos
       /*IMPRESSÇO*/
       skip(1)
       c-liter-imp              AT 09    no-label
       skip(1)
       c-destino                COLON 30 " - " tt-param.arquivo NO-LABEL
       tt-param.usuario         COLON 30
       skip(1)
       with width 132 side-labels frame f-param-definidos stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-definidos:HANDLE).

/*****************************************************************************/
                                                                  /** Erros **/
form ErrorSequence    
     ErrorNumber      
     ErrorDescription
    with width 132 no-attr-space no-box down frame f-erro stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-erro:HANDLE).


/*****************************************************************************/
                                               /** Literais Form Parƒmetros **/
{utp/ut-liter.i Usu rio * l}
assign tt-param.usuario:label in frame f-param-definidos = trim(return-value).

{utp/ut-liter.i Destino * l}
assign c-destino:label in frame f-param-definidos = trim(return-value).

{utp/ut-liter.i Avisos * R}
ASSIGN tt-param.lAvisos:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i SELE€ÇO * R}
assign c-liter-sel = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * R}
assign c-liter-imp = trim(return-value).

{utp/ut-liter.i Empresa * R}
ASSIGN tt-param.iEmpIni:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i Equipamento * R}
ASSIGN tt-param.cEqptoIni:LABEL IN FRAME f-param-definidos = trim(return-value).

/*****************************************************************************/
                                                         /** Fim da Include **/

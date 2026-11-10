/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: AB0410.i
**
**       DATA....: Agosto de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Integra‡Æo Frotas com EMS
**
*****************************************************************************/
                                                /** Defini‡Æo de Vari veis **/
DEFINE VARIABLE c-liter-sel   AS CHARACTER FORMAT "x(09)" NO-UNDO.
DEFINE VARIABLE c-liter-imp   AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE c-destino     AS CHARACTER FORMAT "x(09)" NO-UNDO.
DEFINE VARIABLE c-liter-un    AS CHARACTER FORMAT "x(16)" NO-UNDO.
DEFINE VARIABLE cUnidNegocIni AS CHARACTER FORMAT "x(03)" NO-UNDO.
DEFINE VARIABLE cUnidNegocFim AS CHARACTER FORMAT "x(03)" NO-UNDO.
DEFINE VARIABLE cFaixa        AS CHARACTER FORMAT "x(06)" INITIAL "|<  >|" NO-UNDO.
/*****************************************************************************/
                                                     /** Form de Parƒmetros **/

form   /*PAR¶MTEROS*/
       skip(1)
       c-liter-sel              AT 09    no-label
       skip(1)
       tt-param.dataMovimento   COLON 30  
       tt-param.estabInicial    COLON 30  "|<  >|" AT 50 
       tt-param.estabFinal      NO-LABEL 
       tt-param.depositoIni     colon 30  "|<  >|" AT 50
       tt-param.depositoFim     NO-LABEL 
       &IF DEFINED(bf_mnt_ems206b) &THEN
       c-liter-un    COLON 13   NO-LABEL 
       cUnidNegocIni COLON 30   NO-LABEL cFaixa NO-LABEL AT 50 
       cUnidNegocFim            NO-LABEL
       &ENDIF    
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
DO:
form ErrorSequence    
     ErrorNumber      
     ErrorDescription
    with width 132 no-attr-space no-box down frame f-erro stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-erro:HANDLE).

END. 

/*****************************************************************************/
                                               /** Literais Form Parƒmetros **/
{utp/ut-liter.i Usu rio * l}
assign tt-param.usuario:label in frame f-param-definidos = trim(return-value).

{utp/ut-liter.i Destino * l}
assign c-destino:label in frame f-param-definidos = trim(return-value).

{utp/ut-liter.i PAR¶METRO * R}
assign c-liter-sel = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * R}
assign c-liter-imp = trim(return-value).

{utp/ut-liter.i Unidade_Neg¢cio: * R}
assign c-liter-un = trim(return-value).

{utp/ut-liter.i Data Final Movimento * R}
ASSIGN tt-param.dataMovimento:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i Estabelecimento * R}
ASSIGN tt-param.estabInicial:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i Dep¢sito * R}
ASSIGN tt-param.depositoIni:LABEL IN FRAME f-param-definidos = trim(return-value).

/*****************************************************************************/
                                                         /** Fim da Include **/

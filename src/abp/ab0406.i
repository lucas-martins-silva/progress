/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: AB0405.i
**
**       DATA....: Outubro de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Gera‡Æo Eventos Programados
**
*****************************************************************************/
                                                /** Defini‡Æo de Vari veis **/
DEFINE VARIABLE c-liter-sel   AS CHARACTER FORMAT "x(09)" NO-UNDO.
DEFINE VARIABLE c-liter-par   AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE c-liter-imp   AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE c-destino     AS CHARACTER FORMAT "x(09)" NO-UNDO.
DEFINE VARIABLE c-liter-un    AS CHARACTER FORMAT "x(16)" NO-UNDO.
DEFINE VARIABLE cUnidNegocIni AS CHARACTER FORMAT "x(03)" NO-UNDO.
DEFINE VARIABLE cUnidNegocFim AS CHARACTER FORMAT "x(03)" NO-UNDO.
DEFINE VARIABLE cFaixa        AS CHARACTER FORMAT "x(06)" INITIAL "|<  >|" NO-UNDO.
/*****************************************************************************/
                                                     /** Form de Parƒmetros **/

form   /*SELE€ÇO*/
       skip(1)
       c-liter-sel              AT 09    no-label
       skip(1)
       tt-param.dataIni         format "99/99/9999" COLON 30  "|<  >|" AT 50 
       tt-param.dataFim         format "99/99/9999" NO-LABEL 
       tt-param.docIni          COLON 30  "|<  >|" AT 50 
       tt-param.docFim          NO-LABEL
       tt-param.EmpIni          COLON 30  "|<  >|" AT 50 
       tt-param.EmpFim          NO-LABEL 
       tt-param.EqptoIni        COLON 30  "|<  >|" AT 50 
       tt-param.EqptoFim        NO-LABEL 
       tt-param.EventIni        COLON 30  "|<  >|" AT 50 
       tt-param.EventFim        NO-LABEL 
       tt-param.SubIni          COLON 30  "|<  >|" AT 50 
       tt-param.SubFim          NO-LABEL 
       &IF DEFINED(bf_mnt_ems206b) &THEN
       c-liter-un    COLON 13   NO-LABEL 
       cUnidNegocIni COLON 30   NO-LABEL cFaixa NO-LABEL AT 50 
       cUnidNegocFim            NO-LABEL
       &ENDIF
       /*PAR¶METRO*/
       skip(1)
       c-liter-par              AT 09    NO-LABEL
       skip(1)
       tt-param.lVencido        COLON 30
       tt-param.lVencer         COLON 30
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
form RowErrorsEqpto.ep-codigo        
     RowErrorsEqpto.cod-eqpto    AT 09   
     RowErrorsEqpto.ErrorNumber  AT 26    
     RowErrorsEqpto.ErrorDescription  AT 38  format "x(95)"
    with width 132 no-attr-space no-box down frame f-erro stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-erro:HANDLE).

END. 

{utp/ut-liter.i "Emp."}
assign RowErrorsEqpto.ep-codigo:label in frame f-erro = trim(return-value).
{utp/ut-liter.i "Eqpto"}
assign RowErrorsEqpto.cod-eqpto :label in frame f-erro = trim(return-value).
{utp/ut-liter.i "Erro"}
assign RowErrorsEqpto.ErrorNumber:label in frame f-erro = trim(return-value).
{utp/ut-liter.i "Descri‡Æo"}
assign RowErrorsEqpto.ErrorDescription:label in frame f-erro = trim(return-value).

/*****************************************************************************/
                                               /** Literais Form Parƒmetros **/
{utp/ut-liter.i Usu rio * l}
assign tt-param.usuario:label in frame f-param-definidos = trim(return-value).

{utp/ut-liter.i Destino * l}
assign c-destino:label in frame f-param-definidos = trim(return-value).

{utp/ut-liter.i SELE€ÇO * R}
assign c-liter-sel = trim(return-value).

{utp/ut-liter.i PAR¶METROS * R}
assign c-liter-par = trim(return-value).

{utp/ut-liter.i IMPRESSÇO * R}
assign c-liter-imp = trim(return-value).

{utp/ut-liter.i Unidade_Neg¢cio: * R}
assign c-liter-un = trim(return-value).

{utp/ut-liter.i Data * R}
ASSIGN tt-param.dataIni:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i Empresa * R}
ASSIGN tt-param.EmpIni:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i Equipamento * R}
ASSIGN tt-param.EqptoIni:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i Evento * R}
ASSIGN tt-param.eventIni:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i "Sub Sistema" * R}
ASSIGN tt-param.subIni:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i Documento * R}
ASSIGN tt-param.docIni:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i "Eventos Vencidos" * R}
ASSIGN tt-param.lVencido:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i "Eventos a Vencer" * R}
ASSIGN tt-param.lVencer:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i "Sim/NÆo" * R}
ASSIGN tt-param.lVencido:FORMAT IN FRAME f-param-definidos = trim(return-value)
       tt-param.lVencer:FORMAT IN FRAME f-param-definidos  = trim(return-value).


/*****************************************************************************/
                                                         /** Fim da Include **/

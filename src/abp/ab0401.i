/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: AB0401.i
**
**       DATA....: Junlho de 2003
**
**       AUTOR...: Marcio Willwock - Manufatura - DATASUL S.A.
**
**       OBJETIVO: Atualiza‡Æo de Apontamentos de Abastecimento / Lubrifica‡Æo
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
       tt-param.dataIni         format "99/99/9999" COLON 30  "|<  >|" AT 53 
       tt-param.dataFim         format "99/99/9999" NO-LABEL 
       tt-param.iEmpIni         COLON 30  "|<  >|" AT 53 
       tt-param.iEmpFim         NO-LABEL 
       tt-param.cEstabIni       COLON 30  "|<  >|" AT 53 
       tt-param.cEstabFim       NO-LABEL 
       tt-param.cEqptoIni       COLON 30  "|<  >|" AT 53 
       tt-param.cEqptoFim       NO-LABEL 
       tt-param.cTagIni         COLON 30  "|<  >|" AT 53 
       tt-param.cTagFim         NO-LABEL
       tt-param.cCCini          COLON 30  "|<  >|" AT 53 
       tt-param.cCCfim          NO-LABEL
       tt-param.cPostoIni       COLON 30  "|<  >|" AT 53 
       tt-param.cPostoFim       NO-LABEL
       &IF DEFINED(bf_mnt_ems206b) &THEN
       c-liter-un    COLON 13   NO-LABEL 
       cUnidNegocIni COLON 30   NO-LABEL cFaixa NO-LABEL AT 53 
       cUnidNegocFim            NO-LABEL
       &ENDIF
       /*PAR¶METRO*/
       skip(1)
       c-liter-par              AT 09    NO-LABEL
       skip(1)
       tt-param.iConsiste       COLON 30 FORMAT '>9' "-"
       tt-param.descConsiste    NO-LABEL
       tt-param.lFicha          COLON 30
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
     ErrorDescription format "x(105)"
    with width 132 no-attr-space no-box down frame f-erro stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-erro:HANDLE).

END. 

{utp/ut-liter.i "Seq."}
assign ErrorSequence:label in frame f-erro = trim(return-value).
{utp/ut-liter.i "Erro"}
assign ErrorNumber:label in frame f-erro = trim(return-value).
{utp/ut-liter.i "Descri‡Æo"}
assign ErrorDescription:label in frame f-erro = trim(return-value).

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

{utp/ut-field.i mgfro mab-abastec-lubrific dat-movto 1}
ASSIGN tt-param.dataIni:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i Empresa * R}
ASSIGN tt-param.iEmpIni:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i Estabelecimento * R}
ASSIGN tt-param.cEstabIni:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i Equipamento * R}
ASSIGN tt-param.cEqptoIni:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i TAG * R}
ASSIGN tt-param.cTagIni:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i "Consiste Apontamentos" * R}
ASSIGN tt-param.iConsiste:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i "Consistir Fichas" * R}
ASSIGN tt-param.lFicha:LABEL IN FRAME f-param-definidos = trim(return-value).

{utp/ut-liter.i "Sim/NÆo" * R}
ASSIGN tt-param.lFicha:FORMAT IN FRAME f-param-definidos = trim(return-value).

/*****************************************************************************/
                                                         /** Fim da Include **/

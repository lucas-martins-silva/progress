/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: AB0618.i
**
**       DATA....: Julho de 2006
**
**       AUTOR...: DATASUL S.A.
**
**       OBJETIVO: Forms da Consulta Hist¢rico de Vida do Equipamento
**
*****************************************************************************/
             /** Defini‡Æo de Vari veis **/
DEFINE VARIABLE c-liter-imp    AS CHARACTER FORMAT "x(14)"            NO-UNDO.
DEFINE VARIABLE c-liter-par    AS CHARACTER FORMAT "x(14)"            NO-UNDO.
DEFINE VARIABLE c-destino      AS CHARACTER FORMAT "x(09)"            NO-UNDO.
DEFINE VARIABLE c-fora         AS CHARACTER FORMAT "x(01)"            NO-UNDO.
DEFINE VARIABLE cModelo        LIKE mab-model.des-model               NO-UNDO.
DEFINE VARIABLE cDescTip       AS CHARACTER FORMAT "x(30)"            NO-UNDO.
DEFINE VARIABLE dtInicio       AS DATE FORMAT "99/99/9999"            NO-UNDO.
DEFINE VARIABLE contInicial    LIKE mab-eqpto.val-hodom-horim-inicial NO-UNDO.
DEFINE VARIABLE contInicialSec LIKE mab-eqpto.val-hodom-horim-sec     NO-UNDO.
DEFINE VARIABLE deUso          LIKE mab-eqpto.val-km-inicial          NO-UNDO.
DEFINE VARIABLE deUsoSec       LIKE mab-eqpto.val-km-sec              NO-UNDO.
DEFINE VARIABLE cDescUn        LIKE mab-model.un                      NO-UNDO.
DEFINE VARIABLE cDescUnSec     LIKE mab-model.un                      NO-UNDO.
DEFINE VARIABLE cDescTpDoc     AS CHARACTER FORMAT "x(03)"            NO-UNDO.
DEFINE VARIABLE cDescUn2       AS CHARACTER FORMAT "x(02)"            NO-UNDO.
DEFINE VARIABLE cDescUnSec2    AS CHARACTER FORMAT "x(02)"            NO-UNDO.
DEFINE VARIABLE cDescStatus    AS CHARACTER FORMAT "X(30)"            NO-UNDO.

/** Parƒmetros **/
FORM "PAR¶METROS" AT 12 SKIP
     "----------" AT 12 SKIP(1)
     tt-param.data-ini AT 10
     "|<  >|"          AT 32
     tt-param.data-fim NO-LABEL SKIP
     tt-param.hora-ini AT 10
     "|<  >|"          AT 32
     tt-param.hora-fim NO-LABEL SKIP
     tt-param.docto-ini AT 11
     "|<  >|"           AT 32
     tt-param.docto-fim NO-LABEL SKIP
    with width 132 no-attr-space NO-BOX SIDE-LABELS frame f-param-definidos stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-definidos:HANDLE).


/** ImpressÆo **/
form tt-param.ep-codigo TO 43
     " - " TO 46
     tt-param.cod-eqpto NO-LABEL TO 62
     " - " TO 65
     cModelo NO-LABEL TO 105 SKIP
     cDescTip AT 31 SKIP
     dtInicio AT 31 SKIP
     contInicial AT 23
     cDescUn AT 55 NO-LABEL SKIP
     deUso AT 28
     cDescUn2 AT 55 NO-LABEL SKIP
     contInicialSec AT 12
     cDescUnSec AT 55 NO-LABEL SKIP
     deUsoSec AT 17
     cDescUnSec2 AT 55 NO-LABELS SKIP
    with width 132 no-attr-space NO-BOX SIDE-LABELS PAGE-TOP TOP-ONLY frame f-visoes stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-visoes:HANDLE).

     
form tt-digita.dat-movto       
     tt-digita.hra-inicial     
     tt-digita.val-hodom-horim 
     cDescUN                   
     tt-digita.val-km-real    
     tt-digita.val-livre-1
     cDescUnSec            
     tt-digita.val-livre-2 
     tt-digita.num-docto       
     cDescTpDoc                
     tt-digita.log-abastec-prim
     cDescStatus
    with width 132 no-attr-space no-box down frame f-dados stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-dados:HANDLE).


/*****************************************************************************/
                                               /** Literais Form Parƒmetros **/
{utp/ut-liter.i Equipamento * l}
ASSIGN tt-param.ep-codigo:LABEL IN FRAME f-visoes = RETURN-VALUE.
{utp/ut-liter.i Tipo_Equipamento * l}
ASSIGN cDescTip:LABEL IN FRAME f-visoes = RETURN-VALUE.
{utp/ut-liter.i Data_Inicial * l}
ASSIGN dtInicio:LABEL IN FRAME f-visoes = RETURN-VALUE.
{utp/ut-liter.i Contador_Inicial * l}
ASSIGN contInicial:LABEL IN FRAME f-visoes = RETURN-VALUE.
{utp/ut-liter.i Uso_Inicial * l}
ASSIGN deUso:LABEL IN FRAME f-visoes = RETURN-VALUE.
{utp/ut-liter.i Origem *}
ASSIGN cDescTpDoc:LABEL IN FRAME f-dados = RETURN-VALUE.
{utp/ut-liter.i Data * l}
ASSIGN tt-param.data-ini:LABEL IN FRAME f-param-definidos = RETURN-VALUE.
{utp/ut-liter.i Hora * l}
ASSIGN tt-param.hora-ini:LABEL IN FRAME f-param-definidos = RETURN-VALUE.
{utp/ut-liter.i Documento * l}
ASSIGN tt-param.docto-ini:LABEL IN FRAME f-param-definidos = RETURN-VALUE.

{utp/ut-field.i movfro mab-abastec-lubrific idi-consist 1}
assign cDescStatus:LABEL IN FRAME f-dados  = trim(return-value).

/*****************************************************************************/
                                                    /** Literais Form Dados **/
{utp/ut-liter.i Contador_Sec * l}
ASSIGN tt-digita.val-livre-1:LABEL IN FRAME f-dados = RETURN-VALUE.
{utp/ut-liter.i Uso_Real_Sec * l}
ASSIGN tt-digita.val-livre-2:LABEL IN FRAME f-dados = RETURN-VALUE.

/*****************************************************************************/
                                                         /** Fim da Include **/

/****************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: AB0702.i
**
**       DATA....: Janeiro de 2004
**
**       AUTOR...: DATASUL S.A.
**
**       OBJETIVO: Importaá∆o Percurso Rodado
**       Versao..: 
**
*****************************************************************************/
                                                   /** Definiá∆o vari†veis **/
DEFINE VARIABLE c-liter-par    AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE c-liter-sel    AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE c-liter-log    AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE c-destino      AS CHARACTER FORMAT "x(09)" NO-UNDO.
DEFINE VARIABLE c-imprime      AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-execucao     AS CHARACTER FORMAT "x(10)" NO-UNDO.
DEFINE VARIABLE c-tit-linha    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tit-emp      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tit-eqpto    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tit-data     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tit-km       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-tit-erro     AS CHARACTER  NO-UNDO.
/****************************************************************************/
                                                      /** Frame ParÉmetros **/
form /*PAR∂METRO*/
     skip(1)
     c-liter-par     AT 09       NO-LABEL
     skip(1)
     tt-param.dtInicial    COLON 30 
     tt-param.arq-entrada  COLON 30 
     /*SELEÄ«O*/
     skip(1)
     c-liter-sel     AT 09       NO-LABEL
     skip(1)
     tt-param.empIni       COLON 30  "|<  >|" AT 50
     tt-param.empFim       NO-LABEL                
     tt-param.estabIni     COLON 30  "|<  >|" AT 50
     tt-param.estabFim     NO-LABEL                
     tt-param.grupoIni     COLON 30  "|<  >|" AT 50
     tt-param.grupoFim     NO-LABEL                
     tt-param.modeloIni    COLON 30  "|<  >|" AT 50
     tt-param.modeloFim    NO-LABEL                   
    /*LOG*/
     skip(1)   
     c-liter-log     AT 09       no-label
     skip(1)
     c-imprime             colon 30  
     c-destino             colon 30 " - " tt-param.arq-destino NO-LABEL
     c-execucao            colon 30
     tt-param.usuario      colon 30
     skip(1)        
     with width 132 side-labels frame f-param-definidos stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-definidos:HANDLE).

/****************************************************************************/
                                                   /** Literais ParÉmetros **/
{utp/ut-liter.i "Data Inicial"}
assign tt-param.dtInicial:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Estabelecimento"}
assign tt-param.estabIni:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Grupo Equipamento"}
assign tt-param.grupoIni:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Modelo Equipamento"}
assign tt-param.modeloini:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Usu†rio" * l}
assign tt-param.usuario:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Entrada" * l}
assign tt-param.arq-entrada:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Destino" * l}
assign c-destino:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Imprime" * l}
assign c-imprime:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Todos,Rejeitados" *}
assign c-imprime = entry(tt-param.todos,return-value).
{utp/ut-liter.i "Execuá∆o" * l}
assign c-execucao:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "On-Line,Batch" *}
assign c-execucao = entry(tt-param.execucao,return-value).
{utp/ut-liter.i "PAR∂METROS" * R}
assign c-liter-par = return-value.
{utp/ut-liter.i "SELEÄ«O" * R}
assign c-liter-sel = return-value.
{utp/ut-liter.i "LOG" * R}
assign c-liter-log = return-value.
/****************************************************************************/     
                                                       /** Frame Impress∆o **/
form ttKMImport.i-linha    space(8)
     ttKMImport.ep-codigo 
     ttKMImport.cod-eqpto
     ttKMImport.dat-movto
     ttKMImport.val-km-real
     RowErrorsAux.ErrorNumber
     RowErrorsAux.ErrorDescription format "x(55)"
    with width 132 no-attr-space no-box NO-LABELS down frame f-km stream-io.
/****************************************************************************/
                                                /** Frame T°tulo Impress∆o **/
form c-tit-linha
     c-tit-emp
     c-tit-eqpto  format "x(16)"
     c-tit-data   format "x(10)"
     c-tit-km     format "x(12)"
     c-tit-erro   format "x(65)"
     SKIP
    with width 132 no-attr-space NO-BOX PAGE-TOP TOP-ONLY frame f-titulo stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-titulo:HANDLE).

/****************************************************************************/
                                             /** Literais Titulo Impress∆o **/
{utp/ut-liter.i "Linha" * l}
assign c-tit-linha:label in frame f-titulo = return-value.
{utp/ut-liter.i "Empresa" * l}
assign c-tit-emp:label in frame f-titulo = return-value
       tt-param.empIni:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Equipamento" * l}
assign c-tit-eqpto:label in frame f-titulo = return-value.
{utp/ut-liter.i "Movimento" * l}
assign c-tit-data:label in frame f-titulo = return-value.
{utp/ut-liter.i "Percurso" MAB l}
assign c-tit-km:label in frame f-titulo = return-value.
{utp/ut-liter.i "Erro" * l}
assign c-tit-erro:label in frame f-titulo = return-value.

/****************************************************************************/
                                                           /** Frame Erros **/
form RowErrorsAux.ErrorSequence    at 5
     RowErrorsAux.ErrorNumber      
     RowErrorsAux.ErrorDescription format "x(40)"
    with width 132 no-attr-space no-box down frame f-erro stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-erro:HANDLE).


{utp/ut-liter.i "Seq."}
assign RowErrorsAux.ErrorSequence:label in frame f-erro = trim(return-value).
{utp/ut-liter.i "Erro"}
assign RowErrorsAux.ErrorNumber:label in frame f-erro = trim(return-value).
{utp/ut-liter.i "Descriá∆o"}
assign RowErrorsAux.ErrorDescription:label in frame f-erro = trim(return-value).
/****************************************************************************/
                                            /** Final da include de frames **/

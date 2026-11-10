/****************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*****************************************************************************
**
**       PROGRAMA: AB0703.i
**
**       DATA....: Janeiro de 2004
**
**       AUTOR...: DATASUL S.A.
**
**       OBJETIVO: Gera‡Æo Percurso Rodado Conforme Viagens
**       Versao..: 
**
*****************************************************************************/
                                                   /** Defini‡Æo vari veis **/
DEFINE VARIABLE c-liter-sel     AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE c-liter-imp     AS CHARACTER FORMAT "x(14)" NO-UNDO.
DEFINE VARIABLE c-destino       AS CHARACTER FORMAT "x(09)" NO-UNDO.
DEFINE VARIABLE cDescTpPercurso AS CHARACTER FORMAT "x(40)" NO-UNDO.
DEFINE VARIABLE c-liter-un      AS CHARACTER FORMAT "x(16)" NO-UNDO.
DEFINE VARIABLE cUnidNegocIni   AS CHARACTER FORMAT "x(03)" NO-UNDO.
DEFINE VARIABLE cUnidNegocFim   AS CHARACTER FORMAT "x(03)" NO-UNDO.
DEFINE VARIABLE cFaixa          AS CHARACTER FORMAT "x(06)" INITIAL "|<  >|" NO-UNDO.
/****************************************************************************/
                                                      /** Frame Parƒmetros **/
form /*SELE€ÇO*/
     skip(1)
     c-liter-sel     AT 09       NO-LABEL
     skip(1)
     tt-param.dtInicial    format "99/99/9999" COLON 30  "|<  >|" AT 50
     tt-param.dtFinal      format "99/99/9999" NO-LABEL                
     tt-param.empIni       COLON 30  "|<  >|" AT 50
     tt-param.empFim       NO-LABEL                
     tt-param.estabIni     COLON 30  "|<  >|" AT 50
     tt-param.estabFim     NO-LABEL                
     tt-param.grupoIni     COLON 30  "|<  >|" AT 50
     tt-param.grupoFim     NO-LABEL                
     tt-param.modeloIni    COLON 30  "|<  >|" AT 50
     tt-param.modeloFim    NO-LABEL 
     tt-param.eqptoIni     COLON 30  "|<  >|" AT 50
     tt-param.eqptoFim     NO-LABEL
     &IF DEFINED(bf_mnt_ems206b) &THEN
     c-liter-un    COLON 13   NO-LABEL 
     cUnidNegocIni COLON 30   NO-LABEL cFaixa NO-LABEL AT 50 
     cUnidNegocFim            NO-LABEL
     &ENDIF
     /*IMPRESSÇO*/
     skip(1)
     c-liter-imp     AT 09    no-label
     skip(1)
     c-destino             COLON 30 " - " tt-param.arquivo NO-LABEL
     tt-param.usuario      COLON 30
     skip(1)       
     with width 132 side-labels frame f-param-definidos stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param-definidos:HANDLE).

/****************************************************************************/
                                                   /** Literais Parƒmetros **/
{utp/ut-liter.i "Per¡odo"}
assign tt-param.dtInicial:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Empresa"}
assign tt-param.empIni:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Estabelecimento"}
assign tt-param.estabIni:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Grupo Equipamento"}
assign tt-param.grupoIni:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Modelo Equipamento"}
assign tt-param.modeloini:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Equipamento"}
assign tt-param.eqptoIni:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Usu rio" * l}
assign tt-param.usuario:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "Destino" * l}
assign c-destino:label in frame f-param-definidos = return-value.
{utp/ut-liter.i "SELE€ÇO" * R}
assign c-liter-sel = return-value.
{utp/ut-liter.i "IMPRESSÇO" * R}
assign c-liter-imp = return-value.
{utp/ut-liter.i Unidade_Neg¢cio: * R}
assign c-liter-un = trim(return-value).
/****************************************************************************/
                                                           /** Frame Erros **/
form RowErrors.ErrorSequence
     RowErrors.ErrorNumber      
     RowErrors.ErrorDescription format "x(100)"
    with width 132 no-attr-space no-box down frame f-erro stream-io.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-erro:HANDLE).


{utp/ut-liter.i "Seq."}
assign RowErrors.ErrorSequence:label in frame f-erro = trim(return-value).
{utp/ut-liter.i "Erro"}
assign RowErrors.ErrorNumber:label in frame f-erro = trim(return-value).
{utp/ut-liter.i "Descri‡Æo"}
assign RowErrors.ErrorDescription:label in frame f-erro = trim(return-value).
/****************************************************************************/
                                            /** Final da include de frames **/

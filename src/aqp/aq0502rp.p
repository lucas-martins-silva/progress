/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0502RP 2.00.00.006 } /*** 010006 ***/ 

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0502RP MAQ}
&ENDIF 

/******************************************************************************
**
**       Programa: AQ0502RP.P
**
**       Data....: 23/06/2016.
**
**       Objetivo: Relatorio de Produtores do Ponto de Coleta
**                 M¢dulo Aquisi‡Æo de Produtos Rurais.
** 
******************************************************************************/
FUNCTION fn-logical RETURNS CHARACTER
  ( l-value as LOG )  FORWARD.

{utp/ut-glob.i}
{include/i-rpvar.i}
{include/i-rpcab.i}
{aqp/aq0502.i}   /* tt-param, tt-digita, tt-raw-digita */ 
{aqp/aq0502rp.i} /* Definicoes relatorio */ 


IF NOT VALID-HANDLE(h-acomp) THEN 
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

IF NOT VALID-HANDLE(h-utapi033) THEN
    RUN utp/utapi033.p PERSIST SET h-utapi033.

/* PARAMETERS  */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

RUN pi-inicializar in h-acomp (INPUT ENTRY(2,c-titulo-relat,"-")).

{utp/ut-liter.i Aquisi‡Æo_de_Produtos_Rurais MAQ}    
ASSIGN c-programa     = "AQ0502"
       c-versao       = "I.00"
       c-revisao      = "001"
       c-sistema      = RETURN-VALUE
       c-rodape       = "TOTVS - " + c-programa  +  " - V:" + c-versao.
       c-rodape       = FILL("-", 132 - LENGTH(c-rodape)) + c-rodape.

FOR FIRST empresa FIELDS(razao-social) NO-LOCK 
    WHERE empresa.ep-codigo = i-ep-codigo-usuario:
    ASSIGN c-empresa = empresa.razao-social.
END.

DO ON ERROR UNDO, RETURN ERROR ON STOP  UNDO, RETURN ERROR: 
    DO i-coluna = 1 TO {&COLUNAS}:
        CASE i-coluna:
            WHEN 6 THEN
                ASSIGN c-format    = ">>>,>>>,>>9"
                       c-data-type = "INTEGER".
           WHEN 11 THEN
                ASSIGN c-format    = ">>,>>>,>>>,>>9.9999"
                       c-data-type = "DECINAL".
            OTHERWISE 
                ASSIGN c-format    = " "
                       c-data-type = "CHARACTER".
        END CASE.

        /* cria colunas planilha */
        RUN piColumn IN h-utapi033 (INPUT i-coluna,
                                    INPUT c-data-type, 
                                    INPUT c-label-coluna[i-coluna], 
                                    INPUT c-format, 
                                    INPUT REPLACE(STRING(d-largura[i-coluna] * 5.6),",",".")).
    END.

    FOR FIRST tt-param:
        FOR EACH pto-coleta FIELDS(cod-pto-coleta des-pto-coleta log-pto-coleta-coletiv log-livre-1) NO-LOCK 
           WHERE pto-coleta.cod-pto-coleta >= tt-param.cod-pto-coleta-ini
             AND pto-coleta.cod-pto-coleta <= tt-param.cod-pto-coleta-fim,
            EACH produt-pto-coleta  FIELDS(cod-pto-coleta cdn-produt-rural cod-propried log-respons log-livre-1) NO-LOCK
           WHERE produt-pto-coleta.cod-pto-coleta = pto-coleta.cod-pto-coleta 
             AND produt-pto-coleta.cdn-produt-rural >= tt-param.cdn-produt-rural-ini
             AND produt-pto-coleta.cdn-produt-rural <= tt-param.cdn-produt-rural-fim,
            EACH propried-rural FIELDS(des-propried log-livre-1) NO-LOCK  
           WHERE propried-rural.cod-propried = produt-pto-coleta.cod-propried 
             AND propried-rural.cod-propried >= tt-param.cod-propried-ini
             AND propried-rural.cod-propried <= tt-param.cod-propried-fim,
            EACH emitente FIELDS(nome-emit) NO-LOCK   
           WHERE emitente.cod-emitente = produt-pto-coleta.cdn-produt-rural:
           
           IF tt-param.l-somente-pto-coletivo AND NOT pto-coleta.log-pto-coleta-coletiv THEN
               NEXT.                        
           IF tt-param.l-somente-produt-respons AND NOT produt-pto-coleta.log-respons THEN 
               NEXT.

           /* Inativos */
           IF NOT tt-param.l-inativos THEN DO:
             IF NOT pto-coleta.log-livre-1        THEN NEXT. /* Ponto de Coleta   */
             IF NOT propried-rural.log-livre-1    THEN NEXT. /* Propriedade Rural */
             IF NOT produt-pto-coleta.log-livre-1 THEN NEXT. /* Relacionamento    */

             /* Produtor Rural */
             IF CAN-FIND(FIRST produt-rural 
                         WHERE produt-rural.cdn-produt-rural = produt-pto-coleta.cdn-produt-rural 
                           AND NOT produt-rural.log-livre-1) THEN NEXT. 
           END.
                
           FOR FIRST pto-rota-coleta FIELDS() NO-LOCK
               WHERE pto-rota-coleta.cod-pto-coleta = produt-pto-coleta.cod-pto-coleta: END.
           IF AVAIL pto-rota-coleta THEN DO:
                FOR EACH pto-rota-coleta FIELDS(cod-rota)NO-LOCK
                    WHERE pto-rota-coleta.cod-pto-coleta = produt-pto-coleta.cod-pto-coleta
                      AND pto-rota-coleta.cod-rota      >= tt-param.cod-rota-ini
                      AND pto-rota-coleta.cod-rota      <= tt-param.cod-rota-fim:
                    FOR FIRST rota-coleta FIELDS(cod-rota des-rota val-percur) NO-LOCK
                        WHERE rota-coleta.cod-rota = pto-rota-coleta.cod-rota: 
                        RUN pi-imprime-linhas IN THIS-PROCEDURE.
                    END.
                END.
           END.
           ELSE DO:           
              RUN pi-imprime-linhas IN THIS-PROCEDURE.
           END.   
        END.
        RUN pi-imprime-parametros IN THIS-PROCEDURE.
        RUN piProcessa            IN h-utapi033 (INPUT-OUTPUT tt-param.arquivo, INPUT "AQ0502", INPUT c-titulo-relat).    
    END.
END.

DELETE PROCEDURE h-utapi033.
ASSIGN h-utapi033 = ?.

RUN pi-finalizar in h-acomp.

RETURN "OK".


PROCEDURE pi-imprime-linhas:
/*------------------------------------------------------------------------------
  Purpose: imprimir linhas do relatorio.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
    RUN piNewLine IN h-utapi033.
    DO i-coluna = 1 TO {&COLUNAS}:
        CASE i-coluna:
            WHEN 1  THEN ASSIGN c-valor-campo = pto-coleta.cod-pto-coleta.
            WHEN 2  THEN ASSIGN c-valor-campo = pto-coleta.des-pto-coleta.
            WHEN 3  THEN ASSIGN c-valor-campo = fn-logical(pto-coleta.log-pto-coleta-coletiv).
            WHEN 4  THEN ASSIGN c-valor-campo = produt-pto-coleta.cod-propried.
            WHEN 5  THEN ASSIGN c-valor-campo = propried-rural.des-propried.
            WHEN 6  THEN ASSIGN c-valor-campo = STRING(produt-pto-coleta.cdn-produt-rural).
            WHEN 7  THEN ASSIGN c-valor-campo = emitente.nome-emit.
            WHEN 8  THEN ASSIGN c-valor-campo = fn-logical(produt-pto-coleta.log-respons).
            WHEN 9  THEN ASSIGN c-valor-campo = IF AVAIL pto-rota-coleta AND AVAIL rota-coleta THEN rota-coleta.cod-rota ELSE "".
            WHEN 10 THEN ASSIGN c-valor-campo = IF AVAIL pto-rota-coleta AND AVAIL rota-coleta THEN rota-coleta.des-rota ELSE "".
            WHEN 11 THEN ASSIGN c-valor-campo = IF AVAIL pto-rota-coleta AND AVAIL rota-coleta THEN STRING(rota-coleta.val-percur) ELSE "0".
            OTHERWISE    ASSIGN c-valor-campo = "".
        END CASE.
        RUN piLine IN h-utapi033(INPUT i-coluna, INPUT c-valor-campo).
    END.
END PROCEDURE.



PROCEDURE pi-imprime-parametros:
/*------------------------------------------------------------------------------
  Purpose: imprimir parametros utilizados para geracao do relatorio.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
    DEFINE VARIABLE c-lbl-ate         AS CHARACTER          NO-UNDO.
    DEFINE VARIABLE iParamColumnWidth AS INTEGER EXTENT 2   NO-UNDO.
    DEFINE VARIABLE c-label-params    AS CHARACTER EXTENT 3 NO-UNDO.
    
    
    {utp/ut-liter.i at‚ *}
    ASSIGN c-lbl-ate = RETURN-VALUE.    
    {utp/ut-liter.i "Listar somente pontos coletivos" *}
    ASSIGN c-label-params[1] = RETURN-VALUE.
    {utp/ut-liter.i "Listar somente produtor respons vel" *}
    ASSIGN c-label-params[2] = RETURN-VALUE.   
    {utp/ut-liter.i "Listar Inativos" *}
    ASSIGN c-label-params[3] = RETURN-VALUE.   
    
   {utp/ut-liter.i SELE€ÇO *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.
           
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-coluna[1]
           tt-param-planilha.valor     = STRING(tt-param.cod-pto-coleta-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cod-pto-coleta-fim).

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-coluna[4] 
           tt-param-planilha.valor     = STRING(tt-param.cod-propried-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cod-propried-fim).


    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-coluna[6]
           tt-param-planilha.valor     = STRING(tt-param.cdn-produt-rural-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cdn-produt-rural-fim).
    
 
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-coluna[9]
           tt-param-planilha.valor     = tt-param.cod-rota-ini + " " + c-lbl-ate + " " + tt-param.cod-rota-fim. 
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = ""
           tt-param-planilha.valor     = "".
           
    {utp/ut-liter.i PAR¶METROS *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.
           
    {utp/ut-liter.i Sim/NÆo *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-params[1]
           tt-param-planilha.valor     = fn-logical(tt-param.l-somente-pto-coletivo).

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-params[2]
           tt-param-planilha.valor     = fn-logical(tt-param.l-somente-produt-respons).

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-params[3]
           tt-param-planilha.valor     = fn-logical(tt-param.l-inativos).

    ASSIGN iParamColumnWidth[1] = 150
           iParamColumnWidth[2] = 200.

    RUN setParamColumnWidth IN h-utapi033 (INPUT iParamColumnWidth).
    RUN setTTParam          IN h-utapi033 (INPUT TABLE tt-param-planilha).    

    RETURN "OK":U.
END PROCEDURE.



/* ************************  Function Implementations ***************** */


FUNCTION fn-logical RETURNS CHARACTER
  ( l-value as LOG ) :
    
    RETURN IF l-value THEN c-sim-nao[1] ELSE c-sim-nao[2].
END FUNCTION.





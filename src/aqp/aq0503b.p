/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0503B 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aq0201ca MAQ}
&ENDIF

/*****************************************************************************
**
**       Programa: AQ0503a
**
**       Objetivo: Geração de relatorio em planilha para o programa aq0503
**       Parametros: 
**
*****************************************************************************/

{include/i-rpvar.i}


/* ****************************** Definitions ****************************** */
{aqp/aq0503.i}
{aqp/aq0503b.i}

DEFINE VARIABLE i-colunas   AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-coluna    AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-linha     AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-format    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-data-type AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-utapi033  AS HANDLE    NO-UNDO.

DEFINE INPUT PARAMETER TABLE FOR tt-param.
DEFINE INPUT PARAMETER TABLE FOR tt-carga-preco.

IF NOT VALID-HANDLE(h-utapi033) THEN
    RUN utp/utapi033.p PERSISTENT SET h-utapi033.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

FIND FIRST tt-param NO-ERROR.    

IF NOT AVAIL tt-param THEN RETURN "NOK":U.
    
RUN pi-executar IN THIS-PROCEDURE.

IF VALID-HANDLE(h-utapi033) THEN 
  DELETE OBJECT h-utapi033.

RETURN "OK":U.


PROCEDURE pi-executar:
/*------------------------------------------------------------------------------
  Purpose: Procedure responsavel pea execucao da geracao da planilha
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
    DEFINE VARIABLE qh AS HANDLE NO-UNDO.
    DEFINE VARIABLE bh AS HANDLE NO-UNDO.
    
    ASSIGN i-colunas      = EXTENT(c-titulo-coluna) /* quantidade de colunas */
           c-periodo      = c-periodo + ": " + STRING(tt-param.dt-trans-ini,"99/99/9999") + " - " + STRING(tt-param.dt-trans-fim,"99/99/9999")
           c-titulo-relat = c-titulo-relat + " - " + c-periodo.      

    CREATE BUFFER bh FOR TABLE "tt-carga-preco":U.
    CREATE QUERY qh .
    qh:SET-BUFFERS(bh).
    
    {utp/ut-liter.i Gera‡Æo_de_relat¢rio_em_planilha * }
    RUN pi-inicializar IN h-acomp (INPUT RETURN-VALUE).
    
    {utp/ut-liter.i Gerando_planilha * }
    RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).
    
    DO i-coluna = 1 TO i-colunas:  
    
        ASSIGN c-format    = STRING(bh:BUFFER-FIELD(c-campo[i-coluna]):FORMAT)
               c-data-type = bh:BUFFER-FIELD(c-campo[i-coluna]):DATA-TYPE.
        
        /* Formato character deve ser passado em branco para a planilha */
        IF c-data-type = "character":U THEN 
            ASSIGN c-format = " ":U. 

        /* cria colunas planilha */
        RUN piColumn IN h-utapi033 (INPUT i-coluna,
                                    INPUT c-data-type, 
                                    INPUT c-titulo-coluna[i-coluna], 
                                    INPUT c-format, 
                                    INPUT REPLACE(STRING(d-largura-coluna[i-coluna] * 5.6),",",".")).
    END. 
      
    qh:QUERY-PREPARE("FOR EACH tt-carga-preco BY cod-transp BY dat-trans":U). 
    qh:FORWARD-ONLY.  
    qh:QUERY-OPEN().
    
    REPEAT:
        qh:GET-NEXT().
        IF qh:QUERY-OFF-END THEN LEAVE.
        
        RUN piNewLine IN h-utapi033.
        
        DO i-coluna = 1 TO i-colunas:                
            RUN piLine IN h-utapi033(INPUT i-coluna, INPUT STRING(bh:BUFFER-FIELD(c-campo[i-coluna]):BUFFER-VALUE)).
        END.
    END.
    
    IF tt-param.imp-param THEN 
        RUN pi-imprime-parametros IN THIS-PROCEDURE.    
    
    RUN piProcessa IN h-utapi033 (INPUT-OUTPUT tt-param.arquivo, INPUT "AQ0503", INPUT c-titulo-relat).
    
    RUN pi-finalizar IN h-acomp.
    
    RETURN "OK":U.
END PROCEDURE.




PROCEDURE pi-imprime-parametros:
/*------------------------------------------------------------------------------
  Purpose: imprimir parametros utilizados para geracao do relatorio.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
    DEFINE VARIABLE c-lbl-ate         AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE iParamColumnWidth AS INTEGER EXTENT 2 NO-UNDO.
    
    {utp/ut-liter.i at‚ *}
    ASSIGN c-lbl-ate = RETURN-VALUE.
    
   {utp/ut-liter.i SELE€ÇO *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.
           
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-campos[1]
           tt-param-planilha.valor     = STRING(tt-param.cod-transp-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cod-transp-fim).

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-campos[2]
           tt-param-planilha.valor     = STRING(tt-param.dt-trans-ini, "99/99/9999":U) + " " + c-lbl-ate + " " + STRING(tt-param.dt-trans-fim, "99/99/9999":U).


    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-campos[3]
           tt-param-planilha.valor     = tt-param.cod-estab-ini + " " + c-lbl-ate + " " + tt-param.cod-estab-fim.
    
 
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-campos[4]
           tt-param-planilha.valor     = tt-param.cod-rota-ini + " " + c-lbl-ate + " " + tt-param.cod-rota-fim.
 
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-campos[5]
           tt-param-planilha.valor     = tt-param.it-codigo-ini + " " + c-lbl-ate + " " + tt-param.it-codigo-fim.

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-campos[6]
           tt-param-planilha.valor     = tt-param.cod-placa-ini + " " + c-lbl-ate + " " + tt-param.cod-placa-fim.
 
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = ''
           tt-param-planilha.valor     = ''.
           
    {utp/ut-liter.i PAR¶METROS *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.
           
    CREATE tt-param-planilha.
    IF tt-param.atualiza-frete-carg THEN DO:
        {utp/ut-liter.i Sim *}
        ASSIGN tt-param-planilha.descricao = c-label-params[3]
               tt-param-planilha.valor     = RETURN-VALUE.
    END.
    ELSE DO:
        {utp/ut-liter.i NÆo *}
        ASSIGN tt-param-planilha.descricao = c-label-params[3]
               tt-param-planilha.valor     = RETURN-VALUE.
    END.

    {utp/ut-liter.i Sim/NÆo *}
    CREATE tt-param-planilha.
    IF tt-param.lista-detalhado THEN DO:
        {utp/ut-liter.i Sim *}  
        ASSIGN tt-param-planilha.descricao = c-label-params[11]
               tt-param-planilha.valor     = RETURN-VALUE.
    END.
    ELSE DO:
        {utp/ut-liter.i NÆo *}  
        ASSIGN tt-param-planilha.descricao = c-label-params[11]
               tt-param-planilha.valor     = RETURN-VALUE.
    END.

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = ''
           tt-param-planilha.valor     = ''.           

    {utp/ut-liter.i IMPRESSÇO *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.               

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = c-label-params[6]
           tt-param-planilha.valor     = tt-param.arquivo.

    ASSIGN iParamColumnWidth[1] = 150
           iParamColumnWidth[2] = 200.

    RUN setParamColumnWidth IN h-utapi033 (INPUT iParamColumnWidth).
    RUN setTTParam          IN h-utapi033 (INPUT TABLE tt-param-planilha).    

    RETURN "OK":U.
END PROCEDURE.
 

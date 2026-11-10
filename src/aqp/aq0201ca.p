/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0201CA 2.00.00.005 } /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aq0201ca MAQ}
&ENDIF

/*****************************************************************************
**
**       Programa: AQ0201CA
**
**       Objetivo: Geração de relatorio em planilha para o programa aq0201c
**       Parametros: 
**
*****************************************************************************/

{utp/ut-glob.i}
{aqp/aqapi001.i} /** temp-tables **/
{cdp/cd0666.i}   /** Definicao da tt-erro **/
{utp/utapi013.i} /** planilha **/
{include/i-rpvar.i}
{method/dbotterr.i} /* rowErrors*/

DEFINE VARIABLE iQtdColunas   AS INTEGER   INITIAL 23 NO-UNDO.
DEFINE VARIABLE cTituloColuna AS CHARACTER EXTENT  23 NO-UNDO.
DEFINE VARIABLE cCampo        AS CHARACTER EXTENT  23 NO-UNDO.
DEFINE VARIABLE cDateTime     AS CHARACTER            NO-UNDO.
DEFINE VARIABLE iLinha        AS INTEGER              NO-UNDO. 
DEFINE VARIABLE iColuna       AS INTEGER              NO-UNDO.   
DEFINE VARIABLE cDiretorio    AS CHARACTER            NO-UNDO.
DEFINE VARIABLE cAplExced     AS CHARACTER EXTENT 2   NO-UNDO.

DEFINE INPUT  PARAMETER TABLE FOR tt-regra-form-preco-custom.
DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

/*#############################################################################################################################*/
/*######################################### P R O C E D U R E S   #   I N T E R N A S #########################################*/
/*#############################################################################################################################*/   
    
RUN piInicializar           IN THIS-PROCEDURE.
RUN piMontaCabecalho        IN THIS-PROCEDURE.
RUN piMontaCabecalhoColunas IN THIS-PROCEDURE.
RUN piImprimeLinhas         IN THIS-PROCEDURE.
RUN piGeraPlanilha          IN THIS-PROCEDURE.

PROCEDURE piInicializar PRIVATE:   
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    FIND FIRST empresa
         WHERE empresa.ep-codigo = i-ep-codigo-usuario NO-LOCK NO-ERROR.

    ASSIGN c-empresa  = (IF  AVAIL empresa THEN empresa.razao-social ELSE "")
           c-programa = "AQ0201ca":U.

   {utp/ut-liter.i Listagem_Regras_Reajustadas * r}
    ASSIGN c-titulo-relat = TRIM(RETURN-VALUE).
    
    {utp/ut-liter.i Usu rio * r}
    ASSIGN c-titulo-relat =  c-titulo-relat + " - " + TRIM(RETURN-VALUE) + ": " + v_cod_usuar_corren    
           cDateTime = STRING(TODAY) + " - ":U + STRING(TIME,"HH:MM:SS").

    {utp/ut-liter.i "reajuste-preco" * r}
    ASSIGN cDiretorio = SESSION:TEMP-DIR + RETURN-VALUE + "_" + v_cod_usuar_corren + "_" +  REPLACE(STRING(TODAY),'/','_') + '_' + REPLACE(STRING(TIME,"HH:MM:SS"),":","_") + '.xls'.        
    
    {aqp/aq0201ca.i} /* Atualiza arrays */

    /*SYSTEM-DIALOG PRINTER-SETUP.*/
    OS-DELETE VALUE(cDiretorio).
    
    CREATE tt-configuracao2.
    ASSIGN tt-configuracao2.versao-integracao   = 1
           tt-configuracao2.arquivo-num         = 1
           tt-configuracao2.arquivo             = cDiretorio
           tt-configuracao2.total-planilha      = 1
           tt-configuracao2.exibir-construcao   = NO
           tt-configuracao2.abrir-excel-termino = YES
           tt-configuracao2.imprimir            = NO
           tt-configuracao2.orientacao          = 2.    
           
    {utp/ut-liter.i Regras * }      
    CREATE tt-planilha2.
    ASSIGN tt-planilha2.arquivo-num        = 1
           tt-planilha2.planilha-num       = 1
           tt-planilha2.planilha-nome      = RETURN-VALUE
           tt-planilha2.linhas-grade       = YES
           tt-planilha2.formatar-planilha  = YES
           tt-planilha2.formatar-faixa     = YES
           tt-planilha2.largura-coluna[1]  = 15
           tt-planilha2.largura-coluna[2]  = 25
           tt-planilha2.largura-coluna[3]  = 5
           tt-planilha2.largura-coluna[4]  = 17.86
           tt-planilha2.largura-coluna[5]  = 15
           tt-planilha2.largura-coluna[6]  = 15
           tt-planilha2.largura-coluna[7]  = 15
           tt-planilha2.largura-coluna[8]  = 15
           tt-planilha2.largura-coluna[9]  = 15
           tt-planilha2.largura-coluna[10] = 15
           tt-planilha2.largura-coluna[11] = 15
           tt-planilha2.largura-coluna[12] = 17.57
           tt-planilha2.largura-coluna[13] = 15
           tt-planilha2.largura-coluna[14] = 15
           tt-planilha2.largura-coluna[15] = 15
           tt-planilha2.largura-coluna[16] = 15
           tt-planilha2.largura-coluna[17] = 15
           tt-planilha2.largura-coluna[18] = 15
           tt-planilha2.largura-coluna[19] = 15
           tt-planilha2.largura-coluna[20] = 15
           tt-planilha2.largura-coluna[21] = 15
           tt-planilha2.largura-coluna[22] = 15
           tt-planilha2.largura-coluna[23] = 50.
  
    RETURN "OK":U.
    
END PROCEDURE.

PROCEDURE piMontaCabecalho PRIVATE: 
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    ASSIGN iLinha  = iLinha + 1
           iColuna = 0.
      
    DO iColuna = 1 TO iQtdColunas:
    
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num           = 1
               tt-dados.planilha-num          = 1
               tt-dados.celula-coluna         = iColuna
               tt-dados.celula-linha          = iLinha
               tt-dados.celula-fonte-nome     = "Tahoma":U
               tt-dados.celula-cor-interior   = 2
               tt-dados.celula-fonte-negrito  = YES
               tt-dados.celula-fonte-cor      = 1
               tt-dados.celula-tipo-borda-inf = 1
               tt-dados.celula-tipo-borda-sup = 1
               tt-dados.celula-fonte-tam      = 10
               tt-dados.celula-cor-interior   = 15.
               
        CASE iColuna:
            WHEN 1  THEN ASSIGN tt-dados.celula-valor          = c-empresa
                                tt-dados.celula-tipo-borda-esq = 1. 
            WHEN 8  THEN ASSIGN tt-dados.celula-valor = c-titulo-relat.
            WHEN iQtdColunas THEN ASSIGN tt-dados.celula-valor  = cDateTime
                                         tt-dados.celula-alinhamento-horizontal = 5
                                         tt-dados.celula-tipo-borda-dir = 1.
        END CASE.
        
    END.
    
    RETURN 'OK':U.
    
END PROCEDURE.


PROCEDURE piMontaCabecalhoColunas PRIVATE:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    ASSIGN iLinha  = iLinha + 1
           iColuna = 0.
      
    DO iColuna = 1 TO iQtdColunas:
        CREATE tt-dados.
        ASSIGN tt-dados.arquivo-num                   = 1
               tt-dados.planilha-num                  = 1
               tt-dados.celula-linha                  = iLinha
               tt-dados.celula-coluna                 = iColuna
               tt-dados.celula-fonte-nome             = "Tahoma":U
               tt-dados.celula-valor                  = cTituloColuna[iColuna]
               tt-dados.celula-tipo-borda-esq         = 1
               tt-dados.celula-tipo-borda-inf         = 1
               tt-dados.celula-tipo-borda-sup         = 1
               tt-dados.celula-alinhamento-horizontal = 4
               tt-dados.celula-fonte-negrito          = YES
               tt-dados.celula-fonte-tam              = 10
               tt-dados.celula-cor-interior           = 15.
               
        CASE iColuna:
            WHEN 1           THEN ASSIGN tt-dados.celula-tipo-borda-esq = 1.          
            WHEN iQtdColunas THEN ASSIGN tt-dados.celula-tipo-borda-dir = 1.
        END CASE.       
               
    END.

    RETURN 'OK':U.
    
END PROCEDURE.

PROCEDURE piImprimeLinhas PRIVATE: 
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE VARIABLE qh AS HANDLE NO-UNDO.
    DEFINE VARIABLE bh AS HANDLE NO-UNDO.
    
    
    CREATE BUFFER bh FOR TABLE "tt-regra-form-preco-custom":U.
    CREATE QUERY qh .
    qh:SET-BUFFERS(bh).

    qh:QUERY-PREPARE("FOR EACH tt-regra-form-preco-custom " +
                     "WHERE tt-regra-form-preco-custom.checkSum = '*' " +
                     "BY tt-regra-form-preco-custom.dat-inic " +
                     "BY tt-regra-form-preco-custom.cod-pto-coleta " +
                     "BY tt-regra-form-preco-custom.cdn-produt-rural " +
                     "BY tt-regra-form-preco-custom.cdn-grp-produt " +
                     "BY tt-regra-form-preco-custom.cod-rota " +
                     "BY tt-regra-form-preco-custom.cod-regiao " + 
                     "BY tt-regra-form-preco-custom.cod-estabel"). 
    qh:FORWARD-ONLY.  
    qh:QUERY-OPEN().

    ASSIGN iLinha  = iLinha + 1
           iColuna = 0. 

    REPEAT:
        qh:GET-NEXT().
        IF qh:QUERY-OFF-END THEN LEAVE.

        DO iColuna = 1 TO iQtdColunas:
            CREATE tt-dados.
            ASSIGN tt-dados.arquivo-num                   = 1
                   tt-dados.planilha-num                  = 1
                   tt-dados.celula-linha                  = iLinha
                   tt-dados.celula-coluna                 = iColuna
                   tt-dados.celula-fonte-nome             = "Tahoma":U                   
                   tt-dados.celula-tipo-borda-esq         = 1
                   tt-dados.celula-tipo-borda-inf         = 1
                   tt-dados.celula-tipo-borda-sup         = 1
                   tt-dados.celula-alinhamento-horizontal = 4
                   tt-dados.celula-fonte-tam              = 10.
                   
            CASE iColuna:
                WHEN 4 THEN /* tipo */
                    ASSIGN tt-dados.celula-valor = {ininc/i02in00972.i 04 INT(bh:BUFFER-FIELD(cCampo[iColuna]):BUFFER-VALUE)}.
                WHEN 6 OR 
                WHEN 7 OR 
                WHEN 8 OR
                WHEN 9 THEN
                    ASSIGN tt-dados.celula-valor   = STRING(bh:BUFFER-FIELD(cCampo[iColuna]):BUFFER-VALUE)
                           tt-dados.celula-formato = "#.###.##0,0000":U.  
                WHEN 12 THEN /* abrangencia */
                    ASSIGN tt-dados.celula-valor = {ininc/i01in00972.i 04 INT(bh:BUFFER-FIELD(cCampo[iColuna]):BUFFER-VALUE)}.
               
                WHEN 13 OR /* pto coleta */
                WHEN 14 OR /* propriedade */
                WHEN 17 OR /*rota */
                WHEN 18 OR /* regiao */
                WHEN 19 THEN /* estabelecimento*/
                    ASSIGN tt-dados.celula-valor = IF STRING(bh:BUFFER-FIELD(cCampo[iColuna]):BUFFER-VALUE) = "" THEN  '*' 
                                                   ELSE STRING(bh:BUFFER-FIELD(cCampo[iColuna]):BUFFER-VALUE).                
                WHEN 15 OR /* produtor */
                WHEN 16 THEN /* grupo */
                    ASSIGN tt-dados.celula-valor = IF INT(bh:BUFFER-FIELD(cCampo[iColuna]):BUFFER-VALUE) = 0 THEN "*"
                                                   ELSE STRING(bh:BUFFER-FIELD(cCampo[iColuna]):BUFFER-VALUE).
                WHEN 20 THEN  /*Apl Exced */
                    ASSIGN tt-dados.celula-valor = cAplExced[INT(bh:BUFFER-FIELD(cCampo[iColuna]):BUFFER-VALUE)].               
                WHEN iQtdColunas THEN 
                    ASSIGN tt-dados.celula-tipo-borda-dir = 1
                           tt-dados.celula-valor = STRING(bh:BUFFER-FIELD(cCampo[iColuna]):BUFFER-VALUE).
                OTHERWISE
                    ASSIGN tt-dados.celula-valor = STRING(bh:BUFFER-FIELD(cCampo[iColuna]):BUFFER-VALUE).
                    
            END CASE.   
        END.
        ASSIGN iLinha = iLinha + 1. 
    END.

    IF VALID-HANDLE(qh) THEN DO:
        DELETE OBJECT qh.
        ASSIGN qh = ?.
    END.
    IF VALID-HANDLE(bh) THEN DO:
        DELETE OBJECT bh.
        ASSIGN bh = ?.
    END.

    RETURN 'OK':U.
    
END PROCEDURE.


PROCEDURE piGeraPlanilha PRIVATE:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-utapi013) THEN
        RUN utp/utapi013.p PERSISTENT SET h-utapi013.
  
    EMPTY TEMP-TABLE tt-erros  NO-ERROR.
    EMPTY TEMP-TABLE rowErrors NO-ERROR.
  
    RUN pi-execute2 IN h-utapi013 (INPUT-OUTPUT TABLE tt-configuracao2,
                                   INPUT-OUTPUT TABLE tt-planilha2,
                                   INPUT-OUTPUT TABLE tt-dados,
                                   INPUT-OUTPUT TABLE tt-formatar-faixa,
                                   INPUT-OUTPUT TABLE tt-grafico2,
                                   INPUT-OUTPUT TABLE tt-erros).   
  
    IF RETURN-VALUE = "NOK" THEN DO:
        FOR EACH tt-erros:
            RUN criaRowErrors IN THIS-PROCEDURE(INPUT tt-erros.cod-erro, INPUT STRING(tt-erros.desc-error,"x(255)")).        
        END.
    END.
  
    DELETE PROCEDURE h-utapi013.

END PROCEDURE.

PROCEDURE criaRowErrors PRIVATE:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-msg AS INTEGER                   NO-UNDO.
    DEFINE INPUT PARAMETER p-texto   AS CHARACTER FORMAT "X(255)" NO-UNDO.

    DEFINE VARIABLE iErrorSequence    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cErrorSubType     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cErrorDescription AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cErrorHelp        AS CHARACTER  NO-UNDO.

    userCodeBlock:
    DO ON ERROR UNDO, LEAVE userCodeBlock
       ON STOP  UNDO, LEAVE userCodeBlock
       ON QUIT  UNDO, LEAVE userCodeBlock:

        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT p-num-msg,
                           INPUT p-texto).                       
        ASSIGN cErrorDescription = RETURN-VALUE.
        
        /** Busca o Tipo de Mensagem do EMS **/
        RUN utp/ut-msgs.p (INPUT "TYPE":U,
                           INPUT p-num-msg,
                           INPUT p-texto).
        CASE {uninc/i01un001.i 06 RETURN-VALUE}:
        WHEN 1 THEN
            ASSIGN cErrorSubType = "ERROR":U.
        WHEN 2 THEN
            ASSIGN cErrorSubType = "WARNING":U.
        WHEN 3 THEN
            ASSIGN cErrorSubType = "QUESTION":U.
        WHEN 4 THEN
            ASSIGN cErrorSubType = "INFORMATION":U.
        END CASE.
        
        /** Busca Help da Mensagem **/
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                       INPUT p-num-msg,  
                       INPUT p-texto).   
        ASSIGN cErrorHelp = RETURN-VALUE.
        
        /*--- Atualiza variëvel de sequ¦ncia de erros ---*/
        IF CAN-FIND(LAST rowErrors) THEN DO:
            FIND LAST rowErrors NO-ERROR.
            ASSIGN iErrorSequence = rowErrors.ErrorSequence + 1.
        END.
        ELSE
            ASSIGN iErrorSequence = iErrorSequence + 1.
        
        CREATE rowErrors.
        ASSIGN rowErrors.ErrorSequence    = iErrorSequence
               rowErrors.ErrorNumber      = p-num-msg
               rowErrors.ErrorType        = "EMS":U
               rowErrors.ErrorSubType     = cErrorSubType
               rowErrors.ErrorDescription = cErrorDescription
               rowErrors.ErrorHelp        = cErrorHelp
               rowErrors.ErrorParameters  = p-texto.
    END.

    RETURN "OK":U.
END PROCEDURE.


/*******************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
********************************************************************************/
{include/i-prgvrs.i AQAPI001 2.00.00.040 } /*** "010040" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aqapi001 MAQ}
&ENDIF

/*****************************************************************************
**
**       Programa: AQAPI001
**
**       Objetivo: Apura‡Æo de valores por per¡odo
**     Parametros: 
**
*****************************************************************************/

{utp/ut-glob.i}
{aqp/aqapi001.i}  /*temp-tables*/
{cdp/cdapi020a.i} /*Interpretador de formulas*/
{cdp/cd0666.i}    /*tt-erro*/
&scoped-define TTONLY YES     /*      Segurança      */
{include/i-estab-security.i}  /* por estabelecimento */
{method/dbotterr.i} /* rowErrors*/

/*Vari veis*/
DEFINE VARIABLE h-acomp AS HANDLE NO-UNDO.

DEFINE VARIABLE h-boin00999 AS HANDLE NO-UNDO. /*fechto-produt-period*/
DEFINE VARIABLE h-boin01011 AS HANDLE NO-UNDO. /*fechto-qualid       */
DEFINE VARIABLE h-cdapi020a AS HANDLE NO-UNDO. /*Interpretador de formulas*/

DEFINE VARIABLE qh                AS HANDLE                       NO-UNDO.
DEFINE VARIABLE bh                AS HANDLE                       NO-UNDO.
DEFINE VARIABLE da-data           AS DATE                         NO-UNDO. 
DEFINE VARIABLE l-achou-result    AS LOGICAL                      NO-UNDO. /*encontrou resultado exame para regra*/
DEFINE VARIABLE l-achou           AS LOGICAL                      NO-UNDO. /*encontrou regra para a carga*/
DEFINE VARIABLE c-cod-regiao      AS CHARACTER                    NO-UNDO. 
DEFINE VARIABLE c-cod-rota        AS CHARACTER                    NO-UNDO. 
DEFINE VARIABLE c-cod-propriedade AS CHARACTER                    NO-UNDO. 
DEFINE VARIABLE i-cdn-grp-produt  AS INTEGER                      NO-UNDO. 
DEFINE VARIABLE i-num-regras      AS INTEGER                      NO-UNDO. 
DEFINE VARIABLE i-num-result-exam AS INTEGER                      NO-UNDO. /*número de exames - usado para calcular média dos resultados*/
DEFINE VARIABLE de-val-frete-carg AS DECIMAL                      NO-UNDO. /*valor do frete na carga por litro*/
DEFINE VARIABLE r-rd-fechto       AS ROWID                        NO-UNDO.
DEFINE VARIABLE c-cod-transp      AS INT                          NO-UNDO.
DEFINE VARIABLE c-cod-placa       LIKE carg-rural.cod-placa       NO-UNDO.
DEFINE VARIABLE c-it-codigo       LIKE item.it-codigo             NO-UNDO.
DEFINE VARIABLE c-it-codigo-par   LIKE item.it-codigo             NO-UNDO.
DEFINE VARIABLE c-cod-estab-ant   LIKE tt-fechto-com.cod-estabel  NO-UNDO.
DEFINE VARIABLE c-formula-ant     AS CHAR                         NO-UNDO.

/*#############################################################################################################################*/
/*######################################### P R O C E D U R E    #   I N T E R N A ############################################*/
/*#############################################################################################################################*/
PROCEDURE piGetPreco:


    /*Parametros*/
    DEF INPUT  PARAM TABLE FOR tt-param.
    DEF INPUT  PARAM TABLE FOR tt-digita.
    DEF INPUT  PARAM cPrograma AS CHARACTER NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR rowErrors.

    /*Tela de Acompanhamento*/
    IF  h-acomp = ? THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp ("C lculo do pre‡o").
    
    EMPTY TEMP-TABLE rowErrors NO-ERROR.
    
    /*fechto-produt-period*/
    IF NOT VALID-HANDLE(h-boin00999) THEN DO: /* fechto-produt-period */
        RUN inbo/boin00999.p PERSISTENT SET h-boin00999.
    END.
    RUN openQueryStatic IN h-boin00999 (INPUT "Main":U).

    /*fechto-qualid*/
    IF NOT VALID-HANDLE(h-boin01011) THEN DO:
        RUN inbo/boin01011.p PERSISTENT SET h-boin01011.
    END.
    RUN openQueryStatic IN h-boin01011 (INPUT "Main":U).

    
    /******************************** preço base ***************************************************************************/    
    FOR FIRST tt-param:
        
        /*=====================================================================================================================*/
        ASSIGN tt-param.cdn-tipo = 1. /*busca somente preco base*/
        RUN piGetFaixaValida IN THIS-PROCEDURE (INPUT  TABLE tt-param,
                                                INPUT  cPrograma,
                                                OUTPUT TABLE tt-regra-form-preco).
        
        RUN piSomaCargaPeriodo IN THIS-PROCEDURE (INPUT  TABLE tt-regra-form-preco,
                                                  INPUT  TABLE tt-digita,
                                                  OUTPUT TABLE rowErrors). 
        /**************************** fim preço base ***************************************************************************/    
        /*=====================================================================================================================*/
        
       
        /**************************** calculo das bonifica‡äes *****************************************************************/    
        /*=====================================================================================================================*/
        ASSIGN tt-param.cdn-tipo = 2.   /*busca somente variação de qualidade*/
        RUN piGetFaixaValida IN THIS-PROCEDURE (INPUT  TABLE tt-param,
                                                INPUT  cPrograma,
                                                OUTPUT TABLE tt-regra-form-preco-qual).
        
        /******************************* soma bonificações de qualidade ********************************************************/    
        RUN piSomaQualidade IN THIS-PROCEDURE (INPUT TABLE tt-regra-form-preco-qual,
                                               INPUT TABLE tt-digita).
        /**************************** fim regras de qualidade ******************************************************************/
        /*=====================================================================================================================*/    


        /*=====================================================================================================================*/
        ASSIGN tt-param.cdn-tipo = 3.           /*busca somente varia‡Æoo volume*/
        RUN piGetFaixaValida IN THIS-PROCEDURE (INPUT  TABLE tt-param,
                                                INPUT  cPrograma,
                                                OUTPUT TABLE tt-regra-form-preco-vol).                                                     
        
        /************************** soma bonificações de varia‡Æo de volume ****************************************************/
        RUN piSomaVolume IN THIS-PROCEDURE (INPUT TABLE tt-regra-form-preco-vol,
                                            INPUT TABLE tt-digita).
        /************************** fim regras de varia‡Æo de volume ***********************************************************/
        /*=====================================================================================================================*/
        
        
        /*=====================================================================================================================*/
        ASSIGN tt-param.cdn-tipo = 4.           /*busca somente bônus fixo*/
        RUN piGetFaixaValida IN THIS-PROCEDURE (INPUT  TABLE tt-param,
                                                INPUT  cPrograma,
                                                OUTPUT TABLE tt-regra-form-preco-bonfix).
            
        /***************************** regras de b“nus fixo ********************************************************************/    
        RUN piSomaBonusFixo IN THIS-PROCEDURE (INPUT TABLE tt-regra-form-preco-bonfix,
                                               INPUT TABLE tt-digita).
        /***************************** fim regras de b“nus fixo *******************************************************************/
        /*=====================================================================================================================*/        

    END. /*for first tt-param*/     
    /**************************** fim calculo das bonifica‡äes *****************************************************************/    
   
    /*fechto-produt-period*/
    IF  h-boin00999 <> ? THEN DO:
        DELETE PROCEDURE h-boin00999.
        ASSIGN h-boin00999 = ?.
    END.    

    /*fechto-qualid*/
    IF  h-boin01011 <> ? THEN DO:
        DELETE PROCEDURE h-boin01011.
        ASSIGN h-boin01011 = ?.
    END. 

    /*Tela de Acompanhamento*/
    IF  h-acomp <> ? THEN DO:
        RUN pi-finalizar IN h-acomp.
        ASSIGN h-acomp = ?.    
    END.

    RETURN "OK":U.
END PROCEDURE.
/*##############################################################################################################################*/


/*##################################### P R O C E D U R E S  A U X I L I A R E S ###############################################*/
PROCEDURE cria-tt-regra-form-preco: /*procedure utilizada pela aqapi001.i2*/

    CREATE tt-regra-form-preco.    
    ASSIGN tt-regra-form-preco.cod-regra        = bh:BUFFER-FIELD("cod-regra":U):BUFFER-VALUE              
           tt-regra-form-preco.cdn-seq          = INT(bh:BUFFER-FIELD("cdn-seq":U):BUFFER-VALUE)                                                                                                               
           tt-regra-form-preco.descricao        = bh:BUFFER-FIELD("descricao":U):BUFFER-VALUE                                                                                                             
           tt-regra-form-preco.cdn-tipo         = INT(bh:BUFFER-FIELD("cdn-tipo":U):BUFFER-VALUE)            
           tt-regra-form-preco.cdn-criter       = INT(bh:BUFFER-FIELD("cdn-criter":U):BUFFER-VALUE)
           tt-regra-form-preco.it-codigo        = bh:BUFFER-FIELD("it-codigo":U):BUFFER-VALUE 
           tt-regra-form-preco.cdn-abrangen     = INT(bh:BUFFER-FIELD("cdn-abrangen":U):BUFFER-VALUE) 
           tt-regra-form-preco.cod-estabel      = bh:BUFFER-FIELD("cod-estabel":U):BUFFER-VALUE   
           tt-regra-form-preco.cod-regiao       = bh:BUFFER-FIELD("cod-regiao":U):BUFFER-VALUE
           tt-regra-form-preco.cdn-grp-produt   = bh:BUFFER-FIELD("cdn-grp-produt":U):BUFFER-VALUE  
           tt-regra-form-preco.cod-rota         = bh:BUFFER-FIELD("cod-rota":U):BUFFER-VALUE  
           tt-regra-form-preco.cdn-produt-rural = INT(bh:BUFFER-FIELD("cdn-produt-rural":U):BUFFER-VALUE) 
           tt-regra-form-preco.cod-propried     = bh:BUFFER-FIELD("cod-propried":U):BUFFER-VALUE 
           tt-regra-form-preco.cod-pto-coleta   = bh:BUFFER-FIELD("cod-pto-coleta":U):BUFFER-VALUE 
           tt-regra-form-preco.dat-inic         = DATE(bh:BUFFER-FIELD("dat-inic":U):BUFFER-VALUE)
           tt-regra-form-preco.dat-fim          = DATE(bh:BUFFER-FIELD("dat-fim":U):BUFFER-VALUE) 
           tt-regra-form-preco.val-unit         = DEC(bh:BUFFER-FIELD("val-unit":U):BUFFER-VALUE)
           tt-regra-form-preco.val-faixa-inic   = DEC(bh:BUFFER-FIELD("val-faixa-inic":U):BUFFER-VALUE)
           tt-regra-form-preco.val-faixa-fim    = DEC(bh:BUFFER-FIELD("val-faixa-fim":U):BUFFER-VALUE)
           tt-regra-form-preco.cod-exame        = INT(bh:BUFFER-FIELD("cod-exame":U):BUFFER-VALUE) 
           tt-regra-form-preco.cod-comp         = INT(bh:BUFFER-FIELD("cod-comp":U):BUFFER-VALUE) 
           tt-regra-form-preco.cdn-aplic        = INT(bh:BUFFER-FIELD("cdn-aplic":U):BUFFER-VALUE) 
           tt-regra-form-preco.des-narrat       = bh:BUFFER-FIELD("des-narrat":U):BUFFER-VALUE 
           tt-regra-form-preco.cod-usuar-criac  = bh:BUFFER-FIELD("cod-usuar-criac":U):BUFFER-VALUE 
           tt-regra-form-preco.dat-criac        = DATE(bh:BUFFER-FIELD("dat-criac":U):BUFFER-VALUE)             
           tt-regra-form-preco.cod-usuar-alter  = bh:BUFFER-FIELD("cod-usuar-alter":U):BUFFER-VALUE
           tt-regra-form-preco.dat-alter        = DATE(bh:BUFFER-FIELD("dat-alter":U):BUFFER-VALUE)           
           tt-regra-form-preco.da-dia           = da-data
           tt-regra-form-preco.r-Rowid          = bh:ROWID.

END PROCEDURE.


PROCEDURE piSomaCargaPeriodo:

    /*Parametros*/
    DEF INPUT  PARAM TABLE FOR tt-regra-form-preco.
    DEF INPUT  PARAM TABLE FOR tt-digita.
    DEF OUTPUT PARAM TABLE FOR rowErrors.

    /*Tela de Acompanhamento*/
    IF  h-acomp = ? THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp ("Carregando cargas do per¡odo").
    RUN pi-acompanhar  IN h-acomp ("Calculando valores para as cargas").
        
    {aqp/aqapi001.i3} /*monta a query*/       
    {aqp/aqapi001.i4} /*query dinamica*/
     
    /*Tela de Acompanhamento*/
    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.    

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piSomaQualidade:

    /*Parametros*/
    DEF INPUT PARAM TABLE FOR tt-regra-form-preco.
    DEF INPUT PARAM TABLE FOR tt-digita.
        
    /*Tela de Acompanhamento*/
    IF  h-acomp = ? THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp ("Carregando varia‡Æo por qualidade").
    RUN pi-acompanhar  IN h-acomp ("Somando bonifica‡äes de qualidade").

    {aqp/aqapi001.i6} /**/

    /*Tela de Acompanhamento*/
    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.    

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piSomaVolume:

    /*Parametros*/
    DEF INPUT PARAM TABLE FOR tt-regra-form-preco.
    DEF INPUT PARAM TABLE FOR tt-digita.
    
    /*Tela de Acompanhamento*/
    IF  h-acomp = ? THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    RUN pi-inicializar IN h-acomp ("Carregando varia‡Æo por volume").
    RUN pi-acompanhar  IN h-acomp ("Somando bonifica‡äes de volume").

    {aqp/aqapi001.i7} /*include para bônus volume - leva em consideração bonificações com acordo coletivo*/

    /*Tela de Acompanhamento*/
    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.    

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE piSomaBonusFixo:

    /*Parametros*/
    DEF INPUT PARAM TABLE FOR tt-regra-form-preco.
    DEF INPUT PARAM TABLE FOR tt-digita.
    
    /*Tela de Acompanhamento*/
    IF  h-acomp = ? THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
   
    RUN pi-inicializar IN h-acomp ("Carregando varia‡Æo por b“nus fixo").
    RUN pi-acompanhar  IN h-acomp ("Somando bonifica‡äes de b“nus fixo").
    
    {aqp/aqapi001.i8} /*include para bônus fixo*/

    /*Tela de Acompanhamento*/
    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.    

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE criaRowErrors:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-msg      AS INTEGER                   NO-UNDO.
    DEFINE INPUT PARAMETER p-texto        AS CHARACTER FORMAT "X(255)" NO-UNDO.

    RUN criaRowErrorsEvoluida (p-num-msg, p-texto, "").

    RETURN RETURN-VALUE.
END PROCEDURE.

PROCEDURE criaRowErrorsEvoluida:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-msg      AS INTEGER                   NO-UNDO.
    DEFINE INPUT PARAMETER p-texto        AS CHARACTER FORMAT "X(255)" NO-UNDO.
    DEFINE INPUT PARAMETER p-msg-pronta   AS CHARACTER                 NO-UNDO. /* Mensagem pronta, nao precisa consultar no cadastro de mensagens */

    DEFINE VARIABLE iErrorSequence    AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cErrorSubType     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cErrorDescription AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cErrorHelp        AS CHARACTER  NO-UNDO.

    userCodeBlock:
    DO ON ERROR UNDO, LEAVE userCodeBlock
       ON STOP  UNDO, LEAVE userCodeBlock
       ON QUIT  UNDO, LEAVE userCodeBlock:

        IF p-msg-pronta = "" THEN DO: /* Mensagem nao veio pronta */
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT p-num-msg,
                               INPUT p-texto).
            ASSIGN cErrorDescription = RETURN-VALUE.
        END.
        ELSE DO:
            ASSIGN cErrorDescription = p-msg-pronta.
        END.

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
/*##############################################################################################################################*/


/*#############################################################################################################################*/
/*######################################### P R O C E D U R E S   #   E X T E R N A S #########################################*/
/*#############################################################################################################################*/

PROCEDURE piGetFaixaValida:

    /*Parametros*/
    DEF INPUT  PARAM TABLE FOR tt-param.
    DEF INPUT  PARAM cPrograma AS CHARACTER NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-regra-form-preco.
    
    IF NOT VALID-HANDLE(h-acomp)THEN
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        
    /*Tela de Acompanhamento*/
    {utp/ut-liter.i "C lculo do pre‡o" * }
    RUN pi-inicializar IN h-acomp (RETURN-VALUE). 
        
    FOR FIRST tt-param:
        CASE tt-param.cdn-tipo:    
            WHEN 1 THEN DO:                                        
                {utp/ut-liter.i "Buscando regras de pre‡o" * }
                RUN pi-acompanhar  IN h-acomp (RETURN-VALUE).            
            END.
            WHEN 2 THEN DO:
                {utp/ut-liter.i "Buscando regras de qualidade" * }
                RUN pi-acompanhar  IN h-acomp (RETURN-VALUE).
            END.
            WHEN 3 THEN DO:
                {utp/ut-liter.i "Buscando regras de volume" * }
                RUN pi-acompanhar  IN h-acomp (RETURN-VALUE).
            END.
            WHEN 4 THEN DO:          
                {utp/ut-liter.i "Buscando regras de b“nus fixo" * }
                RUN pi-acompanhar  IN h-acomp (RETURN-VALUE).
            END.
            WHEN 5 THEN DO:          
                {utp/ut-liter.i "Buscando todas as regras" * }
                RUN pi-acompanhar  IN h-acomp (RETURN-VALUE).
            END.            
            
        END CASE.    
        /*Tela de Acompanhamento*/  
        
        EMPTY TEMP-TABLE tt-regra-form-preco.
 
        {aqp/aqapi001.i1}        
        {aqp/aqapi001.i2}
         
    END.

    /*Tela de Acompanhamento*/
    RUN pi-finalizar IN h-acomp.
    ASSIGN h-acomp = ?.    

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piFechtoParcial:
/*------------------------------------------------------------------------------
 Purpose: Retornar fechamento parcial
 Notes:   Utilizada pelo financeiro
------------------------------------------------------------------------------*/

    /*Parametros*/
    DEF INPUT PARAM c-cod-period         LIKE fechto-produt-period.cod-period NO-UNDO.
    DEF INPUT PARAM c-cod-estabel-ini    LIKE estabelec.cod-estabel           NO-UNDO.
    DEF INPUT PARAM c-cod-estabel-fim    LIKE estabelec.cod-estabel           NO-UNDO.
    DEF INPUT PARAM c-cod-regiao-ini     LIKE regra-form-preco.cod-regiao     NO-UNDO.
    DEF INPUT PARAM c-cod-regiao-fim     LIKE regra-form-preco.cod-regiao     NO-UNDO.
    DEF INPUT PARAM c-cod-rota-ini       LIKE regra-form-preco.cod-rota       NO-UNDO.
    DEF INPUT PARAM c-cod-rota-fim       LIKE regra-form-preco.cod-rota       NO-UNDO.
    DEF INPUT PARAM i-cdn-grp-produt-ini LIKE regra-form-preco.cdn-grp-produt NO-UNDO.
    DEF INPUT PARAM i-cdn-grp-produt-fim LIKE regra-form-preco.cdn-grp-produt NO-UNDO.
    DEF INPUT PARAM cdn-produt-rural-ini LIKE produt-rural.cdn-produt-rural   NO-UNDO. 
    DEF INPUT PARAM cdn-produt-rural-fim LIKE produt-rural.cdn-produt-rural   NO-UNDO.
    DEF INPUT PARAM c-cod-propried-ini   LIKE propried-rural.cod-propried     NO-UNDO.
    DEF INPUT PARAM c-cod-propried-fim   LIKE propried-rural.cod-propried     NO-UNDO.

    DEF OUTPUT PARAM TABLE FOR tt-fechto-com.
    DEF OUTPUT PARAM TABLE FOR rowErrors.

    DEF VAR cPrograma       AS CHARACTER INITIAL "fechto-parcial":U NO-UNDO.
    DEF VAR l-per-fechado   AS LOGICAL                              NO-UNDO.
    DEF VAR c-it-codigo-ini LIKE item.it-codigo                     NO-UNDO.
    DEF VAR c-it-codigo-fim LIKE item.it-codigo                     NO-UNDO.

    EMPTY TEMP-TABLE rowErrors NO-ERROR.
    EMPTY TEMP-TABLE tt-fechto-com.
    
    /*fechto-produt-period*/
    IF NOT VALID-HANDLE(h-boin00999) THEN DO: /* fechto-produt-period*/ 
        IF NOT VALID-HANDLE( h-boin00999) THEN 
        RUN inbo/boin00999.p PERSISTENT SET h-boin00999.
    END.
    RUN openQueryStatic IN h-boin00999 (INPUT "Main":U).

    /*tratamento do item*/

    IF c-it-codigo-par <> "":U THEN 
        ASSIGN c-it-codigo-ini = c-it-codigo-par
               c-it-codigo-fim = c-it-codigo-par. 
      
    ELSE
        ASSIGN c-it-codigo-ini = "":U
               c-it-codigo-fim = FILL('Z', 16).
    
    /********************/



    FOR EACH param-aquis-rural FIELDS(cod-periodo cod-estabel) NO-LOCK
        WHERE param-aquis-rural.cod-estabel >= c-cod-estabel-ini
          AND param-aquis-rural.cod-estabel <= c-cod-estabel-fim:

        ASSIGN l-per-fechado = FALSE.
        IF param-aquis-rural.cod-periodo <> "" THEN DO:     /*se estiver vazio, nunca foi efetuado fechamento*/ 

            IF c-cod-period = param-aquis-rural.cod-period THEN /*iguais, per¡odo esta fechado*/ DO:
                ASSIGN l-per-fechado = TRUE.
            END.

            IF INT(SUBSTRING(param-aquis-rural.cod-periodo,3,4)) = INT((SUBSTRING(c-cod-period,3,4))) AND
               INT(SUBSTRING(param-aquis-rural.cod-periodo,1,2)) > INT((SUBSTRING(c-cod-period,1,2))) THEN DO:
                ASSIGN l-per-fechado = TRUE.
            END.

            IF INT(SUBSTRING(param-aquis-rural.cod-periodo,3,4)) > INT((SUBSTRING(c-cod-period,3,4))) THEN DO:
                ASSIGN l-per-fechado = TRUE.
            END.
           
        END.
            
        IF l-per-fechado THEN DO:  /*per¡odo fechado - busca da fechto*/
            FOR EACH  fechto-produt-period NO-LOCK
                WHERE fechto-produt-period.cod-period        = c-cod-period
                AND   fechto-produt-period.cod-estabel      >= c-cod-estabel-ini
                AND   fechto-produt-period.cod-estabel      <= c-cod-estabel-fim
                AND   fechto-produt-period.it-codigo        >= c-it-codigo-ini
                AND   fechto-produt-period.it-codigo        <= c-it-codigo-fim
                AND   fechto-produt-period.cod-propried     >= c-cod-propried-ini
                AND   fechto-produt-period.cod-propried     <= c-cod-propried-fim
                AND   fechto-produt-period.cdn-produt-rural >= cdn-produt-rural-ini
                AND   fechto-produt-period.cdn-produt-rural <= cdn-produt-rural-fim:

                    IF NOT CAN-FIND (FIRST tt-fechto-com
                                     WHERE tt-fechto-com.cod-period          = fechto-produt-period.cod-period
                                     AND   tt-fechto-com.cdn-produt-rural    = fechto-produt-period.cdn-produt-rural
                                     AND   tt-fechto-com.cod-propried        = fechto-produt-period.cod-propried
                                     AND   tt-fechto-com.it-codigo           = fechto-produt-period.it-codigo
                                     AND   tt-fechto-com.cod-estabel         = fechto-produt-period.cod-estabel) THEN DO:
                    
                
                        CREATE tt-fechto-com.
                        ASSIGN tt-fechto-com.cod-period          = fechto-produt-period.cod-period
                               tt-fechto-com.cdn-produt-rural    = fechto-produt-period.cdn-produt-rural
                               tt-fechto-com.cod-propried        = fechto-produt-period.cod-propried
                               tt-fechto-com.it-codigo           = fechto-produt-period.it-codigo
                               tt-fechto-com.cod-estabel         = fechto-produt-period.cod-estabel
                               tt-fechto-com.qtd-period          = fechto-produt-period.qtd-period
                               tt-fechto-com.val-preco-base      = fechto-produt-period.val-preco-base
                               tt-fechto-com.val-var-qualid      = fechto-produt-period.val-var-qualid
                               tt-fechto-com.val-var-volum       = fechto-produt-period.val-var-volum
                               tt-fechto-com.val-bonus-fix       = fechto-produt-period.val-bonus-fix
                               tt-fechto-com.val-bonus-fix-inf   = fechto-produt-period.val-bonus-fix-inf
                               tt-fechto-com.val-frete           = fechto-produt-period.val-frete
                               tt-fechto-com.val-preco-final-inf = fechto-produt-period.val-preco-final-inf
                               tt-fechto-com.val-impto           = fechto-produt-period.val-impto. /* Valor Imposto Sanidade Rural */
                    END.
            END. 

        END.
        ELSE DO:
            EMPTY temp-table tt-param.

            CREATE tt-param.
            ASSIGN tt-param.cod-period            = c-cod-period
                   tt-param.da-dat-ini            = DATE("01/" + SUBSTRING(c-cod-period,1,2) + "/" + SUBSTRING(c-cod-period,3,4))
                   tt-param.da-dat-fim            = IF INT(SUBSTRING(c-cod-period,1,2)) < 12 
                                                       THEN DATE("01/" + STRING(MONTH(tt-param.da-dat-ini) + 1) + "/" + STRING(YEAR(tt-param.da-dat-ini))) - 1 /* último dia do mês */
                                                       ELSE DATE("31/" +         "12"                           + "/" + STRING(YEAR(tt-param.da-dat-ini)))     /* digitado em tela  */
                   tt-param.cod-estabel-ini       = param-aquis-rural.cod-estabel
                   tt-param.cod-estabel-fim       = param-aquis-rural.cod-estabel
                   tt-param.cod-regiao-ini        = c-cod-regiao-ini 
                   tt-param.cod-regiao-fim        = c-cod-regiao-fim 
                   tt-param.cod-rota-ini          = c-cod-rota-ini       
                   tt-param.cod-rota-fim          = c-cod-rota-fim
                   tt-param.cdn-grp-produt-ini    = i-cdn-grp-produt-ini 
                   tt-param.cdn-grp-produt-fim    = i-cdn-grp-produt-fim 
                   tt-param.cdn-produt-rural-ini  = cdn-produt-rural-ini
                   tt-param.cdn-produt-rural-fim  = cdn-produt-rural-fim
                   tt-param.cod-propried-ini      = c-cod-propried-ini
                   tt-param.cod-propried-fim      = c-cod-propried-fim
                   tt-param.cod-pto-coleta-ini    = "" 
                   tt-param.cod-pto-coleta-fim    = FILL('Z', 12).

            IF c-it-codigo-par <> "":U THEN 
                ASSIGN tt-param.it-codigo = c-it-codigo-par. 
        
            FOR FIRST tt-param:
        
                /*=====================================================================================================================*/
                ASSIGN tt-param.cdn-tipo = 1. /*busca somente preco base*/
                RUN piGetFaixaValida IN THIS-PROCEDURE (INPUT  TABLE tt-param,
                                                        INPUT  cPrograma,
                                                        OUTPUT TABLE tt-regra-form-preco).
                
                {aqp/aqapi001.i3} /*filtra as produ-carg do período*/
                {aqp/aqapi001.i9}
                /*=====================================================================================================================*/ 
                
                /**************************** calculo das bonifica‡äes *****************************************************************/    
                /*=====================================================================================================================*/
                ASSIGN tt-param.cdn-tipo = 2.   /*busca somente variação de qualidade*/
                RUN piGetFaixaValida IN THIS-PROCEDURE (INPUT  TABLE tt-param,
                                                        INPUT  cPrograma,
                                                        OUTPUT TABLE tt-regra-form-preco-qual).
                
                /******************************* soma bonificações de qualidade ********************************************************/    
                {aqp/aqapi001.i10} /* qualidade  */
                /**************************** fim regras de qualidade ******************************************************************/
                /*=====================================================================================================================*/    
        
        
                /*=====================================================================================================================*/
                ASSIGN tt-param.cdn-tipo = 3.           /*busca somente varia‡Æoo volume*/
                RUN piGetFaixaValida IN THIS-PROCEDURE (INPUT  TABLE tt-param,
                                                        INPUT  cPrograma,
                                                        OUTPUT TABLE tt-regra-form-preco-vol).                                                     
                
                /************************** soma bonificações de varia‡Æo de volume ****************************************************/
                {aqp/aqapi001.i11} /* volume     */
                /************************** fim regras de varia‡Æo de volume ***********************************************************/
                /*=====================================================================================================================*/
                
                
                /*=====================================================================================================================*/
                ASSIGN tt-param.cdn-tipo = 4.           /*busca somente bônus fixo*/
                RUN piGetFaixaValida IN THIS-PROCEDURE (INPUT  TABLE tt-param,
                                                        INPUT  cPrograma,
                                                        OUTPUT TABLE tt-regra-form-preco-bonfix).
                    
                /***************************** regras de b“nus fixo ********************************************************************/    
                {aqp/aqapi001.i12} /* bonus fixo */
                /***************************** fim regras de b“nus fixo ****************************************************************/
                /*=====================================================================================================================*/           
          
            END.

        END.

    END.

    /*fechto-produt-period*/
    IF  h-boin00999 <> ? THEN DO:
        DELETE PROCEDURE h-boin00999.
        ASSIGN h-boin00999 = ?.
    END.

    /*Interpretador de formulas*/
    IF  h-cdapi020a <> ? THEN DO:
        RUN pi-finalizar IN h-cdapi020a.
        DELETE PROCEDURE h-cdapi020a NO-ERROR.
        ASSIGN h-cdapi020a = ?.
    END.

    /*Tela de Acompanhamento*/
    IF  h-acomp <> ? THEN DO:
        RUN pi-finalizar IN h-acomp.
        ASSIGN h-acomp = ?.    
    END.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE setItem: /*utilizada para filtrar item na obtenção da fechto parcial*/

    DEFINE INPUT PARAM p-c-it-codigo-par LIKE item.it-codigo NO-UNDO.

    ASSIGN c-it-codigo-par = p-c-it-codigo-par.

RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-calculo-imposto-sanidade: /* Calculo do imposto de sanidade animal */
    DEFINE INPUT  PARAM p-c-cod-estab  LIKE tt-fechto-com.cod-estabel         NO-UNDO.
    DEFINE INPUT  PARAM p-d-volume-mes LIKE tt-fechto-com.val-var-volum       NO-UNDO.
    DEFINE OUTPUT PARAM p-d-val-impto  LIKE tt-fechto-com.val-impto   INIT 0  NO-UNDO.

    IF NOT VALID-HANDLE(h-cdapi020a) THEN
        RUN cdp/cdapi020a.p PERSISTENT SET h-cdapi020a (INPUT-OUTPUT TABLE tt-formula,
                                                        INPUT        TABLE tt-var,
                                                        INPUT-OUTPUT TABLE tt-erro,
                                                        INPUT        YES).

    /* Se for estabelecimento diferente precisa buscar novamente a formula */
    IF p-c-cod-estab <> c-cod-estab-ant THEN DO:
        FIND FIRST param-aquis-rural NO-LOCK
             WHERE param-aquis-rural.cod-estabel = p-c-cod-estab NO-ERROR.

        IF NOT AVAIL param-aquis-rural OR param-aquis-rural.dsl-formul-event = "" THEN /* Nao tem parametro cadastrado ou nao tem formula retorna 0 de imposto */
            RETURN "NOK":U.

        ASSIGN c-formula-ant   = param-aquis-rural.dsl-formul-event /* Formula do Evento de Imposto Sanidade Rural - AQ0101 */
               c-cod-estab-ant = p-c-cod-estab. /* atualiza estabelecimento anterior */
    END.

    empty temp-table tt-formula.
    empty temp-table tt-var.
    empty temp-table tt-erro.

    create tt-formula.
    assign tt-formula.formula               = c-formula-ant
           tt-formula.cod-versao-integracao = 001
           tt-formula.sequencia             = 1
           tt-formula.tipo-res              = 1. /* Decimal */
    CREATE tt-var.
    ASSIGN tt-var.nome      = "VOLUME_MES":U
           tt-var.valor     = p-d-volume-mes
           tt-var.tipo-res  = 1.

    run pi-processa-formulas in h-cdapi020a (INPUT-OUTPUT TABLE tt-formula,
                                             INPUT        TABLE tt-var,
                                             INPUT-OUTPUT TABLE tt-erro,
                                             INPUT        YES).

    if can-find (first tt-erro) then do:
        FOR EACH tt-erro:
            RUN criaRowErrorsEvoluida (INPUT tt-erro.cd-erro,
                                       INPUT "",
                                       INPUT tt-erro.mensagem). /* Mensagem pronta, nao precisa consultar no cadastro de mensagens */
        END.
        return "NOK":U.
    end.

    FIND FIRST tt-formula no-lock no-error.
    ASSIGN p-d-val-impto   = IF AVAIL tt-formula THEN tt-formula.RESULT ELSE 0.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE getRowErrors:
    DEF OUTPUT PARAM TABLE FOR rowErrors.
END PROCEDURE.

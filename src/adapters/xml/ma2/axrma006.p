&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AXRMA006 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i axrma006 MAX}
&ENDIF


/*------------------------------------------------------------------------
    File        : axrma006.p
    Purpose     : Recebimento de Item
    Syntax      :
    Description :
    Author(s)   :
    Created     : 26/11/2007
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .P file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* DEFINE PRE-PROCESSADORES */
&GLOBAL-DEFINE XmlApp            MA2
&GLOBAL-DEFINE XmlProdName       EMS2
&GLOBAL-DEFINE XmlProdVersion    204
&GLOBAL-DEFINE XmlTranName       UnitOfMeasure
&GLOBAL-DEFINE XmlMinTranVersion 204.000
&GLOBAL-DEFINE XmlMaxTranVersion 204.999
&GLOBAL-DEFINE XmlListOfAction   add,upd,del


{xmlinc/xmlloadmessagehandlerrecdef.i}
{xmlinc/xmlloadgenxmlrecdef.i}
{utp/ut-glob.i} /* Vari†veis Globais          */
{cdp/cd0666.i}  /* Temp-table de erros padr∆o */
{cdp/cdcfgman.i}


{method/dbotterr.i}
{inbo/boin417.i tt-tab-unidade}


def var hDBOTab-Unidade             as handle               no-undo.               
def var i-sequencia                 as int                  no-undo.
def var c-cod-erro                  as char format "x(500)" no-undo.
def var i-dimensao                  as int                  no-undo.
def var iUnitOfMeasure              as int                  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 7.92
         WIDTH              = 39.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* DEFINE A PROCEDURE getTransSubsInfo  */
{xmlinc/xmlgettranssubsinfo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-piAlteraUnidade) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAlteraUnidade Procedure 
PROCEDURE piAlteraUnidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var iErro as int no-undo.
    def var c-cod-erro as char no-undo.

    /* Cria Unidade de Medida */
    if not valid-handle(hDBOTab-Unidade) or
        hDBOTab-Unidade:type <> "PROCEDURE":U or
        hDBOTab-Unidade:file-name <> "inbo/boin417.p":U then do:
        run inbo/boin417.p persistent set hDBOTab-Unidade.
    end.

    run openQueryStatic in hDBOTab-Unidade (input "Main":U) no-error.

    run goToKey in hDBOTab-Unidade(input tt-tab-unidade.un).
    if return-value <> "ok" then do:
        create tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "O_c¢digo_da_unidade_de_medida_n∆o_pode_ser_alterado" *}
        assign tt-erro.i-sequen = i-sequencia + 1
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = RETURN-VALUE
               i-sequencia      = i-sequencia + 1.
        return "nok":u.
    end.
    else do:
        run emptyRowErrors in hDBOTab-Unidade.
        run setRecord in hDBOTab-Unidade (input table tt-tab-unidade).
        run updateRecord in hDBOTab-Unidade.
        if return-value <> "ok" then do:    
            run getRowErrors in hDBOTab-Unidade(output table RowErrors).
            if can-find(first RowErrors
                        where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
    
                for each RowErrors:
    
                    create tt-erro.
                    assign tt-erro.i-sequen = i-sequencia + 1
                           tt-erro.cd-erro  = RowErrors.ErrorNumber
                           tt-erro.mensagem = RowErrors.ErrorDescription
                           i-sequencia      = i-sequencia + 1.
    
                end.
    
                return "NOK":U.
            end.
        end.           
    end.
       
    if valid-handle(hDBOTab-Unidade) then
        run destroy in hDBOTab-Unidade.  

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piCriaUnidade) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaUnidade Procedure 
PROCEDURE piCriaUnidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var iErro as int no-undo.

    /* Cria Unidade de Medida */
    if not valid-handle(hDBOTab-Unidade) or
        hDBOTab-Unidade:type <> "PROCEDURE":U or
        hDBOTab-Unidade:file-name <> "inbo/boin417.p":U then do:
        run inbo/boin417.p persistent set hDBOTab-Unidade.
    end.

    run openQueryStatic in hDBOTab-Unidade (input "Main":U) no-error.

    run emptyRowErrors in hDBOTab-Unidade.
    run setRecord in hDBOTab-Unidade (input table tt-tab-unidade).
    run createRecord in hDBOTab-Unidade.
    if return-value <> "ok" then do:    
        run getRowErrors in hDBOTab-Unidade(output table RowErrors).
        if can-find(first RowErrors
                    where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:

            for each RowErrors:

                create tt-erro.
                assign tt-erro.i-sequen = i-sequencia + 1
                       tt-erro.cd-erro  = RowErrors.ErrorNumber
                       tt-erro.mensagem = RowErrors.ErrorDescription
                       i-sequencia      = i-sequencia + 1.

            end.

            return "NOK":U.
        end.
    end.           
       
    if valid-handle(hDBOTab-Unidade) then
        run destroy in hDBOTab-Unidade.  

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piExcluiUnidade) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExcluiUnidade Procedure 
PROCEDURE piExcluiUnidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def var iErro as int no-undo.

    /* Cria Unidade de Medida */
    if not valid-handle(hDBOTab-Unidade) or
        hDBOTab-Unidade:type <> "PROCEDURE":U or
        hDBOTab-Unidade:file-name <> "inbo/boin417.p":U then do:
        run inbo/boin417.p persistent set hDBOTab-Unidade.
    end.

    run openQueryStatic in hDBOTab-Unidade (input "Main":U) no-error.

    run pi-valida-exclusao-eai in hDBOTab-Unidade (input tt-tab-unidade.un).
    if return-value <> "ok" then do:
        create tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Existem_itens_utilizando_esta_unidade_de_medida,_portando_n∆o_pode_ser_exclu°do" *}
        assign tt-erro.i-sequen = i-sequencia + 1
               tt-erro.cd-erro  = 17006
               tt-erro.mensagem = RETURN-VALUE
               i-sequencia      = i-sequencia + 1.
        return "nok":u.
    end.
    else do:

        run goToKey in hDBOTab-Unidade(input tt-tab-unidade.un).
        if return-value <> "ok" then do:
            create tt-erro.
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "O_unidade_de_medida_n∆o_foi_encontrada" *}
            assign tt-erro.i-sequen = i-sequencia + 1
                   tt-erro.cd-erro  = 17006
                   tt-erro.mensagem = RETURN-VALUE
                   i-sequencia      = i-sequencia + 1.
            return "nok":u.
        end.
        else do:
            run emptyRowErrors in hDBOTab-Unidade.
            run setRecord in hDBOTab-Unidade (input table tt-tab-unidade).
            run deleteRecord in hDBOTab-Unidade.
            if return-value <> "ok" then do:    
                run getRowErrors in hDBOTab-Unidade(output table RowErrors).
                if can-find(first RowErrors
                            where RowErrors.ErrorType <> "INTERNAL":U no-lock) then do:
        
                    for each RowErrors:
        
                        create tt-erro.
                        assign tt-erro.i-sequen = i-sequencia + 1
                               tt-erro.cd-erro  = RowErrors.ErrorNumber
                               tt-erro.mensagem = RowErrors.ErrorDescription
                               i-sequencia      = i-sequencia + 1.
        
                    end.
        
                    return "NOK":U.
                end.
            end.           
        end.
    end.
       
    if valid-handle(hDBOTab-Unidade) then
        run destroy in hDBOTab-Unidade.  

return "ok":u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveMessage Procedure 
PROCEDURE receiveMessage :
/*------------------------------------------------------------------------------
  Purpose: RECEBE A MENSAGEM DO CONTROL BROKER E PROCESSA A MESMA PARA ENTREGAR AO DESTinO
  Parameters: pinputXml, poutputXml
  Notes:       
------------------------------------------------------------------------------*/

    /* ParÉmetros de entrada e de sa°da */
    def input  param hinputXML  as handle no-undo.
    def output param houtputXML as handle no-undo.

    /* Vari†veis locais */
    def var hGenXml          as handle no-undo.
    def var cReturnValue     as char   no-undo.
    def var hBusinessContent as handle no-undo.
    def var lSuccessProcess  as log    no-undo.
    def var cValue           as char   no-undo.
    def var cNodeName        as char   no-undo.
    def var iIdList          as int    no-undo.
    def var iIdLine          as int    no-undo.
    def var iIdNext          as int    no-undo.
    def var cTranEvent       as char   no-undo.
    def var cTranVersion     as char   no-undo.
    def var cErrorText       as char   no-undo.
    def var iCount           as int    no-undo.
    def var cListRootSon     as char   no-undo.
    def var iContRootSon     as int    no-undo.
    def var hMessageHandler  as handle no-undo.
    def var cTranAction      as char   no-undo.


    /* Verifica se MessageHandler.p est† na mem¢ria */
    {xmlinc/xmlloadmessagehandlerrec.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue" &MHReturnError="houtputXML"}

    /* Verifica se o MessageHandler foi executado corretamente */
    if cReturnValue <> "OK":U then  
        if cReturnValue <> ? and  
           cReturnValue <> "" then  
            run setError in hMessageHandler (input 0,
                                             input "enviroment_error":U,
                                             input cReturnValue).

    /* Faz a interpretaá∆o e alguns processos na mensagem que recebe */
    run parseMessage in hMessageHandler (input  hinputXml,
                                         input "{&XmlTranName}",
                                         input "{&XmlMaxTranVersion}",
                                         input "{&XmlMinTranVersion}",
                                         input 
                                         &if defined (XmlListOfEvents) <> 0 &then
                                             "{&XmlListOfEvents}",
                                         &else
                                             "",
                                         &endif
                                         output lSuccessProcess,
                                         output cTranAction,
                                         output cTranEvent,
                                         output cTranVersion,
                                         output houtputXML ).

    /* Se n∆o processou corretamente, retorna erro */
    if not lSuccessProcess or 
        return-value <> "OK" then do:

        if cReturnValue <> ? and 
           cReturnValue <> " " then do:
            run setError in hMessageHandler (input 0,
                                             input "enviroment_error":U,
                                             input cReturnValue).
        end.

    end.
    else do:
        /* Obtem a parte da mensagem que est† abaixo do elemento BusinessContent */
        run getBusinessContent in hMessageHandler (output hBusinessContent).

        /* Verifica se XMLAPI est† na mem¢ria */
        {xmlinc/xmlloadgenxmlrec.i &GenXml="hGenXml" &GXReturnValue="cReturnValue" &GXReturnError="houtputXML"}
       
        /* Verifica se o ut-genxml foi iniciado corretamente */
        if cReturnValue <> "OK":U then  
            if cReturnValue <> ? and  
               cReturnValue <> "" then do:
                delete object hBusinessContent no-error.
                run setError in hMessageHandler (input 0,
                                                 input "enviroment_error":U,
                                                 input cReturnValue).
            end.

        /* Limpa as temp-tables internas da API XML */
        run reset in hGenXml.

        /* Carrega a estrutura filha de BusinessContent */
        run loadXml in hGenXml (hBusinessContent).

        /* Elimina a mensagem obtida no mÇtodo getBusinessContent */
        delete object hBusinessContent no-error.

        /* Cria um registro para receber os valores dos filhos do elemento raiz (Upsert ou Delete) */
        empty temp-table tt-erro.

        create tt-tab-unidade.
        assign i-sequencia = 0.

        run getSonVal in hGenXml (input 1, input "UnitOfMeasureCode":U, output tt-tab-unidade.un).
        run getSonVal in hGenXml (input 1, input "UnitOfMeasureDescription":U, output tt-tab-unidade.descricao).
        &if defined(bf_man_205) &then
            run getSonDec in hGenXml (input 1, input "Dimension":U, output i-dimensao).
            IF i-dimensao = ? THEN
                ASSIGN i-dimensao = 1.
            if i-dimensao < 1 or 
               i-dimensao > 5 then
                assign tt-tab-unidade.dimensao = 1.
            else
                assign tt-tab-unidade.dimensao = i-dimensao.
        &endif
        
    end.

    if cTranAction = "add":u then
        run piCriaUnidade.
    else do:
        if cTranAction = "upd":u then
            run piAlteraUnidade.
        else
            run piExcluiUnidade.
    end.

    for each tt-erro no-lock:

        {utp/ut-liter.i "Erro de integraá∆o. Durante sua execuá∆o ocorreu o(s) seguinte(s) erro(s) de Progress:"}
        run setError in hMessageHandler (input tt-erro.cd-erro,
                                         input "business_error":U,  /* Erro de neg¢cio */
                                         input return-value + tt-erro.mensagem).
    end.

    /* Obtem mensagem de retorno (erro ou confirmacao) */
    run getReturnMessage in hMessageHandler (output houtputXML). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
*/ 


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ped-draw-nfe NO-UNDO LIKE ped-draw-nfe
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-ped-draw-nfe-imp NO-UNDO LIKE ped-draw-nfe
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-ped-draw-nfe-nac NO-UNDO LIKE ped-draw-nfe
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX414 2.00.00.031 } /*** "010031" 07/10/2024 16:59:57 ***/
&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX414 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName Pedido-drb-NFE
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ped-draw-nfe
&GLOBAL-DEFINE TableLabel Pedido-drb-NFE
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{cxbo/bocx414.i RowObject}
{cxbo/bocx414.i tt-pedido-drb-nfe}

DEFINE VARIABLE c-pedido       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-estabel      AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE h-bocx313      AS HANDLE                       NO-UNDO.
DEFINE VARIABLE h-bocx315      AS HANDLE                       NO-UNDO.
DEFINE VARIABLE l-erro         AS LOGICAL                      NO-UNDO.

DEF VAR h-exapi025        AS HANDLE    NO-UNDO.
DEF VAR i-nivel           AS INTEGER   NO-UNDO.
DEF VAR c-programa        AS CHARACTER NO-UNDO.
DEF VAR c-ultimo-programa AS CHARACTER NO-UNDO.
/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-ped-draw-nfe T "?" NO-UNDO eai ped-draw-nfe
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ped-draw-nfe-imp T "?" NO-UNDO mgcex ped-draw-nfe
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ped-draw-nfe-nac T "?" NO-UNDO mgcex ped-draw-nfe
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 11.33
         WIDTH              = 42.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT CAN-FIND(FIRST Pedido-drb-DI NO-LOCK
                        WHERE Pedido-drb-DI.cod-estabel       = RowObject.cod-estab
                        AND   Pedido-drb-DI.nr-pedido-drb     = RowObject.cod-ped-draw
                        AND   Pedido-drb-DI.declaracao-import = trim(SUBSTRING(RowObject.cod-livre-1,1,20))) THEN DO:
    
        CREATE Pedido-drb-DI.
        ASSIGN Pedido-drb-DI.cod-estabel       = RowObject.cod-estab
               Pedido-drb-DI.nr-pedido-drb     = RowObject.cod-ped-draw
               Pedido-drb-DI.declaracao-import = trim(SUBSTRING(RowObject.cod-livre-1,1,20)).
    END.

    /* Parƒmetro IM0000 - Tabela Documentos Relacionados - param-imp.char-1,229,1 */
    FOR FIRST param-imp FIELDS (char-1) NO-LOCK
        WHERE param-imp.cod-estabel = RowObject.cod-estab:
        IF TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
            {utp/ut-liter.i "Cria‡Æo"}
            RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-bocx313) THEN
        RUN cxbo/bocx313.p PERSISTENT SET h-bocx313.

    RUN eliminaDINfe IN h-bocx313(INPUT RowObject.cod-ped-draw,
                                  INPUT RowObject.cod-estab,
                                  INPUT TRIM(SUBSTRING(RowObject.cod-livre-1,1,20))).

    FOR EACH tab-ocor EXCLUSIVE-LOCK
        WHERE tab-ocor.cod-tab = 720
        AND   trim(SUBSTRING(tab-ocor.char-1,1,5))   = RowObject.cod-ser-docto   
        AND   trim(SUBSTRING(tab-ocor.char-1,6,16))  = RowObject.cod-docto
        AND   trim(SUBSTRING(tab-ocor.char-1,22,6))  = RowObject.cod-natur-operac
        AND   trim(SUBSTRING(tab-ocor.char-1,28,12)) = STRING(RowObject.cdn-emitente)
        AND   tab-ocor.int-2                         = 1:

        FOR FIRST pedido-drb-item EXCLUSIVE-LOCK
            WHERE pedido-drb-item.cod-estabel   = RowObject.cod-estab  
            AND   pedido-drb-item.nr-pedido-drb = RowObject.cod-ped-draw
            AND   pedido-drb-item.it-codigo     = trim(SUBSTRING(tab-ocor.char-1,60,16))
            AND   pedido-drb-item.idi-reg       = tab-ocor.int-2:
            
            IF NOT tab-ocor.log-1 THEN
                ASSIGN pedido-drb-item.qtd-item-nac = pedido-drb-item.qtd-item-nac - tab-ocor.dec-1.
            ELSE
                ASSIGN pedido-drb-item.quantidade = pedido-drb-item.quantidade - tab-ocor.dec-1.

            IF pedido-drb-item.quantidade <= 0 AND
                pedido-drb-item.qtd-item-nac <= 0 THEN
                DELETE pedido-drb-item.
        END.
        DELETE tab-ocor.
    END.

    IF VALID-HANDLE(h-bocx313) THEN DO:
        DELETE PROCEDURE h-bocx313.
        ASSIGN h-bocx313 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroy DBOProgram 
PROCEDURE afterDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-exapi025) THEN DO:
        DELETE PROCEDURE h-exapi025.
        ASSIGN h-exapi025 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Parƒmetro IM0000 - Tabela Documentos Relacionados - param-imp.char-1,229,1 */
    FOR FIRST param-imp FIELD (char-1) NO-LOCK
        WHERE param-imp.cod-estabel = rowObject.cod-estab:
        IF TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
            {utp/ut-liter.i "Altera‡Æo"}
            RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
        END.    
    END.

RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    /* Parƒmetro IM0000 - Tabela Documentos Relacionados - param-imp.char-1,229,1 */
    FOR FIRST param-imp FIELD (char-1) NO-LOCK
        WHERE param-imp.cod-estabel = rowObject.cod-estab:
        
        IF TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
            IF NOT VALID-HANDLE(h-exapi025) THEN
                RUN exp/exapi025.p PERSISTENT SET h-exapi025.
            
            RUN pi-salva-valor-antigo IN h-exapi025(INPUT "ped-draw-nfe":U, INPUT rowObject.r-rowid). 
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST param-imp NO-LOCK
         WHERE param-imp.cod-estabel = RowObject.cod-estab NO-ERROR.

    /* Parƒmetro IM0000 - Tabela Documentos Relacionados - param-imp.char-1,229,1 */
    IF AVAIL param-imp AND TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
        IF NOT VALID-HANDLE(h-exapi025) THEN
            RUN exp/exapi025.p PERSISTENT SET h-exapi025.

        RUN pi-salva-valor-antigo IN h-exapi025(INPUT "ped-draw-nfe":U, INPUT ?).
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaNfe DBOProgram 
PROCEDURE eliminaNfe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-estabel like pedido-drb.cod-estabel   no-undo.
    def input param p-pedido  like pedido-drb.nr-pedido-drb no-undo.
    
    for each bf{&TableName} 
        where bf{&TableName}.cod-estab  = p-estabel 
          and bf{&TableName}.cod-ped-draw = p-pedido exclusive-lock:
        delete bf{&TableName}.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-natur-operac":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac.
        WHEN "cod-ped-draw":U THEN ASSIGN pFieldValue = RowObject.cod-ped-draw.
        WHEN "cod-ser-docto":U THEN ASSIGN pFieldValue = RowObject.cod-ser-docto.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice pddrwnf-id
  Parameters:  
               retorna valor do campo cod-ser-docto
               retorna valor do campo cod-docto
               retorna valor do campo cdn-emitente
               retorna valor do campo cod-natur-operac
               retorna valor do campo cod-ped-draw
               retorna valor do campo cod-estab
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-ser-docto LIKE ped-draw-nfe.cod-ser-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-docto LIKE ped-draw-nfe.cod-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-emitente LIKE ped-draw-nfe.cdn-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-natur-operac LIKE ped-draw-nfe.cod-natur-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-ped-draw LIKE ped-draw-nfe.cod-ped-draw NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estab LIKE ped-draw-nfe.cod-estab NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-ser-docto = RowObject.cod-ser-docto
           pcod-docto = RowObject.cod-docto
           pcdn-emitente = RowObject.cdn-emitente
           pcod-natur-operac = RowObject.cod-natur-operac
           pcod-ped-draw = RowObject.cod-ped-draw
           pcod-estab = RowObject.cod-estab.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice pddrwnf-id
  Parameters:  
               recebe valor do campo cod-ser-docto
               recebe valor do campo cod-docto
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-natur-operac
               recebe valor do campo cod-ped-draw
               recebe valor do campo cod-estab
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-ser-docto LIKE ped-draw-nfe.cod-ser-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto LIKE ped-draw-nfe.cod-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente LIKE ped-draw-nfe.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE ped-draw-nfe.cod-natur-operac NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ped-draw LIKE ped-draw-nfe.cod-ped-draw NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab LIKE ped-draw-nfe.cod-estab NO-UNDO.

    FIND FIRST bfped-draw-nfe WHERE 
        bfped-draw-nfe.cod-ser-docto = pcod-ser-docto AND 
        bfped-draw-nfe.cod-docto = pcod-docto AND 
        bfped-draw-nfe.cdn-emitente = pcdn-emitente AND 
        bfped-draw-nfe.cod-natur-operac = pcod-natur-operac AND 
        bfped-draw-nfe.cod-ped-draw = pcod-ped-draw AND 
        bfped-draw-nfe.cod-estab = pcod-estab NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfped-draw-nfe THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfped-draw-nfe)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkTott-pedido-drb DBOProgram 
PROCEDURE linkTott-pedido-drb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM ph-ordem AS HANDLE NO-UNDO.
    
    RUN getKey IN ph-ordem (OUTPUT c-estabel,
                            OUTPUT c-pedido).
                            
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadTtPedDrawNfe DBOProgram 
PROCEDURE loadTtPedDrawNfe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
   DEFINE INPUT PARAMETER r-row AS ROWID NO-UNDO. 
   DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-ped-draw-nfe.

   EMPTY TEMP-TABLE tt-ped-draw-nfe NO-ERROR.

   FOR FIRST pedido-drb FIELDS(cod-estabel nr-pedido-drb) WHERE 
       ROWID(pedido-drb) = r-row:
    
       FOR EACH ped-draw-nfe NO-LOCK WHERE 
                ped-draw-nfe.cod-estab = pedido-drb.cod-estabel AND
                ped-draw-nfe.cod-ped-draw = pedido-drb.nr-pedido-drb:
           CREATE tt-ped-draw-nfe.
           BUFFER-COPY ped-draw-nfe TO tt-ped-draw-nfe. 
       END.
   END.
   RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter i-abertura as integer no-undo.
    
    case i-abertura:
        when 1 then 
           run openQueryStatic ("Main").
        when 2 then 
           run openQueryStatic ("NfebyPedidoDrb").           
    end case. /*end case*/
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH ped-draw-nfe NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNfebyPedidoDrb DBOProgram 
PROCEDURE openQueryNfebyPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Ped-Draw-Nfe NO-LOCK where 
                                     Ped-Draw-Nfe.cod-estab   = c-estabel and
                                     Ped-Draw-Nfe.cod-ped-draw = c-pedido 
                                     INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNfebyRowidPedidoDrb DBOProgram 
PROCEDURE openQueryNfebyRowidPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Ped-Draw-Nfe NO-LOCK where 
                                     Ped-Draw-Nfe.cod-estab   = c-estabel and
                                     Ped-Draw-Nfe.cod-ped-draw = c-pedido 
                                     INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-historico-criacao-alteracao DBOProgram 
PROCEDURE pi-cria-historico-criacao-alteracao :
/*------------------------------------------------------------------------------------------
Purpose:    Realiza a cria‡Æo do hist¢rico de cria‡Æo/altera‡Æo.
Parameters: c-metodo       : INPUT  : M²todo(Cria‡Æo, Altera‡Æo);
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-metodo AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE r-rowidAux       AS ROWID       NO-UNDO.

    /* Verifica qual o £ltimo programa .w que executou esta procedure */
    ASSIGN i-nivel = 1.
    nivel_block:
    REPEAT WHILE PROGRAM-NAME(i-nivel) <> ?.
        ASSIGN c-programa = REPLACE(PROGRAM-NAME(i-nivel),"~/","~\")
               i-nivel = i-nivel + 1.

        IF c-programa MATCHES "*men*":U THEN NEXT.
        IF c-programa MATCHES "*.w":U THEN DO:
            ASSIGN c-ultimo-programa = ENTRY(NUM-ENTRIES(c-programa,"~\"),c-programa,"~\").
        END.
    END.
    /****************************************************************/

    IF NOT VALID-HANDLE(h-exapi025) THEN
        RUN exp/exapi025.p PERSISTENT SET h-exapi025.

    FOR FIRST ped-draw-nfe FIELDS(cod-estab)
        WHERE ped-draw-nfe.cod-ser-docto    = RowObject.cod-ser-docto
        AND   ped-draw-nfe.cod-docto        = RowObject.cod-docto
        AND   ped-draw-nfe.cdn-emitente     = RowObject.cdn-emitente
        AND   ped-draw-nfe.cod-natur-operac = RowObject.cod-natur-operac
        AND   ped-draw-nfe.cod-ped-draw     = RowObject.cod-ped-draw
        AND   ped-draw-nfe.cod-estab        = RowObject.cod-estab NO-LOCK:
        ASSIGN r-rowidAux = ROWID(ped-draw-nfe).
    END.
    RUN pi-salva-alteracao IN h-exapi025 (INPUT c-metodo, INPUT "ped-draw-nfe":U, INPUT r-rowidAux, INPUT c-ultimo-programa).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-tt-ped-draw-nfe-import DBOProgram 
PROCEDURE pi-get-tt-ped-draw-nfe-import :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-cod-estab    LIKE {&TableName}.cod-estab   NO-UNDO.
    DEFINE INPUT PARAM p-cod-ped-draw LIKE {&TableName}.cod-ped-draw NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-ped-draw-nfe-imp.

    EMPTY TEMP-TABLE tt-ped-draw-nfe-imp.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estab    = p-cod-estab
        AND   bf{&TableName}.cod-ped-draw = p-cod-ped-draw,
            FIRST emitente NO-LOCK                  
                WHERE emitente.cod-emitente = bf{&TableName}.cdn-emitente
                AND   emitente.natureza >= 3:

            /* Natureza = 4 pode ser nacional ou internacional, verificar se emitente.pais = estabelec.pais */
            IF emitente.natureza = 4 THEN DO:
                FIND FIRST estabelec NO-LOCK
                    WHERE estabelec.cod-estabel = p-cod-estab NO-ERROR.
                IF emitente.pais = estabelec.pais THEN /* nacional */
                    NEXT.
            END.

            CREATE tt-ped-draw-nfe-imp.
            BUFFER-COPY bf{&TableName} TO tt-ped-draw-nfe-imp.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-tt-ped-draw-nfe-imp-filter DBOProgram 
PROCEDURE pi-get-tt-ped-draw-nfe-imp-filter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estab      LIKE {&TableName}.cod-estab     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-ped-draw   LIKE {&TableName}.cod-ped-draw  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estab-ini  LIKE {&TableName}.cod-estab     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estab-fim  LIKE {&TableName}.cod-estab     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-serie-ini  LIKE {&TableName}.cod-ser-docto NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-serie-fim  LIKE {&TableName}.cod-ser-docto NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-docto-ini  LIKE {&TableName}.cod-docto     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-docto-fim  LIKE {&TableName}.cod-docto     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ped-draw-nfe-imp.

    EMPTY TEMP-TABLE tt-ped-draw-nfe-imp.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estab      = p-cod-estab
        AND   bf{&TableName}.cod-ped-draw   = p-cod-ped-draw
        AND   (bf{&TableName}.cod-estab    >= p-cod-estab-ini 
        AND   bf{&TableName}.cod-estab     <= p-cod-estab-fim 
        AND   bf{&TableName}.cod-ser-docto >= p-cod-serie-ini 
        AND   bf{&TableName}.cod-ser-docto <= p-cod-serie-fim 
        AND   bf{&TableName}.cod-docto     >= p-cod-docto-ini 
        AND   bf{&TableName}.cod-docto     <= p-cod-docto-fim) ,
            FIRST emitente NO-LOCK                  
                WHERE emitente.cod-emitente = bf{&TableName}.cdn-emitente
                AND   emitente.natureza >= 3:

            /* Natureza = 4 pode ser nacional ou internacional, verificar se emitente.pais = estabelec.pais */
            IF emitente.natureza = 4 THEN DO:
                FIND FIRST estabelec NO-LOCK
                    WHERE estabelec.cod-estabel = p-cod-estab NO-ERROR.
                IF emitente.pais = estabelec.pais THEN /* nacional */
                    NEXT.
            END.

            CREATE tt-ped-draw-nfe-imp.
            BUFFER-COPY bf{&TableName} TO tt-ped-draw-nfe-imp.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-tt-ped-draw-nfe-nac DBOProgram 
PROCEDURE pi-get-tt-ped-draw-nfe-nac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-cod-estab    LIKE {&TableName}.cod-estab   NO-UNDO.
    DEFINE INPUT PARAM p-cod-ped-draw LIKE {&TableName}.cod-ped-draw NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-ped-draw-nfe-nac.

    EMPTY TEMP-TABLE tt-ped-draw-nfe-nac.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estab    = p-cod-estab
        AND   bf{&TableName}.cod-ped-draw = p-cod-ped-draw,
            FIRST emitente NO-LOCK                  
                WHERE emitente.cod-emitente = bf{&TableName}.cdn-emitente
                AND   emitente.natureza <> 3:

            /* Natureza = 4 pode ser nacional ou internacional, verificar se emitente.pais = estabelec.pais */
            IF emitente.natureza = 4 THEN DO:
                FIND FIRST estabelec NO-LOCK
                    WHERE estabelec.cod-estabel = p-cod-estab NO-ERROR.
                IF emitente.pais <> estabelec.pais THEN /* internacional */
                    NEXT.
            END.

            CREATE tt-ped-draw-nfe-nac.
            BUFFER-COPY bf{&TableName} TO tt-ped-draw-nfe-nac.
    END.

    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-tt-ped-draw-nfe-nac-filter DBOProgram 
PROCEDURE pi-get-tt-ped-draw-nfe-nac-filter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estab      LIKE {&TableName}.cod-estab     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-ped-draw   LIKE {&TableName}.cod-ped-draw  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estab-ini  LIKE {&TableName}.cod-estab     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estab-fim  LIKE {&TableName}.cod-estab     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-serie-ini  LIKE {&TableName}.cod-ser-docto NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-serie-fim  LIKE {&TableName}.cod-ser-docto NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-docto-ini  LIKE {&TableName}.cod-docto     NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-docto-fim  LIKE {&TableName}.cod-docto     NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-ped-draw-nfe-nac.

    EMPTY TEMP-TABLE tt-ped-draw-nfe-nac.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estab    = p-cod-estab
        AND   bf{&TableName}.cod-ped-draw = p-cod-ped-draw
        AND   (bf{&TableName}.cod-estab    >= p-cod-estab-ini 
        AND   bf{&TableName}.cod-estab     <= p-cod-estab-fim 
        AND   bf{&TableName}.cod-ser-docto >= p-cod-serie-ini 
        AND   bf{&TableName}.cod-ser-docto <= p-cod-serie-fim 
        AND   bf{&TableName}.cod-docto     >= p-cod-docto-ini 
        AND   bf{&TableName}.cod-docto     <= p-cod-docto-fim) ,
            FIRST emitente NO-LOCK                  
                WHERE emitente.cod-emitente = bf{&TableName}.cdn-emitente
                AND   emitente.natureza <> 3:

            /* Natureza = 4 pode ser nacional ou internacional, verificar se emitente.pais = estabelec.pais */
            IF emitente.natureza = 4 THEN DO:
                FIND FIRST estabelec NO-LOCK
                    WHERE estabelec.cod-estabel = p-cod-estab NO-ERROR.
                IF emitente.pais <> estabelec.pais THEN /* internacional */
                    NEXT.
            END.

            CREATE tt-ped-draw-nfe-nac.
            BUFFER-COPY bf{&TableName} TO tt-ped-draw-nfe-nac.
    END.

    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-key-item-doc-est DBOProgram 
PROCEDURE pi-get-key-item-doc-est :
/*------------------------------------------------------------------------------
  Purpose: Retornar a chave da tabela do item da nota de entrada    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pc-cod-estab    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM pc-cod-ped-draw AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM pc-it-codigo    AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM serie-docto    AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM nro-docto      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM nat-operacao   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM cod-emitente   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAM sequencia      AS INTEGER   NO-UNDO.

    FOR EACH ped-draw-nfe 
        where ped-draw-nfe.cod-estab    = pc-cod-estab
          and ped-draw-nfe.cod-ped-draw = pc-cod-ped-draw no-lock:
        
        find first item-doc-est 
            where item-doc-est.serie-docto  = ped-draw-nfe.cod-ser-docto
              and item-doc-est.nro-docto    = ped-draw-nfe.cod-docto
              and item-doc-est.cod-emitente = ped-draw-nfe.cdn-emitente
              and item-doc-est.nat-operacao = ped-draw-nfe.cod-natur-operac no-lock no-error.

        if avail item-doc-est and item-doc-est.it-codigo = pc-it-codigo then do:
            
            assign serie-docto  = item-doc-est.serie-docto 
                   nro-docto    = item-doc-est.nro-docto   
                   nat-operacao = item-doc-est.nat-operacao
                   cod-emitente = item-doc-est.cod-emitente
                   sequencia    = item-doc-est.sequencia.   

            RETURN "OK":U.
        end.
    END.
    
    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNfebyPedidoDrb DBOProgram 
PROCEDURE setConstraintNfebyPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER ppedido  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pestabel AS CHARACTER NO-UNDO.
    
    for first pedido-drb fields(cod-estabel nr-pedido-drb) no-lock
        where pedido-drb.cod-estabel   = pestabel 
          and pedido-drb.nr-pedido-drb = ppedido:
    end.
    
    if avail pedido-drb then
        assign c-pedido  = pedido-drb.nr-pedido-drb
               c-estabel = pedido-drb.cod-estabel.
               
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNfebyRowidPedidoDrb DBOProgram 
PROCEDURE setConstraintNfebyRowidPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter r-row as rowid no-undo.
    
    for first pedido-drb fields(cod-estabel nr-pedido-drb) where 
        rowid(pedido-drb) = r-row:
    end.
    
    if avail pedido-drb then 
        assign c-estabel = pedido-drb.cod-estabel
               c-pedido  = pedido-drb.nr-pedido-drb.
              
    RETURN "OK":U.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    IF pType = "create":U THEN DO: 
  
       IF RowObject.cdn-emitente <= 0 OR
          RowObject.cdn-emitente = ? THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-emitente AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Emitente" *}
          ASSIGN c-lbl-liter-emitente = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                           &ErrorNumber=25938
                           &ErrorType="EMS"
                           &ErrorParameters="c-lbl-liter-emitente"}
       END.

       IF RowObject.cod-docto = "" OR
          RowObject.cod-docto = ? THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-documentonf AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Documento/NF" *}
          ASSIGN c-lbl-liter-documentonf = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                           &ErrorNumber=25938
                           &ErrorType="EMS"
                           &ErrorParameters="c-lbl-liter-documentonf"}
       END.

       IF RowObject.cod-natur-operac = "" OR
          RowObject.cod-natur-operac = ? THEN DO:
          /* Inicio -- Projeto Internacional */
          DEFINE VARIABLE c-lbl-liter-nat-operacao AS CHARACTER NO-UNDO.
          {utp/ut-liter.i "Nat_Opera‡Æo" *}
          ASSIGN c-lbl-liter-nat-operacao = TRIM(RETURN-VALUE).
          {method/svc/errors/inserr.i
                           &ErrorNumber=25938
                           &ErrorType="EMS"
                           &ErrorParameters="c-lbl-liter-nat-operacao"}
       END.
    
       FIND ped-draw-nfe NO-LOCK
           WHERE ped-draw-nfe.cod-ser-docto = rowObject.cod-ser-docto   
             AND ped-draw-nfe.cod-docto = rowObject.cod-docto       
             AND ped-draw-nfe.cdn-emitente = rowObject.cdn-emitente    
             AND ped-draw-nfe.cod-natur-operac = rowObject.cod-natur-operac
             AND ped-draw-nfe.cod-ped-draw = rowObject.cod-ped-draw 
             AND ped-draw-nfe.cod-estab = rowObject.cod-estab NO-ERROR.
          
       IF AVAIL ped-draw-nfe THEN DO:

           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-pedido-drawback-nota-fiscal-de AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Pedido_Drawback_Nota_Fiscal_de_entrada" *}
           ASSIGN c-lbl-liter-pedido-drawback-nota-fiscal-de = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                       &ErrorNumber=8
                       &ErrorType="EMS"
                       &ErrorSubType="Error"
                       &ErrorParameters="c-lbl-liter-pedido-drawback-nota-fiscal-de"}
       END.  

       IF NOT CAN-FIND (FIRST serie
                        WHERE serie.serie = RowObject.cod-ser-docto NO-LOCK) THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-serie AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Serie" *}
           ASSIGN c-lbl-liter-serie = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                        &ErrorNumber=28590
                        &ErrorType="EMS"
                        &ErrorParameters="c-lbl-liter-serie + '~~~~' + c-lbl-liter-serie"}
       END.
       IF NOT CAN-FIND (FIRST emitente
                        WHERE emitente.cod-emitente = RowObject.cdn-emitente NO-LOCK) THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-emitente-2 AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Emitente" *}
           ASSIGN c-lbl-liter-emitente-2 = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                        &ErrorNumber=28590
                        &ErrorType="EMS"
                        &ErrorParameters="c-lbl-liter-emitente-2 + '~~~~' + c-lbl-liter-emitente-2"}
       END.
       IF NOT CAN-FIND (FIRST natur-oper
                        WHERE natur-oper.nat-operacao = RowObject.cod-natur-operac NO-LOCK) THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-nat-operacao-2 AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Nat._Opera‡Æo" *}
           ASSIGN c-lbl-liter-nat-operacao-2 = TRIM(RETURN-VALUE).
           DEFINE VARIABLE c-lbl-liter-natur-oper AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Natur-oper" *}
           ASSIGN c-lbl-liter-natur-oper = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i
                        &ErrorNumber=28590
                        &ErrorType="EMS"
                        &ErrorParameters="c-lbl-liter-nat-operacao-2 + '~~~~' + c-lbl-liter-natur-oper"}
       END.
       FOR FIRST docum-est FIELDS(ce-atual)
            WHERE docum-est.serie-docto  = RowObject.cod-ser-docto
              AND docum-est.nro-docto    = RowObject.cod-docto
              AND docum-est.cod-emitente = RowObject.cdn-emitente
              AND docum-est.nat-operacao = RowObject.cod-natur-operac NO-LOCK:
       END.
       IF NOT AVAIL docum-est THEN DO:
            {method/svc/errors/inserr.i 
                        &ErrorNumber="952"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters=" "}
       END.
       ELSE DO:
           IF docum-est.ce-atual = NO THEN
               {method/svc/errors/inserr.i 
                           &ErrorNumber="52559"
                           &ErrorType="EMS"
                           &ErrorSubType="Error"
                           &ErrorParameters=" "}
       END.

       /* validar se a nota est  atualizada no re1001 */

    END.    

    IF pType = "delete":U THEN DO:

        IF NOT VALID-HANDLE(h-bocx315) THEN
            RUN cxbo/bocx315.p PERSISTENT SET h-bocx315.

        RUN valida-entrada-baixa IN h-bocx315 (INPUT RowObject.cod-estab,
                                               INPUT RowObject.cod-ped-draw,
                                               INPUT RowObject.cod-ser-docto,
                                               INPUT RowObject.cod-docto,
                                               INPUT RowObject.cdn-emitente,
                                               INPUT RowObject.cod-natur-operac,
                                               OUTPUT l-erro).

        IF l-erro THEN DO:
           CREATE RowErrors.
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-eliminacao-nao-permitida AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "'Elimina‡Æo_nÆo_permitida'" *}
           ASSIGN c-lbl-liter-eliminacao-nao-permitida = TRIM(RETURN-VALUE).
           DEFINE VARIABLE c-lbl-liter-nao-e-possivel-eliminar-este-d AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "'NÆo_‚_poss¡vel_eliminar_este_documento,_pois_o_saldo_dos_movimentos_ficarÆo_negativos!'" *}
           ASSIGN c-lbl-liter-nao-e-possivel-eliminar-este-d = TRIM(RETURN-VALUE).
           ASSIGN RowErrors.ErrorNumber = 17006
                  RowErrors.ErrorType = "EMS":U
                  RowErrors.ErrorSubType = "Error":U
                  RowErrors.ErrorParameters = c-lbl-liter-eliminacao-nao-permitida
                  RowErrors.ErrorHelp = c-lbl-liter-nao-e-possivel-eliminar-este-d.
        END.

        IF VALID-HANDLE(h-bocx315) THEN DO:
            DELETE PROCEDURE h-bocx315.
            ASSIGN h-bocx315 = ?.
        END.
    END.


    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


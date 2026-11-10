&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          movind            PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-carg-rural NO-UNDO LIKE carg-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-liber-carg-div NO-UNDO LIKE liber-carg
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttLiberCargAux NO-UNDO LIKE liber-carg
       FIELD r-rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram
 
{include/i-prgvrs.i BOIN00982 2.00.00.015 } /*** "010015" 17/06/2025 16:40:41 ***/

{include/i_prdvers.i} /* Vers„o Produto */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BOIN00982 MAQ}
&ENDIF
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN00982
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName liber-carg
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE excludeFrameDefinition YES

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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin00982.i RowObject}

DEFINE VARIABLE i-num-carg AS INTEGER NO-UNDO.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}    FOR {&TableName}.
DEFINE BUFFER bfLiberCarg       FOR {&TableName}.    
DEFINE BUFFER bfCargRural       FOR carg-rural.
DEFINE BUFFER bfEstabelec       FOR estabelec.
DEFINE BUFFER bfItemUniEstab    FOR item-uni-estab.
DEFINE BUFFER bfItemEstabRural  FOR item-estab-rural.
DEFINE BUFFER bfParamCQ         FOR param-cq.
    

DEFINE BUFFER bf-ficha-cq      FOR ficha-cq.
DEFINE BUFFER bf-exam-ficha    FOR exam-ficha.


DEFINE VARIABLE h-boin124a   AS HANDLE  NO-UNDO.


/* roteiro inspecao */
{cdp/cd0666.i}
{cqp/cqapi001a.i}

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
      TABLE: tt-carg-rural T "?" NO-UNDO movind carg-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-liber-carg-div T "?" NO-UNDO movind liber-carg
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttLiberCargAux T "?" NO-UNDO movind liber-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE l-eliminou AS LOGICAL INITIAL NO NO-UNDO.

    FOR EACH bf-ficha-cq EXCLUSIVE-LOCK
       &IF "{&product_version}" >= "12.1.C":U &THEN /*12.1.13*/
       WHERE bf-ficha-cq.nr-ficha = RowObject.nr-ficha:
       &ELSE
       WHERE bf-ficha-cq.nr-ficha  = RowObject.nr-ficha:
       &ENDIF

        FOR EACH bf-exam-ficha EXCLUSIVE-LOCK
              OF bf-ficha-cq:
            DELETE bf-exam-ficha.                    
        END.
        
        FOR EACH res-fic-cq EXCLUSIVE-LOCK
              OF bf-ficha-cq:
            DELETE res-fic-cq.
        END.

        FOR EACH rej-ficha EXCLUSIVE-LOCK
              OF bf-ficha-cq:
            DELETE rej-ficha.
        END.

        DELETE bf-ficha-cq.
        ASSIGN l-eliminou = YES.
    END.
    
    IF l-eliminou THEN
        RELEASE ficha-cq.   

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
    /* Atualiza ficha caso exista alteraÁ„o nos campos cod-depos e/ou lote */
    FOR FIRST ficha-cq EXCLUSIVE-LOCK
        &IF "{&product_version}" >= "12.1.C":U &THEN /*12.1.13*/
        WHERE ficha-cq.nr-ficha = RowObject.nr-ficha:
        &ELSE
        WHERE ficha-cq.nr-ficha = RowObject.num-livre-1:
        &ENDIF        
        IF ficha-cq.cod-depos <> RowObject.cod-depos THEN
            ASSIGN ficha-cq.cod-depos = RowObject.cod-depos.
        IF ficha-cq.lote <> RowObject.lote THEN
            ASSIGN ficha-cq.lote = RowObject.lote.                 
    END.
    
    IF AVAIL ficha-cq THEN
        RELEASE ficha-cq.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaSituacaoPesagem DBOProgram 
PROCEDURE buscaSituacaoPesagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-num-carg    AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pi-cdn-pesagem AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-idi-aprov  AS INTEGER NO-UNDO.    
    
    FOR EACH bfLiberCarg FIELDS(idi-aprova cdn-pesagem) NO-LOCK
       WHERE bfLiberCarg.num-carg             = pi-num-carg 
         AND bfLiberCarg.cdn-pesagem          = pi-cdn-pesagem
         AND bfLiberCarg.idi-autoriz-descarga = 1 /* Descarregado */
         AND bfLiberCarg.cdn-pesagem          > 1
         BREAK BY bfLiberCarg.cdn-pesagem:          
         
        IF LAST-OF(bfLiberCarg.cdn-pesagem) THEN
            ASSIGN pi-idi-aprov = bfLiberCarg.idi-aprova.           
    END.
    
    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcula-qtd-aferida-carga DBOProgram 
PROCEDURE calcula-qtd-aferida-carga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-num-carg  AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pd-val-quant AS DECIMAL NO-UNDO.

    FOR EACH bfLiberCarg FIELDS(val-quant)NO-LOCK
       WHERE bfLiberCarg.num-carg = pi-num-carg:
        ASSIGN pd-val-quant = pd-val-quant + bfLiberCarg.val-quant.
    END.

    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createLiberCarg DBOProgram 
PROCEDURE createLiberCarg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-carg AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-qtd-comp AS INTEGER NO-UNDO.

    DEFINE VARIABLE i            AS INTEGER NO-UNDO.
    DEFINE VARIABLE lContEstLote AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lAfericVol   AS LOGICAL NO-UNDO.  
    
    FIND FIRST bfCargRural EXCLUSIVE-LOCK
         WHERE bfCargRural.num-carg = p-num-carg NO-ERROR.

    IF AVAIL bfCargRural THEN DO:    

        FOR FIRST item FIELDS(tipo-con-est it-codigo) NO-LOCK
            WHERE item.it-codigo = bfCargRural.it-codigo:
             
            ASSIGN lContEstLote = item.tipo-con-est = 3.        
            
            FOR FIRST item-uni-estab FIELDS(deposito-pad) NO-LOCK
                WHERE item-uni-estab.it-codigo   = item.it-codigo  
                  AND item-uni-estab.cod-estabel = bfCargRural.cod-estabel: END.
                   
            FOR FIRST item-estab-rural FIELDS(num-dias-valid) NO-LOCK
                WHERE item-estab-rural.it-codigo   = item.it-codigo  
                  AND item-estab-rural.cod-estabel = bfCargRural.cod-estabel: END.             
                  
            FOR LAST pesagem FIELDS(cdn-pesagem) NO-LOCK
               WHERE pesagem.num-carg = bfCargRural.num-carg: END.
        END.    
    END.   
    
    
    RUN openQueryStatic IN THIS-PROCEDURE(INPUT 'Main':U).
    DO i = 1 TO p-qtd-comp:        
                                                                                                                                                            
        EMPTY TEMP-TABLE ttLiberCargAux NO-ERROR.        
                      
        CREATE ttLiberCargAux.
        RUN getCreateSequence IN THIS-PROCEDURE (INPUT p-num-carg, OUTPUT ttLiberCargAux.cdn-liber).      
        
        IF CAN-FIND(FIRST liber-carg 
                    where liber-carg.num-carg = p-num-carg
                      AND liber-carg.cdn-compart = i) THEN NEXT.
       
        ASSIGN ttLiberCargAux.num-carg    = p-num-carg
               ttLiberCargAux.cdn-compart = i
               ttLiberCargAux.cdn-pesagem = IF AVAIL pesagem THEN pesagem.cdn-pesagem ELSE 0.
               
               
        IF lContEstLote THEN
            ASSIGN ttLiberCargAux.lote         = STRING(p-num-carg) + ' - ' + STRING(i)
                   ttLiberCargAux.dt-vali-lote = IF AVAIL item-estab-rural THEN TODAY  + item-estab-rural.num-dias-valid ELSE TODAY. 
       
        IF AVAIL item-uni-estab THEN
            ASSIGN ttLiberCargAux.cod-depos = IF AVAIL item-uni-estab THEN item-uni-estab.deposito-pad ELSE ''.                      

        RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE ttLiberCargAux).
        RUN emptyRowErrors IN THIS-PROCEDURE.
        RUN createRecord   IN THIS-PROCEDURE.

        IF RETURN-VALUE = 'OK' THEN 
            RUN gerarRoteiroInspecao IN THIS-PROCEDURE(INPUT p-num-carg, INPUT ttLiberCargAux.cdn-compart).
        ELSE
            RETURN "NOK":U.
           
    END.
    
    IF AVAIL bfCargRural THEN
        ASSIGN bfCargRural.cdn-sit = 2. /* Em descarga */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteLiberCarg DBOProgram 
PROCEDURE deleteLiberCarg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-num-carg AS INTEGER NO-UNDO.

    FOR EACH bfLiberCarg NO-LOCK 
       WHERE bfLiberCarg.num-carg = p-num-carg:

        RUN goToKey IN THIS-PROCEDURE (INPUT bfLiberCarg.num-carg,
                                       INPUT bfLiberCarg.cdn-liber) NO-ERROR.

        IF RETURN-VALUE = "NOK":U THEN NEXT.

        RUN emptyRowErrors IN THIS-PROCEDURE.
        RUN deleteRecord   IN THIS-PROCEDURE.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dividirLiberacao DBOProgram 
PROCEDURE dividirLiberacao :
/*------------------------------------------------------------------------------
  Purpose:      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-liber-carg-div.
    
    DEFINE VARIABLE d-result           AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE d-val-peso-liq-old AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE c-txt              AS CHARACTER   NO-UNDO.

    FIND FIRST tt-liber-carg-div NO-ERROR.

    IF AVAIL tt-liber-carg-div THEN DO:

        FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
             WHERE ROWID(bf{&TableName}) = tt-liber-carg-div.r-rowid NO-ERROR.

        IF AVAIL bf{&TableName} THEN DO:

            FIND FIRST bfCargRural NO-LOCK
                 WHERE bfCargRural.num-carg = tt-liber-carg-div.num-carg NO-ERROR.

            IF AVAIL bfCargRural THEN DO:

                IF tt-liber-carg-div.val-quant = 0 THEN DO:
                    {utp/ut-liter.i Quantidade * }

                    {method/svc/errors/inserr.i &ErrorNumber="36"
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"}
                    RETURN 'NOK':U.
                END.

                IF bf{&TableName}.val-quant <= tt-liber-carg-div.val-quant THEN DO:
                   {utp/ut-liter.i Quantidade_informada * }
                   ASSIGN c-txt = RETURN-VALUE.
                   {utp/ut-liter.i quantidade_do_compartimento * } 
                   ASSIGN c-txt = c-txt + ' ~~ ' + RETURN-VALUE. 

                    {method/svc/errors/inserr.i &ErrorNumber="5820"
                                                &ErrorType="EMS"
                                                &ErrorParameters="c-txt"}
                   RETURN 'NOK':U.
                END.

                EMPTY TEMP-TABLE ttLiberCargAux NO-ERROR.       
                          
                CREATE ttLiberCargAux.
                BUFFER-COPY tt-liber-carg-div 
                     EXCEPT cdn-liber val-peso-liq 
                         TO ttLiberCargAux NO-ERROR.

                ASSIGN ttLiberCargAux.val-peso-liq = ttLiberCargAux.val-quant * bfCargRural.val-densidade.

                RUN getCreateSequence IN THIS-PROCEDURE (INPUT tt-liber-carg-div.num-carg,
                                                         OUTPUT ttLiberCargAux.cdn-liber).
    
                RUN emptyRowObject IN THIS-PROCEDURE.
                RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE ttLiberCargAux).
                RUN emptyRowErrors IN THIS-PROCEDURE.
                RUN createRecord   IN THIS-PROCEDURE.
                
                IF RETURN-VALUE = 'OK':U THEN DO:
                    ASSIGN d-val-peso-liq-old          = bf{&TableName}.val-peso-liq
                           bf{&TableName}.val-quant    = bf{&TableName}.val-quant - tt-liber-carg-div.val-quant
                           bf{&TableName}.val-peso-liq = bf{&TableName}.val-quant * bfCargRural.val-densidade.

                    ASSIGN d-result = ( bf{&TableName}.val-peso-liq + ttLiberCargAux.val-peso-liq ) - d-val-peso-liq-old.
                    /* acerto */
                    IF d-result <> 0 THEN
                        ASSIGN bf{&TableName}.val-peso-liq = bf{&TableName}.val-peso-liq - d-result.

                END.
            END.
        END.
    END.

    RETURN 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarRoteiroInspecao DBOProgram 
PROCEDURE gerarRoteiroInspecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-carg    AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-compart AS INTEGER NO-UNDO.

    DEFINE VARIABLE i-nr-ficha AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-op       AS INTEGER NO-UNDO.    
    
    FIND FIRST bfParamCQ NO-LOCK NO-ERROR.
    IF NOT AVAIL bfParamCQ THEN RETURN.

    IF NOT AVAIL bfCargRural THEN
        FIND FIRST bfCargRural NO-LOCK
             WHERE bfCargRural.num-carg = p-num-carg NO-ERROR.

    IF NOT AVAIL bfCargRural THEN RETURN "NOK".

    FIND FIRST bfLiberCarg EXCLUSIVE-LOCK
         WHERE bfLiberCarg.num-carg    = p-num-carg
           AND bfLiberCarg.cdn-compart = p-cdn-compart NO-ERROR. 

    IF NOT AVAIL bfLiberCarg THEN RETURN "NOK".

    FOR FIRST bfEstabelec FIELDS(cod-emitente) NO-LOCK
        WHERE bfEstabelec.cod-estabel = bfCargRural.cod-estabel: END.

    FOR FIRST bfItemUniEstab FIELDS (cod-localiz contr-qualid) NO-LOCK
        WHERE bfItemUniEstab.it-codigo   = bfCargRural.it-codigo
          AND bfItemUniEstab.cod-estabel = bfCargRural.cod-estabel: END. 
          
    IF AVAIL bfItemUniEstab 
         AND bfItemUniEstab.contr-qualid 
         AND bfParamCQ.tipo-cq > 1 /* Nao tem cq */ THEN DO:

        CREATE tt-ficha.
        ASSIGN tt-ficha.cod-estabel     = bfCargRural.cod-estabel
               tt-ficha.it-codigo       = bfCargRural.it-codigo
               tt-ficha.data-1          = bfCargRural.dat-trans
               tt-ficha.cod-refer       = bfCargRural.cod-refer
               tt-ficha.nro-docto       = STRING(bfLiberCarg.num-carg)
               tt-ficha.cod-depos       = bfLiberCarg.cod-depos
               tt-ficha.lote            = bfLiberCarg.lote
               tt-ficha.op-seq          = bfLiberCarg.cdn-liber
               tt-ficha.baixa-estoq     = NO
               tt-ficha.baixa-estoq     = NO               
               tt-ficha.inspecionado    = NO
               tt-ficha.liberada        = NO
               tt-ficha.inspecionado    = NO
               tt-ficha.baixa-estoq     = NO
               tt-ficha.per-ppm         = 0
               tt-ficha.qt-aprovada     = 0                   
               tt-ficha.origem          = 1 /* Manual */
               tt-ficha.qt-original     = 1
               tt-ficha.estado          = 1 /* Nao impressa*/                   
               tt-ficha.cod-localiz     = bfItemUniEstab.cod-localiz WHEN AVAIL bfItemUniEstab
               tt-ficha.cod-emitente    = bfEstabelec.cod-emitente WHEN AVAIL bfEstabelec
               tt-ficha.idi-orig-restdo = 5. /* Origem Monitor/Liberacao AQR */               


        RUN cqp/cqapi001a.p (INPUT-OUTPUT TABLE tt-ficha,
                             INPUT-OUTPUT TABLE tt-erro,
                             INPUT-OUTPUT i-nr-ficha, 
                             INPUT-OUTPUT i-op).

        &IF "{&product_version}" >= "12.1.C":U &THEN /*12.1.13*/
        ASSIGN bfLiberCarg.nr-ficha = i-nr-ficha.        
        &ELSE
        ASSIGN bfLiberCarg.num-livre-1 = i-nr-ficha.
        &ENDIF
    END.
    
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-usuario":U THEN ASSIGN pFieldValue = RowObject.cod-usuario.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCreateSequence DBOProgram 
PROCEDURE getCreateSequence :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-num-carg AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-seq AS INTEGER NO-UNDO.

    FIND LAST bfLiberCarg NO-LOCK 
        WHERE bfLiberCarg.num-carg = p-num-carg NO-ERROR.

    IF AVAILABLE bfLiberCarg THEN 
       ASSIGN p-seq = bfLiberCarg.cdn-liber + 1.
    ELSE ASSIGN p-seq = 1.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dt-vali-lote":U THEN ASSIGN pFieldValue = RowObject.dt-vali-lote.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-peso-liq":U THEN ASSIGN pFieldValue = RowObject.val-peso-liq.
        WHEN "val-quant":U THEN ASSIGN pFieldValue = RowObject.val-quant.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn-compart":U THEN ASSIGN pFieldValue = RowObject.cdn-compart.
        WHEN "cdn-liber":U THEN ASSIGN pFieldValue = RowObject.cdn-liber.
        WHEN "cdn-pesagem":U THEN ASSIGN pFieldValue = RowObject.cdn-pesagem.
        WHEN "codigo-rejei":U THEN ASSIGN pFieldValue = RowObject.codigo-rejei.
        WHEN "idi-aprova":U THEN ASSIGN pFieldValue = RowObject.idi-aprova.
        WHEN "idi-autoriz-descarga":U THEN ASSIGN pFieldValue = RowObject.idi-autoriz-descarga.
        WHEN "nr-ficha":U THEN ASSIGN pFieldValue = RowObject.nr-ficha.
        WHEN "num-carg":U THEN ASSIGN pFieldValue = RowObject.num-carg.
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
  Purpose:     Retorna valores dos campos do °ndice liber-carg-id
  Parameters:  
               retorna valor do campo num-carg
               retorna valor do campo cdn-liber
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-carg LIKE liber-carg.num-carg NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-liber LIKE liber-carg.cdn-liber NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-carg = RowObject.num-carg
           pcdn-liber = RowObject.cdn-liber.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice liber-carg-id
  Parameters:  
               recebe valor do campo num-carg
               recebe valor do campo cdn-liber
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-carg LIKE liber-carg.num-carg NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-liber LIKE liber-carg.cdn-liber NO-UNDO. 

    FIND FIRST bfliber-carg WHERE 
        bfliber-carg.num-carg = pnum-carg AND 
        bfliber-carg.cdn-liber = pcdn-liber NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfliber-carg THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfliber-carg)).

    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkTocarg-rural DBOProgram 
PROCEDURE linkTocarg-rural :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
    
    RUN getKey IN pHandle (OUTPUT i-num-carg).   

    RUN setConstraintNumCarga IN THIS-PROCEDURE(INPUT i-num-carg ).
    
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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNumCarg DBOProgram 
PROCEDURE openQueryNumCarg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE {&TableName}.num-carg = i-num-carg NO-LOCK.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNumCarga DBOProgram 
PROCEDURE setConstraintNumCarga :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-carg AS INTEGER NO-UNDO.
        
    ASSIGN i-num-carg = p-num-carg. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE unificarLiberCarg DBOProgram 
PROCEDURE unificarLiberCarg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-carg    AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-compart AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-rowid       AS ROWID   NO-UNDO.

    DEFINE VARIABLE i-qtd-compto   AS INTEGER NO-UNDO.
    DEFINE VARIABLE d-val-quant    AS DECIMAL NO-UNDO.
    DEFINE VARIABLE d-val-peso-liq AS DECIMAL NO-UNDO.

    
    FOR EACH bfLiberCarg NO-LOCK
        WHERE bfLiberCarg.num-carg    = p-num-carg
          AND bfLiberCarg.cdn-compart = p-cdn-compart:

        ASSIGN i-qtd-compto = i-qtd-compto + 1.

        ASSIGN d-val-quant    = d-val-quant    + bfLiberCarg.val-quant
               d-val-peso-liq = d-val-peso-liq + bfLiberCarg.val-peso-liq.
    END.

    IF i-qtd-compto <= 1 THEN 
        RETURN "NOK":U.
    ELSE DO:
        RUN openQueryMain IN THIS-PROCEDURE.

        FOR EACH bfLiberCarg EXCLUSIVE-LOCK
           WHERE bfLiberCarg.num-carg    = p-num-carg
             AND bfLiberCarg.cdn-compart = p-cdn-compart:

            IF ROWID(bfLiberCarg) = p-rowid THEN DO:
                ASSIGN bfLiberCarg.val-quant    = d-val-quant 
                       bfLiberCarg.val-peso-liq = d-val-peso-liq.
            END.
            ELSE DO:
                RUN goToKey IN THIS-PROCEDURE (INPUT bfLiberCarg.num-carg,
                                               INPUT bfLiberCarg.cdn-liber) NO-ERROR.
                IF RETURN-VALUE = "NOK":U THEN NEXT.
        
                RUN emptyRowErrors IN THIS-PROCEDURE.
                RUN deleteRecord   IN THIS-PROCEDURE.
            END.
        END.
    END.
    
    RETURN "OK":U.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateLiberCarg DBOProgram 
PROCEDURE updateLiberCarg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE INPUT PARAMETER p-num-carg        AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-cdn-pesagem     AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER p-val-peso-aferid AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER p-val-quant       AS DECIMAL NO-UNDO.
    
    DEFINE VARIABLE d-val-quant     AS DECIMAL           NO-UNDO.
    DEFINE VARIABLE d-tot-val-quant AS DECIMAL           NO-UNDO.  
    DEFINE VARIABLE d-diferenca     AS DECIMAL           NO-UNDO.
    DEFINE VARIABLE i-casas         AS INTEGER INITIAL 0 NO-UNDO.
    
    DEFINE VARIABLE i-qtd-div AS INTEGER NO-UNDO.

    FIND FIRST bfCargRural WHERE bfCargRural.num-carg = p-num-carg NO-LOCK NO-ERROR.
    IF AVAIL bfCargRural THEN DO: 
        FIND FIRST item WHERE item.it-codigo = bfCargRural.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL item THEN DO:
            IF item.fraciona THEN  
                ASSIGN i-casas = 4.
        END.
    END.
    
    FOR EACH bfLiberCarg NO-LOCK 
       WHERE bfLiberCarg.num-carg = p-num-carg
         AND bfLiberCarg.cdn-pesagem = p-cdn-pesagem:
             
        IF bfLiberCarg.idi-autoriz-descarga <> 1 THEN NEXT.
        
        ASSIGN i-qtd-div = i-qtd-div + 1.
    END.         

    FOR EACH bfLiberCarg NO-LOCK 
       WHERE bfLiberCarg.num-carg = p-num-carg
         AND bfLiberCarg.cdn-pesagem = p-cdn-pesagem
         BREAK BY bfLiberCarg.num-carg:

        IF bfLiberCarg.idi-autoriz-descarga <> 1 THEN NEXT.

        RUN openQueryStatic IN THIS-PROCEDURE(INPUT 'Main':U).

        RUN goToKey IN THIS-PROCEDURE (INPUT bfLiberCarg.num-carg, INPUT bfLiberCarg.cdn-compart) NO-ERROR.

        IF RETURN-VALUE = "NOK":U THEN NEXT.
        EMPTY TEMP-TABLE ttLiberCargAux NO-ERROR. 

        RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE ttLiberCargAux).

        FIND FIRST ttLiberCargAux EXCLUSIVE-LOCK NO-ERROR.

        IF NOT AVAILABLE ttLiberCargAux THEN NEXT.
        
        ASSIGN ttLiberCargAux.val-peso-liq = p-val-peso-aferid / i-qtd-div
               ttLiberCargAux.val-quant    = TRUNC((p-val-quant / i-qtd-div),i-casas).           

        ASSIGN d-val-quant       =  d-val-quant + (p-val-quant / i-qtd-div) /* Total Geral sem truncar valor */
               d-tot-val-quant   = d-tot-val-quant  + ttLiberCargAux.val-quant. /* total salvo na liber-carg*/
        
        IF LAST-OF(bfLiberCarg.num-carg) THEN DO:
            ASSIGN d-diferenca = TRUNC(ROUND(d-val-quant - d-tot-val-quant,i-casas),i-casas).
            IF d-diferenca <> 0 THEN DO:
                ASSIGN ttLiberCargAux.val-quant = ttLiberCargAux.val-quant + d-diferenca.
            END.
        END.
        
        RUN setRecord      IN THIS-PROCEDURE (INPUT TABLE ttLiberCargAux).
        RUN emptyRowErrors IN THIS-PROCEDURE.
        RUN updateRecord   IN THIS-PROCEDURE.
    END.
    
    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/ 
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = 'Create' THEN DO:
         IF CAN-FIND(FIRST bf{&TableName} 
                     WHERE bf{&TableName}.num-carg    = RowObject.num-carg
                       AND bf{&TableName}.cdn-liber   = RowObject.cdn-liber) THEN DO:
          {utp/ut-liter.i 'Liberaá∆o de Carga'}  
          {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorParameters="return-value"}

         END.
    END.
 


    IF pType = 'Update' THEN DO:
        IF NOT CAN-FIND(FIRST deposito 
                        WHERE deposito.cod-depos = RowObject.cod-depos) THEN DO:
              {utp/ut-table.i mgind deposito 1}  
              {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS"
                                            &ErrorParameters="return-value"}
        END.
        ELSE DO:
        
            FIND FIRST deposito NO-LOCK
                 WHERE deposito.cod-depos =  RowObject.cod-depos NO-ERROR.

            IF AVAIL deposito THEN DO:
                IF deposito.ind-dep-cq THEN DO:
                  {method/svc/errors/inserr.i &ErrorNumber="755" /* Dep¢sito de CQ n∆o pode ser movimentado */
                                                &ErrorType="EMS"
                                                &ErrorParameters=" "}

                END.
                ELSE IF RowObject.idi-aprova = 2 AND deposito.ind-dep-rej THEN DO: /* Aprovado */
                    {utp/ut-liter.i Rejeiá∆o} 
                    {method/svc/errors/inserr.i &ErrorNumber="27581" /*Dep¢sito informado n∆o pode ser de &1 */
                                                &ErrorType="EMS"
                                                &ErrorParameters="return-value"}

                END.
                ELSE IF RowObject.idi-aprova = 3 AND NOT deposito.ind-dep-rej THEN DO: /* Reprovado */ 
                    {method/svc/errors/inserr.i &ErrorNumber="1015" /*Dep¢sito n∆o Ç de Rejeiá∆o */
                                                &ErrorType="EMS"
                                                &ErrorParameters=" "}
                END.
            END.
        END.

        FOR FIRST carg-rural NO-LOCK
            WHERE carg-rural.num-carg = RowObject.num-carg:

            FOR FIRST item FIELDS(tipo-con-est) NO-LOCK
                WHERE item.it-codigo = carg-rural.it-codigo:
                 
                IF item.tipo-con-est = 3 THEN DO: /*controlado por lote*/
    
                    IF RowObject.lote = "":U THEN DO:
                        {method/svc/errors/inserr.i &ErrorNumber="527" /*Dep¢sito n∆o Ç de Rejeiá∆o */
                                                    &ErrorType="EMS"
                                                    &ErrorParameters=" "}
                    END.
                    
                    IF RowObject.dt-vali-lote < TODAY THEN DO:
                        {method/svc/errors/inserr.i &ErrorNumber="8015" /*Dep¢sito n∆o Ç de Rejeiá∆o */
                                                    &ErrorType="EMS"
                                                    &ErrorParameters=" "}
                    END.
    
                END.

            END. /*first item*/

        END. /*first carg-rural*/

    END. /*IF pType = update*/



    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaDescargaPendente DBOProgram 
PROCEDURE verificaDescargaPendente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-carg        AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-decarg-penden AS LOGICAL NO-UNDO.

    ASSIGN pl-decarg-penden =  CAN-FIND(FIRST bfLiberCarg
                                        WHERE bfLiberCarg.num-carg             = p-num-carg
                                          AND bfLiberCarg.idi-autoriz-descarga = 0).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consisteSituacaoRoteiro DBOProgram 
PROCEDURE consisteSituacaoRoteiro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-nr-ficha  AS INTEGER   NO-UNDO.   
    DEFINE INPUT  PARAMETER pi-nro-docto AS CHARACTER NO-UNDO.   
    DEFINE INPUT  PARAMETER c-tipo       AS CHARACTER NO-UNDO.  
    DEFINE OUTPUT PARAMETER c-params     AS CHARACTER NO-UNDO. 

    FOR FIRST bfCargRural NO-LOCK
        WHERE bfCargRural.num-carg = INT(pi-nro-docto):
     
        FOR FIRST bfLiberCarg NO-LOCK
            WHERE bfLiberCarg.num-carg = bfCargRural.num-carg 
            &IF "{&product_version}" >= "12.1.C":U &THEN /*12.1.13*/            
              AND bfLiberCarg.nr-ficha = pi-nr-ficha:               
            &ELSE
              AND bfLiberCarg.num-livre-1 = pi-nr-ficha: 
            &ENDIF            
            IF c-tipo = "APROV":U AND bfLiberCarg.idi-aprova = 3 /* Rejeitado */ THEN DO:
                {utp/ut-liter.i aprovar *}
                ASSIGN c-params = RETURN-VALUE + "~~" + STRING(bfLiberCarg.cdn-compart) + "~~" + STRING(bfLiberCarg.num-carg) + "~~".
                {utp/ut-liter.i rejeitado *}
                ASSIGN  c-params =  c-params + RETURN-VALUE.             
            END.
            ELSE IF c-tipo = "REJEI":U AND bfLiberCarg.idi-aprova = 2  /* APROVADO*/ THEN DO:
                {utp/ut-liter.i rejeitar *}
                ASSIGN c-params = RETURN-VALUE + "~~" + STRING(bfLiberCarg.cdn-compart) + "~~" + STRING(bfLiberCarg.num-carg) + "~~".
                {utp/ut-liter.i aprovado *}
                ASSIGN  c-params =  c-params + RETURN-VALUE.  
            END.            
            IF c-params <> "" THEN RETURN "NOK":U.            
        END.
    END.   
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitarBtAprovReprov DBOProgram 
PROCEDURE habilitarBtAprovReprov :
/*------------------------------------------------------------------------------
  Purpose: Verificar se existe quantidade aprovada/reprovada para o 
           compartimento.
           Habilitar/Desabilitar os botoes Aprovar e Reprovar da tela AQ0305
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-num-carg  AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cdn-liber AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-habilitar AS LOGICAL NO-UNDO.
    
    DEFINE VARIABLE l-usuar-resp AS LOGICAL NO-UNDO.
    
    ASSIGN pl-habilitar = NO.
    FOR FIRST liber-carg NO-LOCK
        WHERE liber-carg.num-carg = pi-num-carg
          AND liber-carg.cdn-liber = pi-cdn-liber:       
        FOR FIRST ficha-cq NO-LOCK
            &IF "{&product_version}" >= "12.1.C":U &THEN /*12.1.13*/         
            WHERE ficha-cq.nr-ficha = liber-carg.nr-ficha:
            &ELSE
            WHERE ficha-cq.nr-ficha = liber-carg.num-livre-1:
            &ENDIF            
            IF (ficha-cq.qt-aprovada  + ficha-cq.qt-apr-cond +
                ficha-cq.qt-consumida + ficha-cq.qt-rejeitada) > 0 THEN 
                ASSIGN pl-habilitar = NO.            
            ELSE DO:
                 /* ficha-cq  */  
                IF VALID-HANDLE(h-boin124a) THEN DO:  
                    &IF "{&product_version}" >= "12.1.C":U &THEN /*12.1.13*/         
                    RUN goToKey IN h-boin124a (INPUT liber-carg.nr-ficha).
                    &ELSE
                    RUN goToKey IN h-boin124a (INPUT liber-carg.num-livre-1).
                    &ENDIF
                    IF RETURN-VALUE = "OK":U THEN DO:
                        RUN validaResponsavelFicha IN h-boin124a.
                        ASSIGN l-usuar-resp  = RETURN-VALUE = "OK":U.
                    END.
                    /* Somente hablita se o compartimento n„o tiver sido descarregado e 
                       o usuario logado for o responsavel pela ficha */
                    ASSIGN pl-habilitar = liber-carg.idi-autoriz-descarga = 0 AND l-usuar-resp.
                END.
            END.
            
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inicializa-destroy-h-boin124a DBOProgram 
PROCEDURE inicializa-destroy-h-boin124a :
/*------------------------------------------------------------------------------
  Purpose: Inicializar handle da boin124a (ficha-cq), que ser· usado
           na procedure habilitarBtAprovReprov desta BO.
  Parameters:  <none>
  Notes:    pi-acao: 1 - Inicializa 2- Destroy    
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-acao  AS INTEGER NO-UNDO.   
    
    IF pi-acao = 1 THEN DO: /* inicializa */
        IF NOT VALID-HANDLE(h-boin124a) THEN
            RUN inbo/boin124a.p PERSISTENT SET h-boin124a.
        RUN openQueryStatic IN h-boin124a (INPUT "Main":U) NO-ERROR.      
    END.
    ELSE DO: /* destroy */
        IF VALID-HANDLE(h-boin124a) THEN DO:
            DELETE PROCEDURE h-boin124a.
            ASSIGN h-boin124a = ?.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaRejeicaoFlex DBOProgram 
PROCEDURE atualizaRejeicaoFlex :
/*------------------------------------------------------------------------------
  Purpose: Atualizar codigo de rejeicao e observaÁ„o quando o roteiro for
           rejeitado pela tela flex.
  Parameters:  pc-num-carg     => Numero da carga rural
               pi-nr-ficha     => Numero da ficha CQ
               pi-codigo-rejei => Codigo da Rejeicao
               pc-observacao   => Observacao da Rejeicao  
  Notes: 
  
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-num-carg     AS CHARACTER                 NO-UNDO.
    DEFINE INPUT PARAMETER pi-nr-ficha     LIKE ficha-cq.nr-ficha       NO-UNDO.
    DEFINE INPUT PARAMETER pi-codigo-rejei LIKE liber-carg.codigo-rejei NO-UNDO.
    DEFINE INPUT PARAMETER pc-observacao   LIKE rej-ficha.observacao    NO-UNDO.
    
    &IF "{&product_version}" >= "12.1.C":U &THEN /*12.1.13*/    
    FOR FIRST bfLiberCarg EXCLUSIVE-LOCK
        WHERE bfLiberCarg.num-carg  = INT(pc-num-carg)
          AND bfLiberCarg.nr-ficha  = pi-nr-ficha:
        ASSIGN bfLiberCarg.codigo-rejei = pi-codigo-rejei
               bfLiberCarg.cod-obs      = pc-observacao.
    END.
    &ELSE
    FOR FIRST bfLiberCarg EXCLUSIVE-LOCK
        WHERE bfLiberCarg.num-carg    = INT(pc-num-carg)
          AND bfLiberCarg.num-livre-1 = pi-nr-ficha:
        ASSIGN bfLiberCarg.codigo-rejei                 = pi-codigo-rejei
               OVERLAY(bfLiberCarg.cod-livre-1, 1, 100) = pc-observacao.
    END.
    &ENDIF
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-ped-draw-nfs-estrangeiro NO-UNDO LIKE ped-draw-nfs
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-ped-draw-nfs-nacional NO-UNDO LIKE ped-draw-nfs
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
/*{include/i-prgvrs.i BOCX413 2.00.00.025 } /*** "010025" 25/06/2025 06:16:51 ***/
*/
&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX413 MUT}
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
&GLOBAL-DEFINE DBOName BOCX413
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ped-draw-nfs
&GLOBAL-DEFINE TableLabel 
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx413.i RowObject}

DEFINE VARIABLE c-pedido       AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-estabel      AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE h-bocx314      AS HANDLE                       NO-UNDO.

DEF VAR h-exapi025        AS HANDLE    NO-UNDO.
DEF VAR i-nivel           AS INTEGER   NO-UNDO.
DEF VAR c-programa        AS CHARACTER NO-UNDO.
DEF VAR c-ultimo-programa AS CHARACTER NO-UNDO.
DEF VAR r-rowidAux        AS ROWID   NO-UNDO.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
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
      TABLE: tt-ped-draw-nfs-estrangeiro T "?" NO-UNDO mgcex ped-draw-nfs
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ped-draw-nfs-nacional T "?" NO-UNDO mgcex ped-draw-nfs
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
         HEIGHT             = 12.58
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT CAN-FIND(FIRST Pedido-drb-RE
                        WHERE Pedido-drb-RE.cod-estabel   = RowObject.cod-estab
                        AND   Pedido-drb-RE.nr-pedido-drb = RowObject.cod-ped-draw
                        AND   Pedido-drb-RE.nr-re         = trim(SUBSTRING(RowObject.cod-livre-1,1,20))) THEN DO:

        CREATE Pedido-drb-RE.
        ASSIGN Pedido-drb-RE.cod-estabel   = RowObject.cod-estab
               Pedido-drb-RE.nr-pedido-drb = RowObject.cod-ped-draw
               Pedido-drb-RE.nr-re         = trim(SUBSTRING(RowObject.cod-livre-1,1,20)).
    END.
    
    FOR FIRST param-imp FIELDS(char-1)
         WHERE param-imp.cod-estabel = RowObject.cod-estab NO-LOCK:
    END.
    /*param-imp.char-1,229,1 : Tabela Documentos Relacionados -  - IM0000 Folder Drawback*/
    IF AVAIL param-imp AND TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
        {utp/ut-liter.i "Criaá∆o"}
        RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
    END.

    RETURN "OK":U.
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
    IF NOT VALID-HANDLE(h-bocx314) THEN
        RUN cxbo/bocx314.p PERSISTENT SET h-bocx314.

    /* deletar item-re, pedido-drb-item e pedido-drb-re */
    RUN eliminaRE IN h-bocx314(INPUT RowObject.cod-estab,
                               INPUT RowObject.cod-ped-draw).

    IF VALID-HANDLE(h-bocx314) THEN DO:
        DELETE PROCEDURE h-bocx314.
        ASSIGN h-bocx314 = ?.
    END.

    /*sa°da*/
    FOR EACH tab-ocor EXCLUSIVE-LOCK
        WHERE tab-ocor.cod-tab = 721
        AND   trim(SUBSTRING(tab-ocor.char-1,1,5))   = RowObject.cod-serie   
        AND   trim(SUBSTRING(tab-ocor.char-1,6,16))  = RowObject.cod-fatura
        AND   trim(SUBSTRING(tab-ocor.char-1,22,5)) = RowObject.cod-estab
        AND   tab-ocor.int-2                        = 2:

        FOR FIRST pedido-drb-item EXCLUSIVE-LOCK
            WHERE pedido-drb-item.cod-estabel     = RowObject.cod-estab  
            AND   pedido-drb-item.nr-pedido-drb = RowObject.cod-ped-draw
            AND   pedido-drb-item.it-codigo     = trim(SUBSTRING(tab-ocor.char-1,27,16))
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

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroy DBOProgram 
PROCEDURE afterDestroy :
/*------------------------------------------------------------------------------
  Purpose:   Eliminar o handle.  
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
    FOR FIRST param-imp FIELDS(char-1)
         WHERE param-imp.cod-estabel = RowObject.cod-estab NO-LOCK:
    END.

    /*param-imp.char-1,229,1 : Tabela Documentos Relacionados -  - IM0000 Folder Drawback*/
    IF AVAIL param-imp AND TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
        {utp/ut-liter.i "Alteraá∆o"}
        RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
    END.

RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST param-imp FIELDS(char-1)
         WHERE param-imp.cod-estabel = RowObject.cod-estab NO-LOCK:
    END.
    /*param-imp.char-1,229,1 : Tabela Documentos Relacionados -  - IM0000 Folder Drawback*/
    IF AVAIL param-imp AND TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
        IF NOT VALID-HANDLE(h-exapi025) THEN
            RUN exp/exapi025.p PERSISTENT SET h-exapi025.
        
        RUN pi-salva-valor-antigo IN h-exapi025(INPUT "ped-draw-nfs":U, INPUT rowObject.r-rowid). 
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
    FOR FIRST param-imp FIELDS(char-1)
         WHERE param-imp.cod-estabel = RowObject.cod-estab NO-LOCK:
    END.
    /*param-imp.char-1,229,1 : Tabela Documentos Relacionados -  - IM0000 Folder Drawback*/
    IF AVAIL param-imp AND TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
        IF NOT VALID-HANDLE(h-exapi025) THEN
            RUN exp/exapi025.p PERSISTENT SET h-exapi025.

        RUN pi-salva-valor-antigo IN h-exapi025(INPUT "ped-draw-nfs":U, INPUT ?).
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaNfs DBOProgram 
PROCEDURE eliminaNfs :
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-fatura":U THEN ASSIGN pFieldValue = RowObject.cod-fatura.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-ped-draw":U THEN ASSIGN pFieldValue = RowObject.cod-ped-draw.
        WHEN "cod-serie":U THEN ASSIGN pFieldValue = RowObject.cod-serie.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
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
  Purpose:     Retorna valores dos campos do °ndice pddrwnfs-id
  Parameters:  
               retorna valor do campo cod-estab
               retorna valor do campo cod-serie
               retorna valor do campo cod-fatura
               retorna valor do campo cod-ped-draw
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estab LIKE ped-draw-nfs.cod-estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-serie LIKE ped-draw-nfs.cod-serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-fatura LIKE ped-draw-nfs.cod-fatura NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-ped-draw LIKE ped-draw-nfs.cod-ped-draw NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estab = RowObject.cod-estab
           pcod-serie = RowObject.cod-serie
           pcod-fatura = RowObject.cod-fatura
           pcod-ped-draw = RowObject.cod-ped-draw.

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
  Purpose:     Reposiciona registro com base no °ndice pddrwnfs-id
  Parameters:  
               recebe valor do campo cod-estab
               recebe valor do campo cod-serie
               recebe valor do campo cod-fatura
               recebe valor do campo cod-ped-draw
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estab LIKE ped-draw-nfs.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-serie LIKE ped-draw-nfs.cod-serie NO-UNDO.
    DEFINE INPUT PARAMETER pcod-fatura LIKE ped-draw-nfs.cod-fatura NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ped-draw LIKE ped-draw-nfs.cod-ped-draw NO-UNDO.

    FIND FIRST bfped-draw-nfs WHERE 
        bfped-draw-nfs.cod-estab = pcod-estab AND 
        bfped-draw-nfs.cod-serie = pcod-serie AND 
        bfped-draw-nfs.cod-fatura = pcod-fatura AND 
        bfped-draw-nfs.cod-ped-draw = pcod-ped-draw NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfped-draw-nfs THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfped-draw-nfs)).
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
           run openQueryStatic ("NfsbyPedidoDrb").           
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
    OPEN QUERY {&QueryName} FOR EACH ped-draw-nfs NO-LOCK INDEXED-REPOSITION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNfsbyPedidoDrb DBOProgram 
PROCEDURE openQueryNfsbyPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Ped-Draw-Nfs NO-LOCK where 
                                     Ped-Draw-Nfs.cod-estab    = c-estabel and
                                     Ped-Draw-Nfs.cod-ped-draw = c-pedido 
                                     INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryNfsbyRowidPedidoDrb DBOProgram 
PROCEDURE openQueryNfsbyRowidPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Ped-Draw-Nfs NO-LOCK where 
                                     Ped-Draw-Nfs.cod-estab    = c-estabel and
                                     Ped-Draw-Nfs.cod-ped-draw = c-pedido 
                                     INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-historico-criacao-alteracao DBOProgram 
PROCEDURE pi-cria-historico-criacao-alteracao :
/*------------------------------------------------------------------------------------------
Purpose:    Realiza a criaá∆o do hist¢rico de criaá∆o/alteraá∆o.
Parameters: c-metodo       : INPUT  : M≤todo(Criaá∆o, Alteraá∆o);
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-metodo AS CHARACTER   NO-UNDO.

    /* Verifica qual o £ltimo programa .w que executou esta procedure */
    ASSIGN i-nivel = 1.
    nivel_block:
    REPEAT WHILE PROGRAM-NAME(i-nivel) <> ?.
        ASSIGN c-programa = REPLACE(PROGRAM-NAME(i-nivel),"~/","~\")
               i-nivel = i-nivel + 1.

        IF c-programa MATCHES "*men*":U THEN NEXT.
        IF c-programa MATCHES "*.w":U THEN
            ASSIGN c-ultimo-programa = c-programa
                   c-ultimo-programa = ENTRY(NUM-ENTRIES(c-programa,"~\"),c-programa,"~\").
            
    END.
    /****************************************************************/
              
    FOR FIRST ped-draw-nfs NO-LOCK
        WHERE ped-draw-nfs.cod-estab  = RowObject.cod-estab
        AND   ped-draw-nfs.cod-serie  = RowObject.cod-serie
        AND   ped-draw-nfs.cod-fatura = RowObject.cod-fatura
        AND   ped-draw-nfs.cod-ped-draw = RowObject.cod-ped-draw:
        ASSIGN r-rowidAux = rowid(ped-draw-nfs).
    END.
    
    IF NOT VALID-HANDLE(h-exapi025) THEN
        RUN exp/exapi025.p PERSISTENT SET h-exapi025.

    RUN pi-salva-alteracao IN h-exapi025 (INPUT c-metodo, INPUT "ped-draw-nfs":U, INPUT r-rowidAux, INPUT c-ultimo-programa).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-tt-ped-draw-nfs-estrangeiro DBOProgram 
PROCEDURE pi-get-tt-ped-draw-nfs-estrangeiro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-cod-estab    LIKE {&TableName}.cod-estab   NO-UNDO.
    DEFINE INPUT PARAM p-cod-ped-draw LIKE {&TableName}.cod-ped-draw NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-ped-draw-nfs-estrangeiro.

    EMPTY TEMP-TABLE tt-ped-draw-nfs-estrangeiro.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estab    = p-cod-estab
        AND   bf{&TableName}.cod-ped-draw = p-cod-ped-draw,
        FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.serie       = bf{&TableName}.cod-serie
            AND   nota-fiscal.cod-estabel = bf{&TableName}.cod-estab
            AND   nota-fiscal.nr-nota-fis = bf{&TableName}.cod-fatura,
            FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
                AND   emitente.natureza >= 3 :

            /* Natureza = 4 pode ser nacional ou internacional, verificar se emitente.pais = estabelec.pais */
            IF emitente.natureza = 4 THEN DO:
                FIND FIRST estabelec NO-LOCK
                    WHERE estabelec.cod-estabel = p-cod-estab NO-ERROR.
                IF emitente.pais = estabelec.pais THEN /* nacional */
                    NEXT.
            END.

            CREATE tt-ped-draw-nfs-estrangeiro.
            BUFFER-COPY bf{&TableName} TO tt-ped-draw-nfs-estrangeiro.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-tt-ped-draw-nfs-estr-filter DBOProgram 
PROCEDURE pi-get-tt-ped-draw-nfs-estr-filter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estab         LIKE {&TableName}.cod-estab    NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-ped-draw      LIKE {&TableName}.cod-ped-draw NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estab-ini     LIKE {&TableName}.cod-estab    NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estab-fim     LIKE {&TableName}.cod-estab    NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-serie-ini     LIKE {&TableName}.cod-serie    NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-serie-fim     LIKE {&TableName}.cod-serie    NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-nota-fisc-ini  LIKE {&TableName}.cod-fatura   NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-nota-fisc-fim  LIKE {&TableName}.cod-fatura   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ped-draw-nfs-estrangeiro.

    EMPTY TEMP-TABLE tt-ped-draw-nfs-estrangeiro.
    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estab     = p-cod-estab
        AND   bf{&TableName}.cod-ped-draw  = p-cod-ped-draw
        AND   ( bf{&TableName}.cod-estab  >= p-cod-estab-ini
        AND   bf{&TableName}.cod-estab    <= p-cod-estab-fim
        AND   bf{&TableName}.cod-serie    >= p-cod-serie-ini
        AND   bf{&TableName}.cod-serie    <= p-cod-serie-fim
        AND   bf{&TableName}.cod-fatura   >= p-nr-nota-fisc-ini
        AND   bf{&TableName}.cod-fatura   <= p-nr-nota-fisc-fim),
        FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.serie       = bf{&TableName}.cod-serie
            AND   nota-fiscal.cod-estabel = bf{&TableName}.cod-estab
            AND   nota-fiscal.nr-nota-fis = bf{&TableName}.cod-fatura,
            FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
                AND   emitente.natureza >= 3 :

            /* Natureza = 4 pode ser nacional ou internacional, verificar se emitente.pais = estabelec.pais */
            IF emitente.natureza = 4 THEN DO:
                FIND FIRST estabelec NO-LOCK
                    WHERE estabelec.cod-estabel = p-cod-estab NO-ERROR.
                IF emitente.pais = estabelec.pais THEN /* nacional */
                    NEXT.
            END.

            CREATE tt-ped-draw-nfs-estrangeiro.
            BUFFER-COPY bf{&TableName} TO tt-ped-draw-nfs-estrangeiro.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-tt-ped-draw-nfs-nacional DBOProgram 
PROCEDURE pi-get-tt-ped-draw-nfs-nacional :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-cod-estab    LIKE {&TableName}.cod-estab   NO-UNDO.
    DEFINE INPUT PARAM p-cod-ped-draw LIKE {&TableName}.cod-ped-draw NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-ped-draw-nfs-nacional.

    EMPTY TEMP-TABLE tt-ped-draw-nfs-nacional.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estab    = p-cod-estab
        AND   bf{&TableName}.cod-ped-draw = p-cod-ped-draw,
        FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.serie       = bf{&TableName}.cod-serie
            AND   nota-fiscal.cod-estabel = bf{&TableName}.cod-estab
            AND   nota-fiscal.nr-nota-fis = bf{&TableName}.cod-fatura,
            FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
                AND   emitente.natureza <> 3 :

            /* Natureza = 4 pode ser nacional ou internacional, verificar se emitente.pais = estabelec.pais */
            IF emitente.natureza = 4 THEN DO:
                FIND FIRST estabelec NO-LOCK
                    WHERE estabelec.cod-estabel = p-cod-estab NO-ERROR.
                IF emitente.pais <> estabelec.pais THEN /* internacional */
                    NEXT.
            END.

            CREATE tt-ped-draw-nfs-nacional.
            BUFFER-COPY bf{&TableName} TO tt-ped-draw-nfs-nacional.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-get-tt-ped-draw-nfs-nac-filter DBOProgram 
PROCEDURE pi-get-tt-ped-draw-nfs-nac-filter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-estab         LIKE {&TableName}.cod-estab    NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-ped-draw      LIKE {&TableName}.cod-ped-draw NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estab-ini     LIKE {&TableName}.cod-estab    NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estab-fim     LIKE {&TableName}.cod-estab    NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-serie-ini     LIKE {&TableName}.cod-serie    NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-serie-fim     LIKE {&TableName}.cod-serie    NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-nota-fisc-ini  LIKE {&TableName}.cod-fatura   NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-nota-fisc-fim  LIKE {&TableName}.cod-fatura   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ped-draw-nfs-nacional.

    EMPTY TEMP-TABLE tt-ped-draw-nfs-nacional.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estab    = p-cod-estab
        AND   bf{&TableName}.cod-ped-draw = p-cod-ped-draw
        AND   ( bf{&TableName}.cod-estab  >= p-cod-estab-ini
        AND   bf{&TableName}.cod-estab    <= p-cod-estab-fim
        AND   bf{&TableName}.cod-serie    >= p-cod-serie-ini
        AND   bf{&TableName}.cod-serie    <= p-cod-serie-fim
        AND   bf{&TableName}.cod-fatura   >= p-nr-nota-fisc-ini
        AND   bf{&TableName}.cod-fatura   <= p-nr-nota-fisc-fim) ,
        FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.serie       = bf{&TableName}.cod-serie
            AND   nota-fiscal.cod-estabel = bf{&TableName}.cod-estab
            AND   nota-fiscal.nr-nota-fis = bf{&TableName}.cod-fatura,
            FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
                AND   emitente.natureza <> 3 :

            /* Natureza = 4 pode ser nacional ou internacional, verificar se emitente.pais = estabelec.pais */
            IF emitente.natureza = 4 THEN DO:
                FIND FIRST estabelec NO-LOCK
                    WHERE estabelec.cod-estabel = p-cod-estab NO-ERROR.
                IF emitente.pais <> estabelec.pais THEN /* internacional */
                    NEXT.
            END.

            CREATE tt-ped-draw-nfs-nacional.
            BUFFER-COPY bf{&TableName} TO tt-ped-draw-nfs-nacional.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNfsbyPedidoDrb DBOProgram 
PROCEDURE setConstraintNfsbyPedidoDrb :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintNfsbyRowidPedidoDrb DBOProgram 
PROCEDURE setConstraintNfsbyRowidPedidoDrb :
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
          
    IF pType = "create":U THEN DO:

        FIND nota-fiscal NO-LOCK 
       WHERE nota-fiscal.cod-estabel = RowObject.cod-estab
         AND nota-fiscal.serie       = RowObject.cod-serie       
         AND nota-fiscal.nr-nota-fis = RowObject.cod-fatura NO-ERROR.
                
       IF  NOT AVAILABLE nota-fiscal THEN DO:
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-nota-fiscal AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Nota_Fiscal" *}
           ASSIGN c-lbl-liter-nota-fiscal = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i &ErrorNumber=2
                                       &ErrorType="EMS"
                                       &ErrorParameters="c-lbl-liter-nota-fiscal"}
           RETURN 'NOK':U.
       END.
       ELSE DO:
           IF nota-fiscal.dt-confirma = ? THEN
               {method/svc/errors/inserr.i 
                           &ErrorNumber="52559"
                           &ErrorType="EMS"
                           &ErrorSubType="Error"
                           &ErrorParameters=" "}
       END.
    END.
  
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


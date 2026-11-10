&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN0815 2.00.00.007 } /*** "010007" 17/06/2025 16:40:45 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin0815 MUT}
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
&GLOBAL-DEFINE DBOName BOIN0815
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docto-estoq-embal
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
{inbo/boin0815.i RowObject}
{cdp/cdcfgmat.i}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-diferenca  AS INTEGER     NO-UNDO.
DEFINE VARIABLE vl-peso-ant  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE vl-dif-peso  AS DECIMAL     NO-UNDO.

DEF VAR  cSerDocto      LIKE item-doc-est.serie-docto  NO-UNDO.   
DEF VAR  cNumDocto      LIKE item-doc-est.nro-docto    NO-UNDO.   
DEF VAR  iEmitDocto     LIKE item-doc-est.cod-emitente NO-UNDO.  
DEF VAR  cNatOperDocto  LIKE item-doc-est.nat-operacao NO-UNDO. 

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 20.92
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

    FIND FIRST bf{&TableName} NO-LOCK
         WHERE bf{&TableName}.cod-ser-docto     = RowObject.cod-ser-docto     
         AND   bf{&TableName}.cod-docto         = RowObject.cod-docto         
         AND   bf{&TableName}.cdn-emitente      = RowObject.cdn-emitente      
         AND   bf{&TableName}.cod-natur-operac  = RowObject.cod-natur-operac
         AND   bf{&TableName}.cod-sig-embal     = RowObject.cod-sig-embal  NO-ERROR.
    IF AVAIL bf{&TableName}  THEN DO:

        FIND FIRST docum-est EXCLUSIVE-LOCK
             WHERE docum-est.serie-docto   = bf{&TableName}.cod-ser-docto    
             AND   docum-est.nro-docto     = bf{&TableName}.cod-docto        
             AND   docum-est.cod-emitente  = bf{&TableName}.cdn-emitente     
             AND   docum-est.nat-operacao  = bf{&TableName}.cod-natur-operac NO-ERROR.
        IF AVAIL docum-est THEN DO:
            &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN                
                   ASSIGN docum-est.peso-bruto-tot =  docum-est.peso-bruto-tot + bf{&TableName}.val-peso-embal.
            &ELSE
                   ASSIGN OVERLAY(docum-est.char-1,157,17) =  string(dec(SUBSTRING(docum-est.char-1,157,17)) + bf{&TableName}.val-peso-embal).
            &ENDIF
        END.
    END.
    RETURN "ok":u.
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
   FIND FIRST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-ser-docto     = RowObject.cod-ser-docto     
        AND   bf{&TableName}.cod-docto         = RowObject.cod-docto         
        AND   bf{&TableName}.cdn-emitente      = RowObject.cdn-emitente      
        AND   bf{&TableName}.cod-natur-operac  = RowObject.cod-natur-operac
        AND   bf{&TableName}.cod-sig-embal     = RowObject.cod-sig-embal NO-ERROR.
    IF AVAIL bf{&TableName}  THEN DO:

       ASSIGN  vl-dif-peso =  bf{&TableName}.val-peso-embal -  vl-peso-ant.
            
       FIND FIRST docum-est EXCLUSIVE-LOCK
            WHERE docum-est.serie-docto   = bf{&TableName}.cod-ser-docto    
            AND   docum-est.nro-docto     = bf{&TableName}.cod-docto        
            AND   docum-est.cod-emitente  = bf{&TableName}.cdn-emitente     
            AND   docum-est.nat-operacao  = bf{&TableName}.cod-natur-operac NO-ERROR.
       IF AVAIL docum-est THEN DO:
          &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN                
               ASSIGN docum-est.peso-bruto-tot =  docum-est.peso-bruto-tot + (vl-dif-peso).
          &ELSE
               ASSIGN OVERLAY(docum-est.char-1,157,17) =  string(dec(SUBSTRING(docum-est.char-1,157,17)) + vl-dif-peso).
          &ENDIF
       END.
    END.
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST bf{&TableName}  NO-LOCK
         WHERE bf{&TableName}.cod-ser-docto     = RowObject.cod-ser-docto     
         AND   bf{&TableName}.cod-docto         = RowObject.cod-docto         
         AND   bf{&TableName}.cdn-emitente      = RowObject.cdn-emitente      
         AND   bf{&TableName}.cod-natur-operac  = RowObject.cod-natur-operac
         AND   bf{&TableName}.cod-sig-embal     = RowObject.cod-sig-embal NO-ERROR.
    IF AVAIL bf{&TableName}  THEN DO:

       FIND FIRST docum-est EXCLUSIVE-LOCK
            WHERE docum-est.serie-docto   = bf{&TableName}.cod-ser-docto    
            AND   docum-est.nro-docto     = bf{&TableName}.cod-docto        
            AND   docum-est.cod-emitente  = bf{&TableName}.cdn-emitente     
            AND   docum-est.nat-operacao  = bf{&TableName}.cod-natur-operac NO-ERROR.
       IF AVAIL docum-est THEN DO:
       
           &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN                
               ASSIGN docum-est.peso-bruto-tot =  docum-est.peso-bruto-tot - bf{&TableName}.val-peso-embal.
          &ELSE
               ASSIGN OVERLAY(docum-est.char-1,157,17) = string(dec(SUBSTRING(docum-est.char-1,157,17)) - bf{&TableName}.val-peso-embal).
          &ENDIF
       END.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeUpdateRecord DBOProgram 
PROCEDURE BeforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST bf{&TableName} NO-LOCK
         WHERE bf{&TableName}.cod-ser-docto     = RowObject.cod-ser-docto     
         AND   bf{&TableName}.cod-docto         = RowObject.cod-docto         
         AND   bf{&TableName}.cdn-emitente      = RowObject.cdn-emitente      
         AND   bf{&TableName}.cod-natur-operac  = RowObject.cod-natur-operac
         AND   bf{&TableName}.cod-sig-embal     = RowObject.cod-sig-embal NO-ERROR.
    IF AVAIL bf{&TableName}  THEN 
        ASSIGN vl-peso-ant = bf{&TableName}.val-peso-embal.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteRelacDocum-est DBOProgram 
PROCEDURE DeleteRelacDocum-est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-serie-docto  like docum-est.serie-docto   no-undo.
    DEF INPUT PARAMETER p-nro-docto    like docum-est.nro-docto    no-undo.
    DEF INPUT PARAMETER p-cod-emitente like docum-est.cod-emitente no-undo.
    DEF INPUT PARAMETER p-nat-operacao like docum-est.nat-operacao no-undo.

    FOR EACH  bf{&TableName} 
        WHERE bf{&TableName}.cod-ser-docto    = p-serie-docto 
        AND   bf{&TableName}.cod-docto        = p-nro-docto
        AND   bf{&TableName}.cdn-emitente     = p-cod-emitente
        AND   bf{&TableName}.cod-natur-operac = p-nat-operacao no-lock:
        FIND FIRST {&TableName} 
             WHERE ROWID({&TableName}) = ROWID(bf{&TableName}) exclusive-lock NO-ERROR.
        DELETE {&TableName}.
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
        WHEN "cod-docto":U        THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-embal":U        THEN ASSIGN pFieldValue = RowObject.cod-embal.
        WHEN "cod-natur-operac":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac.
        WHEN "cod-ser-docto":U    THEN ASSIGN pFieldValue = RowObject.cod-ser-docto.
        WHEN "cod-sig-embal":U    THEN ASSIGN pFieldValue = RowObject.cod-sig-embal.
        WHEN "des-descr-gener":U   THEN ASSIGN pFieldValue = RowObject.des-descr-gener.
        WHEN "des-espec-volum":U  THEN ASSIGN pFieldValue = RowObject.des-espec-volum.
        WHEN "des-marca-vol":U    THEN ASSIGN pFieldValue = RowObject.des-marca-vol.
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
        WHEN "qtd-vol":U        THEN ASSIGN pFieldValue = RowObject.qtd-vol.
        WHEN "val-peso-embal":U THEN ASSIGN pFieldValue = RowObject.val-peso-embal.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescSigla DBOProgram 
PROCEDURE getDescSigla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER pcod-sig-embal    LIKE docto-estoq-embal.cod-sig-embal NO-UNDO.
DEFINE OUTPUT PARAMETER p-desc-embalagem  LIKE embalag.descricao              NO-UNDO.
DEFINE OUTPUT PARAMETER p-tipo-emb       LIKE embalag.embalagem               NO-UNDO.

    FIND FIRST embalag NO-LOCK
         WHERE embalag.sigla-emb = pcod-sig-embal NO-ERROR.
    IF AVAIL embalag THEN 
       ASSIGN p-desc-embalagem  =  embalag.descricao
              p-tipo-emb        =  embalag.embalagem.

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
    DEFINE INPUT  PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "num-vol":U          THEN ASSIGN pFieldValue = RowObject.num-vol.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dctsqmb-id
  Parameters:  
               retorna valor do campo cod-ser-docto
               retorna valor do campo cod-docto
               retorna valor do campo cdn-emitente
               retorna valor do campo cod-natur-operac
               retorna valor do campo cod-sig-embal
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-ser-docto    LIKE docto-estoq-embal.cod-ser-docto    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-docto        LIKE docto-estoq-embal.cod-docto        NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-emitente     LIKE docto-estoq-embal.cdn-emitente     NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-natur-operac LIKE docto-estoq-embal.cod-natur-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-sig-embal    LIKE docto-estoq-embal.cod-sig-embal    NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-ser-docto    = RowObject.cod-ser-docto
           pcod-docto        = RowObject.cod-docto
           pcdn-emitente     = RowObject.cdn-emitente
           pcod-natur-operac = RowObject.cod-natur-operac
           pcod-sig-embal    = RowObject.cod-sig-embal.

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
  Purpose:     Reposiciona registro com base no °ndice dctsqmb-id
  Parameters:  
               recebe valor do campo cod-ser-docto
               recebe valor do campo cod-docto
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-natur-operac
               recebe valor do campo cod-sig-embal
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-ser-docto    LIKE docto-estoq-embal.cod-ser-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto        LIKE docto-estoq-embal.cod-docto        NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente     LIKE docto-estoq-embal.cdn-emitente     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE docto-estoq-embal.cod-natur-operac NO-UNDO.
    DEFINE INPUT PARAMETER pcod-sig-embal    LIKE docto-estoq-embal.cod-sig-embal    NO-UNDO.

    FIND FIRST bfdocto-estoq-embal 
         WHERE bfdocto-estoq-embal.cod-ser-docto    = pcod-ser-docto 
         AND   bfdocto-estoq-embal.cod-docto        = pcod-docto 
         AND   bfdocto-estoq-embal.cdn-emitente     = pcdn-emitente 
         AND   bfdocto-estoq-embal.cod-natur-operac = pcod-natur-operac 
         AND   bfdocto-estoq-embal.cod-sig-embal    = pcod-sig-embal NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocto-estoq-embal THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocto-estoq-embal)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY qr{&tableName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryDocto DBOProgram 
PROCEDURE OpenQueryDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY qr{&tableName} FOR EACH {&tableName} NO-LOCK 
        WHERE {&tableName}.cod-ser-docto    = cSerDocto
          AND {&tableName}.cod-docto        = cNumDocto
          AND {&tableName}.cdn-emitente     = iEmitDocto 
          AND {&tableName}.cod-natur-operac = cNatOperDocto
        INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDocto DBOProgram 
PROCEDURE setConstraintDocto:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input parameter pNumDocto      LIKE item-doc-est.nro-docto    NO-UNDO.  
  def input parameter pSerDocto      LIKE item-doc-est.serie-docto  NO-UNDO. 
  def input parameter pEmitDocto     LIKE item-doc-est.cod-emitente NO-UNDO. 
  def input parameter pNatOperDocto  LIKE item-doc-est.nat-operacao NO-UNDO.  

    assign cSerDocto     = pSerDocto    
           cNumDocto     = pNumDocto    
           iEmitDocto    = pEmitDocto   
           cNatOperDocto = pNatOperDocto.
    
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
    

    IF pType = "Create" THEN DO:

        IF CAN-FIND (FIRST bfdocto-estoq-embal 
                     WHERE bfdocto-estoq-embal.cod-ser-docto    = RowObject.cod-ser-docto 
                     AND   bfdocto-estoq-embal.cod-docto        = RowObject.cod-docto 
                     AND   bfdocto-estoq-embal.cdn-emitente     = RowObject.cdn-emitente 
                     AND   bfdocto-estoq-embal.cod-natur-operac = RowObject.cod-natur-operac 
                     AND   bfdocto-estoq-embal.cod-sig-embal    = RowObject.cod-sig-embal     ) THEN DO:         
                /* Inicio -- Projeto Internacional */
                {utp/ut-table.i movind docto-estoq-embal 1} /* Busca o label da tabela */
                {method/svc/errors/inserr.i
                            &ErrorNumber="1"
                            &ErrorType="EMS":U
                            &ErrorSubType="ERROR":U
                            &ErrorParameters=TRIM(RETURN-VALUE)}
        END.
        
    END.        

   IF pType = "Create"
   OR pType = "Update" THEN DO:


        IF NOT CAN-FIND (FIRST embalag NO-LOCK
                         WHERE embalag.embalagem = RowObject.cod-embal) THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-table.i mgdis embalag 1} /* Busca o label da tabela */
            {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS":U
                            &ErrorSubType="ERROR":U
                            &ErrorParameters=TRIM(RETURN-VALUE)}

        END.

        IF NOT CAN-FIND (FIRST embalag NO-LOCK
                         WHERE embalag.sigla-emb = RowObject.cod-sig-embal) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-sigla AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Sigla" *}
            ASSIGN c-lbl-liter-sigla = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters="c-lbl-liter-sigla" }

        END.


        IF CAN-FIND (FIRST embalag NO-LOCK
                     WHERE embalag.embalagem  = RowObject.cod-embal
                     AND   embalag.sigla-emb <> RowObject.cod-sig-embal) THEN DO:

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-a-sigla-informada-nao-esta-rel AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "A_sigla_informada_n∆o_est†_relacionada_ao_tipo_de_embalagem_informada" *}
            ASSIGN c-lbl-liter-a-sigla-informada-nao-esta-rel = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="17006"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters="c-lbl-liter-a-sigla-informada-nao-esta-rel" }
        END.       
   END.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


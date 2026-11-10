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
{include/i-prgvrs.i BOCX100 2.00.00.027 } /*** "010027" 05/12/2024 15:51:51 ***/
{utp/ut-glob.i}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx100 MUT}
&ENDIF

/*--------------------------------------------------------------------------
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

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX100
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-doc-est-cex
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx100.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i}

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bfitem-doc-est FOR item-doc-est.

def var i-cod-emitente       as int            no-undo.
def var c-serie-docto        as char           no-undo.
def var c-nro-docto          as char           no-undo.
def var c-nat-operacao       as char           no-undo.
def var i-sequencia          as int            no-undo.
def var l-despesa-isenta     as log initial no no-undo.



{cdp/cd4300.i3} /* tratamento atributo livre */

&if "{&bf_mat_versao_ems}" >= "2.062" &then
    DEFINE TEMP-TABLE tt-desp-item-doc-est-cex NO-UNDO
        FIELD r-rowid         AS ROWID
        FIELD num-seq-desp  LIKE desp-item-doc-est.num-seq-desp 
        FIELD cod-despesa   LIKE desp-item-doc-est.cod-despesa
        FIELD des-despesa   LIKE despesa.des-despesa
        FIELD val-despesa   LIKE desp-item-doc-est.val-despesa
        FIELD val-per-desp  LIKE desp-item-doc-est.val-per-desp
        FIELD cod-fornec    LIKE fornecedor.cod-fornec
        FIELD tipo            AS CHAR FORMAT 'x(25)'
        FIELD cond-pagto    LIKE cond-pagto.cod-cond-pag
        FIELD moeda-org     LIKE moeda.mo-codigo
        FIELD valor-org       AS DEC
        FIELD gera-dupl       AS LOG
        FIELD dsl-narrativa LIKE desp-item-doc-est.Dsl-Narrativa.   
&endif

    

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
         HEIGHT             = 11.75
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaTTDespesa DBOProgram 
PROCEDURE atualizaTTDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT  PARAM rw-item-doc-est   AS ROWID NO-UNDO.
  DEF INPUT  PARAM p-cod-despesa   LIKE desp-imp.cod-desp NO-UNDO.
  DEF OUTPUT PARAM p-cod-fornec    LIKE item-doc-est-cex.cod-emitente-desp NO-UNDO.
  DEF OUTPUT PARAM p-cond-pagto    LIKE docum-est-cex.cod-cond-pag NO-UNDO.
  DEF OUTPUT PARAM p-moeda-org     LIKE item-doc-est-cex.mo-codigo NO-UNDO.
  DEF OUTPUT PARAM p-valor-org     LIKE item-doc-est-cex.val-desp NO-UNDO.
  DEF OUTPUT PARAM p-gera-dupl     LIKE desp-imp.inc-val-duplic NO-UNDO.
  DEF OUTPUT PARAM p-tipo            AS CHAR NO-UNDO.
  
  FIND FIRST bfitem-doc-est NO-LOCK
       WHERE ROWID(bfitem-doc-est) = rw-item-doc-est NO-ERROR.
  FIND FIRST item-doc-est-cex NO-LOCK
       WHERE item-doc-est-cex.sequencia         = bfitem-doc-est.sequencia
         AND item-doc-est-cex.serie-docto       = bfitem-doc-est.serie-docto
         AND item-doc-est-cex.nro-docto         = bfitem-doc-est.nro-docto
         AND item-doc-est-cex.cod-emitente      = bfitem-doc-est.cod-emitente
         AND item-doc-est-cex.nat-operacao      = bfitem-doc-est.nat-operacao
         AND item-doc-est-cex.cod-desp          = INT(p-cod-despesa) NO-ERROR.
  FIND FIRST docum-est-cex NO-LOCK
       WHERE docum-est-cex.serie-docto       = bfitem-doc-est.serie-docto
         AND docum-est-cex.nro-docto         = bfitem-doc-est.nro-docto
         AND docum-est-cex.cod-emitente      = bfitem-doc-est.cod-emitente
         AND docum-est-cex.nat-operacao      = bfitem-doc-est.nat-operacao
         AND docum-est-cex.cod-emitente-desp = item-doc-est-cex.cod-emitente-desp NO-ERROR.
  IF  AVAIL  docum-est-cex THEN DO:
      ASSIGN p-cod-fornec = item-doc-est-cex.cod-emitente-desp
             p-cond-pagto = docum-est-cex.cod-cond-pag
             p-moeda-org  = item-doc-est-cex.mo-codigo
             p-valor-org  = item-doc-est-cex.val-desp.
      
      FIND FIRST desp-imp NO-LOCK
           WHERE desp-imp.cod-desp = item-doc-est-cex.cod-desp NO-ERROR.
      IF  AVAIL  desp-imp THEN DO:
          ASSIGN p-gera-dupl  = desp-imp.inc-val-duplic.
          ASSIGN p-tipo = {cxinc/i01cx010.i 04 desp-imp.tipo}.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CriaTTdespItemDocEstCex DBOProgram 
PROCEDURE CriaTTdespItemDocEstCex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if "{&bf_mat_versao_ems}" >= "2.062" &then
    DEF INPUT  PARAM serie-doc          LIKE item-doc-est.serie-docto.  
    DEF INPUT  PARAM nr-doc             LIKE item-doc-est.nro-docto.    
    DEF INPUT  PARAM cod-emit           LIKE item-doc-est.cod-emitente. 
    DEF INPUT  PARAM nat-oper           LIKE item-doc-est.nat-operacao.
    DEF INPUT  PARAM it-seq             LIKE item-doc-est.sequencia.
    DEF OUTPUT PARAM TABLE FOR tt-desp-item-doc-est-cex.
    
    
    DEF VAR i-cont AS INT.
    
    ASSIGN i-cont = 1.
    for each item-doc-est-cex
       where item-doc-est-cex.serie-docto  = serie-doc 
         and item-doc-est-cex.nro-docto    = nr-doc    
         and item-doc-est-cex.cod-emitente = cod-emit  
         and item-doc-est-cex.nat-operacao = nat-oper  
         and item-doc-est-cex.sequencia    = it-seq NO-LOCK:
    
        /*find despesa 
            WHERE despesa.cod-despesa = string(item-doc-est-cex.cod-desp) no-lock no-error.
        if  not avail despesa then
            next.*/
    
        create tt-desp-item-doc-est-cex.
        assign tt-desp-item-doc-est-cex.r-rowid       = rowid(item-doc-est-cex)
               tt-desp-item-doc-est-cex.num-seq-desp  = i-cont
               tt-desp-item-doc-est-cex.cod-despesa   = string(item-doc-est-cex.cod-desp)
               tt-desp-item-doc-est-cex.des-despesa   = ""
               tt-desp-item-doc-est-cex.val-per-desp  = 0
               tt-desp-item-doc-est-cex.val-despesa   = item-doc-est-cex.val-desp
               tt-desp-item-doc-est-cex.dsl-narrativa = "".  
    
        ASSIGN i-cont = i-cont + 1.
    END.
&ENDIF
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteDocumEstCex DBOProgram 
PROCEDURE deleteDocumEstCex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-serie-docto  LIKE docum-est.serie-docto  NO-UNDO.
    DEF INPUT PARAMETER p-nro-docto    LIKE docum-est.nro-docto    NO-UNDO.
    DEF INPUT PARAMETER p-cod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEF INPUT PARAMETER p-nat-operacao LIKE docum-est.nat-operacao NO-UNDO.
    DEF INPUT PARAMETER p-cod-desp     LIKE docum-est-cex.cod-desp NO-UNDO.
    
    FOR EACH  docum-est-cex EXCLUSIVE-LOCK
        WHERE docum-est-cex.serie-docto  = p-serie-docto
          AND docum-est-cex.nro-docto    = p-nro-docto
          AND docum-est-cex.cod-emitente = p-cod-emitente
          AND docum-est-cex.nat-operacao = p-nat-operacao
          AND docum-est-cex.cod-desp     = INT(p-cod-desp):
        FOR EACH item-doc-est-cex EXCLUSIVE-LOCK
              OF docum-est-cex:
            DELETE item-doc-est-cex.
        END.
        
        DELETE docum-est-cex.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRelacDocum-est DBOProgram 
PROCEDURE deleteRelacDocum-est :
/*------------------------------------------------------------------------------
  Purpose: Eliminar as despesas relativas ao Documento de Entrada que est† sendo eliminado    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-serie-docto  like docum-est.serie-docto   no-undo.
    def input parameter p-nro-docto    like docum-est.nro-docto    no-undo.
    def input parameter p-cod-emitente like docum-est.cod-emitente no-undo.
    def input parameter p-nat-operacao like docum-est.nat-operacao no-undo.
    
    for each bf{&TableName}
        where bf{&TableName}.serie-docto  = p-serie-docto 
          and bf{&TableName}.nro-docto    = p-nro-docto
          and bf{&TableName}.cod-emitente = p-cod-emitente
          and bf{&TableName}.nat-operacao = p-nat-operacao no-lock:
        find {&TableName} 
            where rowid({&TableName}) = rowid(bf{&TableName}) exclusive-lock no-error.

        /*
        ** Validacao para desvincular a Despesa 
        ** com o item do documento antes de eliminar
        */
        for each desp-embarque 
           &if "{&bf_mat_versao_ems}" >= "2.06" &then
           where desp-embarque.cod-estabel = bf{&TableName}.cod-estabel
             and desp-embarque.embarque    = bf{&TableName}.embarque
             and desp-embarque.cod-desp    = bf{&TableName}.cod-desp
           &else
           where desp-embarque.cod-estabel = substring(bf{&TableName}.char-1,13,3)
             and desp-embarque.embarque    = substring(bf{&TableName}.char-1,1,12)
             and desp-embarque.cod-desp    = bf{&TableName}.cod-desp
           &endif
           exclusive-lock:
           &if "{&bf_mat_versao_ems}" >= "2.06" &then
               assign desp-embarque.log-despes-ja-recbda = no.
           &else
               assign desp-embarque.log-1 = no.
           &endif
        end.

        delete {&TableName}.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRelacItem-doc-est DBOProgram 
PROCEDURE deleteRelacItem-doc-est :
/*------------------------------------------------------------------------------
  Purpose: Eliminar as despesas relativas ao Item do Documento de Entrada que est† sendo eliminado    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-serie-docto  like docum-est.serie-docto  no-undo.
    def input parameter p-nro-docto    like docum-est.nro-docto    no-undo.
    def input parameter p-cod-emitente like docum-est.cod-emitente no-undo.
    def input parameter p-nat-operacao like docum-est.nat-operacao no-undo.
    def input parameter p-sequencia    like item-doc-est.sequencia no-undo.    
    
    for each bf{&TableName}
        where bf{&TableName}.serie-docto  = p-serie-docto 
          and bf{&TableName}.nro-docto    = p-nro-docto
          and bf{&TableName}.cod-emitente = p-cod-emitente
          and bf{&TableName}.nat-operacao = p-nat-operacao 
          and bf{&TableName}.sequencia    = p-sequencia no-lock:
        find {&TableName}
            where rowid({&TableName}) = rowid(bf{&TableName}) exclusive-lock no-error.
        delete {&TableName}.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCotacao DBOProgram 
PROCEDURE findCotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*
** Acha cotacao da moeda na data indicada.
*/
def input  parameter da-dt-atual as date format "99/99/9999"     no-undo.
def input  parameter i-mo-codigo like item-doc-est-cex.mo-codigo no-undo.

/*def var c-periodo like cotacao.ano-periodo no-undo.
 *          
 * assign c-periodo = string(year(da-dt-atual), "9999") + 
 *                    string(month(da-dt-atual), "99" ).
 * 
 * find cotacao where cotacao.mo-codigo = i-mo-codigo and
 *                    cotacao.ano-periodo = c-periodo no-lock no-error.
 * if not avail cotacao then do:
 *    {method/svc/errors/inserr.i
 *                             &ErrorNumber="316" 
 *                             &ErrorType="EMS"
 *                             &ErrorSubType="ERROR"
 *                             &ErrorParameters = "string(i-mo-codigo) + string(today)"  }   
 * end.    
 * 
 * return "OK":U.*/

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
        WHEN "cotacao":U THEN ASSIGN pFieldValue = RowObject.cotacao.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "val-desp":U THEN ASSIGN pFieldValue = RowObject.val-desp.
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
        WHEN "cod-desp":U THEN ASSIGN pFieldValue = RowObject.cod-desp.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-emitente-desp":U THEN ASSIGN pFieldValue = RowObject.cod-emitente-desp.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo sequencia
               retorna valor do campo cod-emitente-desp
               retorna valor do campo cod-desp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE item-doc-est-cex.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE item-doc-est-cex.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE item-doc-est-cex.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE item-doc-est-cex.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE item-doc-est-cex.sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente-desp LIKE item-doc-est-cex.cod-emitente-desp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-desp LIKE item-doc-est-cex.cod-desp NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           psequencia = RowObject.sequencia
           pcod-emitente-desp = RowObject.cod-emitente-desp
           pcod-desp = RowObject.cod-desp.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo sequencia
               recebe valor do campo cod-emitente-desp
               recebe valor do campo cod-desp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE item-doc-est-cex.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE item-doc-est-cex.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE item-doc-est-cex.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE item-doc-est-cex.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE item-doc-est-cex.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente-desp LIKE item-doc-est-cex.cod-emitente-desp NO-UNDO.
    DEFINE INPUT PARAMETER pcod-desp LIKE item-doc-est-cex.cod-desp NO-UNDO.

    FIND FIRST bfitem-doc-est-cex WHERE 
        bfitem-doc-est-cex.serie-docto = pserie-docto AND 
        bfitem-doc-est-cex.nro-docto = pnro-docto AND 
        bfitem-doc-est-cex.cod-emitente = pcod-emitente AND 
        bfitem-doc-est-cex.nat-operacao = pnat-operacao AND 
        bfitem-doc-est-cex.sequencia = psequencia AND 
        bfitem-doc-est-cex.cod-emitente-desp = pcod-emitente-desp AND 
        bfitem-doc-est-cex.cod-desp = pcod-desp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-doc-est-cex THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-doc-est-cex)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linktoItemDocEst DBOProgram 
PROCEDURE linktoItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter pHandle as handle no-undo.
    
    run getKey in pHandle ( output i-cod-emitente,
                            output c-serie-docto,
                            output c-nro-docto,
                            output c-nat-operacao,
                            output i-sequencia).
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
           run openQueryStatic ("Main":U).                
        when 2 then
           run openQueryStatic ("OfItemDocEst":U). 
    end case.
    
    Return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemDocEst DBOProgram 
PROCEDURE openQueryItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName} for each {&TableName} no-lock
        where {&TableName}.serie-docto   = c-serie-docto and
              {&TableName}.nro-docto     = c-nro-docto and
              {&TableName}.cod-emitente  = i-cod-emitente and
              {&TableName}.nat-operacao  = c-nat-operacao and
              {&TableName}.sequencia     = i-sequencia indexed-reposition.        

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
  open query {&QUERYNAME} for each {&TABLENAME} no-lock indexed-reposition.   
  
  Return "OK":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-BuscaItemDocEstCex DBOProgram 
PROCEDURE pi-BuscaItemDocEstCex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel  LIKE docum-est.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER pc-serie-docto  LIKE item-doc-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pc-nro-docto    LIKE item-doc-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pi-cod-emitente LIKE item-doc-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pc-nat-operacao LIKE item-doc-est.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pi-sequencia    LIKE item-doc-est.sequencia    NO-UNDO.
    &if '{&bf_cex_versao_ems}' >= '2.07' &then
        DEFINE OUTPUT PARAMETER pl-taxa AS LOGICAL NO-UNDO.
    &else
        DEFINE OUTPUT PARAMETER pc-taxa AS CHARACTER NO-UNDO. 
    &endif
    
    FIND FIRST param-imp
         WHERE param-imp.cod-estabel = pc-cod-estabel NO-LOCK NO-ERROR.

    FOR EACH item-doc-est-cex NO-LOCK
       WHERE item-doc-est-cex.serie-docto   = pc-serie-docto
         AND item-doc-est-cex.nro-docto     = pc-nro-docto
         AND item-doc-est-cex.cod-emitente  = pi-cod-emitente
         AND item-doc-est-cex.nat-operacao  = pc-nat-operacao
         AND item-doc-est-cex.sequencia     = pi-sequencia:
            
        &if '{&bf_cex_versao_ems}' >= '2.07' &then
            IF  item-doc-est-cex.val-desp > 0 
            AND item-doc-est-cex.cod-emitente-desp = param-imp.cdn-emit-siscomex
            AND item-doc-est-cex.cod-desp          = param-imp.cdn-despes-siscomex THEN
                ASSIGN pl-taxa = param-imp.log-tax-siscomex.
        &else
            IF  item-doc-est-cex.val-desp > 0
            AND item-doc-est-cex.cod-emitente-desp = INT(SUBSTR(param-imp.char-1, 96,9))
            AND item-doc-est-cex.cod-desp          = INT(SUBSTR(param-imp.char-1, 91,5)) THEN 
                ASSIGN pc-taxa = TRIM(SUBSTRING(param-imp.char-1,105,1)).
        &endif
    END.
                                
    RETURN "OK":U.                                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-despesasEnvolvidasEmbarque DBOProgram 
PROCEDURE pi-despesasEnvolvidasEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-serie-docto  like item-doc-est-cex.serie-docto   no-undo.
    def input parameter p-nro-docto    like item-doc-est-cex.nro-docto    no-undo.
    def input parameter p-cod-emitente like item-doc-est-cex.cod-emitente no-undo.
    def input parameter p-nat-operacao like item-doc-est-cex.nat-operacao no-undo.
    
    def var c-embarque LIKE embarque-imp.embarque  no-undo.

    &IF "{&mguni_version}" >= "2.071" &THEN
    def var c-estabel  as char format "x(5)"  no-undo.
    &ELSE
    def var c-estabel  as char format "x(3)"  no-undo.
    &ENDIF
    

    for each bf{&TableName} 
        where bf{&TableName}.serie-docto  = p-serie-docto                
        and bf{&TableName}.nro-docto      = p-nro-docto                  
        and bf{&TableName}.cod-emitente   = p-cod-emitente               
        and bf{&TableName}.nat-operacao   = p-nat-operacao no-lock: 
        
        &if "{&bf_mat_versao_ems}" >= "2.06" &then
            assign c-embarque = bf{&TableName}.embarque
                   c-estabel  = bf{&TableName}.cod-estabel.
        &else  
            assign c-embarque = substr(bf{&TableName}.char-1,1,12)
                   c-estabel  = substr(bf{&TableName}.char-1,13,3).
        &endif
        
        for each desp-embarque
           where desp-embarque.cod-estabel = c-estabel  
             and desp-embarque.embarque    = c-embarque
             and desp-embarque.cod-desp    = bf{&TableName}.cod-desp exclusive-lock :
             
             &if "{&bf_mat_versao_ems}" >= "2.06" &then
                 assign desp-embarque.log-despes-ja-recbda = NO.
             &else  
                 assign desp-embarque.log-1 = NO.
             &endif
        end.
   
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRowidItemDocEst DBOProgram 
PROCEDURE setRowidItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param rwItemDocEst  as rowid no-undo.

    for first item-doc-est
        fields ( cod-emitente serie-docto     
                 nro-docto    nat-operacao
                 usuario      sequencia )
        where rowid(item-doc-est) = rwItemDocEst no-lock:
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validachave DBOProgram 
PROCEDURE validachave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {rep/re1001a.i50} /* tratamento atributo livre docum-est.char-1 */

    for first docum-est fields(cod-estabel char-1)
        where docum-est.serie-docto  = rowObject.serie-docto 
          and docum-est.nro-docto    = rowObject.nro-docto
          and docum-est.cod-emitente = rowObject.cod-emitente
          and docum-est.nat-operacao = rowObject.nat-operacao no-lock:
        {cdp/cd4300.i4 "yes" docum-est.char-1}
        {rep/re1001a.i51 "yes"}          
    end.
    
    if not avail docum-est then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-documento AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Documento" *}
        ASSIGN c-lbl-liter-documento = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
        &ErrorNumber="2" 
        &ErrorType="EMS"
        &ErrorSubType="ERROR"
        &ErrorParameters = "c-lbl-liter-documento" }
    end.    
    
    for first estabelec fields(pais)
        where estabelec.cod-estabel = docum-est.cod-estabel no-lock:
    end.

    for first natur-oper fields(nota-rateio)
        where natur-oper.nat-operacao = rowObject.nat-operacao no-lock:
    end.
    
    for first emitente fields(natureza pais)
        where emitente.cod-emitente = rowObject.cod-emitente no-lock:
        if c-embarque = "":U then do:        
            if (emitente.natureza <> 3 and emitente.natureza <> 4) then do:
                {method/svc/errors/inserr.i
                &ErrorNumber="15196" 
                &ErrorType="EMS"
                &ErrorSubType="ERROR"}  
            end.

            /*
            Quando o documento for de importacao com natureza de operacao em branco
            nao deve realizar esta validacao para o pais diferente de BRASIL.
            */
            if avail natur-oper and natur-oper.nota-rateio = NO THEN DO:
               IF i-pais-impto-usuario <> 1 THEN
                   if avail estabelec and
                      emitente.pais = estabelec.pais then do:
                      {method/svc/errors/inserr.i
                                        &ErrorNumber="27238"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
                   end.
            end.

        end.
    end.
    
    if rowObject.cod-emitente-desp = 0 then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-fornec-despesa AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Fornecedor_da_Despesa" *}
        ASSIGN c-lbl-liter-fornec-despesa = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                        &ErrorNumber="265" 
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters = "c-lbl-liter-fornec-despesa" }  

    end.
    else do:
        for first emitente fields(identific)
            where emitente.cod-emitente = rowObject.cod-emitente-desp no-lock:
            if emitente.identific = 1 then do:
               {method/svc/errors/inserr.i
                          &ErrorNumber="8738" 
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR"}
            end.
        end.
        if not avail emitente then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-fornec-despesa-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Fornecedor_da_Despesa" *}
            ASSIGN c-lbl-liter-fornec-despesa-2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                              &ErrorNumber="2" 
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR"
                              &ErrorParameters = "c-lbl-liter-fornec-despesa-2" }  
        
        end.
    end.    
    
    if rowObject.cod-desp = 0 then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-codigo-despesa AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "C¢digo_Despesa" *}
        ASSIGN c-lbl-liter-codigo-despesa = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                        &ErrorNumber="265" 
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters = "c-lbl-liter-codigo-despesa" }  
    
    end.
    else
        if not can-find(desp-imp where desp-imp.cod-desp = rowObject.cod-desp) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-despesas AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Despesas" *}
            ASSIGN c-lbl-liter-despesas = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                              &ErrorNumber="2" 
                              &ErrorType="EMS"
                              &ErrorSubType="ERROR"
                              &ErrorParameters = "c-lbl-liter-despesas" }  
        end.
        
    find bfitem-doc-est-cex 
        where bfitem-doc-est-cex.serie-docto       = rowObject.serie-docto
          and bfitem-doc-est-cex.nro-docto         = rowObject.nro-docto
          and bfitem-doc-est-cex.cod-emitente      = rowObject.cod-emitente
          and bfitem-doc-est-cex.nat-operacao      = rowObject.nat-operacao
          and bfitem-doc-est-cex.sequencia         = rowObject.sequencia
          and bfitem-doc-est-cex.cod-emitente-desp = rowObject.cod-emitente-desp
          and bfitem-doc-est-cex.cod-desp          = rowObject.cod-desp  no-lock no-error.    
    if avail bfitem-doc-est-cex then do:    
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-desp-itens-nota AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Despesa_dos_Itens_da_Nota" *}
        ASSIGN c-lbl-liter-desp-itens-nota = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                       &ErrorNumber="8" 
                       &ErrorType="EMS"
                       &ErrorSubType="ERROR"
                       &ErrorParameters = "c-lbl-liter-desp-itens-nota" }  
    end.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/

    if pType = "Create" then do:
       run validachave.
    end.   
    
    FIND FIRST desp-imp NO-LOCK
           WHERE desp-imp.cod-desp = rowObject.cod-desp NO-ERROR.
    IF AVAIL desp-imp THEN
        ASSIGN l-despesa-isenta = desp-imp.inc-despesa-nota.

    if rowObject.val-desp = 0 and l-despesa-isenta = no then do:
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter-valor-despesa AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Valor_Despesa" *}
         ASSIGN c-lbl-liter-valor-despesa = TRIM(RETURN-VALUE).
         {method/svc/errors/inserr.i
                           &ErrorNumber="265" 
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters = "c-lbl-liter-valor-despesa" }  
    end. 

    if pType = "Update" then do:
        &if "{&bf_mat_versao_ems}" >= "2.04" &then
            if rowObject.val-desp < {&TABLENAME}.val-desp then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-a-despesa-esta-sendo-modificad AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "A_despesa_est†_sendo_modificada_para_um_valor_menor" *}
                ASSIGN c-lbl-liter-a-despesa-esta-sendo-modificad = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-a-despesa-esta-sendo-modificad-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "A_despesa_est†_sendo_modificada_para_um_valor_menor,_por_este_motivo,_sugere-se_a_modificaá∆o_do_status_da_despesa_no_embarque_para_n∆o_recebida" *}
                ASSIGN c-lbl-liter-a-despesa-esta-sendo-modificad-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="15825" 
                    &ErrorType="EMS"
                    &ErrorSubType="Information"
                    &ErrorDescription = c-lbl-liter-a-despesa-esta-sendo-modificad + '.'
                    &ErrorHelp = c-lbl-liter-a-despesa-esta-sendo-modificad-2 + '.'
                    &ErrorParameters = "''" }                            
            end.
        &endif
    end.
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
{include/i-prgvrs.i BOCX314 2.00.00.020 } /*** "010020" 07/10/2024 16:59:56 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx314 MUT}
&ENDIF

{cdp/cdcfgcex.i}


/*--------------------------------------------------------------------------
    File       : 
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
&GLOBAL-DEFINE DBOName Pedido-drb-RE
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName Pedido-drb-RE
&GLOBAL-DEFINE TableLabel Pedido-drb-RE
&GLOBAL-DEFINE QueryName qr{&TableName}

{cdp/cdcfgdis.i}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{cxbo/bocx314.i RowObject}
{cxbo/bocx314.i tt-pedido-drb-re}

/* Abaixo a definiá∆o da temp-table para a procedure copyRecordRE */
def temp-table tt-pedido-temp NO-UNDO like pedido-drb-RE.


def var c-pedido  as char no-undo.
def var c-estabel as char no-undo.
def var c-re as char no-undo.
def var i-mo-codigo as INTEGER no-undo.
def var d-reg-export as DATE no-undo.

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-nr-re-ini LIKE pedido-drb-re.nr-re NO-UNDO.
DEFINE VARIABLE c-nr-re-fim LIKE pedido-drb-re.nr-re NO-UNDO.

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
         HEIGHT             = 12.42
         WIDTH              = 43.57.
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeDeleteRecord DBOProgram 
PROCEDURE BeforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     Excluir os registros dos filhos do registro pai corrente
  Parameters:
               
  Notes:
------------------------------------------------------------------------------*/

    FOR EACH item-re WHERE
             item-re.cod-estabel   = RowObject.cod-estabel AND
             item-re.nr-pedido-drb = RowObject.nr-pedido-drb AND
             item-re.num-re        = RowObject.nr-re EXCLUSIVE-LOCK:
        DELETE item-re.
    END.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecordRE DBOProgram 
PROCEDURE copyRecordRE :
/*------------------------------------------------------------------------------
  Purpose: Copiar registros existentes na pedido-drb-RE alterando apenas
           o numero pedido drawback e codigo do estabelecimento    
  
  Parameters: Codigo estabelecimento c-estabe(novo/original) e numero de pedido
              drawback (novo/Original) c-pedido
  
  Notes:       
------------------------------------------------------------------------------*/
    def input param c-estabe      as char no-undo.
    def input param c-pedido      as char no-undo.
    def input param c-estabe-novo as char no-undo.
    def input param c-pedido-novo as char no-undo.
    
    for each pedido-drb-RE no-lock
        where pedido-drb-RE.cod-estabel = c-estabe 
          and pedido-drb-RE.nr-pedido-drb = c-pedido use-index ch-re:
        create tt-pedido-temp.
        buffer-copy pedido-drb-RE to tt-pedido-temp.        
    end.
           
    for each tt-pedido-temp:
    
        create pedido-drb-re.
        assign pedido-drb-re.cod-estabel = c-estabe-novo
               pedido-drb-re.nr-pedido-drb = c-pedido-novo
               pedido-drb-re.nr-re = tt-pedido-temp.nr-re
               pedido-drb-re.data-1 = tt-pedido-temp.data-1
               pedido-drb-re.data-2 = tt-pedido-temp.data-2
               pedido-drb-re.char-1 = tt-pedido-temp.char-1
               pedido-drb-re.char-2 = tt-pedido-temp.char-2
               pedido-drb-re.int-1 = tt-pedido-temp.int-1
               pedido-drb-re.int-2 = tt-pedido-temp.int-2
               pedido-drb-re.dec-1 = tt-pedido-temp.dec-1
               pedido-drb-re.dec-2 = tt-pedido-temp.dec-2
               pedido-drb-re.log-1 = tt-pedido-temp.log-1
               pedido-drb-re.log-2 = tt-pedido-temp.log-2.
               &if "{&bf_dis_versao_ems}" >= "2.06" &then 
                   assign pedido-drb-re.mo-codigo = tt-pedido-temp.mo-codigo                
                          pedido-drb-re.dat-reg-export = tt-pedido-temp.dat-reg-export. 
               &else
                   assign pedido-drb-re.int-1  = tt-pedido-temp.int-1   
                          pedido-drb-re.data-1 = tt-pedido-temp.data-1. 
               &endif

               delete tt-pedido-temp.
               
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRecordRe DBOProgram 
PROCEDURE createRecordRe :
/*------------------------------------------------------------------------------
  Purpose: Criar registros na tabela pedido-drb-re    
  Parameters: Estabelecimento, codigo do pedido e tt-pedido-drb-re
  Notes:       
------------------------------------------------------------------------------*/
    def input param c-estabe as char no-undo.
    def input param c-pedido as char no-undo.
    def input param table for tt-pedido-drb-re.
    
    for each tt-pedido-drb-re 
        where tt-pedido-drb-re.cod-estabel   = c-estabe 
          and tt-pedido-drb-re.nr-pedido-drb = c-pedido:
          
       if avail tt-pedido-drb-re then do:
           create pedido-drb-re.
           assign pedido-drb-re.cod-estabel     = c-estabe
                  pedido-drb-re.nr-pedido-drb   = c-pedido
                  pedido-drb-re.nr-re           = tt-pedido-drb-re.nr-re
                  pedido-drb-re.data-1          = tt-pedido-drb-re.data-1
                  pedido-drb-re.data-2          = tt-pedido-drb-re.data-2
                  pedido-drb-re.char-1          = tt-pedido-drb-re.char-1
                  pedido-drb-re.char-2          = tt-pedido-drb-re.char-2
                  pedido-drb-re.int-1           = tt-pedido-drb-re.int-1
                  pedido-drb-re.int-2           = tt-pedido-drb-re.int-2
                  pedido-drb-re.dec-1           = tt-pedido-drb-re.dec-1
                  pedido-drb-re.dec-2           = tt-pedido-drb-re.dec-2
                  pedido-drb-re.log-1           = tt-pedido-drb-re.log-1
                  pedido-drb-re.log-2           = tt-pedido-drb-re.log-2.
                  &if "{&bf_dis_versao_ems}" >= "2.06" &then 
                      assign pedido-drb-re.mo-codigo = tt-pedido-temp.mo-codigo             
                             pedido-drb-re.dat-reg-export = tt-pedido-temp.dat-reg-export.  
                  &else 
                      assign pedido-drb-re.int-1  = tt-pedido-temp.int-1    
                             pedido-drb-re.data-1 = tt-pedido-temp.data-1.  
                  &endif
       end.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaRE DBOProgram 
PROCEDURE eliminaRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-estabel like pedido-drb.cod-estabel        no-undo.
    def input param p-pedido  like pedido-drb.nr-pedido-drb      no-undo.

    for each bf{&TableName} exclusive-lock
        where bf{&TableName}.cod-estabel   = p-estabel 
          and bf{&TableName}.nr-pedido-drb = p-pedido use-index ch-re:
        FOR EACH item-re WHERE
                 item-re.cod-estabel   = bf{&TableName}.cod-estabel AND
                 item-re.nr-pedido-drb = bf{&TableName}.nr-pedido-drb AND
                 item-re.num-re        = bf{&TableName}.nr-re EXCLUSIVE-LOCK:
            DELETE item-re.
        END.
        delete bf{&TableName}.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaRENfs DBOProgram 
PROCEDURE eliminaRENfs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-nr-pedido-drb LIKE pedido-drb.nr-pedido-drb        NO-UNDO.
    DEF INPUT PARAM p-cod-estabel   LIKE pedido-drb.cod-estabel          NO-UNDO.
    DEF INPUT PARAM p-nr-re         LIKE pedido-drb-re.nr-re             NO-UNDO.


    IF NOT CAN-FIND(FIRST ped-draw-nfs 
                        WHERE ped-draw-nfs.cod-estab    = p-cod-estabel
                        AND   ped-draw-nfs.cod-ped-draw = p-nr-pedido-drb
                        AND   TRIM(SUBSTRING(ped-draw-nfs.cod-livre-1,1,20)) = p-nr-re ) THEN DO:
    
        FIND FIRST Pedido-drb-RE EXCLUSIVE-LOCK
            WHERE Pedido-drb-RE.cod-estabel    = p-cod-estabel
            AND   Pedido-drb-RE.nr-pedido-drb  = p-nr-pedido-drb
            AND   Pedido-drb-RE.nr-re          = p-nr-re NO-ERROR.
        DELETE Pedido-drb-RE.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "nr-pedido-drb":U THEN ASSIGN pFieldValue = RowObject.nr-pedido-drb.
        WHEN "nr-re":U THEN ASSIGN pFieldValue = RowObject.nr-re.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        &if "{&bf_dis_versao_ems}" > "2.06" &then 
            WHEN "dat-reg-export":U THEN ASSIGN pFieldValue = RowObject.dat-reg-export.
        &endif

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        &if "{&bf_dis_versao_ems}" > "2.06" &then 
            WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        &endif
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice CH-RE
  Parameters:
               retorna valor dos campos do °ndice CH-RE
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE Pedido-drb-RE.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedido-drb LIKE Pedido-drb-RE.nr-pedido-drb NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-re LIKE Pedido-drb-RE.nr-re NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel.
    ASSIGN pnr-pedido-drb = RowObject.nr-pedido-drb.
    ASSIGN pnr-re = RowObject.nr-re.

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
               retorna status do processo
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
               retorna status do processo
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
  Purpose:     Reposiciona registro com base no °ndice CH-RE
  Parameters:
               recebe valor dos campos do °ndice CH-RE
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE Pedido-drb-RE.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedido-drb LIKE Pedido-drb-RE.nr-pedido-drb NO-UNDO.
    DEFINE INPUT PARAMETER pnr-re LIKE Pedido-drb-RE.nr-re NO-UNDO.

    FOR FIRST bfPedido-drb-RE NO-LOCK WHERE
              bfPedido-drb-RE.cod-estabel = pcod-estabel     AND
              bfPedido-drb-RE.nr-pedido-drb = pnr-pedido-drb AND
              bfPedido-drb-RE.nr-re = pnr-re
              use-index ch-re:
    END.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfPedido-drb-RE THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfPedido-drb-RE)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkTott-Pedido-drb DBOProgram 
PROCEDURE linkTott-Pedido-drb :
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
           run openQueryStatic ("RebyPedidoDrb").   
    end case.
        
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb-RE NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRebyPedidoDrb DBOProgram 
PROCEDURE openQueryRebyPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb-RE NO-LOCK where 
                                     Pedido-drb-RE.nr-pedido-drb = Pedido-drb.nr-pedido-drb and
                                     Pedido-drb-RE.cod-estabel   = Pedido-drb.cod-estabel 
                                     USE-INDEX ch-re
                                     INDEXED-REPOSITION.
                                     
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRebyRowidPedidoDrb DBOProgram 
PROCEDURE openQueryRebyRowidPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH Pedido-drb-re no-lock where 
                                     Pedido-drb-re.nr-pedido-drb = c-pedido and
                                     Pedido-drb-re.cod-estabel   = c-estabel 
                                     use-index ch-re
                                     INDEXED-REPOSITION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRwFaixaPedidoDrbRE DBOProgram 
PROCEDURE openQueryRwFaixaPedidoDrbRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY    {&QueryName}
        FOR EACH  {&TableName}
            WHERE {&TableName}.cod-estabel   = c-estabel   AND
                  {&TableName}.nr-pedido-drb = c-pedido    AND
                  {&TableName}.nr-re        >= c-nr-re-ini AND
                  {&TableName}.nr-re        <= c-nr-re-fim NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-rowid DBOProgram 
PROCEDURE pi-retorna-rowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  p-cod-estabel   LIKE Pedido-drb-RE.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER  p-nr-pedido-drb LIKE Pedido-drb-RE.nr-pedido-drb NO-UNDO.
    DEFINE OUTPUT PARAMETER l-encontrou-re  AS LOGICAL                       NO-UNDO.
    DEFINE OUTPUT PARAMETER r-rowid         AS ROWID                         NO-UNDO.

    FIND FIRST bfPedido-drb-RE NO-LOCK
        WHERE bfPedido-drb-RE.cod-estabel = p-cod-estabel
        AND   bfPedido-drb-RE.nr-pedido-drb = p-nr-pedido-drb NO-ERROR.
    
    IF AVAIL bfPedido-drb-RE THEN
        ASSIGN r-rowid = ROWID(bfPedido-drb-RE)
               l-encontrou-re = YES.
    ELSE
        ASSIGN l-encontrou-re = NO.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-nom-moeda DBOProgram 
PROCEDURE retorna-nom-moeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM c-moeda LIKE moeda.mo-codigo.
    DEF OUTPUT PARAM c-desc-moeda LIKE moeda.descricao.

    FIND moeda WHERE moeda.mo-codigo = c-moeda NO-LOCK NO-ERROR.
    
    IF AVAIL moeda THEN
        ASSIGN c-desc-moeda = moeda.descricao.
    ELSE
        ASSIGN c-desc-moeda = ''.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retorna-spp-drawback-saldo-terc DBOProgram 
PROCEDURE retorna-spp-drawback-saldo-terc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAMETER l-resultado    AS LOG NO-UNDO.
  
IF CAN-FIND (funcao 
            WHERE cd-funcao = 'spp-drb-sld-terc'
            AND   ativo     = YES) THEN
    ASSIGN l-resultado =TRUE.
ELSE
    ASSIGN l-resultado =FALSE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRebyPedidoDrb DBOProgram 
PROCEDURE setConstraintRebyPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER ppedido  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pestabel AS CHARACTER NO-UNDO.
    
    for first pedido-drb fields(cod-estabel nr-pedido-drb) no-lock where 
              pedido-drb.cod-estabel = pestabel and
              pedido-drb.nr-pedido-drb = ppedido:
    end.
    
    if avail pedido-drb then                 
       assign c-pedido  = pedido-drb.nr-pedido-drb
              c-estabel = pedido-drb.cod-estabel.
              
    RETURN "OK":U.           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintRebyRowidPedidoDrb DBOProgram 
PROCEDURE SetConstraintRebyRowidPedidoDrb :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRwFaixaPedidoDrbRE DBOProgram 
PROCEDURE setConstraintRwFaixaPedidoDrbRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pRowid   AS ROWID                 NO-UNDO.
    DEFINE INPUT PARAMETER pNrReIni LIKE pedido-drb-re.nr-re NO-UNDO.
    DEFINE INPUT PARAMETER pNrReFim LIKE pedido-drb-re.nr-re NO-UNDO.

    FOR FIRST   pedido-drb 
        FIELDS (pedido-drb.cod-estabel
                pedido-drb.nr-pedido-drb) 
        WHERE   ROWID(pedido-drb) = pRowid:
    END.

    IF AVAIL pedido-drb THEN
        ASSIGN c-estabel   = pedido-drb.cod-estabel
               c-pedido    = pedido-drb.nr-pedido-drb
               c-nr-re-ini = pNrReIni
               c-nr-re-fim = pNrReFim.
    ELSE
        ASSIGN c-nr-re-ini = ""
               c-nr-re-fim = "ZZZZZZZZZZZZZZZZZZZZ":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
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

    &IF "{&bf_cex_versao_ems}" >= "2.062" &THEN 
    
        if pType = "Create" then do:
    
            for first reg-export no-lock where 
                     reg-export.nr-re-siscomex = rowObject.nr-re:
            end.
            if not avail reg-export then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-nr-re AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Nr._RE" *}
                ASSIGN c-lbl-liter-nr-re = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-nr-re"}           
            end.
            else do:
                if reg-export.cod-estabel <> rowObject.cod-estabel then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-processo-exportacao AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Processo_Exportaá∆o" *}
                    ASSIGN c-lbl-liter-processo-exportacao = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="25043"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters="c-lbl-liter-processo-exportacao"}
                end.
            end.     
    
            if reg-export.nr-re-siscomex = "" then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-nr-re-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Nr._RE" *}
                ASSIGN c-lbl-liter-nr-re-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                    &ErrorNumber="265"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="c-lbl-liter-nr-re-2"}
            end.

            &if "{&bf_dis_versao_ems}" >= "2.06" &then             
                for first moeda no-lock where 
                         moeda.mo-codigo = rowObject.mo-codigo:
                end.
            &else
                for first moeda no-lock where 
                         moeda.mo-codigo = rowObject.int-1:
                end.
            &endif
            
            if not avail moeda then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-moeda AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Moeda" *}
                ASSIGN c-lbl-liter-moeda = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-moeda"}           
            end.
            
        end.
    
    &ELSE
        if pType = "Create" then do:
    
            for first proc-ped-ent no-lock where 
                     proc-ped-ent.nr-re = rowObject.nr-re:
            end.
            if not avail proc-ped-ent then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-nr-re-3 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Nr._RE" *}
                ASSIGN c-lbl-liter-nr-re-3 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-nr-re-3"}           
            end.
            else do:
                if proc-ped-ent.cod-estabel <> rowObject.cod-estabel then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-processo-exportacao-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Processo_Exportaá∆o" *}
                    ASSIGN c-lbl-liter-processo-exportacao-2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="25043"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters="c-lbl-liter-processo-exportacao-2"}
                end.
            end.     
    
            if rowObject.nr-re = "" then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-nr-re-4 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Nr._RE" *}
                ASSIGN c-lbl-liter-nr-re-4 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                    &ErrorNumber="265"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="c-lbl-liter-nr-re-4"}
            end.
            &if "{&bf_dis_versao_ems}" >= "2.06" &then             
                for first moeda no-lock where 
                         moeda.mo-codigo = rowObject.mo-codigo:
                end.
            &else
                for first moeda no-lock where 
                         moeda.mo-codigo = rowObject.int-1:
                end.
            &endif
            if not avail moeda then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-moeda-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Moeda" *}
                ASSIGN c-lbl-liter-moeda-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="2"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-moeda-2"}           
            end.
        END.

    &ENDIF   

        /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaPedidoRE DBOProgram 
PROCEDURE verificaPedidoRE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM pNrRe LIKE pedido-drb-re.nr-re NO-UNDO.

    for first pedido-drb-re no-lock where 
              pedido-drb-re.nr-re = pNrRe:
    end.
    if avail pedido-drb-re then
        RETURN "NOK":U.

    RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaVinculoDrawbackCorrente DBOProgram 
PROCEDURE verificaVinculoDrawbackCorrente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF "{&bf_cex_versao_ems}" >= "2.062" &THEN 

    DEF INPUT  PARAM nr-nota-fis   LIKE it-nota-fisc.nr-nota-fis NO-UNDO.
    DEF INPUT  PARAM cod-estabel   LIKE it-nota-fisc.cod-estabel NO-UNDO.
    DEF INPUT  PARAM serie         LIKE it-nota-fisc.serie       NO-UNDO.
    DEF INPUT  PARAM nr-seq-fat    LIKE it-nota-fisc.nr-seq-fat  NO-UNDO.
    DEF INPUT  PARAM it-codigo     LIKE it-nota-fisc.it-codigo   NO-UNDO.
    DEF INPUT  PARAM nr-pedido-drb LIKE pedido-drb.nr-pedido-drb NO-UNDO.
    DEF OUTPUT PARAM pc-nr-re      LIKE reg-export.nr-re-siscome NO-UNDO. 
    DEF OUTPUT PARAM p-vinculo     AS LOG                        NO-UNDO.

    DEF VAR desc-re AS CHAR NO-UNDO.

    FIND FIRST it-nota-fisc
         WHERE it-nota-fisc.nr-nota-fis = nr-nota-fis
         AND   it-nota-fisc.cod-estabel = cod-estabel
         AND   it-nota-fisc.serie       = serie
         AND   it-nota-fisc.nr-seq-fat  = nr-seq-fat
         AND   it-nota-fisc.it-codigo   = it-codigo NO-LOCK NO-ERROR.
    
    IF  AVAIL it-nota-fisc THEN DO:
        FIND FIRST proc-it-nota-fisc
             WHERE proc-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis  
             &if "{&bf_dis_versao_ems}" >= "2.06" &then 
               AND proc-it-nota-fisc.cod-estab-faturam = it-nota-fisc.cod-estabel      
             &else
               AND proc-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel      
             &ENDIF
               AND proc-it-nota-fisc.serie       = it-nota-fisc.serie            
               AND proc-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
               AND proc-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.

        IF AVAIL proc-it-nota-fisc THEN DO:
            FIND FIRST proc-ped-ent
             WHERE proc-ped-ent.cod-estabel  = proc-it-nota-fisc.cod-estabel
               AND proc-ped-ent.nome-abrev   = it-nota-fisc.nome-ab-cli
               AND proc-ped-ent.nr-sequencia = it-nota-fisc.nr-seq-ped
               AND proc-ped-ent.it-codigo    = it-nota-fisc.it-codigo
               AND proc-ped-ent.cod-refer    = it-nota-fisc.cod-refer
               AND proc-ped-ent.nr-entrega   = it-nota-fisc.nr-entrega 
               AND proc-ped-ent.nr-proc-exp  = proc-it-nota-fisc.nr-proc-exp NO-LOCK NO-ERROR.
        
        IF  AVAIL proc-ped-ent THEN DO:

            FIND FIRST reg-export-item
                 WHERE reg-export-item.cod-estabel   = proc-ped-ent.cod-estabel      
                 AND   reg-export-item.nr-proc-exp   = proc-ped-ent.nr-proc-exp
                 AND   reg-export-item.nome-abrev    = proc-ped-ent.nome-abrev
                 AND   reg-export-item.nr-pedcli     = proc-ped-ent.nr-pedcli
                 AND   reg-export-item.num-seq       = proc-ped-ent.nr-sequencia
                 AND   reg-export-item.it-codigo     = proc-ped-ent.it-codigo
                 AND   reg-export-item.cod-refer     = proc-ped-ent.cod-refer
                 AND   reg-export-item.nr-entrega    = proc-ped-ent.nr-entrega NO-LOCK NO-ERROR.

            IF  AVAIL reg-export-item THEN DO:

                FIND FIRST reg-export
                     WHERE reg-export.nr-re-ems = reg-export-item.nr-re-ems NO-LOCK NO-ERROR.

                IF  AVAIL reg-export THEN
                    ASSIGN pc-nr-re = reg-export.nr-re-siscomex.
                ELSE
                    ASSIGN pc-nr-re = "".
                 
                FIND FIRST pedido-drb-re 
                     WHERE pedido-drb-re.nr-pedido-drb = nr-pedido-drb
                     AND   pedido-drb-re.cod-estabel   = reg-export-item.cod-estabel
                     AND   pedido-drb-re.nr-re         = STRING(reg-export-item.nr-re-ems) NO-LOCK NO-ERROR.
                   
                IF  AVAIL pedido-drb-re THEN
                    ASSIGN p-vinculo = YES.
                ELSE
                    ASSIGN p-vinculo = NO.
                
                END.
            END.
        END.
    END.
&ENDIF

RETURN "OK":u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaVinculoOutroDrawback DBOProgram 
PROCEDURE verificaVinculoOutroDrawback :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF "{&bf_cex_versao_ems}" >= "2.062" &THEN 

    DEF INPUT  PARAM nr-nota-fis   LIKE it-nota-fisc.nr-nota-fis NO-UNDO.
    DEF INPUT  PARAM cod-estabel   LIKE it-nota-fisc.cod-estabel NO-UNDO.
    DEF INPUT  PARAM serie         LIKE it-nota-fisc.serie       NO-UNDO.
    DEF INPUT  PARAM nr-seq-fat    LIKE it-nota-fisc.nr-seq-fat  NO-UNDO.
    DEF INPUT  PARAM it-codigo     LIKE it-nota-fisc.it-codigo   NO-UNDO.
    DEF INPUT  PARAM nr-pedido-drb LIKE pedido-drb.nr-pedido-drb NO-UNDO.
    DEF OUTPUT PARAM pc-nr-re      LIKE reg-export.nr-re-siscome NO-UNDO. 
    DEF OUTPUT PARAM p-vinculo-outro  AS LOG                     NO-UNDO.

    FIND FIRST it-nota-fisc
         WHERE it-nota-fisc.nr-nota-fis = nr-nota-fis
         AND   it-nota-fisc.cod-estabel = cod-estabel
         AND   it-nota-fisc.serie       = serie
         AND   it-nota-fisc.nr-seq-fat  = nr-seq-fat
         AND   it-nota-fisc.it-codigo   = it-codigo NO-LOCK NO-ERROR.
    
    IF  AVAIL it-nota-fisc THEN DO:
         FIND FIRST proc-it-nota-fisc
             WHERE proc-it-nota-fisc.nr-nota-fis       = it-nota-fisc.nr-nota-fis      
             &if "{&bf_dis_versao_ems}" >= "2.06" &then 
               AND proc-it-nota-fisc.cod-estab-faturam = it-nota-fisc.cod-estabel      
             &else
               AND proc-it-nota-fisc.cod-estabel       = it-nota-fisc.cod-estabel      
             &ENDIF
               AND proc-it-nota-fisc.serie             = it-nota-fisc.serie            
               AND proc-it-nota-fisc.nr-seq-fat        = it-nota-fisc.nr-seq-fat
               AND proc-it-nota-fisc.it-codigo         = it-nota-fisc.it-codigo NO-LOCK NO-ERROR.

        IF AVAIL proc-it-nota-fisc THEN DO:
            FIND FIRST proc-ped-ent
                 WHERE proc-ped-ent.cod-estabel  = proc-it-nota-fisc.cod-estabel
                   AND proc-ped-ent.nome-abrev   = it-nota-fisc.nome-ab-cli
                   AND proc-ped-ent.nr-sequencia = it-nota-fisc.nr-seq-ped
                   AND proc-ped-ent.it-codigo    = it-nota-fisc.it-codigo
                   AND proc-ped-ent.cod-refer    = it-nota-fisc.cod-refer
                   AND proc-ped-ent.nr-entrega   = it-nota-fisc.nr-entrega 
                   AND proc-ped-ent.nr-proc-exp  = proc-it-nota-fisc.nr-proc-exp NO-LOCK NO-ERROR.
        
        IF  AVAIL proc-ped-ent THEN DO:

            FIND FIRST reg-export-item
                 WHERE reg-export-item.cod-estabel   = proc-ped-ent.cod-estabel      
                 AND   reg-export-item.nr-proc-exp   = proc-ped-ent.nr-proc-exp
                 AND   reg-export-item.nome-abrev    = proc-ped-ent.nome-abrev
                 AND   reg-export-item.nr-pedcli     = proc-ped-ent.nr-pedcli
                 AND   reg-export-item.num-seq       = proc-ped-ent.nr-sequencia
                 AND   reg-export-item.it-codigo     = proc-ped-ent.it-codigo
                 AND   reg-export-item.cod-refer     = proc-ped-ent.cod-refer
                 AND   reg-export-item.nr-entrega    = proc-ped-ent.nr-entrega NO-LOCK NO-ERROR.

            IF  AVAIL reg-export-item THEN DO:

                FIND FIRST reg-export
                     WHERE reg-export.nr-re-ems = reg-export-item.nr-re-ems NO-LOCK NO-ERROR.

                IF  AVAIL reg-export THEN
                    ASSIGN pc-nr-re = reg-export.nr-re-siscomex.
                ELSE
                    ASSIGN pc-nr-re = "".
                 
                FIND FIRST pedido-drb-re 
                     WHERE pedido-drb-re.nr-pedido-drb <> nr-pedido-drb
                     AND   pedido-drb-re.cod-estabel    = reg-export-item.cod-estabel
                     AND   pedido-drb-re.nr-re          = STRING(reg-export-item.nr-re-ems) NO-LOCK NO-ERROR.
                
                IF  AVAIL pedido-drb-re THEN
                    ASSIGN p-vinculo-outro = YES.
                ELSE
                    ASSIGN p-vinculo-outro = NO.
                END.
            END.
        END.
    END.
&ENDIF

RETURN "OK":u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


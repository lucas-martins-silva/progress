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
{include/i-prgvrs.i BOIN220 2.00.00.004} /*** "010004" 27/10/2023 17:03:44  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin220 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ² um programa PROGRESS
                 que cont²m a l½gica de neg½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName movto-mat
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName movto-mat
&GLOBAL-DEFINE TableLabel movto-mat
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin220.i RowObject}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
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
   Other Settings: CODE-ONLY
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE canFindCharField DBOProgram 
PROCEDURE canFindCharField :
/*------------------------------------------------------------------------------
  Purpose: Procura se existe algum registro de movto-mat cujo atributo informado
           tenha valor igual ao valor passado (atributo tipo caracter)    
  Parameters:  recebe nome do atributo
               recebe valor para o atributo
               retorna flag (encontrado ou nÆo)
  Notes:       

------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER pFieldValue AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER pFound      AS LOGICAL   NO-UNDO. 

   case pFieldName:
      
      WHEN "cd-turno":U THEN 
         assign pFound = can-find(first bf{&TableName} where bf{&TableName}.cd-turno = pFieldValue). 
      WHEN "cod-depos":U THEN 
         assign pFound = can-find(first bf{&TableName} where bf{&TableName}.cod-depos = pFieldValue).
      WHEN "cod-estabel":U THEN 
         assign pFound = can-find(first bf{&TableName} where bf{&TableName}.cod-estabel = pFieldValue).
      when "it-codigo":U then
         assign pFound = can-find(first bf{&tablename} where bf{&TableName}.it-codigo = pFieldValue). 
            
      otherwise RETURN "NOK":U.
         
   end case.
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE canFindIntField DBOProgram 
PROCEDURE canFindIntField :
/*------------------------------------------------------------------------------
  Purpose: Procura se existe algum registro de movto-mat cujo atributo informado
           tenha valor igual ao valor passado (atributo tipo inteiro)    
  Parameters:  recebe nome do atributo
               recebe valor para o atributo
               retorna flag (encontrado ou nÆo)
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER pFieldValue AS INTEGER   NO-UNDO.
   DEFINE OUTPUT PARAMETER pFound      AS LOGICAL   NO-UNDO. 

   case pFieldName:
      WHEN "nr-ord-produ":U THEN 
         assign pFound = can-find(first bf{&TableName} where bf{&TableName}.nr-ord-produ = pFieldValue). 

      otherwise RETURN "NOK":U.
   end case.
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findlastMovtoMatMaiorDtTrans DBOProgram 
PROCEDURE findlastMovtoMatMaiorDtTrans :
/*------------------------------------------------------------------------------
  Purpose: Posiciona a Query corrente no £ltimo registro de movto-mat da Ordem 
           informa com data de transa‡Æo superior a data informada (? para 
           qualquer data).    
  Parameters:  recebe n£mero da Ordem
               recebe data da transa‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNrOrdem    like movto-mat.nr-ord-produ.
    DEFINE INPUT PARAMETER pDtTrans    like movto-mat.dt-trans.
    
    find last bf{&TableName}
         where  bf{&TableName}.nr-ord-produ  = pNrOrdem
         and   (bf{&TableName}.dt-trans > pDtTrans or pDtTrans = ? ) 
         no-lock no-error.
    if avail bf{&TableName} then do:
       RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-mat)).
       IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.
    end.       
    else 
       RETURN "NOK":U.
    RETURN "OK":U.        
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findMovtoMaiorUltFech DBOProgram 
PROCEDURE findMovtoMaiorUltFech :
/*------------------------------------------------------------------------------
  Purpose: Posiciona a Query corrente no primeiro registro de movto-mat da Ordem
           informada com data de transa‡Æo maior ou igual a data do £ltimo 
           fechamento (param-estoq.ult-fech-dia)   
  Parameters:  recebe n£mero da Ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNrOrdem    like movto-mat.nr-ord-produ.
    
    find first param-estoq no-lock no-error.
    if avail param-estoq then do:
       find first bf{&TableName}
            where bf{&TableName}.nr-ord-produ  = pNrOrdem
            and   bf{&TableName}.dt-trans     >= param-estoq.ult-fech-dia no-lock no-error.
       if avail bf{&TableName} then do:
          RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-mat)).
          IF RETURN-VALUE = "NOK":U THEN
              RETURN "NOK":U.
       end.       
       else 
          RETURN "NOK":U.
       RETURN "OK":U.        
    end.
    else 
      RETURN "NOK":U.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findMovtoMatAcabado DBOProgram 
PROCEDURE findMovtoMatAcabado :
/*------------------------------------------------------------------------------
  Purpose: Posiciona a Query corrente no £ltimo registro de movto-mat da Ordem
           informada cujo esp‚cie do documento seja Acabado e a data de transa‡Æo
           seja menor ou igual a data informada .    
  Parameters:  recebe n£mero da Ordem
               recebe data da transa‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNrOrdem    like movto-mat.nr-ord-produ.
    DEFINE INPUT PARAMETER pDtTrans    like movto-mat.dt-trans.
    
    find last bf{&TableName}
         where bf{&TableName}.esp-docto     = 1
         and   bf{&TableName}.nr-ord-produ  = pNrOrdem
         and   bf{&TableName}.dt-trans     <= pDtTrans no-lock no-error.
    if avail bf{&TableName} then do:
       RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-mat)).
       IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.
    end.       
    else 
       RETURN "NOK":U.
    RETURN "OK":U.        
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findMovtoMatDiferenteAcabado DBOProgram 
PROCEDURE findMovtoMatDiferenteAcabado :
/*------------------------------------------------------------------------------
  Purpose: Posiciona a Query corrente no £ltimo registro de movto-mat da Ordem
           informada cujo esp‚cie do documento seja diferente de Acabado e a data
           de transa‡Æo seja menor ou igual a data informada.     
  Parameters:  recebe n£mero da Ordem
               recebe data da transa‡Æo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNrOrdem    like movto-mat.nr-ord-produ.
    DEFINE INPUT PARAMETER pDtTrans    like movto-mat.dt-trans.
    
    find last bf{&TableName}
         where bf{&TableName}.esp-docto     <> 1
         and   bf{&TableName}.nr-ord-produ  =  pNrOrdem
         and   bf{&TableName}.dt-trans      <= pDtTrans no-lock no-error.
    if avail bf{&TableName} then do:
       RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-mat)).
       IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.
    end.       
    else 
       RETURN "NOK":U.
    RETURN "OK":U.        
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNum_seq DBOProgram 
PROCEDURE findNum_seq :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
          	mensagem de erro padrÆo do  EMS
  Parameters: ipar1:pnr-ord-produ:Ordem Produ‡Æo
              ipar2:pnum-sequen:  Sequˆncia 
       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter pnr-ord-produ as inte no-undo.
    def input parameter pnum-sequen as inte no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input pnr-ord-produ,
                 input pnum-sequen).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i movind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo n’o acha o registro */
    end.

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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "descricao-db":U THEN ASSIGN pFieldValue = RowObject.descricao-db.
        WHEN "referencia":U THEN ASSIGN pFieldValue = RowObject.referencia.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "cd-turno":U THEN ASSIGN pFieldValue = RowObject.cd-turno.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-vendedor":U THEN ASSIGN pFieldValue = RowObject.cod-vendedor.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-trans":U THEN ASSIGN pFieldValue = RowObject.dt-trans.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "qt-reporte":U THEN ASSIGN pFieldValue = RowObject.qt-reporte.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "vl-mob-c-m[1]":U THEN ASSIGN pFieldValue = RowObject.vl-mob-c-m[1].
        WHEN "vl-mob-c-m[2]":U THEN ASSIGN pFieldValue = RowObject.vl-mob-c-m[2].
        WHEN "vl-mob-c-m[3]":U THEN ASSIGN pFieldValue = RowObject.vl-mob-c-m[3].
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "vl-mob-c-o[1]":U THEN ASSIGN pFieldValue = RowObject.vl-mob-c-o[1].
        WHEN "vl-mob-c-o[2]":U THEN ASSIGN pFieldValue = RowObject.vl-mob-c-o[2].
        WHEN "vl-mob-c-o[3]":U THEN ASSIGN pFieldValue = RowObject.vl-mob-c-o[3].
        WHEN "vl-mob-c-p[1]":U THEN ASSIGN pFieldValue = RowObject.vl-mob-c-p[1].
        WHEN "vl-mob-c-p[2]":U THEN ASSIGN pFieldValue = RowObject.vl-mob-c-p[2].
        WHEN "vl-mob-c-p[3]":U THEN ASSIGN pFieldValue = RowObject.vl-mob-c-p[3].
        WHEN "valor-ggf-1-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-m[1].
        WHEN "valor-ggf-1-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-m[2].
        WHEN "valor-ggf-1-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-m[3].
        WHEN "valor-ggf-1-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-o[1].
        WHEN "valor-ggf-1-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-o[2].
        WHEN "valor-ggf-1-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-o[3].
        WHEN "valor-ggf-1-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-p[1].
        WHEN "valor-ggf-1-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-p[2].
        WHEN "valor-ggf-1-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-p[3].
        WHEN "valor-ggf-2-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-2-m[1].
        WHEN "valor-ggf-2-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-2-m[2].
        WHEN "valor-ggf-2-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-2-m[3].
        WHEN "valor-ggf-2-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-2-o[1].
        WHEN "valor-ggf-2-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-2-o[2].
        WHEN "valor-ggf-2-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-2-o[3].
        WHEN "valor-ggf-2-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-2-p[1].
        WHEN "valor-ggf-2-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-2-p[2].
        WHEN "valor-ggf-2-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-2-p[3].
        WHEN "valor-ggf-3-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-3-m[1].
        WHEN "valor-ggf-3-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-3-m[2].
        WHEN "valor-ggf-3-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-3-m[3].
        WHEN "valor-ggf-3-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-3-o[1].
        WHEN "valor-ggf-3-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-3-o[2].
        WHEN "valor-ggf-3-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-3-o[3].
        WHEN "valor-ggf-3-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-3-p[1].
        WHEN "valor-ggf-3-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-3-p[2].
        WHEN "valor-ggf-3-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-3-p[3].
        WHEN "valor-ggf-4-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-4-m[1].
        WHEN "valor-ggf-4-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-4-m[2].
        WHEN "valor-ggf-4-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-4-m[3].
        WHEN "valor-ggf-4-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-4-o[1].
        WHEN "valor-ggf-4-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-4-o[2].
        WHEN "valor-ggf-4-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-4-o[3].
        WHEN "valor-ggf-4-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-4-p[1].
        WHEN "valor-ggf-4-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-4-p[2].
        WHEN "valor-ggf-4-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-4-p[3].
        WHEN "valor-ggf-5-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-5-m[1].
        WHEN "valor-ggf-5-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-5-m[2].
        WHEN "valor-ggf-5-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-5-m[3].
        WHEN "valor-ggf-5-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-5-o[1].
        WHEN "valor-ggf-5-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-5-o[2].
        WHEN "valor-ggf-5-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-5-o[3].
        WHEN "valor-ggf-5-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-5-p[1].
        WHEN "valor-ggf-5-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-5-p[2].
        WHEN "valor-ggf-5-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-5-p[3].
        WHEN "valor-ggf-6-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-6-m[1].
        WHEN "valor-ggf-6-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-6-m[2].
        WHEN "valor-ggf-6-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-6-m[3].
        WHEN "valor-ggf-6-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-6-o[1].
        WHEN "valor-ggf-6-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-6-o[2].
        WHEN "valor-ggf-6-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-6-o[3].
        WHEN "valor-ggf-6-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-6-p[1].
        WHEN "valor-ggf-6-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-6-p[2].
        WHEN "valor-ggf-6-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-6-p[3].
        WHEN "valor-ggf-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[1].
        WHEN "valor-ggf-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[2].
        WHEN "valor-ggf-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[3].
        WHEN "valor-ggf-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[1].
        WHEN "valor-ggf-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[2].
        WHEN "valor-ggf-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[3].
        WHEN "valor-ggf-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[1].
        WHEN "valor-ggf-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[2].
        WHEN "valor-ggf-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[3].
        WHEN "valor-mat-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[1].
        WHEN "valor-mat-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[2].
        WHEN "valor-mat-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-m[3].
        WHEN "valor-mat-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[1].
        WHEN "valor-mat-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[2].
        WHEN "valor-mat-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-o[3].
        WHEN "valor-mat-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[1].
        WHEN "valor-mat-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[2].
        WHEN "valor-mat-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mat-p[3].
        WHEN "valor-mob-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[1].
        WHEN "valor-mob-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[2].
        WHEN "valor-mob-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[3].
        WHEN "valor-mob-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[1].
        WHEN "valor-mob-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[2].
        WHEN "valor-mob-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[3].
        WHEN "valor-mob-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[1].
        WHEN "valor-mob-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[2].
        WHEN "valor-mob-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[3].
        WHEN "vl-ggf-c-m[1]":U THEN ASSIGN pFieldValue = RowObject.vl-ggf-c-m[1].
        WHEN "vl-ggf-c-m[2]":U THEN ASSIGN pFieldValue = RowObject.vl-ggf-c-m[2].
        WHEN "vl-ggf-c-m[3]":U THEN ASSIGN pFieldValue = RowObject.vl-ggf-c-m[3].
        WHEN "vl-ggf-c-o[1]":U THEN ASSIGN pFieldValue = RowObject.vl-ggf-c-o[1].
        WHEN "vl-ggf-c-o[2]":U THEN ASSIGN pFieldValue = RowObject.vl-ggf-c-o[2].
        WHEN "vl-ggf-c-o[3]":U THEN ASSIGN pFieldValue = RowObject.vl-ggf-c-o[3].
        WHEN "vl-ggf-c-p[1]":U THEN ASSIGN pFieldValue = RowObject.vl-ggf-c-p[1].
        WHEN "vl-ggf-c-p[2]":U THEN ASSIGN pFieldValue = RowObject.vl-ggf-c-p[2].
        WHEN "vl-ggf-c-p[3]":U THEN ASSIGN pFieldValue = RowObject.vl-ggf-c-p[3].
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "esp-docto":U THEN ASSIGN pFieldValue = RowObject.esp-docto.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-reporte":U THEN ASSIGN pFieldValue = RowObject.nr-reporte.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "num-sequen":U THEN ASSIGN pFieldValue = RowObject.num-sequen.
        WHEN "op-seq":U THEN ASSIGN pFieldValue = RowObject.op-seq.
        WHEN "desmontagem":U THEN ASSIGN pFieldValue = RowObject.desmontagem.
        WHEN "tipo-trans":U THEN ASSIGN pFieldValue = RowObject.tipo-trans.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice NUM-SEQ
  Parameters:
               retorna valor dos campos do ­ndice NUM-SEQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-ord-produ LIKE movto-mat.nr-ord-produ NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-sequen LIKE movto-mat.num-sequen NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-ord-produ = RowObject.nr-ord-produ.
    ASSIGN pnum-sequen = RowObject.num-sequen.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l½gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "crp-atual":U THEN ASSIGN pFieldValue = RowObject.crp-atual.
        WHEN "db-cr-ok":U THEN ASSIGN pFieldValue = RowObject.db-cr-ok.
        WHEN "tipo-custeio":U THEN ASSIGN pFieldValue = RowObject.tipo-custeio.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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
  Purpose:     Reposiciona registro com base no ­ndice NUM-SEQ
  Parameters:
               recebe valor dos campos do ­ndice NUM-SEQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ord-produ LIKE movto-mat.nr-ord-produ NO-UNDO.
    DEFINE INPUT PARAMETER pnum-sequen LIKE movto-mat.num-sequen NO-UNDO.

    FIND FIRST bfmovto-mat WHERE
        bfmovto-mat.nr-ord-produ = pnr-ord-produ AND
        bfmovto-mat.num-sequen = pnum-sequen
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmovto-mat THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-mat)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    define input parameter i-abertura as integer no-undo.
       case i-abertura:
           when 1 then
              RUN openQueryStatic (input "Main":U). 
                          
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
    OPEN QUERY {&QueryName} FOR EACH movto-mat NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pegaUltimoReporte DBOProgram 
PROCEDURE pegaUltimoReporte :
/*------------------------------------------------------------------------------
  Purpose:    Consiste e carrega a data, quantidade e atraso do £ltimo reporte,
              passando esses valores p/ as respectivas vari veis de tela.
  Parameters: ipar1 : p-nr-ord-produ     : Numero da Ordem de Produ‡Æo
              opar1 : p-qtde-ult-reporte : Qtde ultimo Reporte
              opar2 : p-dt-ult-reporte   : Data do ultimo reporte  
       
------------------------------------------------------------------------------*/
     define input  parameter  p-nr-ord-produ      as char no-undo.
     define output parameter  p-qtde-ult-reporte  as char no-undo.
     define output parameter  p-dt-ult-reporte    as char no-undo.
     
     find last {&TABLENAME} where {&TABLENAME}.esp-docto    = 1  and
                                  {&TABLENAME}.nr-ord-produ = ord-prod.nr-ord-produ  no-lock no-error. 
  if avail {&TABLENAME} then 
       assign p-qtde-ult-reporte = trim(string({&TABLENAME}.quantidade,"->>>>,>>>,>>9.9999"))
              p-dt-ult-reporte   = trim(string({&TABLENAME}.dt-trans,"99/99/9999")).
  else 
       assign p-qtde-ult-reporte = trim(string(0,"->>>>,>>>,>>9.9999"))
              p-dt-ult-reporte   = "".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida»’o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida»„es ---*/

    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

 

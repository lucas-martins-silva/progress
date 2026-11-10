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
{include/i-prgvrs.i BOIN568 2.00.00.005 } /*** "010005" 27/10/2023 17:03:48  ***/
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
&GLOBAL-DEFINE DBOName BOIN568
&GLOBAL-DEFINE DBOVersion 2.0
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName movto-dir
&GLOBAL-DEFINE TableLabel Movimento de MOB Direta
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin568.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
def var c-nr-ord-prod like {&TableName}.nr-ord-produ.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2.01
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE canFindCharField DBOProgram 
PROCEDURE canFindCharField :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER pFieldValue AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER pFound      AS LOGICAL   NO-UNDO. 

   case pFieldName:
      
      WHEN "cd-tecnico":U THEN 
         assign pFound = can-find(first bf{&TableName} where bf{&TableName}.cd-tecnico = pFieldValue). 
      WHEN "cd-turno":U THEN 
         assign pFound = can-find(first bf{&TableName} where bf{&TableName}.cd-turno = pFieldValue).
      WHEN "gm-codigo":U THEN 
         assign pFound = can-find(first bf{&TableName} where bf{&TableName}.gm-codigo = pFieldValue).
      when "tp-especial":U then
         assign pFound = can-find(first bf{&TableName} where bf{&TableName}.tp-especial = pFieldValue). 
            
      otherwise RETURN "NOK":U.
         
   end case.
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findMovtoDirDtTrans DBOProgram 
PROCEDURE findMovtoDirDtTrans :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNrOrdem    like movto-dir.nr-ord-produ.
    DEFINE INPUT PARAMETER pDtTrans    like movto-dir.dt-trans.
    
    find last bf{&TableName}
         where bf{&TableName}.nr-ord-produ  = pNrOrdem
         and   bf{&TableName}.dt-trans     <= pDtTrans no-lock no-error.
    if avail bf{&TableName} then do:
       RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-dir)).
       IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.
    end.       
    else 
       RETURN "NOK":U.
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findlastMovtoDirMaiorDtTrans DBOProgram 
PROCEDURE findlastMovtoDirMaiorDtTrans :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNrOrdem    like movto-dir.nr-ord-produ.
    DEFINE INPUT PARAMETER pDtTrans    like movto-dir.dt-trans.
    
    find last bf{&TableName}
         where bf{&TableName}.nr-ord-produ  = pNrOrdem
         and   (bf{&TableName}.dt-trans > pDtTrans or pDtTrans = ? ) 
         no-lock no-error.
    if avail bf{&TableName} then do:
       RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-dir)).
       IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.
    end.       
    else 
       RETURN "NOK":U.
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
        WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo.
        WHEN "cd-mob-dir":U THEN ASSIGN pFieldValue = RowObject.cd-mob-dir.
        WHEN "cd-tecnico":U THEN ASSIGN pFieldValue = RowObject.cd-tecnico.
        WHEN "cd-turno":U THEN ASSIGN pFieldValue = RowObject.cd-turno.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "ct-cr-mob":U THEN ASSIGN pFieldValue = RowObject.ct-cr-mob.
        WHEN "ct-ordem":U THEN ASSIGN pFieldValue = RowObject.ct-ordem.
        WHEN "gm-codigo":U THEN ASSIGN pFieldValue = RowObject.gm-codigo.
        WHEN "hr-contab":U THEN ASSIGN pFieldValue = RowObject.hr-contab.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "refer-contab":U THEN ASSIGN pFieldValue = RowObject.refer-contab.
        WHEN "sc-cr-mob":U THEN ASSIGN pFieldValue = RowObject.sc-cr-mob.
        WHEN "sc-ordem":U THEN ASSIGN pFieldValue = RowObject.sc-ordem.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "tp-especial":U THEN ASSIGN pFieldValue = RowObject.tp-especial.
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
        WHEN "dt-contab":U THEN ASSIGN pFieldValue = RowObject.dt-contab.
        WHEN "dt-retorno":U THEN ASSIGN pFieldValue = RowObject.dt-retorno.
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
        WHEN "horas-report":U THEN ASSIGN pFieldValue = RowObject.horas-report.
        WHEN "qt-reportada":U THEN ASSIGN pFieldValue = RowObject.qt-reportada.
        WHEN "tempo-homem":U THEN ASSIGN pFieldValue = RowObject.tempo-homem.
        WHEN "tempo-prepar":U THEN ASSIGN pFieldValue = RowObject.tempo-prepar.
        WHEN "tempo-trans":U THEN ASSIGN pFieldValue = RowObject.tempo-trans.
        WHEN "valor-mob-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[1].
        WHEN "valor-mob-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[2].
        WHEN "valor-mob-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-m[3].
        WHEN "valor-mob-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[1].
        WHEN "valor-mob-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[2].
        WHEN "valor-mob-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-o[3].
        WHEN "valor-mob-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[1].
        WHEN "valor-mob-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[2].
        WHEN "valor-mob-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-mob-p[3].
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
        WHEN "cd-tarefa":U THEN ASSIGN pFieldValue = RowObject.cd-tarefa.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "matr-func":U THEN ASSIGN pFieldValue = RowObject.matr-func.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-reporte":U THEN ASSIGN pFieldValue = RowObject.nr-reporte.
        WHEN "num-id-movto-dir":U THEN ASSIGN pFieldValue = RowObject.num-id-movto-dir.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "op-seq":U THEN ASSIGN pFieldValue = RowObject.op-seq.
        WHEN "tipo-oper":U THEN ASSIGN pFieldValue = RowObject.tipo-oper.
        WHEN "tipo-trans":U THEN ASSIGN pFieldValue = RowObject.tipo-trans.
        WHEN "tipo-valor":U THEN ASSIGN pFieldValue = RowObject.tipo-valor.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ordem
  Parameters:  
               retorna valor do campo nr-ord-produ
               retorna valor do campo dt-trans
               retorna valor do campo cc-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-ord-produ LIKE movto-dir.nr-ord-produ NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-trans LIKE movto-dir.dt-trans NO-UNDO.
    DEFINE OUTPUT PARAMETER pcc-codigo LIKE movto-dir.cc-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-ord-produ = RowObject.nr-ord-produ
           pdt-trans = RowObject.dt-trans
           pcc-codigo = RowObject.cc-codigo.

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
        WHEN "contabilizado":U THEN ASSIGN pFieldValue = RowObject.contabilizado.
        WHEN "crp-atual":U THEN ASSIGN pFieldValue = RowObject.crp-atual.
        WHEN "db-cr-ok":U THEN ASSIGN pFieldValue = RowObject.db-cr-ok.
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
  Purpose:     Reposiciona registro com base no °ndice ordem
  Parameters:  
               recebe valor do campo nr-ord-produ
               recebe valor do campo dt-trans
               recebe valor do campo cc-codigo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ord-produ LIKE movto-dir.nr-ord-produ NO-UNDO.
    DEFINE INPUT PARAMETER pdt-trans LIKE movto-dir.dt-trans NO-UNDO.
    DEFINE INPUT PARAMETER pcc-codigo LIKE movto-dir.cc-codigo NO-UNDO.

    FIND FIRST bfmovto-dir WHERE 
        bfmovto-dir.nr-ord-produ = pnr-ord-produ AND 
        bfmovto-dir.dt-trans = pdt-trans AND 
        bfmovto-dir.cc-codigo = pcc-codigo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmovto-dir THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-dir)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdProd DBOProgram 
PROCEDURE openQueryOrdProd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
         where {&TableName}.nr-ord-produ = c-nr-ord-prod NO-LOCK.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procuraMovtoDirTarefEspec DBOProgram 
PROCEDURE procuraMovtoDirTarefEspec :
/*------------------------------------------------------------------------------
  Purpose: Procura movimento de mob direto com a Tarefa da Ordem (passar 
           Especialidade como ?) ou Especialidade da Ordem com a chave informada.    
  Parameters:  Recebe Ordem
               Recebe Tarefa
               Recebe Especialidade
               Retorna flag Achou Registro?
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter i-nr-ord-produ like {&tableName}.nr-ord-produ no-undo.
    def input  parameter c-cd-tarefa    like {&tableName}.cd-tarefa    no-undo.
    def input  parameter c-tp-especial  like {&tableName}.tp-especial  no-undo.
    def output parameter l-achou        as   logical                   no-undo.
 
    find first bf{&tableName} where bf{&tableName}.nr-ord-produ = i-nr-ord-produ
                              and   bf{&tableName}.cd-tarefa    = c-cd-tarefa
                              and  (bf{&tableName}.tp-especial  = c-tp-especial or
                                    c-tp-especial = ?)
                              no-lock no-error.
    assign l-achou = avail bf{&tableName}.  
    
    RETURN "OK":U.             
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdProd DBOProgram 
PROCEDURE setConstraintOrdProd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-nr-ord-prod like {&TableName}.nr-ord-produ no-undo.

assign c-nr-ord-prod = p-nr-ord-prod.

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
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



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
{include/i-prgvrs.i BOIN569 2.00.00.005} /*** "010005" 27/10/2023 17:03:49  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin569 MUT}
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
&GLOBAL-DEFINE DBOName movto-ggf
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName movto-ggf
&GLOBAL-DEFINE TableLabel movto-ggf
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin569.i RowObject}

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
         HEIGHT             = 21.54
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alteraCdEquipto DBOProgram 
PROCEDURE alteraCdEquipto :
/*------------------------------------------------------------------------------
  Purpose: Altera o Equipamento do movto-ggf.    
  Parameters:  recebe Equipamento anterior
               recebe Equipamento atual
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCdEquiptoAnt   like movto-ggf.cd-equipto.
DEFINE INPUT PARAMETER pCdEquiptoAtu   like movto-ggf.cd-equipto.

FOR EACH ord-manut fields (cd-equipto nr-ord-produ)
    WHERE ord-manut.cd-equipto = pCdEquiptoAnt no-lock:
    for first  movto-ggf fields (nr-ord-produ)
        where movto-ggf.nr-ord-produ = ord-manut.nr-ord-produ exclusive-lock:
    end.
    if avail movto-ggf then do:
        assign movto-ggf.cd-equipto = pCdEquiptoAtu.
    end.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE canFindCharField DBOProgram 
PROCEDURE canFindCharField :
/*------------------------------------------------------------------------------
  Purpose: Procura se existe algum registro de movto-ggf cujo atributo informado
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
      
      WHEN "cd-tecnico":U THEN 
         assign pFound = can-find(first bf{&TableName} where bf{&TableName}.cd-tecnico = pFieldValue).
      WHEN "cd-turno":U THEN 
         assign pFound = can-find(first bf{&TableName} where bf{&TableName}.cd-turno = pFieldValue).
      when "cd-equipto":U THEN DO:
         FOR EACH ord-manut fields (cd-equipto nr-ord-produ)
            WHERE ord-manut.cd-equipto = pFieldValue no-lock:
            for first  bf{&TableName} fields (nr-ord-produ)
                where bf{&TableName}.nr-ord-produ = ord-manut.nr-ord-produ NO-LOCK:
            end.
            if avail bf{&TableName} then do: 
                assign pFound = yes.
                LEAVE.
            end.
         END.
      END.
      when "tp-especial":U THEN DO:
          for each ord-esp fields (tp-especial nr-ord-produ cd-tarefa ) 
              where ord-esp.tp-especial = pFieldValue no-lock:
              for first bf{&TableName} fields (tp-especial cd-tarefa nr-ord-produ) 
                  where  bf{&TableName}.nr-ord-produ = ord-esp.nr-ord-produ
                  and    bf{&TableName}.cd-tarefa    = ord-esp.cd-tarefa
                  and    bf{&TableName}.tp-especial  = ord-esp.tp-especial no-lock:
              end.
              if avail bf{&TableName} then do:
                  assign pFound = yes.
                  LEAVE.
              end.
          end.
      END.
      otherwise RETURN "NOK":U.

   end case.
   
   RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE canFindIntegerField DBOProgram 
PROCEDURE canFindIntegerField :
/*------------------------------------------------------------------------------
  Purpose: Procura se existe algum registro de movto-ggf cujo atributo informado
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstMovtoGgfTarefa DBOProgram 
PROCEDURE findFirstMovtoGgfTarefa :
/*------------------------------------------------------------------------------
  Purpose: Posiciona a Query corrente no primeiro registro de movto-ggf da Tarefa
           da Ordem com a chave informada.    
  Parameters:  recebe n£mero da Ordem
               recebe tarefa da Ordem
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pNrOrdem    like movto-ggf.nr-ord-produ.
   DEFINE INPUT PARAMETER pCdTarefa   like movto-ggf.cd-tarefa.

   find first bf{&TableName}
        where bf{&TableName}.nr-ord-produ = pNrOrdem
        and   bf{&TableName}.cd-tarefa    = pCdTarefa no-lock no-error.
        
   if avail bf{&TableName} then do:
      RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-ggf)).
      IF RETURN-VALUE = "NOK":U THEN
          RETURN "NOK":U.
   end.       
   else 
      RETURN "NOK":U.

   RETURN "OK":U.             
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findlastMovtoGgfMaiorDtTrans DBOProgram 
PROCEDURE findlastMovtoGgfMaiorDtTrans :
/*------------------------------------------------------------------------------
  Purpose: Posiciona a Query corrente no £ltimo registro de movto-ggf da Ordem
           informada com data de transa‡Æo superior a data informada (? para 
           qualquer data).    
  Parameters:  recebe n£mero da Ordem
               recebe data 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNrOrdem    like movto-ggf.nr-ord-produ.
    DEFINE INPUT PARAMETER pDtTrans    like movto-ggf.dt-trans.
    
    find last bf{&TableName}
         where bf{&TableName}.nr-ord-produ  = pNrOrdem
         and   (bf{&TableName}.dt-trans > pDtTrans or pDtTrans = ?) 
         no-lock no-error.
    if avail bf{&TableName} then do:
       RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-ggf)).
       IF RETURN-VALUE = "NOK":U THEN
           RETURN "NOK":U.
    end.       
    else 
       RETURN "NOK":U.
    RETURN "OK":U.      
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findMovtoGgfDtTrans DBOProgram 
PROCEDURE findMovtoGgfDtTrans :
/*------------------------------------------------------------------------------
  Purpose: Posiciona a Query corrente no £ltimo registro de movto-ggf da Ordem
           informada com data de transa‡Æo menor ou igual a data informada.    
  Parameters:  recebe n£mero da Ordem
               recebe data 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNrOrdem    like movto-ggf.nr-ord-produ.
    DEFINE INPUT PARAMETER pDtTrans    like movto-ggf.dt-trans.
    
    find last bf{&TableName}
         where bf{&TableName}.nr-ord-produ  = pNrOrdem
         and   bf{&TableName}.dt-trans     <= pDtTrans no-lock no-error.
    if avail bf{&TableName} then do:
       RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-ggf)).
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
  Purpose: Posiciona a Query corrente no primeiro registro de movto-ggf da Ordem
           informada com data de transa‡Æo maior ou igual a data do £ltimo 
           fechamento (param-estoq.ult-fech-dia).    
  Parameters:  recebe n£mero da Ordem
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pNrOrdem    like movto-ggf.nr-ord-produ.
    
    find first param-estoq no-lock no-error.
    if avail param-estoq then do:
       find first bf{&TableName}
            where bf{&TableName}.nr-ord-produ  = pNrOrdem
            and   bf{&TableName}.dt-trans     >= param-estoq.ult-fech-dia no-lock no-error.
       if avail bf{&TableName} then do:
          RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-ggf)).
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
        WHEN "ct-cr-ggf[1]":U THEN ASSIGN pFieldValue = RowObject.ct-cr-ggf[1].
        WHEN "ct-cr-ggf[2]":U THEN ASSIGN pFieldValue = RowObject.ct-cr-ggf[2].
        WHEN "ct-cr-ggf[3]":U THEN ASSIGN pFieldValue = RowObject.ct-cr-ggf[3].
        WHEN "ct-cr-ggf[4]":U THEN ASSIGN pFieldValue = RowObject.ct-cr-ggf[4].
        WHEN "ct-cr-ggf[5]":U THEN ASSIGN pFieldValue = RowObject.ct-cr-ggf[5].
        WHEN "ct-cr-ggf[6]":U THEN ASSIGN pFieldValue = RowObject.ct-cr-ggf[6].
        WHEN "ct-ordem":U THEN ASSIGN pFieldValue = RowObject.ct-ordem.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "refer-contab":U THEN ASSIGN pFieldValue = RowObject.refer-contab.
        WHEN "referencia":U THEN ASSIGN pFieldValue = RowObject.referencia.
        WHEN "sc-cr-ggf[1]":U THEN ASSIGN pFieldValue = RowObject.sc-cr-ggf[1].
        WHEN "sc-cr-ggf[2]":U THEN ASSIGN pFieldValue = RowObject.sc-cr-ggf[2].
        WHEN "sc-cr-ggf[3]":U THEN ASSIGN pFieldValue = RowObject.sc-cr-ggf[3].
        WHEN "sc-cr-ggf[4]":U THEN ASSIGN pFieldValue = RowObject.sc-cr-ggf[4].
        WHEN "sc-cr-ggf[5]":U THEN ASSIGN pFieldValue = RowObject.sc-cr-ggf[5].
        WHEN "sc-cr-ggf[6]":U THEN ASSIGN pFieldValue = RowObject.sc-cr-ggf[6].
        WHEN "sc-ordem":U THEN ASSIGN pFieldValue = RowObject.sc-ordem.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "tp-especial":U THEN ASSIGN pFieldValue = RowObject.tp-especial.
        WHEN "gm-codigo":U THEN ASSIGN pFieldValue = RowObject.gm-codigo.
        WHEN "hr-contab":U THEN ASSIGN pFieldValue = RowObject.hr-contab.
        WHEN "hr-trans":U THEN ASSIGN pFieldValue = RowObject.hr-trans.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo.
        WHEN "cd-equipto":U THEN ASSIGN pFieldValue = RowObject.cd-equipto.
        WHEN "cd-tecnico":U THEN ASSIGN pFieldValue = RowObject.cd-tecnico.
        WHEN "cd-turno":U THEN ASSIGN pFieldValue = RowObject.cd-turno.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
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
        WHEN "dt-retorno":U THEN ASSIGN pFieldValue = RowObject.dt-retorno.
        WHEN "dt-trans":U THEN ASSIGN pFieldValue = RowObject.dt-trans.
        WHEN "dt-contab":U THEN ASSIGN pFieldValue = RowObject.dt-contab.
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
        WHEN "nr-up-report":U THEN ASSIGN pFieldValue = RowObject.nr-up-report.
        WHEN "qt-pecas-boas":U THEN ASSIGN pFieldValue = RowObject.qt-pecas-boas.
        WHEN "qt-refugo":U THEN ASSIGN pFieldValue = RowObject.qt-refugo.
        WHEN "qt-reportada":U THEN ASSIGN pFieldValue = RowObject.qt-reportada.
        WHEN "tempo-limp":U THEN ASSIGN pFieldValue = RowObject.tempo-limp.
        WHEN "tempo-maquin":U THEN ASSIGN pFieldValue = RowObject.tempo-maquin.
        WHEN "tempo-prepar":U THEN ASSIGN pFieldValue = RowObject.tempo-prepar.
        WHEN "tempo-trans":U THEN ASSIGN pFieldValue = RowObject.tempo-trans.
        WHEN "valor-ggf-1-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-m[1].
        WHEN "valor-ggf-1-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-m[2].
        WHEN "valor-ggf-1-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-m[3].
        WHEN "valor-ggf-1-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-o[1].
        WHEN "valor-ggf-1-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-o[2].
        WHEN "horas-report":U THEN ASSIGN pFieldValue = RowObject.horas-report.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
        WHEN "valor-ggf-1-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-o[3].
        WHEN "valor-ggf-1-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-p[1].
        WHEN "valor-ggf-1-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-1-p[2].
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
        WHEN "nr-req-sum":U THEN ASSIGN pFieldValue = RowObject.nr-req-sum.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "op-seq":U THEN ASSIGN pFieldValue = RowObject.op-seq.
        WHEN "tipo-oper":U THEN ASSIGN pFieldValue = RowObject.tipo-oper.
        WHEN "tipo-trans":U THEN ASSIGN pFieldValue = RowObject.tipo-trans.
        WHEN "tipo-valor":U THEN ASSIGN pFieldValue = RowObject.tipo-valor.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "matr-func":U THEN ASSIGN pFieldValue = RowObject.matr-func.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-reporte":U THEN ASSIGN pFieldValue = RowObject.nr-reporte.
        WHEN "cd-tarefa":U THEN ASSIGN pFieldValue = RowObject.cd-tarefa.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice ORDEM
  Parameters:
               retorna valor dos campos do ­ndice ORDEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-ord-produ LIKE movto-ggf.nr-ord-produ NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-trans LIKE movto-ggf.dt-trans NO-UNDO.
    DEFINE OUTPUT PARAMETER pcc-codigo LIKE movto-ggf.cc-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-ord-produ = RowObject.nr-ord-produ.
    ASSIGN pdt-trans = RowObject.dt-trans.
    ASSIGN pcc-codigo = RowObject.cc-codigo.

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
  Purpose:     Reposiciona registro com base no ­ndice ORDEM
  Parameters:
               recebe valor dos campos do ­ndice ORDEM
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ord-produ LIKE movto-ggf.nr-ord-produ NO-UNDO.
    DEFINE INPUT PARAMETER pdt-trans LIKE movto-ggf.dt-trans NO-UNDO.
    DEFINE INPUT PARAMETER pcc-codigo LIKE movto-ggf.cc-codigo NO-UNDO.

    FIND FIRST bfmovto-ggf WHERE
        bfmovto-ggf.nr-ord-produ = pnr-ord-produ AND
        bfmovto-ggf.dt-trans = pdt-trans AND
        bfmovto-ggf.cc-codigo = pcc-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmovto-ggf THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-ggf)).
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
    OPEN QUERY {&QueryName} FOR EACH movto-ggf NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procuraMovtoGGFTarefEspec DBOProgram 
PROCEDURE procuraMovtoGGFTarefEspec :
/*------------------------------------------------------------------------------
  Purpose: Procura movimento de ggf com a Tarefa da Ordem (passar Especialidade 
           como ?) ou Especialidade da Ordem com a chave informada.    
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


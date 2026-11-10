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
{include/i-prgvrs.i BOIN218O 2.00.00.004} /*** "010004" 01/12/2023 10:51:01  ***/
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
&GLOBAL-DEFINE DBOName boin218o
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName movto-estoq
&GLOBAL-DEFINE TableLabel Movimento de Estoque
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable rowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin218o.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findMovtoEstoqOM DBOProgram 
PROCEDURE findMovtoEstoqOM :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input parameter pNrOrdem   like movto-estoq.nr-ord-produ.
   
   find first movto-estoq
        where movto-estoq.nr-ord-produ = pNrOrdem no-lock no-error.
   if avail movto-estoq then
      RETURN "OK".
   else     
      RETURN "NOK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findMovtoSuperiorMensalAte DBOProgram 
PROCEDURE findMovtoSuperiorMensalAte :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter pNrOrdem   like movto-estoq.nr-ord-produ.
   
   find first param-estoq no-lock no-error.
   if avail param-estoq then do:
      find first movto-estoq
           where movto-estoq.nr-ord-produ = pNrOrdem
           and   movto-estoq.dt-trans     > param-estoq.mensal-ate
           no-lock no-error.
      if avail movto-estoq then
         RETURN "OK".
      else     
         RETURN "NOK".
   end.      
   else 
      RETURN "NOK".             
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
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-estabel-des":U THEN ASSIGN pFieldValue = RowObject.cod-estabel-des.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-orig-trans":U THEN ASSIGN pFieldValue = RowObject.cod-orig-trans.
        WHEN "cod-prog-orig":U THEN ASSIGN pFieldValue = RowObject.cod-prog-orig.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "cod-usu-ult-alter":U THEN ASSIGN pFieldValue = RowObject.cod-usu-ult-alter.
        WHEN "conta-contabil":U THEN ASSIGN pFieldValue = RowObject.conta-contabil.
        WHEN "conta-saldo":U THEN ASSIGN pFieldValue = RowObject.conta-saldo.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "ct-saldo":U THEN ASSIGN pFieldValue = RowObject.ct-saldo.
        WHEN "descricao-db":U THEN ASSIGN pFieldValue = RowObject.descricao-db.
        WHEN "hr-contab":U THEN ASSIGN pFieldValue = RowObject.hr-contab.
        WHEN "hr-trans":U THEN ASSIGN pFieldValue = RowObject.hr-trans.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-pai":U THEN ASSIGN pFieldValue = RowObject.item-pai.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "origem-valor":U THEN ASSIGN pFieldValue = RowObject.origem-valor.
        WHEN "refer-contab":U THEN ASSIGN pFieldValue = RowObject.refer-contab.
        WHEN "referencia":U THEN ASSIGN pFieldValue = RowObject.referencia.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "sc-saldo":U THEN ASSIGN pFieldValue = RowObject.sc-saldo.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
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
        WHEN "dt-nf-saida":U THEN ASSIGN pFieldValue = RowObject.dt-nf-saida.
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
        WHEN "peso-liquido":U THEN ASSIGN pFieldValue = RowObject.peso-liquido.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "valor-ggf-m[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[1].
        WHEN "valor-ggf-m[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[2].
        WHEN "valor-ggf-m[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-m[3].
        WHEN "valor-ggf-o[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[1].
        WHEN "valor-ggf-o[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[2].
        WHEN "valor-ggf-o[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-o[3].
        WHEN "valor-ggf-p[1]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[1].
        WHEN "valor-ggf-p[2]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[2].
        WHEN "valor-ggf-p[3]":U THEN ASSIGN pFieldValue = RowObject.valor-ggf-p[3].
        WHEN "valor-icm":U THEN ASSIGN pFieldValue = RowObject.valor-icm.
        WHEN "valor-ipi":U THEN ASSIGN pFieldValue = RowObject.valor-ipi.
        WHEN "valor-iss":U THEN ASSIGN pFieldValue = RowObject.valor-iss.
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
        WHEN "valor-nota":U THEN ASSIGN pFieldValue = RowObject.valor-nota.
        WHEN "vl-icm-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-icm-fasb[1].
        WHEN "vl-icm-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-icm-fasb[2].
        WHEN "vl-ipi-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-ipi-fasb[1].
        WHEN "vl-ipi-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-ipi-fasb[2].
        WHEN "vl-iss-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-iss-fasb[1].
        WHEN "vl-iss-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-iss-fasb[2].
        WHEN "vl-nota-fasb[1]":U THEN ASSIGN pFieldValue = RowObject.vl-nota-fasb[1].
        WHEN "vl-nota-fasb[2]":U THEN ASSIGN pFieldValue = RowObject.vl-nota-fasb[2].
        WHEN "vl-taxa":U THEN ASSIGN pFieldValue = RowObject.vl-taxa.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "esp-docto":U THEN ASSIGN pFieldValue = RowObject.esp-docto.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-ord-refer":U THEN ASSIGN pFieldValue = RowObject.nr-ord-refer.
        WHEN "nr-reporte":U THEN ASSIGN pFieldValue = RowObject.nr-reporte.
        WHEN "nr-req-sum":U THEN ASSIGN pFieldValue = RowObject.nr-req-sum.
        WHEN "nr-trans":U THEN ASSIGN pFieldValue = RowObject.nr-trans.
        WHEN "nr-trans-deb":U THEN ASSIGN pFieldValue = RowObject.nr-trans-deb.
        WHEN "num-ord-des":U THEN ASSIGN pFieldValue = RowObject.num-ord-des.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "num-seq-des":U THEN ASSIGN pFieldValue = RowObject.num-seq-des.
        WHEN "num-sequen":U THEN ASSIGN pFieldValue = RowObject.num-sequen.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "op-seq":U THEN ASSIGN pFieldValue = RowObject.op-seq.
        WHEN "sequen-nf":U THEN ASSIGN pFieldValue = RowObject.sequen-nf.
        WHEN "tipo-preco[1]":U THEN ASSIGN pFieldValue = RowObject.tipo-preco[1].
        WHEN "tipo-preco[2]":U THEN ASSIGN pFieldValue = RowObject.tipo-preco[2].
        WHEN "tipo-preco[3]":U THEN ASSIGN pFieldValue = RowObject.tipo-preco[3].
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
  Purpose:     Retorna valores dos campos do °ndice item-data
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo dt-trans
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE movto-estoq.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE movto-estoq.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-trans LIKE movto-estoq.dt-trans NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pcod-estabel = RowObject.cod-estabel
           pdt-trans = RowObject.dt-trans.

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
  Purpose:     Reposiciona registro com base no °ndice item-data
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo dt-trans
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE movto-estoq.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE movto-estoq.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pdt-trans LIKE movto-estoq.dt-trans NO-UNDO.

    FIND FIRST bfmovto-estoq WHERE 
        bfmovto-estoq.it-codigo = pit-codigo AND 
        bfmovto-estoq.cod-estabel = pcod-estabel AND 
        bfmovto-estoq.dt-trans = pdt-trans NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmovto-estoq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-estoq)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE procuraMovtoEstoqTarefa DBOProgram 
PROCEDURE procuraMovtoEstoqTarefa :
/*------------------------------------------------------------------------------
  Purpose: Procura movimento de estoque com a Tarefa da Ordem informada.    
  Parameters:  Recebe Ordem
               Recebe Tarefa
               Retorna flag Achou Registro?
  Notes:       
------------------------------------------------------------------------------*/
    def input  parameter i-nr-ord-produ like {&tableName}.nr-ord-produ no-undo.
    def input  parameter c-op-codigo    like {&tableName}.op-codigo    no-undo.
    def output parameter l-achou        as   logical                   no-undo.
    
    find first bf{&tableName} where bf{&tableName}.nr-ord-produ = i-nr-ord-produ
                              and   bf{&tableName}.op-codigo    = c-op-codigo
                              no-lock no-error.
                              
    assign l-achou = avail bf{&tableName}.  
    
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
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



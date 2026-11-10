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
{include/i-prgvrs.i BOIN313 2.00.00.004} /*** "010004" 27/10/2023 17:03:46  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin313 MUT}
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
&GLOBAL-DEFINE DBOName BOIN313
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName pl-mest
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin313.i RowObject}


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
         HEIGHT             = 1.94
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alocadoCarregado DBOProgram 
PROCEDURE alocadoCarregado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-cd-plano like pl-mest.cd-plano no-undo.

on delete of pm-al-it override do: end.
on delete of pm-al-pr override do: end.
 
/*** Limpeza de tabelas de pegging ***/
for each pm-al-it exclusive-lock
    where pm-al-it.cd-plano = p-cd-plano:
    delete pm-al-it.
end.         
 
for each pm-al-pr exclusive-lock
    where pm-al-pr.cd-plano = p-cd-plano:
    delete pm-al-pr.
end.                
 
/*** Inicializaá∆o do pm-cg-rc-per ***/
for each pm-cg-rc-per exclusive-lock
    where pm-cg-rc-per.cd-plano = p-cd-plano:
   assign pm-cg-rc-per.carga-alt = 0
          pm-cg-rc-per.carga     = 0.
end.           
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregadoNaoIniciado DBOProgram 
PROCEDURE carregadoNaoIniciado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-cd-plano like pl-mest.cd-plano no-undo. 

 
/*** Eliminaá∆o de plano mestre do produto ****/
for each pm-prod where 
         pm-prod.cd-plano = p-cd-plano exclusive-lock:
   delete pm-prod.
end.                                                              
 
/*** Eliminaá∆o de plano mestre do item ****/
for each pm-item where 
         pm-item.cd-plano = p-cd-plano exclusive-lock:
   delete pm-item.
end.                 
 
/** Elimina carga dos recursos anterior **/
for each pm-cg-rc where
         pm-cg-rc.cd-plano = p-cd-plano exclusive-lock: 
    delete pm-cg-rc.
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmadoProdutoAlocado DBOProgram 
PROCEDURE confirmadoProdutoAlocado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-cd-plano like pl-mest.cd-plano no-undo.

  on delete of pm-al-it-estab override do: end.
  on delete of pm-al-pr-estab override do: end.
  
  /*** Eliminaá∆o de registros de pegging do recusso estabelecimento - meta ***/
  for each pm-al-it-estab where
           pm-al-it-estab.cd-plano = p-cd-plano exclusive-lock:
     delete pm-al-it-estab.
  end.         
           
  for each pm-al-pr-estab where
           pm-al-pr-estab.cd-plano = p-cd-plano exclusive-lock:
     delete pm-al-pr-estab.
  end.         
  
  /*** Eliminaá∆o de metas do estabelecimento ***/
  for each pm-item-per-estab EXCLUSIVE-LOCK where
           pm-item-per-estab.cd-plano = p-cd-plano:
      delete pm-item-per-estab.
  end.         

  for each pm-prod-per-estab EXCLUSIVE-LOCK where
           pm-prod-per-estab.cd-plano = p-cd-plano:
      delete pm-prod-per-estab.
  end.         

  /*** Inicializaá∆o de pm-cg-rc-per-estab ***/
  for each pm-cg-rc-per-estab EXCLUSIVE-LOCK where 
           pm-cg-rc-per-estab.cd-plano = p-cd-plano:
      assign pm-cg-rc-per-estab.carga     = 0
             pm-cg-rc-per-estab.carga-alt = 0.     
  end.           

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaPlanoConfirmado DBOProgram 
PROCEDURE eliminaPlanoConfirmado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-cd-plano like pl-mest.cd-plano no-undo.

/*** Eliminaá∆o do plano confirmado ***/
find pl-prod EXCLUSIVE-LOCK where 
     pl-prod.cd-plano = p-cd-plano no-error.

if available pl-prod then delete pl-prod.
   
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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "hr-calc-fim":U THEN ASSIGN pFieldValue = RowObject.hr-calc-fim.
        WHEN "hr-calc-ini":U THEN ASSIGN pFieldValue = RowObject.hr-calc-ini.
        WHEN "per-prev-fim":U THEN ASSIGN pFieldValue = RowObject.per-prev-fim.
        WHEN "per-prev-ini":U THEN ASSIGN pFieldValue = RowObject.per-prev-ini.
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
        WHEN "dat-fim-pm":U THEN ASSIGN pFieldValue = RowObject.dat-fim-pm.
        WHEN "dat-fim-pp":U THEN ASSIGN pFieldValue = RowObject.dat-fim-pp.
        WHEN "dat-ini-pm":U THEN ASSIGN pFieldValue = RowObject.dat-ini-pm.
        WHEN "dat-ini-pp":U THEN ASSIGN pFieldValue = RowObject.dat-ini-pp.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-calc-fim":U THEN ASSIGN pFieldValue = RowObject.dt-calc-fim.
        WHEN "dt-calc-ini":U THEN ASSIGN pFieldValue = RowObject.dt-calc-ini.
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
        WHEN "ano-per-efet":U THEN ASSIGN pFieldValue = RowObject.ano-per-efet.
        WHEN "cd-plano":U THEN ASSIGN pFieldValue = RowObject.cd-plano.
        WHEN "cd-tipo-efet":U THEN ASSIGN pFieldValue = RowObject.cd-tipo-efet.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "ind-funcao-plano":U THEN ASSIGN pFieldValue = RowObject.ind-funcao-plano.
        WHEN "ind-nivel-calc":U THEN ASSIGN pFieldValue = RowObject.ind-nivel-calc.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-per-efet":U THEN ASSIGN pFieldValue = RowObject.nr-per-efet.
        WHEN "num-periodos":U THEN ASSIGN pFieldValue = RowObject.num-periodos.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "tipo-calculo-atp":U THEN ASSIGN pFieldValue = RowObject.tipo-calculo-atp.
        WHEN "tipo-cl-prev":U THEN ASSIGN pFieldValue = RowObject.tipo-cl-prev.
        WHEN "tipo-plano":U THEN ASSIGN pFieldValue = RowObject.tipo-plano.
        WHEN "tp-rep-fabr":U THEN ASSIGN pFieldValue = RowObject.tp-rep-fabr.
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
               retorna valor do campo cd-plano
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcd-plano LIKE pl-mest.cd-plano NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcd-plano = RowObject.cd-plano.

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
        WHEN "calc-atp-cot":U THEN ASSIGN pFieldValue = RowObject.calc-atp-cot.
        WHEN "calculo":U THEN ASSIGN pFieldValue = RowObject.calculo.
        WHEN "cons-apr":U THEN ASSIGN pFieldValue = RowObject.cons-apr.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-detalhe-atp":U THEN ASSIGN pFieldValue = RowObject.log-detalhe-atp.
        WHEN "log-gera-dados-mp":U THEN ASSIGN pFieldValue = RowObject.log-gera-dados-mp.
        WHEN "log-plano-mp":U THEN ASSIGN pFieldValue = RowObject.log-plano-mp.
        WHEN "log-recurso-item":U THEN ASSIGN pFieldValue = RowObject.log-recurso-item.
        WHEN "log-recurso-prod":U THEN ASSIGN pFieldValue = RowObject.log-recurso-prod.
        WHEN "log-reservas-atp":U THEN ASSIGN pFieldValue = RowObject.log-reservas-atp.
        WHEN "ordens-comp":U THEN ASSIGN pFieldValue = RowObject.ordens-comp.
        WHEN "ordens-fabr":U THEN ASSIGN pFieldValue = RowObject.ordens-fabr.
        WHEN "pedidos-fabr":U THEN ASSIGN pFieldValue = RowObject.pedidos-fabr.
        WHEN "res-fabr":U THEN ASSIGN pFieldValue = RowObject.res-fabr.
        WHEN "saldo-fabr":U THEN ASSIGN pFieldValue = RowObject.saldo-fabr.
        WHEN "tp-seg-fabr":U THEN ASSIGN pFieldValue = RowObject.tp-seg-fabr.
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
               recebe valor do campo cd-plano
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcd-plano LIKE pl-mest.cd-plano NO-UNDO.

    FIND FIRST bfpl-mest WHERE 
        bfpl-mest.cd-plano = pcd-plano NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpl-mest THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpl-mest)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    return "OK":U.

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



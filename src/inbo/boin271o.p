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
{include/i-prgvrs.i BOIN271O 2.00.00.011} /*** "010011" 27/10/2023 17:03:45  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin271o MUT}
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
&GLOBAL-DEFINE DBOName boin271o
&GLOBAL-DEFINE DBOVersion 2.00.00.010
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ord-prod
&GLOBAL-DEFINE TableLabel Ordem de Produá∆o
&GLOBAL-DEFINE QueryName qr{&TableName} 


/*--- Include com definiá∆o da temptable rowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin271o.i RowObject}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDataOrdem DBOProgram 
PROCEDURE atualizaDataOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza Data de inicio e tÇrmino da Ordem de Produá∆o.

  Parameters:  N£mero da Ordem
               Data de in°cio
               Data de tÇrmino 
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pNrOrdProdu LIKE {&tableName}.nr-ord-produ.
DEFINE INPUT PARAMETER pDtManut    LIKE {&tableName}.dt-inicio.
DEFINE INPUT PARAMETER pDtPrev     LIKE {&tableName}.dt-termino.


    find ord-prod
        where ord-prod.nr-ord-produ = pNrOrdProdu
        EXCLUSIVE-LOCK.
    if not avail ord-prod then
           return "NOK":U.
               
    assign ord-prod.dt-inicio  = pDtManut
           ord-prod.dt-termino = pDtPrev.
           
    return "OK":U.        
           
End Procedure.

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
        WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "conta-despesa":U THEN ASSIGN pFieldValue = RowObject.conta-despesa.
        WHEN "conta-imob":U THEN ASSIGN pFieldValue = RowObject.conta-imob.
        WHEN "conta-ordem":U THEN ASSIGN pFieldValue = RowObject.conta-ordem.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "ct-desp":U THEN ASSIGN pFieldValue = RowObject.ct-desp.
        WHEN "ct-imob":U THEN ASSIGN pFieldValue = RowObject.ct-imob.
        WHEN "es-codigo":U THEN ASSIGN pFieldValue = RowObject.es-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "it-inspec":U THEN ASSIGN pFieldValue = RowObject.it-inspec.
        WHEN "item-cotacao":U THEN ASSIGN pFieldValue = RowObject.item-cotacao.
        WHEN "lote-serie":U THEN ASSIGN pFieldValue = RowObject.lote-serie.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-pedido":U THEN ASSIGN pFieldValue = RowObject.nr-pedido.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "sc-desp":U THEN ASSIGN pFieldValue = RowObject.sc-desp.
        WHEN "sc-imob":U THEN ASSIGN pFieldValue = RowObject.sc-imob.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
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
        WHEN "data-alt":U THEN ASSIGN pFieldValue = RowObject.data-alt.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-inicio":U THEN ASSIGN pFieldValue = RowObject.dt-inicio.
        WHEN "dt-orig":U THEN ASSIGN pFieldValue = RowObject.dt-orig.
        WHEN "dt-termino":U THEN ASSIGN pFieldValue = RowObject.dt-termino.
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
        WHEN "qt-apr-cond":U THEN ASSIGN pFieldValue = RowObject.qt-apr-cond.
        WHEN "qt-inicial":U THEN ASSIGN pFieldValue = RowObject.qt-inicial.
        WHEN "qt-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-ordem.
        WHEN "qt-perda":U THEN ASSIGN pFieldValue = RowObject.qt-perda.
        WHEN "qt-produzida":U THEN ASSIGN pFieldValue = RowObject.qt-produzida.
        WHEN "qt-refugada":U THEN ASSIGN pFieldValue = RowObject.qt-refugada.
        WHEN "qt-reportada":U THEN ASSIGN pFieldValue = RowObject.qt-reportada.
        WHEN "qt-requisita":U THEN ASSIGN pFieldValue = RowObject.qt-requisita.
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
        WHEN "calc-cs-ggf":U THEN ASSIGN pFieldValue = RowObject.calc-cs-ggf.
        WHEN "calc-cs-mat":U THEN ASSIGN pFieldValue = RowObject.calc-cs-mat.
        WHEN "calc-cs-mob":U THEN ASSIGN pFieldValue = RowObject.calc-cs-mob.
        WHEN "cod-gr-cli":U THEN ASSIGN pFieldValue = RowObject.cod-gr-cli.
        WHEN "custeio-prop-ggf":U THEN ASSIGN pFieldValue = RowObject.custeio-prop-ggf.
        WHEN "custeio-prop-mat":U THEN ASSIGN pFieldValue = RowObject.custeio-prop-mat.
        WHEN "custeio-prop-mob":U THEN ASSIGN pFieldValue = RowObject.custeio-prop-mob.
        WHEN "dest-manut":U THEN ASSIGN pFieldValue = RowObject.dest-manut.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-estrut":U THEN ASSIGN pFieldValue = RowObject.nr-estrut.
        WHEN "nr-estrut-filha":U THEN ASSIGN pFieldValue = RowObject.nr-estrut-filha.
        WHEN "nr-ficha":U THEN ASSIGN pFieldValue = RowObject.nr-ficha.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
        WHEN "nr-ord-aber":U THEN ASSIGN pFieldValue = RowObject.nr-ord-aber.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-ord-refer":U THEN ASSIGN pFieldValue = RowObject.nr-ord-refer.
        WHEN "nr-req-sum":U THEN ASSIGN pFieldValue = RowObject.nr-req-sum.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "nr-ult-seq":U THEN ASSIGN pFieldValue = RowObject.nr-ult-seq.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "rep-prod":U THEN ASSIGN pFieldValue = RowObject.rep-prod.
        WHEN "reporte-ggf":U THEN ASSIGN pFieldValue = RowObject.reporte-ggf.
        WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
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
               retorna valor do campo nr-ord-produ
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-ord-produ LIKE ord-prod.nr-ord-produ NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-ord-produ = RowObject.nr-ord-produ.

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
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "emite-ordem":U THEN ASSIGN pFieldValue = RowObject.emite-ordem.
        WHEN "emite-requis":U THEN ASSIGN pFieldValue = RowObject.emite-requis.
        WHEN "enc-mensal":U THEN ASSIGN pFieldValue = RowObject.enc-mensal.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "prod-repet":U THEN ASSIGN pFieldValue = RowObject.prod-repet.
        WHEN "prototipo":U THEN ASSIGN pFieldValue = RowObject.prototipo.
        WHEN "req-emitida":U THEN ASSIGN pFieldValue = RowObject.req-emitida.
        WHEN "val-per":U THEN ASSIGN pFieldValue = RowObject.val-per.
        WHEN "valorizada":U THEN ASSIGN pFieldValue = RowObject.valorizada.
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
               recebe valor do campo nr-ord-produ
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ord-produ LIKE ord-prod.nr-ord-produ NO-UNDO.

    FIND FIRST bford-prod WHERE 
        bford-prod.nr-ord-produ = pnr-ord-produ NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bford-prod THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bford-prod)).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaCodEstabel DBOProgram 
PROCEDURE setaCodEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pNrOrdem    like ord-prod.nr-ord-prod no-undo.
  DEFINE INPUT PARAMETER pCodEstabel like ord-prod.cod-estabel no-undo.
  
  find first bf{&TableName} where bf{&TableName}.nr-ord-produ = pNrOrdem 
       exclusive-lock no-error.
  if avail bf{&TableName} then do:
     assign bf{&TableName}.cod-estabel = pCodEstabel.
     find current bf{&TableName} no-lock no-error. 
  end.
  else 
     RETURN "NOK":U.
     
  RETURN "OK":U.

END PROCEDURE.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaEstadoOrdem DBOProgram 
PROCEDURE setaEstadoOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pNrOrdem   like ord-prod.nr-ord-prod no-undo.
  DEFINE INPUT PARAMETER pEstado    as   integer              no-undo.
  
  find first bf{&TableName} where bf{&TableName}.nr-ord-produ = pNrOrdem 
       exclusive-lock no-error.
  if  avail bf{&TableName} then do:
      IF  bf{&TableName}.origem = "MI":U THEN DO:
          IF  bf{&TableName}.estado <> pEstado THEN DO:
              /* Gera registro na tabela mi-sincroniz */
              RUN mip/miapi100.p (INPUT "ord-manut":U, /* Nome da Tabela */
                                  INPUT STRING(bf{&TableName}.nr-ord-produ), /* Numero da Ordem de Manutená∆o */
                                  INPUT 2, /* 1-Create, 2-Update, 3-Delete */
                                  INPUT "").  /* Usuario */

              IF  pEstado = 7 OR pEstado = 8 OR (pEstado = 6 AND bf{&TableName}.estado = 7) OR (pEstado = 6 AND bf{&TableName}.estado = 8) THEN DO:
                  /** Chama procedure que validar† as alteraá‰es realizadas na OM **/
                  FOR FIRST mi-param-extens FIELDS(cdn-param des-valor) 
                      WHERE mi-param-extens.cdn-param = 112 
                      AND   mi-param-extens.des-valor = "Sim":U NO-LOCK:
                      /* Gera registro na tabela mi-ord-manut-histor */
                      RUN mip/miapi102.p (INPUT "ord-manut":U, /* Nome da tabela */
                                          INPUT "estado":U, /* Campo da tabela */
                                          INPUT bf{&TableName}.nr-ord-produ, /* Numero da Ordem de Manutená∆o */
                                          INPUT pEstado, /* Valor Atual */
                                          INPUT bf{&TableName}.estado). /* Valor Anterior */
                  END.
              END.
          END.
      END.
      assign bf{&TableName}.estado = pEstado.
      find first bf{&TableName} where bf{&TableName}.nr-ord-produ = pNrOrdem 
           no-lock no-error. 
  end.
  else 
     RETURN "NOK":U.
     
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaQuantidadesOrdem DBOProgram 
PROCEDURE setaQuantidadesOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pOrdem        like ord-prod.nr-ord-produ.
   DEFINE INPUT PARAMETER pQtReportada  like ord-prod.qt-reportada.
   DEFINE INPUT PARAMETER pQtProduzida  like ord-prod.qt-produzida.
   DEFINE INPUT PARAMETER pCalcCsMat    like ord-prod.calc-cs-mat.  

   find first bf{&TableName} where bf{&TableName}.nr-ord-produ = pOrdem
        exclusive-lock no-error.
   if avail bf{&TableName} then do:
      assign bf{&TableName}.qt-reportada   = if pQtReportada <> ? then 
                                                pQtReportada 
                                             else bf{&TableName}.qt-reportada
             bf{&TableName}.qt-produzida   = if pQtProduzida <> ? then 
                                                pQtProduzida 
                                             else bf{&TableName}.qt-produzida
             bf{&TableName}.calc-cs-mat    = if pCalcCsMat <> ? then
                                                pCalcCsMat
                                             else bf{&TableName}.calc-cs-mat.             
      find current bf{&TableName} no-lock no-error.
   end.   
   else 
      RETURN "NOK":U.     
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



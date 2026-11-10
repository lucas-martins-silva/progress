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
{include/i-prgvrs.i BOCX338 2.00.00.007 } /*** "010007" 11/12/2023 10:13:25 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx338 MUT}
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
&GLOBAL-DEFINE DBOName BOCX338
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName memorando-nf
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx338.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE cEstabIni     LIKE memorando-nf.nfs-cod-estabel NO-UNDO.
DEFINE VARIABLE cEstabFim     LIKE memorando-nf.nfs-cod-estabel NO-UNDO.
DEFINE VARIABLE cSerieIni     LIKE memorando-nf.nfs-serie       NO-UNDO.
DEFINE VARIABLE cSerieFim     LIKE memorando-nf.nfs-serie       NO-UNDO.
DEFINE VARIABLE cNrNotaFisIni LIKE memorando-nf.nfs-nr-nota-fis NO-UNDO.
DEFINE VARIABLE cNrNotaFisFim LIKE memorando-nf.nfs-nr-nota-fis NO-UNDO.
DEFINE VARIABLE daDatMemIni   LIKE memorando-nf.dat-memorando   NO-UNDO.
DEFINE VARIABLE daDatMemFim   LIKE memorando-nf.dat-memorando   NO-UNDO.
DEFINE VARIABLE l-valida      AS LOGICAL                        NO-UNDO.

{include/i-epc200.i "bocx338"}

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


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VAR c-motivo AS CHAR NO-UNDO.
    DEF VAR i-seq    AS INT  NO-UNDO.

    FIND FIRST RowObject NO-ERROR.

    IF AVAIL RowObject THEN DO:

        {utp/ut-liter.i "Eliminaá∆o Memorando Exportaá∆o"}.
        ASSIGN c-motivo = TRIM(RETURN-VALUE).

        for first nota-fiscal fields(nr-proc-exp) NO-LOCK
            where nota-fiscal.cod-estabel = RowObject.nfs-cod-estabel
            and   nota-fiscal.serie       = RowObject.nfs-serie      
            and   nota-fiscal.nr-nota-fis = RowObject.nfs-nr-nota-fis: 
        end.

        FOR EACH  memorando-nf-item EXCLUSIVE-LOCK
            WHERE memorando-nf-item.nfs-cod-estabel = RowObject.nfs-cod-estabel
            AND   memorando-nf-item.nfs-serie       = RowObject.nfs-serie
            AND   memorando-nf-item.nfs-nr-nota-fis = RowObject.nfs-nr-nota-fis:

            for first it-nota-fisc fields(nat-operacao it-codigo) NO-LOCK
                where it-nota-fisc.cod-estabel = RowObject.nfs-cod-estabel
                and   it-nota-fisc.serie       = RowObject.nfs-serie      
                and   it-nota-fisc.nr-nota-fis = RowObject.nfs-nr-nota-fis
                and   it-nota-fisc.nr-seq-fat  = memorando-nf-item.nfs-nr-seq-fat:
            end.

            FIND FIRST memorando-sdo EXCLUSIVE-LOCK
                 WHERE memorando-sdo.nfe-cod-estabel  = memorando-nf-item.nfe-cod-estabel
                 AND   memorando-sdo.nfe-serie        = memorando-nf-item.nfe-serie
                 AND   memorando-sdo.nfe-nro-docto    = memorando-nf-item.nfe-nro-docto 
                 AND   memorando-sdo.nfe-cod-emitente = memorando-nf-item.nfe-cod-emitente
                 AND   memorando-sdo.nfe-nat-operacao = memorando-nf-item.nfe-nat-operacao 
                 AND   memorando-sdo.nfe-nr-seq       = memorando-nf-item.nfe-nr-seq  NO-ERROR.

            IF AVAIL memorando-sdo THEN DO:

                FIND LAST  memorando-movto
                     WHERE memorando-movto.nfe-cod-estabel  = memorando-nf-item.nfe-cod-estabel 
                     AND   memorando-movto.nfe-serie        = memorando-nf-item.nfe-serie       
                     AND   memorando-movto.nfe-nro-docto    = memorando-nf-item.nfe-nro-docto   
                     AND   memorando-movto.nfe-cod-emitente = memorando-nf-item.nfe-cod-emitente
                     AND   memorando-movto.nfe-nat-operacao = memorando-nf-item.nfe-nat-operacao
                     AND   memorando-movto.nfe-nr-seq       = memorando-nf-item.nfe-nr-seq NO-LOCK NO-ERROR.

                IF AVAIL memorando-movto THEN
                    ASSIGN i-seq = memorando-movto.num-seq-movto + 1.
                ELSE
                    ASSIGN i-seq = 1.

                CREATE memorando-movto.
                ASSIGN memorando-movto.nfe-cod-estabel            = memorando-nf-item.nfe-cod-estabel 
                       memorando-movto.nfe-serie                  = memorando-nf-item.nfe-serie       
                       memorando-movto.nfe-nro-docto              = memorando-nf-item.nfe-nro-docto   
                       memorando-movto.nfe-cod-emitente           = memorando-nf-item.nfe-cod-emitente
                       memorando-movto.nfe-nat-operacao           = memorando-nf-item.nfe-nat-operacao
                       memorando-movto.nfe-nr-seq                 = memorando-nf-item.nfe-nr-seq      
                       memorando-movto.num-seq-movto              = i-seq
                       memorando-movto.idi-tip-movto              = 1 /* Entrada */
                       memorando-movto.dat-movto                  = TODAY
                       memorando-movto.hra-movto                  = STRING(TIME)
                       memorando-movto.qtd-movto                  = memorando-nf-item.qtd-bxada
                       memorando-movto.nfs-cod-estabel            = memorando-nf-item.nfs-cod-estabel
                       memorando-movto.nfs-serie                  = memorando-nf-item.nfs-serie
                       memorando-movto.nfs-nr-nota-fis            = memorando-nf-item.nfs-nr-nota-fis
                       memorando-movto.nat-operacao               = it-nota-fisc.nat-operacao
                       memorando-movto.nfs-nr-seq-fat             = memorando-nf-item.nfs-nr-seq-fat
                       memorando-movto.nfs-nr-proc-exp            = nota-fiscal.nr-proc-exp
                       memorando-movto.it-codigo-pai              = it-nota-fisc.it-codigo
                       memorando-movto.dsl-histor-movto-memorando = c-motivo
                       memorando-sdo.qtd-sdo-memorando            = memorando-sdo.qtd-sdo-memorando + memorando-nf-item.qtd-bxada.      

            END.     

            DELETE memorando-nf-item.

        END.   

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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "nfs-cod-estabel":U THEN ASSIGN pFieldValue = RowObject.nfs-cod-estabel.
        WHEN "nfs-nr-nota-fis":U THEN ASSIGN pFieldValue = RowObject.nfs-nr-nota-fis.
        WHEN "nfs-serie":U THEN ASSIGN pFieldValue = RowObject.nfs-serie.
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
        WHEN "dat-memorando":U THEN ASSIGN pFieldValue = RowObject.dat-memorando.
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
        WHEN "idi-sit-memorando":U THEN ASSIGN pFieldValue = RowObject.idi-sit-memorando.
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
  Purpose:     Retorna valores dos campos do °ndice mmrndnf-id
  Parameters:  
               retorna valor do campo nfs-cod-estabel
               retorna valor do campo nfs-serie
               retorna valor do campo nfs-nr-nota-fis
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnfs-cod-estabel LIKE memorando-nf.nfs-cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfs-serie LIKE memorando-nf.nfs-serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnfs-nr-nota-fis LIKE memorando-nf.nfs-nr-nota-fis NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnfs-cod-estabel = RowObject.nfs-cod-estabel
           pnfs-serie = RowObject.nfs-serie
           pnfs-nr-nota-fis = RowObject.nfs-nr-nota-fis.

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
        WHEN "log-gerac-autom":U THEN ASSIGN pFieldValue = RowObject.log-gerac-autom.
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
  Purpose:     Reposiciona registro com base no °ndice mmrndnf-id
  Parameters:  
               recebe valor do campo nfs-cod-estabel
               recebe valor do campo nfs-serie
               recebe valor do campo nfs-nr-nota-fis
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnfs-cod-estabel LIKE memorando-nf.nfs-cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnfs-serie LIKE memorando-nf.nfs-serie NO-UNDO.
    DEFINE INPUT PARAMETER pnfs-nr-nota-fis LIKE memorando-nf.nfs-nr-nota-fis NO-UNDO.

    FIND FIRST bfmemorando-nf WHERE 
        bfmemorando-nf.nfs-cod-estabel = pnfs-cod-estabel AND 
        bfmemorando-nf.nfs-serie = pnfs-serie AND 
        bfmemorando-nf.nfs-nr-nota-fis = pnfs-nr-nota-fis NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmemorando-nf THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmemorando-nf)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFaixa DBOProgram 
PROCEDURE openQueryFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query qr{&tableName} 
        FOR EACH  {&tableName} 
            WHERE {&tableName}.nfs-cod-estabel >= cEstabIni    
            AND   {&tableName}.nfs-cod-estabel <= cEstabFim    
            AND   {&tableName}.nfs-serie       >= cSerieIni    
            AND   {&tableName}.nfs-serie       <= cSerieFim    
            AND   {&tableName}.nfs-nr-nota-fis >= cNrNotaFisIni
            AND   {&tableName}.nfs-nr-nota-fis <= cNrNotaFisFim
            AND   {&tableName}.dat-memorando   >= daDatMemIni  
            AND   {&tableName}.dat-memorando   <= daDatMemFim  NO-LOCK 
        BY {&tableName}.nfs-cod-estabel
        BY {&tableName}.nfs-serie
        BY {&tableName}.nfs-nr-nota-fis
        BY {&tableName}.dat-memorando INDEXED-REPOSITION.                                         

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
    open query qr{&tableName} FOR EACH {&tableName} 
        NO-LOCK INDEXED-REPOSITION.                                         

     RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFaixa DBOProgram 
PROCEDURE setConstraintFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcEstabIni     LIKE memorando-nf.nfs-cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcEstabFim     LIKE memorando-nf.nfs-cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcSerieIni     LIKE memorando-nf.nfs-serie       NO-UNDO.
    DEFINE INPUT PARAMETER pcSerieFim     LIKE memorando-nf.nfs-serie       NO-UNDO.
    DEFINE INPUT PARAMETER pcNrNotaFisIni LIKE memorando-nf.nfs-nr-nota-fis NO-UNDO.
    DEFINE INPUT PARAMETER pcNrNotaFisFim LIKE memorando-nf.nfs-nr-nota-fis NO-UNDO.
    DEFINE INPUT PARAMETER pdaDatMemIni   LIKE memorando-nf.dat-memorando   NO-UNDO.
    DEFINE INPUT PARAMETER pdaDatMemFim   LIKE memorando-nf.dat-memorando   NO-UNDO.

    ASSIGN cEstabIni     = pcEstabIni    
           cEstabFim     = pcEstabFim    
           cSerieIni     = pcSerieIni    
           cSerieFim     = pcSerieFim    
           cNrNotaFisIni = pcNrNotaFisIni
           cNrNotaFisFim = pcNrNotaFisFim
           daDatMemIni   = pdaDatMemIni  
           daDatMemFim   = pdaDatMemFim.  

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
    
    CASE pType:
        WHEN "Create":U THEN DO:
            IF CAN-FIND(FIRST bfmemorando-nf NO-LOCK
                        WHERE bfmemorando-nf.nfs-cod-estabel = RowObject.nfs-cod-estabel
                        AND   bfmemorando-nf.nfs-serie       = RowObject.nfs-serie
                        AND   bfmemorando-nf.nfs-nr-nota-fis = RowObject.nfs-nr-nota-fis) THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-memorando-x-nf AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Memorando_x_NF" *}
                ASSIGN c-lbl-liter-memorando-x-nf = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="1" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-memorando-x-nf"}
            END.                                                                

            /* Estabelecimento Inv†lido */
            IF NOT CAN-FIND (FIRST estabelec NO-LOCK
                             WHERE estabelec.cod-estabel = RowObject.nfs-cod-estabel) THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Estabelecimento" *}
                ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="2" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-estabelecimento"}
            END.
            /* SÇrie Inv†lida */
            IF NOT CAN-FIND (FIRST serie NO-LOCK
                             WHERE serie.serie = RowObject.nfs-serie) THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-serie AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "SÇrie" *}
                ASSIGN c-lbl-liter-serie = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="2" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-serie"}
            END.
            /* Nota Fiscal Inv†lida */
            for  FIRST nota-fiscal fields(cod-estabel cod-emitente) NO-LOCK
                 WHERE nota-fiscal.cod-estabel = RowObject.nfs-cod-estabel
                 AND   nota-fiscal.serie       = RowObject.nfs-serie
                 AND   nota-fiscal.nr-nota-fis = RowObject.nfs-nr-nota-fis:
            end.

            if  not avail nota-fiscal THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-notafiscal AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "NotaFiscal" *}
                ASSIGN c-lbl-liter-notafiscal = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="2" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-notafiscal"}
            END.
            else do:
                
                for first emitente fields(pais) no-lock
                    where emitente.cod-emitente = nota-fiscal.cod-emitente:
                end.
                for first estabelec fields(pais) no-lock
                    where estabelec.cod-estabel = nota-fiscal.cod-estabel:
                end.

                /*************************************************************************/
                /*** IN÷CIO CHAMADA EPC - Cliente: MASTROTTO / FO: 1861.575            ***/
                /*************************************************************************/
                /*** Prop¢sito: Deixar de validar o pais do estabelecimento contra o   ***/
                /***            pais do emitente                                       ***/
                /*** Parametros:                                                       ***/
                /***    -> nota-fiscal rowid: disponibiliza o ROWID da nota fiscal     ***/
                /*************************************************************************/
                ASSIGN l-valida = YES.

                IF c-nom-prog-dpc-mg97  <> ""
                OR c-nom-prog-appc-mg97 <> "" 
                OR c-nom-prog-upc-mg97  <> "" THEN DO:
                    FOR EACH tt-epc 
                        WHERE tt-epc.cod-event = "validaEmitente":U:
                        DELETE tt-epc.
                    END.

                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "validaEmitente":U
                           tt-epc.cod-parameter = "rowidNotaFiscal":U
                           tt-epc.val-parameter = STRING(ROWID(nota-fiscal)).
                    
                    {include/i-epc201.i "validaEmitente"}

                    FIND FIRST tt-epc
                        WHERE tt-epc.cod-event     = "validaEmitente":U
                          AND tt-epc.cod-parameter = "retornaEmitente":U NO-ERROR.
                    IF AVAIL tt-epc THEN
                        ASSIGN l-valida = NO.
                END.
                /*************************************************************************/
                /*** FIM CHAMADA EPC - Cliente: MASTROTTO / FO: 1861.575               ***/
                /*************************************************************************/

                IF  l-valida
                AND estabelec.pais = emitente.pais THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="30607"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"}
                END.
            END.

            /* Data Inv†lida */
            IF RowObject.dat-memorando = ? THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="1090" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
            END.
        END.
        WHEN "Update":U THEN DO:
             IF RowObject.dat-memorando = ? THEN DO:
                 {method/svc/errors/inserr.i &ErrorNumber="1090" 
                                             &ErrorType="EMS"
                                             &ErrorSubType="ERROR"}
             END.
        END.
    END CASE.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**	
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa. 
*******************************************************************************/
{include/i-prgvrs.i BOIN006 2.00.00.040 } /*** "010040" 13/11/2023 11:45:42 ***/
    
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
  {include/i-license-manager.i boin006 MRE}
&ENDIF

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
&GLOBAL-DEFINE DBOName BOIN006
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rat-saldo-terc
&GLOBAL-DEFINE TableLabel Rateio Saldo Poder Terceiros
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
{inbo/boin006.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-serie-docto   LIKE rat-saldo-terc.serie-docto  NO-UNDO.
DEFINE VARIABLE c-nro-docto     LIKE rat-saldo-terc.nro-docto    NO-UNDO.
DEFINE VARIABLE i-cod-emitente  LIKE rat-saldo-terc.cod-emitente NO-UNDO.
DEFINE VARIABLE c-nat-operacao  LIKE rat-saldo-terc.nat-operacao NO-UNDO.
DEFINE VARIABLE c-it-codigo     LIKE rat-saldo-terc.it-codigo    NO-UNDO.
DEFINE VARIABLE c-cod-refer     LIKE rat-saldo-terc.cod-refer    NO-UNDO.
DEFINE VARIABLE i-sequencia     LIKE rat-saldo-terc.sequencia    NO-UNDO.

DEFINE VARIABLE de-quantidade   LIKE componente.quantidade            no-undo.
DEF BUFFER bNaturOper        FOR natur-oper.
DEF BUFFER bf-rat-saldo-terc FOR rat-saldo-terc.

{inbo/boin006.i2 tt-rat-saldo-terc-details tt-docs-of-lot-details} /* Temp-table utilizada para pesquisa de informaá‰es para telas metadados */
DEFINE TEMP-TABLE tt-rat-saldo-terc-details-return NO-UNDO LIKE tt-rat-saldo-terc-details. /* Temp-table utilizada para retorno de informaá‰es para telas metadados */

DEFINE TEMP-TABLE tt-rat-saldo-terc-dep NO-UNDO LIKE rat-saldo-terc
       field qtd-digitada as dec
       FIELD r-rowid AS ROWID 
       INDEX id IS PRIMARY UNIQUE serie-docto nro-docto cod-emitente nat-operacao it-codigo cod-refer sequencia lote cod-depos cod-localiz.

/*multiplas naturezas*/
{cdp/cd9701.i}

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
   Other Settings: CODE-ONLY COMPILE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param piItem             like rat-lote.it-codigo  no-undo.
    def input  param piCodEstabel       as char                  no-undo.
    def output param piHabilitaLocaliz  as log                   no-undo.
    def output param piHabilitaLote     as log                   no-undo.
    def output param piHabilitaValidade as log                   no-undo.
    def output param piHabilitaQtde     as log                   no-undo.

    for first item fields ( it-codigo tipo-con-est)
        where item.it-codigo = piItem no-lock.
    end.
    
    if NOT AVAIL ITEM then
        return "NOK":U.
        
    FOR FIRST item-uni-estab
        WHERE item-uni-estab.it-codigo   = item.it-codigo
        AND   item-uni-estab.cod-estabel = piCodEstabel NO-LOCK.
    END.
    
    IF NOT AVAIL item-uni-estab THEN
        RETURN "NOK":U.

    assign piHabilitaLocaliz  = not item-uni-estab.loc-unica
           piHabilitaLote     = item.tipo-con-est <> 1
           piHabilitaValidade = can-do("3,4",string(item.tipo-con-est))
           piHabilitaQtde     = item.tipo-con-est <> 2.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsOfDocumento DBOProgram 
PROCEDURE getBatchRecordsOfDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piNatOperRetorno as char                          no-undo.
    DEFINE INPUT PARAMETER pserie-docto     LIKE rat-saldo-terc.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto       LIKE rat-saldo-terc.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente    LIKE rat-saldo-terc.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao    LIKE rat-saldo-terc.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel     LIKE rat-saldo-terc.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER piProporcao      AS DEC NO-UNDO.
    DEFINE OUTPUT PARAM TABLE               FOR tt-rat-saldo-terc-dep.
    
    DEF VAR de-quantidade        LIKE componente.quantidade NO-UNDO.
    DEF VAR de-qtd               AS DECIMAL                 NO-UNDO.
    DEF VAR de-qt-tot-devol-simb AS DECIMAL                 NO-UNDO.
	DEF VAR de-qt-tot-fat        AS DECIMAL                 NO-UNDO.
    DEF VAR de-valor             AS DECIMAL                 NO-UNDO. 

    /* Limpa temp-table RowObjectAux */
    FOR EACH RowObjectAux :
        DELETE RowObjectAux.
    END.
 
    RUN findNaturOper ( INPUT piNatOperRetorno).
   
    FOR EACH rat-saldo-terc
       WHERE rat-saldo-terc.serie-docto  = pserie-docto 
         AND rat-saldo-terc.nro-docto    = pnro-docto   
         AND rat-saldo-terc.cod-emitente = pcod-emitente
         AND rat-saldo-terc.nat-operacao = pnat-operacao
         AND rat-saldo-terc.cod-estabel  = pcod-estabel NO-LOCK:
        FOR FIRST item
            FIELDS ( fraciona it-codigo )
            WHERE item.it-codigo = rat-saldo-terc.it-codigo NO-LOCK.
        END. 

        CREATE RowObjectAux.
        BUFFER-COPY rat-saldo-terc TO RowObjectAux.
        ASSIGN RowObjectAux.r-rowid = ROWID(rat-saldo-terc).   
        
        IF  {cdp/cd0066.i2 rat-saldo-terc.cod-estabel}
        AND natur-oper.tp-oper-terc = 4 THEN DO: /*Faturamento consignaá∆o com devoluá∆o simbolica*/
            ASSIGN de-qtd               = 0
                   de-qt-tot-devol-simb = 0
                   de-qt-tot-fat        = 0. 

            FOR EACH rat-componente NO-LOCK
               WHERE rat-componente.serie-comp   = rat-saldo-terc.serie-docto
                 AND rat-componente.nro-comp     = rat-saldo-terc.nro-docto
                 AND rat-componente.cod-emitente = rat-saldo-terc.cod-emitente
                 AND rat-componente.nat-comp     = rat-saldo-terc.nat-operacao
                 AND rat-componente.it-codigo    = rat-saldo-terc.it-codigo
                 AND rat-componente.cod-refer    = rat-saldo-terc.cod-refer
                 AND rat-componente.seq-comp     = rat-saldo-terc.sequencia
                 AND rat-componente.lote         = rat-saldo-terc.lote:
                
                IF  rat-componente.componente = 2
                AND NOT rat-componente.baixa-ce
                AND CAN-FIND(FIRST bNaturOper
                             WHERE bNaturOper.nat-operacao = rat-componente.nat-operacao
                               AND bNaturOper.terceiros 
                               AND bNaturOper.tp-oper-terc         = 5  /* Devolucao Consigacao*/
                               AND bNaturOper.idi-tip-devol-consig = 1) /* Simbolica */ THEN
                    ASSIGN de-qt-tot-devol-simb = de-qt-tot-devol-simb + rat-componente.quantidade.
                ELSE IF rat-componente.componente = 1 OR 
                        (rat-componente.componente = 2 AND 
                         CAN-FIND(FIRST bNaturOper
                             WHERE bNaturOper.nat-operacao = rat-componente.nat-operacao
                               AND bNaturOper.terceiros 
                               AND bNaturOper.tp-oper-terc = 4)) THEN /*Faturamento Consignacao*/
                    ASSIGN de-qt-tot-fat = de-qt-tot-fat + rat-componente.quantidade.
            END.
                
            /*
                rat-saldo-terc.quantidade     | SALDO DA REMESSA DISPONIVEL PARA FATURAMENTO 
                rat-componente.quantidade     | TOTAL DA REMESSA 
                rat-saldo-terc.qtd-aloc-trans | TOTAL DAS DEVOLU«’ES SIMBOLICAS E DE MERCADORIA
                de-qt-tot-devol-simb          | TOTAL DAS DEVOLU«’ES SIMBOLICAS
            */

            ASSIGN RowObjectAux.quantidade = ROUND((((de-qt-tot-devol-simb - de-qt-tot-fat) * piProporcao) / 100), IF item.fraciona THEN 4 ELSE 0).
        END.
        ELSE
            ASSIGN de-quantidade           = (( RowObjectAux.quantidade - RowObjectAux.qtd-aloc-trans ) * piProporcao ) / 100   
                   RowObjectAux.quantidade = ROUND(de-quantidade , IF item.fraciona THEN 4 ELSE 0).

        IF RowObjectAux.quantidade <= 0 THEN DO:
            DELETE RowObjectAux.
            NEXT.
        END.
    END.

    FOR EACH RowObjectAux NO-LOCK:

        ASSIGN de-qtd = 0.
        
        FIND FIRST natur-oper
             WHERE natur-oper.nat-operacao = piNatOperRetorno NO-LOCK NO-ERROR.
	     
        IF AVAIL natur-oper AND natur-oper.tp-oper-terc  = 5 AND natur-oper.idi-tip-devol-consig = 1 THEN DO: //devoluá∆o consignaá∆o simb¢lica

           CREATE tt-rat-saldo-terc-dep.
           BUFFER-COPY RowObjectAux TO tt-rat-saldo-terc-dep.
           ASSIGN tt-rat-saldo-terc-dep.r-rowid = rowid(RowObjectAux).

        END.
        ELSE DO:
            IF CAN-FIND(FIRST fat-ser-lote
                        WHERE fat-ser-lote.cod-estabel = RowObjectAux.cod-estabel
                          AND fat-ser-lote.serie       = RowObjectAux.serie-docto
                          AND fat-ser-lote.nr-nota-fis = RowObjectAux.nro-docto
                          AND fat-ser-lote.nr-seq-fat  = RowObjectAux.sequencia
                          AND fat-ser-lote.nr-serlote  = RowObjectAux.lote 
                          AND fat-ser-lote.it-codigo   = RowObjectAux.it-codigo) THEN DO:
    
                FOR EACH fat-ser-lote
                  WHERE fat-ser-lote.cod-estabel = RowObjectAux.cod-estabel
                    AND fat-ser-lote.serie       = RowObjectAux.serie-docto
                    AND fat-ser-lote.nr-nota-fis = RowObjectAux.nro-docto  
                    AND fat-ser-lote.nr-seq-fat  = RowObjectAux.sequencia  
                    AND fat-ser-lote.nr-serlote  = RowObjectAux.lote       
                    AND fat-ser-lote.it-codigo   = RowObjectAux.it-codigo NO-LOCK BREAK BY fat-ser-lote.nr-serlote:

                        FOR FIRST item
                            FIELDS ( fraciona it-codigo )
                            WHERE item.it-codigo = RowObjectAux.it-codigo NO-LOCK:
                        END. 
    
                        CREATE tt-rat-saldo-terc-dep.
                        BUFFER-COPY RowObjectAux EXCEPT cod-depos cod-localiz TO tt-rat-saldo-terc-dep.
                        ASSIGN tt-rat-saldo-terc-dep.r-rowid = rowid(RowObjectAux).

                        ASSIGN de-valor = ROUND((fat-ser-lote.qt-baixada[1] / RowObjectAux.qtd-origin) * RowObjectAux.quantidade, IF item.fraciona THEN 4 ELSE 0).
                        
                        IF (de-valor + de-qtd) > RowObjectAux.quantidade THEN
                            ASSIGN tt-rat-saldo-terc-dep.cod-depos   = fat-ser-lote.cod-depos   
                                   tt-rat-saldo-terc-dep.cod-localiz = fat-ser-lote.cod-localiz
                                   tt-rat-saldo-terc-dep.quantidade  = RowObjectAux.quantidade - de-qtd.
                        ELSE  DO:   
                            IF RowObjectAux.qtd-origin = 0 THEN
                                ASSIGN tt-rat-saldo-terc-dep.quantidade  = ROUND(fat-ser-lote.qt-baixada[1], IF item.fraciona THEN 4 ELSE 0).
                            ELSE 
                                ASSIGN tt-rat-saldo-terc-dep.quantidade  = ROUND((fat-ser-lote.qt-baixada[1] / RowObjectAux.qtd-origin) * RowObjectAux.quantidade, IF item.fraciona THEN 4 ELSE 0).

                            ASSIGN tt-rat-saldo-terc-dep.cod-depos   = fat-ser-lote.cod-depos   
                                   tt-rat-saldo-terc-dep.cod-localiz = fat-ser-lote.cod-localiz
                                   de-qtd = de-qtd + tt-rat-saldo-terc-dep.quantidade.
                        END.
                END.
            END.
            ELSE DO:
                CREATE tt-rat-saldo-terc-dep.
                BUFFER-COPY RowObjectAux TO tt-rat-saldo-terc-dep.
                ASSIGN tt-rat-saldo-terc-dep.r-rowid = rowid(RowObjectAux).
            END.
        END.
    END.

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
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-item-altern":U THEN ASSIGN pFieldValue = RowObject.cod-item-altern.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "des-checksum":U THEN ASSIGN pFieldValue = RowObject.des-checksum.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dt-retorno":U THEN ASSIGN pFieldValue = RowObject.dt-retorno.
        WHEN "dt-vali-lote":U THEN ASSIGN pFieldValue = RowObject.dt-vali-lote.
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
        WHEN "qtd-aloc-trans":U THEN ASSIGN pFieldValue = RowObject.qtd-aloc-trans.
        WHEN "qtd-origin":U THEN ASSIGN pFieldValue = RowObject.qtd-origin.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
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
  Purpose:     Retorna valores dos campos do °ndice rat-sdo-terc-id
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo sequencia
               retorna valor do campo lote
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE rat-saldo-terc.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE rat-saldo-terc.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE rat-saldo-terc.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE rat-saldo-terc.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE rat-saldo-terc.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE rat-saldo-terc.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE rat-saldo-terc.sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER plote LIKE rat-saldo-terc.lote NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer
           psequencia = RowObject.sequencia
           plote = RowObject.lote.

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
  Purpose:     Reposiciona registro com base no °ndice rat-sdo-terc-id
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo sequencia
               recebe valor do campo lote
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE rat-saldo-terc.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE rat-saldo-terc.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE rat-saldo-terc.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE rat-saldo-terc.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE rat-saldo-terc.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE rat-saldo-terc.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE rat-saldo-terc.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER plote LIKE rat-saldo-terc.lote NO-UNDO.

    FIND FIRST bfrat-saldo-terc WHERE 
        bfrat-saldo-terc.serie-docto = pserie-docto AND 
        bfrat-saldo-terc.nro-docto = pnro-docto AND 
        bfrat-saldo-terc.cod-emitente = pcod-emitente AND 
        bfrat-saldo-terc.nat-operacao = pnat-operacao AND 
        bfrat-saldo-terc.it-codigo = pit-codigo AND 
        bfrat-saldo-terc.cod-refer = pcod-refer AND 
        bfrat-saldo-terc.sequencia = psequencia AND 
        bfrat-saldo-terc.lote = plote  NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrat-saldo-terc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrat-saldo-terc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogItemFraciona DBOProgram 
PROCEDURE getLogItemFraciona :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor do campo fraciona do item
  Parameters:  
               recebe codigo do item
               retorna valor do campo fraciona
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piItCodigo AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFraciona AS LOGICAL NO-UNDO.
    
    DEFINE VARIABLE c-lbl AS CHARACTER NO-UNDO.
    
    if  not avail item 
    or  item.it-codigo <> piItCodigo then 
    
        for first item
            fields ( fraciona )
            where item.it-codigo = piItCodigo no-lock.
        end.
        
        
    {utp/ut-liter.i item *}    
    assign c-lbl = RETURN-VALUE.
    if  not avail item then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters=c-lbl}
        RETURN "NOK":U.
    end.
    else do:
        assign pFraciona = item.fraciona.
        RETURN "OK":U.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryBySaldoTerc DBOProgram 
PROCEDURE openQueryBySaldoTerc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName}
        FOR EACH {&TableName} NO-LOCK
            WHERE {&TableName}.serie-docto  = c-serie-docto 
            AND   {&TableName}.nro-docto    = c-nro-docto   
            AND   {&TableName}.cod-emitente = i-cod-emitente
            AND   {&TableName}.nat-operacao = c-nat-operacao
            AND   {&TableName}.it-codigo    = c-it-codigo   
            AND   {&TableName}.cod-refer    = c-cod-refer   
            AND   {&TableName}.sequencia    = i-sequencia 
            BY    {&TableName}.lote INDEXED-REPOSITION.
    
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
    
    OPEN QUERY {&queryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTTDocsOfLotDetails DBOProgram 
PROCEDURE returnTTDocsOfLotDetails :
/*------------------------------------------------------------------------------
  Purpose:     Retornar temp-table com as informaá‰es dos documentos que comp‰em
               os saldos em poder de terceiros por lote/referància.
  Parameters:  pc-it-codigo           -> C¢digo do item - parÉmetro p pesquisa;
               pc-cod-refer           -> C¢digo da referància - parÉmetro p pesquisa;
               pc-lote                -> Lote - parÉmetro p pesquisa;
               pc-cod-estabel         -> C¢digo do estabelecimento;
               pi-cod-emitente        -> C¢digo do emitente - parÉmetro p pesquisa;
               pi-tipo-sal-terc       -> C¢digo do tipo de saldo em terceiros - parÉmetro p pesquisa;
               tt-docs-of-lot-details -> Temp-table retornada com os documentos;
  Notes:       *PROCEDURE EXCLUSIVA DOS PROGRAMAS METADADOS*
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-it-codigo     LIKE rat-saldo-terc.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-refer     LIKE rat-saldo-terc.cod-refer    NO-UNDO.
    DEFINE INPUT  PARAMETER pc-lote          LIKE rat-saldo-terc.lote         NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-estabel   LIKE rat-saldo-terc.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-emitente  LIKE rat-saldo-terc.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER pi-tipo-sal-terc LIKE saldo-terc.tipo-sal-terc    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-docs-of-lot-details.
    
    DEFINE VARIABLE d-QtdSaldoSum            LIKE rat-saldo-terc.quantidade   NO-UNDO.
    DEFINE VARIABLE d-QtdOrigSum             LIKE rat-saldo-terc.qtd-origin   NO-UNDO.

    EMPTY TEMP-TABLE tt-docs-of-lot-details NO-ERROR.
        
    FOR EACH saldo-terc FIELDS (serie-docto nro-docto cod-emitente nat-operacao it-codigo
                                cod-refer sequencia) NO-LOCK
        WHERE saldo-terc.it-codigo     = pc-it-codigo
        AND   saldo-terc.cod-refer     = pc-cod-refer
        AND   saldo-terc.cod-estabel   = pc-cod-estabel
        AND   saldo-terc.cod-emitente  = pi-cod-emitente
        AND   saldo-terc.tipo-sal-terc = pi-tipo-sal-terc,
        EACH rat-saldo-terc NO-LOCK
        WHERE rat-saldo-terc.serie-docto  = saldo-terc.serie-docto
        AND   rat-saldo-terc.nro-docto    = saldo-terc.nro-docto
        AND   rat-saldo-terc.cod-emitente = saldo-terc.cod-emitente
        AND   rat-saldo-terc.nat-operacao = saldo-terc.nat-operacao
        AND   rat-saldo-terc.it-codigo    = saldo-terc.it-codigo
        AND   rat-saldo-terc.cod-refer    = saldo-terc.cod-refer
        AND   rat-saldo-terc.sequencia    = saldo-terc.sequencia
        AND   rat-saldo-terc.lote         = pc-lote
        BREAK BY (rat-saldo-terc.serie-docto + rat-saldo-terc.nro-docto + rat-saldo-terc.nat-operacao):

        IF  FIRST-OF (rat-saldo-terc.serie-docto + rat-saldo-terc.nro-docto + rat-saldo-terc.nat-operacao) THEN
            ASSIGN d-QtdSaldoSum = 0
                   d-QtdOrigSum  = 0.

        ASSIGN d-QtdSaldoSum = d-QtdSaldoSum + rat-saldo-terc.quantidade
               d-QtdOrigSum  = d-QtdOrigSum  + rat-saldo-terc.qtd-origin.

        IF  LAST-OF (rat-saldo-terc.serie-docto + rat-saldo-terc.nro-docto + rat-saldo-terc.nat-operacao) THEN DO:

            CREATE tt-docs-of-lot-details.
            ASSIGN tt-docs-of-lot-details.serieDocto  = rat-saldo-terc.serie-docto 
                   tt-docs-of-lot-details.nroDocto    = rat-saldo-terc.nro-docto   
                   tt-docs-of-lot-details.natOperacao = rat-saldo-terc.nat-operacao
                   tt-docs-of-lot-details.qtdOrigin   = d-QtdOrigSum
                   tt-docs-of-lot-details.quantidade  = d-QtdSaldoSum.

        END. /* End Last-of [...] */

    END. /* End FOR EACH saldo-terc [...] */
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

            &ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTTSaldosByItLotEstabel DBOProgram 
PROCEDURE returnTTSaldosByItLotEstabel :
/*------------------------------------------------------------------------------
  Purpose:     Retornar temp-table com as informaá‰es dos saldos em poder de 
               terceiros por lote/referància levando em consideraá∆o a p†gina
               selecionada no programa e a quantidade de registros por p†gina.
  Parameters:  pi-current-page    -> P†gina corrente do grid;
               pi-page-size       -> Quantidade de registros apresentados por p†gina;
               pc-it-codigo-ini   -> C¢digo do item - parÉmetro p pesquisa;
               pc-lote-ini        -> Lote - parÉmetro p pesquisa;
               pc-cod-estabel-ini -> C¢digo do estabelecimento - parÉmetro p pesquisa;
               pi-total-record    -> N£mero de registros retornados;
  Notes:       *PROCEDURE EXCLUSIVA DOS PROGRAMAS METADADOS*
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-current-page    AS INTEGER                      NO-UNDO.
    DEFINE INPUT  PARAMETER pi-page-size       AS INTEGER                      NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo-ini   LIKE rat-saldo-terc.it-codigo   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-lote-ini        LIKE rat-saldo-terc.lote        NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-estabel-ini LIKE rat-saldo-terc.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-total-record    AS INTEGER INITIAL 0            NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-rat-saldo-terc-details-return.

    DEFINE VARIABLE c-it-codigo-fin   LIKE rat-saldo-terc.it-codigo   INITIAL "ZZZZZZZZZZZZZZZZ" NO-UNDO.
    DEFINE VARIABLE c-lote-fin        LIKE rat-saldo-terc.lote        INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" NO-UNDO.
    DEFINE VARIABLE c-cod-estabel-fin LIKE rat-saldo-terc.cod-estabel INITIAL "ZZZZZ" NO-UNDO.
    DEFINE VARIABLE d-QuantidadeSum   LIKE rat-saldo-terc.quantidade NO-UNDO.
    DEFINE VARIABLE c-nome-abrev      LIKE emitente.nome-abrev NO-UNDO.
    DEFINE VARIABLE c-desc-item       LIKE item.desc-item      NO-UNDO.
    DEFINE VARIABLE i                 AS INTEGER NO-UNDO.
    DEFINE VARIABLE iInitialPage      AS INTEGER NO-UNDO. /* Utilizado para indicar a partir de qual linha deve comeáar a pesquisa (esquema de p†gina no metadados) */
    DEFINE VARIABLE hTable            AS HANDLE  NO-UNDO. 
    DEFINE VARIABLE hTTReturn         AS HANDLE  NO-UNDO. 
    DEFINE VARIABLE hbTTReturn        AS HANDLE  NO-UNDO. 
    DEFINE VARIABLE qhAux             AS HANDLE  NO-UNDO. /* ponteiro auxiliar utilizado na pesquisa com base na pagina/Nr. de registros a serem retornados p o metadados */
    DEFINE VARIABLE h-boad098         AS HANDLE  NO-UNDO. /* tabela emitente */
    DEFINE VARIABLE h-boin172         AS HANDLE  NO-UNDO. /* tabela item */
        
    IF  pc-it-codigo-ini <> "" AND pc-it-codigo-ini <> ? THEN
        ASSIGN c-it-codigo-fin = pc-it-codigo-ini.

    IF  pc-lote-ini <> "" AND pc-lote-ini <> ? THEN
        ASSIGN c-lote-fin = pc-lote-ini.

    IF  pc-cod-estabel-ini <> "" AND pc-cod-estabel-ini <> ? THEN
        ASSIGN c-cod-estabel-fin = pc-cod-estabel-ini.
    
    EMPTY TEMP-TABLE tt-rat-saldo-terc-details NO-ERROR.
        
    /* --> Handle da tabela emitente... */
    /* -- Verifica se o DBO j† est† inicializado ---*/
    IF  NOT VALID-HANDLE(h-boad098) OR
        h-boad098:TYPE <> "PROCEDURE":U OR
        h-boad098:FILE-NAME <> "adbo/boad098na.p":U THEN
        RUN adbo/boad098na.p PERSISTENT SET h-boad098.
    RUN openQueryStatic IN h-boad098 (INPUT "Main":U) NO-ERROR.
    /* --> */

    /* --> Handle da tabela item... */
    /* -- Verifica se o DBO j† est† inicializado ---*/
    IF  NOT VALID-HANDLE(h-boin172) OR
        h-boin172:TYPE <> "PROCEDURE":U OR
        h-boin172:FILE-NAME <> "inbo/boin172.p":U THEN
        RUN inbo/boin172.p PERSISTENT SET h-boin172.
    RUN openQueryStatic IN h-boin172 (INPUT "Main":U) NO-ERROR.
    /* --> */

    /* FOR EACH saldo-terc FIELDS (serie-docto nro-docto cod-emitente nat-operacao it-codigo
                                cod-refer sequencia tipo-sal-terc log-entreg-fut) NO-LOCK
        WHERE saldo-terc.cod-estabel >= pc-cod-estabel-ini
        AND   saldo-terc.cod-estabel <= c-cod-estabel-fin
        AND   saldo-terc.it-codigo   >= pc-it-codigo-ini
        AND   saldo-terc.it-codigo   <= c-it-codigo-fin
        AND   saldo-terc.lote        >= pc-lote-ini 
        AND   saldo-terc.lote        <= c-lote-fin,
        EACH rat-saldo-terc NO-LOCK
        WHERE rat-saldo-terc.serie-docto  = saldo-terc.serie-docto
        AND   rat-saldo-terc.nro-docto    = saldo-terc.nro-docto
        AND   rat-saldo-terc.cod-emitente = saldo-terc.cod-emitente
        AND   rat-saldo-terc.nat-operacao = saldo-terc.nat-operacao
        AND   rat-saldo-terc.it-codigo    = saldo-terc.it-codigo
        AND   rat-saldo-terc.cod-refer    = saldo-terc.cod-refer
        AND   rat-saldo-terc.sequencia    = saldo-terc.sequencia
        BREAK BY (STRING(saldo-terc.tipo-sal-terc) + rat-saldo-terc.it-codigo + STRING(rat-saldo-terc.cod-emitente) + 
                  rat-saldo-terc.cod-estabel + rat-saldo-terc.lote + rat-saldo-terc.cod-refer): */
        
    FOR EACH rat-saldo-terc NO-LOCK
        WHERE rat-saldo-terc.cod-estabel >= pc-cod-estabel-ini
        AND   rat-saldo-terc.cod-estabel <= c-cod-estabel-fin
        AND   rat-saldo-terc.it-codigo   >= pc-it-codigo-ini
        AND   rat-saldo-terc.it-codigo   <= c-it-codigo-fin
        AND   rat-saldo-terc.lote        >= pc-lote-ini 
        AND   rat-saldo-terc.lote        <= c-lote-fin,
        EACH saldo-terc FIELDS (tipo-sal-terc log-entreg-fut) NO-LOCK
        WHERE saldo-terc.serie-docto  = rat-saldo-terc.serie-docto
        AND   saldo-terc.nro-docto    = rat-saldo-terc.nro-docto
        AND   saldo-terc.cod-emitente = rat-saldo-terc.cod-emitente
        AND   saldo-terc.nat-operacao = rat-saldo-terc.nat-operacao
        AND   saldo-terc.it-codigo    = rat-saldo-terc.it-codigo
        AND   saldo-terc.cod-refer    = rat-saldo-terc.cod-refer
        AND   saldo-terc.sequencia    = rat-saldo-terc.sequencia
        BREAK BY (STRING(saldo-terc.tipo-sal-terc) + rat-saldo-terc.it-codigo + STRING(rat-saldo-terc.cod-emitente) + 
                  rat-saldo-terc.cod-estabel + rat-saldo-terc.lote + rat-saldo-terc.cod-refer):

        IF  FIRST-OF (STRING(saldo-terc.tipo-sal-terc) + rat-saldo-terc.it-codigo + STRING(rat-saldo-terc.cod-emitente) + 
                      rat-saldo-terc.cod-estabel + rat-saldo-terc.lote + rat-saldo-terc.cod-refer) THEN
            ASSIGN d-QuantidadeSum = 0.

        ASSIGN d-QuantidadeSum = d-QuantidadeSum + rat-saldo-terc.quantidade.

        IF  LAST-OF (STRING(saldo-terc.tipo-sal-terc) + rat-saldo-terc.it-codigo + STRING(rat-saldo-terc.cod-emitente) + 
                     rat-saldo-terc.cod-estabel + rat-saldo-terc.lote + rat-saldo-terc.cod-refer) THEN DO:
        
            /* --> pesquisa nome abreviado do emitente... */ 
            RUN goToKey      IN h-boad098 (INPUT rat-saldo-terc.cod-emitente).
            RUN getCharField IN h-boad098 (INPUT "nome-abrev":U, OUTPUT c-nome-abrev).
             
            /* --> pesquisa descriá∆o do item... */
            RUN gotoKey      IN h-boin172 (INPUT rat-saldo-terc.it-codigo).
            RUN getCharField IN h-boin172 (INPUT "desc-item":U, OUTPUT c-desc-item).
            
            ASSIGN pi-total-record = pi-total-record + 1. /* Total de linhas a serem retoradas */
    
            CREATE tt-rat-saldo-terc-details.
            ASSIGN tt-rat-saldo-terc-details.itCodigo     = rat-saldo-terc.it-codigo
                   tt-rat-saldo-terc-details.descItem     = c-desc-item
                   tt-rat-saldo-terc-details.codRefer     = rat-saldo-terc.cod-refer
                   tt-rat-saldo-terc-details.lote         = rat-saldo-terc.lote
                   tt-rat-saldo-terc-details.codEstabel   = rat-saldo-terc.cod-estabel
                   tt-rat-saldo-terc-details.nomeAbrev    = c-nome-abrev
                   tt-rat-saldo-terc-details.quantidade   = d-QuantidadeSum  /* Somat¢ria do agrupamento... */
                   tt-rat-saldo-terc-details.tipoSalTerc  = saldo-terc.tipo-sal-terc
                   tt-rat-saldo-terc-details.codEmitente  = rat-saldo-terc.cod-emitente.
                               
            IF  (saldo-terc.tipo-sal-terc > 0 OR saldo-terc.tipo-sal-terc <= 10) AND saldo-terc.tipo-sal-terc <> 6 THEN DO: /* Busca descriá∆o do tipo de saldo */
                ASSIGN tt-rat-saldo-terc-details.descTipoSaldo = {ininc/i01in404.i 04 saldo-terc.tipo-sal-terc}.
    
                IF saldo-terc.log-entreg-fut THEN /* Verifica se Ç entrega futura para concatenar observaá∆o */
                    ASSIGN tt-rat-saldo-terc-details.descTipoSaldo = tt-rat-saldo-terc-details.descTipoSaldo + "-Entrega Futura".
            END.

        END. /* End Last-of [...] */
        
    END. /* End FOR EACH saldo-terc [...] */

    /*--- Elimina o handle da BO emitente ---*/
    IF  VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    /*--- Elimina o handle da BO item ---*/
    IF  VALID-HANDLE(h-boin172) THEN DO:
        DELETE PROCEDURE h-boin172.
        ASSIGN h-boin172 = ?.
    END.
    
    ASSIGN hTable     = BUFFER tt-rat-saldo-terc-details:HANDLE
           hTTReturn  = TEMP-TABLE tt-rat-saldo-terc-details-return:HANDLE
                   hbTTReturn = hTTReturn:DEFAULT-BUFFER-HANDLE.
    
    /* Verifica qual serˇ o primeiro registro da prΩxima pagina*/
        ASSIGN iInitialPage = 1 + (pi-current-page - 1) * pi-page-size.

    CREATE QUERY qhAux.
    qhAux:SET-BUFFERS(hTable). 
    qhAux:QUERY-PREPARE("PRESELECT EACH tt-rat-saldo-terc-details INDEXED-REPOSITION").
    qhAux:QUERY-OPEN().

    
        /*Posiciona no registro previamente calculado */
    qhAux:REPOSITION-TO-ROW(iInitialPage).
      
    REPEAT i = 1 TO pi-page-size:
      qhAux:GET-NEXT().
      IF qhAux:QUERY-OFF-END /* Se j† chegou no fim dos registros...*/
          THEN LEAVE.

      hbTTReturn:BUFFER-CREATE().     /* Cria nova linha no buffer... */
      hbTTReturn:BUFFER-COPY(hTable). /* Copia a linha da tt-rat-saldo-terc-details... */
      hbTTReturn:BUFFER-RELEASE().    /* Efetiva linha do registro criado... */
    END.
        qhAux:QUERY-CLOSE().
    
        IF VALID-HANDLE(qhAux) THEN
                DELETE OBJECT qhAux.
        IF VALID-HANDLE(hTTReturn) THEN
                DELETE OBJECT hTTReturn.
        IF VALID-HANDLE(hTable) THEN
                DELETE OBJECT hTable.
        IF VALID-HANDLE(hbTTReturn) THEN
                DELETE OBJECT hbTTReturn.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintBySaldoTerc DBOProgram 
PROCEDURE setConstraintBySaldoTerc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto  LIKE rat-saldo-terc.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto    LIKE rat-saldo-terc.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE rat-saldo-terc.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE rat-saldo-terc.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo    LIKE rat-saldo-terc.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer    LIKE rat-saldo-terc.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER psequencia    LIKE rat-saldo-terc.sequencia NO-UNDO.

    ASSIGN c-serie-docto  = pserie-docto 
           c-nro-docto    = pnro-docto   
           i-cod-emitente = pcod-emitente
           c-nat-operacao = pnat-operacao
           c-it-codigo    = pit-codigo   
           c-cod-refer    = pcod-refer   
           i-sequencia    = psequencia. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateQtdAloc DBOProgram 
PROCEDURE updateQtdAloc :
/*------------------------------------------------------------------------------
  Purpose:     atualiza quantidade alocada (qtd-aloc-trans)
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo nat-operacao
               recebe valor do campo sequencia
               recebe valor do campo cod-emitente
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo lote
               recebe aá∆o a ser tomada. valores "aloca" ou "desaloca"
               recebe valor alocado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto    LIKE rat-saldo-terc.serie-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto      LIKE rat-saldo-terc.nro-docto      NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao   LIKE rat-saldo-terc.nat-operacao   NO-UNDO.
    DEFINE INPUT PARAMETER psequencia      LIKE rat-saldo-terc.sequencia      NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente   LIKE rat-saldo-terc.cod-emitente   NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo      LIKE rat-saldo-terc.it-codigo      NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer      LIKE rat-saldo-terc.cod-refer      NO-UNDO.
    DEFINE INPUT PARAMETER plote           LIKE rat-saldo-terc.lote           NO-UNDO.
    DEFINE INPUT PARAMETER pacao           AS   CHAR                          NO-UNDO.
    DEFINE INPUT PARAMETER pqtd-aloc-trans LIKE rat-saldo-terc.qtd-aloc-trans NO-UNDO. 

    FIND FIRST bfrat-saldo-terc 
         WHERE bfrat-saldo-terc.serie-docto  = pserie-docto
           AND bfrat-saldo-terc.nro-docto    = pnro-docto
           AND bfrat-saldo-terc.nat-operacao = pnat-operacao
           AND bfrat-saldo-terc.sequencia    = psequencia
           AND bfrat-saldo-terc.cod-emitente = pcod-emitente
           AND bfrat-saldo-terc.it-codigo    = pit-codigo
           AND bfrat-saldo-terc.cod-refer    = pcod-refer
           AND bfrat-saldo-terc.lote         = plote EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAILABLE bfrat-saldo-terc THEN 
        RETURN "NOK":U.

    CASE pacao:
        WHEN "aloca":U THEN
            assign bfrat-saldo-terc.qtd-aloc-trans = bfrat-saldo-terc.qtd-aloc-trans + pqtd-aloc-trans.
        WHEN "desaloca":U THEN
            assign bfrat-saldo-terc.qtd-aloc-trans = bfrat-saldo-terc.qtd-aloc-trans - pqtd-aloc-trans
                   bfrat-saldo-terc.qtd-aloc-trans = IF bfrat-saldo-terc.qtd-aloc-trans < 0 THEN 0 
                                                     ELSE bfrat-saldo-terc.qtd-aloc-trans.
        OTHERWISE RETURN "NOK":U.
    END CASE.
        
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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateSaldo DBOProgram 
PROCEDURE validateSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER c-serie-docto  LIKE rat-saldo-terc.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER c-nro-docto    LIKE rat-saldo-terc.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER i-cod-emitente LIKE rat-saldo-terc.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER c-nat-operacao LIKE rat-saldo-terc.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER c-it-codigo    LIKE rat-saldo-terc.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-refer    LIKE rat-saldo-terc.cod-refer    NO-UNDO.
    DEFINE INPUT PARAMETER i-sequencia    LIKE rat-saldo-terc.sequencia    NO-UNDO.
    DEFINE INPUT PARAMETER c-lote         LIKE rat-saldo-terc.lote         NO-UNDO.
    DEFINE INPUT PARAMETER quantidade     AS DECIMAL                       NO-UNDO.

    def var c-msg-1 as char no-undo.
    
    FIND FIRST bfrat-saldo-terc NO-LOCK 
         WHERE bfrat-saldo-terc.serie-docto  = c-serie-docto 
           AND bfrat-saldo-terc.nro-docto    = c-nro-docto   
           AND bfrat-saldo-terc.cod-emitente = i-cod-emitente
           AND bfrat-saldo-terc.nat-operacao = c-nat-operacao
           AND bfrat-saldo-terc.it-codigo    = c-it-codigo   
           AND bfrat-saldo-terc.cod-refer    = c-cod-refer   
           AND bfrat-saldo-terc.sequencia    = i-sequencia   
           AND bfrat-saldo-terc.lote         = c-lote        NO-ERROR.

    IF (bfrat-saldo-terc.quantidade - bfrat-saldo-terc.qtd-aloc-trans) < quantidade THEN DO:
        {utp/ut-liter.i Quantidade}
        assign c-msg-1 = return-value.
        {utp/ut-liter.i o_saldo_dispon°vel_para_o_lote_}
        assign c-msg-1 = c-msg-1 + "~~" + return-value + bfrat-saldo-terc.lote.
        {method/svc/errors/inserr.i &ErrorNumber="34809"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=c-msg-1}
        RETURN "NOK":U.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateSaldoTerc DBOProgram 
PROCEDURE validateSaldoTerc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pserie-docto    LIKE rat-lote.serie-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto      LIKE rat-lote.nro-docto      NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao   LIKE rat-lote.nat-operacao   NO-UNDO.
    DEFINE INPUT PARAMETER psequencia      LIKE rat-lote.sequencia      NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente   LIKE rat-lote.cod-emitente   NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo      LIKE rat-lote.it-codigo      NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer      LIKE rat-lote.cod-refer      NO-UNDO.
    DEFINE INPUT PARAMETER plote           LIKE rat-lote.lote           NO-UNDO.  
    DEFINE INPUT PARAMETER pquantidade     LIKE rat-lote.quantidade     NO-UNDO.
    
    def var c-msg-1 as char no-undo.
    
    FIND FIRST bfrat-saldo-terc 
         WHERE bfrat-saldo-terc.serie-docto  = pserie-docto
           AND bfrat-saldo-terc.nro-docto    = pnro-docto
           AND bfrat-saldo-terc.nat-operacao = pnat-operacao
           AND bfrat-saldo-terc.sequencia    = psequencia
           AND bfrat-saldo-terc.cod-emitente = pcod-emitente
           AND bfrat-saldo-terc.it-codigo    = pit-codigo
           AND bfrat-saldo-terc.cod-refer    = pcod-refer
           AND bfrat-saldo-terc.lote         = plote  EXCLUSIVE-LOCK NO-ERROR.

    IF NOT AVAILABLE bfrat-saldo-terc OR (bfrat-saldo-terc.quantidade - bfrat-saldo-terc.qtd-aloc-trans) < pquantidade THEN DO:
        {utp/ut-liter.i Quantidade}
        assign c-msg-1 = return-value.
        {utp/ut-liter.i o_saldo_dispon°vel_para_o_lote_}
        assign c-msg-1 = c-msg-1 + "~~" + return-value + bfrat-saldo-terc.lote.
        {method/svc/errors/inserr.i &ErrorNumber="34809"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=c-msg-1}
        RETURN "NOK":U.
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLocalizacao DBOProgram 
PROCEDURE findLocalizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piEstab   like docum-est.cod-estabel    no-undo.
    def input param piLocaliz like item-doc-est.cod-localiz no-undo.
    def input param piDepos   like item-doc-est.cod-depos   no-undo.
    
    def var c-lb-msg as character no-undo.
  
    for first localizacao
        fields ( cod-estabel cod-localiz cod-depos )
        where localizacao.cod-estabel = piEstab
          and localizacao.cod-localiz = piLocaliz
          and localizacao.cod-depos   = piDepos  no-lock.
    end.
        
    if  not avail localizacao then do:
	
        {utp/ut-liter.i "Localizaá∆o" *}
        ASSIGN c-lb-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lb-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.  

END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNaturOper DBOFunction 
PROCEDURE findNaturOper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piNatOperacao like componente.nat-operacao no-undo.

    if  not avail natur-oper
    or  natur-oper.nat-operacao <> piNatOperacao then 
    
        for first natur-oper
            fields ( nat-operacao tp-oper-terc tipo transf denominacao 
                     terceiros char-2 dec-1 
                   &IF "{&mguni_version}" >= "2.08" &THEN idi-tip-devol-consig &ELSE char-1 &ENDIF )
            where natur-oper.nat-operacao = piNatOperacao no-lock.
        end.
        
    if  not avail natur-oper then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-natureza-de-operacao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Natureza_de_Operaá∆o" *}
        ASSIGN c-lbl-liter-natureza-de-operacao = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-natureza-de-operacao"}
        RETURN "NOK":U.
    end.
    else 
        RETURN "OK":U.        


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SugereQtdLote DBOProgram 
PROCEDURE SugereQtdLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER sequencia        LIKE saldo-terc.sequencia      NO-UNDO.
    DEFINE INPUT  PARAMETER c-item           LIKE saldo-terc.it-codigo      NO-UNDO.
    DEFINE INPUT  PARAMETER c-nro-docto      LIKE saldo-terc.nro-docto      NO-UNDO.
    DEFINE INPUT  PARAMETER qtd-retorno      LIKE rat-saldo-terc.quantidade NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM TABLE          FOR tt-rat-saldo-terc-dep.

    DEFINE VARIABLE de-qtd-total AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-soma-ret  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-qtd-aux   AS DECIMAL     NO-UNDO.

    ASSIGN de-qtd-total = 0.
    FOR EACH tt-rat-saldo-terc-dep NO-LOCK
       WHERE tt-rat-saldo-terc-dep.sequencia = sequencia
         AND tt-rat-saldo-terc-dep.it-codigo = c-item 
         AND tt-rat-saldo-terc-dep.nro-docto = c-nro-docto:
            ASSIGN tt-rat-saldo-terc-dep.qtd-digitada = tt-rat-saldo-terc-dep.quantidade
                   de-qtd-total = de-qtd-total + tt-rat-saldo-terc-dep.qtd-digitada.
    END.

    ASSIGN de-soma-ret = 0.
    FOR EACH tt-rat-saldo-terc-dep EXCLUSIVE-LOCK
       WHERE tt-rat-saldo-terc-dep.sequencia = sequencia 
         AND tt-rat-saldo-terc-dep.it-codigo = c-item 
         AND tt-rat-saldo-terc-dep.nro-docto = c-nro-docto
          BY tt-rat-saldo-terc-dep.lote:
        IF tt-rat-saldo-terc-dep.qtd-digitada > 0 THEN DO:
            ASSIGN de-soma-ret = de-soma-ret + tt-rat-saldo-terc-dep.qtd-digitada.

            IF de-soma-ret > qtd-retorno THEN DO: /*acerto de residuo*/
               ASSIGN de-qtd-aux = (de-soma-ret - qtd-retorno)
                      tt-rat-saldo-terc-dep.qtd-digitada = tt-rat-saldo-terc-dep.qtd-digitada - de-qtd-aux
                      de-soma-ret = de-soma-ret - de-qtd-aux.
            END.

            IF tt-rat-saldo-terc-dep.qtd-digitada < 0 THEN
                ASSIGN tt-rat-saldo-terc-dep.qtd-digitada = 0.
        END.
    END. /*FOR EACH tt-rat-saldo-terc-dep*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SugereQtdLote DBOProgram 
PROCEDURE ValidaLoteConversor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nat-operacao-fat  LIKE saldo-terc.nat-operacao     NO-UNDO.
    DEFINE INPUT  PARAMETER p-serie-docto       LIKE saldo-terc.serie-docto      NO-UNDO.
    DEFINE INPUT  PARAMETER p-nro-docto         LIKE saldo-terc.nro-docto        NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-emitente      LIKE saldo-terc.cod-emitente     NO-UNDO.
    DEFINE INPUT  PARAMETER p-nat-operacao-rem  LIKE saldo-terc.nat-operacao     NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-acesso      AS CHAR                          NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-acesso-ref  AS CHAR                          NO-UNDO.
    DEFINE INPUT  PARAMETER p-seq-item          LIKE saldo-terc.sequencia        NO-UNDO.
    DEFINE INPUT  PARAMETER p-qtd-alocada       LIKE saldo-terc.qt-aloca-trans   NO-UNDO.
    DEFINE INPUT  PARAMETER p-seq-item-orig     LIKE saldo-terc.sequencia        NO-UNDO.
    DEFINE OUTPUT PARAMETER p-doc-orig-nfe      AS ROWID                         NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE               FOR tt-rat-saldo-terc-dep.
    
    DEFINE VARIABLE c-cod-estabel  AS CHARACTER NO-UNDO.             
    DEFINE VARIABLE de-saldo       AS DECIMAL   NO-UNDO.

    ASSIGN de-saldo = 0.

    FOR FIRST doc-orig-nfe 
        WHERE doc-orig-nfe.ch-acesso-comp-nfe = p-chave-acesso
          AND doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:
        ASSIGN c-cod-estabel  = doc-orig-nfe.cod-estabel
               p-doc-orig-nfe = ROWID(doc-orig-nfe). 
    END.

    run getBatchRecordsOfDocumento ( INPUT  p-nat-operacao-fat,
                                     INPUT  p-serie-docto, 
                                     INPUT  p-nro-docto,   
                                     INPUT  p-cod-emitente,
                                     INPUT  p-nat-operacao-rem,
                                     INPUT  c-cod-estabel, 
                                     INPUT  100,
                                     OUTPUT TABLE tt-rat-saldo-terc-dep).

    FOR EACH tt-rat-saldo-terc-dep
       WHERE tt-rat-saldo-terc-dep.serie-docto  = p-serie-docto   
       AND   tt-rat-saldo-terc-dep.nro-docto    = p-nro-docto       
       AND   tt-rat-saldo-terc-dep.nat-operacao = p-nat-operacao-rem    
       AND   tt-rat-saldo-terc-dep.cod-emitente = p-cod-emitente
       AND   tt-rat-saldo-terc-dep.sequencia    = p-seq-item EXCLUSIVE-LOCK:
        IF CAN-FIND(rat-lote-medic-nfe 
              WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = p-chave-acesso-ref
                AND rat-lote-medic-nfe.idi-orig-trad      = 2
                AND rat-lote-medic-nfe.seq-item           = p-seq-item        
                AND rat-lote-medic-nfe.cod-lote-fabrican  = tt-rat-saldo-terc-dep.lote         
                AND rat-lote-medic-nfe.cod-depos          = tt-rat-saldo-terc-dep.cod-depos
                AND rat-lote-medic-nfe.cod-localiz        = tt-rat-saldo-terc-dep.cod-localiz  
                AND rat-lote-medic-nfe.it-codigo          = tt-rat-saldo-terc-dep.it-codigo    
                AND rat-lote-medic-nfe.cod-refer          = tt-rat-saldo-terc-dep.cod-refer
                AND SUBSTRING(rat-lote-medic-nfe.cod-livre-1,51,16) = p-nro-docto
                AND SUBSTRING(rat-lote-medic-nfe.cod-livre-1,68,4)  = string(p-seq-item-orig)) THEN DO:
            FOR EACH rat-lote-medic-nfe                                                        
               WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = p-chave-acesso-ref
                 AND rat-lote-medic-nfe.idi-orig-trad      = 2                                 
                 AND rat-lote-medic-nfe.seq-item           = p-seq-item
                 AND rat-lote-medic-nfe.cod-lote-fabrican  = tt-rat-saldo-terc-dep.lote        
                 AND rat-lote-medic-nfe.cod-depos          = tt-rat-saldo-terc-dep.cod-depos   
                 AND rat-lote-medic-nfe.cod-localiz        = tt-rat-saldo-terc-dep.cod-localiz 
                 AND rat-lote-medic-nfe.it-codigo          = tt-rat-saldo-terc-dep.it-codigo   
                 AND rat-lote-medic-nfe.cod-refer          = tt-rat-saldo-terc-dep.cod-refer NO-LOCK:
                IF SUBSTRING(rat-lote-medic-nfe.cod-livre-1,51,16) = p-nro-docto  AND
                   SUBSTRING(rat-lote-medic-nfe.cod-livre-1,68,4)  = string(p-seq-item-orig) THEN 
                    ASSIGN tt-rat-saldo-terc-dep.qtd-digitada = rat-lote-medic-nfe.qtd-lote-fabrican
                           de-saldo = de-saldo + rat-lote-medic-nfe.qtd-lote-fabrican.
                    
            END.
        END.
        ELSE DO:
            RUN SugereQtdLote ( INPUT tt-rat-saldo-terc-dep.sequencia, 
                                INPUT tt-rat-saldo-terc-dep.it-codigo, 
                                INPUT tt-rat-saldo-terc-dep.nro-docto,
                                INPUT p-qtd-alocada,                   /* Qtd que estou retornando */
                                INPUT-OUTPUT TABLE tt-rat-saldo-terc-dep).
        END.
    END.

    IF de-saldo <> 0 AND de-saldo <> p-qtd-alocada THEN DO:
       FOR EACH tt-rat-saldo-terc-dep
          WHERE tt-rat-saldo-terc-dep.serie-docto  = p-serie-docto   
          AND   tt-rat-saldo-terc-dep.nro-docto    = p-nro-docto       
          AND   tt-rat-saldo-terc-dep.nat-operacao = p-nat-operacao-rem   
          AND   tt-rat-saldo-terc-dep.cod-emitente = p-cod-emitente 
          AND   tt-rat-saldo-terc-dep.sequencia    = p-seq-item NO-LOCK:
             RUN SugereQtdLote ( INPUT tt-rat-saldo-terc-dep.sequencia, 
                                 INPUT tt-rat-saldo-terc-dep.it-codigo, 
                                 INPUT tt-rat-saldo-terc-dep.nro-docto,
                                 INPUT p-qtd-alocada,         /* Qtd que estou retornando */
                                 INPUT-OUTPUT TABLE tt-rat-saldo-terc-dep).
        END.
    END.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

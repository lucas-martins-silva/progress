&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
/* Connected Databases 
          movfro           PROGRESS
*/

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-abastec-lubrific NO-UNDO LIKE mab-abastec-lubrific
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-mab-item-abastec NO-UNDO LIKE mab-item-abastec
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-mab-item-lubrific NO-UNDO LIKE mab-item-lubrific
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0804C 2.00.00.018 } /*** 010018 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0804c MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: AB0804C.p
**
**       DATA....: Abril 2004
**
**       AUTor...: DATASUL S.A.
**
**       OBJETIVO: Manuten‡Æo Tabela Abastecimento/Lubrifica‡Æo
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */

/** Parƒmetros **/
define input  parameter pc-serie        as character no-undo.
define input  parameter pc-nota         as character no-undo.
define input  parameter pi-emitente     as integer   no-undo.
define input  parameter pc-natureza     as character no-undo.
define input  parameter pi-sequencia    as integer   no-undo.
define input  parameter pi-acao         as integer   no-undo.

/** Vari veis Handles **/
define variable h-ficha    as handle no-undo.
define variable h-abastec  as handle no-undo.
define variable h-lubrific as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
   Temp-Tables and Buffers:
      TABLE: tt-mab-abastec-lubrific T "?" NO-UNDO movfro mab-abastec-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-mab-item-abastec T "?" NO-UNDO movfro mab-item-abastec
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-mab-item-lubrific T "?" NO-UNDO movfro mab-item-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.38
         WIDTH              = 26.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{abp/ab9001.i}         /** piConverteMoeda  **/
/** Inicializa o programa **/
run pi-inicial in this-procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-altera) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera Procedure 
PROCEDURE pi-altera :
/*------------------------------------------------------------------------------
  Purpose:     pi-altera
  Parameters:  <none>
  Notes:       Altera‡Æo das Tabelas
------------------------------------------------------------------------------*/
for first item-doc-est
    where item-doc-est.serie-docto  = pc-serie
    and   item-doc-est.nro-docto    = pc-nota
    and   item-doc-est.cod-emitente = pi-emitente
    and   item-doc-est.nat-operacao = pc-natureza
    and   item-doc-est.sequencia    = pi-sequencia no-lock:
    /**************************************************
    **                 ABASTECIMENTO                 **
    **************************************************/
    if can-find(first mab-item-abastec
                where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock) then do:
        for first mab-item-abastec
            where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock:
            /** Limpa Temp-Table **/
            empty temp-table tt-mab-item-abastec.
            /** Cria temp-table de comunica‡Æo **/
            create tt-mab-item-abastec.
            buffer-copy mab-item-abastec to tt-mab-item-abastec
            assign tt-mab-item-abastec.r-rowid               = rowid(mab-item-abastec)
                   tt-mab-item-abastec.val-mater-1           = item-doc-est.preco-total[1]
                   tt-mab-item-abastec.val-quant             = item-doc-est.quantidade.

            FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
                IF mab-param.des-valor = "1":U THEN DO:
                    ASSIGN tt-mab-item-abastec.cod-cta-ctbl          = item-doc-est.ct-codigo
                           tt-mab-item-abastec.cod-ccusto            = item-doc-est.sc-codigo.
                END.
            END.

            /** Busca Valores para Moedas Alternativas **/
            run piConverteMoeda in this-procedure (input  tt-mab-item-abastec.val-mater-1,
                                                   output tt-mab-item-abastec.val-mater-2,
                                                   output tt-mab-item-abastec.val-mater-3,
                                                   input  mab-abastec-lubrific.dat-movto).        
            /*--- Limpa temp-table RowErrors no DBO ---*/
            RUN emptyRowErrors IN h-abastec.
            /*-- Posiciona registro a ser alterado na DBO --*/
            run repositionRecord in h-abastec (input tt-mab-item-abastec.r-rowid).
            /*--- Transfere temp-table ttTarefa para o DBO ---*/
            RUN setRecord IN h-abastec (INPUT TABLE tt-mab-item-abastec).
            /*--- Altera registro ---*/
            RUN updateRecord IN h-abastec.
        end.
    end.
    /**************************************************
    **                 LUBRIFICA€ÇO                  **
    **************************************************/
    else do:
        if can-find(first mab-item-lubrific
                    where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto no-lock) then do:
            for each  mab-item-lubrific
                where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto no-lock:
                /** Limpa Temp-Table **/
                empty temp-table tt-mab-item-lubrific.
                /** Cria temp-table de comunica‡Æo **/
                create tt-mab-item-lubrific.
                buffer-copy mab-item-lubrific to tt-mab-item-lubrific
                    assign tt-mab-item-lubrific.r-rowid                  = rowid(mab-item-lubrific)
                           tt-mab-item-lubrific.val-mater-1              = item-doc-est.preco-total[1]
                           tt-mab-item-lubrific.val-quant                = item-doc-est.quantidade.


                FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
                    IF mab-param.des-valor = "1":U THEN DO:
                        ASSIGN tt-mab-item-lubrific.cod-cta-ctbl             = item-doc-est.ct-codigo
                               tt-mab-item-lubrific.cod-ccusto               = item-doc-est.sc-codigo.
                    END.
                END.

                /** Busca Valores para Moedas Alternativas **/
                run piConverteMoeda in this-procedure (input  tt-mab-item-lubrific.val-mater-1,
                                                       output tt-mab-item-lubrific.val-mater-2,
                                                       output tt-mab-item-lubrific.val-mater-3,
                                                       input  mab-abastec-lubrific.dat-movto). 
            
                /*--- Limpa temp-table RowErrors no DBO ---*/
                RUN emptyRowErrors IN h-lubrific.
                /*-- Posiciona registro a ser alterado na DBO --*/
                run repositionRecord in h-lubrific (input tt-mab-item-lubrific.r-rowid).
                /*--- Transfere temp-table ttTarefa para o DBO ---*/
                RUN setRecord IN h-lubrific (INPUT TABLE tt-mab-item-lubrific).
                /*--- Altera registro ---*/
                RUN updateRecord IN h-lubrific.
            end.
        end.
    end.
    /**************************************************
    **                     FICHA                     **
    **************************************************/
    /** Limpa Temp-Table **/
    empty temp-table tt-mab-abastec-lubrific.
    /** Cria temp-table de comunica‡Æo **/
    create tt-mab-abastec-lubrific.
    buffer-copy mab-abastec-lubrific to tt-mab-abastec-lubrific
        assign tt-mab-abastec-lubrific.r-rowid               = rowid(mab-abastec-lubrific)
               tt-mab-abastec-lubrific.ct-codigo             = item-doc-est.ct-codigo
               tt-mab-abastec-lubrific.cc-codigo             = item-doc-est.sc-codigo.

    /*  quando o parametro 55 estiver como sim, as informa‡äes de contas da ficha manter  a mesma a informada na hora da cria‡Æo da ficha de abastecimento.
        A conta informada no recebimento ser  a nivel de item, que ‚ alterada nas linhas acima. */
    FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
        IF  mab-param.des-valor = "1":U THEN DO:
            ASSIGN tt-mab-abastec-lubrific.ct-codigo             = mab-abastec-lubrific.ct-codigo
                   tt-mab-abastec-lubrific.cc-codigo             = mab-abastec-lubrific.cc-codigo
                   tt-mab-abastec-lubrific.cod-cta-ctbl-lubrific = mab-abastec-lubrific.cod-cta-ctbl-lubrific
                   tt-mab-abastec-lubrific.cod-ccusto-lubrific   = mab-abastec-lubrific.cod-ccusto-lubrific.
        END.
    END.

    /*--- Limpa temp-table RowErrors no DBO ---*/
    RUN emptyRowErrors IN h-ficha.
    /*-- Posiciona registro a ser alterado na DBO --*/
    run repositionRecord in h-ficha (input tt-mab-abastec-lubrific.r-rowid).
    /*--- Transfere temp-table ttTarefa para o DBO ---*/
    RUN setRecord IN h-ficha (INPUT TABLE tt-mab-abastec-lubrific).
    /*--- Altera registro ---*/
    RUN updateRecord IN h-ficha.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-elimina) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina Procedure 
PROCEDURE pi-elimina :
/*------------------------------------------------------------------------------
  Purpose:     pi-elimina
  Parameters:  <none>
  Notes:       Elimina‡Æo das Tabelas
------------------------------------------------------------------------------*/
/**************************************************
**                 ABASTECIMENTO                 **
**************************************************/
if can-find(first mab-item-abastec
            where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock) then do:
    for each  mab-item-abastec
        where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock:
        /** Limpa Temp-Table **/
        empty temp-table tt-mab-item-abastec.
        /** Cria temp-table de comunica‡Æo **/
        create tt-mab-item-abastec.
        buffer-copy mab-item-abastec to tt-mab-item-abastec
            assign tt-mab-item-abastec.r-rowid = rowid(mab-item-abastec).
    
        /*--- Limpa temp-table RowErrors no DBO ---*/
        RUN emptyRowErrors IN h-abastec.
        /** Posiciona no Registro que deve ser eliminado **/
        run repositionRecord in h-abastec (input rowid(mab-item-abastec)).
        /*--- Transfere temp-table ttTarefa para o DBO ---*/
        RUN setRecord IN h-abastec (INPUT TABLE tt-mab-item-abastec).
        /*--- Cria um novo registro ---*/
        RUN deleteRecord IN h-abastec.
    end.
end.
/**************************************************
**                 LUBRIFICA€ÇO                  **
**************************************************/

else do:
    if can-find(first mab-item-lubrific
                where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto no-lock) then do:
        for each  mab-item-lubrific
            where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto no-lock:
            /** Limpa Temp-Table **/
            empty temp-table tt-mab-item-lubrific.
            /** Cria temp-table de comunica‡Æo **/
            create tt-mab-item-lubrific.
            buffer-copy mab-item-lubrific to tt-mab-item-lubrific
                assign tt-mab-item-lubrific.r-rowid = rowid(mab-item-lubrific).
        
            /*--- Limpa temp-table RowErrors no DBO ---*/
            RUN emptyRowErrors IN h-lubrific.
            /** Posiciona no Registro que deve ser eliminado **/
            run repositionRecord in h-lubrific (input rowid(mab-item-lubrific)).
            /*--- Transfere temp-table ttTarefa para o DBO ---*/
            RUN setRecord IN h-lubrific (INPUT TABLE tt-mab-item-lubrific).
            /*--- Cria um novo registro ---*/
            RUN deleteRecord IN h-lubrific.
        end.
    end.
end.
/**************************************************
**                     FICHA                     **
**************************************************/
/** Limpa Temp-Table **/
empty temp-table tt-mab-abastec-lubrific.
/** Cria temp-table de comunica‡Æo **/
create tt-mab-abastec-lubrific.
buffer-copy mab-abastec-lubrific to tt-mab-abastec-lubrific
    assign tt-mab-abastec-lubrific.r-rowid = rowid(mab-abastec-lubrific).

/*--- Limpa temp-table RowErrors no DBO ---*/
RUN emptyRowErrors IN h-ficha.
/** Posiciona no Registro que deve ser eliminado **/
run repositionRecord in h-ficha (input rowid(mab-abastec-lubrific)).
/*--- Transfere temp-table ttTarefa para o DBO ---*/
RUN setRecord IN h-ficha (INPUT TABLE tt-mab-abastec-lubrific).
/*--- Cria um novo registro ---*/
RUN deleteRecord IN h-ficha.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-handle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-handle Procedure 
PROCEDURE pi-handle :
/*------------------------------------------------------------------------------
  Purpose:     pi-handle
  Parameters:  entrada pAction = (1 = Inicia / 2 = Finaliza)
  Notes:       Manuten‡Æo dos handles
------------------------------------------------------------------------------*/
define input parameter pAction as integer no-undo.

case pAction:
   /** Inicializa **/
    when 1 then do:
        /*:T--- BO de Ficha Abatestecimento ---*/
        IF NOT VALID-HANDLE(h-ficha) OR
           h-ficha:TYPE <> "PROCEDURE":U OR
           h-ficha:FILE-NAME <> "frbo~\bofr055.p":U THEN DO:
            run frbo/bofr055.p persistent set h-ficha.
        END.
        
        RUN openQueryStatic IN h-ficha (INPUT "Main":U) NO-ERROR.
        
        /*:T--- BO de Ficha Abatestecimento ---*/
        IF NOT VALID-HANDLE(h-abastec) OR
           h-abastec:TYPE <> "PROCEDURE":U OR
           h-abastec:FILE-NAME <> "frbo~\bofr057.p":U THEN DO:
            run frbo/bofr057.p persistent set h-abastec.
        END.
        
        RUN openQueryStatic IN h-abastec (INPUT "Main":U) NO-ERROR.
        
        /*:T--- BO de Ficha Abatestecimento ---*/
        IF NOT VALID-HANDLE(h-lubrific) OR
           h-lubrific:TYPE <> "PROCEDURE":U OR
           h-lubrific:FILE-NAME <> "frbo~\bofr058.p":U THEN DO:
            run frbo/bofr058.p persistent set h-lubrific.
        END.
        
        RUN openQueryStatic IN h-lubrific (INPUT "Main":U) NO-ERROR.
    end.
    /** Finaliza **/
    when 2 then do:
        if valid-handle(h-ficha) then
            run Destroy in h-ficha.
        if valid-handle(h-abastec) then
            run Destroy in h-abastec.
        if valid-handle(h-lubrific) then
            run Destroy in h-lubrific.
    end.
end case.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-inicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicial Procedure 
PROCEDURE pi-inicial :
/*------------------------------------------------------------------------------
  Purpose:     pi-inicial
  Parameters:  <none>
  Notes:       Inicializa‡äa do programa 
------------------------------------------------------------------------------*/
/** Busca a Ficha referente ao Documento Manutenido **/
if can-find(first mab-abastec-lubrific
            where mab-abastec-lubrific.serie        = pc-serie
            and   mab-abastec-lubrific.nr-nota-fis  = pc-nota
            and   mab-abastec-lubrific.cod-emitente = pi-emitente
            and   mab-abastec-lubrific.nat-operacao = pc-natureza
            and   mab-abastec-lubrific.sequencia    = pi-sequencia no-lock) then do:
    for first mab-abastec-lubrific
        where mab-abastec-lubrific.serie        = pc-serie
        and   mab-abastec-lubrific.nr-nota-fis  = pc-nota
        and   mab-abastec-lubrific.cod-emitente = pi-emitente
        and   mab-abastec-lubrific.nat-operacao = pc-natureza
        and   mab-abastec-lubrific.sequencia    = pi-sequencia no-lock:
        /** Inicia Handles **/
        run pi-handle in this-procedure (input 1).
        /** Verifica qual a‡Æo fazer **/
        case pi-acao:
            /** InclusÆo **/
            when 1 then do:
                /** NÆo necess ria l¢gica (at‚ presente momento) **/
            end.
            /** Altera‡Æo **/
            when 2 then do:
                run pi-altera in this-procedure.
            end.
            /** Elimina‡Æo **/
            when 3 then do:
                run pi-elimina in this-procedure.
            end.
        end case.
        /** Finaliza Handles **/
        run pi-handle in this-procedure (input 2).
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


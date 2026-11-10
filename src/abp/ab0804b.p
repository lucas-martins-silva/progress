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
{include/i-prgvrs.i AB0804B 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0804b MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: AB0804B.p
**
**       DATA....: Abril 2004
**
**       AUTor...: DATASUL S.A.
**
**       OBJETIVO: Elimina‡Æo da Ficha de Abastecimento / Lubrifica‡Æo
**
*****************************************************************************/

/* ***************************  Definitions  ************************** */

define input parameter pr-rowid as rowid no-undo.

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
         WIDTH              = 32.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

run pi-inicial in this-procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-elimina-abastecimento) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-abastecimento Procedure 
PROCEDURE pi-elimina-abastecimento :
/*------------------------------------------------------------------------------
  Purpose:     pi-elimina-abastecimento
  Parameters:  <none>
  Notes:       Percorre os abastecimentos e elimina-os
------------------------------------------------------------------------------*/
define variable h-abastec as handle no-undo.

/*:T--- BO de Ficha Abatestecimento ---*/
IF NOT VALID-HANDLE(h-abastec) OR
   h-abastec:TYPE <> "PROCEDURE":U OR
   h-abastec:FILE-NAME <> "frbo~\bofr057.p":U THEN DO:
    run frbo/bofr057.p persistent set h-abastec.
END.

RUN openQueryStatic IN h-abastec (INPUT "Main":U) NO-ERROR.

/** Busca Abastecimentos **/
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
    /*--- Transfere temp-table ttTarefa para o DBO ---*/
    RUN setRecord IN h-abastec (INPUT TABLE tt-mab-item-abastec).
    /** Posiciona no Registro que deve ser eliminado **/
    run repositionRecord in h-abastec (input rowid(mab-item-abastec)).
    /*--- Cria um novo registro ---*/
    RUN deleteRecord IN h-abastec.
end.

/** Elimina handle da BO **/
if valid-handle(h-abastec) then
    run Destroy in h-abastec.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-elimina-ficha) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-ficha Procedure 
PROCEDURE pi-elimina-ficha :
/*------------------------------------------------------------------------------
  Purpose:     pi-elimina-ficha
  Parameters:  <none>
  Notes:       Elimina a ficha de Abastecimento/Lubrifica‡Æo
------------------------------------------------------------------------------*/
define variable h-ficha as handle no-undo.

/*:T--- BO de Ficha Abatestecimento ---*/
IF NOT VALID-HANDLE(h-ficha) OR
   h-ficha:TYPE <> "PROCEDURE":U OR
   h-ficha:FILE-NAME <> "frbo~\bofr055.p":U THEN DO:
    run frbo/bofr055.p persistent set h-ficha.
END.

RUN openQueryStatic IN h-ficha (INPUT "Main":U) NO-ERROR.

/** Limpa Temp-Table **/
empty temp-table tt-mab-abastec-lubrific.
/** Cria temp-table de comunica‡Æo **/
create tt-mab-abastec-lubrific.
buffer-copy mab-abastec-lubrific to tt-mab-abastec-lubrific
    assign tt-mab-abastec-lubrific.r-rowid = rowid(mab-abastec-lubrific).

/*--- Limpa temp-table RowErrors no DBO ---*/
RUN emptyRowErrors IN h-ficha.
/*--- Transfere temp-table ttTarefa para o DBO ---*/
RUN setRecord IN h-ficha (INPUT TABLE tt-mab-abastec-lubrific).
/** Posiciona no Registro que deve ser eliminado **/
run repositionRecord in h-ficha (input rowid(mab-abastec-lubrific)).
/*--- Cria um novo registro ---*/
RUN deleteRecord IN h-ficha.

/** Elimina handle da BO **/
if valid-handle(h-ficha) then
    run Destroy in h-ficha.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-elimina-lubrificacao) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-lubrificacao Procedure 
PROCEDURE pi-elimina-lubrificacao :
/*------------------------------------------------------------------------------
  Purpose:     pi-elimina-lubrificacao
  Parameters:  <none>
  Notes:       Percorre as lubrifica‡äes e elimina-as
------------------------------------------------------------------------------*/
define variable h-lubrific as handle no-undo.

/*:T--- BO de Ficha Abatestecimento ---*/
IF NOT VALID-HANDLE(h-lubrific) OR
   h-lubrific:TYPE <> "PROCEDURE":U OR
   h-lubrific:FILE-NAME <> "frbo~\bofr058.p":U THEN DO:
    run frbo/bofr058.p persistent set h-lubrific.
END.

RUN openQueryStatic IN h-lubrific (INPUT "Main":U) NO-ERROR.

/** Busca Abastecimentos **/
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
    /*--- Transfere temp-table ttTarefa para o DBO ---*/
    RUN setRecord IN h-lubrific (INPUT TABLE tt-mab-item-lubrific).
    /** Posiciona no Registro que deve ser eliminado **/
    run repositionRecord in h-lubrific (input rowid(mab-item-lubrific)).
    /*--- Cria um novo registro ---*/
    RUN deleteRecord IN h-lubrific.
end.

/** Elimina handle da BO **/
if valid-handle(h-lubrific) then
    run Destroy in h-lubrific.

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
  Notes:       Inicial a elimina‡Æo da ficha de abastecimento e lubrifica‡Æo
------------------------------------------------------------------------------*/
/** Limpa temp-table da Ficha de Abastecimento/Lubrifica‡Æo **/
empty temp-table tt-mab-abastec-lubrific.

/** Busca registro pai que ser  eliminado **/
for first mab-abastec-lubrific
    where rowid(mab-abastec-lubrific) = pr-rowid no-lock:
    /** Cria temp-table de comunica‡Æo **/
    create tt-mab-abastec-lubrific.
    buffer-copy mab-abastec-lubrific to tt-mab-abastec-lubrific
        assign tt-mab-abastec-lubrific.r-rowid = rowid(mab-abastec-lubrific).
    /** Elimina os Abastecimentos **/
    if can-find(first mab-item-abastec 
                where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock) then do:
        run pi-elimina-abastecimento in this-procedure.
    end.
    /** Elimina as Lubrifica‡äes **/
    if can-find(first mab-item-lubrific 
                where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto no-lock) then do:
        run pi-elimina-lubrificacao in this-procedure.
    end.

    /** Elimina Registro Pai **/
    run pi-elimina-ficha in this-procedure.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


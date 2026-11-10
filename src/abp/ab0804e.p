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
DEFINE TEMP-TABLE tt-mmv-movto-mater NO-UNDO LIKE mmv-movto-mater
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
{include/i-prgvrs.i AB0804E 2.00.00.022 } /*** "010022" 22/07/2024 10:40:31  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0804e MAB}
&ENDIF


/*****************************************************************************
**
**       PROGRAMA: AB0804E.p
**
**       DATA....: Abril 2004
**
**       AUTor...: DATASUL S.A.
**
**       OBJETIVO: Manutená∆o Tabela Abastecimento/Lubrificaá∆o
**
*****************************************************************************/
{cdp/cdcfgmnt.i}

/* ***************************  Definitions  ************************** */
/** Temp-Table de erros **/
{abp/abapi001.i1}

/** ParÉmetros **/
define input  parameter pc-serie        as character no-undo.
define input  parameter pc-nota         as character no-undo.
define input  parameter pi-emitente     as integer   no-undo.
define input  parameter pc-natureza     as character no-undo.
define input  parameter pi-sequencia    as integer   no-undo.
define input  parameter pi-acao         as integer   no-undo.
define output parameter table for RowErrors.

/** Vari†veis Handles **/
define variable h-ficha    as handle no-undo.
define variable h-abastec  as handle no-undo.
define variable h-lubrific as handle no-undo.
define variable h-material as handle no-undo.

/** Vari†veis Globais **/
define new global shared variable dt-movimento    as date      format "99/99/9999":U     no-undo.
define new global shared variable c-hr-inicial    as character format "99:99":U          no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
define new global shared variable i-ep-codigo     LIKE empresa.ep-codigo   format "x(03)":U            no-undo.
&ELSE
define new global shared variable i-ep-codigo     as integer   format ">>9":U            no-undo.
&ENDIF
define new global shared variable c-cod-eqpto     as character format "x(16)":U          no-undo.
define new global shared variable de-contador     as decimal   format ">,>>>,>>9.9":U no-undo.
define new global shared variable de-contador-sec as decimal   format ">,>>>,>>9.9":U no-undo.
define new global shared variable c-posto         as character format "x(8)":U           no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
define new global shared variable i-empresa-matr  LIKE empresa.ep-codigo   format "x(03)"              NO-UNDO.
&ELSE
define new global shared variable i-empresa-matr  AS INTEGER   FORMAT ">>9"              NO-UNDO.
&ENDIF
&IF "{&mguni_version}" >= "2.071" &THEN
define new global shared variable c-estabel-matr  AS CHARACTER format "x(05)"            NO-UNDO.
&ELSE
define new global shared variable c-estabel-matr  AS CHARACTER FORMAT "x(03)"            NO-UNDO.
&ENDIF
define new global shared variable c-cod-matr      as character format "x(10)":U          no-undo.
define new global shared variable c-cod-evento    as character format "x(8)":U           no-undo.
define new global shared variable c-cod-compart   as character format "x(8)":U           no-undo.
define new global shared variable c-cod-rota      as character format "x(12)":U          no-undo.
define new global shared variable c-cod-ativid    as character format "x(8)":U           no-undo.
define new global shared variable i-tipo          as integer                             no-undo.

/** Usu†rio Logado **/
{utp/ut-glob.i}

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
      TABLE: tt-mmv-movto-mater T "?" NO-UNDO movfro mmv-movto-mater
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
         HEIGHT             = 8.88
         WIDTH              = 27.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{abp/ab9000.i}         /** converteParaHoraInvertida  **/
{abp/ab9001.i}         /** piConverteMoeda            **/
{abp/abapi001.i2}      /** piCriaErro                 **/
 
/** Inicializa o programa **/
run pi-inicial in this-procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-pi-altera-ficha) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-ficha Procedure 
PROCEDURE pi-altera-ficha :
/*------------------------------------------------------------------------------
  Purpose:     pi-altera-ficha
  Parameters:  <none>
  Notes:       Alteraá∆o das Tabelas
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
            /** Cria temp-table de comunicaá∆o **/
            create tt-mab-item-abastec.
            buffer-copy mab-item-abastec to tt-mab-item-abastec
                assign tt-mab-item-abastec.r-rowid               = rowid(mab-item-abastec)
                       tt-mab-item-abastec.val-mater-1           = item-doc-est.preco-total[1] - item-doc-est.desconto[1]
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
    **                 LUBRIFICAÄ«O                  **
    **************************************************/
    else do:
        if can-find(first mab-item-lubrific
                    where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto no-lock) then do:
            for each  mab-item-lubrific
                where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto no-lock:
                /** Limpa Temp-Table **/
                empty temp-table tt-mab-item-lubrific.
                /** Cria temp-table de comunicaá∆o **/
                create tt-mab-item-lubrific.
                buffer-copy mab-item-lubrific to tt-mab-item-lubrific
                    assign tt-mab-item-lubrific.r-rowid               = rowid(mab-item-lubrific)
                           tt-mab-item-lubrific.val-mater-1           = item-doc-est.preco-total[1] - item-doc-est.desconto[1]
                           tt-mab-item-lubrific.val-quant             = item-doc-est.quantidade.

                FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
                    IF mab-param.des-valor = "1":U THEN DO:
                        ASSIGN tt-mab-item-lubrific.cod-cta-ctbl          = item-doc-est.ct-codigo
                               tt-mab-item-lubrific.cod-ccusto            = item-doc-est.sc-codigo.
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
    /** Cria temp-table de comunicaá∆o **/
    create tt-mab-abastec-lubrific.
    buffer-copy mab-abastec-lubrific to tt-mab-abastec-lubrific
        assign tt-mab-abastec-lubrific.r-rowid      = rowid(mab-abastec-lubrific)
               tt-mab-abastec-lubrific.ct-codigo    = item-doc-est.ct-codigo
               tt-mab-abastec-lubrific.cc-codigo    = item-doc-est.sc-codigo.

    /*  quando o parametro 55 estiver como sim, as informaá‰es de contas da ficha manter† a mesma a informada na hora da criaá∆o da ficha de abastecimento.
        A conta informada no recebimento ser† a nivel de item, que Ç alterada nas linhas acima. */
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

&IF DEFINED(EXCLUDE-pi-altera-material) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-material Procedure 
PROCEDURE pi-altera-material :
/*------------------------------------------------------------------------------
  Purpose:     pi-altera-material
  Parameters:  <none>
  Notes:       Altera movimento de material
------------------------------------------------------------------------------*/
for first item-doc-est
    where item-doc-est.serie-docto  = pc-serie
    and   item-doc-est.nro-docto    = pc-nota
    and   item-doc-est.cod-emitente = pi-emitente
    and   item-doc-est.nat-operacao = pc-natureza
    and   item-doc-est.sequencia    = pi-sequencia no-lock:
    /** Limpa Temp-Table **/
    empty temp-table tt-mmv-movto-mater.
    /** Cria temp-table de comunicaá∆o **/
    create tt-mmv-movto-mater.
    buffer-copy mmv-movto-mater to tt-mmv-movto-mater
        assign tt-mmv-movto-mater.r-rowid     = rowid(mmv-movto-mater)
               tt-mmv-movto-mater.dsl-obs     = item-doc-est.narrativa
               tt-mmv-movto-mater.qtd-item    = item-doc-est.quantidade
               tt-mmv-movto-mater.val-mater-1 = item-doc-est.preco-total[1] - item-doc-est.desconto[1].
    /** Busca Valores para Moedas Alternativas **/
    run piConverteMoeda in this-procedure (input  tt-mmv-movto-mater.val-mater-1,
                                           output tt-mmv-movto-mater.val-mater-2,
                                           output tt-mmv-movto-mater.val-mater-3,
                                           input  tt-mmv-movto-mater.dat-movto).
    /*--- Limpa temp-table RowErrors no DBO ---*/
    RUN emptyRowErrors IN h-material.
    /*-- Posiciona registro a ser alterado na DBO --*/
    run repositionRecord in h-material (input tt-mmv-movto-mater.r-rowid).
    /*--- Transfere temp-table ttTarefa para o DBO ---*/
    RUN setRecord IN h-material (INPUT TABLE tt-mmv-movto-mater).
    /*--- Altera registro ---*/
    RUN updateRecord IN h-material.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-cria-ficha) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-ficha Procedure 
PROCEDURE pi-cria-ficha :
/*------------------------------------------------------------------------------
  Purpose:     pi-cria-ficha
  Parameters:  <none>
  Notes:       Cria a ficha de Abastecimento / Lubrificaá∆o
------------------------------------------------------------------------------*/
define buffer bfParam for mab-param.
define buffer bfApont for mab-abastec-lubrific.
DEFINE BUFFER bfEqpto FOR mab-eqpto.
DEFINE VARIABLE dValDatHora AS DECIMAL.
DEFINE VARIABLE cHistEstab LIKE mab-eqpto.cod-estabel NO-UNDO.

DEFINE VARIABLE cConta     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSub       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cContLub   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCCustoLub AS CHARACTER NO-UNDO.

/** Limpa Temp-Table **/
empty temp-table tt-mab-abastec-lubrific.
/** Cria temp-table de comunicaá∆o **/
create tt-mab-abastec-lubrific.
/** Busca a numeraá∆o do Apontamento **/
run buscaDocumento in h-ficha (output tt-mab-abastec-lubrific.num-docto).
/** Busca Atividade e Conta Cont†bil do Hist¢rico Atividade Equipamento **/    
run buscaAtividade in h-ficha (input  i-ep-codigo,
                               input  c-cod-eqpto,
                               input  dt-movimento,
                               output tt-mab-abastec-lubrific.cod-ativid,
                               output cConta,
                               output cSub,
                           &IF DEFINED(bf_mnt_ems206b) &THEN
                               output tt-mab-abastec-lubrific.cod-unid-negoc,
                           &ELSE
                               output tt-mab-abastec-lubrific.cod_unid_negoc,
                           &ENDIF
                               OUTPUT cContLub,
                               OUTPUT cCCustoLub,
                               OUTPUT cHistEstab).

assign /** Dados Globais **/
       tt-mab-abastec-lubrific.ep-codigo           = i-ep-codigo
       tt-mab-abastec-lubrific.cod-eqpto           = c-cod-eqpto
       tt-mab-abastec-lubrific.val-hodom-horim     = de-contador
       tt-mab-abastec-lubrific.val-hodom-horim-sec = de-contador-sec
       tt-mab-abastec-lubrific.dat-movto           = dt-movimento
       tt-mab-abastec-lubrific.hra-inicial         = c-hr-inicial
       tt-mab-abastec-lubrific.hra-final           = c-hr-inicial
       tt-mab-abastec-lubrific.cod-posto           = c-posto
       tt-mab-abastec-lubrific.cod-usuar           = c-seg-usuario
       tt-mab-abastec-lubrific.cod-ativid          = c-cod-ativid
       /** Dados da Nota Fiscal **/
       tt-mab-abastec-lubrific.serie               = pc-serie
       tt-mab-abastec-lubrific.sequencia           = pi-sequencia
       tt-mab-abastec-lubrific.nr-nota-fis         = pc-nota
       tt-mab-abastec-lubrific.nat-operacao        = pc-natureza
       tt-mab-abastec-lubrific.cod-emitente        = pi-emitente
       tt-mab-abastec-lubrific.ct-codigo           = item-doc-est.ct-codigo
       tt-mab-abastec-lubrific.cc-codigo           = item-doc-est.sc-codigo
       /** Dados Iniciais **/
       tt-mab-abastec-lubrific.log-consist         = no
       tt-mab-abastec-lubrific.idi-integr          = 2
       tt-mab-abastec-lubrific.idi-consist         = 1
       tt-mab-abastec-lubrific.r-rowid             = ?.

/*  quando o parametro 55 estiver como sim, as informaá‰es de contas da ficha ser† igual a do historico de estabelecimento do equipamento.
    A conta informada no recebimento ser† a nivel de item, que Ç gravado na procedure pi-inclui deste programa */
FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
    IF mab-param.des-valor = "1":U THEN DO:
        ASSIGN tt-mab-abastec-lubrific.ct-codigo             = cConta
               tt-mab-abastec-lubrific.cc-codigo             = cSub
               tt-mab-abastec-lubrific.cod-cta-ctbl-lubrific = cContLub
               tt-mab-abastec-lubrific.cod-ccusto-lubrific   = cCCustoLub.
    END.
END.


for each  mab-param fields(des-valor cdn-param)
    where mab-param.cdn-param = 7
    or    mab-param.cdn-param = 9 no-lock:
    case mab-param.cdn-param:
        /** Motorista **/
        when 7 then do:
            if mab-param.des-valor = "1":U then do:
                assign tt-mab-abastec-lubrific.ep-codigo-matr   = i-empresa-matr
                       tt-mab-abastec-lubrific.cod-estabel-matr = c-estabel-matr
                       tt-mab-abastec-lubrific.cod-matr         = c-cod-matr.
            end.
            else do:
                assign &IF "{&mguni_version}" >= "2.071" &THEN
                           tt-mab-abastec-lubrific.ep-codigo-matr   = ""
                       &ELSE
                           tt-mab-abastec-lubrific.ep-codigo-matr   = 0
                       &ENDIF
                       tt-mab-abastec-lubrific.cod-estabel-matr = "":U
                       tt-mab-abastec-lubrific.cod-matr         = "":U.
            end.
        end.
        /** Trajeto **/
        when 9 then do:
            if mab-param.des-valor = "1":U then do:
                assign tt-mab-abastec-lubrific.cod-rota = c-cod-rota.
            end.
            else do:
                assign tt-mab-abastec-lubrific.cod-rota = "":U.
            end.
        end.
    end case.
end.

/*--- Limpa temp-table RowErrors no DBO ---*/
RUN emptyRowErrors IN h-ficha.
/*--- Transfere temp-table ttTarefa para o DBO ---*/
RUN setRecord IN h-ficha (INPUT TABLE tt-mab-abastec-lubrific).
/*--- Cria registro ---*/
RUN createRecord IN h-ficha.
if return-value = "NOK":U then do:
    run getRowErrors in h-ficha (output table RowErrors).
    return "NOK":U.
end.

ELSE DO:
    /** Atualiza o campo hora invertida. Ser† gravado no 
    formato "AAAAMMDDHHMM" (Ano+Màs+Dia+Hora+Minuto) **/
    run converteParaHoraInvertida  (input  string(dt-movimento,"99/99/9999"),
                                    input  c-hr-inicial,
                                    output dValDatHora).

    /* Verifica se contador informado Ç maior que contador anterior */
    for last  bfApont fields(val-hodom-horim ep-codigo cod-eqpto)
        where bfApont.ep-codigo            =  i-ep-codigo
        and   bfApont.cod-eqpto            =  c-cod-eqpto        
        and   bfApont.val-dat-hora-invrtda <  dValDatHora NO-LOCK:
        IF bfApont.val-hodom-horim > de-contador AND de-contador <> 0 THEN DO:
            run piCriaErro (5545, 'EMS':U, '').
        END.
        FIND FIRST bfEqpto
             WHERE bfEqpto.ep-codigo = bfApont.ep-codigo
               AND bfEqpto.cod-eqpto = bfApont.cod-eqpto NO-LOCK NO-ERROR.
        IF  AVAIL bfEqpto AND bfEqpto.log-cont-sec THEN DO:
            IF  bfApont.val-hodom-horim-sec > de-contador-sec AND de-contador-sec <> 0 THEN DO:
                RUN piCriaErro (5545, 'EMS':U, '').
            END.
        END.
    END.

END.
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
  Notes:       Eliminaá∆o das Tabelas
------------------------------------------------------------------------------*/
/**************************************************
**                 ABASTECIMENTO                 **
**************************************************/
if can-find(first mab-item-abastec
            where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock) then do:
    for each  mab-item-abastec
        where mab-item-abastec.num-docto = mab-abastec-lubrific.num-docto no-lock:
        /*--- Limpa temp-table RowErrors no DBO ---*/
        RUN emptyRowErrors IN h-abastec.
        /** Posiciona no Registro que deve ser eliminado **/
        run repositionRecord in h-abastec (input rowid(mab-item-abastec)).
        /*--- Cria um novo registro ---*/
        RUN deleteRecord IN h-abastec.
    end.
end.
/**************************************************
**                 LUBRIFICAÄ«O                  **
**************************************************/
else do:
    if can-find(first mab-item-lubrific
                where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto no-lock) then do:
        for each  mab-item-lubrific
            where mab-item-lubrific.num-docto = mab-abastec-lubrific.num-docto no-lock:
            /*--- Limpa temp-table RowErrors no DBO ---*/
            RUN emptyRowErrors IN h-lubrific.
            /** Posiciona no Registro que deve ser eliminado **/
            run repositionRecord in h-lubrific (input rowid(mab-item-lubrific)).
            /*--- Cria um novo registro ---*/
            RUN deleteRecord IN h-lubrific.
        end.
    end.
end.
/**************************************************
**                     FICHA                     **
**************************************************/
/*--- Limpa temp-table RowErrors no DBO ---*/
RUN emptyRowErrors IN h-ficha.
/** Posiciona no Registro que deve ser eliminado **/
run repositionRecord in h-ficha (input rowid(mab-abastec-lubrific)).
/*--- Cria um novo registro ---*/
RUN deleteRecord IN h-ficha.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pi-elimina-material) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-material Procedure 
PROCEDURE pi-elimina-material :
/*------------------------------------------------------------------------------
  Purpose:     pi-elimina-material
  Parameters:  <none>
  Notes:       Elimina Movimento de Material
------------------------------------------------------------------------------*/
/*--- Limpa temp-table RowErrors no DBO ---*/
RUN emptyRowErrors IN h-material.
/** Posiciona no Registro que deve ser eliminado **/
run repositionRecord in h-material (input rowid(mmv-movto-mater)).
/*--- Cria um novo registro ---*/
RUN deleteRecord IN h-material.

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
  Notes:       Manutená∆o dos handles
------------------------------------------------------------------------------*/
define input parameter pAction as integer no-undo.

case pAction:
   /** Inicializa **/
    when 1 then do:
        /*:T--- BO de Movimento Material ---*/
        IF NOT VALID-HANDLE(h-material) OR
           h-material:TYPE <> "PROCEDURE":U OR
           h-material:FILE-NAME <> "frbo/bofr076.p":U THEN DO:
            run frbo/bofr076.p persistent set h-material.
        END.
        
        RUN openQueryStatic IN h-material (INPUT "Main":U) NO-ERROR.

        /*:T--- BO de Ficha Abatestecimento ---*/
        IF NOT VALID-HANDLE(h-ficha) OR
           h-ficha:TYPE <> "PROCEDURE":U OR
           h-ficha:FILE-NAME <> "frbo/bofr055.p":U THEN DO:
            run frbo/bofr055.p persistent set h-ficha.
        END.
        
        RUN openQueryStatic IN h-ficha (INPUT "Main":U) NO-ERROR.
        
        /*:T--- BO de Ficha Abatestecimento ---*/
        IF NOT VALID-HANDLE(h-abastec) OR
           h-abastec:TYPE <> "PROCEDURE":U OR
           h-abastec:FILE-NAME <> "frbo/bofr057.p":U THEN DO:
            run frbo/bofr057.p persistent set h-abastec.
        END.
        
        RUN openQueryStatic IN h-abastec (INPUT "Main":U) NO-ERROR.

        /*:T--- BO de Ficha Abatestecimento ---*/
        IF NOT VALID-HANDLE(h-lubrific) OR
           h-lubrific:TYPE <> "PROCEDURE":U OR
           h-lubrific:FILE-NAME <> "frbo/bofr058.p":U THEN DO:
            run frbo/bofr058.p persistent set h-lubrific.
        END.
        
        RUN openQueryStatic IN h-lubrific (INPUT "Main":U) NO-ERROR.

        /** Verifica se Consiste Ficha **/
        for first mab-param
            where mab-param.cdn-param = 11 no-lock:
            /** 1 = On-Line / 2 = Batch **/
            if mab-param.des-valor = "1":U then do:
                run setaExecutaAPI in h-abastec  (input yes).
                run setaExecutaAPI in h-lubrific (input yes).
            end.
            else do:
                run setaExecutaAPI in h-abastec  (input no).
                run setaExecutaAPI in h-lubrific (input no).
            end.
        end.

    end.
    /** Finaliza **/
    when 2 then do:
        if valid-handle(h-material) then
            run Destroy in h-material.
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

&IF DEFINED(EXCLUDE-pi-inclui) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inclui Procedure 
PROCEDURE pi-inclui :
/*------------------------------------------------------------------------------
  Purpose:     pi-inclui
  Parameters:  <none>
  Notes:       Alteraá∆o das Tabelas
------------------------------------------------------------------------------*/
define variable deTanque as decimal no-undo.

for first item-doc-est
    where item-doc-est.serie-docto  = pc-serie
    and   item-doc-est.nro-docto    = pc-nota
    and   item-doc-est.cod-emitente = pi-emitente
    and   item-doc-est.nat-operacao = pc-natureza
    and   item-doc-est.sequencia    = pi-sequencia no-lock:
    case i-tipo:
        /**********************************************
        **             Abastecimento 
        **********************************************/
        when 1 then do:
            /** Cria Ficha Abastec/Lubrific **/
            run pi-cria-ficha in this-procedure.
            if return-value = "OK":U then do:

                /** Limpa Temp-Table **/
                empty temp-table tt-mab-item-abastec.
                /** Cria temp-table de comunicaá∆o **/
                create tt-mab-item-abastec.
                assign tt-mab-item-abastec.num-docto            = tt-mab-abastec-lubrific.num-docto
                       tt-mab-item-abastec.ep-codigo            = tt-mab-abastec-lubrific.ep-codigo
                       tt-mab-item-abastec.cod-eqpto            = tt-mab-abastec-lubrific.cod-eqpto
                       tt-mab-item-abastec.val-dat-hora-invrtda = tt-mab-abastec-lubrific.val-dat-hora-invrtda
                       tt-mab-item-abastec.cod-posto            = c-posto
                       tt-mab-item-abastec.cod-bomba            = "":U
                       tt-mab-item-abastec.it-codigo            = item-doc-est.it-codigo
                       tt-mab-item-abastec.cod-refer            = item-doc-est.cod-refer
                       tt-mab-item-abastec.cod-localiz          = item-doc-est.cod-localiz
                       tt-mab-item-abastec.lote                 = item-doc-est.lote
                       tt-mab-item-abastec.r-rowid              = ?
                       tt-mab-item-abastec.val-mater-1          = item-doc-est.preco-total[1] - item-doc-est.desconto[1]
                       tt-mab-item-abastec.val-quant            = item-doc-est.quantidade.

                FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
                    IF  mab-param.des-valor = "1":U THEN DO:
                        ASSIGN tt-mab-item-abastec.cod-cta-ctbl = item-doc-est.ct-codigo
                               tt-mab-item-abastec.cod-ccusto   = item-doc-est.sc-codigo.
                    END.
                END.


                /** Atualiza data invertida do Apontamento **/
                run converteParaHoraInvertida (input  string(dt-movimento,"99/99/9999"),
                                                input  c-hr-inicial,
                                                output tt-mab-item-abastec.val-dat-hora-invrtda).

                /** Busca Tipo Material e Flag de Abastecimento Prim†rio **/
                run buscaTipoMaterial in h-abastec (input  tt-mab-item-abastec.ep-codigo,
                                                    input  tt-mab-item-abastec.cod-eqpto,
                                                    input  tt-mab-item-abastec.it-codigo,
                                                    input  dt-movimento,
                                                    output tt-mab-item-abastec.cod-tip-mater,
                                                    output tt-mab-item-abastec.log-abastec-prim,
                                                    output deTanque).
                /** Busca Valores para Moedas Alternativas **/
                run piConverteMoeda in this-procedure (input  tt-mab-item-abastec.val-mater-1,
                                                       output tt-mab-item-abastec.val-mater-2,
                                                       output tt-mab-item-abastec.val-mater-3,
                                                       input  tt-mab-abastec-lubrific.dat-movto).        
                /*--- Limpa temp-table RowErrors no DBO ---*/
                RUN emptyRowErrors IN h-abastec.
                /*--- Transfere temp-table ttTarefa para o DBO ---*/
                RUN setRecord IN h-abastec (INPUT TABLE tt-mab-item-abastec).
                /*--- Cria registro ---*/
                
                RUN createRecord IN h-abastec.
                if return-value = "NOK":U then do:
                    run getRowErrors in h-abastec (output table RowErrors).
                    return "NOK":U.
                end.
                ELSE DO:

                    /* inserida mensagem de aviso para Nota Fiscal que a quantidade informada Ç maior que a capacidade do compartimento */
                    IF item-doc-est.quantidade > deTanque THEN DO:
                        run piCriaErro (30075, 'EMS':U, '').
                    END.
                END.
            end.
            else do:
                return "NOK":U.
            end.
        end.
        /**********************************************
        **             Lubrificaá∆o
        **********************************************/
        when 2 then do:
            /** Cria Ficha Abastec/Lubrific **/
            run pi-cria-ficha in this-procedure.
            if return-value = "OK":U then do:
                /** Limpa Temp-Table **/
                empty temp-table tt-mab-item-lubrific.
                /** Cria temp-table de comunicaá∆o **/
                create tt-mab-item-lubrific.
                assign tt-mab-item-lubrific.num-docto            = tt-mab-abastec-lubrific.num-docto
                       tt-mab-item-lubrific.ep-codigo            = tt-mab-abastec-lubrific.ep-codigo
                       tt-mab-item-lubrific.cod-eqpto            = tt-mab-abastec-lubrific.cod-eqpto
                       tt-mab-item-lubrific.val-dat-hora-invrtda = tt-mab-abastec-lubrific.val-dat-hora-invrtda
                       tt-mab-item-lubrific.cod-evento           = c-cod-evento
                       tt-mab-item-lubrific.cod-comptmento       = c-cod-compart
                       tt-mab-item-lubrific.it-codigo            = item-doc-est.it-codigo
                       tt-mab-item-lubrific.cod-refer            = item-doc-est.cod-refer
                       tt-mab-item-lubrific.cod-localiz          = item-doc-est.cod-localiz
                       tt-mab-item-lubrific.lote                 = item-doc-est.lote
                       tt-mab-item-lubrific.val-mater-1          = item-doc-est.preco-total[1] - item-doc-est.desconto[1]
                       tt-mab-item-lubrific.val-quant            = item-doc-est.quantidade
                       tt-mab-item-lubrific.r-rowid              = ?.

                FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
                    IF mab-param.des-valor = "1":U THEN DO:
                        ASSIGN tt-mab-item-lubrific.cod-cta-ctbl          = item-doc-est.ct-codigo
                               tt-mab-item-lubrific.cod-ccusto            = item-doc-est.sc-codigo.
                    END.
                END.

                /** Atualiza data invertida do Apontamento **/
                run converteParaHoraInvertida (input  string(dt-movimento,"99/99/9999"),
                                               input  c-hr-inicial,
                                               output tt-mab-item-lubrific.val-dat-hora-invrtda).
                
                /** Tipo de Manutená∆o Preventiva Padr∆o **/
                for first mab-param fields(des-valor)
                    where mab-param.cdn-param = 27 no-lock:
                    assign tt-mab-item-lubrific.cd-tipo = integer(mab-param.des-valor).
                end.
                /** Grava Tipo de Material **/
                run buscaTipoMaterial in h-lubrific (input  tt-mab-item-lubrific.ep-codigo,
                                                     input  tt-mab-item-lubrific.cod-eqpto,
                                                     input  tt-mab-item-lubrific.cod-comptmento,
                                                     input  tt-mab-item-lubrific.it-codigo,
                                                     output tt-mab-item-lubrific.cod-tip-mater,
                                                     output deTanque).
                /** Busca Valores para Moedas Alternativas **/
                run piConverteMoeda in this-procedure (input  tt-mab-item-lubrific.val-mater-1,
                                                       output tt-mab-item-lubrific.val-mater-2,
                                                       output tt-mab-item-lubrific.val-mater-3,
                                                       input  tt-mab-abastec-lubrific.dat-movto). 
            
                /*--- Limpa temp-table RowErrors no DBO ---*/
                RUN emptyRowErrors IN h-lubrific.
                /*--- Transfere temp-table ttTarefa para o DBO ---*/
                RUN setRecord IN h-lubrific (INPUT TABLE tt-mab-item-lubrific).
                /*--- Cria registro ---*/
                RUN createRecord IN h-lubrific.
                if return-value = "NOK":U then do:
                    run getRowErrors in h-lubrific (output table RowErrors).
                    return "NOK":U.
                end.
                ELSE DO:
                    /* inserida mensagem de aviso para Nota Fiscal que a quantidade informada Ç maior que a capacidade do compartimento */
                    IF item-doc-est.quantidade > deTanque THEN DO:
                        run piCriaErro (30075, 'EMS':U, '').
                    END.
                END.
            end.
            else do:
                return "NOK":U.
            end.
        end.
        /**********************************************
        **         Outros (Pneus / Serviáos)
        **********************************************/
        when 3 then do:
            /** Limpa Temp-Table **/
            empty temp-table tt-mmv-movto-mater.

            for first item fields(ge-codigo)
                where item.it-codigo = item-doc-est.it-codigo no-lock:
            end.
            create tt-mmv-movto-mater.
            assign /** Chave da Nota Fiscal **/
                   tt-mmv-movto-mater.cod-emitente    = pi-emitente
                   tt-mmv-movto-mater.nat-operacao    = pc-natureza
                   tt-mmv-movto-mater.nro-docto       = pc-nota
                   tt-mmv-movto-mater.sequencia       = pi-sequencia
                   tt-mmv-movto-mater.serie-docto     = pc-serie
                   /** Dados de Tela **/
                   tt-mmv-movto-mater.ep-codigo       = i-ep-codigo
                   tt-mmv-movto-mater.cod-eqpto       = c-cod-eqpto
                   tt-mmv-movto-mater.cod-evento      = c-cod-evento
                   tt-mmv-movto-mater.dat-movto       = dt-movimento 
                   /** Dados do item da Nota **/
                   tt-mmv-movto-mater.it-codigo       = item-doc-est.it-codigo
                   tt-mmv-movto-mater.dsl-obs         = item-doc-est.narrativa
                   tt-mmv-movto-mater.qtd-item        = item-doc-est.quantidade
                   tt-mmv-movto-mater.val-mater-1     = item-doc-est.preco-total[1] - item-doc-est.desconto[1]
                   /** Demais Dados **/
                   tt-mmv-movto-mater.ge-codigo       = item.ge-codigo
                   tt-mmv-movto-mater.esp-docto       = 21            /** NFE -  Nota Fiscal Entrada **/
                   tt-mmv-movto-mater.idi-espec-docto = 1             /** 1 = Nota Fiscal / 2 = Requisiá∆o **/
                   tt-mmv-movto-mater.log-saida       = yes           /** Sa°da do Estoque **/
                   /** Dados n∆o atualizados, pois n∆o existe Ordem Manutená∆o associada **/
                   tt-mmv-movto-mater.nr-ord-produ    = 0
                   tt-mmv-movto-mater.nr-trans        = 0
                   tt-mmv-movto-mater.num-seq         = 0
                   tt-mmv-movto-mater.num-seqcial     = 0.
            /** Busca Valores para Moedas Alternativas **/
            run piConverteMoeda in this-procedure (input  tt-mmv-movto-mater.val-mater-1,
                                                   output tt-mmv-movto-mater.val-mater-2,
                                                   output tt-mmv-movto-mater.val-mater-3,
                                                   input  tt-mmv-movto-mater.dat-movto). 
            /*--- Limpa temp-table RowErrors no DBO ---*/
            RUN emptyRowErrors IN h-material.
            /*--- Transfere temp-table ttTarefa para o DBO ---*/
            RUN setRecord IN h-material (INPUT TABLE tt-mmv-movto-mater).
            /*--- Cria registro ---*/
            RUN createRecord IN h-material.
            if return-value = "NOK":U then do:
                run getRowErrors in h-material (output table RowErrors).
                return "NOK":U.
            end.
        end.
    end case.
end.

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
  Notes:       Inicializaá‰a do programa 
------------------------------------------------------------------------------*/
/** Inicia Handles **/
run pi-handle in this-procedure (input 1).

case pi-acao:
    /** Inclus∆o **/
    when 1 then do:
        inclusao:
        do transaction on error undo, leave
                       on stop  undo, leave:
            run pi-inclui in this-procedure.
            /** Se ocorreu erro, desfaz toda a inclus∆o **/
            if return-value = "NOK":U then do:
                undo inclusao, leave inclusao.
            end.
        end.
    end.
    /** Alteraá∆o **/
    when 2 then do:
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
                /** Alteraá∆o **/
                run pi-altera-ficha in this-procedure.
            end.
        end.
        else do:
            if can-find(first mmv-movto-mater
                        where mmv-movto-mater.serie-docto  = pc-serie
                        and   mmv-movto-mater.nro-docto    = pc-nota
                        and   mmv-movto-mater.cod-emitente = pi-emitente
                        and   mmv-movto-mater.nat-operacao = pc-natureza
                        and   mmv-movto-mater.sequencia    = pi-sequencia no-lock) then do:
                for first mmv-movto-mater
                    where mmv-movto-mater.serie-docto  = pc-serie
                    and   mmv-movto-mater.nro-docto    = pc-nota
                    and   mmv-movto-mater.cod-emitente = pi-emitente
                    and   mmv-movto-mater.nat-operacao = pc-natureza
                    and   mmv-movto-mater.sequencia    = pi-sequencia no-lock:
                    /** Alteraá∆o dos Movimentos de Materiais **/
                    run pi-altera-material in this-procedure.
                end.
            end.
        end.
    end.
    /** Eliminaá∆o **/
    when 3 then do:
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
                /** Eliminaá∆o **/
                run pi-elimina-ficha in this-procedure.
            end.
        end.
        else do:
            if can-find(first mmv-movto-mater
                        where mmv-movto-mater.serie-docto  = pc-serie
                        and   mmv-movto-mater.nro-docto    = pc-nota
                        and   mmv-movto-mater.cod-emitente = pi-emitente
                        and   mmv-movto-mater.nat-operacao = pc-natureza
                        and   mmv-movto-mater.sequencia    = pi-sequencia no-lock) then do:
                for first mmv-movto-mater
                    where mmv-movto-mater.serie-docto  = pc-serie
                    and   mmv-movto-mater.nro-docto    = pc-nota
                    and   mmv-movto-mater.cod-emitente = pi-emitente
                    and   mmv-movto-mater.nat-operacao = pc-natureza
                    and   mmv-movto-mater.sequencia    = pi-sequencia no-lock:
                    /** Eliminaá∆o dos Movimentos de Materiais **/
                    run pi-elimina-material in this-procedure.
                end.
            end.
        end.
    end.
end case.

/** Finaliza Handles **/
run pi-handle in this-procedure (input 2).

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

